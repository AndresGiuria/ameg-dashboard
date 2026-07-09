-- ============================================================================
-- AMEG Dashboard — Tabla de configuración (ejecutar UNA sola vez)
-- Supabase → SQL Editor → New query → pegar esto → Run
--
-- Habilita la pestaña ⚙️ Config de la app (metas y stock editables).
-- NO activa seguridad/login — eso queda para después (supabase_seguridad.sql).
-- ============================================================================

create table if not exists app_config (
  clave text primary key,
  valor jsonb not null,
  updated_at timestamptz not null default now()
);

-- Valores iniciales = los que hoy trae la app por defecto
insert into app_config (clave, valor) values
  ('meta_kg_dia',  '600'),
  ('meta_kg_h',    '12'),
  ('meta_semanal', '{"cutoff":"2026-05-01","antes":3600,"desde":3900}')
on conflict (clave) do nothing;
