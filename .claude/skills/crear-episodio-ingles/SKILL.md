---
name: crear-episodio-ingles
description: Receta para crear o completar un episodio de inglés (English My Way, Libro 1) en la app de inglés tipo Duolingo — temas del pensum, lecciones, ejercicios de lección, banco de práctica y examen, como migración SQL idempotente para Supabase y su entrada en camino.js. Usar cuando se pida "crear el episodio N", "completar el episodio N", "más ejercicios del episodio N" o armar episodios en paralelo.
---

# Crear un episodio de inglés

Formato tomado del **Episodio 3** (`db/012_ep3_completo.sql`). Antes de escribir, **leer en el repo**:
- la última migración en `db/` (para el número siguiente y no repetir ids ni `orden`);
- la migración del episodio anterior completo, como modelo;
- `camino.js` (`UNIDADES`): qué unidades y temas tiene cada episodio;
- las migraciones 006–008, que definen los tipos de ejercicio y columnas (`tema_id`, `pata`, `reservado`). Si algo de esta receta no coincide con ellas, **manda el SQL del repo**.

Si existen los documentos del proyecto `claude/mapa-episodios.md`, `claude/episodios-4-8-contenido.md` y `claude/ep3-cierre.md`, leerlos primero: dicen qué temas, unidades, Test Yourself y Workshop lleva cada episodio.

## Tipos de ejercicio permitidos (solo estos)
`elegir`, `escuchar`, `ordenar`, `escribir`, `emparejar`, `comprension`, `decir`, `libre`, `rapido`, `dibujo`.
Son los del `check` de la tabla `ejercicios` (migración 011) y los que dibuja `lecciones.js`.
**No inventar tipos** (p. ej. `dictado`): la base de datos rechaza el insert y la app no sabría mostrarlo. Un tipo nuevo exige primero una migración que amplíe el `check` y el código en `lecciones.js`, y eso se pregunta antes.

## Qué produce
1. **Una migración** `db/NNN_epN_<descripcion>.sql`, idempotente.
2. **El cambio en `camino.js`**: agregar los ids de los temas nuevos a la unidad correcta del episodio.

## Cabecera de la migración
```sql
-- =====================================================================
-- NNN · Episodio N <qué agrega> (Unidades X y Y del Libro 1)
--   - K temas nuevos en pensum_temas (orden a–b del Episodio N): ...
--   - K lecciones tipo 'tema' (8 ejercicios cada una)
--   - banco-epN +8·K ejercicios de práctica (ordenes ...)
--   - examen-epN +3·K ejercicios reservados (ordenes ...)
-- Requiere 006, 007 y 008. Se puede correr varias veces sin dañar nada.
-- Pega TODO este archivo en Supabase → SQL Editor → Run.
-- =====================================================================
```

## 1. Temas (`pensum_temas`)
```sql
insert into pensum_temas (id, episodio, orden, nombre_es, nombre_en, descripcion) values
  ('epN-tema', N, <orden>, $t$Nombre en español$t$, $t$English name$t$, $t$Explicación corta con un ejemplo en inglés.$t$)
on conflict (id) do update set episodio = excluded.episodio, orden = excluded.orden, nombre_es = excluded.nombre_es,
  nombre_en = excluded.nombre_en, descripcion = excluded.descripcion;
```
- id del tema: `epN-<tema-en-español-con-guiones>` (ej. `ep3-presente-progresivo`).
- `orden` continúa después del último tema de ese episodio.

## 2. Lecciones (`lecciones`), una por tema
```sql
insert into lecciones (id, materia_id, unidad_id, episodio, orden, tipo, titulo, descripcion) values
  ('epN-tema', 'ingles', (select id from unidades where materia_id = 'ingles' and numero = <unidad>), N, <orden>, 'tema',
   $t$Título$t$, $t$Qué se aprende (Unidad X).$t$)
on conflict (id) do update set unidad_id = excluded.unidad_id, episodio = excluded.episodio, orden = excluded.orden,
  tipo = excluded.tipo, titulo = excluded.titulo, descripcion = excluded.descripcion;
```
El id de la lección es el mismo del tema. `tipo` ∈ `refuerzo`, `tema`, `simulacro`.

## 3. Ejercicios: por cada tema, 8 + 8 + 3
```sql
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
  ('<id>', '<leccion>', <orden>, '<tipo>', $j${...}$j$::jsonb, 'epN-tema', '<pata>', <reservado>),
  ...
on conflict (id) do update set ...;   -- copiar el on conflict exacto del episodio anterior
```

| Grupo | `leccion_id` | id | `orden` | `reservado` |
|---|---|---|---|---|
| Lección (8) | `epN-tema` | `epN-tema-01…08` | 1–8 | false |
| Banco de práctica (8) | `banco-epN` | `banco-epN-epN-tema-01…08` | sigue al último del banco | false |
| Examen (3) | `examen-epN` | `examen-epN-epN-tema-01…03` | sigue al último del examen | **true** |

**Lección (8), en este orden:** 4 × `elegir` → 1 × `escribir` → 1 × `ordenar` → 1 × `emparejar` (pata `estudio`) → 1 × `escuchar` (pata `input`).
**Banco (8):** 2 × `comprension` (uno `modo: "escuchar"`, otro `modo: "leer"`; pata `input`) → 2 × `decir` + 1 × `libre` (`output`) → 3 × `rapido` (`fluidez`).
**Examen (3):** `elegir` y `escribir` (`estudio`) + `escuchar` (`input`).

