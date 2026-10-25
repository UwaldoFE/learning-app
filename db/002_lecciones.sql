-- =====================================================================
-- 002 · Lecciones tipo Duolingo, errores, XP y racha
-- Pega TODO este archivo en Supabase → SQL Editor → Run.
-- Se puede correr varias veces sin dañar nada (no borra tu progreso).
-- =====================================================================

-- ============ TABLAS DE CONTENIDO ============
create table if not exists lecciones (
  id text primary key,
  materia_id text not null references materias(id) on delete cascade,
  unidad_id bigint references unidades(id) on delete set null,
  episodio int,
  orden int not null default 0,
  tipo text not null default 'tema' check (tipo in ('refuerzo','tema','simulacro')),
  titulo text not null,
  descripcion text
);
create table if not exists ejercicios (
  id text primary key,
  leccion_id text not null references lecciones(id) on delete cascade,
  orden int not null default 0,
  tipo text not null check (tipo in ('elegir','escuchar','ordenar','escribir','emparejar')),
  datos jsonb not null
);

-- ============ TABLAS DEL ESTUDIANTE ============
create table if not exists mis_lecciones (
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  leccion_id text not null references lecciones(id) on delete cascade,
  veces int not null default 0,
  mejor_precision int not null default 0,
  xp_total int not null default 0,
  ultima timestamptz not null default now(),
  primary key (user_id, leccion_id)
);
create table if not exists mis_errores (
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  ejercicio_id text not null references ejercicios(id) on delete cascade,
  fallos int not null default 1,
  resuelto boolean not null default false,
  ultimo timestamptz not null default now(),
  primary key (user_id, ejercicio_id)
);
create table if not exists mi_estudio (
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  fecha date not null,
  xp int not null default 0,
  lecciones int not null default 0,
  primary key (user_id, fecha)
);

-- ============ SEGURIDAD ============
alter table lecciones     enable row level security;
alter table ejercicios    enable row level security;
alter table mis_lecciones enable row level security;
alter table mis_errores   enable row level security;
alter table mi_estudio    enable row level security;
revoke all on lecciones, ejercicios, mis_lecciones, mis_errores, mi_estudio from anon;

drop policy if exists "leer lecciones" on lecciones;
drop policy if exists "leer ejercicios" on ejercicios;
drop policy if exists "mis lecciones" on mis_lecciones;
drop policy if exists "mis errores" on mis_errores;
drop policy if exists "mi estudio" on mi_estudio;
create policy "leer lecciones"  on lecciones  for select to authenticated using (es_activo());
create policy "leer ejercicios" on ejercicios for select to authenticated using (es_activo());
create policy "mis lecciones" on mis_lecciones for all to authenticated
  using (user_id = auth.uid() and es_activo()) with check (user_id = auth.uid() and es_activo());
create policy "mis errores" on mis_errores for all to authenticated
  using (user_id = auth.uid() and es_activo()) with check (user_id = auth.uid() and es_activo());
create policy "mi estudio" on mi_estudio for all to authenticated
  using (user_id = auth.uid() and es_activo()) with check (user_id = auth.uid() and es_activo());

-- ============ UNIDADES: episodio y descripciones que faltaban ============
update unidades set episodio = 'Episodio 1' where materia_id = 'ingles' and numero = 1;
update unidades set episodio = 'Episodio 1' where materia_id = 'ingles' and numero = 2;
update unidades set episodio = 'Episodio 2' where materia_id = 'ingles' and numero = 3;
update unidades set episodio = 'Episodio 2' where materia_id = 'ingles' and numero = 4;
update unidades set episodio = 'Episodio 3' where materia_id = 'ingles' and numero = 5;
update unidades set episodio = 'Episodio 3' where materia_id = 'ingles' and numero = 6;
update unidades set episodio = 'Episodio 4' where materia_id = 'ingles' and numero = 7;
update unidades set episodio = 'Episodio 4' where materia_id = 'ingles' and numero = 8;
update unidades set episodio = 'Episodio 5' where materia_id = 'ingles' and numero = 9;
update unidades set episodio = 'Episodio 5' where materia_id = 'ingles' and numero = 10;
update unidades set episodio = 'Episodio 6' where materia_id = 'ingles' and numero = 11;
update unidades set episodio = 'Episodio 6' where materia_id = 'ingles' and numero = 12;
update unidades set episodio = 'Episodio 7' where materia_id = 'ingles' and numero = 13;
update unidades set episodio = 'Episodio 7' where materia_id = 'ingles' and numero = 14;
update unidades set episodio = 'Episodio 7' where materia_id = 'ingles' and numero = 15;
update unidades set objetivo = 'Órdenes; verbo modal may; avisos públicos; país y ciudad; capitales' where materia_id = 'ingles' and numero = 6 and (objetivo is null or objetivo = '');
update unidades set objetivo = 'Pasado simple de verbos regulares; expresiones de tiempo; used to' where materia_id = 'ingles' and numero = 7 and (objetivo is null or objetivo = '');
update unidades set objetivo = 'Pasado de verbos irregulares; pasado progresivo; talk vs speak' where materia_id = 'ingles' and numero = 8 and (objetivo is null or objetivo = '');
update unidades set objetivo = 'Palabras negativas; pronombres objeto; oficina; educación' where materia_id = 'ingles' and numero = 9 and (objetivo is null or objetivo = '');
update unidades set objetivo = 'Preguntas sí/no; palabras interrogativas; expresiones con how; have got' where materia_id = 'ingles' and numero = 10 and (objetivo is null or objetivo = '');
update unidades set objetivo = 'Peticiones corteses; some y any; vocabulario de restaurante' where materia_id = 'ingles' and numero = 11 and (objetivo is null or objetivo = '');
update unidades set objetivo = 'Adverbios de frecuencia; números ordinales; plurales irregulares; verduras; colores' where materia_id = 'ingles' and numero = 12 and (objetivo is null or objetivo = '');
update unidades set objetivo = 'Pronombres posesivos; posesión con sustantivos; preposiciones' where materia_id = 'ingles' and numero = 13 and (objetivo is null or objetivo = '');
update unidades set objetivo = 'Adverbios; adjetivos terminados en -y; adverbios irregulares' where materia_id = 'ingles' and numero = 14 and (objetivo is null or objetivo = '');
update unidades set objetivo = 'Negaciones; contracciones con not; preguntas negativas y tag questions' where materia_id = 'ingles' and numero = 15 and (objetivo is null or objetivo = '');

