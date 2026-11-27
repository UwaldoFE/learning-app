-- ============================================================
-- EPISODIO 12 — COMPLETO (U24 At the Restaurant · U25 Tenses Review)
-- 8 temas × 19 ejercicios = 152 ejercicios
-- Tipos: elegir, escribir, escuchar, ordenar, dictado, emparejar,
--        comprensión, decir, libre, rápido
-- ============================================================

-- ────────────────────────────────────────────────────────────
-- UNIDADES 24-25
-- ────────────────────────────────────────────────────────────
insert into unidades (materia_id, numero, episodio, objetivo) values
  ('ingles', 24, 'Episodio 12', 'Countries, nationalities, and ordering at a restaurant'),
  ('ingles', 25, 'Episodio 12', 'Will vs going to, past progressive, and present progressive for future')
on conflict (materia_id, numero) do update set
  episodio = excluded.episodio,
  objetivo = coalesce(nullif(unidades.objetivo, ''), excluded.objetivo);

-- ────────────────────────────────────────────────────────────
-- LECCIONES BANCO Y EXAMEN
-- ────────────────────────────────────────────────────────────
insert into lecciones (id, materia_id, unidad_id, episodio, orden, tipo, titulo, descripcion) values
  ('banco-ep12',  'ingles', (select id from unidades where materia_id='ingles' and numero=24), 12, 90, 'banco',  'Banco Episodio 12',  'Ejercicios de refuerzo — Episodio 12'),
  ('examen-ep12', 'ingles', (select id from unidades where materia_id='ingles' and numero=24), 12, 91, 'examen', 'Examen Episodio 12', 'Evaluación — Episodio 12')
on conflict (id) do update set
  materia_id  = excluded.materia_id,
  unidad_id   = excluded.unidad_id,
  episodio    = excluded.episodio,
  orden       = excluded.orden,
  tipo        = excluded.tipo,
  titulo      = excluded.titulo,
  descripcion = excluded.descripcion;

-- ============================================================
-- TEMAS
-- ============================================================
insert into pensum_temas (id, episodio, orden, nombre_es, nombre_en, descripcion) values
  ('ep12-paises-nacionalidades', 12, 1, $t$Países y nacionalidades$t$, $t$Countries and Nationalities$t$, $t$Aprende los nombres de países y cómo hablar de nacionalidades en inglés$t$),
  ('ep12-restaurante-vocabulario', 12, 2, $t$Vocabulario del restaurante$t$, $t$Restaurant Vocabulary$t$, $t$Palabras clave para pedir comida, leer un menú y hablar de platos$t$),
  ('ep12-restaurante-pedir', 12, 3, $t$Pedir en un restaurante$t$, $t$Ordering at a Restaurant$t$, $t$Frases para ordenar comida, pedir la cuenta y hacer solicitudes educadas$t$),
  ('ep12-restaurante-conversacion', 12, 4, $t$Conversación en el restaurante$t$, $t$Restaurant Conversation$t$, $t$Diálogos y situaciones reales en un restaurante$t$),
  ('ep12-will-vs-going-to', 12, 5, $t$Will vs Going to$t$, $t$Will vs Going to$t$, $t$Diferencias entre will y going to para hablar del futuro$t$),
  ('ep12-pasado-progresivo', 12, 6, $t$Pasado progresivo$t$, $t$Past Progressive$t$, $t$Was/were + -ing para acciones en progreso en el pasado$t$),
  ('ep12-presente-progresivo-futuro', 12, 7, $t$Presente progresivo para el futuro$t$, $t$Present Progressive for Future$t$, $t$Usar am/is/are + -ing para planes definidos en el futuro cercano$t$),
  ('ep12-repaso-tiempos', 12, 8, $t$Repaso de tiempos verbales$t$, $t$Tenses Review$t$, $t$Integración de todos los tiempos vistos: simple, progresivo, perfecto, futuro$t$)
on conflict (id) do update set
  episodio    = excluded.episodio,
  orden       = excluded.orden,
  nombre_es   = excluded.nombre_es,
  nombre_en   = excluded.nombre_en,
  descripcion = excluded.descripcion;

-- ============================================================
-- LECCIONES TIPO TEMA
-- ============================================================
insert into lecciones (id, materia_id, unidad_id, episodio, orden, tipo, titulo, descripcion) values
  ('ep12-paises-nacionalidades',       'ingles', (select id from unidades where materia_id='ingles' and numero=24), 12, 1,  'tema', 'Countries and Nationalities',       'Países y nacionalidades'),
  ('ep12-restaurante-vocabulario',     'ingles', (select id from unidades where materia_id='ingles' and numero=24), 12, 2,  'tema', 'Restaurant Vocabulary',              'Vocabulario del restaurante'),
  ('ep12-restaurante-pedir',           'ingles', (select id from unidades where materia_id='ingles' and numero=24), 12, 3,  'tema', 'Ordering at a Restaurant',            'Pedir en un restaurante'),
  ('ep12-restaurante-conversacion',    'ingles', (select id from unidades where materia_id='ingles' and numero=24), 12, 4,  'tema', 'Restaurant Conversation',             'Conversación en el restaurante'),
  ('ep12-will-vs-going-to',           'ingles', (select id from unidades where materia_id='ingles' and numero=25), 12, 5,  'tema', 'Will vs Going to',                    'Will vs Going to'),
  ('ep12-pasado-progresivo',          'ingles', (select id from unidades where materia_id='ingles' and numero=25), 12, 6,  'tema', 'Past Progressive',                     'Pasado progresivo'),
  ('ep12-presente-progresivo-futuro', 'ingles', (select id from unidades where materia_id='ingles' and numero=25), 12, 7,  'tema', 'Present Progressive for Future',       'Presente progresivo para el futuro'),
  ('ep12-repaso-tiempos',            'ingles', (select id from unidades where materia_id='ingles' and numero=25), 12, 8,  'tema', 'Tenses Review',                        'Repaso de tiempos verbales')
on conflict (id) do update set
  materia_id  = excluded.materia_id,
  unidad_id   = excluded.unidad_id,
  episodio    = excluded.episodio,
  orden       = excluded.orden,
  tipo        = excluded.tipo,
  titulo      = excluded.titulo,
  descripcion = excluded.descripcion;

-- ============================================================
-- EJERCICIOS — TEMA 1: ep12-paises-nacionalidades
-- ============================================================
-- ── Lección (8) ──
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('ep12-pais-01', 'ep12-paises-nacionalidades', 1, 'elegir',
 $j${"frase":"She is from Japan. She is ___.","opciones":["Japanese","Japanian","Japanish","Japonic"],"correcta":0,"es":"Ella es de Japón. Ella es ___.","explicacion":"The nationality for Japan is Japanese."}$j$,
 'ep12-paises-nacionalidades', 'estudio', false),

('ep12-pais-02', 'ep12-paises-nacionalidades', 2, 'emparejar',
 $j${"pares":[["Brazil","Brazilian"],["Germany","German"],["France","French"],["China","Chinese"]],"es":"","explicacion":"Each country has its own nationality form."}$j$,
 'ep12-paises-nacionalidades', 'estudio', false),

('ep12-pais-03', 'ep12-paises-nacionalidades', 3, 'escribir',
 $j${"respuestas":["Colombian"],"mostrar":"He is from Colombia. He is ___.","es":"Él es de Colombia. Él es ___.","explicacion":"The nationality for Colombia is Colombian."}$j$,
 'ep12-paises-nacionalidades', 'estudio', false),

('ep12-pais-04', 'ep12-paises-nacionalidades', 4, 'ordenar',
 $j${"frase":"Where are you from ?","es":"¿De dónde eres?","explicacion":"This is the standard question to ask about someone's country of origin."}$j$,
 'ep12-paises-nacionalidades', 'estudio', false),

('ep12-pais-05', 'ep12-paises-nacionalidades', 5, 'escuchar',
 $j${"opciones":["I am from Mexico.","I am from Italy.","I am from Canada.","I am from Egypt."],"correcta":0,"audio":"I am from Mexico.","es":"Soy de México.","explicacion":"Listen for the country name 'Mexico'."}$j$,
 'ep12-paises-nacionalidades', 'estudio', false),

('ep12-pais-06', 'ep12-paises-nacionalidades', 6, 'dictado',
 $j${"audio":"My friend is Australian.","respuestas":["My friend is Australian.","My friend is Australian"],"mostrar":"My friend is ___.","es":"Mi amigo es australiano.","explicacion":"Australian is the nationality for Australia."}$j$,
 'ep12-paises-nacionalidades', 'estudio', false),

('ep12-pais-07', 'ep12-paises-nacionalidades', 7, 'elegir',
 $j${"frase":"People from Italy speak ___.","opciones":["Italian","Italish","Italese","Italic"],"correcta":0,"es":"La gente de Italia habla ___.","explicacion":"The language and nationality for Italy is Italian."}$j$,
 'ep12-paises-nacionalidades', 'estudio', false),

('ep12-pais-08', 'ep12-paises-nacionalidades', 8, 'escribir',
 $j${"respuestas":["Spanish"],"mostrar":"People from Spain speak ___.","es":"La gente de España habla ___.","explicacion":"The language spoken in Spain is Spanish."}$j$,
 'ep12-paises-nacionalidades', 'estudio', false),

