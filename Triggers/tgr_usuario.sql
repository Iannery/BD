DROP TRIGGER IF EXISTS tgr_usuario;

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
