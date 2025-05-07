-- =========================================
-- Creaci�n y uso de base de datos.
-- =========================================

USE SkyNurce;

-- =========================================
-- Catalogos base
-- =========================================

CREATE TABLE Roles (
    ID INT PRIMARY KEY,
    nombre_rol VARCHAR(100) NOT NULL,
    descripcion descripcion
);

CREATE TABLE estadoCuenta (
    ID INT PRIMARY KEY IDENTITY (100,1), -- INICIAMOS LA SECUENCIA DEL INCREMENTO EN 100
    nombre_estado VARCHAR (100) NOT NULL
);

CREATE TABLE TipoSangre (
    ID TINYINT PRIMARY KEY IDENTITY (1,1),
	nombre VARCHAR (20) NOT NULL,
    tipo VARCHAR (10) UNIQUE
);

CREATE TABLE EstadoCita (
    ID INT PRIMARY KEY NOT NULL,
    nombre VARCHAR(100) NOT NULL
);

CREATE TABLE MetodoPago (
	ID INT PRIMARY KEY IDENTITY (1,1),-- INICIAMOS LA SECUENCIA DEL INCREMENTO EN 1
    nombre VARCHAR(100) NOT NULL
);

CREATE TABLE EstadoPago (
    ID INT PRIMARY KEY IDENTITY (200,1), -- INICIAMOS LA SECUENCIA DEL INCREMENTO EN 200
    nombre_estado VARCHAR(100) NOT NULL,
    descripcion TEXT
);

CREATE TABLE TipoNotificacion (
    ID INT PRIMARY KEY NOT NULL,
    nombre_tipo_notificacion VARCHAR(50) NOT NULL,
	prioridad VARCHAR (20) CHECK (prioridad IN ('Baja', 'Media', 'Alta', 'Critica'))
);

-- =========================================
-- Cat�logos base (Agregados durante el lapso)
-- =========================================

CREATE TABLE Genero (
	sexo CHAR (5) PRIMARY KEY NOT NULL,
	genero VARCHAR(30)
);

CREATE TABLE Especialidades( 
	abreviacion CHAR (10) PRIMARY KEY NOT NULL,
	especialidadVet VARCHAR (100) NOT NULL
	);

CREATE TABLE contactos_Emergencia(
	ID INT PRIMARY KEY IDENTITY (1,1),
	nombre G_nombre,
	telefono G_telefono,
	direccion G_direccion,
	relacion VARCHAR (50)
);

CREATE TABLE Razas (
	ID G_id PRIMARY KEY IDENTITY (1,1),
	nombre G_nombre UNIQUE NOT NULL,
	especie VARCHAR (10) CHECK (especie IN ('Perro','Gato')),
	descripcion descripcion
);

CREATE TABLE TipoPregunta(
	ID INT PRIMARY KEY IDENTITY (1,1),
	nombre G_nombre NOT NULL UNIQUE
);

CREATE TABLE TipoMedicion (
    ID CHAR (10) PRIMARY KEY,
	unidad_medidad VARCHAR(50),
	rango_minimo DECIMAL (10,2), -- INGRESA 10 DIGITOS / GENERA 2 DECIMALES (.00)
	rango_maximo DECIMAL (10,2),
    nombre G_nombre,
	es_editable G_ON_OFF,
	ultima_modificacion G_fecha DEFAULT GETDATE() 
);

CREATE TABLE Actividad (
    ID TINYINT PRIMARY KEY,  
    nivel VARCHAR(20) NOT NULL,  
    descripcion TEXT NOT NULL  
);

-- =========================================
-- Usuarios, Perfiles y Profesionales
-- =========================================

CREATE TABLE Usuarios (
    ID G_id PRIMARY KEY,
    rol_ID G_id NOT NULL,
    estadoCuenta_ID G_id NOT NULL,
    nombre G_nombre,
    apellidos G_nombre,
    email G_email UNIQUE,
    contraseña G_password,
    fecha_creacion G_fecha DEFAULT GETDATE(),
    fecha_actualizacion G_fecha,
    FOREIGN KEY (rol_ID) REFERENCES Roles(ID),
    FOREIGN KEY (estadoCuenta_ID) REFERENCES estadoCuenta(ID)
);

CREATE TABLE Perfiles (
    ID G_id PRIMARY KEY,
    usuario_ID G_id NOT NULL,
    genero_ID CHAR(5) NOT NULL,
    telefono G_telefono,
    direccion G_direccion,
    fecha_nacimiento G_fecha,
    fotografia G_ruta,
    otros_datos descripcion,
    FOREIGN KEY (usuario_ID) REFERENCES Usuarios(ID) ON DELETE CASCADE,
	FOREIGN KEY (genero_ID) REFERENCES Genero(sexo)
);

