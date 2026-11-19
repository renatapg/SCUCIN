# SCUCIN — Sistema de Control de Cunas e Incubadoras UCIN

Aplicación académica de demostración para gestionar admisión neonatal, asignación de espacios, seguimiento de enfermería, ocupación y auditoría. **Todos los registros incluidos son ficticios. No utilizar para atención clínica real.**

## Requisitos
- XAMPP para Windows con Apache, PHP 8.x y MySQL/MariaDB activos.
- MySQL 8.0.16+ o MariaDB 10.6+ (soporte CHECK).
- Navegador actualizado.

## Instalación
1. Descomprime la carpeta `scucin` dentro de `C:\xampp\htdocs\`.
2. Abre XAMPP Control Panel e inicia Apache y MySQL.
3. Entra a `http://localhost/phpmyadmin`.
4. Importa primero `scucin/sql/01_estructura.sql` y después `scucin/sql/02_datos_ficticios.sql`.
5. Revisa `scucin/config/conexion.php`. Por defecto usa host `127.0.0.1`, base `scucin_db`, usuario `root` y contraseña vacía (configuración habitual de XAMPP local). Cambia usuario/contraseña si tu MySQL tiene otras credenciales.
6. Abre `http://localhost/scucin/`.

## Acceso de demostración
Los tres usuarios tienen la contraseña `Scucin2026!`:
- `admin_scucin` — Administrador del sistema.
- `captura_scucin` — Captura.
- `enfermeria_scucin` — Visualización y actualización.

Cambia estas credenciales antes de cualquier despliegue. Las contraseñas se guardan como hashes compatibles con `password_verify()`.

## Módulos incluidos
- Login, sesión de 15 minutos, bloqueo tras cinco intentos fallidos y roles.
- Admisión integrada de madre/neonato con validación PHP, consultas PDO y transacción.
- Enfermería: actualización histórica de estado, peso y egreso con liberación de espacio.
- Administración: consulta de usuarios, médicos, espacios y bitácora.
- Tablero UCIN con KPI, filtros de zona/equipo, tarjetas por espacio y consulta automática del endpoint JSON.
- Reporte imprimible desde navegador con opción «Guardar como PDF».

## PDF / FPDF
El reporte incluido funciona sin librerías externas: usa la función de impresión del navegador para guardar como PDF. **Esta versión no incluye el motor FPDF**; la carpeta `lib/fpdf/` queda preparada para incorporarlo si la evaluación exige específicamente ese motor. Por tanto, la impresión a PDF funciona desde el navegador, pero el requisito técnico de FPDF queda pendiente.

## Pruebas
Consulta `tests/QA.md`. Ejecuta las comprobaciones SQL indicadas en phpMyAdmin después de importar los dos scripts.

## Seguridad y límites
- PDO con excepciones y consultas preparadas en operaciones de datos.
- CSRF en formularios POST principales; escape HTML mediante `h()`/`htmlspecialchars()`.
- Validación del cliente y del servidor.
- No se incluyen integraciones con monitores, HL7/FHIR ni expediente clínico completo.
- Para un uso real se requiere revisión de seguridad, respaldo, HTTPS, gestión formal de credenciales, control de acceso reforzado y validación clínica institucional.


## Instalar SCUCIN como aplicación (PWA)

Esta carpeta incluye `manifest.webmanifest`, `service-worker.js`, `offline.html`, `assets/js/pwa.js` e iconos en `assets/img/app/`.

### Probar en Windows con XAMPP
1. Copia la carpeta `scucin` dentro de `C:\xampp\htdocs\`.
2. Inicia Apache y MySQL.
3. Abre `http://localhost/scucin/` con Chrome o Edge.
4. Inicia sesión y espera unos segundos.
5. Usa el icono **Instalar SCUCIN** de la barra de direcciones o el menú del navegador → **Instalar aplicación**.

`localhost` se considera un origen seguro para desarrollo. En un servidor público se requiere HTTPS.

### Instalar en celular
Primero publica el proyecto en un servidor con PHP + MySQL/MariaDB y HTTPS. Después abre la URL desde el navegador del celular. En Android usa **Instalar aplicación** o **Agregar a pantalla principal**; en iPhone, Safari → Compartir → **Agregar a pantalla de inicio**.

### Límites y seguridad
La PWA no es un APK Android ni un EXE de Windows. El sistema requiere conexión al servidor para iniciar sesión y manejar datos. El modo sin conexión solo muestra un aviso; no almacena páginas ni datos clínicos. GitHub guarda el código, pero GitHub Pages no ejecuta PHP ni ofrece MySQL. No publiques credenciales ni datos identificables. Este proyecto es académico y no debe utilizarse para atención clínica real sin auditoría y validación institucional.
