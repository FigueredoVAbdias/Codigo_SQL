--PROCEDIMIENTO DE FICHA POR CLIENTE
CREATE OR ALTER PROCEDURE f_cliente
	@xcod_cliente varchar (500),
	@r_social varchar(500) OUTPUT,
	@rep_legal varchar(500) OUTPUT,
	@celular varchar(500) OUTPUT,
	@q_contrato int OUTPUT
AS	
	BEGIN

		SELECT @r_social=r_soc
		FROM CLIENTE
		WHERE @xcod_cliente = id_cliente;

		SELECT @rep_legal= p.n_completo
		FROM CLIENTE c
			INNER JOIN SUB_CLIENTE sc ON sc.id_cliente=c.id_cliente
			INNER JOIN TIENE t ON sc.id_scliente = t.id_scliente 
			INNER JOIN PERSONAL p ON p.id_persona = t.id_persona
			INNER JOIN REP_LEGAL r ON p.id_persona = r.id_rep
		WHERE @xcod_cliente = c.id_cliente;

		SELECT @celular= p.cel
		FROM CLIENTE c
			INNER JOIN SUB_CLIENTE sc ON sc.id_cliente=c.id_cliente
			INNER JOIN TIENE t ON sc.id_scliente = t.id_scliente 
			INNER JOIN PERSONAL p ON p.id_persona = t.id_persona
			INNER JOIN REP_LEGAL r ON p.id_persona = r.id_rep
		WHERE @xcod_cliente = c.id_cliente;
		
		SELECT @q_contrato=COUNT(co.cod_con)
		FROM CLIENTE c
			INNER JOIN SUB_CLIENTE sc ON sc.id_cliente=c.id_cliente
			INNER JOIN CONTRATO co ON co.id_scliente=sc.id_scliente
		WHERE @xcod_cliente = c.id_cliente AND co.estado='VIGENTE';


	END

--EXE
DECLARE
	@xcod_cliente varchar (500),
	@xr_social varchar(500),
	@xrep_legal varchar(500),
	@xcelular varchar(500),
	@xq_contrato varchar(500);

	SET @xcod_cliente='YPFB-UGLP-H-001';
	EXEC dbo.f_cliente 
		@xcod_cliente=@xcod_cliente,
		@r_social=@xr_social OUTPUT,
		@rep_legal=@xrep_legal OUTPUT,
		@celular=@xcelular OUTPUT,
		@q_contrato=@xq_contrato OUTPUT;

PRINT 'COD_CLIENTE: '+@xcod_cliente+'		'+@xr_social;
PRINT 'REPRESENTANTE LEGAL:				'+@xrep_legal;
PRINT 'CELULAR:							'+@xcelular;
PRINT 'CANTIDAD DE CONTRATOS VIGENTES:		'+@xq_contrato;

---------------------------------------------------------------------------------
--PROCEDIMIENTO PARA EL CALCULO DE EDAD DE REPRESENTANTES LEGALES
CREATE OR ALTER PROCEDURE calculo_edad
AS
    BEGIN
        UPDATE REP_LEGAL 
		SET edad = DATEPART(YEAR, GETDATE()) - DATEPART(YEAR, fecha_naci);
    END;

EXECUTE calculo_edad;

SELECT *
FROM REP_LEGAL
ORDER BY 4 DESC;
---------------------------------------------------------------------------------
----PROCEDIMIENTO (CON FUNCIONES) DE FICHA POR CLIENTE
CREATE OR ALTER PROCEDURE f_cliente_F
	@xcod_cliente varchar (500),
	@r_social varchar(500) OUTPUT,
	@celular varchar(500) OUTPUT
AS	
	BEGIN
		SELECT @r_social=r_soc
		FROM CLIENTE
		WHERE @xcod_cliente = id_cliente;

		SELECT @celular= p.cel
		FROM CLIENTE c
			INNER JOIN SUB_CLIENTE sc ON sc.id_cliente=c.id_cliente
			INNER JOIN TIENE t ON sc.id_scliente = t.id_scliente 
			INNER JOIN PERSONAL p ON p.id_persona = t.id_persona
			INNER JOIN REP_LEGAL r ON p.id_persona = r.id_rep
		WHERE @xcod_cliente = c.id_cliente;
	END

--EXE
DECLARE
	@xcod_cliente varchar (500),
	@xr_social varchar(500),
	@xcelular varchar(500);

	SET @xcod_cliente='YPFB-UGLP-L-001';
	EXEC dbo.f_cliente_F 
		@xcod_cliente=@xcod_cliente,
		@r_social=@xr_social OUTPUT,
		@celular=@xcelular OUTPUT;

