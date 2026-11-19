# Guía rápida: SCUCIN como aplicación instalable

## A. En Windows (prueba local)
1. Descomprime el ZIP.
2. Copia la carpeta `scucin` a `C:\xampp\htdocs\scucin`.
3. Inicia Apache y MySQL desde XAMPP.
4. Importa `sql/01_estructura.sql` y después `sql/02_datos_ficticios.sql` en phpMyAdmin si aún no lo hiciste.
5. Revisa `config/conexion.php` y confirma la conexión local.
6. Abre `http://localhost/scucin/` en Chrome o Edge.
7. Inicia sesión. Si aparece el icono de instalación, selecciónalo; si no, abre el menú y elige **Instalar SCUCIN**.

## B. En GitHub
1. Crea un repositorio (recomendado: **Private** mientras sea un proyecto académico en desarrollo).
2. Sube el contenido de la carpeta `scucin`, evitando crear una carpeta duplicada `scucin/scucin`.
3. Incluye `.gitignore`.
4. Nunca subas datos reales, contraseñas ni respaldos con información personal.
5. GitHub versiona y distribuye el código; no ejecuta por sí solo PHP ni MySQL.

## C. En celular o fuera de tu computadora
Despliega el proyecto en un servidor con PHP 8.x, MySQL/MariaDB y HTTPS. Después abre la URL en el celular y elige **Instalar aplicación** (Android/Chrome) o **Agregar a pantalla de inicio** (iPhone/Safari).

## Límites
Esta entrega es una PWA, no un APK ni un EXE. El login y los datos requieren conexión al servidor. No se guardan páginas ni respuestas de la base de datos en caché. No utilizar con pacientes reales sin auditoría y validación institucional.