CREATE TABLE Enfermeros (
    ID G_id PRIMARY KEY IDENTITY (1,1) NOT NULL,
    usuario_ID G_id NOT NULL,
    especialidad_ID CHAR (10) NOT NULL,
    numero_colegiado VARCHAR (100) NOT NULL,
    años_experiencia INT NOT NULL,
    turno_disponible G_ON_OFF NOT NULL, -- Si esta o no en trabajo (0-1)
    genero_ID CHAR (5),
    otros_datos descripcion,
    estatus G_estatus,
    FOREIGN KEY (usuario_ID) REFERENCES Usuarios(ID) ON DELETE CASCADE,
	FOREIGN KEY (especialidad_ID)REFERENCES Especialidades (abreviacion),
	FOREIGN KEY (genero_ID) REFERENCES Genero(sexo)
);

-- =========================================
-- Pacientes y Salud
-- =========================================

CREATE TABLE Pacientes (
    ID G_id PRIMARY KEY,
    usuario_ID G_id NOT NULL,	--@
    contacto_Emergencia G_id,	--@
    tipoSangre_ID TINYINT,		--@
    nombre_mascota G_nombre,
    raza_ID G_id,
    edad G_edad,
    color VARCHAR (100),
    fecha_registro G_fecha DEFAULT GETDATE(),
    estatus G_estatus,
    NSS VARCHAR(50) NOT NULL,
    alergias G_texto,
    padecimientos_cronicos G_texto,
    otros_datos_medicos G_texto,
    FOREIGN KEY (usuario_ID) REFERENCES Usuarios(ID) ON DELETE CASCADE,
	FOREIGN KEY (contacto_Emergencia) REFERENCES contactos_Emergencia (ID),
    FOREIGN KEY (tipoSangre_ID) REFERENCES tipoSangre(ID),
	FOREIGN KEY (raza_ID) REFERENCES Razas (ID)
);

CREATE TABLE MedicionesVitales (
    ID G_id PRIMARY KEY,
    paciente_ID G_id NOT NULL,
    medicion CHAR (10) NOT NULL,
    valor DECIMAL(5,2) NOT NULL,
    registro G_fecha DEFAULT GETDATE(),
    unidad VARCHAR(10),
    FOREIGN KEY (paciente_ID) REFERENCES Pacientes(ID) ON DELETE CASCADE,
	FOREIGN KEY (medicion) REFERENCES TipoMedicion (ID)
); -- IMP

CREATE TABLE ConfiguracionAlertas (
    ID G_id PRIMARY KEY,
    usuario_ID G_id NOT NULL,
    tipo_medicion CHAR (10) NOT NULL,
    nombre_alerta G_nombre,
    activa G_estatus DEFAULT 1,
    umbral_minimo DECIMAL(5,2),
    umbral_maximo DECIMAL(5,2),
    fecha_configuracion G_fecha DEFAULT GETDATE(),
	descripcion descripcion
    FOREIGN KEY (usuario_ID) REFERENCES Usuarios(ID) ON DELETE CASCADE,
	FOREIGN KEY (tipo_medicion) REFERENCES TipoMedicion (ID)
); --IMP

CREATE TABLE AlertasGeneradas (
    ID G_id PRIMARY KEY,
    paciente_ID G_id NOT NULL,
    tipo_medicion CHAR (10) NOT NULL,
    descripcion descripcion,
    valor_actual DECIMAL(5,2),
    fecha_alerta G_fecha DEFAULT GETDATE(),
    leida G_estatus DEFAULT 0,
    FOREIGN KEY (paciente_ID) REFERENCES Pacientes(ID) ON DELETE CASCADE,
	FOREIGN KEY (tipo_medicion) REFERENCES TipoMedicion (ID)
); --IMP

CREATE TABLE ActividadMascota (
    ID G_id PRIMARY KEY,
    paciente_ID G_id NOT NULL,
    evento TINYINT,
    intensidad DECIMAL(5,2),
    fecha_hora G_fecha DEFAULT GETDATE(),
    FOREIGN KEY (paciente_ID) REFERENCES Pacientes(ID) ON DELETE CASCADE,
	FOREIGN KEY (evento) REFERENCES Actividad (ID)
); --IMP

CREATE TABLE HistorialMedico (
    ID G_id PRIMARY KEY ,
    paciente_ID G_id NOT NULL,
    enfermero_ID G_id NOT NULL,
    fecha_registro G_fecha DEFAULT GETDATE(),
    diagnostico descripcion,
    tratamiento descripcion,
    observaciones G_observaciones,
    estatus G_estatus,
    FOREIGN KEY (paciente_ID) REFERENCES Pacientes(ID),
    FOREIGN KEY (enfermero_ID) REFERENCES Enfermeros(ID)
);

