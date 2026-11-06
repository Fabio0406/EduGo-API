-- =====================================================================
-- EduGo API — esquema de la base de datos (PostgreSQL)
--
-- Uso:
--   createdb -U postgres edugo
--   psql -U postgres -d edugo -f database/schema.sql
--
-- El script se puede volver a ejecutar: borra las tablas y las crea de nuevo.
-- Reconstruido a partir de las consultas de src/controllers/Usuario.c.js.
-- =====================================================================

SET client_encoding = 'UTF8';   -- para que la ñ y los acentos se lean bien en Windows

CREATE EXTENSION IF NOT EXISTS pgcrypto;   -- solo para generar las contraseñas de prueba

DROP TABLE IF EXISTS solicitud, vehiculo, brevet, conductor, usuario CASCADE;

-- Pasajeros y conductores comparten esta tabla; los dos indicadores dicen qué es cada uno.
CREATE TABLE usuario (
    usua       VARCHAR(50)  PRIMARY KEY,       -- nombre de usuario
    registro   VARCHAR(30),                    -- número de registro universitario
    correo     VARCHAR(100),
    nombre     VARCHAR(100) NOT NULL,
    telefono   VARCHAR(20),
    contraseña VARCHAR(100) NOT NULL,          -- hash bcrypt
    foto       VARCHAR(255) DEFAULT 'default',
    pasajero   BOOLEAN NOT NULL DEFAULT FALSE,
    conductor  BOOLEAN NOT NULL DEFAULT FALSE
);

-- Datos del conductor. "ci" es el número que se envía al registrar el brevet.
CREATE TABLE conductor (
    ci       VARCHAR(30) PRIMARY KEY,
    usua     VARCHAR(50) NOT NULL REFERENCES usuario(usua) ON UPDATE CASCADE ON DELETE CASCADE,
    longitud DOUBLE PRECISION,
    latitud  DOUBLE PRECISION,
    estado   BOOLEAN NOT NULL DEFAULT FALSE     -- TRUE = disponible para viajes
);

-- Licencia de conducir. "numero" es el mismo valor que conductor.ci.
CREATE TABLE brevet (
    numero    VARCHAR(50) PRIMARY KEY,
    fecha_e   DATE,                            -- fecha de emisión
    fecha_v   DATE,                            -- fecha de vencimiento
    categoria VARCHAR(10),
    foto      VARCHAR(255)
);

CREATE TABLE vehiculo (
    placa        VARCHAR(20) PRIMARY KEY,
    modelo       VARCHAR(50),
    año          INTEGER,
    capacidad    INTEGER,
    foto         VARCHAR(255),
    extra        TEXT,
    ci_conductor VARCHAR(30) NOT NULL REFERENCES conductor(ci) ON UPDATE CASCADE ON DELETE CASCADE
);

-- Viajes que publica un conductor
CREATE TABLE solicitud (
    id               SERIAL PRIMARY KEY,
    longitud_origen  DOUBLE PRECISION NOT NULL,
    latitud_origen   DOUBLE PRECISION NOT NULL,
    longitud_destino DOUBLE PRECISION NOT NULL,
    latitud_destino  DOUBLE PRECISION NOT NULL,
    hora             VARCHAR(20),
    monto            NUMERIC(10,2),
    conductor        VARCHAR(30) NOT NULL REFERENCES conductor(ci) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE INDEX idx_conductor_usua     ON conductor(usua);
CREATE INDEX idx_solicitud_conductor ON solicitud(conductor);

-- ---------------------------------------------------------------------
-- Datos de prueba (contraseña de ambos: 123456). Bórralos en producción.
-- ---------------------------------------------------------------------
INSERT INTO usuario (usua, registro, correo, nombre, telefono, contraseña, pasajero, conductor) VALUES
    ('pasajero1',  '220000001', 'pasajero1@example.com',  'Pasajero Demo',  '70000001', crypt('123456', gen_salt('bf', 10)), TRUE,  FALSE),
    ('conductor1', '220000002', 'conductor1@example.com', 'Conductor Demo', '70000002', crypt('123456', gen_salt('bf', 10)), FALSE, TRUE);

INSERT INTO conductor (ci, usua, longitud, latitud, estado) VALUES
    ('1234567', 'conductor1', -63.1821, -17.7833, TRUE);

INSERT INTO brevet (numero, fecha_e, fecha_v, categoria) VALUES
    ('1234567', '2023-01-01', '2028-01-01', 'B');

INSERT INTO vehiculo (placa, modelo, año, capacidad, extra, ci_conductor) VALUES
    ('1234ABC', 'Toyota Corolla', 2015, 4, 'Aire acondicionado', '1234567');

INSERT INTO solicitud (longitud_origen, latitud_origen, longitud_destino, latitud_destino, hora, monto, conductor) VALUES
    (-63.1821, -17.7833, -63.1950, -17.7760, '07:30', 10.00, '1234567');
