-- Estructura de la base de datos (Supabase / PostgreSQL).
-- Solo tablas y reglas de seguridad: el contenido de los cursos NO se guarda en este repositorio.

-- ============ TABLAS ============
create table if not exists materias (
  id text primary key,
  nombre text not null,
  orden int not null default 0
);
create table if not exists unidades (
  id bigint generated always as identity primary key,
  materia_id text not null references materias(id) on delete cascade,
  numero int not null,
  episodio text,
  paginas text,
  objetivo text,
  practica text,
  unique (materia_id, numero)
);
create table if not exists temas (
  id bigint generated always as identity primary key,
  unidad_id bigint not null references unidades(id) on delete cascade,
  orden int not null default 0,
  seccion text,
  paginas text,
  tema_en text not null,
  tema_es text
);
create table if not exists tarjetas (
  id bigint generated always as identity primary key,
  materia_id text not null references materias(id) on delete cascade,
  unidad_id bigint references unidades(id) on delete cascade,
  tema text,
  frente text not null,
  reverso text not null,
  ejemplo text,
  traduccion text
);
create table if not exists progreso (
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  tarjeta_id bigint not null references tarjetas(id) on delete cascade,
  caja int not null default 1,
  proxima_revision date not null default current_date,
  aciertos int not null default 0,
  fallos int not null default 0,
  actualizado timestamptz not null default now(),
  primary key (user_id, tarjeta_id)
);
create table if not exists perfiles (
  id uuid primary key references auth.users(id) on delete cascade,
  email text,
  nombre text,
  rol text not null default 'estudiante' check (rol in ('admin', 'estudiante')),
  activo boolean not null default false,
  creado timestamptz not null default now()
);

-- ============ FUNCIONES DE ROL ============
create or replace function public.es_admin() returns boolean
language sql stable security definer set search_path = public as $$
  select exists (select 1 from perfiles where id = auth.uid() and rol = 'admin' and activo);
$$;
create or replace function public.es_activo() returns boolean
language sql stable security definer set search_path = public as $$
  select exists (select 1 from perfiles where id = auth.uid() and activo);
$$;

-- Cada cuenta nueva crea su perfil (queda pendiente hasta que un admin la apruebe)
create or replace function public.crear_perfil() returns trigger
language plpgsql security definer set search_path = public as $$
begin
  insert into perfiles (id, email, nombre)
  values (new.id, new.email, coalesce(new.raw_user_meta_data->>'nombre', ''))
  on conflict (id) do nothing;
  return new;
end $$;
drop trigger if exists al_crear_usuario on auth.users;
create trigger al_crear_usuario after insert on auth.users
  for each row execute function public.crear_perfil();

-- ============ SEGURIDAD (Row Level Security) ============
alter table materias enable row level security;
alter table unidades enable row level security;
alter table temas    enable row level security;
alter table tarjetas enable row level security;
alter table progreso enable row level security;
alter table perfiles enable row level security;
revoke all on materias, unidades, temas, tarjetas, progreso, perfiles from anon;

create policy "leer materias" on materias for select to authenticated using (es_activo());
create policy "leer unidades" on unidades for select to authenticated using (es_activo());
create policy "leer temas"    on temas    for select to authenticated using (es_activo());
create policy "leer tarjetas" on tarjetas for select to authenticated using (es_activo());
create policy "mi progreso"   on progreso for all to authenticated
  using (user_id = auth.uid() and es_activo()) with check (user_id = auth.uid() and es_activo());
create policy "ver perfiles" on perfiles for select to authenticated
  using (id = auth.uid() or es_admin());
create policy "admin edita perfiles" on perfiles for update to authenticated
  using (es_admin()) with check (es_admin());
