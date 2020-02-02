
DROP FUNCTION IF EXISTS verifica_cod_apres; 


DELIMITER $$

CREATE FUNCTION verifica_cod_apres (codigo char(4)) RETURNS int
DETERMINISTIC
BEGIN
    DECLARE caracteres 	int;
    
    set caracteres 	= substr(codigo, 1, 4);
    
    if (caracteres >= 0000 and caracteres <= 9999) then
		return 1;
    else
		return 0;
    end if;    
end;

