DROP TRIGGER IF EXISTS tgr_disponibilidade;
DROP TRIGGER IF EXISTS tgr_usuario;
DROP TRIGGER IF EXISTS tgr_apresentacao;
DROP TRIGGER IF EXISTS tgr_evento;


DELIMITER $$

CREATE TRIGGER tgr_disponibilidade AFTER INSERT 
ON Ingresso
FOR EACH ROW 
BEGIN
	IF EXISTS (SELECT * FROM Apresentacao, Ingresso WHERE new.codigoApresentacao = Apresentacao.codigoApresentacao 
	and Apresentacao.disponibilidade <= 0) THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Erro: numero maximo de ingressos vendido.';
	ELSE
		UPDATE Apresentacao as a
		INNER JOIN Ingresso on a.codigoApresentacao = new.codigoApresentacao
		SET a.disponibilidade = a.disponibilidade - 1;
	END IF;
END;$$


CREATE TRIGGER tgr_usuario
BEFORE DELETE 
ON Usuario
FOR EACH ROW 
BEGIN
    IF EXISTS (SELECT * FROM Evento, Usuario WHERE old.cpfUsuario = Evento.cpfUsuario) THEN 
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Erro ao tentar excluir usuario';
    end if;
END;$$


CREATE TRIGGER tgr_apresentacao
AFTER INSERT 
ON Apresentacao
FOR EACH ROW 
BEGIN 
	IF EXISTS (SELECT * FROM Apresentacao, Evento, Usuario WHERE Evento.cpfUsuario = Usuario.cpfUsuario 
    and new.codigoEvento = Evento.codigoEvento and Evento.numeroApresentacoes > 9) THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Erro: numero maximo de apresentacoes atingido';
	ELSE
	UPDATE Evento
    INNER JOIN Apresentacao on Evento.codigoEvento = new.codigoEvento
    SET Evento.numeroApresentacoes = Evento.numeroApresentacoes + 1;
    END IF;
END;$$

CREATE TRIGGER tgr_evento
AFTER INSERT 
ON Evento
FOR EACH ROW 
BEGIN 
	IF EXISTS (SELECT * FROM Evento, Usuario WHERE new.cpfUsuario = Usuario.cpfUsuario 
	and Usuario.numeroEventos > 4) THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Erro: numero maximo de eventos atingido';
	ELSE
	UPDATE Usuario
    INNER JOIN Evento on Usuario.cpfUsuario = new.cpfUsuario
    SET Usuario.numeroEventos = Usuario.numeroEventos + 1;
    END IF;
END;$$
    