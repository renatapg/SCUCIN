# Bitácora QA inicial

## Preparación
- [ ] Importar `01_estructura.sql` y `02_datos_ficticios.sql` sin errores.
- [ ] Confirmar 3 roles, 3 usuarios, 6 médicos, 20 madres, 20 neonatos y 25 espacios.
- [ ] Confirmar 20 espacios ocupados, 4 disponibles y 1 en mantenimiento.

## Casos funcionales
- [ ] Inicio de sesión correcto para cada rol.
- [ ] Cinco contraseñas incorrectas bloquean la cuenta durante cinco minutos.
- [ ] Captura registra madre/neonato y asigna un espacio libre.
- [ ] CURP, teléfono, expediente, semanas, peso, Apgar y fechas inválidas se rechazan.
- [ ] CURP/expediente duplicados se rechazan.
- [ ] Dos ingresos concurrentes no asignan el mismo espacio.
- [ ] Enfermería agrega un registro al historial sin sobrescribir el anterior.
- [ ] Egreso registra evento y libera el espacio.
- [ ] Los roles no autorizados reciben HTTP 403.
- [ ] Tablero muestra los KPI y los filtros.
- [ ] Reporte permite imprimir/guardar como PDF.

## Resultado
Registrar fecha, responsable, caso, resultado (PASS/FAIL) y observaciones antes de entregar el proyecto.
