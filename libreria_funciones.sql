--LIBRERIA DE FUNCIONES
-- FUNCION CALCULO DE EDAD DE LOS REPRESENTANTES LEGALES DE CLIENTES
CREATE OR ALTER FUNCTION calc_edad(@fecha_naci date) RETURNS INT
	AS
		BEGIN
			DECLARE @edad INT
			SET @edad = DATEPART(YEAR, GETDATE()) - DATEPART(YEAR, @fecha_naci)
			RETURN @edad
		END
--exe
	SELECT r.*, dbo.calc_edad(fecha_naci) as edad
	FROM REP_LEGAL r
---------------------------------------------------------------------------------------
--FUNCION DESPLIEGA REPRESENTANTES LEGALES DE EMPRESAS CLIENTES VIGENTES:
CREATE OR ALTER FUNCTION rep_legalxcliente(@id_scliente VARCHAR(50)) RETURNS VARCHAR(500)
	AS 
		BEGIN
			DECLARE @rep_legal VARCHAR(500);
			SELECT @rep_legal = p.n_completo
			FROM SUB_CLIENTE sc
				INNER JOIN TIENE t ON sc.id_scliente = t.id_scliente 
				INNER JOIN PERSONAL p ON p.id_persona = t.id_persona
				INNER JOIN REP_LEGAL r ON p.id_persona = r.id_rep
			WHERE 
				sc.id_scliente=@id_scliente;
			RETURN @rep_legal;
		END
--exe
SELECT 
	sc.n_com, 
	dbo.rep_galxcliente(sc.id_scliente) AS representante_legal
FROM SUB_CLIENTE sc 
---------------------------------------------------------------------------------------
--FUNCION DE CALCULO DE LA CANTIDAD DE REPRESENTANTES LEGALES DE GENERO MASCULINOS, FEMENINOS Y EL TOTAL
CREATE OR ALTER FUNCTION calc_sex(@sex int) RETURNS INT
	AS 
	BEGIN
		DECLARE @cantidad int
	
	IF @sex=0
		SELECT @cantidad = count(*)
		FROM REP_LEGAL
		WHERE sex='F';
	ELSE
		IF @sex=1
			SELECT @cantidad = count(*)
			FROM REP_LEGAL
			WHERE sex='M';
		ELSE
			SELECT @cantidad = count(*)
			FROM REP_LEGAL
	
	RETURN @cantidad;
	END;
--exe
SELECT dbo.calc_sex(0) as Cantidad_Femenino, dbo.calc_sex(1) as Cantidad_Masculino, dbo.calc_sex(0) + dbo.calc_sex(1) as Total_Representante_Legal
--exe
SELECT (SELECT COUNT(*)
		FROM REP_LEGAL
		WHERE sex ='F')Cantidad_Femenino,
		(SELECT COUNT(*)
		FROM REP_LEGAL
		WHERE sex ='M')Cantidad_Masculino,
		(SELECT COUNT(*)
		FROM REP_LEGAL)Cantidad_Total
---------------------------------------------------------------------------------------
--FUNCION CANTIDAD DE TANQUES Y CAPACIDAD M3 TOTAL POR SUB CLIENTE CON CONTRATO VIGENTE
--F1
CREATE OR ALTER FUNCTION qtanques_x_sub_cliente(@id_scliente VARCHAR(50)) RETURNS INT
	AS 
		BEGIN
			DECLARE @cantidad int;
			SELECT @cantidad=COUNT(t.cod_tk)
			FROM SUB_CLIENTE sc
			INNER JOIN CONTRATO c ON sc.id_scliente=c.id_scliente
			INNER JOIN EQUIPO e ON e.cod_con=c.cod_con
			INNER JOIN TANQUE t ON e.cod_equ=t.cod_tk
			WHERE 
				sc.id_scliente=@id_scliente;	
			IF @cantidad IS NULL 
			RETURN 0;
			
			RETURN @cantidad;
		END