CREATE TABLE RecetasMedicas (
    ID G_id PRIMARY KEY,
    paciente_ID G_id NOT NULL,
    enfermero_ID G_id NOT NULL,
    fecha_receta G_fecha DEFAULT GETDATE(),
    diagnostico descripcion,
    tratamiento descripcion,
    medicamentos descripcion,
    estatus G_estatus,
    FOREIGN KEY (paciente_ID) REFERENCES Pacientes(ID),
    FOREIGN KEY (enfermero_ID) REFERENCES Enfermeros(ID)
);

-- =========================================
-- Formularios y Respuestas
-- =========================================

CREATE TABLE Formularios (
    ID G_id PRIMARY KEY,
    usuario_ID G_id NOT NULL,
    titulo_formulario VARCHAR (100),
    descripcion_formulario descripcion,
    fecha_creacion G_fecha DEFAULT GETDATE(),
    fecha_actualizacion G_fecha,
    estado G_estatus,
    FOREIGN KEY (usuario_ID) REFERENCES Usuarios(ID) ON DELETE CASCADE
);

CREATE TABLE PreguntasFormulario (
    ID INT PRIMARY KEY IDENTITY(1,1),
    formulario_ID INT NOT NULL,
    tipo_pregunta INT NOT NULL,
    texto_pregunta TEXT NOT NULL,
    orden INT NOT NULL CHECK (orden > 0),
    FOREIGN KEY (formulario_ID) REFERENCES Formularios(ID) ON DELETE CASCADE,
    FOREIGN KEY (tipo_pregunta) REFERENCES TipoPregunta(ID)
);

-- Respuesta del formulario (TENDRE PROBLEMAS ACA!!!!!!!! PERO ESTA ARREGLADO... CREO)
CREATE TABLE RespuestasFormulario (
    ID INT PRIMARY KEY IDENTITY(1,1),
    pregunta_ID INT NOT NULL,
    usuario_ID INT NOT NULL,
    valor_respuesta TEXT NOT NULL,
    fecha_respuesta DATETIME DEFAULT GETDATE(),
	FOREIGN KEY (pregunta_ID) REFERENCES PreguntasFormulario(ID) ON DELETE CASCADE,
	FOREIGN KEY (usuario_ID) REFERENCES Usuarios(ID) ON DELETE NO ACTION
);

-- =========================================
-- Citas y Servicios
-- =========================================

CREATE TABLE Citas (
    ID G_id PRIMARY KEY,
    enfermero_ID G_id NOT NULL,
    paciente_ID G_id NOT NULL,
    fecha_hora_inicio G_fecha,
    fecha_hora_fin G_fecha,
    estado G_id NOT NULL,
    observaciones G_observaciones,
    ubicacion G_direccion,
    estatus G_estatus,
    FOREIGN KEY (enfermero_ID ) REFERENCES Enfermeros(ID),
    FOREIGN KEY (paciente_ID) REFERENCES Pacientes(ID) ON DELETE CASCADE,
    FOREIGN KEY (estado) REFERENCES EstadoCita(ID)
);

CREATE TABLE Servicios (
    ID G_id PRIMARY KEY,
    nombre G_nombre,
    descripcion descripcion,
    costo_estandar MONEY,
    duracion_estimada G_duracion
);

CREATE TABLE ServicioCita (
    ID G_id PRIMARY KEY,
    cita_ID G_id NOT NULL,
    servicio_ID G_id NOT NULL,
    cantidad INT,
    FOREIGN KEY (cita_ID) REFERENCES Citas(ID) ON DELETE CASCADE
);

-- =========================================
-- Pagos
-- =========================================

CREATE TABLE Pagos (
    ID G_id PRIMARY KEY,
    cita_ID G_id NOT NULL,
    monto MONEY,
    fecha_pago G_fecha DEFAULT GETDATE(),
    id_estado_pago G_id NOT NULL,
    id_metodo_pago G_id NOT NULL,
    id_estado_cuenta G_id NOT NULL,
    FOREIGN KEY (cita_ID) REFERENCES Citas(ID) ON DELETE CASCADE,
    FOREIGN KEY (id_estado_pago) REFERENCES EstadoPago(ID),
    FOREIGN KEY (id_metodo_pago) REFERENCES MetodoPago(ID),
    FOREIGN KEY (id_estado_cuenta) REFERENCES EstadoCuenta(ID)
);

-- =========================================
-- Registros y comentarios
-- =========================================

CREATE TABLE Notificaciones (
    ID G_id PRIMARY KEY,
    usuario_ID G_id NOT NULL,
    mensaje descripcion,
    fecha_creacion G_fecha DEFAULT GETDATE(),
    leido G_estatus,
    tipo G_id NOT NULL,
    FOREIGN KEY (usuario_ID) REFERENCES Usuarios(ID) ON DELETE CASCADE,
    FOREIGN KEY (tipo) REFERENCES TipoNotificacion(ID)
);