-- ── Banco (8) ──
('banco-ep12-pais-01', 'banco-ep12', 1, 'comprension',
 $j${"modo":"leer","lineas":[{"en":"Where are you from?","es":"¿De dónde eres?"},{"en":"I am from Argentina. I am Argentinian.","es":"Soy de Argentina. Soy argentino."},{"en":"What language do you speak?","es":"¿Qué idioma hablas?"},{"en":"I speak Spanish and a little English.","es":"Hablo español y un poco de inglés."}],"pregunta":"What nationality is the speaker?","pregunta_es":"¿Cuál es la nacionalidad del hablante?","opciones":["Argentinian","Brazilian","Chilean","Peruvian"],"correcta":0,"explicacion":"He says 'I am Argentinian'."}$j$,
 'ep12-paises-nacionalidades', 'input', false),

('banco-ep12-pais-02', 'banco-ep12', 2, 'comprension',
 $j${"modo":"leer","lineas":[{"en":"She lives in Paris.","es":"Ella vive en París."},{"en":"She is French.","es":"Ella es francesa."},{"en":"She speaks French and English.","es":"Ella habla francés e inglés."}],"pregunta":"Where does she live?","pregunta_es":"¿Dónde vive ella?","opciones":["Paris","London","Berlin","Madrid"],"correcta":0,"explicacion":"The text says 'She lives in Paris'."}$j$,
 'ep12-paises-nacionalidades', 'input', false),

('banco-ep12-pais-03', 'banco-ep12', 3, 'decir',
 $j${"es":"Di: Soy colombiano / colombiana.","respuestas":["I am Colombian.","I'm Colombian."],"mostrar":"I am Colombian.","explicacion":"Use 'I am' + nationality adjective."}$j$,
 'ep12-paises-nacionalidades', 'output', false),

('banco-ep12-pais-04', 'banco-ep12', 4, 'decir',
 $j${"es":"Di: ¿De qué país eres?","respuestas":["What country are you from?","Which country are you from?"],"mostrar":"What country are you from?","explicacion":"Use 'What country are you from?' to ask about nationality."}$j$,
 'ep12-paises-nacionalidades', 'output', false),

('banco-ep12-pais-05', 'banco-ep12', 5, 'libre',
 $j${"pregunta":"Tell me about your country. Where is it? What language do people speak there?","pregunta_es":"Cuéntame sobre tu país. ¿Dónde queda? ¿Qué idioma habla la gente allí?","ejemplo":"I am from Colombia. It is in South America. People speak Spanish."}$j$,
 'ep12-paises-nacionalidades', 'output', false),

('banco-ep12-pais-06', 'banco-ep12', 6, 'rapido',
 $j${"frase":"He is from Japan. He is ___.","opciones":["Japanese","Chinese","Korean","Thai"],"correcta":0,"es":"Él es de Japón. Él es ___.","explicacion":"Japanese is the nationality for Japan.","segundos":5}$j$,
 'ep12-paises-nacionalidades', 'fluidez', false),

('banco-ep12-pais-07', 'banco-ep12', 7, 'rapido',
 $j${"frase":"People from Brazil speak ___.","opciones":["Portuguese","Spanish","Brazilian","French"],"correcta":0,"es":"La gente de Brasil habla ___.","explicacion":"The official language of Brazil is Portuguese, not 'Brazilian'.","segundos":5}$j$,
 'ep12-paises-nacionalidades', 'fluidez', false),

('banco-ep12-pais-08', 'banco-ep12', 8, 'rapido',
 $j${"frase":"The capital of the United Kingdom is ___.","opciones":["London","Paris","Dublin","Edinburgh"],"correcta":0,"es":"La capital del Reino Unido es ___.","explicacion":"London is the capital of the United Kingdom.","segundos":5}$j$,
 'ep12-paises-nacionalidades', 'fluidez', false),

-- ── Examen (3) ──
('examen-ep12-pais-01', 'examen-ep12', 1, 'elegir',
 $j${"frase":"She is from Germany. She is ___.","opciones":["German","Germanian","Dutch","Austrian"],"correcta":0,"es":"Ella es de Alemania. Ella es ___.","explicacion":"The nationality for Germany is German."}$j$,
 'ep12-paises-nacionalidades', 'estudio', true),

('examen-ep12-pais-02', 'examen-ep12', 2, 'escribir',
 $j${"respuestas":["Mexican"],"mostrar":"He is from Mexico. He is ___.","es":"Él es de México. Él es ___.","explicacion":"The nationality for Mexico is Mexican."}$j$,
 'ep12-paises-nacionalidades', 'estudio', true),

('examen-ep12-pais-03', 'examen-ep12', 3, 'elegir',
 $j${"frase":"People from Canada speak English and ___.","opciones":["French","Canadian","Spanish","Portuguese"],"correcta":0,"es":"La gente de Canadá habla inglés y ___.","explicacion":"Canada's two official languages are English and French."}$j$,
 'ep12-paises-nacionalidades', 'estudio', true)

on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;

-- ============================================================
-- EJERCICIOS — TEMA 2: ep12-restaurante-vocabulario
-- ============================================================
-- ── Lección (8) ──
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('ep12-rvoc-01', 'ep12-restaurante-vocabulario', 1, 'elegir',
 $j${"frase":"The person who serves food at a restaurant is a ___.","opciones":["waiter","chef","cashier","host"],"correcta":0,"es":"La persona que sirve la comida en un restaurante es un ___.","explicacion":"A waiter (or waitress) serves food to customers at their tables."}$j$,
 'ep12-restaurante-vocabulario', 'estudio', false),

('ep12-rvoc-02', 'ep12-restaurante-vocabulario', 2, 'emparejar',
 $j${"pares":[["menu","carta / menú"],["tip","propina"],["bill","cuenta"],["appetizer","entrada"]],"es":"","explicacion":"Key restaurant vocabulary paired with Spanish translations."}$j$,
 'ep12-restaurante-vocabulario', 'estudio', false),

('ep12-rvoc-03', 'ep12-restaurante-vocabulario', 3, 'escribir',
 $j${"respuestas":["dessert"],"mostrar":"After the main course, we usually have ___.","es":"Después del plato principal, normalmente tenemos ___.","explicacion":"Dessert is the sweet course served at the end of a meal."}$j$,
 'ep12-restaurante-vocabulario', 'estudio', false),

('ep12-rvoc-04', 'ep12-restaurante-vocabulario', 4, 'ordenar',
 $j${"frase":"Can I see the menu , please ?","es":"¿Puedo ver el menú, por favor?","explicacion":"A polite way to ask for the menu at a restaurant."}$j$,
 'ep12-restaurante-vocabulario', 'estudio', false),

('ep12-rvoc-05', 'ep12-restaurante-vocabulario', 5, 'escuchar',
 $j${"opciones":["I would like a glass of water.","I would like a cup of coffee.","I would like a piece of cake.","I would like a bowl of soup."],"correcta":0,"audio":"I would like a glass of water.","es":"Me gustaría un vaso de agua.","explicacion":"Listen for 'glass of water'."}$j$,
 'ep12-restaurante-vocabulario', 'estudio', false),

('ep12-rvoc-06', 'ep12-restaurante-vocabulario', 6, 'dictado',
 $j${"audio":"The main course is grilled chicken.","respuestas":["The main course is grilled chicken.","The main course is grilled chicken"],"mostrar":"The main course is ___.","es":"El plato principal es pollo a la parrilla.","explicacion":"'Main course' is the principal dish of a meal."}$j$,
 'ep12-restaurante-vocabulario', 'estudio', false),

('ep12-rvoc-07', 'ep12-restaurante-vocabulario', 7, 'elegir',
 $j${"frase":"A ___ is a list of food and drinks available at a restaurant.","opciones":["menu","recipe","bill","order"],"correcta":0,"es":"Un ___ es una lista de comidas y bebidas disponibles en un restaurante.","explicacion":"A menu lists all the dishes and drinks you can order."}$j$,
 'ep12-restaurante-vocabulario', 'estudio', false),

('ep12-rvoc-08', 'ep12-restaurante-vocabulario', 8, 'escribir',
 $j${"respuestas":["tip","a tip"],"mostrar":"After the meal, we leave a ___ for the waiter.","es":"Después de la comida, dejamos una ___ para el mesero.","explicacion":"A tip is extra money you leave for good service."}$j$,
 'ep12-restaurante-vocabulario', 'estudio', false),

-- ── Banco (8) ──
('banco-ep12-rvoc-01', 'banco-ep12', 9, 'comprension',
 $j${"modo":"leer","lineas":[{"en":"Welcome to Luigi's! Here is your menu.","es":"¡Bienvenido a Luigi's! Aquí está su menú."},{"en":"Today's special is grilled salmon with vegetables.","es":"El especial de hoy es salmón a la parrilla con vegetales."},{"en":"For dessert, we have chocolate cake and ice cream.","es":"De postre, tenemos torta de chocolate y helado."}],"pregunta":"What is today's special?","pregunta_es":"¿Cuál es el especial de hoy?","opciones":["Grilled salmon","Chocolate cake","Ice cream","Grilled chicken"],"correcta":0,"explicacion":"The text says 'Today's special is grilled salmon with vegetables'."}$j$,
 'ep12-restaurante-vocabulario', 'input', false),

('banco-ep12-rvoc-02', 'banco-ep12', 10, 'comprension',
 $j${"modo":"leer","lineas":[{"en":"For appetizers, we have soup and salad.","es":"De entradas, tenemos sopa y ensalada."},{"en":"The main courses include pasta, steak, and fish.","es":"Los platos principales incluyen pasta, bistec y pescado."},{"en":"All meals come with a drink.","es":"Todas las comidas incluyen una bebida."}],"pregunta":"What comes with every meal?","pregunta_es":"¿Qué viene con cada comida?","opciones":["A drink","A dessert","Bread","Soup"],"correcta":0,"explicacion":"'All meals come with a drink'."}$j$,
 'ep12-restaurante-vocabulario', 'input', false),

