-- =========================================
-- Creaci�n y uso de base de datos.
-- =========================================

USE SkyNurce;

-- =========================================
-- Tipos de datos personalizados (reutilizables)
-- =========================================

CREATE TYPE descripcion FROM VARCHAR (1000);
CREATE TYPE G_fecha FROM DATETIME;
CREATE TYPE G_edad FROM INT NOT NULL;
CREATE TYPE G_nombre FROM VARCHAR(100);
CREATE TYPE G_email FROM VARCHAR(255);
CREATE TYPE G_password FROM VARCHAR(255);
CREATE TYPE G_texto FROM TEXT;
CREATE TYPE G_id FROM INT NOT NULL;
CREATE TYPE G_telefono FROM VARCHAR(20);
CREATE TYPE G_direccion FROM VARCHAR(255);
CREATE TYPE G_estatus FROM BIT;
CREATE TYPE G_hora FROM TIME;
CREATE TYPE G_duracion FROM INT;
CREATE TYPE G_ruta FROM VARCHAR(255);
CREATE TYPE G_observaciones FROM VARCHAR(1000);
CREATE TYPE G_ON_OFF FROM BIT;

