USE master;
GO
IF EXISTS (
    SELECT * FROM sys.databases
    WHERE name = 'DB_Cursos'
    ) BEGIN
    DROP DATABASE DB_Cursos
END
GO
CREATE DATABASE DB_Cursos
COLLATE Latin1_General_CI_AI;
GO

CREATE TABLE HistorialBajas (
    IDHistorial INT IDENTITY(1,1) NOT NULL,
    IDUsuario INT NOT NULL,           -- Guardamos el ID que tenía el usuario
    IDCurso INT NOT NULL,             -- Guardamos el ID del curso del que se dio de baja
    FechaBaja DATETIME NOT NULL DEFAULT GETDATE(), -- Cuándo ocurrió la baja
    UsuarioSistema VARCHAR(100) NOT NULL DEFAULT SUSER_SNAME(), -- Qué usuario de SQL Server/App ejecutó la baja
    Motivo VARCHAR(255) NULL,         -- Opcional: motivo de la baja

    CONSTRAINT PK_HistorialBajas PRIMARY KEY (IDHistorial)
);

CREATE TABLE Roles (
    IDRol INT IDENTITY(0,1) NOT NULL,
    Nombre VARCHAR(50) NOT NULL,
    Descripcion VARCHAR(255) NULL

    CONSTRAINT PK_Roles PRIMARY KEY(IDRol),
    CONSTRAINT UQ_Roles_nombre UNIQUE (nombre)
)

CREATE TABLE TipoSuscripcion(
    IDTipoSuscripcion INT IDENTITY(0,1) NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    detalle VARCHAR(100) NULL,
    duracion INT NOT NULL DEFAULT 30,
    precio INT NOT NULL

    CONSTRAINT PK_TipoSuscripcion PRIMARY KEY (IDTipoSuscripcion),
    CONSTRAINT UQ_TipoSuscripcion_nombre UNIQUE (nombre),

    CONSTRAINT CK_TipoSuscripcion_duracion CHECK(duracion >= 0),
    CONSTRAINT CK_TipoSuscripcion_precio CHECK (precio>0)
)

CREATE TABLE Usuario (
    IDUsuario INT IDENTITY(0,1) NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    email VARCHAR(50) NOT NULL,
    contrasenia VARCHAR(50) NOT NULL,
    fechaDeInscripcion DATE NOT NULL,
    IDRol INT NOT NULL 

    CONSTRAINT PK_Usuario PRIMARY KEY (IDUsuario),
    CONSTRAINT UQ_Usuario UNIQUE (IDUsuario),

    CONSTRAINT FK_Usuario_Rol FOREIGN KEY (IDRol) REFERENCES Roles (IDRol),

    CONSTRAINT CK_Usuario_fechaDeInscripcion CHECK (fechaDeInscripcion >= CAST(GETDATE() AS DATE)),
    CONSTRAINT CK_Usuario_contrasenia CHECK (LEN(contrasenia)>5)
)

CREATE TABLE Suscripcion (
    IDSuscripcion INT IDENTITY(0,1) NOT NULL,
    IDTipoSuscripcion INT NOT NULL,
    IDUsuario INT NOT NULL,
    fechaDeInscripcion DATE NOT NULL,
    fechaDeFinalizacion DATE NOT NULL,
    activa BIT NOT NULL DEFAULT 1

    CONSTRAINT PK_Suscripcion PRIMARY KEY (IDSuscripcion),
    
    CONSTRAINT FK_Suscripcion_TipoSuscripcion FOREIGN KEY(IDTipoSuscripcion) REFERENCES TipoSuscripcion (IDTipoSuscripcion) ,
    CONSTRAINT FK_Suscripcion_Usuario FOREIGN KEY(IDUsuario) REFERENCES Usuario (IDUsuario),
    
    CONSTRAINT CK_Suscripcion_fechaDeInscripcion CHECK (fechaDeInscripcion >= GETDATE()),
    CONSTRAINT CK_Suscripcion_fechaDeFinalizacion CHECK (fechaDeFinalizacion > fechaDeInscripcion)
    )


CREATE TABLE Curso (
    IDCurso INT NOT NULL IDENTITY(0,1),
    IDUsuarioEmpresa INT NOT NULL,
    nombre VARCHAR (50) NOT NULL,
    descripcion VARCHAR (250) NOT NULL

    CONSTRAINT PK_Curso PRIMARY KEY(IDCurso),
    CONSTRAINT UQ_Curso_IDCurso UNIQUE(IDCurso),

    CONSTRAINT FK_Curso_IDUsuarioEmpresa FOREIGN KEY (IDUsuarioEmpresa) REFERENCES Usuario (IDUsuario)
)

CREATE TABLE TiposArchivos(
    IDTipoArchivo INT IDENTITY(0,1) NOT NULL,
    nombre VARCHAR(50) NOT NULL

    CONSTRAINT PK_TiposArchivo PRIMARY KEY (IDTipoArchivo),
    CONSTRAINT UQ_TiposArchivo_IDTipoArchivo UNIQUE(IDTipoArchivo),
    CONSTRAINT UQ_TiposArchivo_nombre UNIQUE(nombre)
)

