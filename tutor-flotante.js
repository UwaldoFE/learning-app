// ============================================================
// 💬 Tutor flotante: botón en todas las pantallas
// - Sabe en qué pantalla estás (lección, ejercicio, lectura, tarjeta…)
// - Recuerda la conversación (en este dispositivo y en tu cuenta)
// - Micrófono: hablas y /api/voz lo pasa a texto; la respuesta se lee en voz alta
// Usa funciones de app.js, lecciones.js y tutor.js (db, esc, hablar, htmlRespuesta, sumarXP, episodioActual, XP_TUTOR).
// ============================================================
const TF_MAX_GUARDADOS = 40;   // mensajes que se recuerdan
const TF_MAX_ENVIADOS = 16;    // mensajes que se envían a la IA en cada turno
const TF_MAX_SEGUNDOS = 60;    // duración máxima de un audio

const TF = {
  abierto: false, cargado: false, enviando: false, episodio: null, userId: null,
  mensajes: [], contexto: { pantalla: "Inicio", detalle: "" },
  grabando: null, segundos: 0, reloj: null
};

// ---------- contexto de la pantalla (lo llaman el router, las lecciones, las lecturas y el repaso) ----------
function ponerContexto(pantalla, detalle = "") {
  TF.contexto = { pantalla, detalle };
  const c = document.getElementById("tf-ctx");
  if (c) c.textContent = "📍 " + pantalla;
}
const etiquetaTipo = { elegir: "Elegir la opción correcta", escuchar: "Escuchar y elegir", ordenar: "Ordenar las palabras",
  escribir: "Escribir en inglés", emparejar: "Unir parejas", comprension: "Escuchar o leer y responder",
  decir: "Decirlo en voz alta", libre: "Respuesta abierta calificada por Wako", rapido: "Ronda rápida contra reloj" };
// Describe un ejercicio para el tutor. resultado = null (aún no responde) o { ok, tuya }
function describirEjercicio(ej, resultado = null) {
  const d = ej.datos || {}, l = [`Tipo de ejercicio: ${etiquetaTipo[ej.tipo] || ej.tipo}`];
  const ops = (d.opciones || []).map((o, i) => `${"abcd"[i]}) ${o}`).join("  ");
  if (ej.tipo === "elegir") l.push(`Frase: ${d.frase}${d.pista ? " " + d.pista : ""}`, `Traducción: ${d.es || ""}`, `Opciones: ${ops}`, `Respuesta correcta: ${d.opciones?.[d.correcta]}`);
  if (ej.tipo === "escuchar") l.push(`Audio que escucha: ${d.audio}`, `Opciones: ${ops}`, `Respuesta correcta: ${d.opciones?.[d.correcta]}`);
  if (ej.tipo === "ordenar") l.push(`Debe armar en inglés: ${d.es}`, `Respuesta correcta: ${String(d.frase).replace(/ ([?.!,])/g, "$1")}`);
  if (ej.tipo === "escribir") l.push(`Debe escribir en inglés: ${d.es}`, `Respuesta correcta: ${d.mostrar}`);
  if (ej.tipo === "emparejar") l.push(`Parejas: ${(d.pares || []).map((p) => p.join(" = ")).join(" · ")}`);
  if (ej.tipo === "comprension") l.push(`Texto (${d.modo === "escuchar" ? "lo escucha, no lo ve" : "lo lee"}): ${(d.lineas || []).map((x) => x.en).join(" ")}`, `Pregunta: ${d.pregunta}`, `Opciones: ${ops}`, `Respuesta correcta: ${d.opciones?.[d.correcta]}`);
  if (ej.tipo === "decir") l.push(`Debe DECIR en voz alta en inglés: ${d.es}`, `Respuesta modelo: ${d.mostrar}`);
  if (ej.tipo === "libre") l.push(`Tarea abierta: ${d.pregunta} (${d.pregunta_es})`, `Criterio: ${d.criterio}`, `Ejemplo: ${d.ejemplo}`);
  if (ej.tipo === "rapido") l.push(`Ronda rápida contra reloj: ${d.frase}`, `Opciones: ${ops}`, `Respuesta correcta: ${d.opciones?.[d.correcta]}`);
  if (d.explicacion) l.push(`Explicación de la app: ${d.explicacion}`);
  l.push(resultado ? `Estado: ya respondió (${resultado.ok ? "bien" : "mal"}). Su respuesta: ${resultado.tuya || "—"}`
    : "Estado: AÚN NO RESPONDE (dale pistas, no la respuesta, salvo que la pida).");
  return l.join("\n");
}

