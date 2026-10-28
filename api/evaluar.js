// ============================================================
// Wako califica una respuesta abierta ("Escríbelo libre") o un Workshop del examen "Now I Can".
// Recibe: { tarea, tarea_es, criterio, ejemplo, respuesta, episodio, tema, rubrica? }
// Devuelve: { puntaje (0–100), correccion, correccion_es, comentario, bien: [..], mejorar: [..], criterios? }
// ============================================================
const { verificar, contarUso, openaiJSON, errorOpenAI } = require("./_comun");

const NIVEL = {
  1: "Episode 1: to be, a/an, professions, weather, adjectives, comparatives/superlatives, body, he/his she/her",
  2: "Episode 2: present simple (-s with he/she/it), do/does, daily routines, plurals, this/that/these/those, the, numbers, telling the time",
  3: "Episode 3: would like, can/could, may/might, conjunctions (and, but, so, because, or), question words, whose"
};

module.exports = async (req, res) => {
  if (req.method !== "POST") return res.status(405).json({ error: "Usa POST." });
  if (!process.env.OPENAI_API_KEY) return res.status(500).json({ error: "Falta la clave OPENAI_API_KEY en Vercel." });
  const v = await verificar(req);
  if (v.error) return res.status(v.error[0]).json({ error: v.error[1] });

  const b = req.body || {};
  const respuesta = String(b.respuesta || "").slice(0, 1500).trim();
  if (respuesta.split(/\s+/).length < 2) return res.status(400).json({ error: "Escribe una respuesta más completa." });
  const ep = Math.min(Math.max(Number(b.episodio) || 3, 1), 19);
  const permitidos = Object.entries(NIVEL).filter(([n]) => Number(n) <= ep).map(([, t]) => t).join("\n");
  const rubrica = Array.isArray(b.rubrica) && b.rubrica.length ? b.rubrica.slice(0, 6).map(String) : null;

  const sistema = `You are Wako, a friendly robot English tutor grading a Spanish-speaking beginner (A1) from Colombia.
Grade ONLY with the grammar and vocabulary the student has studied:
${permitidos}

TASK given to the student: ${String(b.tarea || "").slice(0, 400)} (${String(b.tarea_es || "").slice(0, 300)})
WHAT TO CHECK: ${String(b.criterio || "").slice(0, 400)}
MODEL ANSWER (only a reference; other answers are fine): ${String(b.ejemplo || "").slice(0, 300)}
${rubrica ? `RUBRIC (score each 0–100): ${rubrica.map((r, i) => `${i + 1}) ${r}`).join(" ")}` : ""}

Scoring (0–100), be fair and encouraging:
- 90–100: answers the task, uses the target grammar correctly, small or no mistakes.
- 70–89: answers the task and is understandable; a few mistakes, but the target grammar is mostly right.
- 40–69: partly answers or important mistakes with the target grammar.
- 0–39: does not answer the task, mostly Spanish, or not understandable.
Spelling mistakes count little. Do not penalize for being short if the task is fulfilled.

Reply ONLY with JSON:
{"puntaje": 0-100, "correccion": "the student's answer corrected (natural, keep his ideas; empty if perfect)", "correccion_es": "Spanish translation of the correction",
 "comentario": "1–2 short sentences in Spanish: what was good and the most important thing to improve", "bien": ["short Spanish points done well"], "mejorar": ["short Spanish points to improve"]${rubrica ? `, "criterios": [scores per rubric item]` : ""}}`;
  try {
    const r = await openaiJSON([{ role: "system", content: sistema }, { role: "user", content: respuesta }], 600);
    await contarUso(v);
    const puntaje = Math.max(0, Math.min(100, Math.round(Number(r.puntaje) || 0)));
    return res.status(200).json({
      puntaje,
      correccion: String(r.correccion || "").trim(), correccion_es: String(r.correccion_es || "").trim(),
      comentario: String(r.comentario || "").trim(),
      bien: Array.isArray(r.bien) ? r.bien.slice(0, 3).map(String) : [],
      mejorar: Array.isArray(r.mejorar) ? r.mejorar.slice(0, 3).map(String) : [],
      criterios: Array.isArray(r.criterios) ? r.criterios.slice(0, 6).map((x) => Math.max(0, Math.min(100, Math.round(Number(x) || 0)))) : undefined
    });
  } catch (e) { return errorOpenAI(res, e); }
};
