/*--------------------CREACIÓN DE BBDD--------------------*/
CREATE DATABASE clinica_veterinaria;
USE clinica_veterinaria;

/*-------------------CREACIÓN DE TABLAS-------------------*/
/*TABLA DUEÑO*/
CREATE TABLE dueno (
	id_dueno INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    direccion VARCHAR(100) NOT NULL,
    telefono VARCHAR(20) NOT NULL
);

/*TABLA PROFESIONAL*/
CREATE TABLE profesional (
	id_profesional INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    especialidad VARCHAR(100) NOT NULL
);

/*TABLA MASCOTA*/
CREATE TABLE mascota (
	id_mascota INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    tipo VARCHAR(50) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    id_dueno INT NOT NULL,
    CONSTRAINT fk_mascota_dueno FOREIGN KEY (id_dueno)
    REFERENCES dueno(id_dueno) ON DELETE CASCADE ON UPDATE CASCADE /*si se borra/actualiza el dueño se borra/actualiza la mascota*/
);

/*TABLA ATENCION*/
CREATE TABLE atencion (
	id_atencion INT PRIMARY KEY AUTO_INCREMENT,
    fecha_atencion DATE NOT NULL,
    descripcion TEXT NOT NULL,
    id_mascota INT NOT NULL,
	id_profesional INT NOT NULL,
    CONSTRAINT fk_atencion_mascota FOREIGN KEY (id_mascota)
    REFERENCES mascota(id_mascota) ON DELETE CASCADE ON UPDATE CASCADE, /*si se borra/actualiza una mascota se borra/actualiza la atención*/
    CONSTRAINT fk_atencion_profesional FOREIGN KEY (id_profesional)
    REFERENCES profesional(id_profesional) ON DELETE CASCADE ON UPDATE CASCADE
);

/*-------------------MODIFICACIÓN DE TABLAS-------------------*/
ALTER TABLE dueno 
ADD UNIQUE KEY uq_nombre_dir_tel (nombre, direccion, telefono);

ALTER TABLE mascota
ADD UNIQUE KEY uq_mascota_dueno (nombre, id_dueno);

/*SHOW INDEX FROM dueno;*/