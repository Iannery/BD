
DROP FUNCTION IF EXISTS verifica_data_apres; 


DELIMITER $$

CREATE FUNCTION verifica_data_apres (valor char(8)) RETURNS int
DETERMINISTIC
BEGIN
    DECLARE dia 	int;
    DECLARE mes 	int;
    DECLARE ano 	int;
    DECLARE barra 	char(2);
    
    set dia 	= substr(valor, 1, 2);
    set mes 	= substr(valor, 4, 2);
    set ano 	= substr(valor, 7, 2);
    set barra 	= CONCAT(substr(valor, 3, 1), substr(valor, 6, 1));
    
    if ((dia <= 30 and dia >= 01) and
		(mes <= 12 and mes >= 01) and
		(ano <= 99  and ano >= 00) and barra = '//') then
		return 1;
    else
		return 0;
    end if;    
end;

