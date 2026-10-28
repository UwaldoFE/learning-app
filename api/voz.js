// ============================================================
// Función secreta del micrófono: recibe tu audio y lo pasa a texto con OpenAI.
// Usa la misma clave OPENAI_API_KEY de Vercel. El audio no se guarda en ningún lado.
// ============================================================
const SUPA_URL = "https://idkwjntidyqdurosvyqp.supabase.co";
const SUPA_KEY = "sb_publishable_SNqxRaUtg80WT4NdQO0g4Q_DaPThv0i";

const { transcribir } = require("./_transcribir");
const LIMITE_AUDIOS = 60;              // audios por día

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

module.exports = async (req, res) => {
  if (req.method !== "POST") return res.status(405).json({ error: "Usa POST." });
  if (!process.env.OPENAI_API_KEY) return res.status(500).json({ error: "Falta la clave OPENAI_API_KEY en Vercel." });

  // 1) Solo usuarios con sesión y cuenta activa
  const token = req.headers.authorization || "";
  if (!token.startsWith("Bearer ")) return res.status(401).json({ error: "Inicia sesión." });
  const yo = await supa("/auth/v1/user", token);
  if (!yo.ok || !yo.data?.id) return res.status(401).json({ error: "Tu sesión venció. Vuelve a entrar." });
  const perfil = await supa(`/rest/v1/perfiles?id=eq.${yo.data.id}&select=activo`, token);
  if (!perfil.ok || !perfil.data?.[0]?.activo) return res.status(403).json({ error: "Tu cuenta aún no está activa." });

  // 2) Tope diario de audios
  const fecha = fechaColombia();
  const uso = await supa(`/rest/v1/tutor_uso?fecha=eq.${fecha}&select=mensajes,audios`, token);
  if (!uso.ok) return res.status(503).json({ error: "Falta correr db/004_tutor_flotante_y_lecciones.sql en Supabase.", codigo: "falta_sql" });
  const audios = uso.data?.[0]?.audios || 0;
  if (audios >= LIMITE_AUDIOS) return res.status(429).json({ error: `Llegaste al tope de ${LIMITE_AUDIOS} audios de hoy. Puedes seguir escribiendo.` });

  // 3) El audio llega en base64
  const { audio = "", tipo = "audio/webm" } = req.body || {};
  try {
    const texto = await transcribir(audio, tipo);
    await supa(`/rest/v1/tutor_uso?on_conflict=user_id,fecha`, token, {
      method: "POST", headers: { Prefer: "resolution=merge-duplicates" },
      body: JSON.stringify({ fecha, audios: audios + 1 })
    });
    if (!texto) return res.status(422).json({ error: "No entendí el audio. Intenta de nuevo, un poco más cerca del micrófono." });
    return res.status(200).json({ texto });
  } catch (e) {
    if (e.codigo === "vacio") return res.status(400).json({ error: "No se escuchó nada. Mantén el micrófono un poco más." });
    if (e.codigo === "largo") return res.status(413).json({ error: "El audio es muy largo. Habla máximo 1 minuto." });
    const msg = String(e.message || e);
    if (/quota|billing|insufficient/i.test(msg)) return res.status(402).json({ error: "Se acabó el saldo de OpenAI. Recarga en platform.openai.com → Billing." });
    return res.status(502).json({ error: "No se pudo pasar el audio a texto. Intenta de nuevo.", detalle: msg.slice(0, 200) });
  }
};
