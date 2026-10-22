--- TABLA ROLES
/*INSERT INTO Roles (Nombre,Descripcion)
VALUES
('admin','Usuario con acceso total a la plataforma'),
('empresa','Usuario con acceso del lado empresas'),
('alumno','Usuario con acceso del lado Alumno')
SELECT * From Roles
*/

---TABLA TIPOSUSCRIPCION
/*
INSERT INTO TipoSuscripcion (nombre,detalle,precio)
VALUES 
('gratis','Te da acceso al contenido ,pero no te da acceso a los examenes ni certificados de las empresas',0),
('plus','Esta version da acceso total a los cursos, evaluaciones y certificados.',15000)

SELECT * FROM TipoSuscripcion
*/

---- TABLAS USUARIOS
/*
INSERT INTO Usuario (nombre,apellido,email,contrasenia,IDRol)
VALUES
('Angel','Simon','AngelS@gmail.com','1223334444',3),
('Maria','De Grazia','mariag@UTN.com.ar','123125',2),
('Joel','almiron','brian_joel@UTN.com.ar','123456',1)

SELECT*FROM Usuario
*/

---TABLA SUSCRIPCION
/*
INSERT INTO Suscripcion (IDTipoSuscripcion, IDUsuario, fechaDeFinalizacion)
VALUES (2, 4, DATEADD(DAY, 30, CAST(GETDATE() AS DATE)));
SELECT * FROM Suscripcion
*/

---TABLA CURSO
/*
INSERT INTO Curso (IDUsuarioEmpresa,nombre,descripcion)VALUES
(4,'JavaScript Inicial','Curso de JavaScript,donde te enseniaremos los pasos para iniciarte en el mundo de la programacion Web')

SELECT * FROM Curso
*/

---TABLA TIPOSARCHIVOS
/*
INSERT INTO TipoArchivo (nombre)
VALUES('pdf'),('docx'),('mp4')
Select * FROM TipoArchivo
*/

---TABLA ARCHIVO
/*
INSERT INTO Archivo (IDCurso,nombre,IDTipoArchivo,ruta)VALUES
(2,'Introduccion Programacion',3,'https://www.youtube.com/watch?v=8GTaO9XhA5M')

SELECT * FROM Archivo
*/

---TABLA PROGRESOARCHIVO
/*
INSERT INTO ProgresoArchivo (IDUsuario,IDArchivo) VALUES (5,1)
SELECT * FROM ProgresoArchivo
*/

--- TABLA EVALUACION
/*
INSERT INTO Evaluacion (IDCurso,titulo,PuntajeAprobacion) VALUES (2,'Final de JS Inicial',45)
Select * from Evaluacion
*/

--- TABLA RESULTADOEVALUACION
/*
INSERT INTO ResultadoEvaluacion (IDEvaluacion,IDUsuario,PuntajeObtenido,aprobacion)VALUES (1,5,80,1)
SELECT * FROM ResultadoEvaluacion
*/

--TABLA CERTIFICADO
/*
INSERT INTO Certificado (IDResultado) VALUES(2) 
SELECT * FROM Certificado
*/

--TABLA INSCRIPCION 
/*
INSERT INTO Inscripcion (IDUsuario,IDCurso) VALUES(5,2)
SELECT * FROM Inscripcion
*/