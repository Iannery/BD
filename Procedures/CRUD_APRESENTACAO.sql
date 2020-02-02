DROP PROCEDURE IF EXISTS CRUD_APRESENTACAO;

DELIMITER $$
CREATE PROCEDURE CRUD_APRESENTACAO(
	comando			    CHAR(6),
    chave_primaria	    INT(4),
    Adataapres		    CHAR(8),
    Apreco              DECIMAL(6,2),
    Anumerosala		    INT,
    Ahorario 		    CHAR(5),
    Adisponibilidade    INT,
    Acodevento          INT(3)
)  
BEGIN

	IF (comando = 'INSERT') THEN		
		IF (verifica_data_apres(Adataapres) = 1 AND
            verifica_horario(Ahorario) = 1 AND 
            verifica_disponibilidade(Adisponibilidade) = 1 AND
            verifica_sala(Anumerosala) = 1 AND
            verifica_preco(Apreco) = 1 AND 
            verifica_cod_evento(Acodevento) = 1) THEN

			INSERT INTO Apresentacao
			VALUES(0, Adataapres, Apreco, Anumerosala, Ahorario, Adisponibilidade, Acodevento);
		ELSE
			SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = "Não foi possivel cadastrar a apresentação.";
		END IF;
	END IF;
    
    
    IF (comando = 'SELECT') THEN
		IF EXISTS(SELECT * FROM Apresentacao WHERE Apresentacao.codigoEvento = Acodevento) THEN
			SELECT * FROM Apresentacao WHERE codigoEvento = Acodevento;
        ELSE
			SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = "Não foi possivel localizar a apresentação.";
        END IF;
    END IF;
    
    
    IF (comando = 'UPDATE') THEN
		IF EXISTS (SELECT * FROM Apresentacao WHERE Apresentacao.codigoApresentacao = chave_primaria) THEN
			IF (verifica_data_apres(Adataapres) = 1 AND
                verifica_horario(Ahorario) = 1 AND 
                verifica_disponibilidade(Adisponibilidade) = 1 AND
                verifica_sala(Anumerosala) = 1 AND
                verifica_preco(Apreco) = 1 AND 
                verifica_cod_evento(Acodevento) = 1) THEN

				UPDATE Evento 
				SET dataApresentacao = Adataapres,
                    preco = Apreco,
                    numeroSala = Anumerosala,
                    horario = Ahorario,
                    disponibilidade = Adisponibilidade
				WHERE codigoApresentacao = chave_primaria;
            ELSE
				SIGNAL SQLSTATE '45000'
				SET MESSAGE_TEXT = "Não foi possivel atualizar a apresentação.";
			END IF;
        ELSE
			SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = "Não foi possivel atualizar a apresentação.";
        END IF;
	END IF;
    
    
    IF (comando = 'DELETE') THEN
		IF EXISTS(SELECT * FROM Apresentacao WHERE Apresentacao.codigoApresentacao = chave_primaria) THEN
				DELETE FROM Apresentacao WHERE codigoApresentacao = chave_primaria;
			ELSE
				SIGNAL SQLSTATE '45000'
				SET MESSAGE_TEXT = "Não foi possivel deletar a apresentação.";
			END IF;
    END IF;
    
END;