-- ============ LECCIONES Y EJERCICIOS ============
insert into lecciones (id, materia_id, unidad_id, episodio, orden, tipo, titulo, descripcion)
values ('ep1-pronombres', 'ingles', (select id from unidades where materia_id = 'ingles' and numero = 1), 1, 1, 'refuerzo', 'He o his, she o her, it o she', 'Pronombres y posesivos: quién hace la acción y de quién es algo.')
on conflict (id) do update set unidad_id = excluded.unidad_id, episodio = excluded.episodio, orden = excluded.orden,
  tipo = excluded.tipo, titulo = excluded.titulo, descripcion = excluded.descripcion;
insert into ejercicios (id, leccion_id, orden, tipo, datos) values
  ('ep1-pronombres-01', 'ep1-pronombres', 1, 'elegir', '{"opciones": ["he", "his", "him"], "correcta": 1, "frase": "That is ___ book.", "pista": "(de él)", "es": "Ese es el libro de él.", "explicacion": "He = él (hace la acción). His = de él (dueño). That is his book."}'::jsonb),
  ('ep1-pronombres-02', 'ep1-pronombres', 2, 'elegir', '{"opciones": ["Her", "She", "It"], "correcta": 1, "frase": "___ is my wife.", "es": "Ella es mi esposa.", "explicacion": "She = ella, la que hace la acción o de quien se habla. Her = de ella."}'::jsonb),
  ('ep1-pronombres-03', 'ep1-pronombres', 3, 'elegir', '{"opciones": ["She", "Her", "His"], "correcta": 1, "frase": "My wife is very beautiful. ___ name is Maria.", "es": "Mi esposa es muy bonita. Su nombre es María.", "explicacion": "Her = de ella. Her name = su nombre (de ella)."}'::jsonb),
  ('ep1-pronombres-04', 'ep1-pronombres', 4, 'elegir', '{"opciones": ["she", "it", "he"], "correcta": 1, "frase": "My car is old, but ___ works well.", "es": "Mi carro es viejo, pero funciona bien.", "explicacion": "It es para cosas y animales. Para personas: he (él) o she (ella)."}'::jsonb),
  ('ep1-pronombres-05', 'ep1-pronombres', 5, 'emparejar', '{"pares": [["I", "my (mi)"], ["he", "his (de él)"], ["she", "her (de ella)"], ["they", "their (de ellos)"]], "es": "", "explicacion": "Cada pronombre tiene su posesivo: I → my, he → his, she → her, they → their."}'::jsonb),
  ('ep1-pronombres-06', 'ep1-pronombres', 6, 'escribir', '{"respuestas": ["his name is uwaldo"], "mostrar": "His name is Uwaldo.", "es": "Su nombre es Uwaldo. (de él)", "explicacion": "Su (de él) = his. Su (de ella) = her."}'::jsonb),
  ('ep1-pronombres-07', 'ep1-pronombres', 7, 'ordenar', '{"frase": "Her store is in Cúcuta .", "es": "La tienda de ella está en Cúcuta.", "explicacion": "Her store = la tienda de ella. El posesivo va antes del sustantivo."}'::jsonb),
  ('ep1-pronombres-08', 'ep1-pronombres', 8, 'escuchar', '{"opciones": ["His brother lives in Bogotá.", "He brother lives in Bogotá.", "Her brother lives in Bogotá."], "correcta": 0, "audio": "His brother lives in Bogotá.", "es": "El hermano de él vive en Bogotá.", "explicacion": "His (de él) suena como /jis/. He suena como /ji/."}'::jsonb)
on conflict (id) do update set orden = excluded.orden, tipo = excluded.tipo, datos = excluded.datos;
delete from ejercicios where leccion_id = 'ep1-pronombres' and orden > 8;
insert into lecciones (id, materia_id, unidad_id, episodio, orden, tipo, titulo, descripcion)
values ('ep2-a-an-plurales', 'ingles', (select id from unidades where materia_id = 'ingles' and numero = 3), 2, 1, 'refuerzo', 'a / an y plurales irregulares', 'Cuándo usar an, y los plurales que no terminan en -s.')
on conflict (id) do update set unidad_id = excluded.unidad_id, episodio = excluded.episodio, orden = excluded.orden,
  tipo = excluded.tipo, titulo = excluded.titulo, descripcion = excluded.descripcion;
