-- ============================================================================
-- AMEG Dashboard — Tabla de horas por persona
-- Supabase → SQL Editor → New query → pegar todo → Run
--
-- Habilita el desglose de horas por persona/semana (antes solo se guardaba
-- el total diario en dias.horas). El importador de 7shifts sigue escribiendo
-- dias.horas (total, usado en Eficiencia kg/h) y AHORA además el detalle
-- por persona aquí.
--
-- Nota: el "drop" solo es seguro mientras la tabla esté vacía o recién creada.
-- Si ya guardaste datos aquí, NO re-ejecutes este script.
-- ============================================================================

drop table if exists horas_por_persona;

create table horas_por_persona (
  id bigint generated always as identity primary key,
  fecha date not null,
  nombre text not null,
  horas numeric not null,
  created_at timestamptz not null default now(),
  unique (fecha, nombre)
);

create index horas_por_persona_fecha_idx on horas_por_persona (fecha);

-- Sin login todavía: RLS apagado, igual que las demás tablas de esta app.
alter table horas_por_persona disable row level security;
