DELIMITER $$


/********************************************************************************
 *	UTILIZA O ALGORITMO DE LUHN PARA TESTAR SE O CARTAO DE CREDITO EH VALIDO	*
 *	RETORNA 1 CASO O CARTAO FOR VALIDO, 0 SE FOR INVÁLIDO E -1 SE FOR NULO.		*
 ********************************************************************************/


CREATE FUNCTION verifica_cartao(numero char(16)) RETURNS int
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
end;