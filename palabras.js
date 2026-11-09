// ============================================================
// Tocar una palabra en inglés → se oye y sale su significado (como en Duolingo).
// Primero busca en el diccionario propio (diccionario.js, instantáneo y gratis);
// si no está, le pregunta a Wako (/api/palabra) y lo recuerda en este celular.
// Con "➕ Guardar" la palabra pasa a "Mis palabras" y sale en las Tarjetas de repaso.
// Usa funciones de app.js (db, esc, hablar, VEL, usuarioActual).
// ============================================================
const CACHE_PALABRAS = "significados-v1";
let misPalabrasSet = null; // palabras ya guardadas (se carga una vez)

const enExamen = () => /^#\/(nowican|ubicacion)/.test(location.hash) || document.body.dataset.examen === "1";

function leerCachePalabras() { try { return JSON.parse(localStorage.getItem(CACHE_PALABRAS)) || {}; } catch { return {}; } }
function guardarCachePalabra(p, r) {
  try { const c = leerCachePalabras(); c[p] = r; localStorage.setItem(CACHE_PALABRAS, JSON.stringify(c)); } catch {}
}

async function cargarMisPalabras() {
  if (misPalabrasSet) return misPalabrasSet;
  try {
    const { data, error } = await db.from("mis_palabras").select("palabra");
    misPalabrasSet = new Set(error ? [] : data.map((r) => r.palabra));
  } catch { misPalabrasSet = new Set(); }
  return misPalabrasSet;
}

