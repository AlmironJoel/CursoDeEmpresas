# DB_Cursos — Plataforma de Capacitaciones para Empresas

Base de datos relacional para la gestión de cursos corporativos, desarrollada en **SQL Server** como Trabajo Práctico Integrador para la materia **Base de Datos II (UTN FRGP)**.

El sistema permite administrar empresas, usuarios, tipos de suscripción, cursos, archivos de estudio, evaluaciones, resultados, certificados e historial de bajas.

---

## 👥 Integrantes del Equipo
* **Almiron, Joel Brian** - Legajo N°: 32378
* **De Grazia, Mariel Alejandra** - Legajo N°: 25874
* **Corbacho, Juan Ignacio** - Legajo N°: 32634
* **Re, Uziel** - Legajo N°: 33080

---

## Esquema de Tablas y Restricciones

### 1. Roles
Define los perfiles de acceso en el sistema (ej. Administrador, Empresa, Alumno).
* `IDRol` (INT, PK, IDENTITY)
* `Nombre` (VARCHAR(50), UNIQUE, NOT NULL)
* `Descripcion` (VARCHAR(255), NULL)

### 2. TipoSuscripcion
Planes disponibles para los usuarios de la plataforma.
* `IDTipoSuscripcion` (INT, PK, IDENTITY)
* `nombre` (VARCHAR(50), UNIQUE, NOT NULL)
* `detalle` (VARCHAR(100), NULL)
* `duracion` (INT, DEFAULT 30, CHECK >= 0)
* `precio` (INT, CHECK >= 0)

### 3. Usuario
Usuarios registrados en la plataforma (incluye alumnos y empresas).
* `IDUsuario` (INT, PK, IDENTITY)
* `nombre` (VARCHAR(50), NOT NULL)
* `apellido` (VARCHAR(50), NOT NULL)
* `email` (VARCHAR(50), UNIQUE, NOT NULL)
* `contrasenia` (VARCHAR(50), CHECK LEN > 5)
* `fechaDeInscripcion` (DATE, DEFAULT GETDATE())
* `IDRol` (INT, FK -> Roles)

### 4. Suscripcion
Historial y estado de las suscripciones contratadas.
* `IDSuscripcion` (INT, PK, IDENTITY)
* `IDTipoSuscripcion` (INT, FK -> TipoSuscripcion)
* `IDUsuario` (INT, FK -> Usuario)
* `fechaDeInscripcion` (DATE, DEFAULT GETDATE())
* `fechaDeFinalizacion` (DATE, NOT NULL)
* `activa` (BIT, DEFAULT 1)

### 5. Curso
Cursos publicados por usuarios con perfil Empresa.
* `IDCurso` (INT, PK, IDENTITY)
* `IDUsuarioEmpresa` (INT, FK -> Usuario)
* `nombre` (VARCHAR(50), NOT NULL)
* `descripcion` (VARCHAR(250), NOT NULL)

### 6. TipoArchivo
Formatos soportados para el material didáctico (PDF, Video, etc.).
* `IDTipoArchivo` (INT, PK, IDENTITY)
* `nombre` (VARCHAR(50), UNIQUE, NOT NULL)

### 7. Archivo
Materiales de estudio pertenecientes a cada curso.
* `IDArchivo` (INT, PK, IDENTITY)
* `IDCurso` (INT, FK -> Curso)
* `nombre` (VARCHAR(50), NOT NULL)
* `IDTipoArchivo` (INT, FK -> TipoArchivo)
* `ruta` (VARCHAR(255), UNIQUE, NOT NULL)

### 8. ProgresoArchivo
Seguimiento del avance de un usuario sobre cada archivo de un curso.
* `IDUsuario` (INT, PK, FK -> Usuario)
* `IDArchivo` (INT, PK, FK -> Archivo)
* `completado` (BIT, DEFAULT 0)

### 9. Evaluacion
Exámenes o evaluaciones configuradas para cada curso.
* `IDEvaluacion` (INT, PK, IDENTITY)
* `IDCurso` (INT, FK -> Curso)
* `titulo` (VARCHAR(50))
* `PuntajeAprobacion` (INT, CHECK BETWEEN 0 AND 100)

### 10. ResultadoEvaluacion
Rendiciones de exámenes realizadas por los alumnos.
* `IDResultado` (INT, PK, IDENTITY)
* `IDEvaluacion` (INT, FK -> Evaluacion)
* `IDUsuario` (INT, FK -> Usuario)
* `PuntajeObtenido` (INT, CHECK BETWEEN 0 AND 100)
* `fecha` (DATE, DEFAULT GETDATE())
* `aprobacion` (BIT, DEFAULT 0)

### 11. Certificado
Comprobantes automáticos generados tras aprobar una evaluación.
* `IDCertificado` (INT, PK, IDENTITY)
* `IDResultado` (INT, UNIQUE, FK -> ResultadoEvaluacion)
* `fechaEmision` (DATE, DEFAULT GETDATE())

### 12. Inscripcion
Registro de alumnos inscriptos a cursos.
* `IDInscripcion` (INT, PK, IDENTITY)
* `IDUsuario` (INT, FK -> Usuario)
* `IDCurso` (INT, FK -> Curso)
* `fechaDeInscripcion` (DATE, DEFAULT GETDATE())
* `completado` (BIT, DEFAULT 0)
* **Restricción:** UNIQUE (`IDUsuario`, `IDCurso`) para impedir inscripciones duplicadas.

### 13. HistorialBajas
Tabla de auditoría para registrar desinscripciones de alumnos.
* `IDHistorial` (INT, PK, IDENTITY)
* `IDUsuario` (INT, NOT NULL)
* `IDCurso` (INT, NOT NULL)
* `FechaBaja` (DATETIME, DEFAULT GETDATE())
* `UsuarioSistema` (VARCHAR(100), DEFAULT SUSER_SNAME())
* `Motivo` (VARCHAR(255), NULL)

---

## 🛠️ Estructura del Repositorio

* `BD_Cursos.sql`: Script completo de creación de la base de datos, tablas, relaciones y restricciones.
* `Insert_BD_Cursos.sql`: Datos de prueba para popular las tablas.
* `Objetos_BD.sql` *(En desarrollo)*: Vistas, Procedimientos Almacenados, Triggers y Funciones.