-- =====================================================================
-- 010 · Tocar una palabra → significado + "Mis palabras"
--   - diccionario: significados que Wako ya buscó (se comparten, así cada
--     palabra se paga una sola vez)
--   - mis_palabras: palabras que guardas para repasar en Tarjetas
--   - tutor_uso.palabras: tope diario de búsquedas con Wako
-- Pega TODO este archivo en Supabase → SQL Editor → Run.
-- Se puede correr varias veces sin dañar nada.
-- =====================================================================

create table if not exists diccionario (
  palabra text primary key,
  es text not null,
  nota text,
  creado timestamptz not null default now()
);

create table if not exists mis_palabras (
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  palabra text not null,
  significado text not null,
  frase text,
  caja int not null default 1,
  proxima_revision date not null default current_date,
  aciertos int not null default 0,
  fallos int not null default 0,
  creado timestamptz not null default now(),
  primary key (user_id, palabra)
);

alter table tutor_uso add column if not exists palabras int not null default 0;

alter table diccionario  enable row level security;
alter table mis_palabras enable row level security;

drop policy if exists "leer diccionario" on diccionario;
drop policy if exists "agregar diccionario" on diccionario;
drop policy if exists "mis palabras" on mis_palabras;
create policy "leer diccionario" on diccionario for select to authenticated using (es_activo());
create policy "agregar diccionario" on diccionario for insert to authenticated with check (es_activo());
create policy "mis palabras" on mis_palabras for all to authenticated
  using (user_id = auth.uid() and es_activo()) with check (user_id = auth.uid() and es_activo());

-- Listo: 2 tablas nuevas y 1 columna.