CREATE TABLE Archivo (
    IDArchivo INT IDENTITY(0,1) NOT NULL,
    IDCurso INT NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    IDTipoArchivo INT NOT NULL,
    ruta VARCHAR (255) NOT NULL

    CONSTRAINT PK_Archivo PRIMARY KEY(IDArchivo),
    CONSTRAINT UQ_Archivo_IDArchivo UNIQUE(IDArchivo),
    CONSTRAINT UQ_Archivo_ruta UNIQUE(ruta),

    CONSTRAINT FK_Archivo_TiposArchivo FOREIGN KEY (IDTipoArchivo) REFERENCES TiposArchivos (IDTipoArchivo)
)

CREATE TABLE ProgresoArchivo(
    IDUsuario INT NOT NULL,
    IDArchivo INT NOT NULL,
    completado BIT DEFAULT 0 NOT NULL
    
    CONSTRAINT PK_ProgresoArchivo PRIMARY KEY (IDUsuario, IDArchivo),
    
    CONSTRAINT FK_ProgresoArchivo_IDUsuario FOREIGN KEY (IDUsuario) REFERENCES Usuario (IDUsuario),
    CONSTRAINT FK_ProgresoArchivo_IDArchivo FOREIGN KEY (IDArchivo) REFERENCES Archivo (IDArchivo)
)

CREATE TABLE Evaluacion (
    IDEvaluacion INT IDENTITY(0,1) NOT NULL,
    IDCurso INT NOT NULL,
    titulo VARCHAR(50),
    PuntajeAprobacion  INT NOT NULL DEFAULT 0

    CONSTRAINT PK_Evaluacion PRIMARY KEY(IDEvaluacion),
    CONSTRAINT UQ_Evaluacion_IDEvaluacion UNIQUE(IDEvaluacion),

    CONSTRAINT FK_Evaluacion_IDCurso FOREIGN KEY (IDCurso) REFERENCES Curso (IDCurso),

    CONSTRAINT CK_Evaluacion_PuntajeAprobacion CHECK (PuntajeAprobacion>=0)
    )


CREATE TABLE ResultadoEvaluacion (
    IDResultado INT IDENTITY(0,1) NOT NULL,
    IDEvaluacion INT NOT NULL,
    IDUsuario INT NOT NULL,
    PuntajeObtenido INT NOT NULL,
    fecha DATE NOT NULL,
    aprobacion BIT DEFAULT 0 NOT NULL 

    CONSTRAINT PK_ResultadoEvaluacion PRIMARY KEY(IDResultado),
    CONSTRAINT UQ_ResultadoEvaluacion_IDResultado UNIQUE(IDResultado),
    
    CONSTRAINT FK_ResultadoEvaluacion_IDEvaluacion FOREIGN KEY (IDEvaluacion) REFERENCES Evaluacion(IDEvaluacion),
    CONSTRAINT FK_ResultadoEvaluacion_IDUsuario FOREIGN KEY (IDUsuario) REFERENCES Usuario(IDUsuario),

    CONSTRAINT CK_ResultadoEvaluacion_PuntajeObtenido CHECK(PuntajeObtenido >= 0 AND PuntajeObtenido <= 100),
    CONSTRAINT CK_ResultadoEvaluacion_fecha CHECK(fecha >= GETDATE())
)

CREATE TABLE Certificado(
    IDCertificado INT IDENTITY(0,1) NOT NULL,
    IDResultado INT NOT NULL,
    fechaEmision DATE NOT NULL

    CONSTRAINT PK_Certificado PRIMARY KEY (IDCertificado),
    CONSTRAINT UQ_Certificado_IDCertificado UNIQUE(IDCertificado),

    CONSTRAINT FK_Certificado_IDResultado FOREIGN KEY (IDResultado) REFERENCES ResultadoEvaluacion (IDResultado),

    CONSTRAINT CK_Certificado_FechaEmision CHECK(fechaEmision >= GETDATE())
)

CREATE TABLE Inscripcion (
    IDInscripcion INT IDENTITY(0,1) NOT NULL,
    IDUsuario INT NOT NULL,
    IDCurso INT NOT NULL,
    fechaDeInscripcion DATE NOT NULL,
    completado BIT DEFAULT 0

    CONSTRAINT PK_Inscripcion PRIMARY KEY (IDInscripcion),
    CONSTRAINT UQ_Inscripcion_IDInscripcion UNIQUE(IDInscripcion),
    CONSTRAINT UQ_Inscripcion_Unica UNIQUE (IDUsuario, IDCurso),
    CONSTRAINT FK_Inscripcion_IDUsuario FOREIGN KEY(IDUsuario) REFERENCES Usuario(IDUsuario),
    CONSTRAINT FK_Inscripcion_IDCurso FOREIGN KEY(IDCurso) REFERENCES Curso(IDCurso),

    CONSTRAINT CK_Inscripcion_fechaDeInscripcion CHECK(fechaDeInscripcion >= GETDATE())
)