### Las 4 patas por tema (19 ejercicios)
| Pata | Lección | Banco | Examen | Total |
|---|---|---|---|---|
| `estudio` (entender la regla) | 7 | 0 | 2 | 9 |
| `input` (escuchar/leer) | 1 | 2 | 1 | 4 |
| `output` (decir/escribir libre) | 0 | 3 | 0 | 3 |
| `fluidez` (rápido, contra reloj) | 0 | 3 | 0 | 3 |

Así quedó el Episodio 3. Si el usuario pide otro balance entre las patas, seguir el suyo.

## Formato de `datos` por tipo
```jsonc
// elegir
{"frase": "I ___ working right now.", "opciones": ["am", "is", "are"], "correcta": 0, "es": "Estoy trabajando ahora mismo.", "explicacion": "I → am."}
// escribir (respuestas en minúscula, sin signos, con variantes válidas)
{"respuestas": ["my wife is selling shoes on tiktok now", "my wife is selling shoes on tiktok right now"], "mostrar": "My wife is selling shoes on TikTok now.", "es": "Mi esposa está vendiendo zapatos en TikTok ahora.", "explicacion": "is + selling."}
// ordenar (la app desordena la frase)
{"frase": "Are you studying English now?", "es": "¿Estás estudiando inglés ahora?", "explicacion": "Are + sujeto + verbo-ing?"}
// emparejar (4 pares inglés–español)
{"pares": [["I am working", "estoy trabajando"], ["she is sleeping", "ella está durmiendo"], ["we are eating", "estamos comiendo"], ["they are playing", "ellos están jugando"]], "es": "", "explicacion": "..."}
// escuchar (audio = la opción correcta)
{"opciones": ["He is running now.", "He runs every day.", "He ran yesterday."], "correcta": 0, "audio": "He is running now.", "es": "Él está corriendo ahora.", "explicacion": "..."}
// decir (hablar: del español al inglés)
{"es": "Estoy escribiendo un mensaje ahora.", "respuestas": ["i am writing a message now", "im writing a message now"], "mostrar": "I'm writing a message now.", "explicacion": "write → writing."}
// libre (respuesta abierta, la corrige el tutor)
{"pregunta": "What are you doing right now? Write two sentences...", "pregunta_es": "¿Qué estás haciendo ahora? ...", "ejemplo": "I'm reading this lesson.", "criterio": "am/is/are + verbo con -ing.", "explicacion": "..."}
// rapido (2 opciones, contra reloj)
{"frase": "I ___ studying now.", "opciones": ["am", "is"], "correcta": 0, "es": "Estoy estudiando ahora.", "explicacion": "I → am.", "segundos": 6}
// comprension (pata input; modo "escuchar" o "leer"; 2–3 líneas cortas + pregunta)
{"modo": "escuchar", "lineas": [{"en": "Hi, I'm Ana.", "es": "Hola, soy Ana."}, {"en": "I'm a teacher.", "es": "Soy profesora."}], "pregunta": "What is Ana's job?", "pregunta_es": "¿Cuál es el trabajo de Ana?", "opciones": ["She is a teacher.", "She is a student.", "She is a nurse."], "correcta": 0, "explicacion": "..."}
// dibujo (pata output; va en la lección "vocab-epN", ver 011)
{"dibujo": "eye", "mostrar": "eye", "es": "ojo", "respuestas": ["eye", "eyes"]}
```

### Dibujos
- Van en la lección de vocabulario del episodio (`vocab-epN`, creada en la 011), con su `tema_id` y pata `output`. Mi camino mete 1 dibujo por bloque.
- `"dibujo"` debe ser una clave que **ya exista en `dibujos.js`**. Si la palabra no tiene dibujo (p. ej. joyería: ring, necklace), hay que dibujarla primero en `dibujos.js`; si no, no usar dibujo para esa palabra.

### Regla de dominio (`camino.js` → `REGLA`)
Un tema queda dominado con: estudio 3 aciertos (75 %), input 2 (70 %), output 2 (60 %), fluidez 3 (70 %), en 2 días distintos. Mi camino elige ejercicios al azar y puede repetirlos: con solo 3 `rapido` por tema, el estudiante repite siempre los mismos. Preferir **más ejercicios distintos por pata** a más ejercicios de estudio.

## Reglas de contenido
- Gramática y vocabulario **del episodio y unidad del Libro 1** que corresponde; no adelantar temas de episodios siguientes.
- Explicaciones **en español, cortas** (una línea), con la regla clave.
- Frases útiles y cercanas a la vida del estudiante (familia, el trabajo vendiendo zapatos por TikTok, Colombia, Cúcuta), como en el Episodio 3.
- En `respuestas`: todo en minúscula, sin puntuación final, e incluir contracciones y variantes correctas (`i am` / `im`, `right now` / `now`).
- `correcta` es el índice (desde 0). Variar la posición de la respuesta correcta.
- Nada de ids u `orden` repetidos: revisar los existentes antes.
- Texto dentro de `$t$...$t$` y JSON dentro de `$j$...$j$` (evita problemas con comillas y apóstrofes).

## Si se hacen varios episodios en paralelo
Cada agente toma **un episodio** y **un número de migración distinto, reservado de antemano** (ej. 013, 014, 015, 016). Todos siguen esta receta y el Episodio 3 como modelo, para que salgan con el mismo formato. Los cambios a `camino.js` se juntan al final en un solo paso.

## Antes de entregar
- [ ] Corre dos veces sin error (todo con `on conflict`)
- [ ] 8 + 8 + 3 ejercicios por tema; todas las patas cubiertas
- [ ] Temas agregados a `camino.js` en su unidad
- [ ] Decirle al usuario: pegar el archivo en Supabase → SQL Editor → Run