// ---------- mostrar u ocultar el botón según la pantalla ----------
function tfVisible(si) {
  document.getElementById("tf-btn").hidden = !si;
  if (!si) tfCerrar();
}

// ---------- memoria ----------
const tfClave = () => `tutor-flotante-${TF.userId || "anon"}`;
async function tfCargar() {
  const user = await usuarioActual();
  if (TF.cargado && TF.userId === user?.id) return;
  TF.userId = user?.id || null;
  let local = { mensajes: [], actualizado: "" };
  try { local = JSON.parse(localStorage.getItem(tfClave())) || local; } catch {}
  TF.mensajes = local.mensajes || [];
  try {
    const { data, error } = await db.from("tutor_chat").select("mensajes, actualizado").maybeSingle();
    if (!error && data && data.actualizado > (local.actualizado || "")) TF.mensajes = data.mensajes || [];
  } catch { /* sin tabla o sin internet: se usa lo del dispositivo */ }
  TF.cargado = true;
}
async function tfGuardar() {
  TF.mensajes = TF.mensajes.filter((x) => !x.provisional).slice(-TF_MAX_GUARDADOS);
  const actualizado = new Date().toISOString();
  try { localStorage.setItem(tfClave(), JSON.stringify({ mensajes: TF.mensajes, actualizado })); } catch {}
  try { if (TF.userId) await db.from("tutor_chat").upsert({ user_id: TF.userId, mensajes: TF.mensajes, actualizado }); } catch {}
}

// ---------- abrir / cerrar ----------
async function tfAbrir() {
  TF.abierto = true;
  document.getElementById("tf-panel").hidden = false;
  document.getElementById("tf-btn").classList.add("abierto");
  document.body.classList.add("tf-abierto");
  tfPintar();
  await tfCargar();
  if (TF.episodio == null) { try { TF.episodio = await episodioActual(); } catch { TF.episodio = 3; } }
  tfPintar();
  if (matchMedia("(min-width: 700px)").matches) document.getElementById("tf-in").focus();
}
function tfCerrar() {
  TF.abierto = false;
  const p = document.getElementById("tf-panel");
  if (p) p.hidden = true;
  document.getElementById("tf-btn")?.classList.remove("abierto");
  document.body.classList.remove("tf-abierto");
  if (TF.grabando) { TF.grabando.cancelar = true; TF.grabando.stop(); }
  tfSoltarMic();
}

// ---------- pintar la conversación ----------
function tfPintar() {
  const body = document.getElementById("tf-body");
  const burbujas = TF.mensajes.map((x) => x.role === "user"
    ? `<div class="t-yo">${x.voz ? "🎤 " : ""}${esc(x.content)}</div>`
    : `<div class="t-ia">${x.bien && x.tras && !x.r?.nota ? `<div class="t-ok">✅ ¡Bien dicho!</div>` : ""}${htmlRespuesta(x.r || {})}</div>`).join("");
  body.innerHTML = burbujas || `
    <div class="tf-vacio">
      <div class="tf-hola">👋</div>
      <b>¡Hola! Soy tu tutor.</b>
      <p class="muted">Pregúntame en español sobre lo que tienes en pantalla, o háblame en inglés y te corrijo.
        Toca 🎤 para hablarme en voz.</p>
    </div>`;
  if (TF.enviando) body.insertAdjacentHTML("beforeend", `<div class="t-ia tf-pensando"><span></span><span></span><span></span></div>`);
  body.scrollTop = body.scrollHeight;
  const mic = document.getElementById("tf-mic");
  mic.classList.toggle("grabando", !!TF.grabando);
  mic.innerHTML = TF.grabando ? (TF.grabando.parando ? "⏳" : `⏹ ${TF.segundos}s`) : "🎤";
  mic.title = TF.grabando ? "Toca para enviar" : "Hablar";
  document.getElementById("tf-env").disabled = TF.enviando;
  mic.disabled = TF.enviando && !TF.grabando;
  document.getElementById("tf-ctx").textContent = "📍 " + TF.contexto.pantalla;
  document.getElementById("tf-in").placeholder = TF.grabando ? "🎙 Te escucho… toca ⏹" : "Write or ask…  (escribe o pregunta)";
}
const tfError = (m) => { const e = document.getElementById("tf-err"); if (e) e.textContent = m || ""; };

