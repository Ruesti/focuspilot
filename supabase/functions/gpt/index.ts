import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";
serve(async (req)=>{
  const supabase = createClient(Deno.env.get("SUPABASE_URL"), Deno.env.get("SUPABASE_ANON_KEY"), {
    global: {
      headers: {
        Authorization: req.headers.get("Authorization")
      }
    }
  });
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) {
    return new Response(JSON.stringify({
      error: "Nicht eingeloggt"
    }), {
      status: 401
    });
  }
  const userId = user.id;
  const { prompt } = await req.json();
  const now = new Date();
  const startOfMonth = new Date(now.getFullYear(), now.getMonth(), 1).toISOString();
  const { count } = await supabase.from("gpt_usage").select("*", {
    count: "exact",
    head: true
  }).eq("user_id", userId).gte("created_at", startOfMonth);
  if ((count ?? 0) >= 20) {
    return new Response(JSON.stringify({
      error: "Free tier limit reached"
    }), {
      status: 403
    });
  }
  const response = await fetch("https://api.openai.com/v1/chat/completions", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      "Authorization": `Bearer ${Deno.env.get("OPENAI_API_KEY")}`
    },
    body: JSON.stringify({
      model: "gpt-3.5-turbo",
      messages: [
        {
          role: "system",
          content: "Du bist ein ruhiger, freundlicher Co-Pilot für kreative Menschen."
        },
        {
          role: "user",
          content: prompt
        }
      ]
    })
  });
  const data = await response.json();
  console.log("🧠 OpenAI-Antwort:", JSON.stringify(data, null, 2));
  // Prüfen ob `choices` überhaupt existieren
  if (!data.choices || !data.choices[0]?.message?.content) {
    return new Response(JSON.stringify({
      error: "OpenAI-Antwort leer oder fehlerhaft",
      openai_response: data
    }), {
      status: 500,
      headers: {
        "Content-Type": "application/json"
      }
    });
  }
  const reply = data.choices[0].message.content;
  // GPT-Nutzung speichern
  await supabase.from("gpt_usage").insert({
    user_id: userId,
    prompt,
    response_tokens: data.usage?.total_tokens ?? 0
  });
  // Antwort zurückgeben
  return new Response(JSON.stringify({
    reply
  }), {
    headers: {
      "Content-Type": "application/json"
    }
  });
});