('banco-ep12-rvoc-03', 'banco-ep12', 11, 'decir',
 $j${"es":"Di: Me gustaría ver el menú, por favor.","respuestas":["I would like to see the menu, please.","I'd like to see the menu, please."],"mostrar":"I would like to see the menu, please.","explicacion":"Use 'I would like to' for polite requests."}$j$,
 'ep12-restaurante-vocabulario', 'output', false),

('banco-ep12-rvoc-04', 'banco-ep12', 12, 'decir',
 $j${"es":"Di: ¿Nos puede traer la cuenta?","respuestas":["Can we have the bill, please?","Could we have the bill, please?","Can we get the check, please?"],"mostrar":"Can we have the bill, please?","explicacion":"'Bill' (UK) or 'check' (US) means the total to pay."}$j$,
 'ep12-restaurante-vocabulario', 'output', false),

('banco-ep12-rvoc-05', 'banco-ep12', 13, 'libre',
 $j${"pregunta":"Describe your favorite restaurant. What kind of food do they serve? What do you usually order?","pregunta_es":"Describe tu restaurante favorito. ¿Qué tipo de comida sirven? ¿Qué pides normalmente?","ejemplo":"My favorite restaurant is an Italian place. They serve pasta and pizza. I usually order spaghetti."}$j$,
 'ep12-restaurante-vocabulario', 'output', false),

('banco-ep12-rvoc-06', 'banco-ep12', 14, 'rapido',
 $j${"frase":"The person who cooks food in a restaurant is the ___.","opciones":["chef","waiter","cashier","manager"],"correcta":0,"es":"La persona que cocina en un restaurante es el ___.","explicacion":"A chef is the professional cook in a restaurant.","segundos":5}$j$,
 'ep12-restaurante-vocabulario', 'fluidez', false),

('banco-ep12-rvoc-07', 'banco-ep12', 15, 'rapido',
 $j${"frase":"You leave a ___ for the waiter after a meal.","opciones":["tip","bill","menu","receipt"],"correcta":0,"es":"Dejas una ___ para el mesero después de comer.","explicacion":"A tip is an extra payment for good service.","segundos":5}$j$,
 'ep12-restaurante-vocabulario', 'fluidez', false),

('banco-ep12-rvoc-08', 'banco-ep12', 16, 'rapido',
 $j${"frase":"The sweet course at the end of a meal is ___.","opciones":["dessert","desert","appetizer","side dish"],"correcta":0,"es":"El curso dulce al final de la comida es ___.","explicacion":"Dessert (double s) is the sweet course. Desert (one s) is a dry place.","segundos":5}$j$,
 'ep12-restaurante-vocabulario', 'fluidez', false),

-- ── Examen (3) ──
('examen-ep12-rvoc-01', 'examen-ep12', 4, 'elegir',
 $j${"frase":"The ___ brings your food to the table.","opciones":["waiter","chef","manager","customer"],"correcta":0,"es":"El ___ trae tu comida a la mesa.","explicacion":"A waiter serves food to customers."}$j$,
 'ep12-restaurante-vocabulario', 'estudio', true),

('examen-ep12-rvoc-02', 'examen-ep12', 5, 'escribir',
 $j${"respuestas":["bill","the bill","check","the check"],"mostrar":"At the end of the meal, the waiter brings the ___.","es":"Al final de la comida, el mesero trae la ___.","explicacion":"The bill (UK) or check (US) is what you pay."}$j$,
 'ep12-restaurante-vocabulario', 'estudio', true),

('examen-ep12-rvoc-03', 'examen-ep12', 6, 'elegir',
 $j${"frase":"A ___ is a small dish served before the main course.","opciones":["appetizer","dessert","side dish","beverage"],"correcta":0,"es":"Una ___ es un plato pequeño servido antes del plato principal.","explicacion":"An appetizer (or starter) comes before the main course."}$j$,
 'ep12-restaurante-vocabulario', 'estudio', true)

on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;

-- ============================================================
-- EJERCICIOS — TEMA 3: ep12-restaurante-pedir
-- ============================================================
-- ── Lección (8) ──
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('ep12-rped-01', 'ep12-restaurante-pedir', 1, 'elegir',
 $j${"frase":"___ I have a glass of water, please?","opciones":["Could","Would","Should","Must"],"correcta":0,"es":"___ darme un vaso de agua, por favor?","explicacion":"'Could I have...' is a polite way to order something."}$j$,
 'ep12-restaurante-pedir', 'estudio', false),

('ep12-rped-02', 'ep12-restaurante-pedir', 2, 'emparejar',
 $j${"pares":[["I'd like...","Me gustaría..."],["Could I have...","¿Podría darme..."],["I'll have...","Voy a pedir..."],["For me...","Para mí..."]],"es":"","explicacion":"Different ways to place an order at a restaurant."}$j$,
 'ep12-restaurante-pedir', 'estudio', false),

('ep12-rped-03', 'ep12-restaurante-pedir', 3, 'escribir',
 $j${"respuestas":["I would like","I'd like"],"mostrar":"___ the chicken, please.","es":"Me gustaría el pollo, por favor.","explicacion":"'I would like' or 'I'd like' are polite ways to order."}$j$,
 'ep12-restaurante-pedir', 'estudio', false),

('ep12-rped-04', 'ep12-restaurante-pedir', 4, 'ordenar',
 $j${"frase":"I would like the steak , please .","es":"Me gustaría el bistec, por favor.","explicacion":"A polite way to order food at a restaurant."}$j$,
 'ep12-restaurante-pedir', 'estudio', false),

('ep12-rped-05', 'ep12-restaurante-pedir', 5, 'escuchar',
 $j${"opciones":["Could I have the pasta, please?","I will have the soup.","I want the salad.","Give me the fish."],"correcta":0,"audio":"Could I have the pasta, please?","es":"¿Podría darme la pasta, por favor?","explicacion":"'Could I have...' is the most polite option."}$j$,
 'ep12-restaurante-pedir', 'estudio', false),

('ep12-rped-06', 'ep12-restaurante-pedir', 6, 'dictado',
 $j${"audio":"Are you ready to order?","respuestas":["Are you ready to order?","Are you ready to order"],"mostrar":"___ to order?","es":"¿Están listos para ordenar?","explicacion":"The waiter asks this when it's time to take your order."}$j$,
 'ep12-restaurante-pedir', 'estudio', false),

('ep12-rped-07', 'ep12-restaurante-pedir', 7, 'elegir',
 $j${"frase":"Waiter: Anything else? You: No, ___.","opciones":["that's all, thank you","I don't want","nothing more","stop"],"correcta":0,"es":"Mesero: ¿Algo más? Tú: No, ___.","explicacion":"'That's all, thank you' is a polite way to finish ordering."}$j$,
 'ep12-restaurante-pedir', 'estudio', false),

('ep12-rped-08', 'ep12-restaurante-pedir', 8, 'escribir',
 $j${"respuestas":["the bill","the check"],"mostrar":"Could I have ___, please?","es":"¿Podría darme la cuenta, por favor?","explicacion":"Ask for 'the bill' (UK) or 'the check' (US) when you want to pay."}$j$,
 'ep12-restaurante-pedir', 'estudio', false),

-- ── Banco (8) ──
('banco-ep12-rped-01', 'banco-ep12', 17, 'comprension',
 $j${"modo":"leer","lineas":[{"en":"Waiter: Good evening. Are you ready to order?","es":"Mesero: Buenas noches. ¿Están listos para ordenar?"},{"en":"Customer: Yes, I'd like the grilled fish, please.","es":"Cliente: Sí, me gustaría el pescado a la parrilla, por favor."},{"en":"Waiter: Would you like anything to drink?","es":"Mesero: ¿Le gustaría algo de tomar?"},{"en":"Customer: Just water, please.","es":"Cliente: Solo agua, por favor."}],"pregunta":"What did the customer order to eat?","pregunta_es":"¿Qué pidió el cliente de comer?","opciones":["Grilled fish","Grilled chicken","Pasta","Steak"],"correcta":0,"explicacion":"The customer said 'I'd like the grilled fish'."}$j$,
 'ep12-restaurante-pedir', 'input', false),

('banco-ep12-rped-02', 'banco-ep12', 18, 'comprension',
 $j${"modo":"leer","lineas":[{"en":"Could I have the soup as an appetizer?","es":"¿Podría darme la sopa como entrada?"},{"en":"And for the main course, I'll have the steak.","es":"Y de plato principal, voy a pedir el bistec."},{"en":"Medium rare, please.","es":"Término medio, por favor."}],"pregunta":"How does the customer want the steak cooked?","pregunta_es":"¿Cómo quiere el cliente que cocinen el bistec?","opciones":["Medium rare","Well done","Rare","Medium"],"correcta":0,"explicacion":"The customer says 'Medium rare, please'."}$j$,
 'ep12-restaurante-pedir', 'input', false),

('banco-ep12-rped-03', 'banco-ep12', 19, 'decir',
 $j${"es":"Di: Me gustaría el salmón, por favor.","respuestas":["I would like the salmon, please.","I'd like the salmon, please."],"mostrar":"I would like the salmon, please.","explicacion":"Use 'I would like' for polite ordering."}$j$,
 'ep12-restaurante-pedir', 'output', false),

('banco-ep12-rped-04', 'banco-ep12', 20, 'decir',
 $j${"es":"Di: ¿Podría darme más pan, por favor?","respuestas":["Could I have more bread, please?","Can I have more bread, please?"],"mostrar":"Could I have more bread, please?","explicacion":"'Could I have...' for polite requests."}$j$,
 'ep12-restaurante-pedir', 'output', false),

