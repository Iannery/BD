
DROP FUNCTION IF EXISTS verifica_estado; 
DELIMITER $$

CREATE FUNCTION verifica_estado (estado char(2)) RETURNS int
DETERMINISTIC
BEGIN
    
    if (estado = 'AC' or estado = 'AL' or estado = 'AP' or 
		estado = 'AM' or estado = 'BA' or estado = 'CE' or 
        estado = 'DF' or estado = 'ES' or estado = 'GO' or 
        estado = 'MA' or estado = 'MT' or estado = 'MS' or 
        estado = 'MG' or estado = 'PA' or estado = 'PB' or 
        estado = 'PR' or estado = 'PE' or estado = 'PI' or 
        estado = 'RJ' or estado = 'RN' or estado = 'RS' or 
        estado = 'RO' or estado = 'RR' or estado = 'SC' or 
        estado = 'SP' or estado = 'SE' or estado = 'TO') then
		return 1;
    else
		return 0;
    end if;    
end;

