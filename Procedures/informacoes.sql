DROP PROCEDURE IF EXISTS CONSULTA_VENDAS;
DROP PROCEDURE IF EXISTS CONSULTA_CPF;

DELIMITER $$
CREATE PROCEDURE CONSULTA_VENDAS (Cpf char(14), CEvento int (3))
BEGIN 
	IF EXISTS (SELECT codigoEvento, cpfUsuario FROM Evento 
    WHERE codigoEvento = CEvento AND cpfUsuario = Cpf)
    THEN 
		SELECT COUNT(codigoIngresso) as 'Total de vendas', ingresso.codigoApresentacao FROM ingresso, apresentacao
        INNER JOIN evento on evento.codigoEvento = apresentacao.codigoEvento
		WHERE Evento.codigoEvento = CEvento and apresentacao.codigoApresentacao = ingresso.codigoApresentacao 
		GROUP BY apresentacao.codigoApresentacao;
    ELSE 
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Erro: cpf ou codigo do evento incorreto. Verifique os dados e tente novamente';
    END IF;
END;$$

CREATE PROCEDURE CONSULTA_CPF(Cpf char (14), CEvento int (3))
BEGIN 
	IF EXISTS(SELECT codigoEvento, cpfUsuario FROM Evento 
    WHERE codigoEvento = CEvento AND cpfUsuario = Cpf)
    THEN 
		SELECT nomeEvento as 'Evento', Apresentacao.codigoApresentacao, Ingresso.cpfUsuario as 'CPF' FROM Apresentacao, Evento, Ingresso
        WHERE Evento.codigoEvento = CEvento and Evento.codigoEvento = Apresentacao.codigoEvento 
        AND Ingresso.codigoApresentacao = Apresentacao.codigoApresentacao;
	ELSE 
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Erro: cpf ou codigo do evento incorreto. Verifique os dados e tente novamente';
    END IF;
END;$$

