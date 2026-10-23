USE DB_Cursos;
GO

-- =============================================
-- 1. ROLES
-- =============================================
INSERT INTO Roles (Nombre, Descripcion) VALUES
('Admin', 'Administrador del sistema con acceso total'),
('Empresa', 'Usuario corporativo que publica y gestiona cursos'),
('Alumno', 'Usuario estudiante que realiza capacitaciones');

-- =============================================
-- 2. TIPOS DE SUSCRIPCIÓN
-- =============================================
INSERT INTO TipoSuscripcion (nombre, detalle, duracion, precio) VALUES
('Gratuito', 'Acceso de prueba limitado sin certificado', 30, 0),
('Plus Mensual', 'Acceso ilimitado a todos los cursos por un mes', 30, 15000),
('Pro Anual', 'Acceso total y prioridad en emisión de certificados por un año', 365, 120000);

-- =============================================
-- 3. USUARIOS (Empresas, Alumnos y Admin)
-- =============================================
-- IDs 1 al 11: Empresas (Rol ID = 2)
INSERT INTO Usuario (nombre, apellido, email, contrasenia, IDRol) VALUES
('TechCorp', 'Argentina', 'contacto@techcorp.com', 'Admin1234', 2),
('Sistemas', 'Global', 'info@sistemasglobal.com', 'Sistemas2026', 2),
('DataAcademy', 'LATAM', 'hola@dataacademy.io', 'DataSecure99', 2),
('CodeMaster', 'IT', 'contacto@codemaster.com', 'Code2026', 2),
('TechAcademy', 'Global', 'info@techacademy.com', 'Tech2026', 2),
('DataMinds', 'Analytics', 'hola@dataminds.io', 'Data2026', 2),
('CloudSkills', 'Academy', 'soporte@cloudskills.com', 'Cloud2026', 2),
('DevFactory', 'Software', 'admin@devfactory.net', 'Dev2026', 2),
('CyberLearn', 'Security', 'cursos@cyberlearn.org', 'Cyber2026', 2),
('AI Institute', 'Latam', 'ai@institute.com', 'Intel2026', 2),
('AgilePath', 'Coaching', 'hello@agilepath.com', 'Agile2026', 2);

-- IDs 12 al 35: Alumnos (Rol ID = 3)
INSERT INTO Usuario (nombre, apellido, email, contrasenia, IDRol) VALUES
('Angel', 'Simon', 'AngelS@gmail.com', '1223334444', 3),
('Maria', 'De Grazia', 'mariag@utn.com.ar', 'Pass12345', 3),
('Joel', 'Almiron', 'brian_joel@utn.com.ar', 'ClaveSegura1', 3),
('Uziel', 'Re', 'uziel_re@utn.com.ar', 'Estudiante2026', 3),
('Carlos', 'Gomez', 'cgomez@gmail.com', 'Pass1234', 3),
('Lucia', 'Fernandez', 'lfernandez@gmail.com', 'Pass1234', 3),
('Matias', 'Lopez', 'mlopez@utn.com.ar', 'Pass1234', 3),
('Sofia', 'Martinez', 'smartinez@gmail.com', 'Pass1234', 3),
('Joaquin', 'Silva', 'jsilva@utn.com.ar', 'Pass1234', 3),
('Valentina', 'Ruiz', 'vruiz@gmail.com', 'Pass1234', 3),
('Tomas', 'Herrera', 'therrera@utn.com.ar', 'Pass1234', 3),
('Camila', 'Diaz', 'cdiaz@gmail.com', 'Pass1234', 3),
('Santiago', 'Vega', 'svega@utn.com.ar', 'Pass1234', 3),
('Martina', 'Cruz', 'mcruz@gmail.com', 'Pass1234', 3),
('Mateo', 'Reyes', 'mreyes@utn.com.ar', 'Pass1234', 3),
('Emma', 'Ortiz', 'eortiz@gmail.com', 'Pass1234', 3),
('Bautista', 'Castro', 'bcastro@utn.com.ar', 'Pass1234', 3),
('Julieta', 'Romero', 'jromero@gmail.com', 'Pass1234', 3),
('Agustin', 'Perez', 'aperez@utn.com.ar', 'Pass1234', 3),
('Zoe', 'Suarez', 'zsuarez@gmail.com', 'Pass1234', 3),
('Facundo', 'Alvarez', 'falvarez@utn.com.ar', 'Pass1234', 3),
('Catalina', 'Molina', 'cmolina@gmail.com', 'Pass1234', 3),
('Nicolas', 'Blanco', 'nblanco@utn.com.ar', 'Pass1234', 3),
('Delfina', 'Acosta', 'dacosta@gmail.com', 'Pass1234', 3);

