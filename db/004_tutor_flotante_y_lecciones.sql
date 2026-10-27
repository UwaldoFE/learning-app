-- =====================================================================
-- 004 · Tutor flotante (memoria de la conversación y uso del micrófono)
--       + lecciones nuevas: resto del Episodio 3 y huecos del Episodio 1
-- Pega TODO este archivo en Supabase → SQL Editor → Run.
-- Se puede correr varias veces sin dañar nada (no borra tu progreso).
-- =====================================================================

-- Conversación del tutor flotante (para que la recuerde en cualquier dispositivo)
create table if not exists tutor_chat (
  user_id uuid primary key default auth.uid() references auth.users(id) on delete cascade,
  mensajes jsonb not null default '[]'::jsonb,
  actualizado timestamptz not null default now()
);
alter table tutor_chat enable row level security;
drop policy if exists "tutor chat" on tutor_chat;
create policy "tutor chat" on tutor_chat for all to authenticated
  using (user_id = auth.uid() and es_activo()) with check (user_id = auth.uid() and es_activo());

-- Audios enviados al micrófono por día (tope diario para cuidar el saldo)
alter table tutor_uso add column if not exists audios int not null default 0;

-- ============ LECCIONES NUEVAS ============
insert into lecciones (id, materia_id, unidad_id, episodio, orden, tipo, titulo, descripcion)
values ('ep3-can-could', 'ingles', (select id from unidades where materia_id = 'ingles' and numero = 5), 3, 5, 'tema', 'Can y could: poder y saber hacer', 'Can para lo que puedes o sabes hacer; can/could para pedir permiso (Unidad 5).')
on conflict (id) do update set unidad_id = excluded.unidad_id, episodio = excluded.episodio, orden = excluded.orden,
  tipo = excluded.tipo, titulo = excluded.titulo, descripcion = excluded.descripcion;
insert into ejercicios (id, leccion_id, orden, tipo, datos) values
  ('ep3-can-could-01', 'ep3-can-could', 1, 'elegir', '{"opciones": ["can", "cans", "am can"], "correcta": 0, "frase": "I ___ speak a little English.", "es": "Puedo hablar un poco de inglés.", "explicacion": "Can = poder / saber hacer algo. Es igual para todos: I can, you can, he can."}'::jsonb),
  ('ep3-can-could-02', 'ep3-can-could', 2, 'elegir', '{"opciones": ["can", "cans", "can to"], "correcta": 0, "frase": "She ___ drive.", "es": "Ella sabe manejar.", "explicacion": "Con can NO hay -s (she can) y el verbo va sin to: can drive."}'::jsonb),
  ('ep3-can-could-03', 'ep3-can-could', 3, 'elegir', '{"opciones": ["Can", "Do can", "Are"], "correcta": 0, "frase": "___ you swim? — Yes, I can.", "es": "¿Sabes nadar? — Sí.", "explicacion": "Para preguntar, can va primero: Can you swim? Respuesta corta: Yes, I can / No, I can''t."}'::jsonb),
  ('ep3-can-could-04', 'ep3-can-could', 4, 'elegir', '{"opciones": ["can''t", "don''t can", "not can"], "correcta": 0, "frase": "I ___ come today. I''m working.", "es": "No puedo venir hoy. Estoy trabajando.", "explicacion": "Negativo: can''t (= cannot). Nunca \"don''t can\"."}'::jsonb),
  ('ep3-can-could-05', 'ep3-can-could', 5, 'escribir', '{"respuestas": ["my wife can sell on tiktok", "my wife can sell shoes on tiktok", "my wife can sell on tik tok"], "mostrar": "My wife can sell on TikTok.", "es": "Mi esposa puede vender en TikTok.", "explicacion": "Sujeto + can + verbo base. Sin -s y sin to."}'::jsonb),
  ('ep3-can-could-06', 'ep3-can-could', 6, 'elegir', '{"opciones": ["Could I use your phone?", "I use your phone?", "Can I to use your phone?"], "correcta": 0, "frase": "¿Cuál es la forma más cortés de pedir permiso?", "es": "¿Podría usar su teléfono?", "explicacion": "Could I…? es más cortés que Can I…? Después de could/can, el verbo va sin to."}'::jsonb),
  ('ep3-can-could-07', 'ep3-can-could', 7, 'ordenar', '{"frase": "Can you help me please ?", "es": "¿Me puedes ayudar, por favor?", "explicacion": "Can + you + verbo + resto. Así pides ayuda de forma sencilla."}'::jsonb),
  ('ep3-can-could-08', 'ep3-can-could', 8, 'escuchar', '{"opciones": ["I can''t go to the party.", "I can go to the party.", "I can''t go to the park."], "correcta": 0, "audio": "I can''t go to the party.", "es": "No puedo ir a la fiesta.", "explicacion": "Can''t suena más largo y fuerte (/kænt/). Can suena corto y suave (/kən/)."}'::jsonb),
  ('ep3-can-could-09', 'ep3-can-could', 9, 'emparejar', '{"pares": [["I can", "yo puedo"], ["I can''t", "yo no puedo"], ["Can you…?", "¿Puedes…?"], ["Could you…?", "¿Podrías…?"]], "es": "", "explicacion": "Could es la forma más cortés de can para pedir algo."}'::jsonb),
  ('ep3-can-could-10', 'ep3-can-could', 10, 'escribir', '{"respuestas": ["i cant go today", "i cannot go today", "i can not go today"], "mostrar": "I can''t go today.", "es": "No puedo ir hoy.", "explicacion": "Can''t = cannot. Va igual con todas las personas."}'::jsonb)
