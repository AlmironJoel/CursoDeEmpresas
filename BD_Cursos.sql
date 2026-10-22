USE master;
GO

IF EXISTS (SELECT * FROM sys.databases WHERE name = 'DB_Cursos') 
BEGIN
    ALTER DATABASE DB_Cursos SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DB_Cursos;
END
GO

CREATE DATABASE DB_Cursos
COLLATE Latin1_General_CI_AI;
GO

USE DB_Cursos;
GO


CREATE TABLE HistorialBajas (
    IDHistorial INT IDENTITY(1,1) NOT NULL,
    IDUsuario INT NOT NULL,           
    IDCurso INT NOT NULL,             
    FechaBaja DATETIME NOT NULL DEFAULT GETDATE(), 
    UsuarioSistema VARCHAR(100) NOT NULL DEFAULT SUSER_SNAME(), 
    Motivo VARCHAR(255) NULL,         
    CONSTRAINT PK_HistorialBajas PRIMARY KEY (IDHistorial)
);

CREATE TABLE Roles (
    IDRol INT IDENTITY(1,1) NOT NULL,
    Nombre VARCHAR(50) NOT NULL,
    Descripcion VARCHAR(255) NULL

    CONSTRAINT PK_Roles PRIMARY KEY(IDRol),
    CONSTRAINT UQ_Roles_nombre UNIQUE (nombre)
);

CREATE TABLE TipoSuscripcion (
    IDTipoSuscripcion INT IDENTITY(1,1) NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    detalle VARCHAR(100) NULL,
    duracion INT NOT NULL DEFAULT 30,
    precio INT NOT NULL

    CONSTRAINT PK_TipoSuscripcion PRIMARY KEY (IDTipoSuscripcion),
    CONSTRAINT UQ_TipoSuscripcion_nombre UNIQUE (nombre),
    CONSTRAINT CK_TipoSuscripcion_duracion CHECK (duracion >= 0),
    CONSTRAINT CK_TipoSuscripcion_precio CHECK (precio >= 0)
);

CREATE TABLE Usuario (
    IDUsuario INT IDENTITY(1,1) NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    email VARCHAR(50) NOT NULL,
    contrasenia VARCHAR(50) NOT NULL,
    fechaDeInscripcion DATE NOT NULL DEFAULT GETDATE(),
    IDRol INT NOT NULL DEFAULT 3

    CONSTRAINT PK_Usuario PRIMARY KEY (IDUsuario),
    CONSTRAINT UQ_Usuario_email UNIQUE (email),
    CONSTRAINT FK_Usuario_Rol FOREIGN KEY (IDRol) REFERENCES Roles (IDRol),
    CONSTRAINT CK_Usuario_contrasenia CHECK (LEN(contrasenia) > 5)
);

CREATE TABLE Suscripcion (
    IDSuscripcion INT IDENTITY(1,1) NOT NULL,
    IDTipoSuscripcion INT NOT NULL,
    IDUsuario INT NOT NULL,
    fechaDeInscripcion DATE NOT NULL DEFAULT GETDATE(),
    fechaDeFinalizacion DATE NOT NULL,
    activa BIT NOT NULL DEFAULT 1
    
    CONSTRAINT PK_Suscripcion PRIMARY KEY (IDSuscripcion),
    CONSTRAINT FK_Suscripcion_TipoSuscripcion FOREIGN KEY(IDTipoSuscripcion) REFERENCES TipoSuscripcion (IDTipoSuscripcion),
    CONSTRAINT FK_Suscripcion_Usuario FOREIGN KEY(IDUsuario) REFERENCES Usuario (IDUsuario),
    CONSTRAINT CK_Suscripcion_fechaDeInscripcion CHECK (fechaDeInscripcion >= CAST(GETDATE() AS DATE)),
    CONSTRAINT CK_Suscripcion_fechaDeFinalizacion CHECK (fechaDeFinalizacion > fechaDeInscripcion)
);

CREATE TABLE Curso (
    IDCurso INT IDENTITY(1,1) NOT NULL,
    IDUsuarioEmpresa INT NOT NULL,
    nombre VARCHAR (50) NOT NULL,
    descripcion VARCHAR (250) NOT NULL

    CONSTRAINT PK_Curso PRIMARY KEY(IDCurso),
    CONSTRAINT FK_Curso_IDUsuarioEmpresa FOREIGN KEY (IDUsuarioEmpresa) REFERENCES Usuario (IDUsuario)
);

CREATE TABLE TipoArchivo (
    IDTipoArchivo INT IDENTITY(1,1) NOT NULL,
    nombre VARCHAR(50) NOT NULL
    CONSTRAINT PK_TiposArchivo PRIMARY KEY (IDTipoArchivo),
    CONSTRAINT UQ_TiposArchivo_nombre UNIQUE(nombre)
);

