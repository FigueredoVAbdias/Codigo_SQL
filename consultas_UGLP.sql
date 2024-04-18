
-------------------------------------------------CONSULTAS RAPIDAS----------------------------------------------------------------------  

--0. CONSULTA PARA BASE DE DATOS EXCEL:
SELECT 
	c.id_scliente as 'Codigo de Cliente',
	c.n_com as 'Nombre Comercial',
	cl.r_soc as 'Razon Social',
	cl.nit as 'NIT', 
	cl.email as 'Email',
	cl.tipo as 'Caracter de la Empresa',
	cl.unid as 'Tipo de Unidad',
	c.regi as 'Tipo de Regimen',
	cl.cont as 'Tipo de Contribuyente',
	cl.gran_act as 'Gran Actividad',
	cl.act_prin as 'Actividad Principal',
	cl.dep_mat as 'Departamento de Planta', 
	cl.dep_mat as 'Provincia de Planta',
	cl.mun_mat as 'Municipio de Planta',
	c.plant as 'Direccion de Planta',
	c.cel_plant as 'Contacto de Planta',
	c.ofic as 'Direccion de Oficina',
	c.cel_ofic as 'Contacto de Oficina',
	co.inf_tec as 'N° Informe Tecnico',
	co.inf_leg as 'N° Informe Legal',
	co.sum_tran as 'N° Contrato de Suministro y Transporte',
	co.p_sum as 'Precio de Suministro',
	co.p_tran as 'Precio de Transporte',
	co.arrend as 'N° Contrato de Arrendamiento de Tanques y/o Vaporizadores',
	co.p_tk as 'Precio de Arrendamiento de Tanques',
	co.p_vap as 'Precio de Arrendamiento de Vaporizadores',
	co.asesor as 'N° de Contrato de Asesoramiento y Mantenimiento de Tanques',
	co.p_ase as 'Precio de Asesoramiento y Mantenimiento de Tanques',
	co.ser_int as 'N° de Contrato de Servicio Integral de Tanques',
	co.tipo as 'Tipo de Contrato',
	co.garantia as 'Garantia (Bs)',
	co.fecha as 'Fecha Deposito de Garantia',
	co.compr as 'Nº Comprobante',
	co.ini as 'Fecha Firma de Contrato',
	co.fin as 'Fecha Finalizacion de Contrato',
	co.estado as 'Estado de Contrato',
	a.inf_tec as 'N° Informe Tecnico(ADENDA)',
	a.inf_leg as 'N° Informe Legal(ADENDA)',
	a.sum_tran as 'N° Contrato de Suministro y Transporte(ADENDA)',
	a.p_sum as 'Precio de Suministro (ADENDA)',
	a.p_tran as 'Precio de Transporte (ADENDA)',
	a.arrend as 'N° Contrato de Arrendamiento de Tanques y/o Vaporizadores(ADENDA)',
	a.p_tk as 'Precio de Arrendamiento de Tanques(ADENDA)',
	a.p_vap as 'Precio de Arrendamiento de Vaporizadores(ADENDA)',
	a.asesor as 'N° de Contrato de Asesoramiento y Mantenimiento de Tanques(ADENDA)',
	a.p_ase as 'Precio de Asesoramiento y Mantenimiento de Tanques(ADENDA)',
	a.garantia as 'Garantia (Bs)(ADENDA)',
	a.fecha as 'Fecha Deposito de Garantia(ADENDA)',
	a.compr as 'Nº Comprobante(ADENDA)',
	pr.media as 'Consumo promedio GLP Proyectado Kg/mes',
	pr.mediana as 'Mediana de Consumo GLP Ultima Gestion Kg/mes',
	pr.frec as 'Frecuencia de consumo GLP',
	pr.cat as 'Categoria (ANH)',
	pr.rubro as 'Rubro (ANH)'
FROM 
	SUB_CLIENTE c 
		LEFT JOIN CLIENTE cl ON cl.id_cliente=c.id_cliente
		LEFT JOIN CONTRATO co ON c.id_cliente = co.id_scliente
		LEFT JOIN ADENDA a ON a.cod_ade = co.cod_ade
		LEFT JOIN PROYECTO pr ON c.id_cliente=pr.id_scliente	
ORDER BY 
	c.n_com