CREATE TABLE Comentarios (
    ID G_id PRIMARY KEY,
    usuario_ID G_id NOT NULL,
    enfermero_ID G_id NOT NULL,
    texto_comentario descripcion,
    calificacion INT,
    fecha_comentario G_fecha DEFAULT GETDATE(),
    FOREIGN KEY (usuario_ID) REFERENCES Usuarios(ID),
    FOREIGN KEY (enfermero_ID) REFERENCES Enfermeros(ID)
);

CREATE TABLE RegistroActividad (
    ID G_id PRIMARY KEY IDENTITY (1,1),
    usuario_ID G_id NOT NULL,
    accion VARCHAR (150),
    tabla_afectada VARCHAR (150),
    id_registro_afectado G_id,
    fecha_accion G_fecha DEFAULT GETDATE(),
    detalles descripcion,
    FOREIGN KEY (usuario_ID) REFERENCES Usuarios(ID) ON DELETE CASCADE
);

-- =========================================
-- SECCION DE INSERCCIONES EN DONDE ESTA WEA SE PONE SERIA
-- =========================================

-- Grupos sangu�neos de perros (DEA). CORREGIDO
INSERT INTO tipoSangre (tipo, nombre) VALUES
('DEA 1.1+', 'PERRO'), ('DEA 1.1-', 'PERRO'), ('DEA 1.2', 'PERRO'),
('DEA 3', 'PERRO'), ('DEA 4', 'PERRO'), ('DEA 5', 'PERRO'),
('DEA 6', 'PERRO'), ('DEA 7', 'PERRO'), ('DEA 8', 'PERRO');

-- Grupos sangu�neos de gatos. CORREGIDO
INSERT INTO tipoSangre (tipo, nombre) VALUES
('A', 'GATO'), ('B', 'GATO'), ('AB', 'GATO');

/*-- ARRUINE ESA PARTE ASI QUE TUVE QUE ACTUALIZAR LA TABLA
ALTER TABLE tipoSangre
ALTER COLUMN nombre VARCHAR(20);

-- TUVE QUE CAMBIAR UNA FORMA MAS COHERENTE PARA LA MASCOTA DE '10100' a 'PERRO'
UPDATE TipoSangre
SET nombre = 'PERRO'
WHERE nombre = CAST(10100 AS VARCHAR);

-- TUVE QUE CAMBIAR UNA FORMA MAS COHERENTE PARA LA MASCOTA DE '10200' a 'GATO'
UPDATE TipoSangre
SET nombre = 'GATO'
WHERE nombre = CAST(10200 AS VARCHAR);

SELECT * FROM tipoSangre
*/

INSERT INTO EstadoCuenta (nombre_estado) VALUES
('Pendiente'),
('Pagado'),
('Vencido'),
('En revision'),
('Cancelado'),
('Reembolsado'),
('Parcialmente pagado'),
('Bloqueado'),
('Autorizado'),
('Rechazado');

-- Estados de pago
INSERT INTO EstadoPago (nombre_estado, descripcion) VALUES
('Pendiente', 'El pago aun no se ha realizado'),
('Completado', 'El pago se ha realizado con exito'),
('Fallido', 'Hubo un problema con el procesamiento del pago'),
('Cancelado', 'El pago ha sido cancelado por el usuario o el sistema'),
('Reembolsado', 'El pago ha sido devuelto al cliente'),
('En disputa', 'El pago esta siendo investigado debido a un reclamo'),
('Parcialmente pagado', 'El pago ha sido efectuado parcialmente');

-- Metodos de pago
INSERT INTO MetodoPago (nombre) VALUES
('Tarjeta de credito'),
('Tarjeta de debito'),
('Transferencia bancaria'),
('PayPal'),
('Efectivo'),
('Cheque'),
('Pago movil');

-- Roles que puede tener cada usuaario
INSERT INTO Roles (ID, nombre_rol, descripcion) VALUES
(1, 'Administrador', 'Acceso total al sistema'),
(2, 'Medico', 'Puede consultar y modificar expedientes medicos'),
(3, 'Recepcionista', 'Gestiona citas y registros de pacientes'),
(4, 'Paciente', 'Accede a su historial y citas medicas'),
(5, 'Invitado', 'Acceso limitado para exploracion');

-- Estado de la cita en cuento esta aplicada
INSERT INTO EstadoCita (ID, nombre) VALUES
(1, 'Pendiente'),
(2, 'Confirmada'),
(3, 'Cancelada'),
(4, 'Reprogramada'),
(5, 'Completada'),
(6, 'No asistio');

-- Notificaciones del dispositivo
INSERT INTO TipoNotificacion (ID, nombre_tipo_notificacion, prioridad) VALUES
(1, 'Recordatorio de cita','Media'),
(2, 'Resultado de examen','Alta'),
(3, 'Aviso de pago','Media'),
(4, 'Promociones y novedades','Baja'),
(5, 'Alerta medica','Critica'),
(6, 'Actualizacion de expediente','Media');