('banco-ep12-rped-05', 'banco-ep12', 21, 'libre',
 $j${"pregunta":"Imagine you are at a restaurant. Order a full meal: appetizer, main course, drink, and dessert.","pregunta_es":"Imagina que estás en un restaurante. Pide una comida completa: entrada, plato principal, bebida y postre.","ejemplo":"I'd like the soup as an appetizer. For the main course, I'll have the steak. I'd like a Coke to drink. And for dessert, chocolate cake, please."}$j$,
 'ep12-restaurante-pedir', 'output', false),

('banco-ep12-rped-06', 'banco-ep12', 22, 'rapido',
 $j${"frase":"A polite way to order: ___ the pasta, please.","opciones":["I'd like","Give me","I want","Bring"],"correcta":0,"es":"Una forma educada de pedir: ___ la pasta, por favor.","explicacion":"'I'd like' is the most polite option.","segundos":5}$j$,
 'ep12-restaurante-pedir', 'fluidez', false),

('banco-ep12-rped-07', 'banco-ep12', 23, 'rapido',
 $j${"frase":"Waiter: Would you like a drink? You: Yes, ___ a coffee.","opciones":["I'll have","Give me","I want","Bring me"],"correcta":0,"es":"Mesero: ¿Le gustaría una bebida? Tú: Sí, ___ un café.","explicacion":"'I'll have' is a natural and polite response.","segundos":5}$j$,
 'ep12-restaurante-pedir', 'fluidez', false),

('banco-ep12-rped-08', 'banco-ep12', 24, 'rapido',
 $j${"frase":"No more, ___, thank you.","opciones":["that's all","stop it","I'm done","enough"],"correcta":0,"es":"Nada más, ___, gracias.","explicacion":"'That's all' is the standard polite phrase to finish ordering.","segundos":5}$j$,
 'ep12-restaurante-pedir', 'fluidez', false),

-- ── Examen (3) ──
('examen-ep12-rped-01', 'examen-ep12', 7, 'elegir',
 $j${"frase":"___ I have the soup, please?","opciones":["Could","Would","Should","Must"],"correcta":0,"es":"¿___ darme la sopa, por favor?","explicacion":"'Could I have...' is the polite ordering form."}$j$,
 'ep12-restaurante-pedir', 'estudio', true),

('examen-ep12-rped-02', 'examen-ep12', 8, 'escribir',
 $j${"respuestas":["I would like","I'd like"],"mostrar":"___ the chicken salad, please.","es":"Me gustaría la ensalada de pollo, por favor.","explicacion":"'I would like' or 'I'd like' for polite orders."}$j$,
 'ep12-restaurante-pedir', 'estudio', true),

('examen-ep12-rped-03', 'examen-ep12', 9, 'elegir',
 $j${"frase":"Waiter: Anything else? Customer: No, ___.","opciones":["that's all, thank you","I don't want more","nothing","stop"],"correcta":0,"es":"Mesero: ¿Algo más? Cliente: No, ___.","explicacion":"'That's all, thank you' is the polite closure."}$j$,
 'ep12-restaurante-pedir', 'estudio', true)

on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;

-- ============================================================
-- EJERCICIOS — TEMA 4: ep12-restaurante-conversacion
-- ============================================================
-- ── Lección (8) ──
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('ep12-rcon-01', 'ep12-restaurante-conversacion', 1, 'elegir',
 $j${"frase":"Waiter: How is everything? Customer: It's ___, thank you.","opciones":["delicious","delicate","deleted","delivered"],"correcta":0,"es":"Mesero: ¿Cómo está todo? Cliente: Está ___, gracias.","explicacion":"'Delicious' means the food tastes very good."}$j$,
 'ep12-restaurante-conversacion', 'estudio', false),

('ep12-rcon-02', 'ep12-restaurante-conversacion', 2, 'emparejar',
 $j${"pares":[["How is everything?","¿Cómo está todo?"],["The food is delicious.","La comida está deliciosa."],["Could we have the bill?","¿Nos trae la cuenta?"],["We'd like a table for two.","Quisiéramos una mesa para dos."]],"es":"","explicacion":"Common restaurant conversation phrases."}$j$,
 'ep12-restaurante-conversacion', 'estudio', false),

('ep12-rcon-03', 'ep12-restaurante-conversacion', 3, 'escribir',
 $j${"respuestas":["table for two","a table for two"],"mostrar":"We'd like a ___, please.","es":"Quisiéramos una mesa para dos, por favor.","explicacion":"'A table for two' means a table for two people."}$j$,
 'ep12-restaurante-conversacion', 'estudio', false),

('ep12-rcon-04', 'ep12-restaurante-conversacion', 4, 'ordenar',
 $j${"frase":"We would like a table for four , please .","es":"Quisiéramos una mesa para cuatro, por favor.","explicacion":"Use 'We would like' to request a table politely."}$j$,
 'ep12-restaurante-conversacion', 'estudio', false),

('ep12-rcon-05', 'ep12-restaurante-conversacion', 5, 'escuchar',
 $j${"opciones":["Do you have a reservation?","Do you have a menu?","Do you have a napkin?","Do you have a fork?"],"correcta":0,"audio":"Do you have a reservation?","es":"¿Tiene una reservación?","explicacion":"The host asks this when you arrive at a restaurant."}$j$,
 'ep12-restaurante-conversacion', 'estudio', false),

('ep12-rcon-06', 'ep12-restaurante-conversacion', 6, 'dictado',
 $j${"audio":"Everything was wonderful, thank you.","respuestas":["Everything was wonderful, thank you.","Everything was wonderful, thank you","Everything was wonderful thank you"],"mostrar":"Everything was ___, thank you.","es":"Todo estuvo maravilloso, gracias.","explicacion":"'Wonderful' expresses high satisfaction with the meal."}$j$,
 'ep12-restaurante-conversacion', 'estudio', false),

('ep12-rcon-07', 'ep12-restaurante-conversacion', 7, 'elegir',
 $j${"frase":"Customer: Can I ___ by card? Waiter: Of course.","opciones":["pay","buy","give","take"],"correcta":0,"es":"Cliente: ¿Puedo ___ con tarjeta? Mesero: Por supuesto.","explicacion":"'Pay by card' means using a credit or debit card."}$j$,
 'ep12-restaurante-conversacion', 'estudio', false),

('ep12-rcon-08', 'ep12-restaurante-conversacion', 8, 'escribir',
 $j${"respuestas":["reservation"],"mostrar":"I have a ___ for 7 o'clock.","es":"Tengo una ___ para las 7.","explicacion":"A reservation is a booking you make in advance at a restaurant."}$j$,
 'ep12-restaurante-conversacion', 'estudio', false),

-- ── Banco (8) ──
('banco-ep12-rcon-01', 'banco-ep12', 25, 'comprension',
 $j${"modo":"leer","lineas":[{"en":"Host: Good evening! Do you have a reservation?","es":"Anfitrión: ¡Buenas noches! ¿Tienen una reservación?"},{"en":"Customer: Yes, under the name Martinez.","es":"Cliente: Sí, a nombre de Martínez."},{"en":"Host: Right this way, please. Here is your table.","es":"Anfitrión: Por aquí, por favor. Aquí está su mesa."},{"en":"Customer: Thank you. Could we see the menu?","es":"Cliente: Gracias. ¿Podríamos ver el menú?"}],"pregunta":"What is the reservation name?","pregunta_es":"¿A qué nombre está la reservación?","opciones":["Martinez","Garcia","Lopez","Rodriguez"],"correcta":0,"explicacion":"The customer says 'under the name Martinez'."}$j$,
 'ep12-restaurante-conversacion', 'input', false),

('banco-ep12-rcon-02', 'banco-ep12', 26, 'comprension',
 $j${"modo":"leer","lineas":[{"en":"Waiter: How was everything?","es":"Mesero: ¿Cómo estuvo todo?"},{"en":"Customer: The food was excellent!","es":"Cliente: ¡La comida estuvo excelente!"},{"en":"Waiter: Would you like dessert?","es":"Mesero: ¿Les gustaría postre?"},{"en":"Customer: No thanks, just the bill, please.","es":"Cliente: No gracias, solo la cuenta, por favor."}],"pregunta":"Does the customer want dessert?","pregunta_es":"¿El cliente quiere postre?","opciones":["No","Yes","Maybe","He doesn't say"],"correcta":0,"explicacion":"The customer says 'No thanks, just the bill'."}$j$,
 'ep12-restaurante-conversacion', 'input', false),

('banco-ep12-rcon-03', 'banco-ep12', 27, 'decir',
 $j${"es":"Di: Quisiéramos una mesa para tres, por favor.","respuestas":["We would like a table for three, please.","We'd like a table for three, please."],"mostrar":"We would like a table for three, please.","explicacion":"Use 'We would like' for polite requests."}$j$,
 'ep12-restaurante-conversacion', 'output', false),

('banco-ep12-rcon-04', 'banco-ep12', 28, 'decir',
 $j${"es":"Di: La comida estuvo deliciosa.","respuestas":["The food was delicious."],"mostrar":"The food was delicious.","explicacion":"Use past tense 'was' to describe the completed meal."}$j$,
 'ep12-restaurante-conversacion', 'output', false),

('banco-ep12-rcon-05', 'banco-ep12', 29, 'libre',
 $j${"pregunta":"Write a short conversation between a waiter and a customer. Include greeting, ordering, and paying.","pregunta_es":"Escribe una conversación corta entre un mesero y un cliente. Incluye saludo, pedido y pago.","ejemplo":"Waiter: Good evening. Are you ready to order? Customer: Yes, I'd like the pasta, please. Waiter: Anything to drink? Customer: A glass of juice, please. ... Customer: Could I have the bill?"}$j$,
 'ep12-restaurante-conversacion', 'output', false),