insert into ejercicios (id, leccion_id, orden, tipo, datos) values
  ('ep2-a-an-plurales-01', 'ep2-a-an-plurales', 1, 'elegir', '{"opciones": ["a", "an", "the"], "correcta": 1, "frase": "This is ___ umbrella.", "es": "Esta es una sombrilla.", "explicacion": "Antes de sonido de vocal se usa an: an umbrella, an apple, an engineer."}'::jsonb),
  ('ep2-a-an-plurales-02', 'ep2-a-an-plurales', 2, 'elegir', '{"opciones": ["a", "an"], "correcta": 1, "frase": "I am ___ engineer.", "es": "Soy ingeniero.", "explicacion": "Engineer empieza con sonido de vocal → an engineer."}'::jsonb),
  ('ep2-a-an-plurales-03', 'ep2-a-an-plurales', 3, 'elegir', '{"opciones": ["a", "an"], "correcta": 0, "frase": "She is ___ teacher.", "es": "Ella es profesora.", "explicacion": "Teacher empieza con sonido de consonante → a teacher."}'::jsonb),
  ('ep2-a-an-plurales-04', 'ep2-a-an-plurales', 4, 'elegir', '{"opciones": ["a", "an"], "correcta": 1, "frase": "I have ___ hour for lunch.", "es": "Tengo una hora para almorzar.", "explicacion": "En hour la h no suena (/aur/), empieza con sonido de vocal → an hour."}'::jsonb),
  ('ep2-a-an-plurales-05', 'ep2-a-an-plurales', 5, 'elegir', '{"opciones": ["childs", "children", "childrens"], "correcta": 1, "frase": "One child, two ___.", "es": "Un niño, dos niños.", "explicacion": "Child es irregular: child → children (sin -s)."}'::jsonb),
  ('ep2-a-an-plurales-06', 'ep2-a-an-plurales', 6, 'emparejar', '{"pares": [["man", "men (hombres)"], ["woman", "women (mujeres)"], ["person", "people (personas)"], ["foot", "feet (pies)"]], "es": "", "explicacion": "Plurales irregulares: cambian la palabra en vez de agregar -s."}'::jsonb),
  ('ep2-a-an-plurales-07', 'ep2-a-an-plurales', 7, 'escribir', '{"respuestas": ["i have two children", "i have two sons", "i have 2 children", "i have 2 sons"], "mostrar": "I have two children.", "es": "Tengo dos hijos.", "explicacion": "Hijos en general = children. Solo hijos varones = sons."}'::jsonb),
  ('ep2-a-an-plurales-08', 'ep2-a-an-plurales', 8, 'elegir', '{"opciones": ["shoe", "shoes", "shoeses"], "correcta": 1, "frase": "Those ___ are very expensive.", "es": "Esos zapatos son muy caros.", "explicacion": "Plural regular: shoe → shoes. Those (esos) va con plural."}'::jsonb)
on conflict (id) do update set orden = excluded.orden, tipo = excluded.tipo, datos = excluded.datos;
delete from ejercicios where leccion_id = 'ep2-a-an-plurales' and orden > 8;
insert into lecciones (id, materia_id, unidad_id, episodio, orden, tipo, titulo, descripcion)
values ('ep2-regla-s', 'ingles', (select id from unidades where materia_id = 'ingles' and numero = 4), 2, 2, 'refuerzo', 'Regla n.º 1: la -s de he, she, it', 'En presente simple, solo he, she e it llevan -s. Con I, you, we, they no.')
on conflict (id) do update set unidad_id = excluded.unidad_id, episodio = excluded.episodio, orden = excluded.orden,
  tipo = excluded.tipo, titulo = excluded.titulo, descripcion = excluded.descripcion;
insert into ejercicios (id, leccion_id, orden, tipo, datos) values
  ('ep2-regla-s-01', 'ep2-regla-s', 1, 'elegir', '{"opciones": ["live", "lives", "living"], "correcta": 1, "frase": "He ___ in Cúcuta.", "es": "Él vive en Cúcuta.", "explicacion": "He / she / it → el verbo lleva -s: he lives."}'::jsonb),
  ('ep2-regla-s-02', 'ep2-regla-s', 2, 'elegir', '{"opciones": ["brush", "brushes", "brushing"], "correcta": 0, "frase": "I ___ my teeth every morning.", "es": "Me cepillo los dientes todas las mañanas.", "explicacion": "Con I el verbo NO lleva -s: I brush. (Con he: he brushes.)"}'::jsonb),
  ('ep2-regla-s-03', 'ep2-regla-s', 3, 'elegir', '{"opciones": ["sell", "sells", "selling"], "correcta": 1, "frase": "Maria ___ shoes on social media.", "es": "María vende zapatos en redes sociales.", "explicacion": "Maria = she → sells."}'::jsonb),
  ('ep2-regla-s-04', 'ep2-regla-s', 4, 'escuchar', '{"opciones": ["She works from home.", "She work from home.", "She is work from home."], "correcta": 0, "audio": "She works from home.", "es": "Ella trabaja desde casa.", "explicacion": "She works: con she el verbo lleva -s. Fíjate en el sonido /s/ al final de works."}'::jsonb),
  ('ep2-regla-s-05', 'ep2-regla-s', 5, 'ordenar', '{"frase": "My wife sells shoes on TikTok .", "es": "Mi esposa vende zapatos en TikTok.", "explicacion": "My wife = she → sells."}'::jsonb),
  ('ep2-regla-s-06', 'ep2-regla-s', 6, 'escribir', '{"respuestas": ["he studies data analysis"], "mostrar": "He studies data analysis.", "es": "Él estudia análisis de datos.", "explicacion": "Study termina en consonante + y → studies (cambia la y por -ies)."}'::jsonb),
  ('ep2-regla-s-07', 'ep2-regla-s', 7, 'elegir', '{"opciones": ["watch", "watchs", "watches"], "correcta": 2, "frase": "My son ___ TV after school.", "es": "Mi hijo ve televisión después del colegio.", "explicacion": "Verbos que terminan en -ch, -sh, -s, -x, -o llevan -es: watches, brushes, goes, does."}'::jsonb),
  ('ep2-regla-s-08', 'ep2-regla-s', 8, 'escribir', '{"respuestas": ["i work and she studies"], "mostrar": "I work and she studies.", "es": "Yo trabajo y ella estudia.", "explicacion": "I work (sin -s) · she studies (con -ies)."}'::jsonb),
  ('ep2-regla-s-09', 'ep2-regla-s', 9, 'emparejar', '{"pares": [["I go", "he goes"], ["I study", "she studies"], ["I watch", "he watches"], ["I have", "she has"]], "es": "", "explicacion": "Con he/she/it: go → goes, study → studies, watch → watches, have → has."}'::jsonb)
