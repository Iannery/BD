DROP TRIGGER IF EXISTS tgr_disponibilidade;
DROP TRIGGER IF EXISTS tgr_usuario;
DROP TRIGGER IF EXISTS tgr_apresentacao;
DROP TRIGGER IF EXISTS tgr_evento;


DELIMITER $$

CREATE TRIGGER tgr_disponibilidade AFTER INSERT 
ON Ingresso
FOR EACH ROW 
BEGIN
	UPDATE Apresentacao as a
    SET a.disponibilidade = a.disponibilidade - 1;
END;$$

CREATE TRIGGER tgr_usuario
BEFORE DELETE 
ON Usuario
FOR EACH ROW 
BEGIN
    IF EXISTS (SELECT * FROM Evento, Usuario WHERE Usuario.cpfUsuario = Evento.cpfUsuario) THEN 
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
    and Apresentacao.codigoEvento = Evento.codigoEvento and Evento.numeroApresentacoes > 9) THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Erro: numero maximo de apresentacoes atingido';
	ELSE
	UPDATE Usuario
    INNER JOIN Evento on Usuario.cpfUsuario = Evento.cpfUsuario
    SET Evento.numeroApresentacoes = Evento.numeroApresentacoes + 1;
    END IF;
END;$$

CREATE TRIGGER tgr_evento
AFTER INSERT 
ON Evento
FOR EACH ROW 
BEGIN 
	IF EXISTS (SELECT * FROM Evento, Usuario WHERE Evento.cpfUsuario = Usuario.cpfUsuario 
	and Usuario.numeroEventos > 4) THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Erro: numero maximo de eventos atingido';
	ELSE
	UPDATE Usuario
    INNER JOIN Evento on Usuario.cpfUsuario = Evento.cpfUsuario
    SET Usuario.numeroEventos = Usuario.numeroEventos + 1;
    END IF;
END;$$
    