-- Genero de manera general
INSERT INTO Genero (sexo, genero) VALUES
('MAS.', 'Masculino'),
('FEM.', 'Femenino');

-- Especialidad del jefe de veterinaria
INSERT INTO Especialidades (abreviacion, especialidadVet) VALUES
('CIR', 'Cirugia'),
('DER', 'Dermatologia'),
('ONC', 'Oncologia'),
('CARD', 'Cardiologia'),
('NEU', 'Neurologia'),
('FISI', 'Fisioterapia'),
('ODON', 'Odontologia'),
('OFTA', 'Oftalmologia'),
('FARM', 'Farmacologia'),
('NUT', 'Nutriciin');

-- Las razas de animales que llega a tener generalmente un veterinario.
INSERT INTO Razas (nombre, especie, descripcion) VALUES
-- Razas de perros
('Labrador Retriever', 'Perro', 'Popular, sociable y propenso a obesidad.'),
('Golden Retriever', 'Perro', 'Inteligente y amigable, pero con riesgo de displasia de cadera.'),
('Bulldog Frances', 'Perro', 'Braquicefalo, problemas respiratorios.'),
('Chihuahua', 'Perro', 'Pequeno, problemas dentales y luxacion de rotula.'),
('Poodle', 'Perro', 'Hipoalergenico, predisposicion a problemas oculares.'),
('Pastor Aleman', 'Perro', 'Leal y protector, con riesgo de displasia de cadera.'),
('Beagle', 'Perro', 'Activo y amigable, propenso a obesidad.'),
('Shih Tzu', 'Perro', 'Pequeno y sociable, con problemas oculares.'),
('Boxer', 'Perro', 'Energetico, predisposicion a tumores y problemas cardiacos.'),
('Dachshund', 'Perro', 'Alargado, propenso a problemas en la columna vertebral.'),
('Border Collie', 'Perro', 'Inteligente y en�rgico, necesita estimulacion mental y fisica constante.'),
('Samoyedo', 'Perro', 'Pelaje espeso, predisposicion a displasia de cadera y problemas de piel.'),
('Doberman', 'Perro', 'Protector y leal, con riesgo de miocardiopatia dilatada.'),
('Corgi', 'Perro', 'Pequeno pero robusto, propenso a problemas de columna por su estructura corporal.'),
('Husky Siberiano', 'Perro', 'Resistente y activo, puede desarrollar problemas de vision como cataratas.'),
('Akita Inu', 'Perro', 'Independiente y fuerte, predisposicion a enfermedades autoinmunes.'),
('Pitbull Terrier', 'Perro', 'Potente musculatura, propenso a alergias y displasia de cadera.'),
('San Bernardo', 'Perro', 'Gran tamano, tendencia a torsion gastrica y displasia de cadera.'),
('Pomerania', 'Perro', 'Pequeno y vivaz, problemas dentales y de traquea colapsada.'),
('Gran Danes', 'Perro', 'Gigante noble, predisposicion a cardiomiopatia y torsion gastrica.'),

-- Razas de gatos
('Persa', 'Gato', 'Cara achatada, problemas respiratorios y oculares.'),
('Maine Coon', 'Gato', 'Grande, propenso a enfermedades cardiacas.'),
('Siames', 'Gato', 'Vocal y social, problemas dentales.'),
('Bengali', 'Gato', 'Activo, predisposicion a enfermedades renales.'),
('British Shorthair', 'Gato', 'Robusto, tendencia a obesidad.'),
('Scottish Fold', 'Gato', 'Orejas dobladas, propenso a problemas oseos.'),
('Ragdoll', 'Gato', 'Docil y afectuoso, con riesgo de enfermedades cardiacas.'),
('Angora Turco', 'Gato', 'Pelaje largo, predisposicion a sordera en gatos blancos.'),
('Azul Ruso', 'Gato', 'Reservado y elegante, con tendencia a problemas urinarios.'),
('Siberiano', 'Gato', 'Resistente y fuerte, propenso a alergias.'),
('Sphynx', 'Gato', 'Sin pelaje, predisposicion a problemas dermatologicos y cardiacos.'),
('Noruego del Bosque', 'Gato', 'Resistente al frio, predisposicion a enfermedad renal poliquistica.'),
('Burmes', 'Gato', 'Social y activo, propenso a hipocalemia familiar.'),
('Abisinio', 'Gato', 'Atletico y curioso, con tendencia a enfermedades periodontales.'),
('Devon Rex', 'Gato', 'Pelaje corto y rizado, predisposicion a displasia de rotula.'),
('Himalayo', 'Gato', 'Mezcla de Persa y Siames, predisposicion a enfermedades renales y oculares.'),
('Manx', 'Gato', 'Sin cola, propenso a anomalias de columna vertebral.'),
('Tonquines', 'Gato', 'Sociable y jugueton, con riesgo de problemas respiratorios.'),
('Somali', 'Gato', 'Variante de Abisinio, predisposicion a deficiencia de piruvato quinasa.'),
('Cornish Rex', 'Gato', 'Pelaje corto y rizado, con tendencia a problemas de piel.');

