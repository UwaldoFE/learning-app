// ============================================================
// Significado de una palabra que NO está en el diccionario propio (diccionario.js).
// 1) Busca en la tabla "diccionario" (lo que Wako ya respondió antes: gratis).
// 2) Si no está, le pregunta a OpenAI y lo guarda para la próxima vez.
// ============================================================
const { supa, fechaColombia, openaiJSON } = require("./_comun");
const LIMITE_PALABRAS = 150; // búsquedas nuevas con Wako por día

module.exports = async (req, res) => {
  if (req.method !== "POST") return res.status(405).json({ error: "Usa POST." });
  const token = req.headers.authorization || "";
  if (!token.startsWith("Bearer ")) return res.status(401).json({ error: "Inicia sesión." });

  const palabra = String(req.body?.palabra || "").toLowerCase().replace(/[’`´]/g, "'").replace(/[^a-z'-]/g, "").slice(0, 40);
  const frase = String(req.body?.frase || "").slice(0, 200);
  if (!palabra) return res.status(400).json({ error: "Falta la palabra." });

  // 1) ¿Ya la buscó alguien?
  const guardada = await supa(`/rest/v1/diccionario?palabra=eq.${encodeURIComponent(palabra)}&select=es,nota`, token);
  if (guardada.status === 401) return res.status(401).json({ error: "Tu sesión venció. Vuelve a entrar." });
  if (guardada.ok && guardada.data?.[0]) return res.status(200).json({ ...guardada.data[0], fuente: "guardada" });
  if (!guardada.ok) return res.status(503).json({ error: "Falta correr db/010_palabras.sql en Supabase.", codigo: "falta_sql" });

  if (!process.env.OPENAI_API_KEY) return res.status(500).json({ error: "Falta la clave OPENAI_API_KEY en Vercel." });

  // 2) Tope diario
  const fecha = fechaColombia();
  const uso = await supa(`/rest/v1/tutor_uso?fecha=eq.${fecha}&select=palabras`, token);
  if (!uso.ok) return res.status(503).json({ error: "Falta correr db/010_palabras.sql en Supabase.", codigo: "falta_sql" });
  const usadas = uso.data?.[0]?.palabras || 0;
  if (usadas >= LIMITE_PALABRAS) return res.status(429).json({ error: "Llegaste al tope de palabras nuevas de hoy." });

  try {
    const r = await openaiJSON([
      { role: "system", content: `You are a bilingual English→Spanish dictionary for a Colombian beginner (A1–A2).
Return JSON: {"es": "1 to 3 common Spanish meanings separated by ' / ' (the meaning used in the sentence first)", "nota": "very short note in Spanish (max 12 words) only if useful: base form of a conjugated verb (e.g. 'pasado de go'), plural, a name, a misspelling, or a phrasal verb; else empty"}.
If it is a person's or place's name, es = "nombre propio". If it is not a real English word, es = "no es una palabra en inglés" and nota = the correct spelling if obvious. Spanish words: es = "(palabra en español)".` },
      { role: "user", content: `Word: ${palabra}\nSentence: ${frase || "(none)"}` }
    ], 120);
    const es = String(r.es || "").slice(0, 120).trim();
    const nota = String(r.nota || "").slice(0, 120).trim();
    if (!es) throw new Error("respuesta vacía");
    await Promise.all([
      supa(`/rest/v1/diccionario?on_conflict=palabra`, token, { method: "POST", headers: { Prefer: "resolution=ignore-duplicates" }, body: JSON.stringify({ palabra, es, nota }) }),
      supa(`/rest/v1/tutor_uso?on_conflict=user_id,fecha`, token, { method: "POST", headers: { Prefer: "resolution=merge-duplicates" }, body: JSON.stringify({ fecha, palabras: usadas + 1 }) })
    ]);
    return res.status(200).json({ es, nota, fuente: "wako" });
  } catch (e) {
    const msg = String(e.message || e);
    if (/quota|billing|insufficient/i.test(msg)) return res.status(402).json({ error: "Se acabó el saldo de OpenAI." });
    return res.status(502).json({ error: "Wako no encontró el significado. Intenta de nuevo." });
  }
};