-- ID 36: Administrador (Rol ID = 1)
INSERT INTO Usuario (nombre, apellido, email, contrasenia, IDRol) VALUES
('Admin', 'Principal', 'admin@plataforma.com', 'AdminPass2026', 1);

-- =============================================
-- 4. SUSCRIPCIONES
-- =============================================
INSERT INTO Suscripcion (IDTipoSuscripcion, IDUsuario, fechaDeFinalizacion, activa)
SELECT 
    CASE WHEN IDUsuario % 2 = 0 THEN 3 ELSE 2 END, 
    IDUsuario, 
    DATEADD(DAY, 60, GETDATE()), 
    1
FROM Usuario WHERE IDRol = 3;

-- =============================================
-- 5. CURSOS (Publicados por Usuarios-Empresa)
-- =============================================
INSERT INTO Curso (IDUsuarioEmpresa, nombre, descripcion) VALUES
(1, 'JavaScript Inicial', 'Aprende los fundamentos del desarrollo web dinámico desde cero.'),
(1, 'React JS y Redux', 'Desarrollo de aplicaciones SPA avanzadas y gestión de estado.'),
(2, 'SQL Server Intermedio', 'Diseño relacional, vistas, store procedures y optimización de consultas.'),
(3, 'Ciencia de Datos con Python', 'Introducción a Pandas, NumPy y visualización de datos.'),
(4, 'HTML & CSS Básico', 'Maquetación web estática'),
(4, 'JavaScript Avanzado', 'Clausuras, promesas y asincronismo'),
(4, 'React JS para Principiantes', 'Componentes y estados'),
(5, 'Java Spring Boot', 'APIs RESTful con Java'),
(5, 'Microservicios', 'Arquitecturas escalables'),
(5, 'Testing en Java', 'JUnit y Mockito'),
(6, 'SQL Server Desde Cero', 'Bases de datos relacionales'),
(6, 'Python para Datos', 'Pandas y NumPy'),
(6, 'Power BI Avanzado', 'DAX y visualizaciones'),
(7, 'AWS Cloud Practitioner', 'Fundamentos de la nube AWS'),
(7, 'Docker & Kubernetes', 'Contenedores y orquestación'),
(7, 'Azure Fundamentals', 'Introducción a Microsoft Azure'),
(8, 'C# .NET Core', 'Desarrollo backend con C#'),
(8, 'Angular Moderno', 'Framework frontend de Google'),
(8, 'Node.js y Express', 'Backend con JavaScript'),
(9, 'Ciberseguridad Básica', 'Fundamentos de seguridad informática'),
(9, 'Ethical Hacking', 'Pruebas de penetración'),
(9, 'Redes y Protocolos', 'TCP/IP y seguridad perimetral'),
(10, 'Machine Learning', 'Modelos predictivos'),
(10, 'Deep Learning', 'Redes neuronales con TensorFlow'),
(10, 'NLP con Python', 'Procesamiento de lenguaje natural'),
(11, 'Scrum Master Certificación', 'Metodologías ágiles'),
(11, 'Kanban Avanzado', 'Flujos de trabajo eficientes'),
(11, 'Product Owner', 'Gestión de backlog y stakeholders');

-- =============================================
-- 6. TIPOS DE ARCHIVO
-- =============================================
INSERT INTO TipoArchivo (nombre) VALUES
('PDF'),
('DOCX'),
('MP4'),
('ZIP');

-- =============================================
-- 7. ARCHIVOS DE ESTUDIO (Ampliados para más cursos)
-- =============================================
INSERT INTO Archivo (IDCurso, nombre, IDTipoArchivo, ruta) VALUES
(1, '01_Introduccion_JS.mp4', 3, 'https://cdn.cursos.com/c1/intro_js.mp4'),
(1, 'Guia_Ejercicios_JS.pdf', 1, 'https://cdn.cursos.com/c1/guia1.pdf'),
(2, 'React_Components.mp4', 3, 'https://cdn.cursos.com/c2/react_comp.mp4'),
(3, 'Script_Creacion_Tablas.sql', 2, 'https://cdn.cursos.com/c3/script_tablas.docx'),
(3, '01_Teoria_Normalizacion.pdf', 1, 'https://cdn.cursos.com/c3/normalizacion.pdf'),
(4, 'Pandas_Intro.pdf', 1, 'https://cdn.cursos.com/c4/pandas.pdf'),
(5, 'Estructura_HTML.mp4', 3, 'https://cdn.cursos.com/c5/html.mp4'),
(8, 'Spring_Boot_Setup.zip', 4, 'https://cdn.cursos.com/c8/spring_setup.zip'),
(11, 'SQL_Select_Joins.mp4', 3, 'https://cdn.cursos.com/c11/sql_joins.mp4'),
(14, 'AWS_EC2_Guide.pdf', 1, 'https://cdn.cursos.com/c14/aws_ec2.pdf'),
(20, 'Kali_Linux_Tools.zip', 4, 'https://cdn.cursos.com/c20/kali_tools.zip'),
(23, 'Machine_Learning_Models.pdf', 1, 'https://cdn.cursos.com/c23/ml_models.pdf'),
(26, 'Scrum_Guide_2020.pdf', 1, 'https://cdn.cursos.com/c26/scrum_guide.pdf');

