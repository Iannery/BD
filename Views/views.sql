DROP VIEW IF EXISTS AprPorEvento;
DROP VIEW IF EXISTS EPorUsuario;
DROP VIEW IF EXISTS MaisVendidos;

CREATE VIEW AprPorEvento AS
SELECT nomeEvento AS 'Nome do Evento',
numeroApresentacoes as 'Qtd de Apresentacoes'
FROM Evento;

CREATE VIEW EPorUsuario AS
SELECT nomeUsuario as 'Nome',
numeroEventos as 'Eventos cadastrados'
FROM Usuario;

CREATE VIEW MaisVendidos AS
SELECT
COUNT(codigoIngresso) as 'Quantidade de Vendas',
Ingresso.codigoApresentacao as 'Apresentacao',
Evento.nomeEvento as 'Evento'
FROM Ingresso 
INNER JOIN Evento, Apresentacao
WHERE Apresentacao.codigoEvento = Evento.codigoEvento 
AND Apresentacao.codigoApresentacao = Ingresso.codigoApresentacao
GROUP BY Ingresso.codigoApresentacao
ORDER BY COUNT(codigoIngresso) DESC;

