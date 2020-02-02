DROP PROCEDURE IF EXISTS CRUD_EVENTO;

DELIMITER $$



CREATE PROCEDURE `CRUD_EVENTO`(
	comando			CHAR(6),
    chave_primaria	INT(3),
    Efxetaria		CHAR(2),
    Enome           CHAR(20),
    Eclasse			INT,
    Ecidade 		VARCHAR(15),
    Eestado         CHAR(2),
    Ecpf            CHAR(14)
)
BEGIN

	IF (comando = 'INSERT') THEN		
		IF (verifica_estado(Eestado) = 1 AND
            verifica_classe_evento(Eclasse) = 1 AND 
            verifica_faixa_etaria(Efxetaria) = 1 AND
            verifica_cidade(Ecidade) = 1 AND
            valida_cpf(Ecpf) = 1) THEN

			INSERT INTO Evento
			VALUES(0, Efxetaria, Enome, Eclasse, Ecidade, Eestado, 0, Ecpf);
		ELSE
			SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = "Não foi possivel cadastrar o evento.";
		END IF;
	END IF;
    
    
    IF (comando = 'SELECT') THEN
		IF EXISTS(SELECT * FROM Evento WHERE Evento.cpfUsuario = Ecpf) THEN
			SELECT * FROM Evento WHERE cpfUsuario = Ecpf;
        ELSE
			SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = "Não foi possivel localizar o evento.";
        END IF;
    END IF;
    
    
    IF (comando = 'UPDATE') THEN
		IF EXISTS (SELECT * FROM Evento WHERE Evento.codigoEvento = chave_primaria) THEN
			IF (verifica_estado(Eestado) = 1 AND
                verifica_classe_evento(Eclasse) = 1 AND 
                verifica_faixa_etaria(Efxetaria) = 1 AND
                verifica_cidade(Ecidade) = 1) THEN

				UPDATE Evento 
				SET faixaEtaria = Efxetaria, 
                    nomeEvento = Enome, 
                    classe = Eclasse, 
                    cidade = Ecidade,
                    estado = Eestado
				WHERE codigoEvento = chave_primaria;
            ELSE
				SIGNAL SQLSTATE '45000'
				SET MESSAGE_TEXT = "Não foi possivel atualizar o evento.";
			END IF;
        ELSE
			SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = "Não foi possivel atualizar o evento.";
        END IF;
	END IF;
    
    
    IF (comando = 'DELETE') THEN
		IF EXISTS(SELECT * FROM Evento WHERE Evento.codigoEvento = chave_primaria) THEN
				DELETE FROM Evento WHERE codigoEvento = chave_primaria;
			ELSE
				SIGNAL SQLSTATE '45000'
				SET MESSAGE_TEXT = "Não foi possivel deletar o cartão.";
			END IF;
    END IF;
    
END