// ---------- enviar un mensaje al tutor ----------
async function tfEnviar(texto, { voz = false } = {}) {
  texto = String(texto || "").trim();
  if (!texto || TF.enviando) return;
  tfError("");
  TF.mensajes.push({ role: "user", content: texto, voz });
  TF.enviando = true; tfPintar();
  try {
    const { data } = await db.auth.getSession();
    const c = TF.contexto;
    const r = await fetch("/api/tutor", {
      method: "POST",
      headers: { "Content-Type": "application/json", Authorization: `Bearer ${data.session?.access_token || ""}` },
      body: JSON.stringify({
        modo: "flotante", episodio: TF.episodio || 3,
        contexto: `Pantalla: ${c.pantalla}${c.detalle ? "\n" + c.detalle : ""}`,
        mensajes: TF.mensajes.slice(-TF_MAX_ENVIADOS).map((x) => ({ role: x.role, content: x.role === "user" ? x.content : JSON.stringify(x.r) }))
      })
    });
    const j = await r.json().catch(() => ({}));
    if (!r.ok) {
      TF.mensajes.pop();
      if (!voz) document.getElementById("tf-in").value = texto;
      tfError(j.codigo === "falta_sql" ? "Falta correr un archivo SQL en Supabase (mira las instrucciones)." : (j.error || "El tutor no pudo responder. Intenta de nuevo."));
      return;
    }
    TF.mensajes.push({ role: "assistant", r: j.respuesta, bien: j.respuesta.bien, tras: true });
    await tfGuardar();
    if (voz && j.respuesta.mensaje) { try { hablar(j.respuesta.mensaje); } catch {} }
    try { await sumarXP(XP_TUTOR); } catch {}
  } catch (e) {
    TF.mensajes.pop();
    tfError("Sin conexión con el tutor. Revisa tu internet.");
  } finally {
    TF.enviando = false; tfPintar();
  }
}

