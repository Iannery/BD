
DROP FUNCTION IF EXISTS verifica_cidade; 
DELIMITER $$

CREATE FUNCTION verifica_cidade (cidade varchar(15)) RETURNS int
DETERMINISTIC
BEGIN
    DECLARE i 	 int;
    declare flag int;
    set i = 1;
    set flag = 1;
    while (i <= length(cidade) - 1) do
		if (substr(cidade, i, 2) = '  ') then
			set flag = 0;
		end if;
        set i = i + 1;
    end while;
    
    
    return flag;
end;



