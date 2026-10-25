--Vistas
--Vista para que se puedan ver los alumnos por empresas.
--Nombre completo(usuario),fecha de incripcion a la materia(inscripcion) y su obtuvieron certificado(Certificado), tipo de Inscripcion.
/*
CREATE VIEW VW_LISTA_ALUMNOS AS
SELECT
    U.IDUsuario as IDUsuario,
    TS.nombre AS tipoSucripcion,
    U.nombre AS NombreAlumno,
    U.apellido as apellidoAlumno,
    I.fechaDeInscripcion AS fechaDeInscripcionCurso,
    C.nombre as nombreCurso,
    UE.nombre + ', ' + ue.apellido as nombreEmpresa
 FROM Usuario U
    INNER JOIN Suscripcion S ON S.IDUsuario = U.IDUsuario
    INNER JOIN TipoSuscripcion TS ON TS.IDTipoSuscripcion=S.IDTipoSuscripcion
    --
    INNER JOIN Inscripcion I ON I.IDUsuario = U.IDUsuario
    INNER JOIN Curso C ON C.IDCurso = I.IDCurso
    INNER JOIN Usuario UE ON UE.IDUsuario = C.IDUsuarioEmpresa
  
    WHERE U.IDRol = 3
*/

--Vista para ver los cursos ordenados por empresas
CREATE VIEW VW_LISTA_CURSOSxEMPRESAS AS
SELECT 
    U.IDUsuario as IDEmpresa,
    U.nombre +' '+U.apellido AS Empresa,
    C.nombre as nombreCurso
FROM Usuario U
INNER JOIN Curso C ON C.IDUsuarioEmpresa = U.IDUsuario
--ORDER BY U.IDUsuario DESC , C.nombre ASC-- Al ser una vista el ordenamiento lo hacemos fuera

-- Vista para ver la cantidad de alumnos en cada curso y armar un Ranking de cursos con mas interes
--VW_CANT_ALUMNOSxEMPRESAS