// ---------- micrófono ----------
// El micrófono queda "despierto" mientras el chat está abierto (así la siguiente grabación empieza al instante)
// y se apaga solo al cerrar el chat o tras 45 s sin usarlo.
const tfPuedeGrabar = () => !!(navigator.mediaDevices?.getUserMedia && window.MediaRecorder);
const TF_MIC_DESPIERTO_MS = 45000;
const TF_COLA_MS = 350; // al tocar ⏹ se graba un instante más para no cortar la última palabra
function tfSoltarMic() {
  clearTimeout(TF.dormir);
  try { TF.stream?.getTracks().forEach((t) => t.stop()); } catch {}
  try { TF.audioCtx?.close(); } catch {}
  TF.stream = null; TF.audioCtx = null; TF.analizador = null;
}
async function tfStream() {
  clearTimeout(TF.dormir);
  if (TF.stream && TF.stream.getTracks().some((t) => t.readyState === "live")) return TF.stream;
  TF.stream = await navigator.mediaDevices.getUserMedia({ audio: { echoCancellation: true, noiseSuppression: true, autoGainControl: true } });
  try { // medidor de volumen: el botón se mueve con tu voz
    TF.audioCtx = new (window.AudioContext || window.webkitAudioContext)();
    TF.analizador = TF.audioCtx.createAnalyser();
    TF.analizador.fftSize = 256;
    TF.audioCtx.createMediaStreamSource(TF.stream).connect(TF.analizador);
  } catch { TF.analizador = null; }
  return TF.stream;
}
function tfMedirVoz() {
  const mic = document.getElementById("tf-mic");
  if (!TF.grabando || !TF.analizador) { mic.style.removeProperty("--voz"); return; }
  const d = new Uint8Array(TF.analizador.fftSize);
  TF.analizador.getByteTimeDomainData(d);
  let suma = 0; for (const v of d) suma += ((v - 128) / 128) ** 2;
  const nivel = Math.min(1, Math.sqrt(suma / d.length) * 6);
  if (nivel > 0.15) TF.oido = true;
  mic.style.setProperty("--voz", nivel.toFixed(2));
  requestAnimationFrame(tfMedirVoz);
}
async function tfMic() {
  if (TF.grabando) { // segundo toque: terminar (con un instante de cola)
    const rec = TF.grabando;
    if (rec.parando) return;
    rec.parando = true;
    document.getElementById("tf-mic").innerHTML = "⏳";
    return setTimeout(() => rec.state !== "inactive" && rec.stop(), TF_COLA_MS);
  }
  if (!tfPuedeGrabar()) return tfError("Este navegador no deja usar el micrófono. Prueba con Chrome o Safari actualizado.");
  tfError("");
  try { speechSynthesis.cancel(); } catch {}
  const mic = document.getElementById("tf-mic");
  mic.innerHTML = "…";
  let stream;
  try { stream = await tfStream(); }
  catch { tfPintar(); return tfError("No tengo permiso para el micrófono. Actívalo en el candado 🔒 de la barra de direcciones."); }
  const tipo = ["audio/webm;codecs=opus", "audio/webm", "audio/mp4", "audio/ogg"].find((t) => MediaRecorder.isTypeSupported?.(t)) || "";
  const rec = new MediaRecorder(stream, tipo ? { mimeType: tipo, audioBitsPerSecond: 32000 } : undefined);
  const trozos = [];
  rec.ondataavailable = (e) => { if (e.data?.size) trozos.push(e.data); };
  rec.onstop = async () => {
    clearInterval(TF.reloj);
    const cancelado = rec.cancelar, oido = TF.oido;
    TF.grabando = null;
    TF.dormir = setTimeout(tfSoltarMic, TF_MIC_DESPIERTO_MS);
    if (TF.abierto) tfPintar();
    if (cancelado) return;
    const blob = new Blob(trozos, { type: rec.mimeType || tipo || "audio/webm" });
    if (blob.size < 1000 || !oido) return tfError("No te escuché. Toca 🎤, espera la vibración, habla y vuelve a tocar.");
    await tfEnviarAudio(blob);
  };
  if (TF.audioCtx?.state === "suspended") { try { await TF.audioCtx.resume(); } catch {} }
  rec.start(250);
  TF.grabando = rec; TF.segundos = 0; TF.oido = !TF.analizador; // sin medidor no se puede saber: se asume que sí
  try { navigator.vibrate?.(40); } catch {}
  TF.reloj = setInterval(() => {
    TF.segundos++;
    if (TF.segundos >= TF_MAX_SEGUNDOS) rec.stop();
    tfPintar();
  }, 1000);
  tfPintar();
  tfMedirVoz();
}
const aBase64 = (blob) => new Promise((ok, mal) => {
  const r = new FileReader();
  r.onload = () => ok(String(r.result).split(",")[1] || "");
  r.onerror = mal;
  r.readAsDataURL(blob);
});
// El audio va directo al tutor: él lo pasa a texto y responde en el mismo viaje
async function tfEnviarAudio(blob) {
  if (TF.enviando) return;
  tfError("");
  const provisional = { role: "user", content: "🎧 Escuchando tu audio…", voz: true, provisional: true };
  TF.mensajes.push(provisional);
  TF.enviando = true; tfPintar();
  try {
    const { data } = await db.auth.getSession();
    const c = TF.contexto;
    const historial = TF.mensajes.filter((x) => !x.provisional).slice(-TF_MAX_ENVIADOS)
      .map((x) => ({ role: x.role, content: x.role === "user" ? x.content : JSON.stringify(x.r) }));
    const r = await fetch("/api/tutor", {
      method: "POST",
      headers: { "Content-Type": "application/json", Authorization: `Bearer ${data.session?.access_token || ""}` },
      body: JSON.stringify({
        modo: "flotante", episodio: TF.episodio || 3,
        contexto: `Pantalla: ${c.pantalla}${c.detalle ? "\n" + c.detalle : ""}`,
        mensajes: historial, audio: await aBase64(blob), tipo: blob.type
      })
    });
    const j = await r.json().catch(() => ({}));
    TF.mensajes = TF.mensajes.filter((x) => x !== provisional);
    if (!r.ok) return tfError(j.error || "El tutor no pudo responder. Intenta de nuevo.");
    TF.mensajes.push({ role: "user", content: j.texto, voz: true });
    TF.mensajes.push({ role: "assistant", r: j.respuesta, bien: j.respuesta.bien, tras: true });
    await tfGuardar();
    if (j.respuesta.mensaje) { try { hablar(j.respuesta.mensaje); } catch {} }
    try { await sumarXP(XP_TUTOR); } catch {}
  } catch {
    TF.mensajes = TF.mensajes.filter((x) => x !== provisional);
    tfError("Sin conexión. Revisa tu internet.");
  } finally {
    TF.enviando = false; tfPintar();
  }
}