on conflict (id) do update set orden = excluded.orden, tipo = excluded.tipo, datos = excluded.datos;
delete from ejercicios where leccion_id = 'ep3-can-could' and orden > 10;
insert into lecciones (id, materia_id, unidad_id, episodio, orden, tipo, titulo, descripcion)
values ('ep3-question-words', 'ingles', (select id from unidades where materia_id = 'ingles' and numero = 6), 3, 6, 'tema', 'Question words: what, where, when, who, how', 'Las palabras para preguntar, como en el taxi y en la llamada (Unidad 6).')
on conflict (id) do update set unidad_id = excluded.unidad_id, episodio = excluded.episodio, orden = excluded.orden,
  tipo = excluded.tipo, titulo = excluded.titulo, descripcion = excluded.descripcion;
insert into ejercicios (id, leccion_id, orden, tipo, datos) values
  ('ep3-question-words-01', 'ep3-question-words', 1, 'elegir', '{"opciones": ["Where", "When", "Who"], "correcta": 0, "frase": "___ do you live? — In Cúcuta.", "es": "¿Dónde vives? — En Cúcuta.", "explicacion": "Where = dónde. Se responde con un lugar."}'::jsonb),
  ('ep3-question-words-02', 'ep3-question-words', 2, 'elegir', '{"opciones": ["What", "Who", "Where"], "correcta": 0, "frase": "___ is your name? — Uwaldo.", "es": "¿Cuál es tu nombre? — Uwaldo.", "explicacion": "What = qué / cuál. What is your name? = ¿Cómo te llamas?"}'::jsonb),
  ('ep3-question-words-03', 'ep3-question-words', 3, 'elegir', '{"opciones": ["When", "Where", "Who"], "correcta": 0, "frase": "___ is the meeting? — Tomorrow.", "es": "¿Cuándo es la reunión? — Mañana.", "explicacion": "When = cuándo. Se responde con un momento."}'::jsonb),
  ('ep3-question-words-04', 'ep3-question-words', 4, 'elegir', '{"opciones": ["Who", "Whose", "What"], "correcta": 0, "frase": "___ is that man? — He''s my brother.", "es": "¿Quién es ese hombre? — Es mi hermano.", "explicacion": "Who = quién (una persona). Whose = de quién (el dueño de algo)."}'::jsonb),
  ('ep3-question-words-05', 'ep3-question-words', 5, 'elegir', '{"opciones": ["much", "many", "long"], "correcta": 0, "frase": "How ___ is the taxi to the airport? — Twenty thousand pesos.", "es": "¿Cuánto cuesta el taxi al aeropuerto? — Veinte mil pesos.", "explicacion": "How much = cuánto cuesta / cuánto (de algo que no se cuenta). How long = cuánto tiempo."}'::jsonb),
  ('ep3-question-words-06', 'ep3-question-words', 6, 'elegir', '{"opciones": ["time", "hour", "clock"], "correcta": 0, "frase": "What ___ is it? — It''s three o''clock.", "es": "¿Qué hora es? — Son las tres.", "explicacion": "Para la hora se dice What time is it? (no \"what hour\")."}'::jsonb),
  ('ep3-question-words-07', 'ep3-question-words', 7, 'emparejar', '{"pares": [["What?", "¿Qué? / ¿Cuál?"], ["Where?", "¿Dónde?"], ["When?", "¿Cuándo?"], ["Who?", "¿Quién?"], ["How?", "¿Cómo?"]], "es": "", "explicacion": "Las question words van al principio de la pregunta."}'::jsonb),
  ('ep3-question-words-08', 'ep3-question-words', 8, 'escribir', '{"respuestas": ["where do you work"], "mostrar": "Where do you work?", "es": "¿Dónde trabajas?", "explicacion": "Question word + do/does + sujeto + verbo: Where do you work?"}'::jsonb),
  ('ep3-question-words-09', 'ep3-question-words', 9, 'ordenar', '{"frase": "What time does the store open ?", "es": "¿A qué hora abre la tienda?", "explicacion": "What time + does + the store (= it) + open. Después de does el verbo va sin -s."}'::jsonb),
  ('ep3-question-words-10', 'ep3-question-words', 10, 'escuchar', '{"opciones": ["How long does it take?", "How much does it cost?", "How old are you?"], "correcta": 0, "audio": "How long does it take?", "es": "¿Cuánto tiempo se demora?", "explicacion": "How long = cuánto tiempo. How much = cuánto cuesta. How old = cuántos años."}'::jsonb),
  ('ep3-question-words-11', 'ep3-question-words', 11, 'elegir', '{"opciones": ["Why", "What", "How"], "correcta": 0, "frase": "___ do you study English? — Because I want a remote job.", "es": "¿Por qué estudias inglés? — Porque quiero un trabajo remoto.", "explicacion": "Why = por qué (pregunta). Because = porque (respuesta)."}'::jsonb),
  ('ep3-question-words-12', 'ep3-question-words', 12, 'escribir', '{"respuestas": ["how much is it", "how much is this", "how much does it cost", "how much does this cost"], "mostrar": "How much is it?", "es": "¿Cuánto cuesta?", "explicacion": "How much is it? es la forma más fácil de preguntar un precio."}'::jsonb)
