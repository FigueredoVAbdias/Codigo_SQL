--------------------AJUSTES DE DB UGLP-------------------

-- Declaracion de fecha actual
Declare @fecha_Actual Date = getdate();

--columna condicional para estado de contrato
UPDATE CONTRATO
Set estado = Case
	when @fecha_Actual>=ini and @fecha_Actual<=fin then 'VIGENTE'
	ELSE 'VENCIDO'
	END;

Select *
from CONTRATO
WHERE fin <= @fecha_Actual

--columna condicional para edad de rep legal
UPDATE REP_LEGAL
set edad = DATEDIFF(YEAR, fecha_naci, GETDATE())

SELECT * FROM REP_LEGAL;
-------------------------------------------
--ACTUALIZAR ID_CLIENTE
UPDATE SUB_CLIENTE 
SET id_cliente = c.id_cliente
FROM SUB_CLIENTE as sub
INNER JOIN CLIENTE as c on sub.nit=c.nit


