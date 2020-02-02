
DROP FUNCTION IF EXISTS verifica_classe_evento; 
DELIMITER $$

CREATE FUNCTION verifica_classe_evento (valor int) RETURNS int
DETERMINISTIC
BEGIN
    
    if (valor >= 1 and valor <= 4) then
		return 1;
    else
		return 0;
    end if;    
end;

