// supabase/functions/stripe_webhook/index.ts
import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import Stripe from "https://esm.sh/stripe@12.3.0";
const stripe = new Stripe(Deno.env.get("STRIPE_SECRET_KEY"), {
  apiVersion: "2022-11-15"
});
serve(async (req)=>{
  const sig = req.headers.get("stripe-signature");
  const endpointSecret = Deno.env.get("STRIPE_WEBHOOK_SECRET");
  let event;
  try {
    const body = await req.text();
    event = stripe.webhooks.constructEvent(body, sig, endpointSecret);
  } catch (err) {
    console.error("Webhook Error:", err.message);
    return new Response(`Webhook Error: ${err.message}`, {
      status: 400
    });
  }
  // Supabase Admin-Client
  const supabaseUrl = Deno.env.get("SUPABASE_URL");
  const serviceRole = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");
  const { createClient } = await import("https://esm.sh/@supabase/supabase-js@2");
  const supabase = createClient(supabaseUrl, serviceRole);
  try {
    switch(event.type){
      case "checkout.session.completed":
        {
          const session = event.data.object;
          // Wir speichern alles aus metadata
          const userId = session.metadata?.user_id ?? null;
          const plan = session.metadata?.plan ?? "free";
          const storage = session.metadata?.storage ?? null;
          // Optional: Stripe Customer in Profile mappen (hilft für spätere Events)
          const customerId = typeof session.customer === "string" ? session.customer : session.customer?.id ?? null;
          if (userId && customerId) {
            await supabase.from("profiles").update({
              stripe_customer_id: customerId
            }).eq("id", userId);
          }
          if (userId) {
            const { error } = await supabase.from("profiles").update({
              subscription_plan: plan,
              subscription_status: "active",
              storage_option: storage
            }).eq("id", userId);
            if (error) {
              console.error("DB update error:", error);
              return new Response("DB error", {
                status: 500
              });
            }
          }
          break;
        }
      case "customer.subscription.deleted":
      case "customer.subscription.updated":
        {
          // ⚠️ Achtung: Diese Events enthalten i.d.R. KEIN user_id in metadata,
          // außer du schreibst metadata direkt auf das Subscription-Objekt.
          // Besser: über stripe_customer_id -> profiles verknüpfen.
          const subscription = event.data.object;
          const customerId = typeof subscription.customer === "string" ? subscription.customer : subscription.customer?.id ?? null;
          if (customerId) {
            // Hole zugehörigen User via gespeicherter stripe_customer_id
            const { data: prof, error: selErr } = await supabase.from("profiles").select("id").eq("stripe_customer_id", customerId).single();
            if (!selErr && prof?.id) {
              const isActive = subscription.status === "active" || subscription.status === "trialing" || subscription.status === "past_due"; // je nach Policy
              await supabase.from("profiles").update({
                subscription_status: isActive ? "active" : "inactive"
              }).eq("id", prof.id);
            }
          }
          break;
        }
      default:
        break;
    }
    return new Response("ok", {
      status: 200
    });
  } catch (err) {
    console.error("Handler error:", err.message);
    return new Response("internal error", {
      status: 500
    });
  }
});