on conflict (id) do update set orden = excluded.orden, tipo = excluded.tipo, datos = excluded.datos;
delete from ejercicios where leccion_id = 'ep2-regla-s' and orden > 9;
insert into lecciones (id, materia_id, unidad_id, episodio, orden, tipo, titulo, descripcion)
values ('ep2-do-does', 'ingles', (select id from unidades where materia_id = 'ingles' and numero = 4), 2, 3, 'refuerzo', 'Do y Does: preguntar y negar', 'Do con I, you, we, they. Does con he, she, it. Después de does el verbo va sin -s.')
on conflict (id) do update set unidad_id = excluded.unidad_id, episodio = excluded.episodio, orden = excluded.orden,
  tipo = excluded.tipo, titulo = excluded.titulo, descripcion = excluded.descripcion;
insert into ejercicios (id, leccion_id, orden, tipo, datos) values
  ('ep2-do-does-01', 'ep2-do-does', 1, 'elegir', '{"opciones": ["Do", "Does", "Are"], "correcta": 0, "frase": "___ you work on Saturdays?", "es": "¿Trabajas los sábados?", "explicacion": "Preguntas con you → Do."}'::jsonb),
  ('ep2-do-does-02', 'ep2-do-does', 2, 'elegir', '{"opciones": ["Do", "Does", "Is"], "correcta": 1, "frase": "___ she live in Cúcuta?", "es": "¿Ella vive en Cúcuta?", "explicacion": "Preguntas con he / she / it → Does."}'::jsonb),
  ('ep2-do-does-03', 'ep2-do-does', 3, 'elegir', '{"opciones": ["like", "likes", "liking"], "correcta": 0, "frase": "Does he ___ coffee?", "es": "¿A él le gusta el café?", "explicacion": "Después de does el verbo vuelve a su forma base: Does he like…? (la -s ya la lleva does)."}'::jsonb),
  ('ep2-do-does-04', 'ep2-do-does', 4, 'elegir', '{"opciones": ["don''t", "doesn''t", "not"], "correcta": 0, "frase": "I ___ like tea.", "es": "No me gusta el té.", "explicacion": "Negativo con I → don''t."}'::jsonb),
  ('ep2-do-does-05', 'ep2-do-does', 5, 'elegir', '{"opciones": ["don''t", "doesn''t", "isn''t"], "correcta": 1, "frase": "Maria ___ work on Sundays.", "es": "María no trabaja los domingos.", "explicacion": "Negativo con she → doesn''t + verbo base: doesn''t work."}'::jsonb),
  ('ep2-do-does-06', 'ep2-do-does', 6, 'ordenar', '{"frase": "Do you sell shoes online ?", "es": "¿Vendes zapatos por internet?", "explicacion": "Pregunta: Do + you + verbo + resto."}'::jsonb),
  ('ep2-do-does-07', 'ep2-do-does', 7, 'escribir', '{"respuestas": ["he doesnt have luggage", "he does not have luggage", "he doesnt have any luggage", "he does not have any luggage"], "mostrar": "He doesn''t have luggage.", "es": "Él no tiene equipaje.", "explicacion": "Negativo con he: doesn''t + have. Nunca doesn''t has."}'::jsonb),
  ('ep2-do-does-08', 'ep2-do-does', 8, 'escuchar', '{"opciones": ["Does your wife work with you?", "Do your wife work with you?", "Is your wife work with you?"], "correcta": 0, "audio": "Does your wife work with you?", "es": "¿Tu esposa trabaja contigo?", "explicacion": "Your wife = she → Does … work?"}'::jsonb),
  ('ep2-do-does-09', 'ep2-do-does', 9, 'escribir', '{"respuestas": ["where do you live"], "mostrar": "Where do you live?", "es": "¿Dónde vives?", "explicacion": "Palabra de pregunta + do + you + verbo: Where do you live?"}'::jsonb)
on conflict (id) do update set orden = excluded.orden, tipo = excluded.tipo, datos = excluded.datos;
delete from ejercicios where leccion_id = 'ep2-do-does' and orden > 9;
insert into lecciones (id, materia_id, unidad_id, episodio, orden, tipo, titulo, descripcion)
values ('ep2-mi-rutina', 'ingles', (select id from unidades where materia_id = 'ingles' and numero = 4), 2, 4, 'refuerzo', 'Tu rutina y tu trabajo', 'Frases de tu día a día, con los errores que salieron en tu escritura.')
on conflict (id) do update set unidad_id = excluded.unidad_id, episodio = excluded.episodio, orden = excluded.orden,
  tipo = excluded.tipo, titulo = excluded.titulo, descripcion = excluded.descripcion;
