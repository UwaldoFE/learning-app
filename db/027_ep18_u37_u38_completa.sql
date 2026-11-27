-- =====================================================================
-- 027 · Episodio 18 completo (Unidades 37 y 38 del Libro 3)
--   - 8 temas nuevos en pensum_temas (orden 1-8 del Episodio 18):
--     Unidad 37 (Leisure: Museums & The Theater): reported speech, say/tell,
--       homófonos, arte y teatro.
--     Unidad 38 (Congratulations): condicional cero, primer condicional,
--       felicitaciones, preguntas y órdenes en estilo indirecto.
--   - 8 lecciones tipo 'tema' (8 ejercicios cada una)
--   - banco-ep18 +8·8 = 64 ejercicios de práctica
--   - examen-ep18 +8·3 = 24 ejercicios reservados
--   - 8×19 = 152 ejercicios en total
--   - 'escuchar' de lección y examen va pata 'input'.
-- Requiere 006, 007, 008 y 011. Se puede correr varias veces sin dañar nada.
-- Pega TODO este archivo en Supabase → SQL Editor → Run.
-- =====================================================================

insert into unidades (materia_id, numero, episodio, objetivo) values
  ('ingles', 37, 'Episodio 18', 'Reported speech, say and tell, homophones, art and theater'),
  ('ingles', 38, 'Episodio 18', 'Zero and first conditionals, congratulations, reported questions and commands')
on conflict (materia_id, numero) do update set
  episodio = excluded.episodio,
  objetivo = coalesce(nullif(unidades.objetivo, ''), excluded.objetivo);

insert into lecciones (id, materia_id, unidad_id, episodio, orden, tipo, titulo, descripcion) values
  ('banco-ep18', 'ingles', (select id from unidades where materia_id = 'ingles' and numero = 37), 18, 90, 'banco', 'Banco de ejercicios Episodio 18', 'Ejercicios de refuerzo - Episodio 18'),
  ('examen-ep18', 'ingles', (select id from unidades where materia_id = 'ingles' and numero = 37), 18, 91, 'examen', 'Examen Episodio 18', 'Evaluación - Episodio 18')
on conflict (id) do update set
  materia_id = excluded.materia_id, unidad_id = excluded.unidad_id, episodio = excluded.episodio,
  orden = excluded.orden, tipo = excluded.tipo, titulo = excluded.titulo, descripcion = excluded.descripcion;