// Busca el significado: diccionario propio → caché del celular → Wako
async function significadoDe(palabra, frase) {
  const clave = palabra.toLowerCase().replace(/[’`´]/g, "'");
  const local = buscarEnDiccionario(clave);
  if (local) return local;
  const cache = leerCachePalabras()[clave];
  if (cache) return cache;
  const { data } = await db.auth.getSession();
  const r = await fetch("/api/palabra", {
    method: "POST",
    headers: { "Content-Type": "application/json", Authorization: `Bearer ${data.session?.access_token || ""}` },
    body: JSON.stringify({ palabra: clave, frase })
  });
  const j = await r.json().catch(() => ({}));
  if (!r.ok) throw new Error(j.error || "No encontré el significado.");
  const res = { es: j.es, nota: j.nota || "", wako: true };
  guardarCachePalabra(clave, res);
  return res;
}

function cerrarBurbuja() { document.getElementById("burbuja-palabra")?.remove(); }

async function mostrarSignificado(el) {
  cerrarBurbuja();
  const palabra = el.dataset.palabra;
  // La frase completa donde está la palabra (ayuda a Wako a elegir el significado)
  const frase = (el.closest(".lect-linea, .lec-frase, .fb-ingles, .practica, .t-msg, div, p") || el.parentElement)?.textContent?.trim().slice(0, 200) || "";
  const b = document.createElement("div");
  b.id = "burbuja-palabra";
  b.className = "burbuja";
  b.innerHTML = `<div class="burbuja-top"><b>${esc(palabra)}</b>
      <button class="voz" data-voz="${esc(palabra)}" title="Escuchar">🔊</button>
      <button class="voz" data-voz-lento="${esc(palabra)}" title="Despacio">🐢</button></div>
    <div class="burbuja-es">${enExamen() ? `<span class="muted">En el examen solo puedes oírla 🙂</span>` : `<span class="muted">Buscando…</span>`}</div>`;
  document.body.appendChild(b);
  ubicarBurbuja(b, el);
  if (enExamen()) return;

  let r;
  try { r = await significadoDe(palabra, frase); }
  catch (e) {
    if (!document.body.contains(b)) return;
    b.querySelector(".burbuja-es").innerHTML = `<span class="muted">${esc(e.message)}</span>`;
    return ubicarBurbuja(b, el);
  }
  if (!document.body.contains(b)) return; // ya la cerraron
  const base = r.base && r.base !== palabra.toLowerCase() ? r.base : "";
  const guardable = !/nombre propio|no es una palabra|palabra en español/i.test(r.es);
  const clave = (base || palabra).toLowerCase();
  b.querySelector(".burbuja-es").innerHTML = `
    <div class="burbuja-sig">${esc(r.es)}</div>
    ${base ? `<div class="muted burbuja-nota">${esc(palabra)} → <b>${esc(base)}</b>${r.nota ? ` · ${esc(r.nota)}` : ""}</div>`
      : r.nota ? `<div class="muted burbuja-nota">${esc(r.nota)}</div>` : ""}
    ${guardable ? `<button class="btn alt burbuja-guardar" id="b-guardar-palabra">➕ Guardar en mis tarjetas</button>` : ""}`;
  ubicarBurbuja(b, el);
  const btn = b.querySelector("#b-guardar-palabra");
  if (!btn) return;
  const yaEsta = () => { btn.textContent = "✓ Está en tus tarjetas"; btn.disabled = true; };
  cargarMisPalabras().then((s) => { if (s.has(clave)) yaEsta(); });
  btn.onclick = async (e) => {
    e.stopPropagation();
    btn.disabled = true; btn.textContent = "Guardando…";
    const significado = r.es.split(" / ").slice(0, 2).join(" / ").replace(/\s*\(.*?\)\s*/g, " ").trim() || r.es;
    const { error } = await db.from("mis_palabras").upsert({ palabra: clave, significado, frase: frase.slice(0, 200) }, { onConflict: "user_id,palabra", ignoreDuplicates: true });
    if (error) {
      btn.disabled = false;
      btn.textContent = /mis_palabras|does not exist|schema cache/i.test(error.message) ? "Falta correr db/010 en Supabase" : "No se pudo guardar. Toca otra vez";
      return;
    }
    (await cargarMisPalabras()).add(clave);
    yaEsta();
    try { navigator.vibrate?.(30); } catch {}
  };
}

// Pone la burbuja encima de la palabra (o debajo si no cabe), sin salirse de la pantalla
function ubicarBurbuja(b, el) {
  const r = el.getBoundingClientRect(), w = Math.min(300, window.innerWidth - 24);
  b.style.width = w + "px";
  const left = Math.max(12, Math.min(window.innerWidth - w - 12, r.left + r.width / 2 - w / 2));
  b.style.left = left + "px";
  const alto = b.offsetHeight;
  const arriba = r.top - alto - 10;
  b.style.top = (arriba > 8 ? arriba : r.bottom + 10) + "px";
  b.classList.toggle("abajo", arriba <= 8);
  b.style.setProperty("--flecha", Math.max(16, Math.min(w - 16, r.left + r.width / 2 - left)) + "px");
}

document.addEventListener("click", (e) => {
  const b = document.getElementById("burbuja-palabra");
  if (b && !b.contains(e.target) && !e.target.closest("[data-palabra]")) cerrarBurbuja();
});
window.addEventListener("scroll", cerrarBurbuja, { passive: true });
window.addEventListener("hashchange", cerrarBurbuja);

// ---------- "Mis palabras": lista para ver y borrar ----------
async function vistaMisPalabras() {
  pintar(`<p class="muted">Cargando…</p>`);
  const { data, error } = await db.from("mis_palabras").select("*").order("creado", { ascending: false });
  if (error) return pintar(/mis_palabras|does not exist|schema cache/i.test(error.message)
    ? `<a href="#/ingles" class="link">← Inglés</a><div class="card" style="margin-top:16px"><h2>Falta un paso en Supabase</h2>
       <p class="muted">Abre Supabase → <b>SQL Editor</b>, pega <code>db/010_palabras.sql</code> y dale <b>Run</b>.</p></div>`
    : errorBox(error));
  misPalabrasSet = new Set(data.map((r) => r.palabra));
  const hoyStr = hoy(); // misma fecha que usan las Tarjetas
  const pendientes = data.filter((p) => p.proxima_revision <= hoyStr).length;
  pintar(`
    <a href="#/ingles" class="link">← Inglés</a>
    <h1>📝 Mis palabras</h1>
    <p class="muted">Toca cualquier palabra en inglés de la app y dale <b>➕ Guardar</b>. Aquí quedan y salen en tus Tarjetas para repasarlas.</p>
    ${data.length ? `<a class="btn grande" href="#/ingles/repaso">🃏 Repasar ahora${pendientes ? ` (${pendientes} para hoy)` : ""}</a>` : ""}
    <div class="card" style="margin-top:14px">
      ${data.length ? data.map((p) => `
        <div class="mi-palabra">
          <div><b>${fraseTocable(p.palabra)}</b> <button class="voz" data-voz="${esc(p.palabra)}">🔊</button>
            <div class="muted">${esc(p.significado)}</div>
            ${p.frase ? `<div class="muted mi-palabra-frase">“${esc(p.frase)}”</div>` : ""}</div>
          <button class="link" data-borrar="${esc(p.palabra)}" title="Quitar">🗑</button>
        </div>`).join("") : `<p class="muted">Todavía no has guardado palabras.</p>`}
    </div>`);
  app.querySelectorAll("[data-borrar]").forEach((x) => (x.onclick = async () => {
    if (!confirm(`¿Quitar "${x.dataset.borrar}" de tus palabras?`)) return;
    await db.from("mis_palabras").delete().eq("palabra", x.dataset.borrar);
    vistaMisPalabras();
  }));
}
