// ============================================================
// Pasa un audio a texto con OpenAI (lo usan api/tutor.js y api/voz.js).
// Los archivos que empiezan con "_" en /api no son páginas: Vercel no los publica.
// ============================================================
const MODELOS = [process.env.OPENAI_TRANSCRIBE_MODEL, "gpt-4o-transcribe", "gpt-4o-mini-transcribe", "whisper-1"].filter(Boolean);
const MAX_BYTES = 3 * 1024 * 1024; // ~1 minuto de audio

const extension = (tipo) => /mp4|m4a|aac/.test(tipo) ? "m4a" : /ogg/.test(tipo) ? "ogg" : /wav/.test(tipo) ? "wav" : /mpeg|mp3/.test(tipo) ? "mp3" : "webm";

// pistas: palabras de lo que el estudiante tiene en pantalla, para que entienda mejor
async function transcribir(base64, tipoCompleto = "audio/webm", pistas = "") {
  const buffer = Buffer.from(String(base64 || ""), "base64");
  if (buffer.length < 1000) { const e = new Error("vacio"); e.codigo = "vacio"; throw e; }
  if (buffer.length > MAX_BYTES) { const e = new Error("largo"); e.codigo = "largo"; throw e; }
  const tipo = String(tipoCompleto).split(";")[0] || "audio/webm";
  const prompt = ("The speaker is a Spanish-speaking English learner from Colombia (beginner). He may speak English, Spanish, or mix both. "
    + "Write exactly what he says in the language he uses, keeping his grammar mistakes. "
    + (pistas ? `Words that may appear: ${pistas}` : "")).slice(0, 900);
  let ultimoError = "";
  for (const model of MODELOS) {
    const form = new FormData();
    form.append("file", new Blob([buffer], { type: tipo }), `audio.${extension(tipo)}`);
    form.append("model", model);
    form.append("prompt", prompt);
    const r = await fetch("https://api.openai.com/v1/audio/transcriptions", {
      method: "POST", headers: { Authorization: `Bearer ${process.env.OPENAI_API_KEY}` }, body: form
    });
    const data = await r.json().catch(() => ({}));
    if (r.ok) return String(data.text || "").trim();
    ultimoError = data.error?.message || `HTTP ${r.status}`;
    if (!/model/i.test(ultimoError) || /quota|billing|api key/i.test(ultimoError)) break;
  }
  throw new Error(ultimoError);
}

module.exports = { transcribir };
