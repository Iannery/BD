DROP PROCEDURE IF EXISTS CRUD_USUARIO;

DELIMITER $$
CREATE PROCEDURE CRUD_USUARIO(
	comando			CHAR(6),
    chave_primaria	CHAR(14),
	cpf 			CHAR(14),
    nome 			VARCHAR(50),
    senha1 			CHAR(6),
    nascimento		CHAR(8)
)  
BEGIN

	IF (comando = 'INSERT') THEN		
		IF (verifica_data_nascimento(nascimento) = 1 AND valida_cpf(cpf) = 1) THEN
			INSERT INTO Usuario 
			VALUES (cpf, nome, senha1, nascimento, 0);
		ELSE
			SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = "Não foi possivel cadastrar o usuario.";
		END IF;
	END IF;
    
    
    IF (comando = 'SELECT') THEN
		IF EXISTS(SELECT * FROM Usuario WHERE Usuario.cpfUsuario = chave_primaria) THEN
			SELECT * FROM Usuario WHERE cpfUsuario = chave_primaria;
        ELSE
			SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = "Não foi possivel localizar o usuario.";
        END IF;
    END IF;
    
    
    IF (comando = 'UPDATE') THEN
		IF EXISTS (SELECT * FROM Usuario WHERE Usuario.cpfUsuario = chave_primaria) THEN
			IF (verifica_data_nascimento(nascimento) = 1 AND valida_cpf(cpf) = 1) THEN
				UPDATE Usuario 
				SET cpfUsuario = cpf, nomeUsuario = nome, senha = senha1, dataNascimento = nascimento
				WHERE cpfUsuario = chave_primaria;
            ELSE
				SIGNAL SQLSTATE '45000'
				SET MESSAGE_TEXT = "Não foi possivel atualizar o usuario.";
			END IF;
        ELSE
			SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = "Não foi possivel atualizar o usuario.";
        END IF;
	END IF;
    
    
    IF (comando = 'DELETE') THEN
		IF EXISTS(SELECT * FROM Usuario WHERE Usuario.cpfUsuario = chave_primaria) THEN
				DELETE FROM Usuario WHERE cpfUsuario = chave_primaria;
			ELSE
				SIGNAL SQLSTATE '45000'
				SET MESSAGE_TEXT = "Não foi possivel deletar o usuario.";
			END IF;
    END IF;
    
END;