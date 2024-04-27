-- LISTADO DE CLIENTE CON FBUNCIONES
DECLARE list_cliente CURSOR FOR SELECT id_cliente, r_soc FROM CLIENTE ORDER BY r_soc;

DECLARE
	@xid_cliente varchar(500),
	@xr_soc varchar(500),
	@nro int;

OPEN list_cliente
	FETCH NEXT FROM list_cliente INTO @xid_cliente, @xr_soc
	 
	PRINT'				LISTADO DE CLIENTES';
	PRINT'===========================================================================================================================================';
	PRINT'NRO.	CODIGO DE CLIENTE		RAZON SOCIAL								REPRESENTANTE LEGAL					CANTIDAD DE CONTRATOS VIGENTES';
	PRINT'===========================================================================================================================================';
	SET @nro=0;
	 
	WHILE @@FETCH_STATUS=0
		BEGIN
			SET @nro=@nro+1;
			PRINT CONVERT(VARCHAR(500),@nro)+'		'+@xid_cliente+'			'+@xr_soc+'						'+dbo.rep_legalxcliente(@xid_cliente)+'									'+CONVERT(VARCHAR(500),dbo.q_contratoxcliente(@xid_cliente));
			FETCH NEXT FROM list_cliente INTO @xid_cliente, @xr_soc
		END

CLOSE list_cliente;
DEALLOCATE list_cliente;
--------------------------------------------------------------------------
---- LISTADO DE CLIENTE SIN FUNCIONES
DECLARE list_cliente CURSOR FOR SELECT DISTINCT c.id_cliente, c.r_soc, p.n_completo, COUNT(co.cod_con)
								FROM CLIENTE c
									INNER JOIN SUB_CLIENTE sc ON c.id_cliente=sc.id_cliente
									INNER JOIN CONTRATO co ON co.id_scliente=sc.id_scliente
									INNER JOIN TIENE t ON sc.id_scliente = t.id_scliente 
									INNER JOIN PERSONAL p ON p.id_persona = t.id_persona
									INNER JOIN REP_LEGAL r ON p.id_persona = r.id_rep
									WHERE co.estado='vigente'
									GROUP BY c.id_cliente, c.r_soc, p.n_completo
								ORDER BY c.r_soc;

DECLARE
	@xid_cliente varchar(500),
	@xr_soc varchar(500),
	@rep_legal varchar(500),
	@q_contrato int,
	@nro int;

OPEN list_cliente
	 FETCH NEXT FROM list_cliente INTO @xid_cliente, @xr_soc, @rep_legal, @q_contrato
	 
	 PRINT'				LISTADO DE CLIENTES';
	 PRINT'===========================================================================================================================================';
	 PRINT'NRO.	CODIGO DE CLIENTE		RAZON SOCIAL								REPRESENTANTE LEGAL					CANTIDAD DE CONTRATOS VIGENTES';
	 PRINT'===========================================================================================================================================';
	 SET @nro=0;
	 
	 WHILE @@FETCH_STATUS=0
	 BEGIN
		
		SET @nro=@nro+1;
		PRINT CONVERT(VARCHAR(500),@nro)+'		'+@xid_cliente+'			'+@xr_soc+'									'+@rep_legal+'														'+CONVERT(VARCHAR(500),@q_contrato);
		FETCH NEXT FROM list_cliente INTO @xid_cliente, @xr_soc, @rep_legal, @q_contrato
	END

CLOSE list_cliente;
DEALLOCATE list_cliente;
--------------------------------------------------------------------------
--TANQUES POR sub_CLIENTE (CURSORES ANIDADAS)
DECLARE list_cliente CURSOR FOR SELECT sc.id_scliente, sc.n_com
								FROM SUB_CLIENTE sc 
									INNER JOIN CONTRATO co ON co.id_scliente=sc.id_scliente
									WHERE co.estado='vigente'
								ORDER BY sc.n_com;
DECLARE
	@xid_scliente varchar(500),
	@xn_com varchar(500)

