
DROP FUNCTION IF EXISTS verifica_sala; 
DELIMITER $$

CREATE FUNCTION verifica_sala (valor int) RETURNS int
DETERMINISTIC
BEGIN
    
    if (valor >= 1 and valor <= 10) then
		return 1;
    else
		return 0;
    end if;    
end;

