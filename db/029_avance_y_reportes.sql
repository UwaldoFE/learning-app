-- 029: pantalla "Mi avance" para cada usuario y "Reportes" para el administrador.
-- Idempotente. Solo lee; no cambia datos.

-- Avance de un usuario. Cada persona ve el suyo; el administrador puede ver el de cualquiera.
create or replace function public.mi_avance(uid uuid default auth.uid())
returns jsonb
language plpgsql stable security definer set search_path = public
as $$
declare r jsonb;
begin
  if uid is distinct from auth.uid() and not es_admin() then
    raise exception 'No autorizado';
  end if;

  with dom as (
    select tema_id, pata, aciertos, dias_acierto,
      case when recientes = '' then 0
           else length(replace(recientes, '0', ''))::numeric / length(recientes) end as pct
    from mi_dominio where user_id = uid
  ),
  cumple as (
    select tema_id,
      (
        (pata = 'estudio' and aciertos >= 3 and pct >= 0.75) or
        (pata = 'input'   and aciertos >= 2 and pct >= 0.70) or
        (pata = 'output'  and aciertos >= 2 and pct >= 0.60) or
        (pata = 'fluidez' and aciertos >= 3 and pct >= 0.70)
      ) and dias_acierto >= 2 as ok
    from dom
  ),
  verdes as (
    select tema_id from cumple group by tema_id
    having count(*) filter (where ok) = 4
  )
  select jsonb_build_object(
    'temas_total',          (select count(*) from pensum_temas where materia_id = 'ingles'),
    'temas_verdes',         (select count(*) from verdes),
    'lecciones_aprobadas',  (select count(*) from mis_lecciones where user_id = uid and mejor_precision >= 80),
    'lecciones_intentadas', (select count(*) from mis_lecciones where user_id = uid),
    'xp_total',             coalesce((select sum(xp) from mi_estudio where user_id = uid), 0),
    'dias_estudio',         (select count(*) from mi_estudio where user_id = uid and (xp > 0 or lecciones > 0)),
    'dias_7',               (select count(*) from mi_estudio where user_id = uid and fecha >= current_date - 6 and (xp > 0 or lecciones > 0)),
    'ultimo_estudio',       (select max(fecha) from mi_estudio where user_id = uid and (xp > 0 or lecciones > 0)),
    'episodios_aprobados',  coalesce((select episodios_aprobados from mi_wako where user_id = uid), 0),
    'etapa_wako',           coalesce((select etapa_vista from mi_wako where user_id = uid), 1),
    'examenes_aprobados',   (select count(*) from mis_examenes where user_id = uid and aprobado),
    'medallas',             (select count(*) from mis_medallas where user_id = uid)
  ) into r;

  return r;
end $$;

-- Lista de todos los usuarios con su avance. Solo administradores.
create or replace function public.reporte_usuarios()
returns table (id uuid, nombre text, email text, rol text, activo boolean, creado timestamptz, avance jsonb)
language plpgsql stable security definer set search_path = public
as $$
begin
  if not es_admin() then
    raise exception 'No autorizado';
  end if;
  return query
    select p.id, p.nombre, p.email, p.rol, p.activo, p.creado, mi_avance(p.id)
    from perfiles p
    order by p.creado;
end $$;

grant execute on function public.mi_avance(uuid) to authenticated;
grant execute on function public.reporte_usuarios() to authenticated;
