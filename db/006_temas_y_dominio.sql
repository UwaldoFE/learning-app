-- =====================================================================
-- 006 · Temas del pénsum y dominio por tema (base de "Mi camino" y los exámenes)
--   - pensum_temas: los temas de cada episodio (Ep 1–3 por ahora)
--   - ejercicios.tema_id y ejercicios.pata: a qué tema y a qué pata pertenece cada ejercicio
--     (pata: estudio, input, output, fluidez — las "4 patas" de Paul Nation)
--   - mi_dominio: tu avance por tema y pata, incluidos los días distintos en que acertaste
--   - registrar_dominio(): la app la llama con cada respuesta
-- Pega TODO este archivo en Supabase → SQL Editor → Run.
-- Se puede correr varias veces sin dañar nada.
-- =====================================================================

create table if not exists pensum_temas (
  id text primary key,
  materia_id text not null default 'ingles' references materias(id) on delete cascade,
  episodio int not null,
  orden int not null default 0,
  nombre_es text not null,
  nombre_en text,
  descripcion text
);
alter table pensum_temas enable row level security;
drop policy if exists "leer pensum" on pensum_temas;
create policy "leer pensum" on pensum_temas for select to authenticated using (es_activo());

alter table ejercicios add column if not exists tema_id text references pensum_temas(id) on delete set null;
alter table ejercicios add column if not exists pata text not null default 'estudio';
alter table ejercicios drop constraint if exists ejercicios_pata_check;
alter table ejercicios add constraint ejercicios_pata_check check (pata in ('estudio','input','output','fluidez'));

create table if not exists mi_dominio (
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  tema_id text not null references pensum_temas(id) on delete cascade,
  pata text not null check (pata in ('estudio','input','output','fluidez')),
  intentos int not null default 0,
  aciertos int not null default 0,
  recientes text not null default '',          -- últimas 10 respuestas: 1 = bien, 0 = mal (la más nueva al final)
  dias_acierto int not null default 0,          -- en cuántos días distintos acertaste
  ultimo_dia_acierto date,
  actualizado timestamptz not null default now(),
  primary key (user_id, tema_id, pata)
);
alter table mi_dominio enable row level security;
drop policy if exists "mi dominio" on mi_dominio;
create policy "mi dominio" on mi_dominio for all to authenticated
  using (user_id = auth.uid() and es_activo()) with check (user_id = auth.uid() and es_activo());

-- La app llama esta función con cada respuesta (suma de forma segura, sin pisar datos)
create or replace function registrar_dominio(p_tema text, p_pata text, p_ok boolean, p_fecha date)
returns void language plpgsql security invoker set search_path = public as $$
begin
  insert into mi_dominio (user_id, tema_id, pata, intentos, aciertos, recientes, dias_acierto, ultimo_dia_acierto)
  values (auth.uid(), p_tema, p_pata, 1, case when p_ok then 1 else 0 end,
          case when p_ok then '1' else '0' end, case when p_ok then 1 else 0 end, case when p_ok then p_fecha end)
  on conflict (user_id, tema_id, pata) do update set
    intentos = mi_dominio.intentos + 1,
    aciertos = mi_dominio.aciertos + case when p_ok then 1 else 0 end,
    recientes = right(mi_dominio.recientes || case when p_ok then '1' else '0' end, 10),
    dias_acierto = mi_dominio.dias_acierto
      + case when p_ok and (mi_dominio.ultimo_dia_acierto is null or mi_dominio.ultimo_dia_acierto < p_fecha) then 1 else 0 end,
    ultimo_dia_acierto = case when p_ok then greatest(coalesce(mi_dominio.ultimo_dia_acierto, p_fecha), p_fecha) else mi_dominio.ultimo_dia_acierto end,
    actualizado = now();
end $$;
revoke all on function registrar_dominio(text, text, boolean, date) from anon;
grant execute on function registrar_dominio(text, text, boolean, date) to authenticated;

