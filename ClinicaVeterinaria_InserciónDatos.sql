USE clinica_veterinaria;

/*-------------------INSERCIÓN DE DATOS-------------------*/

/*DUEÑOS*/
INSERT INTO dueno (nombre, direccion, telefono) VALUES
('Juan Pérez', 'Calle Falsa 123', '555-1234'),
('Ana Gómez', 'Avenida Siempre Viva 456', '555-5678'),
('Carlos Ruiz', 'Calle 8 de Octubre 789', '555-8765');

/*MASCOTAS*/
INSERT INTO mascota (nombre, tipo, fecha_nacimiento,id_dueno) VALUES
('Rex', 'Perro', '2020-05-10', 1),
('Luna', 'Gato', '2019-02-20', 2),
('Fido', 'Perro', '2021-03-15', 3);

/*PROFESIONALES*/
INSERT INTO profesional (nombre, especialidad) VALUES
('Dr. Martínez', 'Veterinario'),
('Dr. Pérez', 'Especialista en dermatología'),
('Dr. López', 'Cardiólogo veterinario');

/*ATENCIONES*/
INSERT INTO atencion (fecha_atencion, descripcion, id_mascota, id_profesional) VALUES
('2025-03-01', 'Chequeo general',1,1),
('2025-03-05', 'Tratamiento dermatológico',2,2),
('2025-03-07', 'Consulta cardiológica',3,3);