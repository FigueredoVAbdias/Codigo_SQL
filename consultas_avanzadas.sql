-- CANTIDAD TOTAL DE TANQUES ARRENDADOS A CLIENTE CON CONTRATO VIGENTE
SELECT 
	COUNT(e.cod_equ) as 'Cantidad de tanques', 
	sc.n_com as 'Cliente' 
FROM EQUIPO e 
	INNER JOIN TANQUE t ON e.cod_equ = t.cod_tk 
	INNER JOIN CONTRATO c ON c.cod_con = e.cod_con 
	INNER JOIN SUB_CLIENTE sc ON sc.id_scliente = c.id_scliente 
WHERE c.estado ='VIGENTE'
GROUP BY sc.n_com 
ORDER BY COUNT(e.cod_equ) DESC
----------------------------------------------------------------------------------------
-- CANTIDAD TOTAL DE TANQUES PROPIEDAD DE YPFB ARRENDADOS A CLIENTE CON CONTRATO VIGENTE
SELECT 
	COUNT(e.cod_equ) as 'Cantidad de tanques', 
	sc.n_com as 'Cliente' 
FROM EQUIPO e 
	INNER JOIN TANQUE t ON e.cod_equ = t.cod_tk 
	INNER JOIN CONTRATO c ON c.cod_con = e.cod_con 
	INNER JOIN SUB_CLIENTE sc ON sc.id_scliente = c.id_scliente 
WHERE c.estado ='VIGENTE' and 
	e.propiedad ='YPFB'
GROUP BY sc.n_com 
ORDER BY sc.n_com  
----------------------------------------------------------------------------------------
-- CANTIDAD TOTAL DE TANQUES PROPIEDAD DE CLIENTE CON CONTRATO VIGENTE
SELECT 
	COUNT(e.cod_equ) as 'Cantidad de tanques', 
	sc.n_com as 'Cliente' 
FROM EQUIPO e 
	INNER JOIN TANQUE t ON e.cod_equ = t.cod_tk 
	INNER JOIN CONTRATO c ON c.cod_con = e.cod_con 
	INNER JOIN SUB_CLIENTE sc ON sc.id_scliente = c.id_scliente 
WHERE c.estado ='VIGENTE' and 
	e.propiedad ='CLIENTE'	
GROUP BY sc.n_com 
ORDER BY sc.n_com  
----------------------------------------------------------------------------------------
-- CANTIDAD TOTAL DE VAPORIZADORES ARRENDADOS A CLIENTE CON CONTRATO VIGENTE
SELECT 
	COUNT(e.cod_equ) as 'Cantidad de tanques', 
	sc.n_com as 'Cliente' 
FROM EQUIPO e 
	INNER JOIN VAPORIZADOR v ON e.cod_equ = v.cod_vap 
	INNER JOIN CONTRATO c ON c.cod_con = e.cod_con 
	INNER JOIN SUB_CLIENTE sc ON sc.id_scliente = c.id_scliente 
WHERE c.estado ='VIGENTE'
GROUP BY sc.n_com 
ORDER BY COUNT(e.cod_equ) DESC
----------------------------------------------------------------------------------------
--CLIENTE CON LA MAXIMA CANTIDAD DE EQUIPOS ARRENDADOS
SELECT 
	COUNT(*),cod_con 
FROM EQUIPO
GROUP BY cod_con 

SELECT 
	sc.n_com, 
	s1.cantidad, 
	c.estado
FROM CONTRATO c
	INNER JOIN SUB_CLIENTE sc ON sc.id_scliente = c.id_scliente
	INNER JOIN (SELECT 
					COUNT(*) as 'cantidad' ,
					c.cod_con 
				FROM EQUIPO e INNER JOIN CONTRATO c ON c.cod_con = e.cod_con
				WHERE c.estado='vigente'
				GROUP BY c.cod_con)s1
	ON s1.cod_con = c.cod_con 
WHERE 
	c.estado = 'vigente' and 
	s1.cantidad = (
					SELECT MAX(s2.cantidad)
					FROM(
						SELECT 
							COUNT(*) as 'cantidad',
							c.cod_con 
						FROM EQUIPO e INNER JOIN CONTRATO c ON c.cod_con = e.cod_con
						WHERE c.estado='vigente'
						GROUP BY c.cod_con)s2)
