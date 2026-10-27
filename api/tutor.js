// ============================================================
// Función secreta del tutor (corre en el servidor de Vercel, no en el celular).
// Guarda la clave de OpenAI en la variable de entorno OPENAI_API_KEY:
// nunca va en el código, en GitHub ni en la app.
// ============================================================

// Datos públicos de Supabase (los mismos de config.js; la seguridad la pone RLS)
const SUPA_URL = "https://idkwjntidyqdurosvyqp.supabase.co";
const SUPA_KEY = "sb_publishable_SNqxRaUtg80WT4NdQO0g4Q_DaPThv0i";

const LIMITE_DIARIO = 60;          // mensajes al tutor por día
const MAX_HISTORIAL = 16;          // últimos mensajes que se envían a la IA
// Si un modelo deja de existir, se prueba el siguiente.
const MODELOS = [process.env.OPENAI_MODEL, "gpt-4.1-mini", "gpt-4o-mini", "gpt-5-mini"].filter(Boolean);

const TEMAS = {
  1: "to be, a/an, professions, weather, adjectives, comparatives and superlatives, parts of the body",
  2: "present simple (-s with he/she/it), do/does, daily routines, plurals, this/that, the, numbers, telling the time",
  3: "would like, can/could, may/might, modal verbs, conjunctions (and, but, so, because), question words (what, where, when, how long, how much, who), whose; informal phone calls, taking a taxi",
  4: "past simple (regular and irregular verbs), days of the week; at the hotel, formal phone calls",
  5: "office and computer words, neither/either/both, this/that/these/those, there is/there are",
  6: "food, some/any, countable and uncountable nouns, too/enough, months, ordinal numbers, adverbs of frequency; making reservations",
  7: "adverbs, prepositions, possessive adjectives and pronouns (my/mine, your/yours); review of book 1"
};

const MODOS = {
  clase: "MODE: CLASS. Teach the topic the student asks for, in Spanish, short and clear, with 2–3 examples from the student's life (use 'Mi vida'). Put the explanation in \"nota\". Then ask ONE short practice question in English in \"mensaje\". On later turns, correct his answers and keep practicing that topic (max 3 questions), then say well done and suggest a next topic.",
  rol: "MODE: ROLE-PLAY. You play a character in the scenario the student chose (stay in character in \"mensaje\"). Speak naturally but very simply. Correct his English outside the character using the correction fields. After about 6 turns, end the scene politely and put a short summary of what he did well and what to practice in \"nota\" (Spanish).",
  libre: "MODE: FREE CONVERSATION. Start with a friendly 'question of the day' about his daily life (work, family, studies, plans). Keep the conversation going with one simple question each turn.",
  flotante: "MODE: STUDY HELPER (floating chat). The student opens you from any screen of his study app; the CURRENT SCREEN is described below. (a) If he asks something in Spanish (about the exercise, a word, a grammar point), answer in Spanish in \"nota\": clear and short, with 1–2 English examples; this is NOT a mistake, so leave \"correccion\" empty and set \"bien\" true. If the exercise is not answered yet, give a hint that guides him to the answer instead of the answer itself; give the answer only if he asks for it directly or already answered. You may explain any topic that appears on his screen, even from another episode. (b) If he writes in English, correct it and keep a friendly simple conversation, like free conversation. \"mensaje\" can be a short follow-up in English (it may be a question to keep him practicing).",
  traducir: "MODE: HOW DO I SAY THIS? The student writes in Spanish (often a message he wants to send). Put the natural English version in \"mensaje\" and the original idea in \"mensaje_es\". In \"explicacion\" explain in Spanish the 1–2 most useful points (word order, a key word). Leave \"correccion\" empty unless he also tried in English. Ask nothing back."
};

const fechaColombia = () => new Date(Date.now() - 5 * 3600e3).toISOString().slice(0, 10);