on conflict (id) do update set orden = excluded.orden, tipo = excluded.tipo, datos = excluded.datos;
delete from ejercicios where leccion_id = 'ep3-question-words' and orden > 12;
insert into lecciones (id, materia_id, unidad_id, episodio, orden, tipo, titulo, descripcion)
values ('ep3-because-or', 'ingles', (select id from unidades where materia_id = 'ingles' and numero = 5), 3, 7, 'tema', 'Because, or, and, but, so: une tus ideas', 'Conectores para dar razones, opciones y resultados.')
on conflict (id) do update set unidad_id = excluded.unidad_id, episodio = excluded.episodio, orden = excluded.orden,
  tipo = excluded.tipo, titulo = excluded.titulo, descripcion = excluded.descripcion;
insert into ejercicios (id, leccion_id, orden, tipo, datos) values
  ('ep3-because-or-01', 'ep3-because-or', 1, 'elegir', '{"opciones": ["because", "but", "or"], "correcta": 0, "frase": "I study English ___ I want to work remotely.", "es": "Estudio inglés porque quiero trabajar remoto.", "explicacion": "Because = porque. Explica la razón."}'::jsonb),
  ('ep3-because-or-02', 'ep3-because-or', 2, 'elegir', '{"opciones": ["or", "but", "so"], "correcta": 0, "frase": "Would you like tea ___ coffee?", "es": "¿Le gustaría té o café?", "explicacion": "Or = o. Sirve para dar opciones."}'::jsonb),
  ('ep3-because-or-03', 'ep3-because-or', 3, 'elegir', '{"opciones": ["but", "because", "or"], "correcta": 0, "frase": "I want to go, ___ I can''t. I''m working.", "es": "Quiero ir, pero no puedo. Estoy trabajando.", "explicacion": "But = pero. Une dos ideas que se contradicen."}'::jsonb),
  ('ep3-because-or-04', 'ep3-because-or', 4, 'elegir', '{"opciones": ["so", "because", "or"], "correcta": 0, "frase": "It''s raining, ___ I''m taking a taxi.", "es": "Está lloviendo, así que voy a tomar un taxi.", "explicacion": "So = así que / entonces. Dice el resultado."}'::jsonb),
  ('ep3-because-or-05', 'ep3-because-or', 5, 'elegir', '{"opciones": ["Because", "So", "But"], "correcta": 0, "frase": "Why are you tired? — ___ I work a lot.", "es": "¿Por qué estás cansado? — Porque trabajo mucho.", "explicacion": "A una pregunta con Why se responde con Because."}'::jsonb),
  ('ep3-because-or-06', 'ep3-because-or', 6, 'escribir', '{"respuestas": ["i study because i want a new job"], "mostrar": "I study because I want a new job.", "es": "Estudio porque quiero un trabajo nuevo.", "explicacion": "Because + sujeto + verbo. En inglés el adjetivo va antes: a new job."}'::jsonb),
  ('ep3-because-or-07', 'ep3-because-or', 7, 'ordenar', '{"frase": "Do you want cash or card ?", "es": "¿Quiere efectivo o tarjeta?", "explicacion": "Or (o) une las dos opciones."}'::jsonb),
  ('ep3-because-or-08', 'ep3-because-or', 8, 'emparejar', '{"pares": [["and", "y"], ["but", "pero"], ["so", "así que"], ["because", "porque"], ["or", "o"]], "es": "", "explicacion": "Cinco conectores básicos para unir ideas."}'::jsonb),
  ('ep3-because-or-09', 'ep3-because-or', 9, 'escuchar', '{"opciones": ["I''m late because the traffic is bad.", "I''m late but the traffic is bad.", "I''m late so the traffic is bad."], "correcta": 0, "audio": "I''m late because the traffic is bad.", "es": "Llego tarde porque el tráfico está malo.", "explicacion": "Because da la razón de llegar tarde."}'::jsonb),
  ('ep3-because-or-10', 'ep3-because-or', 10, 'escribir', '{"respuestas": ["i would like to go but i am busy", "id like to go but im busy", "i would like to go but im busy", "id like to go but i am busy"], "mostrar": "I''d like to go, but I''m busy.", "es": "Me gustaría ir, pero estoy ocupado.", "explicacion": "I''d like = me gustaría. But = pero."}'::jsonb)