-----------------------------------------------------------------------------------------
--CLIENTE CON LA MINIMA CANTIDAD DE EQUIPOS ARRENDADOS
SELECT COUNT(*),cod_con 
FROM EQUIPO
GROUP BY cod_con 

SELECT 
	sc.n_com, 
	s1.cantidad, 
	c.estado
FROM CONTRATO c
	INNER JOIN SUB_CLIENTE sc ON sc.id_scliente = c.id_scliente
	INNER JOIN (SELECT COUNT(*) as 'cantidad' ,c.cod_con 
				FROM EQUIPO e INNER JOIN CONTRATO c ON c.cod_con = e.cod_con
				WHERE c.estado='vigente'
				GROUP BY c.cod_con)s1
	ON s1.cod_con = c.cod_con 
WHERE 
	c.estado = 'vigente' and 
	s1.cantidad = (
					SELECT MIN(s2.cantidad)
					FROM(
						SELECT COUNT(*) as 'cantidad',c.cod_con 
						FROM EQUIPO e INNER JOIN CONTRATO c ON c.cod_con = e.cod_con
						WHERE c.estado='vigente'
						GROUP BY c.cod_con)s2)
-----------------------------------------------------------------------------------------
----CLIENTE CON LA MAXIMA CANTIDAD DE TANQUES ARRENDADOS PROPIEDAD DE YPFB
SELECT sc.n_com, s1.cantidad, c.estado, s1.propiedad
FROM CONTRATO c
	INNER JOIN SUB_CLIENTE sc ON sc.id_scliente = c.id_scliente
	INNER JOIN (SELECT COUNT(*) as 'cantidad',c.cod_con, e.propiedad
				FROM EQUIPO e 
					INNER JOIN TANQUE t ON e.cod_equ=t.cod_tk
					INNER JOIN CONTRATO c ON c.cod_con = e.cod_con
					WHERE c.estado='vigente' 
					GROUP BY c.cod_con,e.propiedad)s1
	ON s1.cod_con = c.cod_con 
WHERE 
	c.estado = 'vigente' and
	s1.cantidad = (
					SELECT MAX(s2.cantidad)
					FROM(
						SELECT COUNT(*) as 'cantidad',c.cod_con, e.propiedad
						FROM EQUIPO e 
							INNER JOIN TANQUE t  ON e.cod_equ=t.cod_tk
							INNER JOIN CONTRATO c ON c.cod_con = e.cod_con
							WHERE c.estado='vigente'
							GROUP BY c.cod_con,e.propiedad)s2)
-----------------------------------------------------------------------------------------
--CLIENTE CON MAXIMA MONTO DE GARANTIA
SELECT MAX(monto) 
FROM GARANTIA

SELECT sc.n_com , g.monto, c.estado 
FROM SUB_CLIENTE sc 
	INNER JOIN CONTRATO c ON sc.id_scliente = c.id_scliente 
	INNER JOIN GARANTIA g ON c.cod_con = g.cod_con 
WHERE c.estado = 'vigente' and
		g.monto = (SELECT MAX(monto) 
		FROM GARANTIA g INNER JOIN CONTRATO c ON g.cod_con=c.cod_con
		WHERE c.estado ='vigente')
-----------------------------------------------------------------------------------------			
--CLIENTE CON MINIMO MONTO DE GARANTIA
SELECT MIN(monto) 
FROM GARANTIA

SELECT sc.n_com , g.monto, c.estado 
FROM SUB_CLIENTE sc 
	INNER JOIN CONTRATO c ON sc.id_scliente = c.id_scliente 
	INNER JOIN GARANTIA g ON c.cod_con = g.cod_con 
WHERE c.estado = 'vigente' and
		g.monto = (SELECT MIN(monto) 
		FROM GARANTIA g INNER JOIN CONTRATO c ON g.cod_con=c.cod_con
		WHERE c.estado ='vigente')
-----------------------------------------------------------------------------------------
--CANTIDAD DE CONTRATOS VIGENTES POR CLIENTE
SELECT COUNT(*),cod_con 
FROM CONTRATO
GROUP BY cod_con 	

