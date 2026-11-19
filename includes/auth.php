<?php
require_once __DIR__.'/funciones.php';
if (session_status()===PHP_SESSION_NONE) session_start();
if (empty($_SESSION['id_usuario'])) { flash('error','Inicia sesión para continuar.'); redirigir('/scucin/login.php'); }
if (!empty($_SESSION['ultima_actividad']) && time()-$_SESSION['ultima_actividad']>900) { session_unset();session_destroy();header('Location: /scucin/login.php?expirada=1');exit; }
$_SESSION['ultima_actividad']=time();
function exigir_roles(array $roles): void { if (!in_array($_SESSION['rol'] ?? '',$roles,true)) { http_response_code(403); echo '<h1>Acceso no autorizado</h1>'; exit; } }