// ---------- nueva conversación ----------
async function tfNueva() {
  if (TF.mensajes.length && !confirm("¿Empezar una conversación nueva? El tutor olvidará esta.")) return;
  TF.mensajes = [];
  await tfGuardar();
  tfError(""); tfPintar();
}

// ---------- crear el botón y el panel (una sola vez) ----------
(function crearTutorFlotante() {
  document.body.insertAdjacentHTML("beforeend", `
    <button id="tf-btn" class="tf-btn" hidden aria-label="Abrir el tutor">
      <span class="tf-ico">💬</span><span class="tf-x">✕</span>
    </button>
    <section id="tf-panel" class="tf-panel" hidden role="dialog" aria-label="Tutor">
      <header class="tf-head">
        <div class="tf-avatar">✨</div>
        <div style="flex:1;min-width:0">
          <b>Tutor</b>
          <div class="tf-ctx" id="tf-ctx"></div>
        </div>
        <a class="tf-ic" href="#/ingles/tutor" title="Tutor completo (modos)">⤢</a>
        <button class="tf-ic" id="tf-nuevo" title="Nueva conversación">🗑</button>
        <button class="tf-ic" id="tf-cerrar" title="Cerrar">✕</button>
      </header>
      <div class="tf-body" id="tf-body"></div>
      <div class="tf-chips">
        <button class="tf-chip" data-tf="Explícame este ejercicio">🤔 Explícame esto</button>
        <button class="tf-chip" data-tf="Dame una pista">💡 Pista</button>
        <button class="tf-chip" data-tf="Let's talk in English!">💬 Let's talk</button>
        <button class="tf-chip" data-tf-escribir="¿Cómo digo: ">🔁 ¿Cómo digo…?</button>
      </div>
      <p class="error tf-err" id="tf-err"></p>
      <div class="tf-pie">
        <textarea id="tf-in" rows="1" placeholder="Write or ask…  (escribe o pregunta)"></textarea>
        <button class="tf-mic" id="tf-mic" title="Hablar">🎤</button>
        <button class="tf-env" id="tf-env" title="Enviar">➤</button>
      </div>
    </section>`);
  const inp = document.getElementById("tf-in");
  const crecer = () => { inp.style.height = "auto"; inp.style.height = Math.min(inp.scrollHeight, 120) + "px"; };
  document.getElementById("tf-btn").onclick = () => (TF.abierto ? tfCerrar() : tfAbrir());
  document.getElementById("tf-cerrar").onclick = tfCerrar;
  document.getElementById("tf-nuevo").onclick = tfNueva;
  document.getElementById("tf-mic").onclick = tfMic;
  document.getElementById("tf-env").onclick = () => { const v = inp.value; inp.value = ""; crecer(); tfEnviar(v); };
  inp.oninput = crecer;
  inp.onkeydown = (e) => { if (e.key === "Enter" && !e.shiftKey) { e.preventDefault(); document.getElementById("tf-env").click(); } };
  document.querySelectorAll("[data-tf]").forEach((b) => (b.onclick = () => tfEnviar(b.dataset.tf)));
  document.querySelector("[data-tf-escribir]").onclick = (e) => { inp.value = e.currentTarget.dataset.tfEscribir; inp.focus(); crecer(); };
  document.addEventListener("keydown", (e) => { if (e.key === "Escape" && TF.abierto) tfCerrar(); });
  if (!tfPuedeGrabar()) document.getElementById("tf-mic").hidden = true;
})();