-- TIPOS DE PREGUNTAS (TENGO QUE QUITAR ACENTOS VOY A CHILLAR)
INSERT INTO TipoPregunta (nombre) VALUES
('Seleccion multiple'), ('Texto libre'), ('Si/No'), ('Fecha'), ('Numero');

-- MEDICIONES GENERALES DE VETERINARIOS (Esa MRD me hizo tardar mucho).
INSERT INTO TipoMedicion (ID, unidad_medidad, rango_minimo, rango_maximo, nombre, es_editable, ultima_modificacion)
VALUES 
	('TMP_C', 'OC', 37.5, 39.5, 'Temperatura Corporal Canina', 1, GETDATE()),
    ('TMP_F', 'OC', 38.0, 39.5, 'Temperatura Corporal Felina', 1, GETDATE()),
    ('FC_C', 'bpm', 60, 140, 'Frecuencia Cardiaca Canina', 1, GETDATE()),
    ('FC_F', 'bpm', 120, 220, 'Frecuencia Cardiaca Felina', 1, GETDATE()),
    ('FR_C', 'rpm', 10, 30, 'Frecuencia Respiratoria Canina', 1, GETDATE()),
    ('FR_F', 'rpm', 20, 40, 'Frecuencia Respiratoria Felina', 1, GETDATE()),
    ('GLU_C', 'mg/dL', 75, 125, 'Glucosa en Sangre Canina', 1, GETDATE()),
    ('GLU_F', 'mg/dL', 75, 150, 'Glucosa en Sangre Felina', 1, GETDATE()),
    ('PESO_C', 'kg', 1.0, 100.0, 'Peso Canino', 1, GETDATE()),
    ('PESO_F', 'kg', 1.0, 15.0, 'Peso Felino', 1, GETDATE()),
    ('HEM_C', 'g/dL', 12.0, 18.0, 'Nivel de Hemoglobina Canina', 1, GETDATE()),
    ('HEM_F', 'g/dL', 10.0, 16.0, 'Nivel de Hemoglobina Felina', 1, GETDATE()),
    ('TFG_C', 'mL/min/1.73m2', 1.5, 3.0, 'Tasa de Filtracion Glomerular Canina', 1, GETDATE()),
    ('TFG_F', 'mL/min/1.73m2', 1.0, 2.5, 'Tasa de Filtracion Glomerular Felina', 1, GETDATE()),
    ('NA_C', 'mEq/L', 140, 155, 'Concentracion de Sodio Canina', 1, GETDATE()),
    ('NA_F', 'mEq/L', 145, 160, 'Concentracion de Sodio Felina', 1, GETDATE()),
    ('K_C', 'mEq/L', 3.5, 5.5, 'Concentracion de Potasio Canina', 1, GETDATE()),
    ('K_F', 'mEq/L', 3.8, 5.8, 'Concentracion de Potasio Felina', 1, GETDATE()),
    ('CA_C', 'mg/dL', 8.5, 11.5, 'Concentracion de Calcio Canina', 1, GETDATE()),
    ('CA_F', 'mg/dL', 8.0, 11.0, 'Concentracion de Calcio Felina', 1, GETDATE()),
    ('ALB_C', 'g/dL', 2.5, 4.0, 'Albumina Canina', 1, GETDATE()),
    ('ALB_F', 'g/dL', 2.8, 4.2, 'Albumina Felina', 1, GETDATE()),
    ('CREA_C', 'mg/dL', 0.5, 1.5, 'Creatinina Canina', 1, GETDATE()),
    ('CREA_F', 'mg/dL', 0.6, 2.0, 'Creatinina Felina', 1, GETDATE()),
    ('BUN_C', 'mg/dL', 10, 30, 'Nitrogeno Ureico Canino (BUN)', 1, GETDATE()),
    ('BUN_F', 'mg/dL', 15, 35, 'Nitrogeno Ureico Felino (BUN)', 1, GETDATE()),
    ('ALT_C', 'U/L', 10, 100, 'Alanina Aminotransferasa Canina (ALT)', 1, GETDATE()),
    ('ALT_F', 'U/L', 15, 120, 'Alanina Aminotransferasa Felina (ALT)', 1, GETDATE()),
    ('TP_C', 'g/dL', 5.0, 7.5, 'Proteina Total Canina', 1, GETDATE()),
    ('TP_F', 'g/dL', 5.5, 8.0, 'Proteina Total Felina', 1, GETDATE()),
    ('PCV_C', '%', 37, 55, 'Volumen Globular Canino (PCV)', 1, GETDATE()),
    ('PCV_F', '%', 29, 45, 'Volumen Globular Felino (PCV)', 1, GETDATE()),
    ('RBC_C', 'mill/uL', 5.5, 8.5, 'Recuento de Globulos Rojos Canino', 1, GETDATE()),
    ('RBC_F', 'mill/uL', 6.0, 9.5, 'Recuento de Globulos Rojos Felino', 1, GETDATE());

	INSERT INTO contactos_Emergencia (nombre, telefono, direccion, relacion) VALUES
    ('Marco Aurelio Gil Carrillo', '7359876543', 'Calle Jacarandas 150 Col.Cuautlixco', 'Due�o'),
    ('Ana Ruiz Jimenez Campos', '7356543210', 'Av. Morelos 567 Col. Cuautlixco', 'Amigo'),
    ('Pedro Lopez de la Rocha', '7358765432', 'Boulevard del R�o 234 Col. A�o de juarez', 'Cuidador'),
    ('Isabela Flores Martinez', '7354321098', 'Calle Orqu�dea 78 Col. Girasoles', 'Vecino'),
    ('Jose Perez Barretos', '7352198765', 'Av. Insurgentes 312 Col. Reforma', 'Due�o');

