-- =====================================================================
-- 008 · Batería de Wako, exámenes y medallas
--   - mi_energia: bloques de "Mi camino" y minutos de práctica libre por día
--     (1 bloque = 1 raya; 10 min de práctica libre = ½ raya)
--   - sumar_energia(): la app la llama al terminar un bloque o una práctica
--   - mi_wako: meta de rayas del día (3 o 4…) y si ya presentó el examen de ubicación
--   - mis_examenes: examen de ubicación y "Now I Can" (Test Yourself + Workshop)
--   - mis_medallas: niveles aprobados en el instituto (medalla 🏅, no hace crecer a Wako)
-- Pega TODO este archivo en Supabase → SQL Editor → Run.
-- Se puede correr varias veces sin dañar nada. Requiere 005 y 006.
-- =====================================================================

create table if not exists mi_energia (
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  fecha date not null,
  bloques int not null default 0,
  minutos_libre int not null default 0,
  primary key (user_id, fecha)
);
alter table mi_energia enable row level security;
drop policy if exists "mi energia" on mi_energia;
create policy "mi energia" on mi_energia for all to authenticated
  using (user_id = auth.uid() and es_activo()) with check (user_id = auth.uid() and es_activo());

create or replace function sumar_energia(p_fecha date, p_bloques int, p_minutos int)
returns mi_energia language plpgsql security invoker set search_path = public as $$
declare fila mi_energia;
begin
  insert into mi_energia (user_id, fecha, bloques, minutos_libre)
  values (auth.uid(), p_fecha, greatest(p_bloques, 0), greatest(p_minutos, 0))
  on conflict (user_id, fecha) do update set
    bloques = mi_energia.bloques + greatest(p_bloques, 0),
    minutos_libre = mi_energia.minutos_libre + greatest(p_minutos, 0)
  returning * into fila;
  return fila;
end $$;
revoke all on function sumar_energia(date, int, int) from anon;
grant execute on function sumar_energia(date, int, int) to authenticated;

alter table mi_wako add column if not exists meta_rayas int not null default 4;
alter table mi_wako drop constraint if exists mi_wako_meta_rayas_check;
alter table mi_wako add constraint mi_wako_meta_rayas_check check (meta_rayas between 2 and 6);
alter table mi_wako add column if not exists certificado boolean not null default false;

create table if not exists mis_examenes (
  id bigint generated always as identity primary key,
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  episodio int not null,
  tipo text not null check (tipo in ('ubicacion','test','workshop')),
  puntaje int not null check (puntaje between 0 and 100),
  aprobado boolean not null,
  fecha date not null,
  detalle jsonb,
  creado timestamptz not null default now()
);
create index if not exists mis_examenes_usuario on mis_examenes (user_id, episodio, tipo);
alter table mis_examenes enable row level security;
drop policy if exists "mis examenes ver" on mis_examenes;
drop policy if exists "mis examenes guardar" on mis_examenes;
create policy "mis examenes ver" on mis_examenes for select to authenticated using (user_id = auth.uid() and es_activo());
create policy "mis examenes guardar" on mis_examenes for insert to authenticated with check (user_id = auth.uid() and es_activo());

create table if not exists mis_medallas (
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  episodio int not null,
  fecha date not null default current_date,
  primary key (user_id, episodio)
);
alter table mis_medallas enable row level security;
drop policy if exists "mis medallas" on mis_medallas;
create policy "mis medallas" on mis_medallas for all to authenticated
  using (user_id = auth.uid() and es_activo()) with check (user_id = auth.uid() and es_activo());

-- Listo: 3 tablas nuevas, 1 función y 2 columnas en mi_wako.
