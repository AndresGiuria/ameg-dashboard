-- ============================================================================
-- AMEG Dashboard — Tabla de configuración (v2)
-- Supabase → SQL Editor → New query → pegar todo → Run
--
-- Habilita la pestaña ⚙️ Config de la app (metas y stock editables).
-- NO activa seguridad/login — eso queda para después (supabase_seguridad.sql).
--
-- Nota: el "drop" solo es seguro mientras la tabla esté vacía o recién creada.
-- Si ya guardaste configuración desde la app, NO re-ejecutes este script.
-- ============================================================================

drop table if exists app_config;

create table app_config (
  clave text primary key,
  valor jsonb not null,
  updated_at timestamptz not null default now()
);

-- La app aún no usa login: RLS debe quedar apagado (igual que las demás tablas).
-- El Table Editor de Supabase lo enciende por defecto; aquí lo apagamos explícito.
alter table app_config disable row level security;

-- Valores iniciales = los que hoy trae la app por defecto
insert into app_config (clave, valor) values
  ('meta_kg_dia',  '600'),
  ('meta_kg_h',    '12'),
  ('meta_semanal', '{"cutoff":"2026-05-01","antes":3600,"desde":3900}');