on conflict (id) do update set orden = excluded.orden, tipo = excluded.tipo, datos = excluded.datos;
delete from ejercicios where leccion_id = 'ep3-because-or' and orden > 10;
insert into lecciones (id, materia_id, unidad_id, episodio, orden, tipo, titulo, descripcion)
values ('ep1-to-be', 'ingles', (select id from unidades where materia_id = 'ingles' and numero = 1), 1, 2, 'refuerzo', 'To be: I am, you are, he is', 'El verbo ser/estar y el error "I am study".')
on conflict (id) do update set unidad_id = excluded.unidad_id, episodio = excluded.episodio, orden = excluded.orden,
  tipo = excluded.tipo, titulo = excluded.titulo, descripcion = excluded.descripcion;
insert into ejercicios (id, leccion_id, orden, tipo, datos) values
  ('ep1-to-be-01', 'ep1-to-be', 1, 'elegir', '{"opciones": ["am", "is", "are"], "correcta": 0, "frase": "I ___ a businessman.", "es": "Soy empresario.", "explicacion": "I → am. He/she/it → is. You/we/they → are."}'::jsonb),
  ('ep1-to-be-02', 'ep1-to-be', 2, 'elegir', '{"opciones": ["are", "is", "am"], "correcta": 0, "frase": "They ___ my children.", "es": "Ellos son mis hijos.", "explicacion": "They (ellos) → are."}'::jsonb),
  ('ep1-to-be-03', 'ep1-to-be', 3, 'elegir', '{"opciones": ["is", "are", "am"], "correcta": 0, "frase": "Maria ___ my wife.", "es": "María es mi esposa.", "explicacion": "Maria = she → is."}'::jsonb),
  ('ep1-to-be-04', 'ep1-to-be', 4, 'elegir', '{"opciones": ["I study data analysis.", "I am study data analysis.", "I studying data analysis."], "correcta": 0, "frase": "¿Cuál está bien escrita?", "es": "Estudio análisis de datos.", "explicacion": "No se mezcla am con otro verbo. Para lo habitual: I study. (I am + adjetivo o profesión: I am tired, I am a student.)"}'::jsonb),
  ('ep1-to-be-05', 'ep1-to-be', 5, 'elegir', '{"opciones": ["isn''t", "aren''t", "not"], "correcta": 0, "frase": "He ___ a doctor. He''s a nurse.", "es": "Él no es médico. Es enfermero.", "explicacion": "Negativo de is: is not = isn''t."}'::jsonb),
  ('ep1-to-be-06', 'ep1-to-be', 6, 'elegir', '{"opciones": ["Are", "Is", "Do"], "correcta": 0, "frase": "___ you from Colombia? — Yes, I am.", "es": "¿Eres de Colombia? — Sí.", "explicacion": "Para preguntar, el verbo to be va primero: Are you…? Is she…?"}'::jsonb),
  ('ep1-to-be-07', 'ep1-to-be', 7, 'emparejar', '{"pares": [["I am", "I''m"], ["you are", "you''re"], ["she is", "she''s"], ["we are", "we''re"]], "es": "", "explicacion": "Las contracciones son la forma normal de hablar: I''m, you''re, she''s, we''re."}'::jsonb),
  ('ep1-to-be-08', 'ep1-to-be', 8, 'escribir', '{"respuestas": ["we are from cucuta", "we are from cúcuta", "were from cucuta", "were from cúcuta"], "mostrar": "We are from Cúcuta.", "es": "Somos de Cúcuta.", "explicacion": "We (nosotros) → are. From = de (origen)."}'::jsonb),
  ('ep1-to-be-09', 'ep1-to-be', 9, 'escuchar', '{"opciones": ["She''s a teacher.", "He''s a teacher.", "She has a teacher."], "correcta": 0, "audio": "She''s a teacher.", "es": "Ella es profesora.", "explicacion": "She''s = she is. Fíjate en el sonido /shi/ (she) y no /ji/ (he)."}'::jsonb),
  ('ep1-to-be-10', 'ep1-to-be', 10, 'ordenar', '{"frase": "Is your wife from Colombia ?", "es": "¿Tu esposa es de Colombia?", "explicacion": "Pregunta con to be: Is + sujeto + resto."}'::jsonb)
