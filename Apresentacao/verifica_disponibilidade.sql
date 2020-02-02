
DROP FUNCTION IF EXISTS verifica_disponibilidade; 
DELIMITER $$

CREATE FUNCTION verifica_disponibilidade (valor int) RETURNS int
DETERMINISTIC
BEGIN
    
    if (valor >= 0 and valor <= 250) then
		return 1;
    else
		return 0;
    end if;    
end;

