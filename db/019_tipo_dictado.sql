-- =====================================================================
-- 019 · Tipo de ejercicio "dictado"
--   - Amplía el check de ejercicios.tipo para aceptar el tipo 'dictado'
--     (se oye la frase, como "escuchar" con su modo lento 🐢, y se escribe,
--     calificado igual que "escribir": misma normalización de mayúsculas,
--     signos y contracciones).
--   - Mantiene los 10 tipos actuales: elegir, escuchar, ordenar, escribir,
--     emparejar, comprension, decir, libre, rapido, dibujo.
-- Ejecutar ANTES de correr 015, 016, 017 y 018 (traen 30 ejercicios 'dictado').
-- Pega TODO este archivo en Supabase → SQL Editor → Run.
-- Se puede correr varias veces sin dañar nada.
-- =====================================================================

alter table ejercicios drop constraint if exists ejercicios_tipo_check;
alter table ejercicios add constraint ejercicios_tipo_check
  check (tipo in ('elegir','escuchar','ordenar','escribir','emparejar','comprension','decir','libre','rapido','dibujo','dictado'));
