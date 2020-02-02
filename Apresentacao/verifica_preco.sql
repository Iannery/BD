
DROP FUNCTION IF EXISTS verifica_preco; 


DELIMITER $$

CREATE FUNCTION verifica_preco (preco decimal (6,2)) RETURNS int
DETERMINISTIC
BEGIN
	if(preco >= 0 and preco <= 1000) then
		return 1;
    else
		return 0;
    end if;    
end;

