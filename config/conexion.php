<?php
// Configuración local XAMPP. Ajusta estas variables si tu MySQL usa otra clave.
$host = '127.0.0.1';
$bd = 'scucin_db';
$usuario = 'root';
$contrasena = ''; // XAMPP suele usar root sin contraseña en instalaciones locales.
$charset = 'utf8mb4';
$dsn = "mysql:host=$host;dbname=$bd;charset=$charset";
$options = [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION, PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC, PDO::ATTR_EMULATE_PREPARES => false];
try { $pdo = new PDO($dsn, $usuario, $contrasena, $options); }
catch (PDOException $e) { error_log('[SCUCIN DB] '.$e->getMessage()); http_response_code(500); exit('No fue posible conectar con la base de datos. Revisa config/conexion.php y que MySQL esté iniciado.'); }
