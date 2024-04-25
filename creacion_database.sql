CREATE TABLE CLIENTE(
	id_cliente varchar(20) not null PRIMARY KEY,
	n_comercial varchar(200),
	r_social varchar(200),
	nit int,
	email varchar(200),
	dep varchar(100),
	prov varchar(100),
	mun varchar(100),
	tipo varchar(100),
	unid varchar(100),
	regi varchar(100),
	cont varchar(100),
	gran_act varchar(100),
	act_prin varchar(200),
	ofic varchar(200),
	cel_ofic varchar(100),
	plant varchar(200),
	cel_plant varchar(100));

CREATE TABLE PERSONAL(
	id_persona varchar(10) not null PRIMARY KEY,
	n_completo varchar(200),
	cel varchar(100),
	email varchar(100));

CREATE TABLE TIENE(
	id_cliente varchar(20) not null,
	id_persona varchar(10) not null,
	CONSTRAINT FK_id_cliente FOREIGN KEY (id_cliente) REFERENCES CLIENTE(id_cliente), 
	CONSTRAINT FK_id_persona FOREIGN KEY (id_persona) REFERENCES PERSONAL(id_persona));

CREATE TABLE REP_LEGAL(
	id_rep varchar(10) not null,
	ci varchar(20),
	fecha_naci date,
	edad int,
	sex varchar(20),
	ocup varchar(50),
	CONSTRAINT FK_id_rep FOREIGN KEY (id_rep) REFERENCES PERSONAL(id_persona));
	
	UPDATE REP_LEGAL
	SET edad = DATEDIFF(year, fecha_naci, GETDATE()); 


CREATE TABLE ENCARGADO(
	id_enc varchar(10) not null,
	CONSTRAINT FK_id_enc FOREIGN KEY (id_enc) REFERENCES PERSONAL(id_persona));

CREATE TABLE ADENDA(
	cod_ade varchar(10) not null PRIMARY KEY,
	inf_tec varchar(50),
	inf_leg varchar(50),
	sum_tran varchar(50),
	p_sum float,
	p_tran float,
	arrend varchar(50),
	p_tk float,
	p_vap float,
	asesor varchar(50),
	p_ase float,
	garantia float,
	fecha date,
	compr varchar(50));

CREATE TABLE CONTRATO(
	cod_con varchar(10) not null PRIMARY KEY,
	inf_tec varchar(50),
	inf_leg varchar(50),
	sum_tran varchar(50),
	p_sum float,
	p_tran float,
	arrend varchar(50),
	p_tk float,
	p_vap float,
	asesor varchar(50),
	P_ase float,
	ser_int varchar(50),
	tipo varchar(10),
	garantia float,
	fecha date,
	compr varchar(50),
	inicio date,
	fin date,
	estado varchar(20),
	cod_ade varchar(10),
	CONSTRAINT FK_cod_ade FOREIGN KEY (cod_ade) REFERENCES ADENDA(cod_ade));
	
	UPDATE CONTRATO
	SET estado =
    		CASE
        		WHEN fin <= GETDATE() THEN "VIGENTE"
        		WHEN fin > GETDATE() THEN "VENCIDO"
        		ELSE "RESUELTO"
    		END;

CREATE TABLE FIRMA(
	id_persona varchar(10) not null,
	cod_con varchar(10) not null,
	CONSTRAINT FK_id_persona1 FOREIGN KEY (id_persona) REFERENCES PERSONAL(id_persona), 
	CONSTRAINT FK_cod_con FOREIGN KEY (cod_con) REFERENCES CONTRATO(cod_con));

CREATE TABLE EQUIPO(
	cod_equ varchar(10) not null PRIMARY KEY,
	marca varchar(30),
	industria varchar(30),
	propiedad varchar(30),
	fecha_habil date,
	ubic_fis varchar(100),
	dep varchar(30),
	id_cliente varchar(10),
	CONSTRAINT FK_id_cliente1 FOREIGN KEY (id_cliente) REFERENCES CLIENTE(id_cliente));

CREATE TABLE TANQUE(
	cod_tk varchar(30) not null,
	cap float,
	num_ph varchar(30),
	inicio_ph date,
	fin_ph date,
	cat varchar(20),
	CONSTRAINT FK_cod_tk FOREIGN KEY (cod_tk) REFERENCES EQUIPO(cod_equ));

CREATE TABLE VAPORIZADOR(
	cod_vap varchar(30) not null,
	modelo varchar (20),
	potencia float,
	CONSTRAINT FK_cod_vap FOREIGN KEY (cod_vap) REFERENCES EQUIPO(cod_equ));

CREATE TABLE PROYECTO(
	cod_pro varchar(10) not null PRIMARY KEY,
	media float,
	mediana float,
	frec varchar(20),
	cat varchar(5),
	equipo varchar(50),
	uso_glp varchar (100),
	rubro varchar (50),
	id_cliente varchar(20) not null, 
	CONSTRAINT FK_id_cliente2 FOREIGN KEY (id_cliente) REFERENCES CLIENTE(id_cliente));
	
	UPDATE PROYECTO
	SET cat =
    		CASE
        		WHEN media >= 60 THEN "B"
        		WHEN media >= 1000 THEN "A"
        		ELSE "C"
		END;	
	UPDATE PROYECTO
	SET rubro =
    		CASE
        		WHEN media >= 60 THEN "COMERCIAL"
        		WHEN media >= 1000 THEN "INDUSTRIAL"
        		ELSE "DOMESTICO"
		END;
	
CREATE TABLE VENTA(
	cod_ven varchar(10) not null PRIMARY KEY,
	id_cliente varchar(20) not null, 
	r_social varchar (100),
	factura int,
	fecha date,
	producto varchar(200),
	cantidad float,
	total float,
	CONSTRAINT FK_id_cliente3 FOREIGN KEY (id_cliente) REFERENCES CLIENTE(id_cliente));	

----BACK UP--

BACKUP DATABASE DB_UGLP 
	TO DISK = 'C:\Users\Abdias Figueredo V\OneDrive - Universidad Mayor de San Simón\Documentos\YPFB\DB\BACKUP\DB_UGLP.bak' 
	WITH FORMAT, 
	MEDIANAME = 'SQLServerBackups', 
	NAME = 'Respaldo Completo de DB_UGLP';
GO

bulk insert FAMILIAR
from'C:\Users\Abdias Figueredo V\OneDrive - Universidad Mayor de San Simón\Documentos\COMPASSION\DATOS BRUTOS\FAMILIAR.csv'
WITH 
	(
	FIRSTROW = 2,
	FIELDTERMINATOR = ';', 
	ROWTERMINATOR = '\n');