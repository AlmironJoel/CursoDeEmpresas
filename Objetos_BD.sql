USE DB_Cursos;

Go
CREATE OR ALTER VIEW VW_LISTA_ALUMNOS AS
SELECT
    U.IDUsuario as IDUsuario,
    TS.nombre AS tipoSuscripcion,
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
GO


GO
CREATE OR ALTER VIEW VW_LISTA_CURSOSxEMPRESAS AS
SELECT 
    U.IDUsuario as IDEmpresa,
    U.nombre +' '+U.apellido AS Empresa,
    C.nombre as nombreCurso
FROM Usuario U
INNER JOIN Curso C ON C.IDUsuarioEmpresa = U.IDUsuario
GO


GO
CREATE OR ALTER VIEW VW_CANT_ALUMNOSxCurso AS
SELECT
    C.IDCurso,
    C.nombre,
    COUNT(I.IDInscripcion) AS cantidadAlumnos
FROM Curso C
INNER JOIN Inscripcion I ON I.IDCurso=C.IDCurso
INNER JOIN Usuario U ON U.IDUsuario=I.IDUsuario
GROUP BY C.nombre,C.IDCurso
GO

GO
CREATE OR ALTER FUNCTION fn_Calcular_dias (@IDUsuario INT)
RETURNS INT
AS
BEGIN
    DECLARE @CantidadDias INT;
 
    SELECT TOP 1
        @CantidadDias = DATEDIFF(DAY, CAST(GETDATE() AS DATE), S.fechaDeFinalizacion)
    FROM Suscripcion S
    WHERE S.IDUsuario = @IDUsuario
      AND S.activa = 1
    ORDER BY S.fechaDeFinalizacion DESC;
 
    RETURN @CantidadDias;
END;

GO
CREATE OR ALTER VIEW VW_ESTADO_SUSCRIPCIONES AS
SELECT
    U.IDUsuario,
    U.nombre + ' ' + U.apellido AS nombreUsuario,
    U.mail,
    TS.nombre AS tipoSuscripcion,
    TS.precio,
    S.fechaDeInscripcion AS fechaInicio,
    S.fechaDeFinalizacion AS fechaVencimiento,
    dbo.fn_Calcular_dias(U.IDUsuario) AS diasRestantes,
    CASE
        WHEN dbo.fn_Calcular_dias(U.IDUsuario) < 0  THEN 'Vencida'
        WHEN dbo.fn_Calcular_dias(U.IDUsuario) <= 7 THEN 'Por vencer'
        ELSE 'Vigente'
    END AS estadoSuscripcion
FROM Suscripcion S
INNER JOIN Usuario U ON U.IDUsuario = S.IDUsuario
INNER JOIN TipoSuscripcion TS ON TS.IDTipoSuscripcion = S.IDTipoSuscripcion
WHERE S.activa = 1;

GO


GO
CREATE OR ALTER PROCEDURE SP_REGISTRAR_INSCRIPCION(
    @IDUsuario INT,
    @IDCurso INT
)AS BEGIN

    BEGIN TRY

        BEGIN TRANSACTION;

        IF NOT EXISTS (SELECT 1 FROM Usuario U WHERE U.IDUsuario = @IDUsuario)
        BEGIN
            RAISERROR('USUARIO NO EXISTENTE', 16, 1);   
        END;

        IF NOT EXISTS (
            SELECT 1
            FROM Curso C
            WHERE C.IDCurso = @IDCurso
        )
        BEGIN
            RAISERROR('CURSO NO EXISTENTE', 16, 2);
            
        END;
    
        IF NOT EXISTS (
            SELECT 1 FROM Suscripcion S WHERE S.IDUsuario = @IDUsuario AND S.activa = 1 AND S.fechaDeFinalizacion > CAST(GETDATE() AS date)
        )BEGIN
            RAISERROR('SUSCRIPCION NO ACTIVA, NO PUEDE REGISTRARSE', 16, 2);   
        END;

        IF EXISTS (
        SELECT 1
        FROM Inscripcion I
        WHERE I.IDUsuario = @IDUsuario
        AND I.IDCurso = @IDCurso)
         BEGIN
               RAISERROR('EL ALUMNO YA ESTA MATRICULADO EN ESTE CURSO', 16, 2);
          END;

        INSERT INTO Inscripcion (IDUsuario, IDCurso)
        VALUES (@IDUsuario, @IDCurso);

        COMMIT TRANSACTION;

    END TRY

    BEGIN CATCH

        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END;
        
        DECLARE @mensajeError NVARCHAR(250)
        SET @mensajeError = ERROR_MESSAGE()

        RAISERROR(@mensajeError, 16, 1);

    END CATCH;

