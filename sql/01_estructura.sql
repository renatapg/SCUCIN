-- SCUCIN | Estructura de base de datos | MySQL 8.0.16+ / MariaDB 10.6+
CREATE DATABASE IF NOT EXISTS scucin_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE scucin_db;
SET NAMES utf8mb4;

CREATE TABLE roles (
 id_rol INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 nombre_rol VARCHAR(80) NOT NULL UNIQUE,
 descripcion VARCHAR(255) NULL
) ENGINE=InnoDB;
CREATE TABLE usuarios (
 id_usuario INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 nombre_completo VARCHAR(150) NOT NULL,
 usuario VARCHAR(50) NOT NULL UNIQUE,
 password_hash VARCHAR(255) NOT NULL,
 id_rol INT UNSIGNED NOT NULL,
 activo TINYINT(1) NOT NULL DEFAULT 1,
 intentos_fallidos TINYINT UNSIGNED NOT NULL DEFAULT 0,
 bloqueado_hasta DATETIME NULL,
 ultimo_acceso DATETIME NULL,
 fecha_creacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
 CONSTRAINT fk_usuarios_rol FOREIGN KEY(id_rol) REFERENCES roles(id_rol) ON UPDATE CASCADE ON DELETE RESTRICT,
 CHECK(activo IN (0,1))
) ENGINE=InnoDB;
CREATE TABLE madres (
 id_madre INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 nombre VARCHAR(80) NOT NULL,
 apellido_paterno VARCHAR(60) NOT NULL,
 apellido_materno VARCHAR(60) NOT NULL,
 curp_madre CHAR(18) NOT NULL UNIQUE,
 edad TINYINT UNSIGNED NOT NULL,
 telefono CHAR(10) NOT NULL,
 domicilio VARCHAR(255) NULL,
 tipo_sangre_madre VARCHAR(5) NULL,
 antecedentes_importantes TEXT NULL,
 fecha_registro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
 CHECK(edad BETWEEN 10 AND 60), CHECK(telefono REGEXP '^[0-9]{10}$'),
 CHECK(curp_madre REGEXP '^[A-Z][AEIOU][A-Z]{2}[0-9]{6}[HM][A-Z]{2}[B-DF-HJ-NP-TV-Z]{3}[A-Z0-9][0-9]$')
) ENGINE=InnoDB;
CREATE TABLE medicos_neonatologos (
 id_medico INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 cedula_profesional VARCHAR(8) NOT NULL UNIQUE,
 nombre_completo VARCHAR(150) NOT NULL,
 especialidad ENUM('Neonatología','Pediatría') NOT NULL,
 turno ENUM('Matutino','Vespertino','Nocturno','Especial') NOT NULL,
 telefono CHAR(10) NULL,
 correo VARCHAR(120) NULL,
 activo TINYINT(1) NOT NULL DEFAULT 1,
 CHECK(cedula_profesional REGEXP '^[0-9]{7,8}$'), CHECK(telefono IS NULL OR telefono REGEXP '^[0-9]{10}$')
) ENGINE=InnoDB;
CREATE TABLE pacientes_neonatos (
 id_neonato INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 exp_neonato VARCHAR(20) NOT NULL UNIQUE,
 nombre_neonato VARCHAR(100) NOT NULL,
 id_madre INT UNSIGNED NOT NULL,
 fecha_hora_nacimiento DATETIME NOT NULL,
 sexo_neonato ENUM('Masculino','Femenino','Indeterminado') NOT NULL,
 metodo_gestacional ENUM('Capurro','Ballard') NOT NULL DEFAULT 'Ballard',
 semanas_gestacion TINYINT UNSIGNED NOT NULL,
 peso_nacer_gramos SMALLINT UNSIGNED NOT NULL,
 talla_cm DECIMAL(5,2) NULL,
 apgar_1min TINYINT UNSIGNED NOT NULL,
 apgar_5min TINYINT UNSIGNED NOT NULL,
 diagnostico_ingreso TEXT NOT NULL,
 alergias_conocidas TEXT NULL,
 fecha_registro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
 registrado_por INT UNSIGNED NOT NULL,
 CONSTRAINT fk_neonato_madre FOREIGN KEY(id_madre) REFERENCES madres(id_madre) ON UPDATE CASCADE ON DELETE RESTRICT,
 CONSTRAINT fk_neonato_usuario FOREIGN KEY(registrado_por) REFERENCES usuarios(id_usuario) ON UPDATE CASCADE ON DELETE RESTRICT,
 CHECK(exp_neonato REGEXP '^NEO-[0-9]{4}-[0-9]{3,}$'), CHECK(semanas_gestacion BETWEEN 22 AND 45),
 CHECK(peso_nacer_gramos BETWEEN 400 AND 6000), CHECK(apgar_1min BETWEEN 0 AND 10), CHECK(apgar_5min BETWEEN 0 AND 10)
) ENGINE=InnoDB;
CREATE TABLE espacios_neonatales (
 id_espacio INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 numero_espacio VARCHAR(15) NOT NULL UNIQUE,
 tipo_equipo ENUM('Incubadora Cerrada','Incubadora de Traslado','Cuna Radiante','Cuna Térmica') NOT NULL,
 zona_ucin ENUM('Área de Cuidados Intensivos','Área de Cuidados Intermedios','Crecimiento y Aislamiento') NOT NULL,
 estado_espacio ENUM('Disponible','Ocupada','En Mantenimiento/Limpieza') NOT NULL DEFAULT 'Disponible',
 id_neonato INT UNSIGNED NULL,
 id_medico INT UNSIGNED NULL,
 fecha_ingreso_ucin DATETIME NULL,
 observaciones_equipo VARCHAR(255) NULL,
 activo TINYINT(1) NOT NULL DEFAULT 1,
 UNIQUE KEY uq_espacio_neonato(id_neonato),
 CONSTRAINT fk_espacio_neonato FOREIGN KEY(id_neonato) REFERENCES pacientes_neonatos(id_neonato) ON UPDATE CASCADE ON DELETE RESTRICT,
 CONSTRAINT fk_espacio_medico FOREIGN KEY(id_medico) REFERENCES medicos_neonatologos(id_medico) ON UPDATE CASCADE ON DELETE SET NULL,
 CHECK((estado_espacio='Ocupada' AND id_neonato IS NOT NULL AND fecha_ingreso_ucin IS NOT NULL) OR (estado_espacio IN ('Disponible','En Mantenimiento/Limpieza') AND id_neonato IS NULL AND fecha_ingreso_ucin IS NULL))
) ENGINE=InnoDB;
CREATE TABLE estado_neonato (
 id_estado BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 id_neonato INT UNSIGNED NOT NULL,
 id_espacio INT UNSIGNED NULL,
 estado_clinico ENUM('Estable','Delicado','Grave') NOT NULL,
 soporte_respiratorio ENUM('Sin ventilación mecánica','Con ventilación mecánica') NOT NULL DEFAULT 'Sin ventilación mecánica',
 alimentacion ENUM('Lactancia materna exclusiva','Otra alimentación') NOT NULL DEFAULT 'Otra alimentación',
 atencion_especial ENUM('Método madre-canguro','Sin método madre-canguro') NOT NULL DEFAULT 'Sin método madre-canguro',
 visitas ENUM('Horario habilitado','Horario no habilitado') NOT NULL DEFAULT 'Horario no habilitado',
 situacion_hospitalaria ENUM('Hospitalizado','Alta/Egreso') NOT NULL DEFAULT 'Hospitalizado',
 peso_actual_gramos SMALLINT UNSIGNED NOT NULL,
 estudios_proximos TEXT NULL,
 fecha_estudio_programado DATETIME NULL,
 observaciones_enfermeria_medica TEXT NULL,
 fecha_actualizacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
 actualizado_por INT UNSIGNED NOT NULL,
 CONSTRAINT fk_estado_neonato FOREIGN KEY(id_neonato) REFERENCES pacientes_neonatos(id_neonato) ON UPDATE CASCADE ON DELETE RESTRICT,
 CONSTRAINT fk_estado_espacio FOREIGN KEY(id_espacio) REFERENCES espacios_neonatales(id_espacio) ON UPDATE CASCADE ON DELETE SET NULL,
 CONSTRAINT fk_estado_usuario FOREIGN KEY(actualizado_por) REFERENCES usuarios(id_usuario) ON UPDATE CASCADE ON DELETE RESTRICT,
 CHECK(peso_actual_gramos BETWEEN 200 AND 8000), CHECK(fecha_estudio_programado IS NULL OR estudios_proximos IS NOT NULL)
) ENGINE=InnoDB;
CREATE INDEX idx_estado_neonato_fecha ON estado_neonato(id_neonato,fecha_actualizacion,id_estado);
CREATE TABLE historial_asignaciones (
 id_asignacion BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 id_neonato INT UNSIGNED NOT NULL,
 id_espacio_anterior INT UNSIGNED NULL,
 id_espacio_nuevo INT UNSIGNED NULL,
 evento ENUM('Ingreso','Cambio de espacio','Alta/Egreso') NOT NULL,
 fecha_hora DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
 id_usuario INT UNSIGNED NOT NULL,
 observaciones VARCHAR(255) NULL,
 FOREIGN KEY(id_neonato) REFERENCES pacientes_neonatos(id_neonato) ON UPDATE CASCADE ON DELETE RESTRICT,
 FOREIGN KEY(id_espacio_anterior) REFERENCES espacios_neonatales(id_espacio) ON UPDATE CASCADE ON DELETE SET NULL,
 FOREIGN KEY(id_espacio_nuevo) REFERENCES espacios_neonatales(id_espacio) ON UPDATE CASCADE ON DELETE SET NULL,
 FOREIGN KEY(id_usuario) REFERENCES usuarios(id_usuario) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;
CREATE TABLE bitacora_cambios (
 id_bitacora BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 id_usuario INT UNSIGNED NOT NULL,
 tabla_afectada VARCHAR(64) NOT NULL,
 id_registro VARCHAR(40) NOT NULL,
 accion ENUM('INSERT','UPDATE','ALTA','LOGIN_FALLIDO','ACCESO_NO_AUTORIZADO') NOT NULL,
 valor_anterior JSON NULL,
 valor_nuevo JSON NULL,
 fecha_hora DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
 FOREIGN KEY(id_usuario) REFERENCES usuarios(id_usuario) ON UPDATE CASCADE ON DELETE RESTRICT,
 INDEX idx_bitacora_fecha(fecha_hora), INDEX idx_bitacora_usuario(id_usuario)
) ENGINE=InnoDB;
CREATE OR REPLACE VIEW v_tablero_ucin AS
SELECT e.id_espacio,e.numero_espacio,e.tipo_equipo,e.zona_ucin,e.estado_espacio,e.activo,
 n.id_neonato,n.nombre_neonato,n.exp_neonato,n.semanas_gestacion,n.peso_nacer_gramos,
 CONCAT_WS(' ',m.nombre,m.apellido_paterno,m.apellido_materno) AS nombre_madre,
 med.nombre_completo AS medico_tratante,e.fecha_ingreso_ucin,
 CASE WHEN e.fecha_ingreso_ucin IS NULL THEN NULL ELSE GREATEST(DATEDIFF(CURRENT_DATE,DATE(e.fecha_ingreso_ucin)),0) END AS dias_estancia,
 st.estado_clinico,st.soporte_respiratorio,st.alimentacion,st.atencion_especial,st.visitas,st.situacion_hospitalaria,
 st.peso_actual_gramos,st.estudios_proximos,st.fecha_estudio_programado
FROM espacios_neonatales e
LEFT JOIN pacientes_neonatos n ON n.id_neonato=e.id_neonato
LEFT JOIN madres m ON m.id_madre=n.id_madre
LEFT JOIN medicos_neonatologos med ON med.id_medico=e.id_medico
LEFT JOIN (SELECT s.* FROM estado_neonato s JOIN (SELECT id_neonato,MAX(id_estado) max_id FROM estado_neonato GROUP BY id_neonato) u ON u.max_id=s.id_estado) st ON st.id_neonato=e.id_neonato
WHERE e.activo=1;