SELECT c.id_cliente ,c.r_soc, s1.cantidad_de_contratos
FROM CLIENTE c
	INNER JOIN (SELECT COUNT(*) as cantidad_de_contratos ,id_cliente
				FROM SUB_CLIENTE sc INNER JOIN CONTRATO co ON co.id_scliente=sc.id_scliente
				WHERE co.estado='vigente'
				GROUP BY id_cliente)s1
	ON s1.id_cliente= c.id_cliente 
ORDER BY s1.cantidad_de_contratos DESC 
------------------------------------------------------------------------------------------
--CLIENTES PERSONAL NATURAL CON CONTRATO VIGENTE
SELECT DISTINCT 
	sc.id_scliente as 'Codigo',
	sc.n_com as 'Nombre comercial',
	c.unid as 'Tipo de unidad económica',
	sc.cel_ofic as 'Celular de Oficina', 
	s1.direc as 'Dirección de Oficina o Planta',  
	sc.cel_plant as 'Celular de Planta', 
	s2.direc as 'Dirección de Planta',
	p.n_completo as 'Nombre completo representante legal',
	p.cel as 'celular representante legal'
FROM CLIENTE c 
	INNER JOIN SUB_CLIENTE sc ON c.id_cliente=sc.id_cliente
	INNER JOIN CONTRATO co ON co.id_scliente=sc.id_scliente
	INNER JOIN (SELECT t.id_scliente, p.n_completo, p.cel 
				FROM TIENE t 
				INNER JOIN PERSONAL p ON p.id_persona=t.id_persona
				INNER JOIN REP_LEGAL rl ON rl.id_rep=p.id_persona
				GROUP BY t.id_scliente,p.n_completo, p.cel)s3
	ON t.id_scliente=sc.id_scliente
	LEFT JOIN (SELECT su.id_scliente, u.direc, u.cat
				FROM SE_UBICA su INNER JOIN UBICACION u ON u.id_ubic=su.id_ubic
				WHERE u.cat='OFICINA/PLANTA' or u.cat='OFICINA')s1
	ON s1.id_scliente=sc.id_scliente
	LEFT JOIN (SELECT su.id_scliente, u.direc, u.cat
				FROM SE_UBICA su INNER JOIN UBICACION u ON u.id_ubic=su.id_ubic
				WHERE u.cat='PLANTA')s2
	ON s2.id_scliente=sc.id_scliente
WHERE
	co.estado='Vigente' and
	c.unid IN ('PERSONA NATURAL','EMPRESA UNIPERSONAL','FUNDACION')
------------------------------------------------------------------------------------------
SELECT DISTINCT sc.n_com, c.unid, sc.cel_ofic, sc.cel_plant
FROM CLIENTE c 
	INNER JOIN SUB_CLIENTE sc ON c.id_cliente=sc.id_cliente
	INNER JOIN CONTRATO co ON co.id_scliente=sc.id_scliente
WHERE
	co.estado='Vigente' and
	c.unid IN ('PERSONA NATURAL','EMPRESA UNIPERSONAL','FUNDACION')
------------------------------------------------------------------------------------------
--CLIENTES CON TANQUES DE 7M3 CON CONTRATO VIGENTE
SELECT DISTINCT sc.n_com--,t.cod_tk,t.cap
FROM SUB_CLIENTE sc 
	INNER JOIN CONTRATO co ON co.id_scliente=sc.id_scliente
	INNER JOIN EQUIPO e ON e.cod_con=co.cod_con
	INNER JOIN TANQUE t ON t.cod_tk = e.cod_equ
WHERE 
	--co.estado='Vigente' and
	t.cap <4
--ORDER BY t.cap DESC 
------------------------------------------------------------------------------------------
--CLIENTES CON TANQUES DE 4 CON CONTRATO VIGENTE
SELECT DISTINCT sc.id_scliente,c.unid ,sc.n_com--,t.cod_tk,t.cap
FROM CLIENTE c 
	INNER JOIN SUB_CLIENTE sc ON c.id_cliente=sc.id_cliente
	INNER JOIN CONTRATO co ON co.id_scliente=sc.id_scliente
	INNER JOIN EQUIPO e ON e.cod_con=co.cod_con
	INNER JOIN TANQUE t ON t.cod_tk = e.cod_equ
WHERE t.cap >3
--ORDER BY t.cap DESC 
------------------------------------------------------------------------------------------
