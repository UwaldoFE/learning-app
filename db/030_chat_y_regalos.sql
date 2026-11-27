-- 030: chat entre amigas y primos, regalos de energía y supervisión del administrador.
-- Idempotente. Las escrituras pasan por funciones que validan todo; no hay inserciones directas.

-- Marca de menor: su amistad necesita aprobación del administrador.
alter table perfiles add column if not exists nino boolean not null default false;

-- ============ TABLAS ============
create table if not exists amistades (
  id bigint generated always as identity primary key,
  de uuid not null references perfiles(id) on delete cascade,
  para uuid not null references perfiles(id) on delete cascade,
  estado text not null default 'pendiente' check (estado in ('pendiente', 'aceptada', 'bloqueada')),
  aprobada_admin boolean not null default false,
  creado timestamptz not null default now(),
  check (de <> para),
  unique (de, para)
);

create table if not exists mensajes (
  id bigint generated always as identity primary key,
  de uuid not null references perfiles(id) on delete cascade,
  para uuid not null references perfiles(id) on delete cascade,
  texto text not null check (char_length(texto) between 1 and 500),
  creado timestamptz not null default now(),
  reportado boolean not null default false
);
create index if not exists mensajes_par on mensajes (de, para, creado);

create table if not exists reportes_chat (
  id bigint generated always as identity primary key,
  mensaje_id bigint not null references mensajes(id) on delete cascade,
  reporta uuid not null references perfiles(id) on delete cascade,
  motivo text,
  creado timestamptz not null default now(),
  revisado boolean not null default false
);

create table if not exists regalos (
  id bigint generated always as identity primary key,
  de uuid not null references perfiles(id) on delete cascade,
  para uuid not null references perfiles(id) on delete cascade,
  rayas numeric(3,1) not null check (rayas > 0 and rayas <= 5),
  fecha date not null default current_date,
  creado timestamptz not null default now(),
  check (de <> para)
);

alter table amistades enable row level security;
alter table mensajes enable row level security;
alter table reportes_chat enable row level security;
alter table regalos enable row level security;

drop policy if exists "amistades ver" on amistades;
create policy "amistades ver" on amistades for select to authenticated
  using ((de = auth.uid() or para = auth.uid()) and es_activo() or es_admin());

drop policy if exists "mensajes ver" on mensajes;
create policy "mensajes ver" on mensajes for select to authenticated
  using ((de = auth.uid() or para = auth.uid()) and es_activo() or es_admin());

drop policy if exists "reportes ver" on reportes_chat;
create policy "reportes ver" on reportes_chat for select to authenticated
  using (reporta = auth.uid() or es_admin());
drop policy if exists "reportes revisar" on reportes_chat;
create policy "reportes revisar" on reportes_chat for update to authenticated
  using (es_admin()) with check (es_admin());

drop policy if exists "regalos ver" on regalos;
create policy "regalos ver" on regalos for select to authenticated
  using ((de = auth.uid() or para = auth.uid()) and es_activo() or es_admin());

-- ============ FUNCIONES AUXILIARES ============
create or replace function public.amistad_activa(a uuid, b uuid)
returns boolean language sql stable security definer set search_path = public as $$
  select exists (select 1 from amistades
    where estado = 'aceptada' and aprobada_admin
      and ((de = a and para = b) or (de = b and para = a)));
$$;

create or replace function public.bloqueado(a uuid, b uuid)
returns boolean language sql stable security definer set search_path = public as $$
  select exists (select 1 from amistades
    where estado = 'bloqueada'
      and ((de = a and para = b) or (de = b and para = a)));
$$;

-- ============ LECTURA ============
-- Contactos de una persona (solicitudes y amistades). El administrador puede ver los de cualquiera.
create or replace function public.contactos_de(uid uuid default auth.uid())
returns table (amistad_id bigint, otro uuid, nombre text, estado text, aprobada boolean, pedida_por_mi boolean)
language plpgsql stable security definer set search_path = public
as $$
begin
  if uid is distinct from auth.uid() and not es_admin() then
    raise exception 'No autorizado';
  end if;
  return query
    select a.id,
           case when a.de = uid then a.para else a.de end,
           coalesce(p.nombre, p.email, ''),
           a.estado,
           a.aprobada_admin,
           a.de = uid
    from amistades a
    join perfiles p on p.id = case when a.de = uid then a.para else a.de end
    where (a.de = uid or a.para = uid)
    order by a.creado desc;
end $$;

-- Buscar a una persona por correo exacto (solo muestra nombre e id).
create or replace function public.buscar_usuario(p_email text)
returns table (id uuid, nombre text)
language plpgsql stable security definer set search_path = public
as $$
begin
  if not es_activo() then raise exception 'No autorizado'; end if;
  return query
    select p.id, coalesce(p.nombre, p.email)
    from perfiles p
    where lower(p.email) = lower(trim(p_email)) and p.activo and p.id <> auth.uid();
end $$;

-- Energía disponible hoy (en rayas), contando regalos recibidos y enviados.
create or replace function public.energia_disponible_hoy(uid uuid default auth.uid())
returns numeric language sql stable security definer set search_path = public
as $$
  select coalesce((select bloques + floor(minutos_libre / 10.0) / 2
                   from mi_energia where user_id = uid and fecha = current_date), 0)
       + coalesce((select sum(rayas) from regalos where para = uid and fecha = current_date), 0)
       - coalesce((select sum(rayas) from regalos where de = uid and fecha = current_date), 0);
$$;

