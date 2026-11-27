-- =====================================================================
-- 020 · Dictado pasa a la pata "input"
--   - Los 30 ejercicios tipo 'dictado' (episodios 9-12) quedaron con
--     pata 'estudio'; se mueven a 'input' porque miden comprensión
--     auditiva, no la regla gramatical.
-- Se puede correr varias veces sin dañar nada (solo toca filas tipo='dictado').
-- Pega TODO este archivo en Supabase → SQL Editor → Run.
-- =====================================================================

update ejercicios set pata = 'input' where tipo = 'dictado' and pata = 'estudio';