PRINT 'COD_CLIENTE: '+@xcod_cliente+'		'+@xr_social;
PRINT 'REPRESENTANTE LEGAL:				'+dbo.rep_legalxcliente(@xcod_cliente);
PRINT 'CELULAR:							'+@xcelular;
---------------------------------------------------------------------------------
-- PROCEDIMIENTO PARA VISUALIZAR FICHA DE CLIENTES CON INFORMACION DE TANQUES ASIGNADOS
CREATE OR ALTER PROCEDURE f_sub_cliente
	@xid_scliente varchar (500),
	@n_com varchar(500) OUTPUT,
	@r_social varchar(500) OUTPUT,
	@rep_legal varchar(500) OUTPUT,
	@planta varchar(500) OUTPUT,
	@oficina varchar(500) OUTPUT,
	@contrato varchar(500) OUTPUT,
	@total_cap int OUTPUT,
	@observarcion varchar(500) OUTPUT
AS	
	BEGIN
		
		SELECT @n_com=n_com
		FROM SUB_CLIENTE
		WHERE @xid_scliente = id_scliente;
		
		SELECT @r_social=c.r_soc
		FROM SUB_CLIENTE sc INNER JOIN CLIENTE c ON c.id_cliente=sc.id_cliente
		WHERE @xid_scliente = id_scliente;

		SELECT @rep_legal= p.n_completo
		FROM CLIENTE c
			INNER JOIN SUB_CLIENTE sc ON sc.id_cliente=c.id_cliente
			INNER JOIN TIENE t ON sc.id_scliente = t.id_scliente 
			INNER JOIN PERSONAL p ON p.id_persona = t.id_persona
			INNER JOIN REP_LEGAL r ON p.id_persona = r.id_rep
		WHERE @xid_scliente = sc.id_scliente;

		SELECT @planta= u.direc
		FROM SUB_CLIENTE sc
		INNER JOIN SE_UBICA se ON sc.id_scliente=se.id_scliente
		INNER JOIN UBICACION u ON u.cod_ubic=se.cod_ubic
		WHERE @xid_scliente = sc.id_scliente AND u.cat='PLANTA';

		SELECT @oficina= u.direc
		FROM SUB_CLIENTE sc
		INNER JOIN SE_UBICA se ON sc.id_scliente=se.id_scliente
		INNER JOIN UBICACION u ON u.cod_ubic=se.cod_ubic
		WHERE @xid_scliente = sc.id_scliente AND u.cat IN ('OFICINA','OFICINA/PLANTA');

				SELECT @contrato=co.estado
		FROM CLIENTE c
			INNER JOIN SUB_CLIENTE sc ON sc.id_cliente=c.id_cliente
			INNER JOIN CONTRATO co ON co.id_scliente=sc.id_scliente
		WHERE @xid_scliente = sc.id_scliente;

		SELECT @total_cap=SUM(t.cap)
		FROM SUB_CLIENTE sc
			INNER JOIN CONTRATO c ON sc.id_scliente=c.id_scliente
			INNER JOIN EQUIPO e ON e.cod_con=c.cod_con
			INNER JOIN TANQUE t ON e.cod_equ=t.cod_tk
		WHERE @xid_scliente = c.id_scliente;

		IF @total_cap < 10
			SET @observarcion = 'CAPACIDAD TOTAL DE TANQUES NIVEL COMERCIAL';

		IF @total_cap >10
		 	SET @observarcion = 'CAPACIDAD TOTAL DE TANQUES NIVEL INDUSTRIAL';

		IF @total_cap IS NULL
		 	SET @observarcion = 'NO TIENE TANQUES INSTALADOS';

	END

--EXE
DECLARE
	@xid_scliente varchar (500),
	@xn_com varchar(500),
	@xr_social varchar(500),
	@xrep_legal varchar(500),
	@xplanta varchar(500),
	@xoficina varchar(500),
	@xcontrato varchar(500),
	@xtotal_cap INT,
	@xobservarcion varchar(500);

	SET @xid_scliente='YPFB-UGLP-COM-Y-001';
	EXEC dbo.f_sub_cliente 
		@xid_scliente=@xid_scliente,
		@n_com=@xn_com OUTPUT,
		@r_social=@xr_social OUTPUT,
		@rep_legal=@xrep_legal OUTPUT,
		@planta=@xplanta OUTPUT,
		@oficina=@xoficina OUTPUT,
		@contrato=@xcontrato OUTPUT,
		@total_cap=@xtotal_cap OUTPUT,
		@observarcion=@xobservarcion OUTPUT;

PRINT 'COD_CLIENTE:					'+@xid_scliente;
PRINT 'RAZON SOCIAL:					'+@xr_social;
PRINT 'NOMBRE COMERCIAL:				'+@xn_com;
PRINT 'REPRESENTANTE LEGAL:			'+@xrep_legal;
PRINT 'UBICACION DE PLANTA:			'+@xplanta;
PRINT 'UBICACION DE OFICINA O PLANTA:	'+@xoficina;
PRINT 'ESTADO DE CONTRATO:				'+@xcontrato;
PRINT 'CAPACIDAD TOTAL DE TANQUES:		'+CONVERT(VARCHAR(500),@xtotal_cap)+' CM3';
PRINT 'OBSERVACIONES:					'+@xobservarcion;
---------------------------------------------------------------------------------