on conflict (id) do update set orden = excluded.orden, tipo = excluded.tipo, datos = excluded.datos;
delete from ejercicios where leccion_id = 'ep1-to-be' and orden > 10;
insert into lecciones (id, materia_id, unidad_id, episodio, orden, tipo, titulo, descripcion)
values ('ep1-profesiones-clima', 'ingles', (select id from unidades where materia_id = 'ingles' and numero = 1), 1, 3, 'refuerzo', 'Profesiones y el clima', 'Decir a qué te dedicas (con a/an) y cómo está el tiempo (It''s…).')
on conflict (id) do update set unidad_id = excluded.unidad_id, episodio = excluded.episodio, orden = excluded.orden,
  tipo = excluded.tipo, titulo = excluded.titulo, descripcion = excluded.descripcion;
insert into ejercicios (id, leccion_id, orden, tipo, datos) values
  ('ep1-profesiones-clima-01', 'ep1-profesiones-clima', 1, 'emparejar', '{"pares": [["nurse", "enfermero(a)"], ["engineer", "ingeniero(a)"], ["salesman", "vendedor"], ["lawyer", "abogado(a)"]], "es": "", "explicacion": "Profesiones comunes. En inglés casi no cambian por género."}'::jsonb),
  ('ep1-profesiones-clima-02', 'ep1-profesiones-clima', 2, 'elegir', '{"opciones": ["a", "an", "the"], "correcta": 0, "frase": "What do you do? — I''m ___ salesman.", "es": "¿A qué te dedicas? — Soy vendedor.", "explicacion": "En inglés la profesión lleva a/an: I''m a salesman. En español no se dice \"un\"."}'::jsonb),
  ('ep1-profesiones-clima-03', 'ep1-profesiones-clima', 3, 'elegir', '{"opciones": ["an", "a"], "correcta": 0, "frase": "My brother is ___ architect.", "es": "Mi hermano es arquitecto.", "explicacion": "Architect empieza con sonido de vocal → an architect."}'::jsonb),
  ('ep1-profesiones-clima-04', 'ep1-profesiones-clima', 4, 'elegir', '{"opciones": ["sunny", "sun", "sunning"], "correcta": 0, "frase": "What''s the weather like? — It''s ___.", "es": "¿Cómo está el clima? — Está soleado.", "explicacion": "El clima se dice con It''s + adjetivo: It''s sunny, It''s hot.", "pista": "(soleado)"}'::jsonb),
  ('ep1-profesiones-clima-05', 'ep1-profesiones-clima', 5, 'elegir', '{"opciones": ["rainy", "sunny", "hot"], "correcta": 0, "frase": "It''s ___ today. Take an umbrella.", "es": "Hoy está lluvioso. Lleva una sombrilla.", "explicacion": "Rainy = lluvioso. Rain = lluvia."}'::jsonb),
  ('ep1-profesiones-clima-06', 'ep1-profesiones-clima', 6, 'emparejar', '{"pares": [["hot", "caluroso"], ["cold", "frío"], ["rainy", "lluvioso"], ["cloudy", "nublado"]], "es": "", "explicacion": "Palabras del clima: todas van con It''s."}'::jsonb),
  ('ep1-profesiones-clima-07', 'ep1-profesiones-clima', 7, 'escribir', '{"respuestas": ["i am a data analyst", "im a data analyst"], "mostrar": "I''m a data analyst.", "es": "Soy analista de datos.", "explicacion": "Profesión con a/an: I''m a data analyst."}'::jsonb),
  ('ep1-profesiones-clima-08', 'ep1-profesiones-clima', 8, 'escribir', '{"respuestas": ["it is hot in cucuta", "it is hot in cúcuta", "its hot in cucuta", "its hot in cúcuta", "it is very hot in cucuta", "it is very hot in cúcuta", "its very hot in cucuta", "its very hot in cúcuta"], "mostrar": "It''s hot in Cúcuta.", "es": "Hace calor en Cúcuta.", "explicacion": "Hacer calor = It''s hot. En inglés el clima siempre lleva It''s."}'::jsonb),
  ('ep1-profesiones-clima-09', 'ep1-profesiones-clima', 9, 'escuchar', '{"opciones": ["It''s cloudy and cold.", "It''s sunny and cold.", "It''s cloudy and hot."], "correcta": 0, "audio": "It''s cloudy and cold.", "es": "Está nublado y frío.", "explicacion": "Cloudy = nublado. Cold = frío."}'::jsonb),
  ('ep1-profesiones-clima-10', 'ep1-profesiones-clima', 10, 'ordenar', '{"frase": "My wife is a businesswoman .", "es": "Mi esposa es empresaria.", "explicacion": "Sujeto + is + a + profesión."}'::jsonb)
