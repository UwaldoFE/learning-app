-- =====================================================================
-- 005 · Wako, tu compañero de estudio
--       Guarda cuántos episodios aprobaste en el instituto (para que Wako crezca)
--       y la última etapa que viste (para mostrar la animación de evolución una sola vez).
--       La energía no se guarda aquí: se calcula con lo que estudias (tabla mi_estudio).
-- Pega TODO este archivo en Supabase → SQL Editor → Run.
-- Se puede correr varias veces sin dañar nada.
-- =====================================================================
create table if not exists mi_wako (
  user_id uuid primary key default auth.uid() references auth.users(id) on delete cascade,
  episodios_aprobados int not null default 0 check (episodios_aprobados between 0 and 19),
  etapa_vista int not null default 1 check (etapa_vista between 1 and 10),
  actualizado timestamptz not null default now()
);
alter table mi_wako enable row level security;
drop policy if exists "mi wako" on mi_wako;
create policy "mi wako" on mi_wako for all to authenticated
  using (user_id = auth.uid() and es_activo()) with check (user_id = auth.uid() and es_activo());

-- Listo: 1 tabla nueva.