-- =============================================
-- 8. INSCRIPCIONES (Alineadas con Alumnos IDs 12 a 35)
-- =============================================
INSERT INTO Inscripcion (IDUsuario, IDCurso, completado) VALUES
(12, 1, 1), (12, 3, 0), (12, 5, 0),
(13, 2, 1), (13, 8, 1), (13, 11, 0),
(14, 3, 0), (14, 14, 0), (14, 20, 1),
(15, 4, 1), (15, 23, 0), (15, 26, 0),
(16, 5, 1), (16, 1, 1),  (16, 8, 0),
(17, 6, 0), (17, 11, 0), (17, 14, 1),
(18, 7, 1), (18, 20, 1), (18, 2, 0),
(19, 8, 0), (19, 23, 0), (19, 3, 1),
(20, 9, 1), (20, 26, 0), (20, 4, 0),
(21, 10, 0), (21, 1, 1), (21, 5, 1),
(22, 11, 1), (22, 2, 0), (22, 6, 0),
(23, 12, 0), (23, 3, 1), (23, 7, 1),
(24, 13, 1), (24, 4, 0), (24, 8, 0),
(25, 14, 0), (25, 5, 1), (25, 9, 1),
(26, 15, 1), (26, 6, 0), (26, 10, 0),
(27, 16, 0), (27, 7, 1), (27, 11, 1),
(28, 17, 1), (28, 8, 0), (28, 12, 0),
(29, 18, 0), (29, 9, 1), (29, 13, 1),
(30, 19, 1), (30, 10, 0), (30, 14, 0),
(31, 20, 0), (31, 11, 1), (31, 15, 1),
(32, 21, 1), (32, 12, 0), (32, 16, 1),
(33, 22, 0), (33, 13, 1), (33, 17, 0),
(34, 23, 1), (34, 14, 0), (34, 18, 1),
(35, 24, 0), (35, 15, 1), (35, 19, 0);

-- =============================================
-- 9. PROGRESO DE ARCHIVOS
-- =============================================
INSERT INTO ProgresoArchivo (IDUsuario, IDArchivo, completado) VALUES
(12, 1, 1), (12, 2, 1), 
(13, 3, 1), 
(14, 4, 1), (14, 5, 1),
(15, 6, 1),
(16, 7, 1),
(17, 10, 1),
(18, 11, 1),
(24, 8, 1);

-- =============================================
-- 10. EVALUACIONES
-- =============================================
INSERT INTO Evaluacion (IDCurso, titulo, PuntajeAprobacion) VALUES
(1, 'Examen Final JavaScript Inicial', 60),
(2, 'Evaluación de Proyecto React', 70),
(3, 'Examen Integrador SQL Server', 75),
(4, 'Test Pandas y NumPy', 60),
(5, 'Maquetación Final HTML/CSS', 60),
(8, 'API Rest con Spring Boot', 70),
(11, 'Consultas y Joins SQL', 70),
(14, 'Despliegue en AWS EC2', 65),
(20, 'Test Penetration Kali', 80),
(23, 'Modelos de Regresión', 75),
(26, 'Examen Certificación Scrum', 85);

-- =============================================
-- 11. RESULTADOS DE EVALUACIONES
-- =============================================
-- Resultados para alumnos con completado = 1 en inscripciones
INSERT INTO ResultadoEvaluacion (IDEvaluacion, IDUsuario, PuntajeObtenido, aprobacion) VALUES
(1, 12, 85, 1), -- Angel aprobó JS
(2, 13, 90, 1), -- Maria aprobó React
(3, 14, 50, 0), -- Joel reprobó SQL
(4, 15, 78, 1), 
(5, 16, 95, 1), 
(6, 24, 82, 1), 
(7, 27, 40, 0), 
(8, 17, 88, 1),
(9, 18, 91, 1),
(10, 34, 76, 1),
(11, 26, 65, 0);

-- =============================================
-- 12. CERTIFICADOS
-- =============================================
-- Solo se emiten para los resultados aprobados (IDs 1, 2, 4, 5, 6, 8, 9, 10)
INSERT INTO Certificado (IDResultado) VALUES
(1), 
(2), 
(4), 
(5), 
(6), 
(8), 
(9), 
(10);
GO