insert into ejercicios (id, leccion_id, orden, tipo, datos) values
  ('ep2-mi-rutina-01', 'ep2-mi-rutina', 1, 'elegir', '{"opciones": ["am study", "study", "studies"], "correcta": 1, "frase": "I ___ data analysis.", "es": "Estudio análisis de datos.", "explicacion": "No se junta am + verbo base. Di I study (en general) o I am studying (en esta etapa)."}'::jsonb),
  ('ep2-mi-rutina-02', 'ep2-mi-rutina', 2, 'elegir', '{"opciones": ["in", "on", "at"], "correcta": 1, "frase": "I sell shoes ___ social media.", "es": "Vendo zapatos en redes sociales.", "explicacion": "En redes sociales e internet se usa on: on social media, on TikTok, on the internet."}'::jsonb),
  ('ep2-mi-rutina-03', 'ep2-mi-rutina', 3, 'elegir', '{"opciones": ["with", "to", "for"], "correcta": 1, "frase": "I''m married ___ Maria.", "es": "Estoy casado con María.", "explicacion": "En inglés te casas to alguien: married to."}'::jsonb),
  ('ep2-mi-rutina-04', 'ep2-mi-rutina', 4, 'elegir', '{"opciones": ["lunch", "have", "take"], "correcta": 1, "frase": "I ___ lunch at twelve o''clock.", "es": "Almuerzo a las doce.", "explicacion": "Las comidas van con have: have breakfast, have lunch, have dinner."}'::jsonb),
  ('ep2-mi-rutina-05', 'ep2-mi-rutina', 5, 'ordenar', '{"frase": "I wake up at seven o''clock .", "es": "Me despierto a las siete.", "explicacion": "O''clock lleva apóstrofo y va después del número."}'::jsonb),
  ('ep2-mi-rutina-06', 'ep2-mi-rutina', 6, 'escribir', '{"respuestas": ["i take a shower and brush my teeth", "i take a shower and i brush my teeth", "i shower and brush my teeth", "i shower and i brush my teeth"], "mostrar": "I take a shower and brush my teeth.", "es": "Me ducho y me cepillo los dientes.", "explicacion": "Take a shower (ducharse) · brush my teeth (cepillarme los dientes). Con I, sin -s."}'::jsonb),
  ('ep2-mi-rutina-07', 'ep2-mi-rutina', 7, 'escribir', '{"respuestas": ["i sell shoes on social media"], "mostrar": "I sell shoes on social media.", "es": "Vendo zapatos en redes sociales.", "explicacion": "Trabajo habitual → presente simple (I sell) + on social media."}'::jsonb),
  ('ep2-mi-rutina-08', 'ep2-mi-rutina', 8, 'escuchar', '{"opciones": ["At nine o''clock I sit at my desk.", "At five o''clock I sit at my desk.", "At nine o''clock I sat at my desk."], "correcta": 0, "audio": "At nine o''clock I sit at my desk.", "es": "A las nueve me siento en mi escritorio.", "explicacion": "Sit at my desk = sentarme en mi escritorio. Nine (9) vs five (5)."}'::jsonb),
  ('ep2-mi-rutina-09', 'ep2-mi-rutina', 9, 'elegir', '{"opciones": ["do", "does", "are"], "correcta": 0, "frase": "What time ___ you have breakfast?", "es": "¿A qué hora desayunas?", "explicacion": "What time + do + you + verbo."}'::jsonb)
on conflict (id) do update set orden = excluded.orden, tipo = excluded.tipo, datos = excluded.datos;
delete from ejercicios where leccion_id = 'ep2-mi-rutina' and orden > 9;
insert into lecciones (id, materia_id, unidad_id, episodio, orden, tipo, titulo, descripcion)
values ('ep3-would-like', 'ingles', (select id from unidades where materia_id = 'ingles' and numero = 5), 3, 1, 'tema', 'Would you like…? / I''d like…', 'Ofrecer y pedir con cortesía (Unidad 5: llamada informal).')
on conflict (id) do update set unidad_id = excluded.unidad_id, episodio = excluded.episodio, orden = excluded.orden,
  tipo = excluded.tipo, titulo = excluded.titulo, descripcion = excluded.descripcion;
