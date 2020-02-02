DROP PROCEDURE IF EXISTS CRUD_CARTAO;

DELIMITER $$
CREATE PROCEDURE CRUD_CARTAO(
	comando			CHAR(6),
    chave_primaria	CHAR(16),
	Cnumero			CHAR(16),
    Ccodseg			CHAR(3),
    Cdataval		CHAR(5),
    Ccpf    		CHAR(14)
)  
BEGIN

	IF (comando = 'INSERT') THEN		
		IF (verifica_data_validade(Cdataval) = 1 AND 
            valida_cpf(Ccpf) = 1 AND 
            verifica_cartao(Cnumero) = 1) THEN
			INSERT INTO CartaoDeCredito 
			VALUES (Cnumero, Ccodseg, Cdataval, Ccpf);
		ELSE
			SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = "Não foi possivel cadastrar o cartão.";
		END IF;
	END IF;
    
    
    IF (comando = 'SELECT') THEN
		IF EXISTS(SELECT * FROM CartaoDeCredito WHERE CartaoDeCredito.cpfUsuario = Ccpf) THEN
			SELECT * FROM CartaoDeCredito WHERE cpfUsuario = Ccpf;
        ELSE
			SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = "Não foi possivel localizar o cartão.";
        END IF;
    END IF;
    
    
    IF (comando = 'UPDATE') THEN
		IF EXISTS (SELECT * FROM CartaoDeCredito WHERE CartaoDeCredito.numero = chave_primaria) THEN
			IF (verifica_data_validade(Cdataval) = 1 AND 
                valida_cpf(Ccpf) = 1 AND 
                verifica_cartao(Cnumero) = 1) THEN

				UPDATE CartaoDeCredito 
				SET numero = Cnumero, codigoSeguranca = Ccodseg, dataValidade = Cdataval
				WHERE cpfUsuario = chave_primaria;
            ELSE
				SIGNAL SQLSTATE '45000'
				SET MESSAGE_TEXT = "Não foi possivel atualizar o cartão.";
			END IF;
        ELSE
			SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = "Não foi possivel atualizar o cartão.";
        END IF;
	END IF;
    
    
    IF (comando = 'DELETE') THEN
		IF EXISTS(SELECT * FROM CartaoDeCredito WHERE CartaoDeCredito.numero = chave_primaria) THEN
				DELETE FROM CartaoDeCredito WHERE numero = chave_primaria;
			ELSE
				SIGNAL SQLSTATE '45000'
				SET MESSAGE_TEXT = "Não foi possivel deletar o cartão.";
			END IF;
    END IF;
    
END;