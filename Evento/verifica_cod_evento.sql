
DROP FUNCTION IF EXISTS verifica_cod_evento; 


DELIMITER $$

CREATE FUNCTION verifica_cod_evento (codigo INT(3)) RETURNS int
DETERMINISTIC
BEGIN
    if (codigo >= 000 and codigo <= 999) then
		return 1;
    else
		return 0;
    end if;    
end;