('banco-ep12-rcon-06', 'banco-ep12', 30, 'rapido',
 $j${"frase":"Host: Do you have a ___?","opciones":["reservation","menu","tip","bill"],"correcta":0,"es":"Anfitrión: ¿Tiene una ___?","explicacion":"The host asks about your reservation when you arrive.","segundos":5}$j$,
 'ep12-restaurante-conversacion', 'fluidez', false),

('banco-ep12-rcon-07', 'banco-ep12', 31, 'rapido',
 $j${"frase":"The food was ___! I loved it.","opciones":["delicious","disgusting","cold","raw"],"correcta":0,"es":"¡La comida estuvo ___! Me encantó.","explicacion":"'Delicious' matches 'I loved it'.","segundos":5}$j$,
 'ep12-restaurante-conversacion', 'fluidez', false),

('banco-ep12-rcon-08', 'banco-ep12', 32, 'rapido',
 $j${"frase":"Can I ___ by card?","opciones":["pay","buy","give","take"],"correcta":0,"es":"¿Puedo ___ con tarjeta?","explicacion":"'Pay by card' is the correct expression.","segundos":5}$j$,
 'ep12-restaurante-conversacion', 'fluidez', false),

-- ── Examen (3) ──
('examen-ep12-rcon-01', 'examen-ep12', 10, 'elegir',
 $j${"frase":"Waiter: How is everything? Customer: ___, thank you.","opciones":["It's delicious","It's delicate","It's deleted","It's delivered"],"correcta":0,"es":"Mesero: ¿Cómo está todo? Cliente: ___, gracias.","explicacion":"'Delicious' means the food tastes great."}$j$,
 'ep12-restaurante-conversacion', 'estudio', true),

('examen-ep12-rcon-02', 'examen-ep12', 11, 'escribir',
 $j${"respuestas":["reservation"],"mostrar":"Do you have a ___?","es":"¿Tiene una reservación?","explicacion":"A reservation is a booking at a restaurant."}$j$,
 'ep12-restaurante-conversacion', 'estudio', true),

('examen-ep12-rcon-03', 'examen-ep12', 12, 'elegir',
 $j${"frase":"We'd like a ___ for two, please.","opciones":["table","chair","menu","bill"],"correcta":0,"es":"Quisiéramos una ___ para dos, por favor.","explicacion":"You request a table when arriving at a restaurant."}$j$,
 'ep12-restaurante-conversacion', 'estudio', true)

on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;

-- ============================================================
-- EJERCICIOS — TEMA 5: ep12-will-vs-going-to
-- ============================================================
-- ── Lección (8) ──
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('ep12-wvg-01', 'ep12-will-vs-going-to', 1, 'elegir',
 $j${"frase":"Look at those dark clouds! It ___ rain.","opciones":["is going to","will","shall","would"],"correcta":0,"es":"¡Mira esas nubes oscuras! ___ a llover.","explicacion":"Use 'going to' for predictions based on present evidence (the dark clouds)."}$j$,
 'ep12-will-vs-going-to', 'estudio', false),

('ep12-wvg-02', 'ep12-will-vs-going-to', 2, 'emparejar',
 $j${"pares":[["I'll help you.","Decisión espontánea"],["I'm going to study medicine.","Plan ya decidido"],["It will rain tomorrow.","Predicción sin evidencia"],["Look! She's going to fall!","Predicción con evidencia"]],"es":"","explicacion":"Will = spontaneous decisions and predictions without evidence. Going to = plans and evidence-based predictions."}$j$,
 'ep12-will-vs-going-to', 'estudio', false),

('ep12-wvg-03', 'ep12-will-vs-going-to', 3, 'escribir',
 $j${"respuestas":["will"],"mostrar":"The phone is ringing. I ___ answer it.","es":"El teléfono está sonando. Yo ___ contestar.","explicacion":"Use 'will' for spontaneous decisions made at the moment."}$j$,
 'ep12-will-vs-going-to', 'estudio', false),

('ep12-wvg-04', 'ep12-will-vs-going-to', 4, 'ordenar',
 $j${"frase":"I am going to visit my parents this weekend .","es":"Voy a visitar a mis padres este fin de semana.","explicacion":"Use 'going to' for a plan already decided before speaking."}$j$,
 'ep12-will-vs-going-to', 'estudio', false),

('ep12-wvg-05', 'ep12-will-vs-going-to', 5, 'escuchar',
 $j${"opciones":["I think it will be sunny tomorrow.","I think it is going to be sunny.","It is sunny now.","It was sunny yesterday."],"correcta":0,"audio":"I think it will be sunny tomorrow.","es":"Creo que estará soleado mañana.","explicacion":"Use 'will' for predictions based on opinion ('I think')."}$j$,
 'ep12-will-vs-going-to', 'estudio', false),

('ep12-wvg-06', 'ep12-will-vs-going-to', 6, 'dictado',
 $j${"audio":"She is going to have a baby.","respuestas":["She is going to have a baby.","She is going to have a baby","She's going to have a baby."],"mostrar":"She ___ have a baby.","es":"Ella va a tener un bebé.","explicacion":"Use 'going to' for a certain future based on present evidence/knowledge."}$j$,
 'ep12-will-vs-going-to', 'estudio', false),

('ep12-wvg-07', 'ep12-will-vs-going-to', 7, 'elegir',
 $j${"frase":"I'm tired. I think I ___ go to bed early.","opciones":["will","am going to","shall","would"],"correcta":0,"es":"Estoy cansado. Creo que ___ acostarme temprano.","explicacion":"Use 'will' for a decision made at the moment of speaking."}$j$,
 'ep12-will-vs-going-to', 'estudio', false),

('ep12-wvg-08', 'ep12-will-vs-going-to', 8, 'escribir',
 $j${"respuestas":["am going to","'m going to"],"mostrar":"I ___ start a new job next month. (plan)","es":"Voy a empezar un nuevo trabajo el próximo mes.","explicacion":"Use 'going to' for a plan already decided."}$j$,
 'ep12-will-vs-going-to', 'estudio', false),

-- ── Banco (8) ──
('banco-ep12-wvg-01', 'banco-ep12', 33, 'comprension',
 $j${"modo":"leer","lineas":[{"en":"A: What are your plans for the summer?","es":"A: ¿Cuáles son tus planes para el verano?"},{"en":"B: I'm going to travel to Europe. I already bought the tickets.","es":"B: Voy a viajar a Europa. Ya compré los boletos."},{"en":"A: That sounds great! I think I'll stay home and rest.","es":"A: ¡Suena genial! Creo que me quedaré en casa y descansaré."}],"pregunta":"Who has already made plans?","pregunta_es":"¿Quién ya tiene planes hechos?","opciones":["Person B","Person A","Both","Neither"],"correcta":0,"explicacion":"Person B uses 'going to' and says 'I already bought the tickets' — a firm plan."}$j$,
 'ep12-will-vs-going-to', 'input', false),

('banco-ep12-wvg-02', 'banco-ep12', 34, 'comprension',
 $j${"modo":"leer","lineas":[{"en":"Look at that car! It's going too fast.","es":"¡Mira ese carro! Va muy rápido."},{"en":"It's going to crash!","es":"¡Va a chocar!"},{"en":"Oh no! Call 911. I'll call an ambulance.","es":"¡Oh no! Llama al 911. Yo llamaré una ambulancia."}],"pregunta":"Why does the speaker use 'going to crash'?","pregunta_es":"¿Por qué el hablante usa 'going to crash'?","opciones":["Evidence-based prediction","A planned event","A spontaneous decision","A promise"],"correcta":0,"explicacion":"'Going to' is used because there is visible evidence (the car going too fast)."}$j$,
 'ep12-will-vs-going-to', 'input', false),

('banco-ep12-wvg-03', 'banco-ep12', 35, 'decir',
 $j${"es":"Di: Creo que lloverá mañana.","respuestas":["I think it will rain tomorrow."],"mostrar":"I think it will rain tomorrow.","explicacion":"Use 'will' for predictions based on opinion."}$j$,
 'ep12-will-vs-going-to', 'output', false),

('banco-ep12-wvg-04', 'banco-ep12', 36, 'decir',
 $j${"es":"Di: Voy a estudiar inglés esta noche. (plan)","respuestas":["I am going to study English tonight.","I'm going to study English tonight."],"mostrar":"I am going to study English tonight.","explicacion":"Use 'going to' for a plan already decided."}$j$,
 'ep12-will-vs-going-to', 'output', false),

('banco-ep12-wvg-05', 'banco-ep12', 37, 'libre',
 $j${"pregunta":"Tell me three things you are going to do this week (plans) and one thing you think will happen (prediction).","pregunta_es":"Dime tres cosas que vas a hacer esta semana (planes) y una cosa que crees que pasará (predicción).","ejemplo":"I am going to study English on Monday. I am going to work on Tuesday. I am going to visit my mom on Friday. I think it will be cold this week."}$j$,
 'ep12-will-vs-going-to', 'output', false),

('banco-ep12-wvg-06', 'banco-ep12', 38, 'rapido',
 $j${"frase":"The phone is ringing. I ___ get it.","opciones":["will","am going to","was going to","have"],"correcta":0,"es":"El teléfono suena. Yo ___ contestar.","explicacion":"Spontaneous decision → will.","segundos":5}$j$,
 'ep12-will-vs-going-to', 'fluidez', false),