on conflict (id) do update set orden = excluded.orden, tipo = excluded.tipo, datos = excluded.datos;
delete from ejercicios where leccion_id = 'ep1-profesiones-clima' and orden > 10;
insert into lecciones (id, materia_id, unidad_id, episodio, orden, tipo, titulo, descripcion)
values ('ep1-adjetivos-cuerpo', 'ingles', (select id from unidades where materia_id = 'ingles' and numero = 2), 1, 4, 'refuerzo', 'Describir personas: adjetivos y cuerpo', 'El adjetivo va antes del sustantivo y no lleva -s (Unidad 2).')
on conflict (id) do update set unidad_id = excluded.unidad_id, episodio = excluded.episodio, orden = excluded.orden,
  tipo = excluded.tipo, titulo = excluded.titulo, descripcion = excluded.descripcion;
insert into ejercicios (id, leccion_id, orden, tipo, datos) values
  ('ep1-adjetivos-cuerpo-01', 'ep1-adjetivos-cuerpo', 1, 'elegir', '{"opciones": ["long", "longs", "a long"], "correcta": 0, "frase": "She has ___ hair.", "es": "Ella tiene el pelo largo.", "explicacion": "El adjetivo nunca lleva -s y va antes: long hair. Hair no lleva a."}'::jsonb),
  ('ep1-adjetivos-cuerpo-02', 'ep1-adjetivos-cuerpo', 2, 'elegir', '{"opciones": ["He has a red car.", "He has a car red.", "He has red a car."], "correcta": 0, "frase": "¿Cómo se dice: Él tiene un carro rojo?", "es": "Él tiene un carro rojo.", "explicacion": "En inglés el adjetivo va ANTES del sustantivo: a red car."}'::jsonb),
  ('ep1-adjetivos-cuerpo-03', 'ep1-adjetivos-cuerpo', 3, 'emparejar', '{"pares": [["head", "cabeza"], ["eyes", "ojos"], ["hands", "manos"], ["legs", "piernas"]], "es": "", "explicacion": "Partes del cuerpo. Eyes, hands y legs van en plural."}'::jsonb),
  ('ep1-adjetivos-cuerpo-04', 'ep1-adjetivos-cuerpo', 4, 'elegir', '{"opciones": ["eyes", "eye", "eyeses"], "correcta": 0, "frase": "Laura has big brown ___.", "es": "Laura tiene ojos grandes y cafés.", "explicacion": "Dos ojos → eyes. Los adjetivos (big, brown) van antes."}'::jsonb),
  ('ep1-adjetivos-cuerpo-05', 'ep1-adjetivos-cuerpo', 5, 'elegir', '{"opciones": ["short", "small", "thin"], "correcta": 0, "frase": "¿Qué es lo contrario de tall?", "es": "Lo contrario de alto es bajo.", "explicacion": "Tall/short es para altura. Big/small es para tamaño."}'::jsonb),
  ('ep1-adjetivos-cuerpo-06', 'ep1-adjetivos-cuerpo', 6, 'emparejar', '{"pares": [["tall", "short"], ["young", "old"], ["fat", "thin"], ["happy", "sad"]], "es": "", "explicacion": "Adjetivos contrarios para describir personas."}'::jsonb),
  ('ep1-adjetivos-cuerpo-07', 'ep1-adjetivos-cuerpo', 7, 'escribir', '{"respuestas": ["my wife is very beautiful", "my wife is very pretty"], "mostrar": "My wife is very beautiful.", "es": "Mi esposa es muy bonita.", "explicacion": "My wife is… (no \"my wife it''s\"). Beautiful se escribe con -eau-."}'::jsonb),
  ('ep1-adjetivos-cuerpo-08', 'ep1-adjetivos-cuerpo', 8, 'escuchar', '{"opciones": ["He has short black hair.", "He has short brown hair.", "She has short black hair."], "correcta": 0, "audio": "He has short black hair.", "es": "Él tiene el pelo corto y negro.", "explicacion": "Primero el tamaño (short), luego el color (black), luego la cosa (hair)."}'::jsonb),
  ('ep1-adjetivos-cuerpo-09', 'ep1-adjetivos-cuerpo', 9, 'ordenar', '{"frase": "Laura has long blond hair .", "es": "Laura tiene el pelo largo y rubio.", "explicacion": "Has + adjetivos + hair."}'::jsonb),
  ('ep1-adjetivos-cuerpo-10', 'ep1-adjetivos-cuerpo', 10, 'escribir', '{"respuestas": ["he has green eyes"], "mostrar": "He has green eyes.", "es": "Él tiene los ojos verdes.", "explicacion": "En inglés no se dice \"the\": He has green eyes."}'::jsonb)