OPEN list_cliente
	FETCH NEXT FROM list_cliente INTO @xid_scliente, @xn_com
	 
	PRINT'				LISTADO DE CLIENTES';
	PRINT'-----------------------------------------------------------------------------'
	WHILE @@FETCH_STATUS=0
	
	BEGIN
		PRINT @xid_scliente+'			'+@xn_com;

	DECLARE list_tk CURSOR FOR SELECT tk.cod_tk, tk.cap
								FROM CONTRATO c 
								INNER JOIN EQUIPO e ON e.cod_con=c.cod_con 
								INNER JOIN TANQUE tk ON tk.cod_tk=e.cod_equ
								WHERE c.estado='vigente' and c.id_scliente=@xid_scliente;
	DECLARE
	@xcod_tk varchar(500),
	@xcap float;
	
	OPEN list_tk
	FETCH NEXT FROM list_tk INTO @xcod_tk, @xcap
	WHILE @@FETCH_STATUS=0
		
		BEGIN
			PRINT @xcod_tk+'				'+CONVERT(VARCHAR(500),@xcap);
		FETCH NEXT FROM list_tk INTO @xcod_tk, @xcap
	
		END

	CLOSE list_tk;
	DEALLOCATE list_tk;
	
	FETCH NEXT FROM list_cliente INTO @xid_scliente, @xn_com
	PRINT'-----------------------------------------------------------------------------'
	END

CLOSE list_cliente;
DEALLOCATE list_cliente;
-------------------------------------------------------------------------------------------------------
--TRABAJADORES POR CLIENTE (CURSORES ANIDADAS)
--CURSOR1
DECLARE list_cliente CURSOR FOR SELECT DISTINCT sc.id_scliente, sc.n_com
								FROM SUB_CLIENTE sc 
									INNER JOIN CONTRATO co ON co.id_scliente=sc.id_scliente
								WHERE co.estado='vigente'
								ORDER BY sc.n_com;
DECLARE
	@xid_scliente varchar(500),
	@xn_com varchar(500);

OPEN list_cliente
	FETCH NEXT FROM list_cliente INTO @xid_scliente, @xn_com
	 
	PRINT'FICHA CLIENTE';
	PRINT'============================================================================='
	WHILE @@FETCH_STATUS=0
	
	BEGIN
		PRINT @xid_scliente+'	'+@xn_com;
		--CURSOR 2
		DECLARE list_personal CURSOR FOR SELECT p.n_completo, p.cel
									FROM SUB_CLIENTE sc 
										INNER JOIN TIENE t ON t.id_scliente=sc.id_scliente
										INNER JOIN PERSONAL p ON p.id_persona=t.id_persona 
										INNER JOIN CONTRATO co ON co.id_scliente=sc.id_scliente
									WHERE co.estado='vigente' and sc.id_scliente=@xid_scliente;
		DECLARE
		@xn_completo varchar(500),
		@xcel varchar(500);
	
		OPEN list_personal
		FETCH NEXT FROM list_personal INTO @xn_completo, @xcel
		PRINT'-----------------------------------------------------------------------------'
		PRINT'		PERSONAL DEL CLIENTE:										CELULAR'
		
		WHILE @@FETCH_STATUS=0
		
			BEGIN
				PRINT'		'+@xn_completo+'										'+@xcel;
				FETCH NEXT FROM list_personal INTO @xn_completo, @xcel
			END
		--CURSOR 3
		CLOSE list_personal;
		DEALLOCATE list_personal;
	
		DECLARE list_contratos CURSOR FOR SELECT co.sum_tran,co.arrend,co.asesor,co.ser_int
									FROM SUB_CLIENTE sc 
										INNER JOIN CONTRATO co ON co.id_scliente=sc.id_scliente
									WHERE co.estado='vigente' and sc.id_scliente=@xid_scliente;
		DECLARE
		@xsum_tran varchar(500),
		@xarrend varchar(500),
		@xasesor varchar(500),
		@xser_int varchar(500);
	
		OPEN list_contratos
		FETCH NEXT FROM list_contratos INTO @xsum_tran, @xarrend,@xasesor,@xser_int
		PRINT '		
		CONTRATOS:'															
		WHILE @@FETCH_STATUS=0
		
			BEGIN
				PRINT '		Suministro y transporte: '+'	'+@xsum_tran;
				PRINT '		Arrendamiento de equipos: '+'	'+@xarrend;
				PRINT '		Asesoramiento de equipos:'+'	'+@xasesor;
				PRINT '		Sevicio Integral: '+'			'+@xser_int;
				FETCH NEXT FROM list_contratos INTO @xsum_tran, @xarrend,@xasesor,@xser_int
			END

		CLOSE list_contratos;
		DEALLOCATE list_contratos;
	
	FETCH NEXT FROM list_cliente INTO @xid_scliente, @xn_com
	PRINT'-----------------------------------------------------------------------------'
	END

CLOSE list_cliente;
DEALLOCATE list_cliente;