('banco-ep12-wvg-07', 'banco-ep12', 39, 'rapido',
 $j${"frase":"She bought a dress. She ___ go to a party.","opciones":["is going to","will","shall","would"],"correcta":0,"es":"Ella compró un vestido. ___ ir a una fiesta.","explicacion":"Plan already made (evidence: bought a dress) → going to.","segundos":5}$j$,
 'ep12-will-vs-going-to', 'fluidez', false),

('banco-ep12-wvg-08', 'banco-ep12', 40, 'rapido',
 $j${"frase":"I think Brazil ___ win the World Cup.","opciones":["will","is going to","shall","has"],"correcta":0,"es":"Creo que Brasil ___ ganar el Mundial.","explicacion":"Opinion/prediction without evidence → will (after 'I think').","segundos":5}$j$,
 'ep12-will-vs-going-to', 'fluidez', false),

-- ── Examen (3) ──
('examen-ep12-wvg-01', 'examen-ep12', 13, 'elegir',
 $j${"frase":"Look! The bus ___ leave without us!","opciones":["is going to","will","shall","would"],"correcta":0,"es":"¡Mira! El bus nos ___ dejar.","explicacion":"Evidence-based prediction (you can see it) → going to."}$j$,
 'ep12-will-vs-going-to', 'estudio', true),

('examen-ep12-wvg-02', 'examen-ep12', 14, 'escribir',
 $j${"respuestas":["will"],"mostrar":"Don't worry, I ___ help you with that.","es":"No te preocupes, yo te ___ ayudar con eso.","explicacion":"Spontaneous offer/decision → will."}$j$,
 'ep12-will-vs-going-to', 'estudio', true),

('examen-ep12-wvg-03', 'examen-ep12', 15, 'elegir',
 $j${"frase":"We ___ move to a new apartment next month. We already signed the contract.","opciones":["are going to","will","shall","would"],"correcta":0,"es":"Nos ___ mudar a un apartamento nuevo el próximo mes. Ya firmamos el contrato.","explicacion":"Pre-decided plan (signed contract) → going to."}$j$,
 'ep12-will-vs-going-to', 'estudio', true)

on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;

-- ============================================================
-- EJERCICIOS — TEMA 6: ep12-pasado-progresivo
-- ============================================================
-- ── Lección (8) ──
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('ep12-ppro-01', 'ep12-pasado-progresivo', 1, 'elegir',
 $j${"frase":"I ___ watching TV when you called.","opciones":["was","were","am","is"],"correcta":0,"es":"Yo ___ viendo televisión cuando llamaste.","explicacion":"Use 'was' + -ing with I/he/she/it for the past progressive."}$j$,
 'ep12-pasado-progresivo', 'estudio', false),

('ep12-ppro-02', 'ep12-pasado-progresivo', 2, 'emparejar',
 $j${"pares":[["I was eating","Yo estaba comiendo"],["They were sleeping","Ellos estaban durmiendo"],["She was reading","Ella estaba leyendo"],["We were studying","Nosotros estábamos estudiando"]],"es":"","explicacion":"Past progressive: was/were + verb-ing."}$j$,
 'ep12-pasado-progresivo', 'estudio', false),

('ep12-ppro-03', 'ep12-pasado-progresivo', 3, 'escribir',
 $j${"respuestas":["were playing"],"mostrar":"The children ___ in the park when it started to rain.","es":"Los niños ___ en el parque cuando empezó a llover.","explicacion":"Use 'were' + -ing with they/we/you for the past progressive."}$j$,
 'ep12-pasado-progresivo', 'estudio', false),

('ep12-ppro-04', 'ep12-pasado-progresivo', 4, 'ordenar',
 $j${"frase":"She was cooking dinner when the phone rang .","es":"Ella estaba cocinando la cena cuando sonó el teléfono.","explicacion":"Past progressive (ongoing action) + simple past (interrupting action)."}$j$,
 'ep12-pasado-progresivo', 'estudio', false),

('ep12-ppro-05', 'ep12-pasado-progresivo', 5, 'escuchar',
 $j${"opciones":["They were dancing at the party.","They danced at the party.","They dance at the party.","They will dance at the party."],"correcta":0,"audio":"They were dancing at the party.","es":"Ellos estaban bailando en la fiesta.","explicacion":"'Were dancing' is the past progressive form."}$j$,
 'ep12-pasado-progresivo', 'estudio', false),

('ep12-ppro-06', 'ep12-pasado-progresivo', 6, 'dictado',
 $j${"audio":"I was sleeping when the alarm went off.","respuestas":["I was sleeping when the alarm went off.","I was sleeping when the alarm went off"],"mostrar":"I was ___ when the alarm ___.","es":"Yo estaba durmiendo cuando sonó la alarma.","explicacion":"Past progressive for the ongoing action, simple past for the interruption."}$j$,
 'ep12-pasado-progresivo', 'estudio', false),

('ep12-ppro-07', 'ep12-pasado-progresivo', 7, 'elegir',
 $j${"frase":"While I ___ studying, my brother was playing video games.","opciones":["was","were","am","is"],"correcta":0,"es":"Mientras yo ___ estudiando, mi hermano estaba jugando videojuegos.","explicacion":"Use 'was' with I/he/she/it. 'While' + past progressive for two simultaneous actions."}$j$,
 'ep12-pasado-progresivo', 'estudio', false),

('ep12-ppro-08', 'ep12-pasado-progresivo', 8, 'escribir',
 $j${"respuestas":["was raining"],"mostrar":"It ___ when I left the house.","es":"Estaba lloviendo cuando salí de la casa.","explicacion":"Use 'was raining' (past progressive) for the background action."}$j$,
 'ep12-pasado-progresivo', 'estudio', false),

-- ── Banco (8) ──
('banco-ep12-ppro-01', 'banco-ep12', 41, 'comprension',
 $j${"modo":"leer","lineas":[{"en":"Last night at 8 PM, I was watching a movie.","es":"Anoche a las 8 PM, estaba viendo una película."},{"en":"My wife was reading a book.","es":"Mi esposa estaba leyendo un libro."},{"en":"The kids were sleeping in their room.","es":"Los niños estaban durmiendo en su cuarto."}],"pregunta":"What was the wife doing at 8 PM?","pregunta_es":"¿Qué estaba haciendo la esposa a las 8 PM?","opciones":["Reading a book","Watching a movie","Sleeping","Cooking"],"correcta":0,"explicacion":"The text says 'My wife was reading a book'."}$j$,
 'ep12-pasado-progresivo', 'input', false),

('banco-ep12-ppro-02', 'banco-ep12', 42, 'comprension',
 $j${"modo":"leer","lineas":[{"en":"I was walking home when I saw an accident.","es":"Estaba caminando a casa cuando vi un accidente."},{"en":"Two cars were going very fast.","es":"Dos carros iban muy rápido."},{"en":"I called the police immediately.","es":"Llamé a la policía inmediatamente."}],"pregunta":"What happened while the speaker was walking?","pregunta_es":"¿Qué pasó mientras el hablante caminaba?","opciones":["He saw an accident","He got lost","He found money","He met a friend"],"correcta":0,"explicacion":"'I was walking... when I saw an accident'."}$j$,
 'ep12-pasado-progresivo', 'input', false),

('banco-ep12-ppro-03', 'banco-ep12', 43, 'decir',
 $j${"es":"Di: Yo estaba durmiendo cuando tú llamaste.","respuestas":["I was sleeping when you called."],"mostrar":"I was sleeping when you called.","explicacion":"Past progressive + simple past for interrupted actions."}$j$,
 'ep12-pasado-progresivo', 'output', false),

('banco-ep12-ppro-04', 'banco-ep12', 44, 'decir',
 $j${"es":"Di: Ellos estaban estudiando toda la noche.","respuestas":["They were studying all night."],"mostrar":"They were studying all night.","explicacion":"Use 'were' + -ing with they for the past progressive."}$j$,
 'ep12-pasado-progresivo', 'output', false),

('banco-ep12-ppro-05', 'banco-ep12', 45, 'libre',
 $j${"pregunta":"What were you doing yesterday at 3 PM? Write 3 sentences about what you and your family were doing.","pregunta_es":"¿Qué estabas haciendo ayer a las 3 PM? Escribe 3 oraciones sobre lo que tú y tu familia estaban haciendo.","ejemplo":"I was working at home. My daughter was doing homework. My wife was cooking dinner."}$j$,
 'ep12-pasado-progresivo', 'output', false),

('banco-ep12-ppro-06', 'banco-ep12', 46, 'rapido',
 $j${"frase":"She ___ cooking when I arrived.","opciones":["was","were","is","are"],"correcta":0,"es":"Ella ___ cocinando cuando llegué.","explicacion":"Use 'was' with she for the past progressive.","segundos":5}$j$,
 'ep12-pasado-progresivo', 'fluidez', false),

('banco-ep12-ppro-07', 'banco-ep12', 47, 'rapido',
 $j${"frase":"We ___ playing soccer at 5 PM.","opciones":["were","was","are","is"],"correcta":0,"es":"Nosotros ___ jugando fútbol a las 5 PM.","explicacion":"Use 'were' with we for the past progressive.","segundos":5}$j$,
 'ep12-pasado-progresivo', 'fluidez', false),

('banco-ep12-ppro-08', 'banco-ep12', 48, 'rapido',
 $j${"frase":"While I was reading, he ___ listening to music.","opciones":["was","were","is","am"],"correcta":0,"es":"Mientras yo leía, él ___ escuchando música.","explicacion":"Use 'was' with he for the past progressive.","segundos":5}$j$,
 'ep12-pasado-progresivo', 'fluidez', false),