insert into ejercicios (id, leccion_id, orden, tipo, datos) values
  ('ep3-would-like-01', 'ep3-would-like', 1, 'elegir', '{"opciones": ["Do", "Would", "Are"], "correcta": 1, "frase": "___ you like a coffee?", "es": "¿Le gustaría un café?", "explicacion": "Para OFRECER algo con cortesía: Would you like…?"}'::jsonb),
  ('ep3-would-like-02', 'ep3-would-like', 2, 'elegir', '{"opciones": ["¿Te gusta el café?", "¿Quieres un café ahora?", "¿Te gustaría un café?"], "correcta": 0, "frase": "¿Qué significa: Do you like coffee?", "es": "", "explicacion": "Do you like…? pregunta si algo te gusta en general. Would you like…? ofrece algo ahora."}'::jsonb),
  ('ep3-would-like-03', 'ep3-would-like', 3, 'elegir', '{"opciones": ["would", "do", "am"], "correcta": 0, "frase": "I ___ like a glass of water, please.", "es": "Me gustaría un vaso de agua, por favor.", "explicacion": "Para PEDIR con cortesía: I would like… (corto: I''d like…)."}'::jsonb),
  ('ep3-would-like-04', 'ep3-would-like', 4, 'escribir', '{"respuestas": ["i would like a taxi please", "id like a taxi please"], "mostrar": "I''d like a taxi, please.", "es": "Me gustaría un taxi, por favor.", "explicacion": "I would like = I''d like = me gustaría."}'::jsonb),
  ('ep3-would-like-05', 'ep3-would-like', 5, 'ordenar', '{"frase": "Would you like to see the menu ?", "es": "¿Le gustaría ver el menú?", "explicacion": "Would you like + to + verbo."}'::jsonb),
  ('ep3-would-like-06', 'ep3-would-like', 6, 'escuchar', '{"opciones": ["I''d like a table for two, please.", "I like a table for two, please.", "I''d like a cable for two, please."], "correcta": 0, "audio": "I''d like a table for two, please.", "es": "Quisiera una mesa para dos, por favor.", "explicacion": "La d de I''d suena suave pero cambia el sentido: I''d like = quisiera."}'::jsonb),
  ('ep3-would-like-07', 'ep3-would-like', 7, 'elegir', '{"opciones": ["come", "to come", "coming"], "correcta": 1, "frase": "Would you like ___ with me?", "es": "¿Te gustaría venir conmigo?", "explicacion": "Would like + to + verbo: would you like to come…?"}'::jsonb),
  ('ep3-would-like-08', 'ep3-would-like', 8, 'escribir', '{"respuestas": ["would you like to come to my store", "would you like to come to my shop"], "mostrar": "Would you like to come to my store?", "es": "¿Le gustaría venir a mi tienda?", "explicacion": "Would you like to + verbo + resto."}'::jsonb)
on conflict (id) do update set orden = excluded.orden, tipo = excluded.tipo, datos = excluded.datos;
delete from ejercicios where leccion_id = 'ep3-would-like' and orden > 8;
insert into lecciones (id, materia_id, unidad_id, episodio, orden, tipo, titulo, descripcion)
values ('ep3-could-you', 'ingles', (select id from unidades where materia_id = 'ingles' and numero = 6), 3, 2, 'tema', 'Could you…? Pedir con cortesía en el taxi', 'Could you / Would you + verbo base + please (Unidad 6: taking a taxi).')
on conflict (id) do update set unidad_id = excluded.unidad_id, episodio = excluded.episodio, orden = excluded.orden,
  tipo = excluded.tipo, titulo = excluded.titulo, descripcion = excluded.descripcion;
insert into ejercicios (id, leccion_id, orden, tipo, datos) values
  ('ep3-could-you-01', 'ep3-could-you', 1, 'elegir', '{"opciones": ["Could", "Do", "Are"], "correcta": 0, "frase": "___ you take me to the airport, please?", "es": "¿Me podría llevar al aeropuerto, por favor?", "explicacion": "Could you…? = ¿Podría…? Es la forma cortés más usada."}'::jsonb),
  ('ep3-could-you-02', 'ep3-could-you', 2, 'elegir', '{"opciones": ["Take me to the airport.", "Could you take me to the airport, please?", "You take me to the airport."], "correcta": 1, "frase": "¿Cuál es la forma más cortés?", "es": "", "explicacion": "Could you … please? suena educado. Las otras suenan como una orden."}'::jsonb),
  ('ep3-could-you-03', 'ep3-could-you', 3, 'elegir', '{"opciones": ["drive", "drives", "driving"], "correcta": 0, "frase": "Could you ___ slower, please?", "es": "¿Podría manejar más despacio, por favor?", "explicacion": "Después de could el verbo va en forma base: could you drive."}'::jsonb),
  ('ep3-could-you-04', 'ep3-could-you', 4, 'escribir', '{"respuestas": ["could you take me to the mall please", "would you take me to the mall please", "could you take me to the shopping mall please"], "mostrar": "Could you take me to the mall, please?", "es": "¿Me podría llevar al centro comercial, por favor?", "explicacion": "Could you take me to + lugar + please?"}'::jsonb),
  ('ep3-could-you-05', 'ep3-could-you', 5, 'escribir', '{"respuestas": ["could i open the window", "can i open the window", "may i open the window"], "mostrar": "Could I open the window?", "es": "¿Puedo abrir la ventana?", "explicacion": "Para pedir permiso para ti: Could I…? (o Can I…? / May I…?)."}'::jsonb),
  ('ep3-could-you-06', 'ep3-could-you', 6, 'ordenar', '{"frase": "Could you stop here please ?", "es": "¿Podría parar aquí, por favor?", "explicacion": "Could + you + verbo + resto + please."}'::jsonb),
  ('ep3-could-you-07', 'ep3-could-you', 7, 'escuchar', '{"opciones": ["Could I pay by card?", "Could I pay by car?", "Could I play by card?"], "correcta": 0, "audio": "Could I pay by card?", "es": "¿Puedo pagar con tarjeta?", "explicacion": "Pay = pagar · by card = con tarjeta."}'::jsonb),
  ('ep3-could-you-08', 'ep3-could-you', 8, 'emparejar', '{"pares": [["take me to", "llevarme a"], ["slower", "más despacio"], ["stop here", "pare aquí"], ["by card", "con tarjeta"]], "es": "", "explicacion": "Frases útiles en el taxi."}'::jsonb)
