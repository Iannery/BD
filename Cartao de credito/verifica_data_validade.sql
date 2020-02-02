
DROP FUNCTION IF EXISTS verifica_data_validade; 


DELIMITER $$

CREATE FUNCTION verifica_data_validade (valor char(5)) RETURNS int
DETERMINISTIC
BEGIN
    DECLARE meses 	int;
    DECLARE anos 	int;
    DECLARE barra 	char(1);
    
    set meses 	= substr(valor, 1, 2);
    set anos 	= substr(valor, 4, 2);
    set barra 	= substr(valor, 3, 1);
    
    if (meses <= 12 and meses >= 01 and
		anos >= 0  and anos <= 99 and barra = '/') then
		return 1;
    else
		return 0;
    end if;    
end;

