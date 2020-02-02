DROP PROCEDURE IF EXISTS CRUD_INGRESSO;

DELIMITER $$
CREATE PROCEDURE CRUD_INGRESSO(
	comando			CHAR(6),
    chave_primaria	INT(5),
	Icodapres   	INT(4),
    Icpf    		CHAR(14)
)  
BEGIN

	IF (comando = 'INSERT') THEN		
		IF (verifica_cod_apres(Icodapres) = 1 AND 
            valida_cpf(Icpf) = 1) THEN
			INSERT INTO Ingresso 
			VALUES (0, Icodapres, Icpf);
		ELSE
			SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = "Não foi possivel cadastrar o ingresso.";
		END IF;
	END IF;
    
    
    IF (comando = 'SELECT') THEN
		IF EXISTS(SELECT * FROM Ingresso WHERE Ingresso.cpfUsuario = Icpf) THEN
			SELECT * FROM Ingresso WHERE cpfUsuario = Icpf;
        ELSE
			SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = "Não foi possivel localizar o ingresso.";
        END IF;
    END IF;
    
    IF (comando = 'DELETE') THEN
		IF EXISTS(SELECT * FROM Ingresso WHERE Ingresso.codigoIngresso = chave_primaria) THEN
				DELETE FROM Ingresso WHERE codigoIngresso = chave_primaria;
			ELSE
				SIGNAL SQLSTATE '45000'
				SET MESSAGE_TEXT = "Não foi possivel deletar o ingresso.";
			END IF;
    END IF;
    
END;