on conflict (id) do update set orden = excluded.orden, tipo = excluded.tipo, datos = excluded.datos;
delete from ejercicios where leccion_id = 'ep3-could-you' and orden > 8;
insert into lecciones (id, materia_id, unidad_id, episodio, orden, tipo, titulo, descripcion)
values ('ep3-whose', 'ingles', (select id from unidades where materia_id = 'ingles' and numero = 6), 3, 3, 'tema', 'Whose…? ¿De quién es?', 'Preguntar de quién es algo y responder con ''s.')
on conflict (id) do update set unidad_id = excluded.unidad_id, episodio = excluded.episodio, orden = excluded.orden,
  tipo = excluded.tipo, titulo = excluded.titulo, descripcion = excluded.descripcion;
insert into ejercicios (id, leccion_id, orden, tipo, datos) values
  ('ep3-whose-01', 'ep3-whose', 1, 'elegir', '{"opciones": ["Who", "Whose", "Where"], "correcta": 1, "frase": "___ is this bag? It''s Maria''s.", "es": "¿De quién es este bolso? Es de María.", "explicacion": "Whose = ¿de quién? Who = ¿quién?"}'::jsonb),
  ('ep3-whose-02', 'ep3-whose', 2, 'elegir', '{"opciones": ["Carlos", "Carlos''s", "Carloses"], "correcta": 1, "frase": "This is ___ phone.", "pista": "(de Carlos)", "es": "Este es el teléfono de Carlos.", "explicacion": "Para decir ''de alguien'' se agrega ''s: Carlos''s phone, Maria''s bag."}'::jsonb),
  ('ep3-whose-03', 'ep3-whose', 3, 'escribir', '{"respuestas": ["whose car is this", "whose is this car"], "mostrar": "Whose car is this?", "es": "¿De quién es este carro?", "explicacion": "Whose + cosa + is this?"}'::jsonb),
  ('ep3-whose-04', 'ep3-whose', 4, 'ordenar', '{"frase": "Whose shoes are these ?", "es": "¿De quién son estos zapatos?", "explicacion": "Con plural: Whose … are these?"}'::jsonb),
  ('ep3-whose-05', 'ep3-whose', 5, 'elegir', '{"opciones": ["my", "I", "me"], "correcta": 0, "frase": "Whose bag is this? It''s ___ bag.", "es": "¿De quién es este bolso? Es mi bolso.", "explicacion": "My = mi. It''s my bag."}'::jsonb),
  ('ep3-whose-06', 'ep3-whose', 6, 'escuchar', '{"opciones": ["Whose jacket is this?", "Whose jacket is that?", "Where is the jacket?"], "correcta": 0, "audio": "Whose jacket is this?", "es": "¿De quién es esta chaqueta?", "explicacion": "This = esta (cerca) · that = esa (lejos)."}'::jsonb),
  ('ep3-whose-07', 'ep3-whose', 7, 'emparejar', '{"pares": [["Who?", "¿Quién?"], ["Whose?", "¿De quién?"], ["Where?", "¿Dónde?"], ["How much?", "¿Cuánto cuesta?"]], "es": "", "explicacion": "Palabras para preguntar (question words)."}'::jsonb)
on conflict (id) do update set orden = excluded.orden, tipo = excluded.tipo, datos = excluded.datos;
delete from ejercicios where leccion_id = 'ep3-whose' and orden > 7;
insert into lecciones (id, materia_id, unidad_id, episodio, orden, tipo, titulo, descripcion)
values ('ep3-might-conectores', 'ingles', (select id from unidades where materia_id = 'ingles' and numero = 5), 3, 4, 'tema', 'May, might y conectores (and, but, so)', 'Decir que algo puede pasar y unir ideas.')
on conflict (id) do update set unidad_id = excluded.unidad_id, episodio = excluded.episodio, orden = excluded.orden,
  tipo = excluded.tipo, titulo = excluded.titulo, descripcion = excluded.descripcion;
insert into ejercicios (id, leccion_id, orden, tipo, datos) values
  ('ep3-might-conectores-01', 'ep3-might-conectores', 1, 'elegir', '{"opciones": ["might", "must", "does"], "correcta": 0, "frase": "It ___ rain tomorrow. I''m not sure.", "es": "Puede que llueva mañana. No estoy seguro.", "explicacion": "Might = puede que (no es seguro)."}'::jsonb),
  ('ep3-might-conectores-02', 'ep3-might-conectores', 2, 'elegir', '{"opciones": ["and", "but", "so"], "correcta": 1, "frase": "I like coffee, ___ I don''t like tea.", "es": "Me gusta el café, pero no me gusta el té.", "explicacion": "But = pero (contraste)."}'::jsonb),
  ('ep3-might-conectores-03', 'ep3-might-conectores', 3, 'elegir', '{"opciones": ["but", "so", "or"], "correcta": 1, "frase": "I was tired, ___ I went to bed early.", "es": "Estaba cansado, así que me acosté temprano.", "explicacion": "So = así que / entonces (consecuencia)."}'::jsonb),
  ('ep3-might-conectores-04', 'ep3-might-conectores', 4, 'elegir', '{"opciones": ["May", "Might", "Do"], "correcta": 0, "frase": "___ I come in?", "pista": "(pedir permiso formal)", "es": "¿Puedo pasar?", "explicacion": "May I…? = ¿Puedo…? (muy formal y cortés)."}'::jsonb),
  ('ep3-might-conectores-05', 'ep3-might-conectores', 5, 'escribir', '{"respuestas": ["i might be late", "i may be late"], "mostrar": "I might be late.", "es": "Puede que llegue tarde.", "explicacion": "Might / may + verbo base: I might be late."}'::jsonb),
  ('ep3-might-conectores-06', 'ep3-might-conectores', 6, 'ordenar', '{"frase": "I study English and I sell shoes .", "es": "Estudio inglés y vendo zapatos.", "explicacion": "And = y (suma ideas)."}'::jsonb),
  ('ep3-might-conectores-07', 'ep3-might-conectores', 7, 'escuchar', '{"opciones": ["She might come to the store later.", "She must come to the store later.", "She may come to the store today."], "correcta": 0, "audio": "She might come to the store later.", "es": "Puede que ella venga a la tienda más tarde.", "explicacion": "Might (puede que) vs must (debe)."}'::jsonb)
