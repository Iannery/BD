
DROP FUNCTION IF EXISTS verifica_cod_ingresso; 


DELIMITER $$

CREATE FUNCTION verifica_cod_ingresso (codigo char(5)) RETURNS int
DETERMINISTIC
BEGIN
    DECLARE caracteres 	int;
    
    set caracteres 	= substr(codigo, 1, 5);
    
    if (caracteres >= 00000 and caracteres <= 99999) then
		return 1;
    else
		return 0;
    end if;    
end;

