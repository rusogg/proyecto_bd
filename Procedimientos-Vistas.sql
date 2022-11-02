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
ALTER FUNCTION ComprobarSlots(@Idt as int)
RETURNS int
AS 
BEGIN
   DECLARE @retval int
   SELECT @retval = (SELECT cant_slots FROM tiendas where id_tienda = @Idt) - (SELECT COUNT(*) FROM ArticulosEnTiendas WHERE ArticulosEnTiendas.idTienda = @Idt)
   RETURN @retval
END;
GO