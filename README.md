# API EduGo

Backend de **EduGo**, una aplicación de transporte compartido para estudiantes universitarios: los conductores publican viajes con origen, destino, hora y precio, y los pasajeros ven las solicitudes disponibles de conductores activos. La API maneja el registro de pasajeros y conductores (con su licencia y vehículo) y la ubicación en tiempo real del conductor.

> Proyecto académico — UAGRM (2023).

## Funcionalidades

- Registro e inicio de sesión de **pasajeros** y **conductores** (con foto de perfil).
- Registro del **brevet** (licencia de conducir) y del **vehículo** del conductor.
- Actualización de la **posición GPS** (latitud / longitud) del conductor.
- Activar / desactivar la disponibilidad del conductor.
- Publicación de **solicitudes de viaje** (origen, destino, hora, monto).
- Listado de viajes disponibles con datos del conductor y del vehículo.

## Tecnologías

- Node.js + Express (ES Modules)
- PostgreSQL (`pg`)
- bcryptjs (hash de contraseñas)
- Multer (subida de imágenes)

## Estructura

```
src/
├── index.js                 # Arranque del servidor
├── config.js
├── db.js                    # Conexión a PostgreSQL
├── routes/Usuario.js        # Endpoints
├── controllers/Usuario.c.js # Lógica de negocio
├── lib/helpers.js           # Cifrado de contraseñas
└── public/images/           # Fotos subidas
```

## Requisitos

- Node.js 18 o superior
- PostgreSQL 12 o superior

## Instalación

```bash
npm install
```

### Configuración

Copia el archivo de ejemplo y completa los datos de conexión a PostgreSQL:

```bash
cp .env.example .env
```

| Variable | Descripción |
|---|---|
| `PORT` | Puerto del servidor (por defecto `5000`) |
| `DB_HOST`, `DB_PORT`, `DB_USER`, `DB_PASSWORD`, `DB_DATABASE` | Conexión a PostgreSQL |

El archivo `.env` está en `.gitignore`. **No lo subas al repositorio.**

### Base de datos

El script [`database/schema.sql`](database/schema.sql) crea todas las tablas y carga los datos iniciales. Necesitas PostgreSQL:

```bash
createdb -U postgres edugo
```
```bash
psql -U postgres -d edugo -f database/schema.sql
```

El script se puede volver a ejecutar: borra las tablas y las crea de nuevo, **así que también borra los datos**.

Incluye datos de prueba (contraseña `123456` para los dos):

- `pasajero1`: pasajero.
- `conductor1`: conductor con brevet, vehículo y un viaje publicado.

### Ejecutar

```bash
npm run dev     # desarrollo con nodemon
npm start
```

Puerto por defecto: `5000`.

## Endpoints

| Método | Ruta | Descripción |
|---|---|---|
| POST | `/IniciarSP` | Iniciar sesión como pasajero |
| POST | `/IniciarSC` | Iniciar sesión como conductor |
| POST | `/RegisP` | Registrar pasajero (con `foto`) |
| POST | `/RegisC` | Registrar conductor (con `foto`) |
| POST | `/RegisB` | Registrar brevet (con `foto`) |
| POST | `/RegisV` | Registrar vehículo (con `foto`) |
| POST | `/posicion/:usua/:ci` | Actualizar ubicación del conductor |
| POST | `/posicion/estado/:usua/:ci` | Cambiar estado (disponible / no disponible) |
| POST | `/AnadirS` (o `/AñadirS`) | Publicar solicitud de viaje |
| GET | `/solicitudes` | Listar viajes disponibles |