------------------
---------------------------------
-- 1. CLIENTES VIGENTES CON ADENDA:
SELECT 
	c.id_cliente as 'Codigo de Cliente',
	c.n_com as 'Nombre Comercial',
	a.inf_tec as 'N° Informe Tecnico(ADENDA)',
	a.inf_leg as 'N° Informe Legal(ADENDA)',
	a.sum_tran as 'N° Contrato de Suministro y Transporte(ADENDA)',
	a.p_sum as 'Precio de Suministro (ADENDA)',
	a.p_tran as 'Precio de Transporte (ADENDA)',
	a.arrend as 'N° Contrato de Arrendamiento de Tanques y/o Vaporizadores(ADENDA)',
	a.p_tk as 'Precio de Arrendamiento de Tanques(ADENDA)',
	a.p_vap as 'Precio de Arrendamiento de Vaporizadores(ADENDA)',
	a.asesor as 'N° de Contrato de Asesoramiento y Mantenimiento de Tanques(ADENDA)',
	a.p_ase as 'Precio de Asesoramiento y Mantenimiento de Tanques(ADENDA)',
	a.garantia as 'Garantia (Bs)(ADENDA)',
	a.fecha as 'Fecha Deposito de Garantia(ADENDA)',
	a.compr as 'Nº Comprobante(ADENDA)'
FROM 
	CLIENTE c 
		INNER JOIN CONTRATO co ON c.id_cliente = co.id_cliente
		INNER JOIN ADENDA a ON a.cod_ade = co.cod_ade
WHERE 
	co.ESTADO Like 'VIGENTE'

--2. CLIENTES CON CONTRATO VIGENTE:
SELECT 
	su.id_scliente as 'Codigo de Cliente',
	su.n_com as 'Nombre Comercial',
	co.inf_tec as 'N° Informe Tecnico',
	co.inf_leg as 'N° Informe Legal',
	co.sum_tran as 'N° Contrato de Suministro y Transporte',
	co.p_sum as 'Precio de Suministro',
	co.p_tran as 'Precio de Transporte',
	co.arrend as 'N° Contrato de Arrendamiento de Tanques y/o Vaporizadores',
	co.p_tk as 'Precio de Arrendamiento de Tanques',
	co.p_vap as 'Precio de Arrendamiento de Vaporizadores',
	co.asesor as 'N° de Contrato de Asesoramiento y Mantenimiento de Tanques',
	co.p_ase as 'Precio de Asesoramiento y Mantenimiento de Tanques',
	co.ser_int as 'N° de Contrato de Servicio Integral de Tanques',
	co.tipo as 'Tipo de Contrato',
	co.garantia as 'Garantia (Bs)',
	co.fecha as 'Fecha Deposito de Garantia',
	co.compr as 'Nº Comprobante',
	co.ini as 'Fecha Firma de Contrato',
	co.fin as 'Fecha Finalizacion de Contrato',
	co.estado as 'Estado de Contrato'
FROM 
SUB_CLIENTE su 
	INNER JOIN CONTRATO co ON su.id_scliente = co.id_scliente
WHERE 
co.estado='VIGENTE'

--3. ENCARGADOS DE PLANTA Y DE SOLICITAR GLP:
SELECT 
	c.id_cliente as 'Codigo de Cliente',
	c.n_com as 'Nombre Comercial', 
	p.n_completo as 'Nombre Completo', 
	p.cel as 'Celular'
FROM 
	CLIENTE c 
		INNER JOIN CONTRATO co ON c.id_cliente = co.id_cliente 
		INNER JOIN TIENE t ON c.id_cliente = t.id_cliente 
		INNER JOIN PERSONAL p ON p.id_persona = t.id_persona
		INNER JOIN ENCARGADO e ON p.id_persona = e.id_enc 
WHERE 
	co.estado='VIGENTE'

--REPRESENTANTES LEGALES DE EMPRESAS CLIENTES VIGENTES:
SELECT 	
	c.id_cliente as 'Codigo de Cliente',
	c.n_com as 'Nombre Comercial',
	c.r_soc as 'Razon Social',
	p.n_completo as 'Nombre Completo Representante Legal', 
	r.ci as 'CI',
	r.fecha_naci as 'Fecha de Nacimiento',
	r.edad as 'Edad',
	r.sex as 'Genero',
	r.ocup as 'Ocupacion',
	p.email as 'Email',
	p.cel as 'Celular'
FROM CLIENTE c 
	INNER JOIN CONTRATO co ON c.id_cliente = co.id_cliente 
	INNER JOIN TIENE t ON c.id_cliente = t.id_cliente 
	INNER JOIN PERSONAL p ON p.id_persona = t.id_persona
	INNER JOIN REP_LEGAL r ON p.id_persona = r.id_rep
WHERE 
	co.estado='VIGENTE';

--TANQUES EN STOCK:
SELECT
	tk.cod_tk as 'Codigo', 
	tk.cap as 'Capacidad', 
	eq.marca as 'Marca',
	eq.industria as 'Industria',
	tk.num_ph as 'N° Certificado de Prueba Hidraulica',
	tk.inicio_ph as 'Fecha de Prueba Hidraulica',
	tk.fin_ph as 'Fecha de Vencimiento de Prueba Hidraulica',
	eq.fecha_habil as 'Fecha de Habilitacion',
	eq.propiedad as 'Propiedad',
	eq.ubic_fis 'Ubicacion Fisica',
	eq.dep as 'Departamento'