on conflict (id) do update set orden = excluded.orden, tipo = excluded.tipo, datos = excluded.datos;
delete from ejercicios where leccion_id = 'ep3-might-conectores' and orden > 7;
insert into lecciones (id, materia_id, unidad_id, episodio, orden, tipo, titulo, descripcion)
values ('ep3-simulacro', 'ingles', (select id from unidades where materia_id = 'ingles' and numero = 6), 3, 9, 'simulacro', 'Simulacro del Episodio 3', 'Repaso de todo el episodio, como preparación para tu evaluación en el instituto.')
on conflict (id) do update set unidad_id = excluded.unidad_id, episodio = excluded.episodio, orden = excluded.orden,
  tipo = excluded.tipo, titulo = excluded.titulo, descripcion = excluded.descripcion;
insert into ejercicios (id, leccion_id, orden, tipo, datos) values
  ('ep3-simulacro-01', 'ep3-simulacro', 1, 'elegir', '{"opciones": ["Would", "Do", "Are"], "correcta": 0, "frase": "___ you like some water?", "es": "¿Le gustaría un poco de agua?", "explicacion": "Ofrecer: Would you like…?"}'::jsonb),
  ('ep3-simulacro-02', 'ep3-simulacro', 2, 'elegir', '{"opciones": ["help", "helps", "helping"], "correcta": 0, "frase": "Could you ___ me, please?", "es": "¿Me podría ayudar, por favor?", "explicacion": "Could you + verbo base."}'::jsonb),
  ('ep3-simulacro-03', 'ep3-simulacro', 3, 'elegir', '{"opciones": ["Whose", "Who", "What"], "correcta": 0, "frase": "___ car is this? It''s my brother''s.", "es": "¿De quién es este carro? Es de mi hermano.", "explicacion": "Whose = ¿de quién?"}'::jsonb),
  ('ep3-simulacro-04', 'ep3-simulacro', 4, 'elegir', '{"opciones": ["might", "mights", "is"], "correcta": 0, "frase": "It ___ be cold tonight.", "es": "Puede que haga frío esta noche.", "explicacion": "Might nunca lleva -s: it might be."}'::jsonb),
  ('ep3-simulacro-05', 'ep3-simulacro', 5, 'elegir', '{"opciones": ["so", "but", "or"], "correcta": 0, "frase": "I''m hungry, ___ I''m going to eat.", "es": "Tengo hambre, así que voy a comer.", "explicacion": "So = así que."}'::jsonb),
  ('ep3-simulacro-06', 'ep3-simulacro', 6, 'escribir', '{"respuestas": ["could you help me with my bags please", "would you help me with my bags please", "could you help me with my luggage please", "would you help me with my luggage please"], "mostrar": "Could you help me with my bags, please?", "es": "¿Me podría ayudar con mis maletas, por favor?", "explicacion": "Could you help me with + cosa + please?"}'::jsonb),
  ('ep3-simulacro-07', 'ep3-simulacro', 7, 'escribir', '{"respuestas": ["i would like to go to the airport", "id like to go to the airport"], "mostrar": "I''d like to go to the airport.", "es": "Me gustaría ir al aeropuerto.", "explicacion": "I''d like + to + verbo."}'::jsonb),
  ('ep3-simulacro-08', 'ep3-simulacro', 8, 'ordenar', '{"frase": "Whose phone is this ?", "es": "¿De quién es este teléfono?", "explicacion": "Whose + cosa + is this?"}'::jsonb),
  ('ep3-simulacro-09', 'ep3-simulacro', 9, 'escuchar', '{"opciones": ["Would you like to pay by card or cash?", "Would you like to play by card or cash?", "Do you like to pay by card or cash?"], "correcta": 0, "audio": "Would you like to pay by card or cash?", "es": "¿Le gustaría pagar con tarjeta o en efectivo?", "explicacion": "Pay = pagar · cash = efectivo."}'::jsonb),
  ('ep3-simulacro-10', 'ep3-simulacro', 10, 'elegir', '{"opciones": ["do", "does", "are"], "correcta": 0, "frase": "Where ___ you want to go?", "es": "¿A dónde quiere ir?", "explicacion": "Where + do + you + verbo."}'::jsonb),
  ('ep3-simulacro-11', 'ep3-simulacro', 11, 'escribir', '{"respuestas": ["how much is it", "how much does it cost", "how much is this", "how much"], "mostrar": "How much is it?", "es": "¿Cuánto cuesta?", "explicacion": "How much = ¿cuánto?"}'::jsonb),
  ('ep3-simulacro-12', 'ep3-simulacro', 12, 'elegir', '{"opciones": ["long", "much", "many"], "correcta": 0, "frase": "How ___ does it take to the airport?", "es": "¿Cuánto se demora al aeropuerto?", "explicacion": "How long = ¿cuánto tiempo?"}'::jsonb)
on conflict (id) do update set orden = excluded.orden, tipo = excluded.tipo, datos = excluded.datos;
delete from ejercicios where leccion_id = 'ep3-simulacro' and orden > 12;

-- Listo: 10 lecciones, 85 ejercicios.
