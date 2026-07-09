-- ============================================================================
-- AMEG Dashboard — Seguridad (RLS) — PARA MÁS ADELANTE, cuando toque login
-- Ejecutar en: Supabase → SQL Editor → New query → pegar todo → Run
--
-- ⚠️ ORDEN CORRECTO (importante):
--   1. Supabase → Authentication → Users → "Add user" → crear el usuario
--      (ej. cocina@gustacos.com + contraseña; marcar "Auto Confirm User")
--   2. En index.html cambiar AUTH_REQUERIDA a true, subir a GitHub
--   3. Esperar el deploy de Render (~2 min) y probar que el login funciona
--   4. RECIÉN ENTONCES ejecutar este script — a partir de ahí, nadie sin
--      sesión puede leer ni escribir datos.
-- ============================================================================

-- ── 1. Tabla de configuración (metas y stock editables sin redeploy) ──
create table if not exists app_config (
  clave text primary key,
  valor jsonb not null,
  updated_at timestamptz not null default now()
);

-- Valores iniciales = los que hoy están hardcodeados en index.html
insert into app_config (clave, valor) values
  ('meta_kg_dia',  '600'),
  ('meta_kg_h',    '12'),
  ('meta_semanal', '{"cutoff":"2026-05-01","antes":3600,"desde":3900}')
on conflict (clave) do nothing;

-- ── 2. Activar RLS en todas las tablas ──
alter table semanas            enable row level security;
alter table dias               enable row level security;
alter table dias_productos     enable row level security;
alter table inventario_diario  enable row level security;
alter table app_config         enable row level security;

-- ── 3. Policies: acceso total SOLO para usuarios con sesión ──
-- (drop previo por si se re-ejecuta el script)
drop policy if exists "auth full access" on semanas;
drop policy if exists "auth full access" on dias;
drop policy if exists "auth full access" on dias_productos;
drop policy if exists "auth full access" on inventario_diario;
drop policy if exists "auth full access" on app_config;

create policy "auth full access" on semanas           for all to authenticated using (true) with check (true);
create policy "auth full access" on dias              for all to authenticated using (true) with check (true);
create policy "auth full access" on dias_productos    for all to authenticated using (true) with check (true);
create policy "auth full access" on inventario_diario for all to authenticated using (true) with check (true);
create policy "auth full access" on app_config        for all to authenticated using (true) with check (true);

-- ── 4. (Recomendado) Índices únicos: evitan duplicados por fecha/producto ──
-- Si este paso falla por duplicados existentes, ejecuta solo los pasos 1-3
-- (selecciónalos y Run) y avísale a Claude para limpiar los duplicados.
create unique index if not exists dias_productos_fecha_prod_uidx
  on dias_productos (fecha, producto);
create unique index if not exists inventario_fecha_prod_uidx
  on inventario_diario (fecha, producto);

-- ============================================================================
-- Para VERIFICAR que quedó protegido: abre la app en ventana de incógnito
-- sin iniciar sesión — no debe cargar ninguna semana ni dato.
-- ============================================================================