FROM 
	EQUIPO eq 
		INNER JOIN TANQUE tk ON eq.cod_equ = tk.cod_tk
WHERE 
eq.ubic_fis='EN DEPOSITO';

--TANQUES DE PROPIEDAD DE CLIENTES CON CONTRATO VIGENTES:
SELECT 
	c.id_cliente as 'Codigo de Cliente',
	c.n_com as 'Nombre Comercial', 
	tk.cod_tk as 'Codigo', 
	tk.cap as 'Capacidad', 
	eq.marca as 'Marca',
	eq.industria as 'Industria',
	tk.num_ph as 'N° Certificado de Prueba Hidraulica',
	tk.inicio_ph as 'Fecha de Prueba Hidraulica',
	tk.fin_ph as 'Fecha de Vencimiento de Prueba Hidraulica',
	eq.fecha_habil as 'Fecha de Habilitacion',
	eq.propiedad as 'Propiedad',
	eq.ubic_fis 'Ubicacion Fisica',
	eq.dep as 'Departamento'
FROM 
	CLIENTE c 
		INNER JOIN CONTRATO co ON c.id_cliente = co.id_cliente 
		INNER JOIN EQUIPO eq ON c.id_cliente = eq.id_cliente 
		INNER JOIN TANQUE tk ON eq.cod_equ = tk.cod_tk
WHERE 
	co.estado='VIGENTE' and
	eq.propiedad='CLIENTE';

--TANQUES PROPIEDAD DE YPFB POR CLIENTES CON CONTRATOS VIGENTES:
SELECT 
	c.id_cliente as 'Codigo de Cliente',
	c.n_com as 'Nombre Comercial', 
	tk.cod_tk as 'Codigo', 
	tk.cap as 'Capacidad', 
	eq.marca as 'Marca',
	eq.industria as 'Industria',
	tk.num_ph as 'N° Certificado de Prueba Hidraulica',
	tk.inicio_ph as 'Fecha de Prueba Hidraulica',
	tk.fin_ph as 'Fecha de Vencimiento de Prueba Hidraulica',
	eq.fecha_habil as 'Fecha de Habilitacion',
	eq.propiedad as 'Propiedad',
	eq.ubic_fis 'Ubicacion Fisica',
	eq.dep as 'Departamento'
FROM 
	CLIENTE c 
		INNER JOIN CONTRATO co ON c.id_cliente = co.id_cliente 
		INNER JOIN EQUIPO eq ON c.id_cliente = eq.id_cliente 
		INNER JOIN TANQUE tk ON eq.cod_equ = tk.cod_tk
WHERE 
	co.estado='VIGENTE' and
	eq.propiedad='YPFB';


--VAPORIZADORES ALQUILADOS A CLIENTES CON CONTRATO VIGENTES:
SELECT 
	c.id_cliente as 'Codigo de Cliente',
	c.n_com as 'Nombre Comercial', 
	v.cod_vap, v.modelo as 'Modelo', 
	v.potencia as 'Potencia',
	eq.marca as 'Marca',
	eq.industria as 'Industria',
	eq.fecha_habil as 'Fecha de Habilitacion',
	eq.propiedad as 'Propiedad',
	eq.ubic_fis 'Ubicacion Fisica',
	eq.dep as 'Departamento'
FROM 
	CLIENTE c 
		INNER JOIN CONTRATO co ON c.id_cliente = co.id_cliente 
		INNER JOIN EQUIPO eq ON c.id_cliente = eq.id_cliente 
		INNER JOIN VAPORIZADOR v ON eq.cod_equ = v.cod_vap
WHERE 
	co.estado='VIGENTE';

----PROYECTO POR CLIENTE CON CONTRATO VIGENTE
SELECT 
	c.id_cliente as 'Codigo de Cliente',
	c.n_com as 'Nombre Comercial', 
	pr.media as 'Consumo promedio GLP Proyectado Kg/mes',
	pr.mediana as 'Mediana de Consumo GLP Ultima Gestion Kg/mes',
	pr.frec as 'Frecuencia de consumo GLP',
	pr.cat as 'Categoria (ANH)',
	pr.rubro as 'Rubro (ANH)'
FROM CLIENTE c 
	LEFT JOIN CONTRATO co ON c.id_cliente = co.id_cliente
	LEFT JOIN PROYECTO pr ON c.id_cliente=pr.id_cliente	
WHERE 
	co.estado='VIGENTE'
ORDER BY 
	c.n_com

	--------VENTAS POR CLIENTE
SELECT
	r_social as 'Razon Social',
	factura as 'Factura',
	fecha as 'Fecha',
	producto as 'Producto',
	cantidad as 'Cantidad',
	total as 'Total'
FROM 
	VENTA