-- ── Examen (3) ──
('examen-ep12-ppro-01', 'examen-ep12', 16, 'elegir',
 $j${"frase":"They ___ watching a movie when the power went out.","opciones":["were","was","are","is"],"correcta":0,"es":"Ellos ___ viendo una película cuando se fue la luz.","explicacion":"Use 'were' with they for the past progressive."}$j$,
 'ep12-pasado-progresivo', 'estudio', true),

('examen-ep12-ppro-02', 'examen-ep12', 17, 'escribir',
 $j${"respuestas":["was reading"],"mostrar":"She ___ a book when I called her.","es":"Ella ___ un libro cuando la llamé.","explicacion":"Use 'was' + -ing with she for the past progressive."}$j$,
 'ep12-pasado-progresivo', 'estudio', true),

('examen-ep12-ppro-03', 'examen-ep12', 18, 'elegir',
 $j${"frase":"While we ___ dinner, someone knocked on the door.","opciones":["were having","was having","are having","had"],"correcta":0,"es":"Mientras ___ la cena, alguien tocó la puerta.","explicacion":"Use 'were having' (past progressive) with we."}$j$,
 'ep12-pasado-progresivo', 'estudio', true)

on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;

-- ============================================================
-- EJERCICIOS — TEMA 7: ep12-presente-progresivo-futuro
-- ============================================================
-- ── Lección (8) ──
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('ep12-ppfu-01', 'ep12-presente-progresivo-futuro', 1, 'elegir',
 $j${"frase":"I ___ meeting my friends tonight. (definite plan)","opciones":["am","will","was","have"],"correcta":0,"es":"___ reuniéndome con mis amigos esta noche.","explicacion":"Use present progressive (am/is/are + -ing) for definite future arrangements."}$j$,
 'ep12-presente-progresivo-futuro', 'estudio', false),

('ep12-ppfu-02', 'ep12-presente-progresivo-futuro', 2, 'emparejar',
 $j${"pares":[["I'm flying to Paris tomorrow.","Vuelo a París mañana."],["She's starting a new job on Monday.","Ella empieza un trabajo nuevo el lunes."],["We're having dinner with them tonight.","Cenamos con ellos esta noche."],["They're moving to a new house next week.","Se mudan a una casa nueva la próxima semana."]],"es":"","explicacion":"Present progressive for definite future arrangements."}$j$,
 'ep12-presente-progresivo-futuro', 'estudio', false),

('ep12-ppfu-03', 'ep12-presente-progresivo-futuro', 3, 'escribir',
 $j${"respuestas":["am leaving","'m leaving"],"mostrar":"I ___ for Bogotá tomorrow morning. (definite plan)","es":"Me voy para Bogotá mañana en la mañana.","explicacion":"Use present progressive for a definite arrangement."}$j$,
 'ep12-presente-progresivo-futuro', 'estudio', false),

('ep12-ppfu-04', 'ep12-presente-progresivo-futuro', 4, 'ordenar',
 $j${"frase":"We are having lunch with the boss tomorrow .","es":"Vamos a almorzar con el jefe mañana.","explicacion":"Present progressive for a planned future event."}$j$,
 'ep12-presente-progresivo-futuro', 'estudio', false),

('ep12-ppfu-05', 'ep12-presente-progresivo-futuro', 5, 'escuchar',
 $j${"opciones":["She is meeting her doctor at 3 PM.","She meets her doctor at 3 PM.","She met her doctor at 3 PM.","She will meet her doctor at 3 PM."],"correcta":0,"audio":"She is meeting her doctor at 3 PM.","es":"Ella se reúne con su doctor a las 3 PM.","explicacion":"Present progressive for a fixed future appointment."}$j$,
 'ep12-presente-progresivo-futuro', 'estudio', false),

('ep12-ppfu-06', 'ep12-presente-progresivo-futuro', 6, 'dictado',
 $j${"audio":"They are getting married next June.","respuestas":["They are getting married next June.","They are getting married next June","They're getting married next June."],"mostrar":"They ___ next June.","es":"Ellos se casan en junio próximo.","explicacion":"Use present progressive for a definite arrangement in the future."}$j$,
 'ep12-presente-progresivo-futuro', 'estudio', false),

('ep12-ppfu-07', 'ep12-presente-progresivo-futuro', 7, 'elegir',
 $j${"frase":"What ___ you doing this weekend? (asking about plans)","opciones":["are","will","do","did"],"correcta":0,"es":"¿Qué ___ haciendo este fin de semana?","explicacion":"Use 'are you doing' (present progressive) to ask about definite plans."}$j$,
 'ep12-presente-progresivo-futuro', 'estudio', false),

('ep12-ppfu-08', 'ep12-presente-progresivo-futuro', 8, 'escribir',
 $j${"respuestas":["is coming","'s coming"],"mostrar":"My sister ___ to visit us this Friday.","es":"Mi hermana viene a visitarnos este viernes.","explicacion":"Present progressive for a definite future plan."}$j$,
 'ep12-presente-progresivo-futuro', 'estudio', false),

-- ── Banco (8) ──
('banco-ep12-ppfu-01', 'banco-ep12', 49, 'comprension',
 $j${"modo":"leer","lineas":[{"en":"A: What are you doing tomorrow?","es":"A: ¿Qué vas a hacer mañana?"},{"en":"B: I'm having lunch with my mom. Then I'm going to the gym.","es":"B: Almuerzo con mi mamá. Luego voy al gimnasio."},{"en":"A: Sounds busy! I'm just staying home.","es":"A: ¡Suena ocupado! Yo me quedo en casa."}],"pregunta":"What is Person B doing after lunch?","pregunta_es":"¿Qué va a hacer la persona B después del almuerzo?","opciones":["Going to the gym","Staying home","Going shopping","Working"],"correcta":0,"explicacion":"Person B says 'Then I'm going to the gym'."}$j$,
 'ep12-presente-progresivo-futuro', 'input', false),

('banco-ep12-ppfu-02', 'banco-ep12', 50, 'comprension',
 $j${"modo":"leer","lineas":[{"en":"This Saturday is going to be busy!","es":"¡Este sábado va a estar ocupado!"},{"en":"In the morning, we're visiting grandma.","es":"En la mañana, visitamos a la abuela."},{"en":"In the afternoon, the kids are playing in a soccer match.","es":"En la tarde, los niños juegan un partido de fútbol."},{"en":"In the evening, we're having dinner with friends.","es":"En la noche, cenamos con amigos."}],"pregunta":"When are the kids playing soccer?","pregunta_es":"¿Cuándo juegan los niños fútbol?","opciones":["In the afternoon","In the morning","In the evening","On Sunday"],"correcta":0,"explicacion":"'In the afternoon, the kids are playing in a soccer match'."}$j$,
 'ep12-presente-progresivo-futuro', 'input', false),

('banco-ep12-ppfu-03', 'banco-ep12', 51, 'decir',
 $j${"es":"Di: Vuelo a Miami mañana.","respuestas":["I am flying to Miami tomorrow.","I'm flying to Miami tomorrow."],"mostrar":"I am flying to Miami tomorrow.","explicacion":"Present progressive for a definite arrangement."}$j$,
 'ep12-presente-progresivo-futuro', 'output', false),

('banco-ep12-ppfu-04', 'banco-ep12', 52, 'decir',
 $j${"es":"Di: ¿Qué estás haciendo esta noche?","respuestas":["What are you doing tonight?"],"mostrar":"What are you doing tonight?","explicacion":"Use present progressive to ask about definite plans."}$j$,
 'ep12-presente-progresivo-futuro', 'output', false),

('banco-ep12-ppfu-05', 'banco-ep12', 53, 'libre',
 $j${"pregunta":"Tell me about your plans for this weekend using the present progressive. Write at least 3 sentences.","pregunta_es":"Cuéntame sobre tus planes para este fin de semana usando el presente progresivo. Escribe al menos 3 oraciones.","ejemplo":"On Saturday morning, I'm studying English. In the afternoon, I'm visiting my parents. On Sunday, I'm watching a movie with my family."}$j$,
 'ep12-presente-progresivo-futuro', 'output', false),

('banco-ep12-ppfu-06', 'banco-ep12', 54, 'rapido',
 $j${"frase":"She ___ starting her new job on Monday.","opciones":["is","will","was","has"],"correcta":0,"es":"Ella empieza su nuevo trabajo el lunes.","explicacion":"Present progressive for a definite future arrangement.","segundos":5}$j$,
 'ep12-presente-progresivo-futuro', 'fluidez', false),

('banco-ep12-ppfu-07', 'banco-ep12', 55, 'rapido',
 $j${"frase":"We ___ having a party this Friday.","opciones":["are","will","were","have"],"correcta":0,"es":"Hacemos una fiesta este viernes.","explicacion":"Present progressive for a planned event.","segundos":5}$j$,
 'ep12-presente-progresivo-futuro', 'fluidez', false),

('banco-ep12-ppfu-08', 'banco-ep12', 56, 'rapido',
 $j${"frase":"What ___ you doing after class?","opciones":["are","will","do","did"],"correcta":0,"es":"¿Qué haces después de clase?","explicacion":"Present progressive for future plans.","segundos":5}$j$,
 'ep12-presente-progresivo-futuro', 'fluidez', false),

-- ── Examen (3) ──
('examen-ep12-ppfu-01', 'examen-ep12', 19, 'elegir',
 $j${"frase":"I ___ having dinner with my boss tonight. (arrangement)","opciones":["am","will","was","do"],"correcta":0,"es":"Ceno con mi jefe esta noche.","explicacion":"Present progressive for a definite arrangement."}$j$,
 'ep12-presente-progresivo-futuro', 'estudio', true),

