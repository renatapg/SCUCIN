<?php
if (session_status() === PHP_SESSION_NONE) { session_start(); }
function h($v): string { return htmlspecialchars((string)($v ?? ''), ENT_QUOTES | ENT_SUBSTITUTE, 'UTF-8'); }
function csrf_token(): string { if (empty($_SESSION['csrf'])) $_SESSION['csrf']=bin2hex(random_bytes(32)); return $_SESSION['csrf']; }
function csrf_validar(): void { if ($_SERVER['REQUEST_METHOD']==='POST' && (!isset($_POST['csrf']) || !hash_equals($_SESSION['csrf'] ?? '', (string)$_POST['csrf']))) { http_response_code(419); exit('La sesión del formulario expiró. Regresa e inténtalo nuevamente.'); } }
function redirigir(string $url): never { header('Location: '.$url); exit; }
function flash(string $tipo,string $mensaje): void { $_SESSION['flash']=['tipo'=>$tipo,'mensaje'=>$mensaje]; }
function mostrar_flash(): void { if (!empty($_SESSION['flash'])) { $f=$_SESSION['flash']; echo '<div class="alerta '.h($f['tipo']).'">'.h($f['mensaje']).'</div>'; unset($_SESSION['flash']); } }
function registrar_bitacora(PDO $pdo,string $tabla,string $id,string $accion,?array $antes,?array $despues): void {
 $q=$pdo->prepare('INSERT INTO bitacora_cambios(id_usuario,tabla_afectada,id_registro,accion,valor_anterior,valor_nuevo) VALUES(?,?,?,?,?,?)');
 $q->execute([$_SESSION['id_usuario'] ?? 1,$tabla,$id,$accion,$antes?json_encode($antes,JSON_UNESCAPED_UNICODE):null,$despues?json_encode($despues,JSON_UNESCAPED_UNICODE):null]);
}
function validar_nombre(string $v): bool { return (bool)preg_match("/^[\\p{L} .'-]+$/u",trim($v)); }
function validar_curp(string $v): bool { return (bool)preg_match('/^[A-Z][AEIOU][A-Z]{2}[0-9]{6}[HM][A-Z]{2}[B-DF-HJ-NP-TV-Z]{3}[A-Z0-9][0-9]$/',strtoupper(trim($v))); }
function validar_telefono(string $v): bool { return (bool)preg_match('/^[0-9]{10}$/',trim($v)); }
function validar_fecha_no_futura(string $v): bool { $t=strtotime($v); return $t!==false && $t<=time(); }
function ultimo_estado(PDO $pdo,int $id): ?array { $q=$pdo->prepare('SELECT * FROM estado_neonato WHERE id_neonato=? ORDER BY id_estado DESC LIMIT 1');$q->execute([$id]);return $q->fetch() ?: null; }
