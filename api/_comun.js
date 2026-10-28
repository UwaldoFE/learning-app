// ============================================================
// Funciones compartidas por las funciones del servidor (los archivos con "_" no son páginas).
// ============================================================
const SUPA_URL = "https://idkwjntidyqdurosvyqp.supabase.co";
const SUPA_KEY = "sb_publishable_SNqxRaUtg80WT4NdQO0g4Q_DaPThv0i";
const LIMITE_DIARIO = 60; // mensajes a Wako por día (tutor + calificaciones)

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

// Verifica sesión, cuenta activa y tope diario. Devuelve { error } o { token, userId, usados, fecha }
async function verificar(req) {
  const token = req.headers.authorization || "";
  if (!token.startsWith("Bearer ")) return { error: [401, "Inicia sesión."] };
  const yo = await supa("/auth/v1/user", token);
  if (!yo.ok || !yo.data?.id) return { error: [401, "Tu sesión venció. Vuelve a entrar."] };
  const fecha = fechaColombia();
  const [perfil, uso] = await Promise.all([
    supa(`/rest/v1/perfiles?id=eq.${yo.data.id}&select=activo`, token),
    supa(`/rest/v1/tutor_uso?fecha=eq.${fecha}&select=mensajes`, token)
  ]);
  if (!perfil.ok || !perfil.data?.[0]?.activo) return { error: [403, "Tu cuenta aún no está activa."] };
  const usados = uso.data?.[0]?.mensajes || 0;
  if (usados >= LIMITE_DIARIO) return { error: [429, `Llegaste al tope de ${LIMITE_DIARIO} mensajes de hoy. ¡Mañana seguimos!`] };
  return { token, userId: yo.data.id, usados, fecha };
}
async function contarUso({ token, fecha, usados }) {
  await supa(`/rest/v1/tutor_uso?on_conflict=user_id,fecha`, token, {
    method: "POST", headers: { Prefer: "resolution=merge-duplicates" }, body: JSON.stringify({ fecha, mensajes: usados + 1 })
  });
}

const MODELOS = [process.env.OPENAI_MODEL, "gpt-4.1-mini", "gpt-4o-mini", "gpt-5-mini"].filter(Boolean);
async function openaiJSON(mensajes, max = 700) {
  let ultimoError = "";
  for (const model of MODELOS) {
    const r = await fetch("https://api.openai.com/v1/chat/completions", {
      method: "POST",
      headers: { Authorization: `Bearer ${process.env.OPENAI_API_KEY}`, "Content-Type": "application/json" },
      body: JSON.stringify({ model, messages: mensajes, response_format: { type: "json_object" }, max_completion_tokens: max })
    });
    const data = await r.json().catch(() => ({}));
    if (r.ok) return JSON.parse(data.choices?.[0]?.message?.content || "{}");
    ultimoError = data.error?.message || `HTTP ${r.status}`;
    if (!/model/i.test(ultimoError) || /quota|billing|api key/i.test(ultimoError)) break;
  }
  throw new Error(ultimoError);
}
function errorOpenAI(res, e) {
  const msg = String(e.message || e);
  if (/quota|billing|insufficient/i.test(msg)) return res.status(402).json({ error: "Se acabó el saldo de OpenAI. Recarga en platform.openai.com → Billing." });
  if (/api key|invalid_api_key/i.test(msg)) return res.status(500).json({ error: "La clave de OpenAI no es válida. Revisa OPENAI_API_KEY en Vercel." });
  return res.status(502).json({ error: "Wako no pudo responder. Intenta de nuevo.", detalle: msg.slice(0, 200) });
}

module.exports = { supa, verificar, contarUso, openaiJSON, errorOpenAI, fechaColombia };
