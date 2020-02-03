-- ----------------------------------------------------------------------------
-- MySQL Workbench Migration
-- Migrated Schemata: sistema_ingressos_BD
-- Source Schemata: sistema_ingressos
-- Created: Sun Feb  2 22:52:19 2020
-- Workbench Version: 6.3.10
-- ----------------------------------------------------------------------------

SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------------------------------------------------------
-- Schema sistema_ingressos_BD
-- ----------------------------------------------------------------------------
DROP SCHEMA IF EXISTS `sistema_ingressos_BD` ;
CREATE SCHEMA IF NOT EXISTS `sistema_ingressos_BD` ;

-- ----------------------------------------------------------------------------
-- Table sistema_ingressos_BD.Apresentacao
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `sistema_ingressos_BD`.`Apresentacao` (
  `codigoApresentacao` INT(4) UNSIGNED ZEROFILL NOT NULL AUTO_INCREMENT,
  `dataApresentacao` CHAR(8) NOT NULL,
  `preco` INT(11) NOT NULL,
  `numeroSala` INT(11) NOT NULL,
  `horario` CHAR(5) NOT NULL,
  `disponibilidade` INT(11) NULL DEFAULT '50',
  `codigoEvento` INT(3) UNSIGNED ZEROFILL NOT NULL,
  PRIMARY KEY (`codigoApresentacao`),
  INDEX `codigoEvento` (`codigoEvento` ASC),
  CONSTRAINT `Apresentacao_ibfk_1`
    FOREIGN KEY (`codigoEvento`)
    REFERENCES `sistema_ingressos_BD`.`Evento` (`codigoEvento`))
ENGINE = InnoDB
AUTO_INCREMENT = 0
DEFAULT CHARACTER SET = latin1;

