--Vistas

--Vista de items con sus respectivas tiendas
ALTER VIEW ArticulosEnTiendas
AS 
SELECT t.id_tienda as 'idTienda', t.cant_slots as 'Slots', t.nombre as 'Nombre Tienda',i.nombre as 'Articulo',c.titulo_categoria as 'Categoria',ti.precio,ti.cantidad
FROM tiendas_items ti
INNER JOIN items i
ON ti.id_item = i.id_item
INNER JOIN tiendas t 
ON ti.id_tienda = t.id_tienda
INNER JOIN categorias c
ON i.id_categoria = c.id_categoria
--WHERE t.id_tienda = 1
GO 

--Procedimientos

--Comprobar disponibilidad de slots de la tienda para ingresar items en la misma
CREATE FUNCTION ComprobarSlots(@Idt as int)
RETURNS int
AS 
BEGIN
   DECLARE @retval int
   SELECT @retval = (SELECT cant_slots FROM tiendas where id_tienda = @Idt) - (SELECT COUNT(*) FROM ArticulosEnTiendas WHERE ArticulosEnTiendas.idTienda = @Idt)
   RETURN @retval
END;
GO

--Vista de los personajes de las cuenta
CREATE VIEW CuentaPersonajes
AS 
SELECT pe.id_usuario, pe.id_personaje, pe.nombre_personaje, cl.nombre_clase as 'Clase'
FROM personajes pe
INNER JOIN clases cl
ON pe.id_clase = cl.id_clase
GO
--Vista de los personajes de en las cuenta con sus detalles
CREATE VIEW CuentaPersonajesDetalles
AS
SELECT pe.id_usuario, pe.id_personaje,cp.nombre_personaje,cp.Clase,es.nivel,es.experiencia,pe.oro,pe.mana,es.vida,es.fuerza,es.agilidad,es.magia
FROM personaje_estadistica pe
INNER JOIN estadisticas es
ON pe.id_estadistica = es.id_estadistica
INNER JOIN CuentaPersonajes cp 
ON pe.id_personaje = cp.id_personaje
GO

select * from CuentaPersonajes 
select * from CuentaPersonajesDetalles

--INSTANCIA LAS ESTADISTICAS POR DEFAULT AL MOMENTO DE CREAR UN NUEVO PERSONAJE
--Mago
	--Fuerza 25
	--Agilidad 50
	--Magia 100
--Guerrero
	--Fuerza 100
	--Agilidad 50
	--Magia 0
--Arquero
	--Fuerza 50
	--Agilidad 100
	--Magia 0
GO
CREATE TRIGGER InstanciarEstadisticas
ON personajes FOR INSERT AS
BEGIN 
	DECLARE @idUsuario INT
	DECLARE @IdPersonaje INT
	DECLARE @idClase int
	DECLARE @IdEstadistica INT
	SELECT @idUsuario = INSERTED.id_usuario
	FROM INSERTED
	SELECT @IdPersonaje = INSERTED.id_personaje
	FROM INSERTED

	--Instanciar una estadistica
	IF (SELECT INSERTED.id_clase from INSERTED) = 1
		INSERT INTO estadisticas(vida,nivel,experiencia,fuerza,agilidad,magia) VALUES (100,0,0,50,100,0);
	ELSE IF (SELECT INSERTED.id_clase from INSERTED) = 2
		INSERT INTO estadisticas(vida,nivel,experiencia,fuerza,agilidad,magia) VALUES (100,0,0,100,50,0);
	ELSE IF (SELECT INSERTED.id_clase from INSERTED) = 3
		INSERT INTO estadisticas(vida,nivel,experiencia,fuerza,agilidad,magia) VALUES (100,0,0,50,100,0);
	--Almaceno el id de la estadistica 
	SELECT @IdEstadistica = id_estadistica FROM estadisticas WHERE id_estadistica=(SELECT max(id_estadistica) FROM estadisticas);
	--Instaciar personaje_estadistica

	INSERT INTO personaje_estadistica(id_usuario,id_personaje,id_estadistica,oro,mana) VALUES (@idUsuario,@IdPersonaje,@IdEstadistica,100,100);
END
GO


--CK_Personaje_Items...
--Un personaje no puede tener en su inventario un item que no pertenezca a su categoria


--CK_StockItem_Tienda...
--Control de stock de los items en la tienda(cantidad disponible)


--DF_Estadisticas_Segun_ClasePersonaje
--Valores por defecto al crear un personaje, dependiendo la clase del mismo


