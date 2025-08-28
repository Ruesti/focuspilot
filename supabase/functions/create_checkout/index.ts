import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import Stripe from "https://esm.sh/stripe@12.3.0";
const stripe = new Stripe(Deno.env.get("STRIPE_SECRET_KEY"), {
  apiVersion: "2022-11-15"
});
// GPT-Abo-Stufen (Plan-Namen = Flutter-Werte)
const PRICE_IDS = {
  ideenschmiede: "",
  ideenprofi: "price_1RpDSgCzJwTSJEeeN5gIWIQ7",
  werkstatt: "price_1RqeZ5CzJwTSJEeesC3UoyTU",
  manufaktur: "price_1RpDTWCzJwTSJEeejcDBjaiM",
  all_in: "price_1RqeZZCzJwTSJEeesFj09y2D",
  Storage_1gb: "price_1RpDY6CzJwTSJEee3fTHlo38",
  Storage_10gb: "price_1RpDYaCzJwTSJEeeiJIvj4v1"
};
serve(async (req)=>{
  try {
    const { plan, storage } = await req.json();
    console.log("RECEIVED:", {
      plan,
      storage
    });
    // Free-Plan darf keinen Checkout auslösen
    if (!plan || !(plan in PRICE_IDS) || plan === "ideenschmiede") {
      throw new Error(`Ungültiger oder kostenloser Plan: ${plan}`);
    }
    const prices = [];
    // Pflicht: Plan-Preis
    const planPrice = PRICE_IDS[plan];
    if (!planPrice) throw new Error(`price_id fehlt für Plan: ${plan}`);
    prices.push(planPrice);
    // Optional: Speicher
    if (storage && storage !== "none") {
      const storageKey = `Storage_${storage}`;
      const storagePrice = PRICE_IDS[storageKey];
      if (!storagePrice) throw new Error(`Fehlende storage price_id für: ${storageKey}`);
      prices.push(storagePrice);
    }
    console.log("CHECKOUT START:", prices);
    const successUrl = Deno.env.get("STRIPE_SUCCESS_URL") ?? "https://focuspilot.de/checkout-success";
    const cancelUrl = Deno.env.get("STRIPE_CANCEL_URL") ?? "https://focuspilot.de/checkout-cancel";
    const session = await stripe.checkout.sessions.create({
      mode: "subscription",
      line_items: prices.map((price)=>({
          price,
          quantity: 1
        })),
      success_url: successUrl,
      cancel_url: cancelUrl
    });
    return new Response(JSON.stringify({
      url: session.url
    }), {
      headers: {
        "Content-Type": "application/json"
      }
    });
  } catch (e) {
    const msg = e instanceof Error ? e.message : String(e);
    console.error("CHECKOUT ERROR:", msg);
    return new Response(JSON.stringify({
      error: msg
    }), {
      status: 400,
      headers: {
        "Content-Type": "application/json"
      }
    });
  }
});