on conflict (id) do update set orden = excluded.orden, tipo = excluded.tipo, datos = excluded.datos;
delete from ejercicios where leccion_id = 'ep1-adjetivos-cuerpo' and orden > 10;
insert into lecciones (id, materia_id, unidad_id, episodio, orden, tipo, titulo, descripcion)
values ('ep1-comparativos', 'ingles', (select id from unidades where materia_id = 'ingles' and numero = 2), 1, 5, 'refuerzo', 'Comparativos y superlativos', 'Taller than, more expensive than, the biggest.')
on conflict (id) do update set unidad_id = excluded.unidad_id, episodio = excluded.episodio, orden = excluded.orden,
  tipo = excluded.tipo, titulo = excluded.titulo, descripcion = excluded.descripcion;
insert into ejercicios (id, leccion_id, orden, tipo, datos) values
  ('ep1-comparativos-01', 'ep1-comparativos', 1, 'elegir', '{"opciones": ["taller", "more tall", "tallest"], "correcta": 0, "frase": "Tom is ___ than Laura.", "es": "Tom es más alto que Laura.", "explicacion": "Adjetivo corto + -er + than: taller than."}'::jsonb),
  ('ep1-comparativos-02', 'ep1-comparativos', 2, 'elegir', '{"opciones": ["more expensive", "expensiver", "expensivest"], "correcta": 0, "frase": "This phone is ___ than that one.", "es": "Este teléfono es más caro que ese.", "explicacion": "Adjetivo largo: more + adjetivo + than."}'::jsonb),
  ('ep1-comparativos-03', 'ep1-comparativos', 3, 'elegir', '{"opciones": ["colder", "more cold", "coldest"], "correcta": 0, "frase": "Bogotá is ___ than Cúcuta.", "es": "Bogotá es más fría que Cúcuta.", "explicacion": "Cold es corto → colder.", "pista": "(más fría)"}'::jsonb),
  ('ep1-comparativos-04', 'ep1-comparativos', 4, 'elegir', '{"opciones": ["biggest", "bigger", "most big"], "correcta": 0, "frase": "This is the ___ store in the mall.", "es": "Esta es la tienda más grande del centro comercial.", "explicacion": "Superlativo: the + -est. Big dobla la g: big → bigger → biggest.", "pista": "(más grande)"}'::jsonb),
  ('ep1-comparativos-05', 'ep1-comparativos', 5, 'elegir', '{"opciones": ["most intelligent", "intelligentest", "more intelligent"], "correcta": 0, "frase": "She is the ___ student in the class.", "es": "Ella es la estudiante más inteligente de la clase.", "explicacion": "Adjetivo largo en superlativo: the most + adjetivo."}'::jsonb),
  ('ep1-comparativos-06', 'ep1-comparativos', 6, 'emparejar', '{"pares": [["good", "better"], ["bad", "worse"], ["big", "bigger"], ["happy", "happier"]], "es": "", "explicacion": "Good y bad son irregulares. Happy cambia la y por -ier."}'::jsonb),
  ('ep1-comparativos-07', 'ep1-comparativos', 7, 'escribir', '{"respuestas": ["my brother is taller than me", "my brother is taller than i am", "my brother is taller than i"], "mostrar": "My brother is taller than me.", "es": "Mi hermano es más alto que yo.", "explicacion": "Más … que = -er + than."}'::jsonb),
  ('ep1-comparativos-08', 'ep1-comparativos', 8, 'escuchar', '{"opciones": ["Coffee is better than tea.", "Coffee is bigger than tea.", "Coffee is better than me."], "correcta": 0, "audio": "Coffee is better than tea.", "es": "El café es mejor que el té.", "explicacion": "Better = mejor (comparativo de good)."}'::jsonb),
  ('ep1-comparativos-09', 'ep1-comparativos', 9, 'ordenar', '{"frase": "These shoes are cheaper than those shoes .", "es": "Estos zapatos son más baratos que esos zapatos.", "explicacion": "Cheap → cheaper than. These/those van con plural."}'::jsonb),
  ('ep1-comparativos-10', 'ep1-comparativos', 10, 'escribir', '{"respuestas": ["it is the best store in cucuta", "it is the best store in cúcuta", "its the best store in cucuta", "its the best store in cúcuta", "it is the best shop in cucuta", "it is the best shop in cúcuta", "its the best shop in cucuta", "its the best shop in cúcuta"], "mostrar": "It''s the best store in Cúcuta.", "es": "Es la mejor tienda de Cúcuta.", "explicacion": "Good → better → the best. \"De\" en superlativo con lugares = in."}'::jsonb)