-- ============ ESCRITURA (todo pasa por aquí) ============
create or replace function public.pedir_amistad(p_para uuid)
returns text language plpgsql security definer set search_path = public
as $$
declare yo uuid := auth.uid();
begin
  if not es_activo() then raise exception 'No autorizado'; end if;
  if bloqueado(yo, p_para) then raise exception 'No disponible'; end if;
  if exists (select 1 from amistades where (de = yo and para = p_para) or (de = p_para and para = yo)) then
    return 'Ya hay una solicitud o amistad con esta persona';
  end if;
  insert into amistades (de, para) values (yo, p_para);
  return 'Solicitud enviada';
end $$;

create or replace function public.responder_amistad(p_de uuid, p_aceptar boolean)
returns text language plpgsql security definer set search_path = public
as $$
declare yo uuid := auth.uid();
begin
  if not es_activo() then raise exception 'No autorizado'; end if;
  if p_aceptar then
    update amistades set estado = 'aceptada',
      -- si alguna de las dos es menor, queda esperando aprobación del administrador
      aprobada_admin = not (
        coalesce((select nino from perfiles where id = yo), false) or
        coalesce((select nino from perfiles where id = p_de), false))
    where de = p_de and para = yo and estado = 'pendiente';
    return 'Aceptada';
  end if;
  delete from amistades where de = p_de and para = yo and estado = 'pendiente';
  return 'Rechazada';
end $$;

create or replace function public.bloquear(p_otro uuid)
returns text language plpgsql security definer set search_path = public
as $$
declare yo uuid := auth.uid();
begin
  if not es_activo() then raise exception 'No autorizado'; end if;
  delete from amistades where (de = yo and para = p_otro) or (de = p_otro and para = yo);
  insert into amistades (de, para, estado, aprobada_admin) values (yo, p_otro, 'bloqueada', true)
    on conflict (de, para) do update set estado = 'bloqueada';
  return 'Bloqueada';
end $$;

-- Solo el administrador aprueba amistades de menores.
create or replace function public.aprobar_amistad(p_id bigint)
returns text language plpgsql security definer set search_path = public
as $$
begin
  if not es_admin() then raise exception 'No autorizado'; end if;
  update amistades set aprobada_admin = true where id = p_id and estado = 'aceptada';
  return 'Aprobada';
end $$;

create or replace function public.enviar_mensaje(p_para uuid, p_texto text)
returns bigint language plpgsql security definer set search_path = public
as $$
declare yo uuid := auth.uid(); nuevo bigint;
begin
  if not es_activo() then raise exception 'No autorizado'; end if;
  if not amistad_activa(yo, p_para) or bloqueado(yo, p_para) then
    raise exception 'Solo puedes escribir a tus amigas y primos aprobados';
  end if;
  if trim(coalesce(p_texto, '')) = '' then raise exception 'Escribe un mensaje'; end if;
  if (select count(*) from mensajes where de = yo and creado >= now() - interval '1 day') >= 300 then
    raise exception 'Llegaste al límite de mensajes de hoy';
  end if;
  insert into mensajes (de, para, texto) values (yo, p_para, left(trim(p_texto), 500))
  returning id into nuevo;
  return nuevo;
end $$;

create or replace function public.reportar_mensaje(p_id bigint, p_motivo text default null)
returns text language plpgsql security definer set search_path = public
as $$
declare yo uuid := auth.uid();
begin
  if not es_activo() then raise exception 'No autorizado'; end if;
  if not exists (select 1 from mensajes where id = p_id and (de = yo or para = yo)) then
    raise exception 'No autorizado';
  end if;
  insert into reportes_chat (mensaje_id, reporta, motivo) values (p_id, yo, left(p_motivo, 300));
  update mensajes set reportado = true where id = p_id;
  return 'Reporte enviado';
end $$;

-- Regalo de energía: en rayas (½ o 1). Máximo 2 rayas regaladas por día y sin pasar la energía que tienes hoy.
create or replace function public.enviar_regalo(p_para uuid, p_rayas numeric)
returns numeric language plpgsql security definer set search_path = public
as $$
declare yo uuid := auth.uid(); disponible numeric; ya_regalado numeric;
begin
  if not es_activo() then raise exception 'No autorizado'; end if;
  if not amistad_activa(yo, p_para) or bloqueado(yo, p_para) then
    raise exception 'Solo puedes regalar energía a tus amigas y primos aprobados';
  end if;
  if p_rayas < 0.5 or p_rayas > 2 or (p_rayas * 2) <> floor(p_rayas * 2) then
    raise exception 'Regalo no válido';
  end if;
  select coalesce(sum(rayas), 0) into ya_regalado from regalos where de = yo and fecha = current_date;
  if ya_regalado + p_rayas > 2 then
    raise exception 'Hoy ya regalaste el máximo de 2 rayas';
  end if;
  disponible := energia_disponible_hoy(yo);
  if disponible < p_rayas then
    raise exception 'No tienes suficiente energía hoy';
  end if;
  insert into regalos (de, para, rayas) values (yo, p_para, p_rayas);
  return disponible - p_rayas;
end $$;

-- Permisos
grant execute on function public.contactos_de(uuid) to authenticated;
grant execute on function public.buscar_usuario(text) to authenticated;
grant execute on function public.energia_disponible_hoy(uuid) to authenticated;
grant execute on function public.pedir_amistad(uuid) to authenticated;
grant execute on function public.responder_amistad(uuid, boolean) to authenticated;
grant execute on function public.bloquear(uuid) to authenticated;
grant execute on function public.aprobar_amistad(bigint) to authenticated;
grant execute on function public.enviar_mensaje(uuid, text) to authenticated;
grant execute on function public.reportar_mensaje(bigint, text) to authenticated;
grant execute on function public.enviar_regalo(uuid, numeric) to authenticated;
