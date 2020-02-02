
DROP FUNCTION IF EXISTS verifica_faixa_etaria; 
DELIMITER $$

CREATE FUNCTION verifica_faixa_etaria (valor char(2)) RETURNS int
DETERMINISTIC
BEGIN
    
    if (valor =  'L' or valor = '10' or
		valor = '12' or valor = '14' or
        valor = '16' or valor = '18') then
		return 1;
    else
		return 0;
    end if;    
end;

