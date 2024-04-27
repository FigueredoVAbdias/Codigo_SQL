--TABLA HISTORICA DE CONTRATO
CREATE TABLE HISTO_CONTRATO(
	cod_con varchar(50),
     inf_tec varchar(500),
     inf_leg varchar(500),
     sum_tran varchar(500),
     p_sum float,
     p_tran float,
     arrend varchar(500),
     p_tk float,
     p_vap float,
     asesor varchar(500),
     p_ase float,
     ser_int varchar(500),
     tipo varchar(500),
     ini date,
     fin date,
     estado varchar(500),
     id_scliente varchar(50),
	 fecha_modi date
	 )

CREATE TRIGGER TR_HISTO_CONTRATO ON CONTRATO FOR UPDATE
AS
SET NOCOUNT ON
DECLARE 
	@xold_cod_con varchar(50),
     @xold_inf_tec varchar(500),
     @xold_inf_leg varchar(500),
     @xold_sum_tran varchar(500),
     @xold_p_sum float,
     @xold_p_tran float,
     @xold_arrend varchar(500),
     @xold_p_tk float,
     @xold_p_vap float,
     @xold_asesor varchar(500),
     @xold_p_ase float,
     @xold_ser_int varchar(500),
     @xold_tipo varchar(500),
     @xold_ini date,
     @xold_fin date,
     @xold_estado varchar(500),
     @xold_id_scliente varchar(50)

SELECT @xold_cod_con=cod_con FROM DELETED
SELECT @xold_inf_tec=inf_tec FROM DELETED
SELECT @xold_inf_leg=inf_leg FROM DELETED
SELECT @xold_sum_tran=sum_tran FROM DELETED
SELECT @xold_p_sum=p_sum FROM DELETED
SELECT @xold_p_tran=p_tran FROM DELETED
SELECT @xold_arrend=arrend FROM DELETED
SELECT @xold_p_tk=p_tk FROM DELETED
SELECT @xold_p_vap=p_vap FROM DELETED
SELECT @xold_asesor=asesor FROM DELETED
SELECT @xold_p_ase=p_ase FROM DELETED
SELECT @xold_ser_int=ser_int FROM DELETED
SELECT @xold_tipo=tipo FROM DELETED
SELECT @xold_ini=ini FROM DELETED
SELECT @xold_fin=fin FROM DELETED
SELECT @xold_estado=estado FROM DELETED
SELECT @xold_id_scliente=id_scliente FROM DELETED

INSERT INTO HISTO_CONTRATO 
VALUES(
	@xold_cod_con,
     @xold_inf_tec ,
     @xold_inf_leg ,
     @xold_sum_tran ,
     @xold_p_sum ,
     @xold_p_tran ,
     @xold_arrend ,
     @xold_p_tk ,
     @xold_p_vap ,
     @xold_asesor ,
     @xold_p_ase ,
     @xold_ser_int ,
     @xold_tipo ,
     @xold_ini,
     @xold_fin,
     @xold_estado ,
     @xold_id_scliente,
	 GETDATE())
--EXE
SELECT * FROM HISTO_CONTRATO
SELECT * FROM CONTRATO

UPDATE CONTRATO
SET sum_tran='YPFB-ALCCNº277/2022'
WHERE cod_con='CON-01'

