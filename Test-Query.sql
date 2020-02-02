CALL CRUD_USUARIO ('INSERT', NULL, '526.541.340-59', 'Joao das Neves',  '123456', '22/02/48');
CALL CRUD_USUARIO ('INSERT', NULL, '522.863.610-29', 'Rebeca Pereira',  'Passwo', '10/04/52');
CALL CRUD_USUARIO ('INSERT', NULL, '821.512.780-00', 'Camila Costa',    'LololO', '01/09/68');
CALL CRUD_USUARIO ('INSERT', NULL, '314.994.470-86', 'Gabriela Cunha',  '987654', '11/02/97');
CALL CRUD_USUARIO ('INSERT', NULL, '023.304.451-56', 'Felipe Ribeiro',  'aloalo', '07/12/88');

CALL CRUD_EVENTO('INSERT', NULL, 'L',   'Evento Teste 1', 1, 'Sao Paulo',   'SP', '526.541.340-59');
CALL CRUD_EVENTO('INSERT', NULL, '10',  'Evento Teste 2', 1, 'Goiania',     'GO', '526.541.340-59');
CALL CRUD_EVENTO('INSERT', NULL, '12',  'Evento Teste 3', 1, 'Palmas',      'TO', '526.541.340-59');
CALL CRUD_EVENTO('INSERT', NULL, '14',  'Evento Teste 4', 1, 'Brasilia',    'DF', '526.541.340-59');
CALL CRUD_EVENTO('INSERT', NULL, '16',  'Evento Teste 5', 1, 'Cuiaba',      'MT', '526.541.340-59');
CALL CRUD_EVENTO('INSERT', NULL, '18',  'Evento Teste 6', 1, 'Sao Luis',    'MA', '526.541.340-59');
CALL CRUD_EVENTO('INSERT', NULL, 'L',   'Evento Teste 7', 1, 'Teresina',    'PI', '526.541.340-59');
CALL CRUD_EVENTO('INSERT', NULL, 'L',   'Evento Teste 8', 1, 'Natal',       'RN', '526.541.340-59');



CALL CRUD_USUARIO ('SELECT', '023.304.451-56', NULL, NULL, NULL, NULL);

CALL CRUD_USUARIO('UPDATE', '023.304.451-56', '023.304.451-55', 'Ian Nery', '111111', '09/09/98');

CALL CRUD_USUARIO('DELETE', '023.304.451-56', NULL, NULL, NULL, NULL);



CALL CRUD_EVENTO('SELECT', NULL, NULL, NULL, NULL, NULL, NULL, '023.304.451-56');

CALL CRUD_EVENTO('UPDATE', 009, '14', 'Evento', 2, 'Rio de Janeiro', 'RJ', '023.304.451-56');



SELECT * FROM Usuario;

DELETE FROM Usuario where cpfUsuario = '023.304.451-56';

INSERT INTO Evento VALUES(0, '', '', 3, '', '', '023.304.451-56');



DELETE FROM Evento;
DELETE FROM Usuario;
DELETE FROM Apresentacao;
DELETE FROM Ingresso;
DELETE FROM CartaoDeCredito;    
    