-- ============ TEMAS DEL PÉNSUM (Ep 1–3) ============
insert into pensum_temas (id, episodio, orden, nombre_es, nombre_en, descripcion) values
  ('ep1-to-be', 1, 1, 'Verbo to be', 'to be (am / is / are)', 'Ser o estar: I am, you are, he/she/it is; negativas y preguntas.'),
  ('ep1-a-an', 1, 2, 'Artículos a / an', 'a / an', 'Un/una: a ante sonido de consonante, an ante sonido de vocal; la profesión lleva a/an.'),
  ('ep1-pronombres', 1, 3, 'Pronombres y posesivos', 'he / his, she / her', 'Quién hace la acción (he, she, it) y de quién es algo (his, her, my, their).'),
  ('ep1-profesiones', 1, 4, 'Profesiones', 'Jobs', 'Decir a qué te dedicas: I''m a nurse, an engineer…'),
  ('ep1-clima', 1, 5, 'El clima', 'Weather', 'It''s sunny, rainy, cloudy, hot, cold.'),
  ('ep1-adjetivos', 1, 6, 'Adjetivos para describir', 'Adjectives', 'El adjetivo va antes del sustantivo y no lleva -s; contrarios.'),
  ('ep1-cuerpo', 1, 7, 'Partes del cuerpo', 'The body', 'Head, eyes, hands, legs; describir cómo es una persona.'),
  ('ep1-comparativos', 1, 8, 'Comparativos y superlativos', 'taller than / the biggest', '-er than, more … than, the -est, the most …; good/better/the best.'),
  ('ep2-presente-s', 2, 1, 'Presente simple: la -s de he/she/it', 'Present simple', 'Rutinas y verdades; solo he/she/it llevan -s (lives, studies, watches).'),
  ('ep2-do-does', 2, 2, 'Do / does: preguntas y negativas', 'do / does', 'Do con I/you/we/they, does con he/she/it; después de does el verbo va sin -s.'),
  ('ep2-rutinas', 2, 3, 'Rutinas diarias', 'Daily routine', 'Wake up, take a shower, have lunch, sell on social media…'),
  ('ep2-plurales', 2, 4, 'Plurales regulares e irregulares', 'Plurals', 'shoe → shoes; child → children, man → men, person → people.'),
  ('ep2-this-that', 2, 5, 'This, that, these, those', 'Demonstratives', 'Cerca/lejos y singular/plural.'),
  ('ep2-the', 2, 6, 'El artículo the', 'the', 'Cuándo usar the y cuándo no.'),
  ('ep2-numeros', 2, 7, 'Números', 'Numbers', 'Contar, precios y edades.'),
  ('ep2-hora', 2, 8, 'La hora', 'Telling the time', 'What time is it? o''clock, a quarter past, half past, a quarter to.'),
  ('ep3-would-like', 3, 1, 'Would like', 'would like', 'Ofrecer y pedir con cortesía: Would you like…? I''d like…'),
  ('ep3-can-could', 3, 2, 'Can y could', 'can / could', 'Poder o saber hacer algo; pedir con cortesía: Could you…?'),
  ('ep3-may-might', 3, 3, 'May y might', 'may / might', 'Posibilidad (It might rain) y permiso formal (May I…?).'),
  ('ep3-conectores', 3, 4, 'Conectores', 'and, but, so, because, or', 'Unir ideas: suma, contraste, resultado, razón y opción.'),
  ('ep3-question-words', 3, 5, 'Palabras para preguntar', 'Question words', 'What, where, when, who, why, how much, how long, what time.'),
  ('ep3-whose', 3, 6, 'Whose', 'whose', 'De quién es algo; respuesta con ''s.')
on conflict (id) do update set episodio = excluded.episodio, orden = excluded.orden, nombre_es = excluded.nombre_es,
  nombre_en = excluded.nombre_en, descripcion = excluded.descripcion;

