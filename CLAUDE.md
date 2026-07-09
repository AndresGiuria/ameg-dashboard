# AMEG Dashboard

## ⚠️ SUPABASE COMPARTIDO — LEER ANTES DE TOCAR LA BASE

El proyecto de Supabase `vcsclfosmtrgfcgaqiqu` ("AMEG - DASHBOARD") es
**compartido por 3 apps distintas**. Una tabla que esta app no usa NO es una
tabla muerta — es de otra app.

| App | Repo local | Tablas |
|---|---|---|
| **ameg-dashboard** (esta) | `01proyectosia/ameg-dashboard/ameg-dashboard` | `semanas`, `dias`, `dias_productos`, `inventario_diario`, `app_config` |
| tesoreria-app | `01proyectosia/tesoreria-app` | `facturas` + bucket Storage `facturas` |
| ventas-delivery | `01proyectosia/ventas - todas las sucursales/ventas-delivery` | `ventas_delivery`, `costos_insumos`, `costos_labor`, `costos_no_perecibles`, `costos_renta`, `productos_mix`, `upload_log` |

**Reglas:**
- NUNCA generar `DROP TABLE` / `ALTER TABLE` / `TRUNCATE` sobre tablas que no
  estén en la fila de esta app, ni sugerir al usuario correrlos.
- Antes de cualquier DDL destructivo, verificar contra las 3 apps.
- Incidente real: el 2026-07-09 una migración de ventas-delivery borró la
  tabla `facturas` de producción de tesoreria-app (~1900 facturas) porque
  desde aquel repo parecía "no usada".