END;
GO

GO
CREATE OR ALTER PROCEDURE sp_RankingAlumnosXEmpresa (@IDEmpresa INT) AS
BEGIN

    BEGIN TRY
        BEGIN TRANSACTION
            IF EXISTS (
                SELECT 1 FROM Usuario U
                INNER JOIN Roles R ON R.IDRol = U.IDRol

                WHERE U.IDUsuario = @IDEmpresa AND R.Nombre='empresa'
                )BEGIN
                    SELECT 
                        u.nombre+','+u.apellido as nombreCompletoAlumno,
                        ISNULL (re.PuntajeObtenido,0) AS puntaje,
                        CASE
                        WHEN re.aprobacion = 1 THEN 'Aprobado'
                        WHEN re.aprobacion = 0 THEN 'Desaprobado'
                        ELSE 'SIN NOTA DEFINIDA'
                        END AS aprobacion ,
                        C.nombre ,
                        e.nombre as empresa
                     FROM Inscripcion I
                    INNER JOIN Usuario U  ON U.IDUsuario = I.IDUsuario
                    INNER JOIN Curso C    ON C.IDCurso = I.IDCurso
                    INNER JOIN Usuario E  ON E.IDUsuario = C.IDUsuarioEmpresa
                    LEFT JOIN Evaluacion EV         ON EV.IDCurso = C.IDCurso
                    LEFT JOIN ResultadoEvaluacion RE 
                        ON RE.IDEvaluacion = EV.IDEvaluacion
                           AND RE.IDUsuario = U.IDUsuario
                    WHERE C.IDUsuarioEmpresa = @IDEmpresa
                    ORDER BY puntaje DESC, nombreCompletoAlumno;
                END ELSE BEGIN
                    RAISERROR ('No existe esa empresa',16,1)
                END

        COMMIT TRANSACTION
    END TRY

    BEGIN CATCH
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END;
        DECLARE @MensajeError VARCHAR(250)

        SET @MensajeError = ERROR_MESSAGE()
        RAISERROR (@MensajeError,16,1)
    END CATCH
END

GO

GO
CREATE OR ALTER TRIGGER tr_Eliminar_Inscripcion 
ON Inscripcion
AFTER DELETE
AS
BEGIN
    BEGIN TRY
        DECLARE @nombreUsuario VARCHAR(100)
        SELECT @nombreUsuario=u.nombre FROM Usuario U
        WHERE U.IDUsuario =(SELECT 
            IDUsuario
        FROM deleted)
         
        INSERT INTO HistorialBajas
        (IDUsuario, IDCurso,UsuarioBaja, Motivo)
        SELECT 
            IDUsuario, 
            IDCurso,
            @nombreUsuario,
            'Baja manual de inscripción'
        FROM deleted;
    END TRY

    BEGIN CATCH
        DECLARE @mensajeError NVARCHAR(200);
        SET @mensajeError = ERROR_MESSAGE();
        RAISERROR (@mensajeError, 16, 1);
    END CATCH
END;
GO
GO
CREATE OR ALTER TRIGGER tr_emitir_diploma ON ResultadoEvaluacion
    AFTER INSERT
AS BEGIN
    BEGIN TRY
        INSERT INTO Certificado (IDResultado)
        SELECT IDResultado
        FROM inserted
        WHERE aprobacion = 1;
    END TRY
    BEGIN CATCH
        RAISERROR ('error al crear el certificado, verificar nota', 16, 1);
    END CATCH
END
GO
