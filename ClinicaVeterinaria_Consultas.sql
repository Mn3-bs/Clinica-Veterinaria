USE clinica_veterinaria;

/*-------------------CONSULTAS-------------------*/

/*1. Obtener todos los dueños y sus mascotas.*/
SELECT d.nombre AS 'Nombre del dueño', m.nombre AS 'Nombre de la mascota'
FROM dueno d INNER JOIN mascota m
ON d.id_dueno = m.id_dueno;

/*2. Obtener las atenciones realizadas a las mascotas con los detalles del profesional que atendió.*/
SELECT a.descripcion AS 'Descripción de la atención', a.fecha_atencion AS 'Fecha de la atención',
p.nombre AS 'Profesional que atendió', p.especialidad AS 'Especialidad del profesional'
FROM atencion a INNER JOIN profesional p
ON a.id_profesional = p.id_profesional;

/*3. Contar la cantidad de atenciones por profesional.*/
SELECT COUNT(a.id_profesional) AS 'Cantidad de atenciones', p.nombre AS 'Nombre del profesional'
FROM atencion a INNER JOIN profesional p
ON a.id_profesional = p.id_profesional
GROUP BY p.id_profesional, p.nombre;

/*4. Actualizar la dirección de un dueño (por ejemplo, cambiar la dirección de Juan Pérez).*/
/*UPDATE dueno
SET direccion = 'Dirección Nueva 1'
WHERE nombre LIKE '%Juan P%rez%'; /*asumiendo que no sé el id, pero parece que hay alguna configuración de protección*/

UPDATE dueno
SET direccion = 'Dirección Nueva 2'
WHERE id_dueno = 1;

/*5. Eliminar una atención (por ejemplo, atención con id 2).*/
DELETE FROM atencion
WHERE id_atencion = 2;

/*6. Realizar una transacción para agregar una nueva mascota, atención y actualización de información.*/
DELIMITER $$
CREATE PROCEDURE registra_atencion_mascota (
    
	/*datos del dueño por si hay que crearlos*/
    IN p_nombre_dueno VARCHAR(100),
	IN p_direccion_dueno VARCHAR(200),
	IN p_telefono_dueno VARCHAR(20),

	/*datos de la mascota por si hay que crearlos*/
    IN p_nombre_mascota VARCHAR(100),
    IN p_tipo_mascota VARCHAR(50),
    IN p_fecha_nac_mascota DATE,

    /*datos de la atención*/
    IN p_fecha_atencion DATE,
    IN p_descripcion_atencion TEXT
)

BEGIN
	DECLARE v_id_dueno INT DEFAULT NULL;
    DECLARE v_id_mascota INT DEFAULT NULL;
    DECLARE v_id_profesional INT DEFAULT NULL;
	DECLARE v_id_atencion INT DEFAULT NULL;

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Error, atención cancelada' AS mensaje;
    END;

    START TRANSACTION;

	/*Si el dueño no existe, entonces crearlo*/
    SELECT id_dueno INTO v_id_dueno
    FROM dueno
    WHERE nombre = p_nombre_dueno AND direccion = p_direccion_dueno AND telefono = p_telefono_dueno;
    
    IF v_id_dueno IS NULL THEN
		INSERT INTO dueno (nombre, direccion, telefono)
        VALUES (p_nombre_dueno, p_direccion_dueno, p_telefono_dueno);
        SET v_id_dueno = LAST_INSERT_ID();
	END IF;

	/*Si la mascota no existe, entonces crearla*/
    SELECT id_mascota INTO v_id_mascota
    FROM mascota
    WHERE nombre = p_nombre_mascota AND id_dueno = v_id_dueno;

    IF v_id_mascota IS NULL THEN
        /*Crear mascota*/
		INSERT INTO mascota (nombre, tipo, fecha_nacimiento, id_dueno)
		VALUES (p_nombre_mascota, p_tipo_mascota, p_fecha_nac_mascota, v_id_dueno);
		SET v_id_mascota = LAST_INSERT_ID();

        /*Como es mascota nueva, buscar cualquier profesional para asignarle en la atención*/
        SELECT id_profesional INTO v_id_profesional
        FROM profesional
        LIMIT 1;/*el primero de la lista que encuentra, da lo mismo cual*/
        
    ELSE /*la mascota si existe entonces buscar el profesional que la atendió la última vez*/

		SELECT id_profesional INTO v_id_profesional
		FROM atencion /*busca en atención el profesional*/
		WHERE id_mascota = v_id_mascota /*asignado a la mascota que tenemos*/
		ORDER BY fecha_atencion DESC 
		LIMIT 1;/*la más reciente atención a esa mascota, primer registro*/

        IF v_id_profesional IS NULL THEN /*si esa mascota existente no tiene profesional asignado*/
            SELECT id_profesional INTO v_id_profesional /*se le asigna cualquiera*/
            FROM profesional
            LIMIT 1;
        END IF;

	END IF;

	/*Crear atención*/
	INSERT INTO atencion (fecha_atencion, descripcion, id_mascota, id_profesional)
	VALUES (p_fecha_atencion, p_descripcion_atencion, v_id_mascota, v_id_profesional);

    COMMIT;

    SELECT 'Atención registrada correctamente' AS mensaje;

END $$

DELIMITER ;


/* CALL (p_nombre_dueno,p_direccion_dueno,p_telefono_dueno,
		p_nombre_mascota,p_tipo_mascota,p_fecha_nac_mascota,
        p_fecha_atencion,p_descripcion_atencion)*/
        
/*DUEÑO Y MASCOTA NUEVO*/
CALL registra_atencion_mascota('Juanin Juan Harry','Calle Calle 13','123456',
								'Zuko','Gato','2024-11-01',
                                '2026-02-11','Primer control');
                                
/*DUEÑO EXISTENTE Y MASCOTA NUEVA*/
CALL registra_atencion_mascota('Juanin Juan Harry','Calle Calle 13','123456',
								'Elune', 'Conejo', '2025-06-15',
								'2026-02-18', 'Vacuna anual');