-- ----------------------------------------------------------------------------
-- Table sistema_ingressos_BD.CartaoDeCredito
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `sistema_ingressos_BD`.`CartaoDeCredito` (
  `numero` CHAR(16) NOT NULL,
  `codigoSeguranca` CHAR(3) NOT NULL,
  `dataValidade` CHAR(5) NOT NULL,
  `cpfUsuario` CHAR(14) NOT NULL,
  PRIMARY KEY (`numero`),
  UNIQUE INDEX `numero_UNIQUE` (`numero` ASC),
  INDEX `cpfUsuario` (`cpfUsuario` ASC),
  CONSTRAINT `CartaoDeCredito_ibfk_1`
    FOREIGN KEY (`cpfUsuario`)
    REFERENCES `sistema_ingressos_BD`.`Usuario` (`cpfUsuario`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

-- ----------------------------------------------------------------------------
-- Table sistema_ingressos_BD.Evento
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `sistema_ingressos_BD`.`Evento` (
  `codigoEvento` INT(3) UNSIGNED ZEROFILL NOT NULL AUTO_INCREMENT,
  `faixaEtaria` CHAR(2) NOT NULL,
  `nomeEvento` CHAR(20) NOT NULL,
  `classe` INT(11) NOT NULL,
  `cidade` VARCHAR(15) NOT NULL,
  `estado` CHAR(2) NOT NULL,
  `numeroApresentacoes` INT(11) NOT NULL DEFAULT '0',
  `cpfUsuario` CHAR(14) NOT NULL,
  PRIMARY KEY (`codigoEvento`),
  INDEX `cpfUsuario` (`cpfUsuario` ASC),
  CONSTRAINT `Evento_ibfk_1`
    FOREIGN KEY (`cpfUsuario`)
    REFERENCES `sistema_ingressos_BD`.`Usuario` (`cpfUsuario`))
ENGINE = InnoDB
AUTO_INCREMENT = 0
DEFAULT CHARACTER SET = latin1;

-- ----------------------------------------------------------------------------
-- Table sistema_ingressos_BD.Ingresso
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `sistema_ingressos_BD`.`Ingresso` (
  `codigoIngresso` INT(5) NOT NULL AUTO_INCREMENT,
  `codigoApresentacao` INT(4) UNSIGNED ZEROFILL NOT NULL,
  `cpfUsuario` CHAR(14) NOT NULL,
  PRIMARY KEY (`codigoIngresso`),
  INDEX `ingr_fk_1` (`codigoApresentacao` ASC),
  INDEX `ingr_fk_2` (`cpfUsuario` ASC),
  CONSTRAINT `ingr_fk_1`
    FOREIGN KEY (`codigoApresentacao`)
    REFERENCES `sistema_ingressos_BD`.`Apresentacao` (`codigoApresentacao`),
  CONSTRAINT `ingr_fk_2`
    FOREIGN KEY (`cpfUsuario`)
    REFERENCES `sistema_ingressos_BD`.`Usuario` (`cpfUsuario`))
ENGINE = InnoDB
AUTO_INCREMENT = 0
DEFAULT CHARACTER SET = latin1;

-- ----------------------------------------------------------------------------
-- Table sistema_ingressos_BD.Usuario
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `sistema_ingressos_BD`.`Usuario` (
  `cpfUsuario` CHAR(14) NOT NULL,
  `nomeUsuario` VARCHAR(50) NULL DEFAULT NULL,
  `senha` CHAR(6) NOT NULL,
  `dataNascimento` CHAR(8) NOT NULL,
  `numeroEventos` INT(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`cpfUsuario`),
  UNIQUE INDEX `cpfUsuario` (`cpfUsuario` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

-- ----------------------------------------------------------------------------
-- View sistema_ingressos_BD.AprPorEvento
-- ----------------------------------------------------------------------------
USE `sistema_ingressos_BD`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `sistema_ingressos`.`AprPorEvento` AS select `sistema_ingressos`.`Evento`.`nomeEvento` AS `Nome do Evento`,`sistema_ingressos`.`Evento`.`numeroApresentacoes` AS `Qtd de Apresentacoes` from `sistema_ingressos`.`Evento`;

-- ----------------------------------------------------------------------------
-- View sistema_ingressos_BD.EPorUsuario
-- ----------------------------------------------------------------------------
USE `sistema_ingressos_BD`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `sistema_ingressos`.`EPorUsuario` AS select `sistema_ingressos`.`Usuario`.`nomeUsuario` AS `Nome`,`sistema_ingressos`.`Usuario`.`numeroEventos` AS `Eventos cadastrados` from `sistema_ingressos`.`Usuario`;

-- ----------------------------------------------------------------------------
-- View sistema_ingressos_BD.MaisVendidos
-- ----------------------------------------------------------------------------
USE `sistema_ingressos_BD`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `sistema_ingressos`.`MaisVendidos` AS select count(`sistema_ingressos`.`Ingresso`.`codigoIngresso`) AS `Quantidade de Vendas`,`sistema_ingressos`.`Ingresso`.`codigoApresentacao` AS `Apresentacao`,`sistema_ingressos`.`Evento`.`nomeEvento` AS `Evento` from ((`sistema_ingressos`.`Ingresso` join `sistema_ingressos`.`Evento`) join `sistema_ingressos`.`Apresentacao`) where ((`sistema_ingressos`.`Apresentacao`.`codigoEvento` = `sistema_ingressos`.`Evento`.`codigoEvento`) and (`sistema_ingressos`.`Apresentacao`.`codigoApresentacao` = `sistema_ingressos`.`Ingresso`.`codigoApresentacao`)) group by `sistema_ingressos`.`Ingresso`.`codigoApresentacao` order by count(`sistema_ingressos`.`Ingresso`.`codigoIngresso`) desc;

-- ----------------------------------------------------------------------------
-- Routine sistema_ingressos_BD.CONSULTA_CPF
-- ----------------------------------------------------------------------------
DELIMITER $$

DELIMITER $$
USE `sistema_ingressos_BD`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `CONSULTA_CPF`(Cpf char (14), CEvento int (3))
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
END$$

DELIMITER ;

-- ----------------------------------------------------------------------------
-- Routine sistema_ingressos_BD.CONSULTA_VENDAS
-- ----------------------------------------------------------------------------
DELIMITER $$

DELIMITER $$
USE `sistema_ingressos_BD`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `CONSULTA_VENDAS`(Cpf char(14), CEvento int (3))
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
END$$

DELIMITER ;

-- ----------------------------------------------------------------------------
-- Routine sistema_ingressos_BD.CRUD_APRESENTACAO
-- ----------------------------------------------------------------------------
DELIMITER $$

DELIMITER $$
USE `sistema_ingressos_BD`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `CRUD_APRESENTACAO`(
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
    
END$$

DELIMITER ;

-- ----------------------------------------------------------------------------
-- Routine sistema_ingressos_BD.CRUD_CARTAO
-- ----------------------------------------------------------------------------
DELIMITER $$

DELIMITER $$
USE `sistema_ingressos_BD`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `CRUD_CARTAO`(
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
    
END$$

DELIMITER ;

-- ----------------------------------------------------------------------------
-- Routine sistema_ingressos_BD.CRUD_EVENTO
-- ----------------------------------------------------------------------------
DELIMITER $$

DELIMITER $$
USE `sistema_ingressos_BD`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `CRUD_EVENTO`(
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
    
END$$

DELIMITER ;

-- ----------------------------------------------------------------------------
-- Routine sistema_ingressos_BD.CRUD_INGRESSO
-- ----------------------------------------------------------------------------
DELIMITER $$

DELIMITER $$
USE `sistema_ingressos_BD`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `CRUD_INGRESSO`(
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
    
END$$

DELIMITER ;

-- ----------------------------------------------------------------------------
-- Routine sistema_ingressos_BD.CRUD_USUARIO
-- ----------------------------------------------------------------------------
DELIMITER $$

DELIMITER $$
USE `sistema_ingressos_BD`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `CRUD_USUARIO`(
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
    
END$$

DELIMITER ;

-- ----------------------------------------------------------------------------
-- Routine sistema_ingressos_BD.valida_cpf
-- ----------------------------------------------------------------------------
DELIMITER $$

DELIMITER $$
USE `sistema_ingressos_BD`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `valida_cpf`(cpf char(14)) RETURNS int(11)
    DETERMINISTIC
BEGIN
  DECLARE indice    int;
  DECLARE cpf_real  char(11);
  DECLARE soma      int;
  DECLARE flag_dig  int;
  DECLARE digito_1  int; 
  DECLARE digito_2  int;
  DECLARE resultado char(2);

  /* CHECAGEM PRA VER SE CPF EH NULO */	
  if(cpf IS NULL) then
	return -1;
  end if;



  /* PARTE DOS DIGITOS IGUAIS */
  set flag_dig 	= 1;
  set soma	 	= 0;
  set indice 	= 1;
  set cpf_real 	= CONCAT(
    SUBSTR(cpf, 1, 3), SUBSTR(cpf,  5, 3), 
    SUBSTR(cpf, 9, 3), SUBSTR(cpf, 13, 2));

  while (indice <= 11) do 
    if(SUBSTR(cpf_real, indice, 1) <> SUBSTR(cpf_real, 1, 1)) then
      set flag_dig = 0;
    end if;
    set indice = indice + 1;
  end while;
  /* FIM DA PARTE DIGITOS IGUAIS */
  
  
  if(flag_dig = 0) then
	set indice = 1;
    
    /* CALCULO PRIMEIRO DIGITO */
    while(indice <= 9) do
	  set soma = soma + (SUBSTR(cpf_real, indice, 1) * (11 - indice));
      set indice = indice + 1;
    end while;  
    set soma = 11 - (soma % 11); 
    set soma = soma % 10;
    set digito_1 = soma;
	
    set indice = 1;
    set soma = 0;
    
    /* CALCULO SEGUNDO DIGITO */
    while(indice <= 10) do
	  set soma = soma + (SUBSTR(cpf_real, indice, 1) * (12 - indice));
      set indice = indice + 1;
    end while;  
    set soma = 11 - (soma % 11); 
    set soma = soma % 10;
    set digito_2 = soma;
	
    set resultado = CONCAT(digito_1, digito_2);
	
    if(resultado = SUBSTR(cpf_real, 10, 2)) then
		return 1;
	else
		return 0;
	end if;
  end if;
  return 0;
end$$

DELIMITER ;

-- ----------------------------------------------------------------------------
-- Routine sistema_ingressos_BD.verifica_cartao
-- ----------------------------------------------------------------------------
DELIMITER $$

DELIMITER $$
USE `sistema_ingressos_BD`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `verifica_cartao`(numero char(16)) RETURNS int(11)
    DETERMINISTIC
BEGIN

	DECLARE tamanho		 	int;
    DECLARE soma 			int;
    DECLARE digito 			int;
    DECLARE par_impar		int;
	
	/* CHECAGEM PRA VER SE CPF EH NULO */	
    if(numero IS NULL) then
		return -1;
	end if;

	set tamanho 	= length(numero);
    set soma 		= 0;
    
    /* FLAG PARA DETERMINAR SE O PESO EH PAR OU IMPAR */
    set par_impar 	= 1; 
    
    /****************************************************************
	 *	EM MYSQL, AS SUBSTRINGS COMECAM A PARTIR DA POSICAO 1,		*
     *  PORTANTO, PARA ADEQUAR AO ALGORITMO DE LUHN, DIREMOS QUE	*
     *  AS POSICOES IMPARES "1,3,5,...,15" TEM PESO 2, ENQUANTO		*
     *  AS POSICOES PARES 	"0,2,4,...,16" TEM PESO 1.				*
     ****************************************************************/
    
    while tamanho > 0 do
		set digito = substr(numero, tamanho, 1) * par_impar;
        
        /**************************************************************** 
		 * CASO A MULTIPLICACAO DO DIGITO COM O PESO DE MAIOR QUE 9,	*
         * OCORRE A SOMA DOS DOIS DIGITOS RESULTANTES, OU SEJA, 		*
         * SUBTRAI-SE ESTE NUMERO DE DOIS DIGITOS POR 9.				*
         ****************************************************************/
		set soma = soma + IF(digito > 9, digito - 9, digito);
		set par_impar = 3 - par_impar;
        set tamanho = tamanho - 1;
	end while;
    
    /****************************************************************
     * CHECAR CASO O CHECKSUM DE UM VALOR DIVISIVEL POR 10,			*
     * QUE OCORRE QUANDO O ALGORITMO VALIDA UM NUMERO DE CARTAO.	*
	 ****************************************************************/
    if(soma % 10 = 0) then
		return 1;
	else
		return 0;
	end if;
end$$

DELIMITER ;

-- ----------------------------------------------------------------------------
-- Routine sistema_ingressos_BD.verifica_cidade
-- ----------------------------------------------------------------------------
DELIMITER $$

DELIMITER $$
USE `sistema_ingressos_BD`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `verifica_cidade`(cidade varchar(15)) RETURNS int(11)
    DETERMINISTIC
BEGIN
    DECLARE i 	 int;
    declare flag int;
    set i = 1;
    set flag = 1;
    while (i <= length(cidade) - 1) do
		if (substr(cidade, i, 2) = '  ') then
			set flag = 0;
		end if;
        set i = i + 1;
    end while;
    
    
    return flag;
end$$

DELIMITER ;

-- ----------------------------------------------------------------------------
-- Routine sistema_ingressos_BD.verifica_classe_evento
-- ----------------------------------------------------------------------------
DELIMITER $$

DELIMITER $$
USE `sistema_ingressos_BD`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `verifica_classe_evento`(valor int) RETURNS int(11)
    DETERMINISTIC
BEGIN
    
    if (valor >= 1 and valor <= 4) then
		return 1;
    else
		return 0;
    end if;    
end$$

DELIMITER ;

-- ----------------------------------------------------------------------------
-- Routine sistema_ingressos_BD.verifica_cod_apres
-- ----------------------------------------------------------------------------
DELIMITER $$

DELIMITER $$
USE `sistema_ingressos_BD`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `verifica_cod_apres`(codigo char(4)) RETURNS int(11)
    DETERMINISTIC
BEGIN
    DECLARE caracteres 	int;
    
    set caracteres 	= substr(codigo, 1, 4);
    
    if (caracteres >= 0000 and caracteres <= 9999) then
		return 1;
    else
		return 0;
    end if;    
end$$

DELIMITER ;

-- ----------------------------------------------------------------------------
-- Routine sistema_ingressos_BD.verifica_cod_evento
-- ----------------------------------------------------------------------------
DELIMITER $$

DELIMITER $$
USE `sistema_ingressos_BD`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `verifica_cod_evento`(codigo INT(3)) RETURNS int(11)
    DETERMINISTIC
BEGIN
    if (codigo >= 000 and codigo <= 999) then
		return 1;
    else
		return 0;
    end if;    
end$$

DELIMITER ;

-- ----------------------------------------------------------------------------
-- Routine sistema_ingressos_BD.verifica_cod_ingresso
-- ----------------------------------------------------------------------------
DELIMITER $$

DELIMITER $$
USE `sistema_ingressos_BD`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `verifica_cod_ingresso`(codigo char(5)) RETURNS int(11)
    DETERMINISTIC
BEGIN
    DECLARE caracteres 	int;
    
    set caracteres 	= substr(codigo, 1, 5);
    
    if (caracteres >= 00000 and caracteres <= 99999) then
		return 1;
    else
		return 0;
    end if;    
end$$

DELIMITER ;

-- ----------------------------------------------------------------------------
-- Routine sistema_ingressos_BD.verifica_data_apres
-- ----------------------------------------------------------------------------
DELIMITER $$

DELIMITER $$
USE `sistema_ingressos_BD`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `verifica_data_apres`(valor char(8)) RETURNS int(11)
    DETERMINISTIC
BEGIN
    DECLARE dia 	int;
    DECLARE mes 	int;
    DECLARE ano 	int;
    DECLARE barra 	char(2);
    
    set dia 	= substr(valor, 1, 2);
    set mes 	= substr(valor, 4, 2);
    set ano 	= substr(valor, 7, 2);
    set barra 	= CONCAT(substr(valor, 3, 1), substr(valor, 6, 1));
    
    if ((dia <= 30 and dia >= 01) and
		(mes <= 12 and mes >= 01) and
		(ano <= 99  and ano >= 00) and barra = '//') then
		return 1;
    else
		return 0;
    end if;    
end$$

DELIMITER ;

-- ----------------------------------------------------------------------------
-- Routine sistema_ingressos_BD.verifica_data_nascimento
-- ----------------------------------------------------------------------------
DELIMITER $$

DELIMITER $$
USE `sistema_ingressos_BD`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `verifica_data_nascimento`(valor char(8)) RETURNS int(11)
    DETERMINISTIC
BEGIN
    DECLARE dia 	int;
    DECLARE mes 	int;
    DECLARE ano 	int;
    DECLARE barra 	char(2);
    
    set dia 	= substr(valor, 1, 2);
    set mes 	= substr(valor, 4, 2);
    set ano 	= substr(valor, 7, 2);
    set barra 	= CONCAT(substr(valor, 3, 1), substr(valor, 6, 1));
    
    if ((dia <= 30 and dia >= 01) and
		(mes <= 12 and mes >= 01) and
		(ano <= 99  and ano >= 00) and barra = '//') then
		return 1;
    else
		return 0;
    end if;    
end$$

DELIMITER ;

-- ----------------------------------------------------------------------------
-- Routine sistema_ingressos_BD.verifica_data_validade
-- ----------------------------------------------------------------------------
DELIMITER $$

DELIMITER $$
USE `sistema_ingressos_BD`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `verifica_data_validade`(valor char(5)) RETURNS int(11)
    DETERMINISTIC
BEGIN
    DECLARE meses 	int;
    DECLARE anos 	int;
    DECLARE barra 	char(1);
    
    set meses 	= substr(valor, 1, 2);
    set anos 	= substr(valor, 4, 2);
    set barra 	= substr(valor, 3, 1);
    
    if (meses <= 12 and meses >= 01 and
		anos >= 0  and anos <= 99 and barra = '/') then
		return 1;
    else
		return 0;
    end if;    
end$$

DELIMITER ;

-- ----------------------------------------------------------------------------
-- Routine sistema_ingressos_BD.verifica_disponibilidade
-- ----------------------------------------------------------------------------
DELIMITER $$

DELIMITER $$
USE `sistema_ingressos_BD`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `verifica_disponibilidade`(valor int) RETURNS int(11)
    DETERMINISTIC
BEGIN
    
    if (valor >= 0 and valor <= 250) then
		return 1;
    else
		return 0;
    end if;    
end$$

DELIMITER ;

-- ----------------------------------------------------------------------------
-- Routine sistema_ingressos_BD.verifica_estado
-- ----------------------------------------------------------------------------
DELIMITER $$

DELIMITER $$
USE `sistema_ingressos_BD`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `verifica_estado`(estado char(2)) RETURNS int(11)
    DETERMINISTIC
BEGIN
    
    if (estado = 'AC' or estado = 'AL' or estado = 'AP' or 
		estado = 'AM' or estado = 'BA' or estado = 'CE' or 
        estado = 'DF' or estado = 'ES' or estado = 'GO' or 
        estado = 'MA' or estado = 'MT' or estado = 'MS' or 
        estado = 'MG' or estado = 'PA' or estado = 'PB' or 
        estado = 'PR' or estado = 'PE' or estado = 'PI' or 
        estado = 'RJ' or estado = 'RN' or estado = 'RS' or 
        estado = 'RO' or estado = 'RR' or estado = 'SC' or 
        estado = 'SP' or estado = 'SE' or estado = 'TO') then
		return 1;
    else
		return 0;
    end if;    
end$$

DELIMITER ;

-- ----------------------------------------------------------------------------
-- Routine sistema_ingressos_BD.verifica_faixa_etaria
-- ----------------------------------------------------------------------------
DELIMITER $$

DELIMITER $$
USE `sistema_ingressos_BD`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `verifica_faixa_etaria`(valor char(2)) RETURNS int(11)
    DETERMINISTIC
BEGIN
    
    if (valor =  'L' or valor = '10' or
		valor = '12' or valor = '14' or
        valor = '16' or valor = '18') then
		return 1;
    else
		return 0;
    end if;    
end$$

DELIMITER ;

-- ----------------------------------------------------------------------------
-- Routine sistema_ingressos_BD.verifica_horario
-- ----------------------------------------------------------------------------
DELIMITER $$

DELIMITER $$
USE `sistema_ingressos_BD`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `verifica_horario`(valor char(5)) RETURNS int(11)
    DETERMINISTIC
BEGIN
    DECLARE hora 	int;
    DECLARE minuto 	int;
    DECLARE pontos 	char(1);
    
    set hora 	= substr(valor, 1, 2);
    set minuto 	= substr(valor, 4, 2);
    set pontos 	= substr(valor, 3, 1);
    
    if ((hora <= 22 and hora >= 07) and
		(minuto = 00 or minuto = 15 or minuto = 30 or minuto = 45) and
		 pontos = ':') then
		return 1;
    else
		return 0;
    end if;    
end$$

DELIMITER ;

-- ----------------------------------------------------------------------------
-- Routine sistema_ingressos_BD.verifica_preco
-- ----------------------------------------------------------------------------
DELIMITER $$

DELIMITER $$
USE `sistema_ingressos_BD`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `verifica_preco`(preco decimal (6,2)) RETURNS int(11)
    DETERMINISTIC
BEGIN
	if(preco >= 0 and preco <= 1000) then
		return 1;
    else
		return 0;
    end if;    
end$$

DELIMITER ;

-- ----------------------------------------------------------------------------
-- Routine sistema_ingressos_BD.verifica_sala
-- ----------------------------------------------------------------------------
DELIMITER $$

DELIMITER $$
USE `sistema_ingressos_BD`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `verifica_sala`(valor int) RETURNS int(11)
    DETERMINISTIC
BEGIN
    
    if (valor >= 1 and valor <= 10) then
		return 1;
    else
		return 0;
    end if;    
end$$

DELIMITER ;

-- ----------------------------------------------------------------------------
-- Trigger sistema_ingressos_BD.tgr_apresentacao
-- ----------------------------------------------------------------------------
DELIMITER $$
USE `sistema_ingressos_BD`$$
CREATE DEFINER=`root`@`localhost` TRIGGER tgr_apresentacao
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
END;

-- ----------------------------------------------------------------------------
-- Trigger sistema_ingressos_BD.tgr_evento
-- ----------------------------------------------------------------------------
DELIMITER $$
USE `sistema_ingressos_BD`$$
CREATE DEFINER=`root`@`localhost` TRIGGER tgr_evento
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
END;

-- ----------------------------------------------------------------------------
-- Trigger sistema_ingressos_BD.tgr_disponibilidade
-- ----------------------------------------------------------------------------
DELIMITER $$
USE `sistema_ingressos_BD`$$
CREATE DEFINER=`root`@`localhost` TRIGGER tgr_disponibilidade AFTER INSERT 
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
END;

-- ----------------------------------------------------------------------------
-- Trigger sistema_ingressos_BD.tgr_usuario
-- ----------------------------------------------------------------------------
DELIMITER $$
USE `sistema_ingressos_BD`$$
CREATE DEFINER=`root`@`localhost` TRIGGER tgr_usuario
BEFORE DELETE 
ON Usuario
FOR EACH ROW 
BEGIN
    IF EXISTS (SELECT * FROM Evento, Usuario WHERE old.cpfUsuario = Evento.cpfUsuario) THEN 
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Erro ao tentar excluir usuario';
    end if;
END;
SET FOREIGN_KEY_CHECKS = 1;