insert into pensum_temas (id, episodio, orden, nombre_es, nombre_en, descripcion) values
  ('ep18-reported-speech', 18, 1, $t$Estilo indirecto (reported speech)$t$, $t$Reported speech$t$, $t$Al pasar al estilo indirecto el tiempo retrocede: am/is → was, will → would, lives → lived.$t$),
  ('ep18-say-tell', 18, 2, $t$Say y tell$t$, $t$Say and tell$t$, $t$say no lleva persona (said that...). tell sí (told me that...). Verbos como admit, explain y suggest van sin persona.$t$),
  ('ep18-homofonos', 18, 3, $t$Homófonos$t$, $t$Homophones$t$, $t$Suenan igual pero se escriben distinto: sea/see, sun/son, right/write, hear/here, meet/meat.$t$),
  ('ep18-arte-teatro', 18, 4, $t$Arte y teatro$t$, $t$Art and theater$t$, $t$museum, gallery, modern art, musical, play, performance, tickets: vocabulario de museos y teatro.$t$),
  ('ep18-condicional-cero', 18, 5, $t$Condicional cero$t$, $t$Zero conditional$t$, $t$If + presente simple, presente simple: hechos y verdades generales. If water reaches 100 degrees, it boils.$t$),
  ('ep18-primer-condicional', 18, 6, $t$Primer condicional$t$, $t$First conditional$t$, $t$If + presente simple, will + infinitivo: posibilidades reales en el futuro. If it rains, I won't go.$t$),
  ('ep18-felicitaciones', 18, 7, $t$Felicitar y expresar alegría$t$, $t$Congratulating and expressing happiness$t$, $t$Congratulations! I'm so happy for you. You really deserve it. You make a beautiful couple.$t$),
  ('ep18-preguntas-ordenes-indirecto', 18, 8, $t$Preguntas y órdenes en estilo indirecto$t$, $t$Reported questions and commands$t$, $t$asked me if / asked where: preguntas. told him to: órdenes. Ej.: She asked me where I lived.$t$)
on conflict (id) do update set episodio = excluded.episodio, orden = excluded.orden,
  nombre_es = excluded.nombre_es, nombre_en = excluded.nombre_en, descripcion = excluded.descripcion;

insert into lecciones (id, materia_id, unidad_id, episodio, orden, tipo, titulo, descripcion) values
  ('ep18-reported-speech', 'ingles', (select id from unidades where materia_id = 'ingles' and numero = 37), 18, 1, 'tema', $t$Reported speech$t$, $t$Al pasar al estilo indirecto el tiempo retrocede: am/is → was, will → would, lives → lived.$t$),
  ('ep18-say-tell', 'ingles', (select id from unidades where materia_id = 'ingles' and numero = 37), 18, 2, 'tema', $t$Say and tell$t$, $t$say no lleva persona (said that...). tell sí (told me that...). Verbos como admit, explain y suggest van sin persona.$t$),
  ('ep18-homofonos', 'ingles', (select id from unidades where materia_id = 'ingles' and numero = 37), 18, 3, 'tema', $t$Homophones$t$, $t$Suenan igual pero se escriben distinto: sea/see, sun/son, right/write, hear/here, meet/meat.$t$),
  ('ep18-arte-teatro', 'ingles', (select id from unidades where materia_id = 'ingles' and numero = 37), 18, 4, 'tema', $t$Art and theater$t$, $t$museum, gallery, modern art, musical, play, performance, tickets: vocabulario de museos y teatro.$t$),
  ('ep18-condicional-cero', 'ingles', (select id from unidades where materia_id = 'ingles' and numero = 38), 18, 5, 'tema', $t$Zero conditional$t$, $t$If + presente simple, presente simple: hechos y verdades generales. If water reaches 100 degrees, it boils.$t$),
  ('ep18-primer-condicional', 'ingles', (select id from unidades where materia_id = 'ingles' and numero = 38), 18, 6, 'tema', $t$First conditional$t$, $t$If + presente simple, will + infinitivo: posibilidades reales en el futuro. If it rains, I won't go.$t$),
  ('ep18-felicitaciones', 'ingles', (select id from unidades where materia_id = 'ingles' and numero = 38), 18, 7, 'tema', $t$Congratulating and expressing happiness$t$, $t$Congratulations! I'm so happy for you. You really deserve it. You make a beautiful couple.$t$),
  ('ep18-preguntas-ordenes-indirecto', 'ingles', (select id from unidades where materia_id = 'ingles' and numero = 38), 18, 8, 'tema', $t$Reported questions and commands$t$, $t$asked me if / asked where: preguntas. told him to: órdenes. Ej.: She asked me where I lived.$t$)
on conflict (id) do update set unidad_id = excluded.unidad_id, episodio = excluded.episodio, orden = excluded.orden,
  tipo = excluded.tipo, titulo = excluded.titulo, descripcion = excluded.descripcion;


-- EJERCICIOS — TEMA 1: ep18-reported-speech
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('ep18-rspe-01', 'ep18-reported-speech', 1, 'elegir',
 $j${"frase": "He said that he ___ tired.", "opciones": ["was", "is", "will be", "be"], "correcta": 0, "es": "Dijo que estaba cansado.", "explicacion": "is → was (retroceso de tiempo)."}$j$::jsonb,
 'ep18-reported-speech', 'estudio', false),
('ep18-rspe-02', 'ep18-reported-speech', 2, 'elegir',
 $j${"frase": "She said she ___ come to the party.", "opciones": ["would", "will", "is", "does"], "correcta": 0, "es": "Dijo que iría a la fiesta.", "explicacion": "will → would."}$j$::jsonb,
 'ep18-reported-speech', 'estudio', false),
('ep18-rspe-03', 'ep18-reported-speech', 3, 'elegir',
 $j${"frase": "They said they ___ the book last week.", "opciones": ["had read", "read", "have read", "reads"], "correcta": 0, "es": "Dijeron que habían leído el libro la semana pasada.", "explicacion": "have read → had read."}$j$::jsonb,
 'ep18-reported-speech', 'estudio', false),
('ep18-rspe-04', 'ep18-reported-speech', 4, 'elegir',
 $j${"frase": "Mary said she ___ in Cúcuta.", "opciones": ["lived", "lives", "will live", "living"], "correcta": 0, "es": "Mary dijo que vivía en Cúcuta.", "explicacion": "lives → lived."}$j$::jsonb,
 'ep18-reported-speech', 'estudio', false),
('ep18-rspe-05', 'ep18-reported-speech', 5, 'escribir',
 $j${"respuestas": ["he said he was tired", "he said that he was tired"], "mostrar": "He said that he was tired.", "es": "Dijo que estaba cansado.", "explicacion": "am → was en estilo indirecto."}$j$::jsonb,
 'ep18-reported-speech', 'estudio', false),
('ep18-rspe-06', 'ep18-reported-speech', 6, 'ordenar',
 $j${"frase": "She said that she was busy.", "es": "Ella dijo que estaba ocupada.", "explicacion": "said that + sujeto + verbo en pasado."}$j$::jsonb,
 'ep18-reported-speech', 'estudio', false),
('ep18-rspe-07', 'ep18-reported-speech', 7, 'emparejar',
 $j${"pares": [["I am tired", "estoy cansado"], ["I will come", "vendré"], ["I went", "fui"], ["I have finished", "he terminado"]], "es": "", "explicacion": "En estilo indirecto estos tiempos retroceden."}$j$::jsonb,
 'ep18-reported-speech', 'estudio', false),
('ep18-rspe-08', 'ep18-reported-speech', 8, 'escuchar',
 $j${"opciones": ["He said that he was happy.", "He says he is happy yesterday.", "He said he will be happy.", "He said he is happy."], "correcta": 0, "audio": "He said that he was happy.", "es": "Dijo que estaba feliz.", "explicacion": "is → was."}$j$::jsonb,
 'ep18-reported-speech', 'input', false)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('banco-ep18-rspe-01', 'banco-ep18', 1, 'comprension',
 $j${"modo": "escuchar", "lineas": [{"en": "Ana said that she was going to the museum on Sunday.", "es": "Ana dijo que iba a ir al museo el domingo."}, {"en": "She said that the tickets were cheap.", "es": "Dijo que las entradas eran baratas."}], "pregunta": "What did Ana say about the tickets?", "pregunta_es": "¿Qué dijo Ana de las entradas?", "opciones": ["They were cheap", "They were sold out", "They were expensive", "They were free"], "correcta": 0, "explicacion": "'She said that the tickets were cheap.'"}$j$::jsonb,
 'ep18-reported-speech', 'input', false),
('banco-ep18-rspe-02', 'banco-ep18', 2, 'comprension',
 $j${"modo": "leer", "lineas": [{"en": "Peter told me that he would meet me at the theater.", "es": "Peter me dijo que me encontraría en el teatro."}, {"en": "He said he had already bought the tickets.", "es": "Dijo que ya había comprado las entradas."}], "pregunta": "Where will Peter meet the speaker?", "pregunta_es": "¿Dónde se encontrará Peter con el hablante?", "opciones": ["At the theater", "At the museum", "At home", "At the airport"], "correcta": 0, "explicacion": "'he would meet me at the theater.'"}$j$::jsonb,
 'ep18-reported-speech', 'input', false),
('banco-ep18-rspe-03', 'banco-ep18', 3, 'decir',
 $j${"es": "Dijo que estaba muy cansada.", "respuestas": ["she said that she was very tired", "she said she was very tired"], "mostrar": "She said that she was very tired.", "explicacion": "am/is → was."}$j$::jsonb,
 'ep18-reported-speech', 'output', false),
('banco-ep18-rspe-04', 'banco-ep18', 4, 'decir',
 $j${"es": "Dijeron que vendrían mañana.", "respuestas": ["they said that they would come tomorrow", "they said they would come tomorrow"], "mostrar": "They said they would come tomorrow.", "explicacion": "will → would."}$j$::jsonb,
 'ep18-reported-speech', 'output', false),
('banco-ep18-rspe-05', 'banco-ep18', 5, 'libre',
 $j${"pregunta": "Report what a friend said yesterday using said that. Write two sentences.", "pregunta_es": "Cuenta lo que dijo un amigo ayer usando said that. Escribe dos frases.", "ejemplo": "My friend said that he was hungry. He said he had lost his keys.", "criterio": "said + that + tiempo retrocedido.", "explicacion": "El tiempo retrocede al pasar a indirecto."}$j$::jsonb,
 'ep18-reported-speech', 'output', false),
('banco-ep18-rspe-06', 'banco-ep18', 6, 'rapido',
 $j${"frase": "She said she ___ busy.", "opciones": ["was", "is"], "correcta": 0, "es": "Dijo que estaba ocupada.", "explicacion": "is → was.", "segundos": 5}$j$::jsonb,
 'ep18-reported-speech', 'fluidez', false),
('banco-ep18-rspe-07', 'banco-ep18', 7, 'rapido',
 $j${"frase": "He said he ___ call me.", "opciones": ["would", "will"], "correcta": 0, "es": "Dijo que me llamaría.", "explicacion": "will → would.", "segundos": 5}$j$::jsonb,
 'ep18-reported-speech', 'fluidez', false),
('banco-ep18-rspe-08', 'banco-ep18', 8, 'rapido',
 $j${"frase": "They said they ___ at home.", "opciones": ["were", "are"], "correcta": 0, "es": "Dijeron que estaban en casa.", "explicacion": "are → were.", "segundos": 5}$j$::jsonb,
 'ep18-reported-speech', 'fluidez', false)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('examen-ep18-rspe-01', 'examen-ep18', 1, 'elegir',
 $j${"frase": "Tom said he ___ the money.", "opciones": ["had lost", "lost", "loses"], "correcta": 0, "es": "Tom dijo que había perdido el dinero.", "explicacion": "lost → had lost."}$j$::jsonb,
 'ep18-reported-speech', 'estudio', true),
('examen-ep18-rspe-02', 'examen-ep18', 2, 'escribir',
 $j${"respuestas": ["she said she was happy"], "mostrar": "She said she was happy.", "es": "Dijo que estaba feliz.", "explicacion": "is → was."}$j$::jsonb,
 'ep18-reported-speech', 'estudio', true),
('examen-ep18-rspe-03', 'examen-ep18', 3, 'escuchar',
 $j${"opciones": ["He said he would call later.", "He says he will call later.", "He said he call later.", "He said he called later yesterday."], "correcta": 0, "audio": "He said he would call later.", "es": "Dijo que llamaría más tarde.", "explicacion": "will → would."}$j$::jsonb,
 'ep18-reported-speech', 'input', true)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;

-- EJERCICIOS — TEMA 2: ep18-say-tell
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('ep18-saytell-01', 'ep18-say-tell', 1, 'elegir',
 $j${"frase": "She ___ me that she was ill.", "opciones": ["told", "said", "say", "tells"], "correcta": 0, "es": "Me dijo que estaba enferma.", "explicacion": "tell + persona (me)."}$j$::jsonb,
 'ep18-say-tell', 'estudio', false),
('ep18-saytell-02', 'ep18-say-tell', 2, 'elegir',
 $j${"frase": "He ___ that he was late.", "opciones": ["said", "told", "tell", "tells"], "correcta": 0, "es": "Dijo que llegaba tarde.", "explicacion": "say sin persona."}$j$::jsonb,
 'ep18-say-tell', 'estudio', false),
('ep18-saytell-03', 'ep18-say-tell', 3, 'elegir',
 $j${"frase": "She ___ that she had forgotten the keys.", "opciones": ["admitted", "admitted me", "admit me", "admits to me"], "correcta": 0, "es": "Admitió que había olvidado las llaves.", "explicacion": "admit + that, sin persona."}$j$::jsonb,
 'ep18-say-tell', 'estudio', false),
('ep18-saytell-04', 'ep18-say-tell', 4, 'elegir',
 $j${"frase": "Tom ___ me to close the door.", "opciones": ["told", "said", "explained"], "correcta": 0, "es": "Tom me dijo que cerrara la puerta.", "explicacion": "tell + persona + to + verbo."}$j$::jsonb,
 'ep18-say-tell', 'estudio', false),
('ep18-saytell-05', 'ep18-say-tell', 5, 'escribir',
 $j${"respuestas": ["he told me that he was busy", "he told me he was busy"], "mostrar": "He told me that he was busy.", "es": "Me dijo que estaba ocupado.", "explicacion": "tell + persona."}$j$::jsonb,
 'ep18-say-tell', 'estudio', false),
('ep18-saytell-06', 'ep18-say-tell', 6, 'ordenar',
 $j${"frase": "She suggested going to the museum.", "es": "Ella sugirió ir al museo.", "explicacion": "suggest + -ing."}$j$::jsonb,
 'ep18-say-tell', 'estudio', false),
('ep18-saytell-07', 'ep18-say-tell', 7, 'emparejar',
 $j${"pares": [["say that", "decir que"], ["tell me", "decirme"], ["admit that", "admitir que"], ["explain that", "explicar que"]], "es": "", "explicacion": "Say y tell con y sin persona."}$j$::jsonb,
 'ep18-say-tell', 'estudio', false),
('ep18-saytell-08', 'ep18-say-tell', 8, 'escuchar',
 $j${"opciones": ["She told me she was ready.", "She said me she was ready.", "She told that she was ready.", "She say me she was ready."], "correcta": 0, "audio": "She told me she was ready.", "es": "Me dijo que estaba lista.", "explicacion": "tell + me."}$j$::jsonb,
 'ep18-say-tell', 'input', false)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('banco-ep18-saytell-01', 'banco-ep18', 1, 'comprension',
 $j${"modo": "escuchar", "lineas": [{"en": "Harry told me the show was cancelled.", "es": "Harry me dijo que el show fue cancelado."}, {"en": "He said it was too expensive to produce.", "es": "Dijo que era demasiado caro de producir."}], "pregunta": "Why was the show cancelled?", "pregunta_es": "¿Por qué fue cancelado el show?", "opciones": ["It was too expensive", "It was too early", "The actors were sick", "It rained"], "correcta": 0, "explicacion": "'It was too expensive to produce.'"}$j$::jsonb,
 'ep18-say-tell', 'input', false),
('banco-ep18-saytell-02', 'banco-ep18', 2, 'comprension',
 $j${"modo": "leer", "lineas": [{"en": "Lyle admitted that he didn't like modern art.", "es": "Lyle admitió que no le gustaba el arte moderno."}, {"en": "Frances explained that she preferred plays.", "es": "Frances explicó que prefería las obras de teatro."}], "pregunta": "What did Frances prefer?", "pregunta_es": "¿Qué prefería Frances?", "opciones": ["Plays", "Modern art", "Musicals", "Concerts"], "correcta": 0, "explicacion": "'Frances explained that she preferred plays.'"}$j$::jsonb,
 'ep18-say-tell', 'input', false),
('banco-ep18-saytell-03', 'banco-ep18', 3, 'decir',
 $j${"es": "Me dijo que vendría.", "respuestas": ["he told me he would come", "he told me that he would come"], "mostrar": "He told me he would come.", "explicacion": "tell + persona."}$j$::jsonb,
 'ep18-say-tell', 'output', false),
('banco-ep18-saytell-04', 'banco-ep18', 4, 'decir',
 $j${"es": "Dijo que estaba lista.", "respuestas": ["she said she was ready", "she said that she was ready"], "mostrar": "She said she was ready.", "explicacion": "say sin persona."}$j$::jsonb,
 'ep18-say-tell', 'output', false),
('banco-ep18-saytell-05', 'banco-ep18', 5, 'libre',
 $j${"pregunta": "Write two sentences: one with said and one with told me.", "pregunta_es": "Escribe dos frases: una con said y otra con told me.", "ejemplo": "She said she was tired. He told me the film was great.", "criterio": "say sin persona; tell con persona.", "explicacion": "say no lleva persona; tell sí."}$j$::jsonb,
 'ep18-say-tell', 'output', false),
('banco-ep18-saytell-06', 'banco-ep18', 6, 'rapido',
 $j${"frase": "She ___ going out tonight.", "opciones": ["suggested", "told"], "correcta": 0, "es": "Ella sugirió salir esta noche.", "explicacion": "suggest + -ing.", "segundos": 5}$j$::jsonb,
 'ep18-say-tell', 'fluidez', false),
('banco-ep18-saytell-07', 'banco-ep18', 7, 'rapido',
 $j${"frase": "She ___ that she was sorry.", "opciones": ["said", "told"], "correcta": 0, "es": "Dijo que lo sentía.", "explicacion": "say sin persona.", "segundos": 5}$j$::jsonb,
 'ep18-say-tell', 'fluidez', false),
('banco-ep18-saytell-08', 'banco-ep18', 8, 'rapido',
 $j${"frase": "Ana ___ me the truth.", "opciones": ["told", "said"], "correcta": 0, "es": "Ana me dijo la verdad.", "explicacion": "tell + me.", "segundos": 5}$j$::jsonb,
 'ep18-say-tell', 'fluidez', false)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('examen-ep18-saytell-01', 'examen-ep18', 1, 'elegir',
 $j${"frase": "He ___ that he was tired.", "opciones": ["said", "told", "tells"], "correcta": 0, "es": "Dijo que estaba cansado.", "explicacion": "say sin persona."}$j$::jsonb,
 'ep18-say-tell', 'estudio', true),
('examen-ep18-saytell-02', 'examen-ep18', 2, 'escribir',
 $j${"respuestas": ["she told me she was happy"], "mostrar": "She told me she was happy.", "es": "Me dijo que estaba feliz.", "explicacion": "tell + me."}$j$::jsonb,
 'ep18-say-tell', 'estudio', true),
('examen-ep18-saytell-03', 'examen-ep18', 3, 'escuchar',
 $j${"opciones": ["He admitted that he was wrong.", "He admitted me he was wrong.", "He admits that he was wrong yesterday.", "He admitted he was wrong me."], "correcta": 0, "audio": "He admitted that he was wrong.", "es": "Admitió que estaba equivocado.", "explicacion": "admit + that."}$j$::jsonb,
 'ep18-say-tell', 'input', true)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;

-- EJERCICIOS — TEMA 3: ep18-homofonos
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('ep18-homo-01', 'ep18-homofonos', 1, 'elegir',
 $j${"frase": "I can ___ the sea from my room.", "opciones": ["see", "sea", "sees", "seen"], "correcta": 0, "es": "Puedo ver el mar desde mi cuarto.", "explicacion": "see = ver; sea = mar."}$j$::jsonb,
 'ep18-homofonos', 'estudio', false),
('ep18-homo-02', 'ep18-homofonos', 2, 'elegir',
 $j${"frase": "Her ___ is a doctor.", "opciones": ["son", "sun", "sone", "sunn"], "correcta": 0, "es": "Su hijo es médico.", "explicacion": "son = hijo; sun = sol."}$j$::jsonb,
 'ep18-homofonos', 'estudio', false),
('ep18-homo-03', 'ep18-homofonos', 3, 'elegir',
 $j${"frase": "Please ___ the answer on the board.", "opciones": ["write", "right", "rite", "wright"], "correcta": 0, "es": "Por favor escribe la respuesta en el tablero.", "explicacion": "write = escribir; right = correcto/derecha."}$j$::jsonb,
 'ep18-homofonos', 'estudio', false),
('ep18-homo-04', 'ep18-homofonos', 4, 'elegir',
 $j${"frase": "I can't ___ you well. Speak louder.", "opciones": ["hear", "here", "heer", "hair"], "correcta": 0, "es": "No te escucho bien. Habla más fuerte.", "explicacion": "hear = escuchar; here = aquí."}$j$::jsonb,
 'ep18-homofonos', 'estudio', false),
('ep18-homo-05', 'ep18-homofonos', 5, 'escribir',
 $j${"respuestas": ["the sun is hot today"], "mostrar": "The sun is hot today.", "es": "El sol está caliente hoy.", "explicacion": "sun = sol."}$j$::jsonb,
 'ep18-homofonos', 'estudio', false),
('ep18-homo-06', 'ep18-homofonos', 6, 'ordenar',
 $j${"frase": "Let's meet here at noon.", "es": "Encontrémonos aquí al mediodía.", "explicacion": "meet = encontrarse; here = aquí."}$j$::jsonb,
 'ep18-homofonos', 'estudio', false),
('ep18-homo-07', 'ep18-homofonos', 7, 'emparejar',
 $j${"pares": [["sea", "mar"], ["see", "ver"], ["son", "hijo"], ["sun", "sol"]], "es": "", "explicacion": "Homófonos básicos."}$j$::jsonb,
 'ep18-homofonos', 'estudio', false),
('ep18-homo-08', 'ep18-homofonos', 8, 'escuchar',
 $j${"opciones": ["I'll meet you at the sea.", "I'll meat you at the see.", "I'll meet you at the see.", "I'll meet you at the sea?"], "correcta": 0, "audio": "I'll meet you at the sea.", "es": "Te veo en el mar.", "explicacion": "sea = mar."}$j$::jsonb,
 'ep18-homofonos', 'input', false)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('banco-ep18-homo-01', 'banco-ep18', 1, 'comprension',
 $j${"modo": "escuchar", "lineas": [{"en": "Did you hear the news? The king's son is getting married.", "es": "¿Escuchaste la noticia? El hijo del rey se va a casar."}, {"en": "Yes, I'll write to him right away.", "es": "Sí, le escribiré enseguida."}], "pregunta": "Who is getting married?", "pregunta_es": "¿Quién se va a casar?", "opciones": ["The king's son", "The king", "The writer", "The speaker"], "correcta": 0, "explicacion": "'The king's son is getting married.'"}$j$::jsonb,
 'ep18-homofonos', 'input', false),
('banco-ep18-homo-02', 'banco-ep18', 2, 'comprension',
 $j${"modo": "leer", "lineas": [{"en": "We will meet at the sea at noon.", "es": "Nos encontraremos en el mar al mediodía."}, {"en": "Bring a hat, the sun is strong.", "es": "Trae un sombrero, el sol es fuerte."}], "pregunta": "What should the listener bring?", "pregunta_es": "¿Qué debe traer el oyente?", "opciones": ["A hat", "An umbrella", "A book", "A coat"], "correcta": 0, "explicacion": "'Bring a hat, the sun is strong.'"}$j$::jsonb,
 'ep18-homofonos', 'input', false),
('banco-ep18-homo-03', 'banco-ep18', 3, 'decir',
 $j${"es": "Te escucho.", "respuestas": ["i hear you", "i can hear you"], "mostrar": "I hear you.", "explicacion": "hear = escuchar."}$j$::jsonb,
 'ep18-homofonos', 'output', false),
('banco-ep18-homo-04', 'banco-ep18', 4, 'decir',
 $j${"es": "Nos vemos aquí.", "respuestas": ["we will meet here", "we'll meet here"], "mostrar": "We'll meet here.", "explicacion": "here = aquí."}$j$::jsonb,
 'ep18-homofonos', 'output', false),
('banco-ep18-homo-05', 'banco-ep18', 5, 'libre',
 $j${"pregunta": "Write two sentences using two homophones from this lesson (for example sea/see or right/write).", "pregunta_es": "Escribe dos frases usando dos homófonos de esta lección (por ejemplo sea/see o right/write).", "ejemplo": "I can see the sea from my window. Please write the right answer.", "criterio": "usa el homófono con su significado correcto.", "explicacion": "Revisa que cada palabra tenga el sentido correcto."}$j$::jsonb,
 'ep18-homofonos', 'output', false),
('banco-ep18-homo-06', 'banco-ep18', 6, 'rapido',
 $j${"frase": "I want to ___ the movie.", "opciones": ["see", "sea"], "correcta": 0, "es": "Quiero ver la película.", "explicacion": "see = ver.", "segundos": 5}$j$::jsonb,
 'ep18-homofonos', 'fluidez', false),
('banco-ep18-homo-07', 'banco-ep18', 7, 'rapido',
 $j${"frase": "Turn ___ at the corner.", "opciones": ["right", "write"], "correcta": 0, "es": "Gira a la derecha en la esquina.", "explicacion": "right = derecha.", "segundos": 5}$j$::jsonb,
 'ep18-homofonos', 'fluidez', false),
('banco-ep18-homo-08', 'banco-ep18', 8, 'rapido',
 $j${"frase": "Her ___ lives in Bogotá.", "opciones": ["son", "sun"], "correcta": 0, "es": "Su hijo vive en Bogotá.", "explicacion": "son = hijo.", "segundos": 5}$j$::jsonb,
 'ep18-homofonos', 'fluidez', false)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('examen-ep18-homo-01', 'examen-ep18', 1, 'elegir',
 $j${"frase": "The ___ is shining brightly today.", "opciones": ["sun", "son", "sunny"], "correcta": 0, "es": "El sol brilla fuerte hoy.", "explicacion": "sun = sol."}$j$::jsonb,
 'ep18-homofonos', 'estudio', true),
('examen-ep18-homo-02', 'examen-ep18', 2, 'escribir',
 $j${"respuestas": ["i will meet you there"], "mostrar": "I will meet you there.", "es": "Te encontraré allí.", "explicacion": "meet = encontrarse."}$j$::jsonb,
 'ep18-homofonos', 'estudio', true),
('examen-ep18-homo-03', 'examen-ep18', 3, 'escuchar',
 $j${"opciones": ["Can you hear me now?", "Can you here me now?", "Can you hair me now?", "Can you hear my son?"], "correcta": 0, "audio": "Can you hear me now?", "es": "¿Me escuchas ahora?", "explicacion": "hear = escuchar."}$j$::jsonb,
 'ep18-homofonos', 'input', true)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;

-- EJERCICIOS — TEMA 4: ep18-arte-teatro
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('ep18-arte-01', 'ep18-arte-teatro', 1, 'elegir',
 $j${"frase": "I'd love to see a ___ on Broadway.", "opciones": ["musical", "musically", "musician"], "correcta": 0, "es": "Me encantaría ver un musical en Broadway.", "explicacion": "musical = musical (obra)."}$j$::jsonb,
 'ep18-arte-teatro', 'estudio', false),
('ep18-arte-02', 'ep18-arte-teatro', 2, 'elegir',
 $j${"frase": "The ___ has beautiful paintings from the 1900s.", "opciones": ["museum", "museums", "musical"], "correcta": 0, "es": "El museo tiene pinturas hermosas de los años 1900.", "explicacion": "museum = museo."}$j$::jsonb,
 'ep18-arte-teatro', 'estudio', false),
('ep18-arte-03', 'ep18-arte-teatro', 3, 'elegir',
 $j${"frase": "I bought two ___ for the play.", "opciones": ["tickets", "ticket's", "tichets"], "correcta": 0, "es": "Compré dos boletas para la obra.", "explicacion": "ticket = boleta/entrada."}$j$::jsonb,
 'ep18-arte-teatro', 'estudio', false),
('ep18-arte-04', 'ep18-arte-teatro', 4, 'elegir',
 $j${"frase": "I'm not a big fan of ___ art.", "opciones": ["modern", "modernly", "moderns"], "correcta": 0, "es": "No soy muy fan del arte moderno.", "explicacion": "modern art = arte moderno."}$j$::jsonb,
 'ep18-arte-teatro', 'estudio', false),
('ep18-arte-05', 'ep18-arte-teatro', 5, 'escribir',
 $j${"respuestas": ["i like modern art", "i love modern art"], "mostrar": "I like modern art.", "es": "Me gusta el arte moderno.", "explicacion": "modern art = arte moderno."}$j$::jsonb,
 'ep18-arte-teatro', 'estudio', false),
('ep18-arte-06', 'ep18-arte-teatro', 6, 'ordenar',
 $j${"frase": "I prefer musicals to plays.", "es": "Prefiero los musicales a las obras de teatro.", "explicacion": "prefer X to Y."}$j$::jsonb,
 'ep18-arte-teatro', 'estudio', false),
('ep18-arte-07', 'ep18-arte-teatro', 7, 'emparejar',
 $j${"pares": [["museum", "museo"], ["gallery", "galería"], ["play", "obra de teatro"], ["tickets", "boletas"]], "es": "", "explicacion": "Vocabulario de museos y teatro."}$j$::jsonb,
 'ep18-arte-teatro', 'estudio', false),
('ep18-arte-08', 'ep18-arte-teatro', 8, 'escuchar',
 $j${"opciones": ["The performance starts at eight.", "The performer starts at eight.", "The performance started at ate.", "The perform starts at eight."], "correcta": 0, "audio": "The performance starts at eight.", "es": "La función empieza a las ocho.", "explicacion": "performance = función/presentación."}$j$::jsonb,
 'ep18-arte-teatro', 'input', false)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('banco-ep18-arte-01', 'banco-ep18', 1, 'comprension',
 $j${"modo": "escuchar", "lineas": [{"en": "We went to the museum and saw modern art.", "es": "Fuimos al museo y vimos arte moderno."}, {"en": "Then we bought tickets for a musical tonight.", "es": "Luego compramos boletas para un musical esta noche."}], "pregunta": "What did they buy?", "pregunta_es": "¿Qué compraron?", "opciones": ["Tickets for a musical", "A painting", "A book", "A new hat"], "correcta": 0, "explicacion": "'we bought tickets for a musical tonight.'"}$j$::jsonb,
 'ep18-arte-teatro', 'input', false),
('banco-ep18-arte-02', 'banco-ep18', 2, 'comprension',
 $j${"modo": "leer", "lineas": [{"en": "I prefer plays to concerts.", "es": "Prefiero las obras de teatro a los conciertos."}, {"en": "I'm not into performance art.", "es": "No me gusta el arte de performance."}], "pregunta": "What does the speaker prefer?", "pregunta_es": "¿Qué prefiere el hablante?", "opciones": ["Plays", "Concerts", "Performance art", "Painting"], "correcta": 0, "explicacion": "'I prefer plays to concerts.'"}$j$::jsonb,
 'ep18-arte-teatro', 'input', false),
('banco-ep18-arte-03', 'banco-ep18', 3, 'decir',
 $j${"es": "Me gusta el arte moderno.", "respuestas": ["i like modern art", "i love modern art"], "mostrar": "I like modern art.", "explicacion": "modern art."}$j$::jsonb,
 'ep18-arte-teatro', 'output', false),
('banco-ep18-arte-04', 'banco-ep18', 4, 'decir',
 $j${"es": "Compramos boletas para la obra.", "respuestas": ["we bought tickets for the play", "we bought tickets for the show"], "mostrar": "We bought tickets for the play.", "explicacion": "play = obra de teatro."}$j$::jsonb,
 'ep18-arte-teatro', 'output', false),
('banco-ep18-arte-05', 'banco-ep18', 5, 'libre',
 $j${"pregunta": "Describe a museum, play or musical you visited or would like to visit. Use at least three words from this lesson.", "pregunta_es": "Describe un museo, una obra o un musical que visitaste o quisieras visitar. Usa al menos tres palabras de esta lección.", "ejemplo": "I'd like to visit the national museum. I prefer musicals to plays.", "criterio": "vocabulario de la lección.", "explicacion": "Usa las palabras de la lección."}$j$::jsonb,
 'ep18-arte-teatro', 'output', false),
('banco-ep18-arte-06', 'banco-ep18', 6, 'rapido',
 $j${"frase": "We saw a ___ at the gallery.", "opciones": ["painting", "painter"], "correcta": 0, "es": "Vimos una pintura en la galería.", "explicacion": "painting = pintura.", "segundos": 5}$j$::jsonb,
 'ep18-arte-teatro', 'fluidez', false),
('banco-ep18-arte-07', 'banco-ep18', 7, 'rapido',
 $j${"frase": "I prefer ___ to plays.", "opciones": ["musicals", "musician"], "correcta": 0, "es": "Prefiero los musicales a las obras de teatro.", "explicacion": "musicals.", "segundos": 5}$j$::jsonb,
 'ep18-arte-teatro', 'fluidez', false),
('banco-ep18-arte-08', 'banco-ep18', 8, 'rapido',
 $j${"frase": "The ___ starts at eight.", "opciones": ["performance", "perform"], "correcta": 0, "es": "La función empieza a las ocho.", "explicacion": "performance = función.", "segundos": 5}$j$::jsonb,
 'ep18-arte-teatro', 'fluidez', false)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('examen-ep18-arte-01', 'examen-ep18', 1, 'elegir',
 $j${"frase": "The ___ has a free exhibition this week.", "opciones": ["gallery", "galley", "gallon"], "correcta": 0, "es": "La galería tiene una exposición gratuita esta semana.", "explicacion": "gallery = galería."}$j$::jsonb,
 'ep18-arte-teatro', 'estudio', true),
('examen-ep18-arte-02', 'examen-ep18', 2, 'escribir',
 $j${"respuestas": ["i bought two tickets"], "mostrar": "I bought two tickets.", "es": "Compré dos boletas.", "explicacion": "ticket = boleta."}$j$::jsonb,
 'ep18-arte-teatro', 'estudio', true),
('examen-ep18-arte-03', 'examen-ep18', 3, 'escuchar',
 $j${"opciones": ["We saw a great play last night.", "We saw a great plate last night.", "We saw a great plan last night.", "We saw a great play tonight."], "correcta": 0, "audio": "We saw a great play last night.", "es": "Anoche vimos una obra muy buena.", "explicacion": "play = obra de teatro."}$j$::jsonb,
 'ep18-arte-teatro', 'input', true)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;

-- EJERCICIOS — TEMA 5: ep18-condicional-cero
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('ep18-cond0-01', 'ep18-condicional-cero', 1, 'elegir',
 $j${"frase": "If water reaches 100 degrees, it ___.", "opciones": ["boils", "will boil", "boiled", "boil"], "correcta": 0, "es": "Si el agua llega a 100 grados, hierve.", "explicacion": "zero: presente + presente."}$j$::jsonb,
 'ep18-condicional-cero', 'estudio', false),
('ep18-cond0-02', 'ep18-condicional-cero', 2, 'elegir',
 $j${"frase": "If people eat too much, they ___ fat.", "opciones": ["get", "will get", "got", "getting"], "correcta": 0, "es": "Si la gente come demasiado, engorda.", "explicacion": "get en presente."}$j$::jsonb,
 'ep18-condicional-cero', 'estudio', false),
('ep18-cond0-03', 'ep18-condicional-cero', 3, 'elegir',
 $j${"frase": "If babies are hungry, they ___.", "opciones": ["cry", "will cry", "cried", "crying"], "correcta": 0, "es": "Si los bebés tienen hambre, lloran.", "explicacion": "presente simple."}$j$::jsonb,
 'ep18-condicional-cero', 'estudio', false),
('ep18-cond0-04', 'ep18-condicional-cero', 4, 'elegir',
 $j${"frase": "___ you touch a fire, you get burned.", "opciones": ["If", "Because", "Unless", "Although"], "correcta": 0, "es": "Si tocas el fuego, te quemas.", "explicacion": "if = si."}$j$::jsonb,
 'ep18-condicional-cero', 'estudio', false),
('ep18-cond0-05', 'ep18-condicional-cero', 5, 'escribir',
 $j${"respuestas": ["if you touch a fire you get burned", "if you touch fire you get burned"], "mostrar": "If you touch a fire, you get burned.", "es": "Si tocas el fuego, te quemas.", "explicacion": "if + presente, presente."}$j$::jsonb,
 'ep18-condicional-cero', 'estudio', false),
('ep18-cond0-06', 'ep18-condicional-cero', 6, 'ordenar',
 $j${"frase": "If I eat peanuts, I get sick.", "es": "Si como maníes, me enfermo.", "explicacion": "if + presente simple, presente simple."}$j$::jsonb,
 'ep18-condicional-cero', 'estudio', false),
('ep18-cond0-07', 'ep18-condicional-cero', 7, 'emparejar',
 $j${"pares": [["if it boils", "si hierve"], ["if they are hungry", "si tienen hambre"], ["if you mix", "si mezclas"], ["if they are scared", "si tienen miedo"]], "es": "", "explicacion": "Condicional cero: hechos generales."}$j$::jsonb,
 'ep18-condicional-cero', 'estudio', false),
('ep18-cond0-08', 'ep18-condicional-cero', 8, 'escuchar',
 $j${"opciones": ["If you mix hydrogen and oxygen, you get water.", "If you mix hydrogen and oxygen, you will get water.", "If you mixed hydrogen and oxygen, you got water.", "If you mix hydrogen and oxygen, you got water."], "correcta": 0, "audio": "If you mix hydrogen and oxygen, you get water.", "es": "Si mezclas hidrógeno y oxígeno, obtienes agua.", "explicacion": "Hecho general: presente."}$j$::jsonb,
 'ep18-condicional-cero', 'input', false)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('banco-ep18-cond0-01', 'banco-ep18', 1, 'comprension',
 $j${"modo": "escuchar", "lineas": [{"en": "Snakes bite if they are scared.", "es": "Las serpientes muerden si tienen miedo."}, {"en": "Babies cry if they are hungry.", "es": "Los bebés lloran si tienen hambre."}], "pregunta": "When do snakes bite?", "pregunta_es": "¿Cuándo muerden las serpientes?", "opciones": ["If they are scared", "If they are hungry", "If it rains", "When they sleep"], "correcta": 0, "explicacion": "'Snakes bite if they are scared.'"}$j$::jsonb,
 'ep18-condicional-cero', 'input', false),
('banco-ep18-cond0-02', 'banco-ep18', 2, 'comprension',
 $j${"modo": "leer", "lineas": [{"en": "People die if they don't eat.", "es": "La gente muere si no come."}, {"en": "You get water if you mix hydrogen and oxygen.", "es": "Obtienes agua si mezclas hidrógeno y oxígeno."}], "pregunta": "What do you get if you mix hydrogen and oxygen?", "pregunta_es": "¿Qué obtienes si mezclas hidrógeno y oxígeno?", "opciones": ["Water", "Fire", "Salt", "Gas"], "correcta": 0, "explicacion": "'You get water if you mix hydrogen and oxygen.'"}$j$::jsonb,
 'ep18-condicional-cero', 'input', false),
('banco-ep18-cond0-03', 'banco-ep18', 3, 'decir',
 $j${"es": "Si el agua hierve, se evapora.", "respuestas": ["if water boils it evaporates", "if water boils, it evaporates"], "mostrar": "If water boils, it evaporates.", "explicacion": "if + presente, presente."}$j$::jsonb,
 'ep18-condicional-cero', 'output', false),
('banco-ep18-cond0-04', 'banco-ep18', 4, 'decir',
 $j${"es": "Si comes demasiado, engordas.", "respuestas": ["if you eat too much you get fat", "if you eat too much, you get fat"], "mostrar": "If you eat too much, you get fat.", "explicacion": "get fat = engordar."}$j$::jsonb,
 'ep18-condicional-cero', 'output', false),
('banco-ep18-cond0-05', 'banco-ep18', 5, 'libre',
 $j${"pregunta": "Write two zero conditional sentences about general facts.", "pregunta_es": "Escribe dos frases de condicional cero sobre hechos generales.", "ejemplo": "If you heat ice, it melts. If people sleep too little, they get tired.", "criterio": "if + presente simple, presente simple.", "explicacion": "Hechos generales, no planes."}$j$::jsonb,
 'ep18-condicional-cero', 'output', false),
('banco-ep18-cond0-06', 'banco-ep18', 6, 'rapido',
 $j${"frase": "If it rains, the streets ___ wet.", "opciones": ["get", "will get"], "correcta": 0, "es": "Si llueve, las calles se mojan.", "explicacion": "hecho general: presente.", "segundos": 5}$j$::jsonb,
 'ep18-condicional-cero', 'fluidez', false),
('banco-ep18-cond0-07', 'banco-ep18', 7, 'rapido',
 $j${"frase": "If babies are hungry, they ___.", "opciones": ["cry", "cried"], "correcta": 0, "es": "Si los bebés tienen hambre, lloran.", "explicacion": "presente simple.", "segundos": 5}$j$::jsonb,
 'ep18-condicional-cero', 'fluidez', false),
('banco-ep18-cond0-08', 'banco-ep18', 8, 'rapido',
 $j${"frase": "If you touch a fire, you ___ burned.", "opciones": ["get", "got"], "correcta": 0, "es": "Si tocas el fuego, te quemas.", "explicacion": "get burned.", "segundos": 5}$j$::jsonb,
 'ep18-condicional-cero', 'fluidez', false)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('examen-ep18-cond0-01', 'examen-ep18', 1, 'elegir',
 $j${"frase": "If ice ___, it becomes water.", "opciones": ["melts", "will melt", "melted"], "correcta": 0, "es": "Si el hielo se derrite, se vuelve agua.", "explicacion": "presente simple."}$j$::jsonb,
 'ep18-condicional-cero', 'estudio', true),
('examen-ep18-cond0-02', 'examen-ep18', 2, 'escribir',
 $j${"respuestas": ["if people eat too much they get fat"], "mostrar": "If people eat too much, they get fat.", "es": "Si la gente come demasiado, engorda.", "explicacion": "if + presente, presente."}$j$::jsonb,
 'ep18-condicional-cero', 'estudio', true),
('examen-ep18-cond0-03', 'examen-ep18', 3, 'escuchar',
 $j${"opciones": ["If you sit in the sun, you get burned.", "If you sit in the sun, you will get burned.", "If you sat in the sun, you got burned.", "If you sit in the sun, you got burned."], "correcta": 0, "audio": "If you sit in the sun, you get burned.", "es": "Si te sientas al sol, te quemas.", "explicacion": "Hecho general: presente."}$j$::jsonb,
 'ep18-condicional-cero', 'input', true)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;

-- EJERCICIOS — TEMA 6: ep18-primer-condicional
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('ep18-cond1-01', 'ep18-primer-condicional', 1, 'elegir',
 $j${"frase": "If it rains, I ___ go to the park.", "opciones": ["won't", "don't", "wouldn't", "didn't"], "correcta": 0, "es": "Si llueve, no iré al parque.", "explicacion": "will not = won't."}$j$::jsonb,
 'ep18-primer-condicional', 'estudio', false),
('ep18-cond1-02', 'ep18-primer-condicional', 2, 'elegir',
 $j${"frase": "If I study today, I ___ go to the party tonight.", "opciones": ["will", "would", "do", "did"], "correcta": 0, "es": "Si estudio hoy, iré a la fiesta esta noche.", "explicacion": "will + infinitivo."}$j$::jsonb,
 'ep18-primer-condicional', 'estudio', false),
('ep18-cond1-03', 'ep18-primer-condicional', 3, 'elegir',
 $j${"frase": "She'll miss the bus if she ___ soon.", "opciones": ["doesn't leave", "won't leave", "didn't leave", "wouldn't leave"], "correcta": 0, "es": "Perderá el bus si no sale pronto.", "explicacion": "if + presente negativo."}$j$::jsonb,
 'ep18-primer-condicional', 'estudio', false),
('ep18-cond1-04', 'ep18-primer-condicional', 4, 'elegir',
 $j${"frase": "If I see her, I ___ tell her.", "opciones": ["will", "would", "did", "am"], "correcta": 0, "es": "Si la veo, se lo diré.", "explicacion": "will."}$j$::jsonb,
 'ep18-primer-condicional', 'estudio', false),
('ep18-cond1-05', 'ep18-primer-condicional', 5, 'escribir',
 $j${"respuestas": ["if it rains i will stay home", "if it rains i'll stay home"], "mostrar": "If it rains, I'll stay home.", "es": "Si llueve, me quedaré en casa.", "explicacion": "if + presente, will."}$j$::jsonb,
 'ep18-primer-condicional', 'estudio', false),
('ep18-cond1-06', 'ep18-primer-condicional', 6, 'ordenar',
 $j${"frase": "If I have enough money, I'll buy shoes.", "es": "Si tengo suficiente dinero, compraré zapatos.", "explicacion": "if + presente, will + verbo."}$j$::jsonb,
 'ep18-primer-condicional', 'estudio', false),
('ep18-cond1-07', 'ep18-primer-condicional', 7, 'emparejar',
 $j${"pares": [["if it rains", "si llueve"], ["I'll stay home", "me quedaré en casa"], ["if I study", "si estudio"], ["she'll be late", "ella llegará tarde"]], "es": "", "explicacion": "Primer condicional: posibilidades reales."}$j$::jsonb,
 'ep18-primer-condicional', 'estudio', false),
('ep18-cond1-08', 'ep18-primer-condicional', 8, 'escuchar',
 $j${"opciones": ["If the train is delayed, she'll be late.", "If the train is delayed, she would be late.", "If the train delayed, she'll be late.", "If the train is delayed, she be late."], "correcta": 0, "audio": "If the train is delayed, she'll be late.", "es": "Si el tren se retrasa, ella llegará tarde.", "explicacion": "will + infinitivo."}$j$::jsonb,
 'ep18-primer-condicional', 'input', false)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('banco-ep18-cond1-01', 'banco-ep18', 1, 'comprension',
 $j${"modo": "escuchar", "lineas": [{"en": "If I have enough money, I'll buy new shoes.", "es": "Si tengo suficiente dinero, compraré zapatos nuevos."}, {"en": "Then I'll go to the mall with my sister.", "es": "Luego iré al centro comercial con mi hermana."}], "pregunta": "What will the speaker buy if they have enough money?", "pregunta_es": "¿Qué comprará el hablante si tiene suficiente dinero?", "opciones": ["New shoes", "A car", "A house", "A phone"], "correcta": 0, "explicacion": "'I'll buy new shoes.'"}$j$::jsonb,
 'ep18-primer-condicional', 'input', false),
('banco-ep18-cond1-02', 'banco-ep18', 2, 'comprension',
 $j${"modo": "leer", "lineas": [{"en": "If the weather is nice, we'll go camping.", "es": "Si el clima es bueno, iremos de camping."}, {"en": "If it rains, we'll stay at home.", "es": "Si llueve, nos quedaremos en casa."}], "pregunta": "Where will they stay if it rains?", "pregunta_es": "¿Dónde se quedarán si llueve?", "opciones": ["At home", "At the beach", "In a tent", "At school"], "correcta": 0, "explicacion": "'If it rains, we'll stay at home.'"}$j$::jsonb,
 'ep18-primer-condicional', 'input', false),
('banco-ep18-cond1-03', 'banco-ep18', 3, 'decir',
 $j${"es": "Si llueve, me quedaré en casa.", "respuestas": ["if it rains i will stay at home", "if it rains i'll stay at home"], "mostrar": "If it rains, I'll stay at home.", "explicacion": "if + presente, will + verbo."}$j$::jsonb,
 'ep18-primer-condicional', 'output', false),
('banco-ep18-cond1-04', 'banco-ep18', 4, 'decir',
 $j${"es": "Si estudias, aprobarás.", "respuestas": ["if you study you will pass", "if you study you'll pass"], "mostrar": "If you study, you'll pass.", "explicacion": "will pass."}$j$::jsonb,
 'ep18-primer-condicional', 'output', false),
('banco-ep18-cond1-05', 'banco-ep18', 5, 'libre',
 $j${"pregunta": "Write two first conditional sentences about your plans for this weekend.", "pregunta_es": "Escribe dos frases de primer condicional sobre tus planes para este fin de semana.", "ejemplo": "If it's sunny, I'll go to the park. If I finish work early, I'll call you.", "criterio": "if + presente, will + verbo base.", "explicacion": "Planes o posibilidades reales."}$j$::jsonb,
 'ep18-primer-condicional', 'output', false),
('banco-ep18-cond1-06', 'banco-ep18', 6, 'rapido',
 $j${"frase": "If I see her, I ___ tell her.", "opciones": ["will", "would"], "correcta": 0, "es": "Si la veo, se lo diré.", "explicacion": "will.", "segundos": 5}$j$::jsonb,
 'ep18-primer-condicional', 'fluidez', false),
('banco-ep18-cond1-07', 'banco-ep18', 7, 'rapido',
 $j${"frase": "If it rains, I ___ go out.", "opciones": ["won't", "didn't"], "correcta": 0, "es": "Si llueve, no saldré.", "explicacion": "won't.", "segundos": 5}$j$::jsonb,
 'ep18-primer-condicional', 'fluidez', false),
('banco-ep18-cond1-08', 'banco-ep18', 8, 'rapido',
 $j${"frase": "She'll be late if the train ___ delayed.", "opciones": ["is", "will be"], "correcta": 0, "es": "Ella llegará tarde si el tren se retrasa.", "explicacion": "if + presente.", "segundos": 5}$j$::jsonb,
 'ep18-primer-condicional', 'fluidez', false)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('examen-ep18-cond1-01', 'examen-ep18', 1, 'elegir',
 $j${"frase": "If you ___ hard, you'll pass the exam.", "opciones": ["study", "will study", "studied"], "correcta": 0, "es": "Si estudias duro, pasarás el examen.", "explicacion": "presente en la cláusula if."}$j$::jsonb,
 'ep18-primer-condicional', 'estudio', true),
('examen-ep18-cond1-02', 'examen-ep18', 2, 'escribir',
 $j${"respuestas": ["if you study you will pass"], "mostrar": "If you study, you will pass.", "es": "Si estudias, pasarás.", "explicacion": "if + presente, will."}$j$::jsonb,
 'ep18-primer-condicional', 'estudio', true),
('examen-ep18-cond1-03', 'examen-ep18', 3, 'escuchar',
 $j${"opciones": ["If I have time, I'll call you tonight.", "If I had time, I'll call you tonight.", "If I have time, I would call you tonight.", "If I have time, I calls you tonight."], "correcta": 0, "audio": "If I have time, I'll call you tonight.", "es": "Si tengo tiempo, te llamaré esta noche.", "explicacion": "if + presente, will."}$j$::jsonb,
 'ep18-primer-condicional', 'input', true)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;

-- EJERCICIOS — TEMA 7: ep18-felicitaciones
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('ep18-felic-01', 'ep18-felicitaciones', 1, 'elegir',
 $j${"frase": "___! I heard you got the job.", "opciones": ["Congratulations", "Congratulate", "Congratulated", "Congratulating"], "correcta": 0, "es": "¡Felicitaciones! Escuché que conseguiste el trabajo.", "explicacion": "Congratulations! es la expresión fija."}$j$::jsonb,
 'ep18-felicitaciones', 'estudio', false),
('ep18-felic-02', 'ep18-felicitaciones', 2, 'elegir',
 $j${"frase": "I'm so ___ for you!", "opciones": ["happy", "happiness", "happily", "happier"], "correcta": 0, "es": "¡Estoy muy feliz por ti!", "explicacion": "happy for you."}$j$::jsonb,
 'ep18-felicitaciones', 'estudio', false),
('ep18-felic-03', 'ep18-felicitaciones', 3, 'elegir',
 $j${"frase": "You really ___ it!", "opciones": ["deserve", "deserves", "deserved", "deserving"], "correcta": 0, "es": "¡De verdad te lo mereces!", "explicacion": "deserve + it."}$j$::jsonb,
 'ep18-felicitaciones', 'estudio', false),
('ep18-felic-04', 'ep18-felicitaciones', 4, 'elegir',
 $j${"frase": "You make a ___ couple.", "opciones": ["beautiful", "beautifully", "beauty", "beautify"], "correcta": 0, "es": "Hacen una pareja hermosa.", "explicacion": "beautiful couple."}$j$::jsonb,
 'ep18-felicitaciones', 'estudio', false),
('ep18-felic-05', 'ep18-felicitaciones', 5, 'escribir',
 $j${"respuestas": ["congratulations"], "mostrar": "Congratulations!", "es": "¡Felicitaciones!", "explicacion": "Congratulations!"}$j$::jsonb,
 'ep18-felicitaciones', 'estudio', false),
('ep18-felic-06', 'ep18-felicitaciones', 6, 'ordenar',
 $j${"frase": "We are so happy for you both.", "es": "Estamos muy felices por los dos.", "explicacion": "happy for you (both)."}$j$::jsonb,
 'ep18-felicitaciones', 'estudio', false),
('ep18-felic-07', 'ep18-felicitaciones', 7, 'emparejar',
 $j${"pares": [["Congratulations", "Felicitaciones"], ["I'm so happy for you", "Estoy muy feliz por ti"], ["You deserve it", "Te lo mereces"], ["Good luck", "Buena suerte"]], "es": "", "explicacion": "Expresiones de felicitación."}$j$::jsonb,
 'ep18-felicitaciones', 'estudio', false),
('ep18-felic-08', 'ep18-felicitaciones', 8, 'escuchar',
 $j${"opciones": ["Congratulations on your engagement!", "Congratulate on your engagement!", "Congratulations on your engaged!", "Congratulated your engagement!"], "correcta": 0, "audio": "Congratulations on your engagement!", "es": "¡Felicitaciones por tu compromiso!", "explicacion": "Congratulations on your..."}$j$::jsonb,
 'ep18-felicitaciones', 'input', false)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('banco-ep18-felic-01', 'banco-ep18', 1, 'comprension',
 $j${"modo": "escuchar", "lineas": [{"en": "Kathryn and I are engaged!", "es": "¡Kathryn y yo estamos comprometidos!"}, {"en": "Congratulations! You make a beautiful couple.", "es": "¡Felicitaciones! Hacen una pareja hermosa."}], "pregunta": "What is the news?", "pregunta_es": "¿Cuál es la noticia?", "opciones": ["They are engaged", "They moved to Bogotá", "They bought a house", "They won a prize"], "correcta": 0, "explicacion": "'Kathryn and I are engaged!'"}$j$::jsonb,
 'ep18-felicitaciones', 'input', false),
('banco-ep18-felic-02', 'banco-ep18', 2, 'comprension',
 $j${"modo": "leer", "lineas": [{"en": "I'm so happy for you. You really deserve this promotion.", "es": "Estoy muy feliz por ti. De verdad te mereces este ascenso."}, {"en": "Thanks! It means a lot to me.", "es": "¡Gracias! Significa mucho para mí."}], "pregunta": "What does the speaker think about the promotion?", "pregunta_es": "¿Qué piensa el hablante del ascenso?", "opciones": ["The person deserves it", "It is a mistake", "It is too late", "The person doesn't want it"], "correcta": 0, "explicacion": "'You really deserve this promotion.'"}$j$::jsonb,
 'ep18-felicitaciones', 'input', false),
('banco-ep18-felic-03', 'banco-ep18', 3, 'decir',
 $j${"es": "¡Felicitaciones por tu boda!", "respuestas": ["congratulations on your wedding", "congratulations on your marriage"], "mostrar": "Congratulations on your wedding!", "explicacion": "Congratulations on your..."}$j$::jsonb,
 'ep18-felicitaciones', 'output', false),
('banco-ep18-felic-04', 'banco-ep18', 4, 'decir',
 $j${"es": "Estoy muy feliz por ti.", "respuestas": ["i am so happy for you", "i'm so happy for you", "im so happy for you"], "mostrar": "I'm so happy for you.", "explicacion": "happy for you."}$j$::jsonb,
 'ep18-felicitaciones', 'output', false),
('banco-ep18-felic-05', 'banco-ep18', 5, 'libre',
 $j${"pregunta": "Write a short congratulations message to a friend who got a new job. Use two expressions from this lesson.", "pregunta_es": "Escribe un mensaje corto de felicitación a un amigo que consiguió un trabajo nuevo. Usa dos expresiones de esta lección.", "ejemplo": "Congratulations on your new job! I'm so happy for you. You really deserve it.", "criterio": "dos expresiones de felicitación.", "explicacion": "Usa las expresiones de la lección."}$j$::jsonb,
 'ep18-felicitaciones', 'output', false),
('banco-ep18-felic-06', 'banco-ep18', 6, 'rapido',
 $j${"frase": "___! You won the prize.", "opciones": ["Congratulations", "Congratulate"], "correcta": 0, "es": "¡Felicitaciones! Ganaste el premio.", "explicacion": "Congratulations!", "segundos": 5}$j$::jsonb,
 'ep18-felicitaciones', 'fluidez', false),
('banco-ep18-felic-07', 'banco-ep18', 7, 'rapido',
 $j${"frase": "You really ___ it.", "opciones": ["deserve", "deserved"], "correcta": 0, "es": "De verdad te lo mereces.", "explicacion": "deserve + it.", "segundos": 5}$j$::jsonb,
 'ep18-felicitaciones', 'fluidez', false),
('banco-ep18-felic-08', 'banco-ep18', 8, 'rapido',
 $j${"frase": "You make a ___ couple.", "opciones": ["beautiful", "beauty"], "correcta": 0, "es": "Hacen una pareja hermosa.", "explicacion": "beautiful.", "segundos": 5}$j$::jsonb,
 'ep18-felicitaciones', 'fluidez', false)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('examen-ep18-felic-01', 'examen-ep18', 1, 'elegir',
 $j${"frase": "I'm ___ for you!", "opciones": ["so happy", "so happily", "so happiest"], "correcta": 0, "es": "¡Estoy muy feliz por ti!", "explicacion": "so happy for you."}$j$::jsonb,
 'ep18-felicitaciones', 'estudio', true),
('examen-ep18-felic-02', 'examen-ep18', 2, 'escribir',
 $j${"respuestas": ["good luck"], "mostrar": "Good luck!", "es": "¡Buena suerte!", "explicacion": "Good luck!"}$j$::jsonb,
 'ep18-felicitaciones', 'estudio', true),
('examen-ep18-felic-03', 'examen-ep18', 3, 'escuchar',
 $j${"opciones": ["We are so happy for you both.", "We are so sad for you both.", "We are so happy with you both.", "We are so happy for two you."], "correcta": 0, "audio": "We are so happy for you both.", "es": "Estamos muy felices por los dos.", "explicacion": "happy for you."}$j$::jsonb,
 'ep18-felicitaciones', 'input', true)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;

-- EJERCICIOS — TEMA 8: ep18-preguntas-ordenes-indirecto
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('ep18-pregu-01', 'ep18-preguntas-ordenes-indirecto', 1, 'elegir',
 $j${"frase": "He asked me ___ I was from.", "opciones": ["where", "if", "that", "why"], "correcta": 0, "es": "Me preguntó de dónde era.", "explicacion": "pregunta con where; orden directo en indirecto."}$j$::jsonb,
 'ep18-preguntas-ordenes-indirecto', 'estudio', false),
('ep18-pregu-02', 'ep18-preguntas-ordenes-indirecto', 2, 'elegir',
 $j${"frase": "She asked me ___ I liked the museum.", "opciones": ["if", "that", "where", "what"], "correcta": 0, "es": "Me preguntó si me había gustado el museo.", "explicacion": "pregunta sí/no: if."}$j$::jsonb,
 'ep18-preguntas-ordenes-indirecto', 'estudio', false),
('ep18-pregu-03', 'ep18-preguntas-ordenes-indirecto', 3, 'elegir',
 $j${"frase": "The teacher told us ___ quiet.", "opciones": ["to be", "be", "being"], "correcta": 0, "es": "La profesora nos dijo que estuviéramos en silencio.", "explicacion": "told + objeto + to + verbo."}$j$::jsonb,
 'ep18-preguntas-ordenes-indirecto', 'estudio', false),
('ep18-pregu-04', 'ep18-preguntas-ordenes-indirecto', 4, 'elegir',
 $j${"frase": "He asked ___ the tickets were.", "opciones": ["where", "that", "to"], "correcta": 0, "es": "Preguntó dónde estaban las boletas.", "explicacion": "where en pregunta indirecta."}$j$::jsonb,
 'ep18-preguntas-ordenes-indirecto', 'estudio', false),
('ep18-pregu-05', 'ep18-preguntas-ordenes-indirecto', 5, 'escribir',
 $j${"respuestas": ["she asked me where i lived"], "mostrar": "She asked me where I lived.", "es": "Me preguntó dónde vivía.", "explicacion": "where + sujeto + verbo (sin signo de pregunta)."}$j$::jsonb,
 'ep18-preguntas-ordenes-indirecto', 'estudio', false),
('ep18-pregu-06', 'ep18-preguntas-ordenes-indirecto', 6, 'ordenar',
 $j${"frase": "He asked me if I was coming.", "es": "Me preguntó si iba a ir.", "explicacion": "asked + if + sujeto + verbo."}$j$::jsonb,
 'ep18-preguntas-ordenes-indirecto', 'estudio', false),
('ep18-pregu-07', 'ep18-preguntas-ordenes-indirecto', 7, 'emparejar',
 $j${"pares": [["asked me if", "me preguntó si"], ["asked me where", "me preguntó dónde"], ["told him to wait", "le dijo que esperara"], ["told her to call", "le dijo que llamara"]], "es": "", "explicacion": "Preguntas y órdenes en indirecto."}$j$::jsonb,
 'ep18-preguntas-ordenes-indirecto', 'estudio', false),
('ep18-pregu-08', 'ep18-preguntas-ordenes-indirecto', 8, 'escuchar',
 $j${"opciones": ["He asked me if I was ready.", "He asked me that I am ready.", "He asked me is I ready.", "He ask me if I ready."], "correcta": 0, "audio": "He asked me if I was ready.", "es": "Me preguntó si estaba listo.", "explicacion": "asked + if."}$j$::jsonb,
 'ep18-preguntas-ordenes-indirecto', 'input', false)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('banco-ep18-pregu-01', 'banco-ep18', 1, 'comprension',
 $j${"modo": "escuchar", "lineas": [{"en": "Harold asked me if I wanted to go to the theater.", "es": "Harold me preguntó si quería ir al teatro."}, {"en": "I told him I would think about it.", "es": "Le dije que lo pensaría."}], "pregunta": "What did Harold ask?", "pregunta_es": "¿Qué preguntó Harold?", "opciones": ["If the speaker wanted to go to the theater", "Where the theater was", "What time the show started", "If the speaker had a car"], "correcta": 0, "explicacion": "'He asked me if I wanted to go to the theater.'"}$j$::jsonb,
 'ep18-preguntas-ordenes-indirecto', 'input', false),
('banco-ep18-pregu-02', 'banco-ep18', 2, 'comprension',
 $j${"modo": "leer", "lineas": [{"en": "The doctor told me to rest for a week.", "es": "El médico me dijo que descansara una semana."}, {"en": "He asked me how I felt.", "es": "Me preguntó cómo me sentía."}], "pregunta": "What did the doctor tell the speaker?", "pregunta_es": "¿Qué le dijo el médico al hablante?", "opciones": ["To rest for a week", "To go to work", "To call a friend", "To eat more"], "correcta": 0, "explicacion": "'The doctor told me to rest for a week.'"}$j$::jsonb,
 'ep18-preguntas-ordenes-indirecto', 'input', false),
('banco-ep18-pregu-03', 'banco-ep18', 3, 'decir',
 $j${"es": "Me preguntó dónde vivía.", "respuestas": ["he asked me where i lived", "he asked me where i was living"], "mostrar": "He asked me where I lived.", "explicacion": "where + sujeto + verbo."}$j$::jsonb,
 'ep18-preguntas-ordenes-indirecto', 'output', false),
('banco-ep18-pregu-04', 'banco-ep18', 4, 'decir',
 $j${"es": "Le dije que se sentara.", "respuestas": ["i told him to sit down", "i told him to sit"], "mostrar": "I told him to sit down.", "explicacion": "told + objeto + to + verbo."}$j$::jsonb,
 'ep18-preguntas-ordenes-indirecto', 'output', false),
('banco-ep18-pregu-05', 'banco-ep18', 5, 'libre',
 $j${"pregunta": "Report two things someone asked or told you, using asked and told.", "pregunta_es": "Cuenta dos cosas que alguien te preguntó o te dijo, usando asked y told.", "ejemplo": "My mom asked me if I had eaten. My teacher told us to read the lesson.", "criterio": "asked/told + objeto + if/where/to.", "explicacion": "Usa if para sí/no y to para órdenes."}$j$::jsonb,
 'ep18-preguntas-ordenes-indirecto', 'output', false),
('banco-ep18-pregu-06', 'banco-ep18', 6, 'rapido',
 $j${"frase": "She asked me ___ I was tired.", "opciones": ["if", "that"], "correcta": 0, "es": "Me preguntó si estaba cansado.", "explicacion": "if.", "segundos": 5}$j$::jsonb,
 'ep18-preguntas-ordenes-indirecto', 'fluidez', false),
('banco-ep18-pregu-07', 'banco-ep18', 7, 'rapido',
 $j${"frase": "He told me ___ calm.", "opciones": ["to be", "be"], "correcta": 0, "es": "Me dijo que estuviera tranquilo.", "explicacion": "told + to.", "segundos": 5}$j$::jsonb,
 'ep18-preguntas-ordenes-indirecto', 'fluidez', false),
('banco-ep18-pregu-08', 'banco-ep18', 8, 'rapido',
 $j${"frase": "They asked where ___.", "opciones": ["the museum was", "was the museum"], "correcta": 0, "es": "Preguntaron dónde estaba el museo.", "explicacion": "orden directo en indirecto.", "segundos": 5}$j$::jsonb,
 'ep18-preguntas-ordenes-indirecto', 'fluidez', false)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('examen-ep18-pregu-01', 'examen-ep18', 1, 'elegir',
 $j${"frase": "He asked me ___ I liked modern art.", "opciones": ["if", "what", "to"], "correcta": 0, "es": "Me preguntó si me gustaba el arte moderno.", "explicacion": "pregunta sí/no: if."}$j$::jsonb,
 'ep18-preguntas-ordenes-indirecto', 'estudio', true),
('examen-ep18-pregu-02', 'examen-ep18', 2, 'escribir',
 $j${"respuestas": ["she told me to wait"], "mostrar": "She told me to wait.", "es": "Me dijo que esperara.", "explicacion": "told + objeto + to."}$j$::jsonb,
 'ep18-preguntas-ordenes-indirecto', 'estudio', true),
('examen-ep18-pregu-03', 'examen-ep18', 3, 'escuchar',
 $j${"opciones": ["She asked me where the theater was.", "She asked me where was the theater?", "She asked me that the theater was.", "She asked me the theater where."], "correcta": 0, "audio": "She asked me where the theater was.", "es": "Me preguntó dónde estaba el teatro.", "explicacion": "orden directo en indirecto."}$j$::jsonb,
 'ep18-preguntas-ordenes-indirecto', 'input', true)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;