CREATE TABLE Archivo (
    IDArchivo INT IDENTITY(1,1) NOT NULL,
    IDCurso INT NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    IDTipoArchivo INT NOT NULL,
    ruta VARCHAR (255) NOT NULL
    CONSTRAINT PK_Archivo PRIMARY KEY(IDArchivo),
    CONSTRAINT UQ_Archivo_ruta UNIQUE(ruta),
    CONSTRAINT FK_Archivo_Curso FOREIGN KEY (IDCurso) REFERENCES Curso (IDCurso),
    CONSTRAINT FK_Archivo_TiposArchivo FOREIGN KEY (IDTipoArchivo) REFERENCES TiposArchivos (IDTipoArchivo)
);

CREATE TABLE ProgresoArchivo (
    IDUsuario INT NOT NULL, 
    IDArchivo INT NOT NULL,
    completado BIT DEFAULT 0 NOT NULL

    CONSTRAINT PK_ProgresoArchivo PRIMARY KEY (IDUsuario, IDArchivo),
    CONSTRAINT FK_ProgresoArchivo_IDUsuario FOREIGN KEY (IDUsuario) REFERENCES Usuario (IDUsuario),
    CONSTRAINT FK_ProgresoArchivo_IDArchivo FOREIGN KEY (IDArchivo) REFERENCES Archivo (IDArchivo)
);

CREATE TABLE Evaluacion (
    IDEvaluacion INT IDENTITY(1,1) NOT NULL,
    IDCurso INT NOT NULL,
    titulo VARCHAR(50),
    PuntajeAprobacion INT NOT NULL DEFAULT 0

    CONSTRAINT PK_Evaluacion PRIMARY KEY(IDEvaluacion),
    CONSTRAINT FK_Evaluacion_IDCurso FOREIGN KEY (IDCurso) REFERENCES Curso (IDCurso),
    CONSTRAINT CK_Evaluacion_PuntajeAprobacion CHECK (PuntajeAprobacion >= 0 AND PuntajeAprobacion <= 100)
);

CREATE TABLE ResultadoEvaluacion (
    IDResultado INT IDENTITY(1,1) NOT NULL,
    IDEvaluacion INT NOT NULL,
    IDUsuario INT NOT NULL,
    PuntajeObtenido INT NOT NULL,
    fecha DATE NOT NULL DEFAULT GETDATE(),
    aprobacion BIT DEFAULT 0 NOT NULL 

    CONSTRAINT PK_ResultadoEvaluacion PRIMARY KEY(IDResultado),
    CONSTRAINT FK_ResultadoEvaluacion_IDEvaluacion FOREIGN KEY (IDEvaluacion) REFERENCES Evaluacion(IDEvaluacion),
    CONSTRAINT FK_ResultadoEvaluacion_IDUsuario FOREIGN KEY (IDUsuario) REFERENCES Usuario(IDUsuario),
    CONSTRAINT CK_ResultadoEvaluacion_PuntajeObtenido CHECK(PuntajeObtenido >= 0 AND PuntajeObtenido <= 100),
    CONSTRAINT CK_ResultadoEvaluacion_Fecha CHECK(fecha >= CAST(GETDATE() AS DATE))
);

CREATE TABLE Certificado (
    IDCertificado INT IDENTITY(1,1) NOT NULL,
    IDResultado INT NOT NULL,
    fechaEmision DATE NOT NULL DEFAULT GETDATE()

    CONSTRAINT PK_Certificado PRIMARY KEY (IDCertificado),
    CONSTRAINT UQ_Certificado_Resultado UNIQUE(IDResultado), 
    CONSTRAINT FK_Certificado_IDResultado FOREIGN KEY (IDResultado) REFERENCES ResultadoEvaluacion (IDResultado),
    CONSTRAINT CK_Certificado_FechaEmision CHECK(fechaEmision >= CAST(GETDATE() AS DATE))
);

CREATE TABLE Inscripcion (
    IDInscripcion INT IDENTITY(1,1) NOT NULL,
    IDUsuario INT NOT NULL,
    IDCurso INT NOT NULL,
    fechaDeInscripcion DATE NOT NULL DEFAULT GETDATE(),
    completado BIT DEFAULT 0 NOT NULL
    
    CONSTRAINT PK_Inscripcion PRIMARY KEY (IDInscripcion),
    CONSTRAINT UQ_Inscripcion_UsuarioCurso UNIQUE (IDUsuario, IDCurso), 
    CONSTRAINT FK_Inscripcion_IDUsuario FOREIGN KEY(IDUsuario) REFERENCES Usuario(IDUsuario),
    CONSTRAINT FK_Inscripcion_IDCurso FOREIGN KEY(IDCurso) REFERENCES Curso(IDCurso),
    CONSTRAINT CK_Inscripcion_fechaDeInscripcion CHECK(fechaDeInscripcion >= CAST(GETDATE() AS DATE))
);
GO