INSERT INTO Servicios (ID, nombre, descripcion, costo_estandar, duracion_estimada) VALUES
    (1, 'Consulta General', 'Consulta veterinaria de rutina', 300.00, 30),
    (2, 'Vacunacion', 'Administracion de vacuna antirrabica', 150.00, 15),
    (3, 'Estetica', 'Bano y corte de pelo', 200.00, 45),
    (4, 'Desparasitacion', 'Administracion de antiparasitarios internos y externos', 250.00, 20),
    (5, 'Consulta Especializada', 'Evaluacion medica por especialista', 500.00, 40),
    (6, 'Rayos X', 'Estudio radiografico para diagnostico', 800.00, 60),
    (7, 'Ultrasonido', 'Estudio de imagen por ultrasonido', 900.00, 45),
    (8, 'Cirugia menor', 'Procedimientos quirurgicos menores', 1200.00, 90),
    (9, 'Limpieza dental', 'Profilaxis y eliminacion de sarro', 700.00, 50),
    (10, 'Hospitalizacion', 'Estancia y cuidados postoperatorios', 1500.00, 24 * 60);

INSERT INTO Usuarios (ID, rol_ID, estadoCuenta_ID, nombre, apellidos, email, contraseña) VALUES
    (1, 1, 108, 'Admin', 'Sistema', 'admin@skyNurce.com', 'administrador'),
    (2, 2, 108, 'Juan Carlos', 'Vidal Perez', 'juan.perez@gmail.com', 'hashed_pw_1'),
    (3, 3, 108, 'Maria Antonieta', 'Lopez Villalba', 'maria.lopez@gmail.com', 'hashed_pw_2'),
    (4, 4, 108, 'Jose Carlos', 'Gomez Barreto', 'carlos.gomez@hotmail.com', 'hashed_pw_3'),
    (5, 2, 108, 'Roberto', 'Gusman Fernandez', 'roberto.fernandez@hotmail.com', 'hashed_pw_4'),
    (6, 3, 108, 'Sofia', 'Ramirez Herrera', 'sofia.ramirez@gmail.com', 'hashed_pw_5'),
    (7, 4, 108, 'Luis', 'Torres Sanchez', 'luis.torres@gmail.com', 'hashed_pw_6'),
    (8, 5, 108, 'Gabriela', 'Ortega de la Rosa', 'gabriela.ortega@hotmail.com', 'hashed_pw_7'),
    (9, 2, 108, 'Alejandro', 'Martinez Martinez', 'alejandro.martinez@gmail.com', 'hashed_pw_8'),
    (10, 1, 108, 'SuperAdmin', 'Master', 'superadmin@skyNurce.com', 'super_administrador'),
	(11, 2, 108, 'Arias', 'Hernandez', 'arias.hernandez@gmail.com', 'hashed_pw_11'), -- MEDICO
    (12, 2, 108, 'Ximena', 'Campo Maldonado', 'ximena.campo@hotmail.com', 'hashed_pw_12'), --MEDICO
    (13, 2, 108, 'Andrea', 'Gomez Suarez', 'andrea.gomez@gmail.com', 'hashed_pw_13'), --MEDICO
    (14, 2, 108, 'Leonardo Yael', 'Vidal Barrios', 'leo.vidal@skyNurce.com', 'hashed_pw_14'); --MEDICO

