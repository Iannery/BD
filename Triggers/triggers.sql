DROP TRIGGER IF EXISTS tgr_apresentacao;

DELIMITER $$

CREATE TRIGGER tgr_disponibilidade AFTER INSERT 
ON ingresso
FOR EACH ROW 
BEGIN
	UPDATE apresentacao as a
    SET a.disponibilidade = a.disponibilidade - 1;
END $$

DELIMITER $$
CREATE TRIGGER tgr_usuario
BEFORE DELETE 
ON Usuario
FOR EACH ROW 
BEGIN
    IF EXISTS (SELECT * FROM Evento, Usuario WHERE Usuario.cpfUsuario = Evento.cpfUsuario) THEN 
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Erro ao tentar excluir usuario';
    end if;
END;


DELIMITER $$
CREATE TRIGGER tgr_apresentacao
AFTER INSERT 
ON Apresentacao
FOR EACH ROW 
BEGIN 
	IF EXISTS (SELECT * FROM Apresentacao, Evento, usuario WHERE evento.cpfUsuario = usuario.cpfUsuario 
    and apresentacao.codigoEvento = evento.codigoEvento and usuario.numeroApresentacoes > 9) THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Erro: numero maximo de apresentacoes atingido';
	ELSE
	UPDATE Usuario
    INNER JOIN Evento on usuario.cpfUsuario = evento.cpfUsuario
    SET usuario.numeroApresentacoes = usuario.numeroApresentacoes + 1;
    END IF;
END;

DELIMITER $$
CREATE TRIGGER tgr_evento
AFTER INSERT 
ON Evento
FOR EACH ROW 
BEGIN 
	IF EXISTS (SELECT * FROM Evento, usuario WHERE evento.cpfUsuario = usuario.cpfUsuario 
	and usuario.numeroEventos > 4) THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Erro: numero maximo de eventos atingido';
	ELSE
	UPDATE Usuario
    INNER JOIN Evento on usuario.cpfUsuario = evento.cpfUsuario
    SET usuario.numeroEventos = usuario.numeroEventos + 1;
    END IF;
END;
    