--F2
CREATE OR ALTER FUNCTION totalcap_tk(@id_scliente VARCHAR(50)) RETURNS FLOAT
	AS 
		BEGIN
			DECLARE @total_cap FLOAT;
			SELECT @total_cap=SUM(t.cap)
			FROM SUB_CLIENTE sc
			INNER JOIN CONTRATO c ON sc.id_scliente=c.id_scliente
			INNER JOIN EQUIPO e ON e.cod_con=c.cod_con
			INNER JOIN TANQUE t ON e.cod_equ=t.cod_tk
			WHERE 
				sc.id_scliente=@id_scliente;
			IF @total_cap IS NULL 
			RETURN 0;

			RETURN @total_cap;
		END
--exe
SELECT 
	sc.id_scliente,
	sc.n_com,dbo.qtanques_x_sub_cliente(sc.id_scliente) Cantidad_de_tanques, 
	dbo.totalcap_tk(sc.id_scliente)total_cap
FROM SUB_CLIENTE sc 
	INNER JOIN CONTRATO c ON sc.id_scliente=c.id_scliente
WHERE c.estado='vigente'
ORDER BY dbo.totalcap_tk(sc.id_scliente) DESC
---------------------------------------------------------------------------------------
--FUNCION DE CALCULO DE TOTAL DE REPRESENTANTES LEGALES POR GENERO Y POR CLIENTE CON CONTRATO VIGENTE
CREATE OR ALTER FUNCTION q_rep_legal_x_cliente(@id_scliente VARCHAR(50),@sex_rep_legal INT) RETURNS INT
	AS 
		BEGIN
			DECLARE @cantidad INT;
		
		IF @sex_rep_legal=0
				SELECT @cantidad = count(r.id_rep)
				FROM SUB_CLIENTE sc
					INNER JOIN CONTRATO c ON sc.id_scliente=c.id_scliente
					INNER JOIN TIENE t ON sc.id_scliente = t.id_scliente 
					INNER JOIN PERSONAL p ON p.id_persona = t.id_persona
					INNER JOIN REP_LEGAL r ON p.id_persona = r.id_rep
				WHERE
					c.estado='vigente' and
					sex='F' and
					sc.id_scliente=@id_scliente;	
			ELSE
				IF @sex_rep_legal=1
				SELECT @cantidad = count(r.id_rep)
				FROM SUB_CLIENTE sc
					INNER JOIN CONTRATO c ON sc.id_scliente=c.id_scliente
					INNER JOIN TIENE t ON sc.id_scliente = t.id_scliente 
					INNER JOIN PERSONAL p ON p.id_persona = t.id_persona
					INNER JOIN REP_LEGAL r ON p.id_persona = r.id_rep
				WHERE 
					c.estado='vigente' and
					sex='M' and
					sc.id_scliente=@id_scliente;
				ELSE
					IF @sex_rep_legal=2
				SELECT @cantidad = count(r.id_rep)
				FROM SUB_CLIENTE sc
					INNER JOIN CONTRATO c ON sc.id_scliente=c.id_scliente
					INNER JOIN TIENE t ON sc.id_scliente = t.id_scliente 
					INNER JOIN PERSONAL p ON p.id_persona = t.id_persona
					INNER JOIN REP_LEGAL r ON p.id_persona = r.id_rep
				WHERE
					c.estado='vigente' and
					sc.id_scliente=@id_scliente;

			RETURN @cantidad;
		END
--exe
SELECT DISTINCT 
	sc.id_scliente,
	sc.n_com, 
	dbo.q_rep_legal_x_cliente(id_scliente,0) representante_legal_femenino,
	dbo.q_rep_legal_x_cliente(id_scliente,1) representante_legal_masculino,
	dbo.q_rep_legal_x_cliente(id_scliente,2) representante_legal_total
FROM SUB_CLIENTE sc
WHERE dbo.q_rep_legal_x_cliente(id_scliente,2)<>0
---------------------------------------------------------------------------------------