async function supa(ruta, token, opciones = {}) {
  const r = await fetch(`${SUPA_URL}${ruta}`, {
    ...opciones,
    headers: { apikey: SUPA_KEY, Authorization: token, "Content-Type": "application/json", ...(opciones.headers || {}) }
  });
  const texto = await r.text();
  let data = null;
  try { data = texto ? JSON.parse(texto) : null; } catch { data = texto; }
  return { ok: r.ok, status: r.status, data };
}

const faltaTabla = (r) => !r.ok && /tutor_uso|mi_vida|does not exist|schema cache|PGRST205|42P01/i.test(JSON.stringify(r.data));

function instrucciones({ modo, episodio, escenario, miVida, errores, contexto }) {
  const ep = Math.min(Math.max(Number(episodio) || 3, 1), 7);
  const permitidos = Object.entries(TEMAS).filter(([n]) => Number(n) <= ep).map(([n, t]) => `Ep${n}: ${t}`).join("\n");
  return `You are a warm, patient English tutor for a Spanish-speaking adult from Colombia (beginner, about A1). He studies English by "episodes".
He is preparing Episode ${ep}. Use ONLY grammar and vocabulary from these episodes (simple present, can, would like, etc.). Short sentences. No idioms. No past or future tenses unless his episode includes them.
${permitidos}

${MODOS[modo] || MODOS.libre}
${escenario ? `Scenario chosen: ${escenario}` : ""}
${contexto ? `CURRENT SCREEN (what the student sees right now):\n${contexto}` : ""}

About the student ("Mi vida", written by him; use it for examples and questions):
${miVida || "(empty — ask him simple questions about his life)"}

His frequent mistakes (bring them up naturally when useful):
${errores.length ? errores.map((e) => "- " + e).join("\n") : "- (none recorded yet)"}

CORRECTION RULES:
- If his last message in English has mistakes, put the corrected sentence in "correccion", its Spanish translation in "correccion_es", and in "explicacion" ONE short reason in Spanish (max 2 sentences). Set "bien" to false.
- If it is correct, leave "correccion" empty and set "bien" to true. If he wrote in Spanish (not in translate or helper mode), gently give him the English version as the correction.
- Never correct more than the 2 most important mistakes.
- Always end "mensaje" with ONE simple question so he keeps talking (except in translate mode; in helper mode only when it helps).

Reply ONLY with a JSON object with exactly these keys:
{"bien": true|false, "correccion": "", "correccion_es": "", "explicacion": "", "nota": "", "mensaje": "", "mensaje_es": ""}
- "mensaje": your reply in simple English (1–3 short sentences).
- "mensaje_es": its Spanish translation.
- "nota": extra explanation in Spanish only when needed (class mode or end of role-play), else "".`;
}

async function llamarOpenAI(mensajes) {
  let ultimoError = "";
  for (const model of MODELOS) {
    const r = await fetch("https://api.openai.com/v1/chat/completions", {
      method: "POST",
      headers: { Authorization: `Bearer ${process.env.OPENAI_API_KEY}`, "Content-Type": "application/json" },
      body: JSON.stringify({ model, messages: mensajes, response_format: { type: "json_object" }, max_completion_tokens: 900 })
    });
    const data = await r.json().catch(() => ({}));
    if (r.ok) return JSON.parse(data.choices?.[0]?.message?.content || "{}");
    ultimoError = data.error?.message || `HTTP ${r.status}`;
    // Solo se prueba otro modelo si el problema es el modelo; si es la clave o el saldo, se para aquí.
    if (!/model/i.test(ultimoError) || /quota|billing|api key/i.test(ultimoError)) break;
  }
  throw new Error(ultimoError);
}

