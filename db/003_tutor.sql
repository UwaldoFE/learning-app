-- ============================================================
-- 003 · Tutor IA: ficha "Mi vida", uso diario del tutor
--       y progreso de "Leer y escuchar" en tu cuenta
-- Pega TODO este archivo en Supabase → SQL Editor → Run.
-- Se puede correr varias veces sin dañar nada.
-- ============================================================

-- Lo que el tutor sabe de ti (lo escribes tú en la app)
create table if not exists mi_vida (
  user_id uuid primary key default auth.uid() references auth.users(id) on delete cascade,
  texto text not null default '',
  actualizado timestamptz not null default now()
);

-- Mensajes al tutor por día (para el tope diario y cuidar el saldo)
create table if not exists tutor_uso (
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  fecha date not null,
  mensajes int not null default 0,
  primary key (user_id, fecha)
);

-- Historias de "Leer y escuchar" ya hechas (para verlas en cualquier dispositivo)
create table if not exists mis_lecturas (
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  lectura_id text not null,
  aciertos int not null default 0,
  veces int not null default 0,
  ultima timestamptz not null default now(),
  primary key (user_id, lectura_id)
);

alter table mi_vida      enable row level security;
alter table tutor_uso    enable row level security;
alter table mis_lecturas enable row level security;

drop policy if exists "mi vida" on mi_vida;
drop policy if exists "tutor uso" on tutor_uso;
drop policy if exists "mis lecturas" on mis_lecturas;
create policy "mi vida" on mi_vida for all to authenticated
  using (user_id = auth.uid() and es_activo()) with check (user_id = auth.uid() and es_activo());
create policy "tutor uso" on tutor_uso for all to authenticated
  using (user_id = auth.uid() and es_activo()) with check (user_id = auth.uid() and es_activo());
create policy "mis lecturas" on mis_lecturas for all to authenticated
  using (user_id = auth.uid() and es_activo()) with check (user_id = auth.uid() and es_activo());

-- Listo: 3 tablas nuevas.
