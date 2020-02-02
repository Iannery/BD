
DROP FUNCTION IF EXISTS verifica_horario; 


DELIMITER $$

CREATE FUNCTION verifica_horario (valor char(5)) RETURNS int
DETERMINISTIC
BEGIN
    DECLARE hora 	int;
    DECLARE minuto 	int;
    DECLARE pontos 	char(1);
    
    set hora 	= substr(valor, 1, 2);
    set minuto 	= substr(valor, 4, 2);
    set pontos 	= substr(valor, 3, 1);
    
    if ((hora <= 22 and hora >= 07) and
		(minuto = 00 or minuto = 15 or minuto = 30 or minuto = 45) and
		 pontos = ':') then
		return 1;
    else
		return 0;
    end if;    
end;