module.exports = async (req, res) => {
  if (req.method !== "POST") return res.status(405).json({ error: "Usa POST." });
  if (!process.env.OPENAI_API_KEY) return res.status(500).json({ error: "Falta la clave OPENAI_API_KEY en Vercel.", codigo: "sin_clave" });

  // 1) ¿Quién eres? Solo usuarios con sesión y cuenta activa pueden usar el tutor.
  const token = req.headers.authorization || "";
  if (!token.startsWith("Bearer ")) return res.status(401).json({ error: "Inicia sesión." });
  const yo = await supa("/auth/v1/user", token);
  if (!yo.ok || !yo.data?.id) return res.status(401).json({ error: "Tu sesión venció. Vuelve a entrar." });
  const perfil = await supa(`/rest/v1/perfiles?id=eq.${yo.data.id}&select=activo`, token);
  if (!perfil.ok || !perfil.data?.[0]?.activo) return res.status(403).json({ error: "Tu cuenta aún no está activa." });

  // 2) Tope diario
  const fecha = fechaColombia();
  const uso = await supa(`/rest/v1/tutor_uso?fecha=eq.${fecha}&select=mensajes`, token);
  if (faltaTabla(uso)) return res.status(503).json({ error: "Falta correr db/003_tutor.sql en Supabase.", codigo: "falta_sql" });
  const usados = uso.data?.[0]?.mensajes || 0;
  if (usados >= LIMITE_DIARIO) return res.status(429).json({ error: `Llegaste al tope de ${LIMITE_DIARIO} mensajes de hoy. ¡Mañana seguimos!`, usados, limite: LIMITE_DIARIO });

  // 3) Contexto: tu ficha "Mi vida" y tus errores pendientes
  const { modo = "libre", episodio = 3, escenario = "" } = req.body || {};
  const contexto = String(req.body?.contexto || "").slice(0, 1200);
  const [vida, err] = await Promise.all([
    supa(`/rest/v1/mi_vida?select=texto`, token),
    supa(`/rest/v1/mis_errores?resuelto=eq.false&select=ejercicios(datos)&order=fallos.desc&limit=8`, token)
  ]);
  const miVida = String(vida.data?.[0]?.texto || "").slice(0, 1500);
  const errores = (Array.isArray(err.data) ? err.data : [])
    .map((r) => r.ejercicios?.datos?.explicacion).filter(Boolean).map((t) => String(t).slice(0, 160));

  // 4) Conversación (limpia y corta)
  const historial = (Array.isArray(req.body?.mensajes) ? req.body.mensajes : [])
    .filter((m) => (m.role === "user" || m.role === "assistant") && typeof m.content === "string")
    .slice(-MAX_HISTORIAL)
    .map((m) => ({ role: m.role, content: m.content.slice(0, 1200) }));
  if (!historial.length) historial.push({ role: "user", content: "(Start the session now.)" });

  try {
    const r = await llamarOpenAI([{ role: "system", content: instrucciones({ modo, episodio, escenario, miVida, errores, contexto }) }, ...historial]);
    const limpio = {};
    for (const k of ["correccion", "correccion_es", "explicacion", "nota", "mensaje", "mensaje_es"]) limpio[k] = String(r[k] ?? "").trim();
    limpio.bien = r.bien !== false && !limpio.correccion;
    await supa(`/rest/v1/tutor_uso?on_conflict=user_id,fecha`, token, {
      method: "POST", headers: { Prefer: "resolution=merge-duplicates" },
      body: JSON.stringify({ fecha, mensajes: usados + 1 })
    });
    return res.status(200).json({ respuesta: limpio, usados: usados + 1, limite: LIMITE_DIARIO });
  } catch (e) {
    const msg = String(e.message || e);
    if (/quota|billing|insufficient/i.test(msg)) return res.status(402).json({ error: "Se acabó el saldo de OpenAI. Recarga en platform.openai.com → Billing.", codigo: "sin_saldo" });
    if (/api key|Incorrect API key|invalid_api_key/i.test(msg)) return res.status(500).json({ error: "La clave de OpenAI no es válida. Revisa OPENAI_API_KEY en Vercel.", codigo: "clave_mala" });
    return res.status(502).json({ error: "El tutor no pudo responder. Intenta de nuevo.", detalle: msg.slice(0, 200) });
  }
};