--Vista personajes y NPCS en mapa
GO 
CREATE VIEW npcsView
AS
SELECT np.id_npc,tp.nombre_tipo,np.nombre_npc,np.estatico
FROM npcs np
INNER JOIN npcs_tipos tp
ON np.id_tipo = tp.id_tipo
GO
--select * from npcsView
CREATE VIEW npcsBoss
AS
Select * from npcsView WHERE nombre_tipo='Boss' 
GO
Select * from npcsBoss
--Vista personajes en una cuenta

--Vista NPCS BOSS


--Vista personajes conectados

--Vista Items con sus estadisticas
--Listado de todos los items con sus estadisticas y categorias

--Vista Inventario Personaje
----Listado de todos los items en el inventario del pesonaje con sus estadisticas y categorias 
--(se puede utilizar la vista de items) y filtar 

--CK_NivelMax
--Nivel maximo del personaje (100)

--Estado en cuenta (Eliminacion Logica)
--Agregar como atributo en cuenta
--estado bit 

--Vista de cuentas activas o Eliminadas
--Vista Activos
	--where estado = 1
--Vista No Activos
	--where estado = 0

--Estado Online en Personaje
--estado_online bit
--Vista Activos
	--where estado = 1
--Vista No Activos
	--where estado = 0

--DF_EstadoActivoCuenta
--Estado activo en cuenta

--DF_SlotInventario
--Cantidad de espacio disponible (5)


--Temas técnicos de trabajo

--Transacciones 
--Pasos para la compra
	--Control de stock en la tienda...
	--Espacio libre en Inventario personaje
	--Oro mayor al total...

--Si la compra se realizo correctamente...
--Triggers
	--Descontar Stock en Tienda
		--Si cantidad de items en tienda es 0 se elimina de la tienda
	--Descontar Oro
	--Aumentar el espacio en inventario y se agrega el item


--Vistas. (completo)

--Permisos. 
--Admin (MANEJO DE TABLAS (CREAR - ELIMINAR - ACTUALIZAR)
--DEV (READ - AGREGAR REGISTROS - ACTUALIZAR REGISTROS)
--

--Manejo de datos multimediales en bases de datos relacionales
--Imagen de Perfil en Cuenta (Insertar enlace como imagen)
--https://cloudinary.com/
--Agregar url_imagenPerfil en cuenta (String)

--Backup y restauración.
-- Backup diarios de algunas tablas y uno semanal de la base completa



--COSAS POR HACER

--CREAR TABLAS COMPRA Y DETALLE
-- Realizar la transaccion con los triggers

--Añadir atributo eliminaciones logicas en Cuenta y Personaje
--Generar vistas de activos en Cuenta y Personaje
--DF_EstadoActivoCuenta

--Generar vistas (Ya se pueden realizar)
--Vista personajes y NPCS en mapa
--Vista personajes en una cuenta
--Vista NPCS BOSS
--Vista Items con sus estadisticas
--Vista Inventario Personaje


--CHECKS
--CK_NivelMax
--CK_Personaje_Items
--CK_StockItem_Tienda
--DF_SlotInventario
--DF_Estadisticas_Segun_ClasePersonaje


--Manejo de datos multimediales en bases de datos relacionales
--Imagen de Perfil en Cuenta (Insertar enlace como imagen)
	--Agregar url_imagenPerfil en cuenta (String)

--Backup y restauración.
-- Backup diarios de algunas tablas y uno semanal de la base completa



--COMPLETAR EL INFORME

--CAPITULO I
	--c. Objetivo del Trabajo Práctico.
		--Responde a la pregunta ¿para qué realizo el Trabajo Práctico? ¿Qué puede esperar el lector
		--del trabajo que voy a realizar? En este nivel se deben especificar los
		--i. Objetivos Generales.
		--Resultado general esperado con el trabajo. El objetivo general debe
		--responder al Problema principal.
		--ii. Objetivos Específicos.
		--Resultados particulares esperados. Guardan relación con las preguntas
		--expresadas al inicio del Capítulo. 
--CAPITULO II
--(Marco teórico. Acá se debe explicar brevemente los conceptos sobre los temas técnicos de los motores de bases de datos que se asignó a cada grupo)

--CAPITULO III
--(metodología / herramientas)


	--Metodologia
		--Descripción de cómo se realizó el Trabajo Práctico.
	--Herramientas
		--Motor de base datos (todo lo relacionado)
		--Git
		--Github
--CAPITULO IV
--Entidades
--(descripción de las tablas)

--Diccionario de datos
--(descripción de los atributos de cada tabla)
