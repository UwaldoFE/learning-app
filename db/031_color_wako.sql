-- 031: color de Wako por persona (para distinguir los bots de cada niña/niño)
alter table perfiles add column if not exists tono_wako text not null default 'azul'
  check (tono_wako in ('azul', 'rosa', 'morado', 'verde', 'naranja'));

create or replace function public.elegir_tono_wako(p_tono text)
returns text language plpgsql security definer set search_path = public
as $$
begin
  if not es_activo() then raise exception 'No autorizado'; end if;
  if p_tono not in ('azul', 'rosa', 'morado', 'verde', 'naranja') then
    raise exception 'Color no válido';
  end if;
  update perfiles set tono_wako = p_tono where id = auth.uid();
  return p_tono;
end $$;

grant execute on function public.elegir_tono_wako(text) to authenticated;