on conflict (id) do update set orden = excluded.orden, tipo = excluded.tipo, datos = excluded.datos;
delete from ejercicios where leccion_id = 'ep1-comparativos' and orden > 10;
-- Simulacro del Episodio 3: 3 preguntas más con los temas nuevos
insert into ejercicios (id, leccion_id, orden, tipo, datos) values
  ('ep3-simulacro-13', 'ep3-simulacro', 13, 'elegir', '{"opciones": ["can", "cans", "can to"], "correcta": 0, "frase": "She ___ speak French.", "es": "Ella sabe hablar francés.", "explicacion": "Can no lleva -s y el verbo va sin to."}'::jsonb),
  ('ep3-simulacro-14', 'ep3-simulacro', 14, 'elegir', '{"opciones": ["Where", "Whose", "When"], "correcta": 0, "frase": "___ do you live? — Near the airport.", "es": "¿Dónde vives? — Cerca del aeropuerto.", "explicacion": "Where = dónde."}'::jsonb),
  ('ep3-simulacro-15', 'ep3-simulacro', 15, 'elegir', '{"opciones": ["because", "or", "so"], "correcta": 0, "frase": "I''m happy ___ I have a new job.", "es": "Estoy feliz porque tengo un trabajo nuevo.", "explicacion": "Because explica la razón."}'::jsonb)
on conflict (id) do update set orden = excluded.orden, tipo = excluded.tipo, datos = excluded.datos;

-- Listo: 1 tabla nueva, 7 lecciones nuevas y 75 ejercicios nuevos.