('examen-ep12-ppfu-02', 'examen-ep12', 20, 'escribir',
 $j${"respuestas":["are leaving","'re leaving"],"mostrar":"They ___ for London tomorrow morning.","es":"Ellos salen para Londres mañana en la mañana.","explicacion":"Present progressive for a definite future plan."}$j$,
 'ep12-presente-progresivo-futuro', 'estudio', true),

('examen-ep12-ppfu-03', 'examen-ep12', 21, 'elegir',
 $j${"frase":"___ you coming to the party on Saturday?","opciones":["Are","Will","Do","Did"],"correcta":0,"es":"¿Vienes a la fiesta el sábado?","explicacion":"Present progressive to ask about a fixed plan."}$j$,
 'ep12-presente-progresivo-futuro', 'estudio', true)

on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;

-- ============================================================
-- EJERCICIOS — TEMA 8: ep12-repaso-tiempos
-- ============================================================
-- ── Lección (8) ──
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('ep12-rept-01', 'ep12-repaso-tiempos', 1, 'elegir',
 $j${"frase":"She ___ to work every day. (habitual)","opciones":["goes","is going","went","will go"],"correcta":0,"es":"Ella ___ al trabajo todos los días.","explicacion":"Use simple present for habitual actions ('every day')."}$j$,
 'ep12-repaso-tiempos', 'estudio', false),

('ep12-rept-02', 'ep12-repaso-tiempos', 2, 'emparejar',
 $j${"pares":[["I eat breakfast every day.","Presente simple"],["I am eating breakfast now.","Presente progresivo"],["I ate breakfast this morning.","Pasado simple"],["I have eaten breakfast already.","Presente perfecto"]],"es":"","explicacion":"Each sentence illustrates a different tense."}$j$,
 'ep12-repaso-tiempos', 'estudio', false),

('ep12-rept-03', 'ep12-repaso-tiempos', 3, 'escribir',
 $j${"respuestas":["have visited","have already visited"],"mostrar":"I ___ Paris three times. (experience)","es":"He visitado París tres veces.","explicacion":"Use present perfect for life experiences."}$j$,
 'ep12-repaso-tiempos', 'estudio', false),

('ep12-rept-04', 'ep12-repaso-tiempos', 4, 'ordenar',
 $j${"frase":"She was studying when the lights went out .","es":"Ella estaba estudiando cuando se apagaron las luces.","explicacion":"Past progressive (ongoing) + simple past (interruption)."}$j$,
 'ep12-repaso-tiempos', 'estudio', false),

('ep12-rept-05', 'ep12-repaso-tiempos', 5, 'escuchar',
 $j${"opciones":["I have never been to Japan.","I never went to Japan.","I am never going to Japan.","I was never in Japan."],"correcta":0,"audio":"I have never been to Japan.","es":"Nunca he estado en Japón.","explicacion":"Present perfect with 'never' for experiences."}$j$,
 'ep12-repaso-tiempos', 'estudio', false),

('ep12-rept-06', 'ep12-repaso-tiempos', 6, 'dictado',
 $j${"audio":"We lived in Bogotá for five years.","respuestas":["We lived in Bogotá for five years.","We lived in Bogota for five years.","We lived in Bogotá for five years","We lived in Bogota for five years"],"mostrar":"We ___ in Bogotá for five years.","es":"Vivimos en Bogotá por cinco años.","explicacion":"Simple past for a completed period of time."}$j$,
 'ep12-repaso-tiempos', 'estudio', false),

('ep12-rept-07', 'ep12-repaso-tiempos', 7, 'elegir',
 $j${"frase":"Right now, the children ___ in the garden.","opciones":["are playing","play","played","have played"],"correcta":0,"es":"Ahora mismo, los niños ___ en el jardín.","explicacion":"Use present progressive for actions happening right now."}$j$,
 'ep12-repaso-tiempos', 'estudio', false),

('ep12-rept-08', 'ep12-repaso-tiempos', 8, 'escribir',
 $j${"respuestas":["went"],"mostrar":"We ___ to the beach last weekend.","es":"Fuimos a la playa el fin de semana pasado.","explicacion":"Use simple past for completed actions in the past ('last weekend')."}$j$,
 'ep12-repaso-tiempos', 'estudio', false),

-- ── Banco (8) ──
('banco-ep12-rept-01', 'banco-ep12', 57, 'comprension',
 $j${"modo":"leer","lineas":[{"en":"I usually wake up at 6 AM.","es":"Normalmente me levanto a las 6 AM."},{"en":"This morning, I woke up late because I was tired.","es":"Esta mañana me levanté tarde porque estaba cansado."},{"en":"Right now, I am drinking my coffee and reading the news.","es":"Ahora mismo, estoy tomando mi café y leyendo las noticias."},{"en":"I have never been late to work before.","es":"Nunca he llegado tarde al trabajo antes."}],"pregunta":"How many different tenses are used in this text?","pregunta_es":"¿Cuántos tiempos diferentes se usan en este texto?","opciones":["4","2","3","5"],"correcta":0,"explicacion":"Simple present (wake up), simple past (woke up), present progressive (am drinking), present perfect (have never been)."}$j$,
 'ep12-repaso-tiempos', 'input', false),

('banco-ep12-rept-02', 'banco-ep12', 58, 'comprension',
 $j${"modo":"leer","lineas":[{"en":"Yesterday, I studied for three hours.","es":"Ayer, estudié por tres horas."},{"en":"I was studying when my friend called.","es":"Estaba estudiando cuando mi amigo llamó."},{"en":"Tomorrow, I am taking the exam.","es":"Mañana, presento el examen."},{"en":"I have studied a lot, so I think I will pass.","es":"He estudiado mucho, así que creo que pasaré."}],"pregunta":"Which tense is 'I was studying' in?","pregunta_es":"¿En qué tiempo está 'I was studying'?","opciones":["Past progressive","Present progressive","Simple past","Present perfect"],"correcta":0,"explicacion":"'Was studying' = was + verb-ing = past progressive."}$j$,
 'ep12-repaso-tiempos', 'input', false),

('banco-ep12-rept-03', 'banco-ep12', 59, 'decir',
 $j${"es":"Di: Nunca he comido comida japonesa.","respuestas":["I have never eaten Japanese food."],"mostrar":"I have never eaten Japanese food.","explicacion":"Present perfect with 'never' for experiences."}$j$,
 'ep12-repaso-tiempos', 'output', false),

('banco-ep12-rept-04', 'banco-ep12', 60, 'decir',
 $j${"es":"Di: Ella está trabajando ahora mismo.","respuestas":["She is working right now."],"mostrar":"She is working right now.","explicacion":"Present progressive for actions happening now."}$j$,
 'ep12-repaso-tiempos', 'output', false),

('banco-ep12-rept-05', 'banco-ep12', 61, 'libre',
 $j${"pregunta":"Write about your day using 4 different tenses: simple present, simple past, present progressive, and present perfect. One sentence for each.","pregunta_es":"Escribe sobre tu día usando 4 tiempos diferentes: presente simple, pasado simple, presente progresivo y presente perfecto. Una oración para cada uno.","ejemplo":"I usually study at night. Yesterday, I studied for two hours. Right now, I am practicing English. I have already finished my homework."}$j$,
 'ep12-repaso-tiempos', 'output', false),

('banco-ep12-rept-06', 'banco-ep12', 62, 'rapido',
 $j${"frase":"I ___ to that restaurant many times. (experience)","opciones":["have been","went","go","am going"],"correcta":0,"es":"He ido a ese restaurante muchas veces.","explicacion":"Present perfect for life experiences.","segundos":5}$j$,
 'ep12-repaso-tiempos', 'fluidez', false),

('banco-ep12-rept-07', 'banco-ep12', 63, 'rapido',
 $j${"frase":"Look! She ___ across the street right now.","opciones":["is running","runs","ran","has run"],"correcta":0,"es":"¡Mira! Ella ___ cruzando la calle ahora.","explicacion":"Present progressive for actions happening right now.","segundos":5}$j$,
 'ep12-repaso-tiempos', 'fluidez', false),

('banco-ep12-rept-08', 'banco-ep12', 64, 'rapido',
 $j${"frase":"They ___ in Medellín in 2018.","opciones":["lived","have lived","are living","live"],"correcta":0,"es":"Ellos ___ en Medellín en 2018.","explicacion":"Simple past for a specific completed time (2018).","segundos":5}$j$,
 'ep12-repaso-tiempos', 'fluidez', false),

-- ── Examen (3) ──
('examen-ep12-rept-01', 'examen-ep12', 22, 'elegir',
 $j${"frase":"She ___ English since she was 10.","opciones":["has studied","studied","studies","is studying"],"correcta":0,"es":"Ella ___ inglés desde que tenía 10 años.","explicacion":"Present perfect with 'since' for actions that started in the past and continue."}$j$,
 'ep12-repaso-tiempos', 'estudio', true),

('examen-ep12-rept-02', 'examen-ep12', 23, 'escribir',
 $j${"respuestas":["was sleeping"],"mostrar":"He ___ when the earthquake happened.","es":"Él ___ cuando ocurrió el terremoto.","explicacion":"Past progressive for the action in progress when the interruption happened."}$j$,
 'ep12-repaso-tiempos', 'estudio', true),

('examen-ep12-rept-03', 'examen-ep12', 24, 'elegir',
 $j${"frase":"Every morning, he ___ coffee and reads the news.","opciones":["drinks","is drinking","drank","has drunk"],"correcta":0,"es":"Cada mañana, él ___ café y lee las noticias.","explicacion":"Simple present for habitual actions ('every morning')."}$j$,
 'ep12-repaso-tiempos', 'estudio', true)

on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;