-- NMMS �Como que asi se ponen las fechas? Ya tengo sue�o LPT
INSERT INTO Perfiles (ID, usuario_ID, genero_ID, telefono, direccion, fecha_nacimiento, fotografia, otros_datos) VALUES
	(1, 1, 'MAS.', '7351878407', 'Direccion 55, Col.Cuautlixco', '20030417', NULL, 'Admin principal de la base de datos.');

INSERT INTO Enfermeros (usuario_ID, especialidad_ID, numero_colegiado, años_experiencia, turno_disponible, genero_ID, otros_datos, estatus) VALUES
    (2, 'CARD', 'COL-1023', 8, 1, 'MAS.', 'Especialista en cardiologia veterinaria', 1),
    (3, 'DER', 'COL-1098', 6, 1, 'FEM.', 'Experto en dermatologia para especies exoticas', 1),
    (4, 'NUT', 'COL-1056', 5, 1, 'MAS.', 'Nutricionista con enfoque en pequeños animales', 1);

-- ELIMINAR ESPECIE (TENGO QUE TENER CUIDADO CON ESTA TABLA)
INSERT INTO Pacientes (ID, usuario_ID, contacto_Emergencia, tipoSangre_ID, nombre_mascota, raza_ID, edad, color, estatus, NSS, alergias, padecimientos_cronicos, otros_datos_medicos) VALUES
    (1, 9, 3, 1, 'Fido', 1, 5, 'Marron', 1, 'NSS12345', 'Ninguna', 'Ninguna', 'Ninguna'), -- PERRO
    (2, 9, 3, 2, 'Miau', 3, 3, 'Blanco', 1, 'NSS67890', 'Ninguna', 'Asma', 'Dieta especial'), -- PERRO
    (3, 8, 1, 3, 'Rocky', 2, 7, 'Negro', 1, 'NSS11223', 'Polen', 'Artritis', 'Terapia semanal'), -- PERRO
    (4, 9, 3, 1, 'Pelusa', 4, 4, 'Gris', 1, 'NSS44556', 'Ninguna', 'Diabetes', 'Medicacion diaria'), -- PERRO
    (5, 8, 1, 2, 'Max', 5, 6, 'Beige', 1, 'NSS78901', 'Picaduras', 'Epilepsia', 'Monitoreo mensual'), -- PERRO
    (6, 7, 2, 10, 'Luna', 11, 2, 'Anaranjado', 1, 'NSS23456', 'Ninguna', 'Enfermedad renal', 'Suplementos dieteticos'), -- GATO
    (7, 6, 5, 11, 'Toby', 17, 4, 'Dorado', 1, 'NSS56789', 'Alimentos procesados', 'Obesidad', 'Control de peso'), -- GATO
    (8, 6, 5, 11, 'Simba', 18, 3, 'Atigrado', 1, 'NSS90123', 'Ninguna', 'Hipotiroidismo', 'Chequeos regulares'), -- GATO
    (9, 6, 5, 11, 'Chester', 19, 1, 'Blanco y negro', 1, 'NSS34567', 'Polvo', 'Problemas digestivos', 'Dieta baja en grasas'), -- GATO
    (10, 5, 4, 12, 'Misty', 14, 3, 'Negro y blanco', 1, 'NSS67891', 'Mariscos', 'Hipertension', 'Control de presion arterial'); -- GATO

INSERT INTO MedicionesVitales (ID, paciente_ID, medicion, valor, unidad) VALUES
(1, 1, 'TMP_F', 37.5, '�C');

INSERT INTO ConfiguracionAlertas (ID, usuario_ID, tipo_medicion, nombre_alerta, activa, umbral_minimo, umbral_maximo, descripcion) VALUES
(1, 9, 'TMP_C', 'Alerta Temperatura', 0, 37.0, 39.0, 'Ingresaremos despues toda la descripccion de la alerta, brindar el contexto,');

INSERT INTO AlertasGeneradas (ID, paciente_ID, tipo_medicion, descripcion, valor_actual) VALUES
(1, 9, 'TMP_C', 'Temperatura por encima de umbral', 38.5);

INSERT INTO HistorialMedico (ID, paciente_ID, enfermero_ID, diagnostico, tratamiento, observaciones, estatus) VALUES
(1, 9, 3, 'Otitis externa', 'Antibiotico local por 7 dias', 'Paciente inquieto al tacto en oreja', 1);

INSERT INTO RecetasMedicas (ID, paciente_ID, enfermero_ID, diagnostico, tratamiento, medicamentos, estatus) VALUES
(1, 9, 3, 'Otitis externa', 'Limpieza auricular y aplicacion de gotas', 'Gotas Oticas ABC 5ml', 1);

INSERT INTO Formularios (ID, usuario_ID, titulo_formulario, descripcion_formulario, estado) VALUES -- ESTADO (BIEN, MAL)
(1, 9, 'Ingreso Canino Inicial', 'Formulario para primera visita del paciente canino', 1);

