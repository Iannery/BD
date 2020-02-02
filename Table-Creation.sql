CREATE DATABASE IF NOT EXISTS sistema_ingressos;

CREATE TABLE Usuario (
    cpfUsuario CHAR(14) NOT NULL,
    nomeUsuario VARCHAR(50),
    senha CHAR(6) NOT NULL, 
    dataNascimento CHAR(8) NOT NULL,
    numeroEventos INT NOT NULL DEFAULT 0,
    PRIMARY KEY (cpfUsuario)
);

CREATE TABLE CartaoDeCredito (
    numero CHAR(16) NOT NULL,
    codigoSeguranca CHAR(3) NOT NULL,
    dataValidade CHAR(5) NOT NULL,
    PRIMARY KEY (numero)
);

CREATE TABLE Evento(
    codigoEvento INT(3) ZEROFILL NOT NULL AUTO_INCREMENT,
    faixaEtaria CHAR(2) NOT NULL,
    nomeEvento CHAR(20) NOT NULL,
    classe INT NOT NULL,
    cidade VARCHAR(15) NOT NULL, 
    estado CHAR(2) NOT NULL,
    numeroApresentacoes INT NOT NULL DEFAULT 0,
    PRIMARY KEY (codigoEvento)
);

CREATE TABLE Apresentacao(
    codigoApresentacao INT(4) ZEROFILL NOT NULL AUTO_INCREMENT,
    dataApresentacao CHAR(8) NOT NULL, 
    preco INT NOT NULL,
    numeroSala INT NOT NULL, 
    horario CHAR(5) NOT NULL, 
    disponibilidade INT DEFAULT 50,
    PRIMARY KEY (codigoApresentacao)
);

CREATE TABLE Ingresso(
    codigoIngresso INT(5) NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (codigoIngresso)
);

ALTER TABLE CartaoDeCredito
	ADD cpfUsuario CHAR(14) NOT NULL,
    ADD FOREIGN KEY (cpfUsuario) REFERENCES Usuario(cpfUsuario);

ALTER TABLE Evento
	ADD cpfUsuario CHAR(14) NOT NULL,
    ADD FOREIGN KEY (cpfUsuario) REFERENCES Usuario(cpfUsuario);


ALTER TABLE Apresentacao
	ADD codigoEvento INT(3) ZEROFILL NOT NULL,
    ADD FOREIGN KEY (codigoEvento) REFERENCES Evento(codigoEvento);

ALTER TABLE Ingresso
	ADD codigoApresentacao INT(4) ZEROFILL NOT NULL,
    ADD cpfUsuario CHAR(14) NOT NULL,
    ADD CONSTRAINT ingr_fk_1 FOREIGN KEY (codigoApresentacao) REFERENCES Apresentacao(codigoApresentacao),
    ADD CONSTRAINT ingr_fk_2 FOREIGN KEY (cpfUsuario) REFERENCES  Usuario(cpfUsuario);