-- ============ CADA EJERCICIO CON SU TEMA Y SU PATA ============
update ejercicios set tema_id = 'ep1-a-an', pata = 'estudio' where id in ('ep2-a-an-plurales-01', 'ep2-a-an-plurales-02', 'ep2-a-an-plurales-03', 'ep2-a-an-plurales-04');
update ejercicios set tema_id = 'ep1-adjetivos', pata = 'estudio' where id in ('ep1-adjetivos-cuerpo-01', 'ep1-adjetivos-cuerpo-02', 'ep1-adjetivos-cuerpo-05', 'ep1-adjetivos-cuerpo-06', 'ep1-adjetivos-cuerpo-07', 'ep1-adjetivos-cuerpo-09');
update ejercicios set tema_id = 'ep1-adjetivos', pata = 'input' where id in ('ep1-adjetivos-cuerpo-08');
update ejercicios set tema_id = 'ep1-clima', pata = 'estudio' where id in ('ep1-profesiones-clima-04', 'ep1-profesiones-clima-05', 'ep1-profesiones-clima-06', 'ep1-profesiones-clima-08');
update ejercicios set tema_id = 'ep1-clima', pata = 'input' where id in ('ep1-profesiones-clima-09');
update ejercicios set tema_id = 'ep1-comparativos', pata = 'estudio' where id in ('ep1-comparativos-01', 'ep1-comparativos-02', 'ep1-comparativos-03', 'ep1-comparativos-04', 'ep1-comparativos-05', 'ep1-comparativos-06', 'ep1-comparativos-07', 'ep1-comparativos-09', 'ep1-comparativos-10');
update ejercicios set tema_id = 'ep1-comparativos', pata = 'input' where id in ('ep1-comparativos-08');
update ejercicios set tema_id = 'ep1-cuerpo', pata = 'estudio' where id in ('ep1-adjetivos-cuerpo-03', 'ep1-adjetivos-cuerpo-04', 'ep1-adjetivos-cuerpo-10');
update ejercicios set tema_id = 'ep1-profesiones', pata = 'estudio' where id in ('ep1-profesiones-clima-01', 'ep1-profesiones-clima-02', 'ep1-profesiones-clima-03', 'ep1-profesiones-clima-07', 'ep1-profesiones-clima-10');
update ejercicios set tema_id = 'ep1-pronombres', pata = 'estudio' where id in ('ep1-pronombres-01', 'ep1-pronombres-02', 'ep1-pronombres-03', 'ep1-pronombres-04', 'ep1-pronombres-05', 'ep1-pronombres-06', 'ep1-pronombres-07');
update ejercicios set tema_id = 'ep1-pronombres', pata = 'input' where id in ('ep1-pronombres-08');
update ejercicios set tema_id = 'ep1-to-be', pata = 'estudio' where id in ('ep1-to-be-01', 'ep1-to-be-02', 'ep1-to-be-03', 'ep1-to-be-04', 'ep1-to-be-05', 'ep1-to-be-06', 'ep1-to-be-07', 'ep1-to-be-08', 'ep1-to-be-10');
update ejercicios set tema_id = 'ep1-to-be', pata = 'input' where id in ('ep1-to-be-09');
update ejercicios set tema_id = 'ep2-do-does', pata = 'estudio' where id in ('ep2-do-does-01', 'ep2-do-does-02', 'ep2-do-does-03', 'ep2-do-does-04', 'ep2-do-does-05', 'ep2-do-does-06', 'ep2-do-does-07', 'ep2-mi-rutina-09');
update ejercicios set tema_id = 'ep2-do-does', pata = 'input' where id in ('ep2-do-does-08');
update ejercicios set tema_id = 'ep2-plurales', pata = 'estudio' where id in ('ep2-a-an-plurales-05', 'ep2-a-an-plurales-06', 'ep2-a-an-plurales-07', 'ep2-a-an-plurales-08');
update ejercicios set tema_id = 'ep2-presente-s', pata = 'estudio' where id in ('ep2-regla-s-01', 'ep2-regla-s-02', 'ep2-regla-s-03', 'ep2-regla-s-05', 'ep2-regla-s-06', 'ep2-regla-s-07', 'ep2-regla-s-08', 'ep2-regla-s-09', 'ep2-mi-rutina-01');
update ejercicios set tema_id = 'ep2-presente-s', pata = 'input' where id in ('ep2-regla-s-04');
update ejercicios set tema_id = 'ep2-rutinas', pata = 'estudio' where id in ('ep2-mi-rutina-02', 'ep2-mi-rutina-03', 'ep2-mi-rutina-04', 'ep2-mi-rutina-05', 'ep2-mi-rutina-06', 'ep2-mi-rutina-07');
update ejercicios set tema_id = 'ep2-rutinas', pata = 'input' where id in ('ep2-mi-rutina-08');
update ejercicios set tema_id = 'ep3-can-could', pata = 'estudio' where id in ('ep3-could-you-01', 'ep3-could-you-02', 'ep3-could-you-03', 'ep3-could-you-04', 'ep3-could-you-05', 'ep3-could-you-06', 'ep3-could-you-08', 'ep3-simulacro-02', 'ep3-simulacro-06', 'ep3-can-could-01', 'ep3-can-could-02', 'ep3-can-could-03', 'ep3-can-could-04', 'ep3-can-could-05', 'ep3-can-could-06', 'ep3-can-could-07', 'ep3-can-could-09', 'ep3-can-could-10', 'ep3-simulacro-13');
update ejercicios set tema_id = 'ep3-can-could', pata = 'input' where id in ('ep3-could-you-07', 'ep3-can-could-08');
update ejercicios set tema_id = 'ep3-conectores', pata = 'estudio' where id in ('ep3-might-conectores-02', 'ep3-might-conectores-03', 'ep3-might-conectores-06', 'ep3-simulacro-05', 'ep3-because-or-01', 'ep3-because-or-02', 'ep3-because-or-03', 'ep3-because-or-04', 'ep3-because-or-05', 'ep3-because-or-06', 'ep3-because-or-07', 'ep3-because-or-08', 'ep3-because-or-10', 'ep3-simulacro-15');
update ejercicios set tema_id = 'ep3-conectores', pata = 'input' where id in ('ep3-because-or-09');
update ejercicios set tema_id = 'ep3-may-might', pata = 'estudio' where id in ('ep3-might-conectores-01', 'ep3-might-conectores-04', 'ep3-might-conectores-05', 'ep3-simulacro-04');
update ejercicios set tema_id = 'ep3-may-might', pata = 'input' where id in ('ep3-might-conectores-07');
update ejercicios set tema_id = 'ep3-question-words', pata = 'estudio' where id in ('ep2-do-does-09', 'ep3-whose-07', 'ep3-simulacro-10', 'ep3-simulacro-11', 'ep3-simulacro-12', 'ep3-question-words-01', 'ep3-question-words-02', 'ep3-question-words-03', 'ep3-question-words-04', 'ep3-question-words-05', 'ep3-question-words-06', 'ep3-question-words-07', 'ep3-question-words-08', 'ep3-question-words-09', 'ep3-question-words-11', 'ep3-question-words-12', 'ep3-simulacro-14');
update ejercicios set tema_id = 'ep3-question-words', pata = 'input' where id in ('ep3-question-words-10');
update ejercicios set tema_id = 'ep3-whose', pata = 'estudio' where id in ('ep3-whose-01', 'ep3-whose-02', 'ep3-whose-03', 'ep3-whose-04', 'ep3-whose-05', 'ep3-simulacro-03', 'ep3-simulacro-08');
update ejercicios set tema_id = 'ep3-whose', pata = 'input' where id in ('ep3-whose-06');
update ejercicios set tema_id = 'ep3-would-like', pata = 'estudio' where id in ('ep3-would-like-01', 'ep3-would-like-02', 'ep3-would-like-03', 'ep3-would-like-04', 'ep3-would-like-05', 'ep3-would-like-07', 'ep3-would-like-08', 'ep3-simulacro-01', 'ep3-simulacro-07');
update ejercicios set tema_id = 'ep3-would-like', pata = 'input' where id in ('ep3-would-like-06', 'ep3-simulacro-09');

-- Listo: 22 temas, 160 ejercicios etiquetados, 1 tabla de dominio.
