DELIMITER $$

/****************************************************************************
 *	CRIA A FUNCAO DE VALIDAR CPF. RECEBE COMO ENTRADA O CPF COM '.' E '-'.	*
 *	RETORNA 1 CASO O CPF FOR VALIDO, 0 SE FOR INVÁLIDO E -1 SE FOR NULO.	*
 ****************************************************************************/


CREATE FUNCTION valida_cpf (cpf char(14)) RETURNS int
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
end;


