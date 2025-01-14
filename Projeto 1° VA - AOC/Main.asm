# Projeto 1 VA Arquitetura e Organizacao de Computadores - 2024.2
# Alunos: Heitor Leander Feitosa da silva
#         Joao victor Morais Barreto da silva
#         Mariane Elisa dos Santos Souza
#         Samuel Roberto de Carvalho Bezerra

.data

	# Constantes
.eqv	keyboard_status 0xFFFF0000 # endereco do status do teclado
.eqv	display_status 0xFFFF0008 # endereco do status do display
.eqv	keyboard_buffer 0xFFFF0004 # endereco do buffer do teclado
.eqv	display_buffer 0xFFFF000C # endereco do buffer do display

	banner:  		.asciiz "MIPShelf-shell>>"
	comando: 		.space 100    # Espaco reservado para o comando digitado pelo usuario
	data_sistema:   .space 5  	  # Espaco reservado para a data do sistema
	hora_sistema: 	.space 5 	  # Espaco reservado para a hora do sistema
	
	# Caracteres
	barra_n:   		.byte 10      # Valor em ASCII do caractere de quebra de linha '\n'
	espaco:			.byte 32      # Valor em ASCII do caractere de espaco ' '       
	aspas_duplas:   .byte 34      # Valor em AscII do caractere de aspas duplas ""
	virgula:		.byte 44      # Valor em AscII do caractere da v�rgula (',')
	
	# Livro:
	titulo:  	.space 30     # Espaco reservado para o titulo do livro
	autor:    	.space 30     # Espaco reservado para o nome do autor do livro
	ISBN:       .space 10     # Espaco reservado para o codigo de ISBN do livro
	quantidade: .space 5   	  # Espaco reservado para a quantidade de livros disponiveis:
	
	# Usu�rio:
	nome:   	.space 30     # Espaco reservado para o nome do usuario
	matricula:	.space 10     # Espaco reservado para o numero de matricula do usuario
	curso:      .space 15     # Espaco reservado para o curso do usuario
	
	# Empr�stimo:
	matricula_usuario_ass: 	.space 10   # Espaco reservado para a matricula do usuario associado ao emprestimo
	ISBN_livro_ass:         .space 10   # Espaco reservado para o codigo de ISBN do livro associado ao emprestimo
	data_registro:  		.space 10   # Espaco reservado para a data em que foi registrado o emprestimo
	data_devolucao: 		.space 10   # Espaco reservado para a data de devolu�cao do emprestimo
	
	# Reposit�rios Tempor�rios
	repo_livro: .space 4500 # Espa�o reservado para a grava��o tempor�ria dos livros cadastrados
	repo_usuario: .space 4500 # Espa�o reservado para a grava��o tempor�ria dos usu�rios cadastrados
	repo_emprestimo: .space 4000 # Espa�o reservado para a grava��o tempor�ria dos empr�stimos cadastrados
	
	# Locais dos arquivos salvos
	local_arquivo_livros: .asciiz  "C:/repo_livros.txt"
	local_arquivo_usuario: .asciiz  "C:/repo_usuarios.txt"
	local_arquivo_emprestimo: .asciiz  "C:/repo_emprestimos.txt"	
	
	# Comandos:
	cmd_cadastrar_livro: 	.asciiz "cadastrar_livro"
	cmd_cadastrar_usuario:  .asciiz "cadastrar_usuario"
	cmd_listar_livro: 		.asciiz "listar_livro"
	cmd_reg_emprestimo:     .asciiz "registrar_emprestimo"
	cmd_gerar_relatorio:    .asciiz "gerar_relatorio"
	cmd_remover_livro:      .asciiz "remover_livro"
	cmd_remover_usuario: 	.asciiz "remover_usuario"
	cmd_salvar_dados: 	    .asciiz "salvar_dados"
	cmd_formatar_dados: 	.asciiz "formatar_dados"
	cmd_data_hora: 			.asciiz "data_hora"
	
	# Argumentos
	arg_titulo:      	.asciiz "--titulo"
	arg_autor:      	.asciiz "--autor"
	arg_ISBN:        	.asciiz "--isbn"
	arg_quantidade: 	.asciiz "--qtd"
	arg_nome:			.asciiz "--nome"
	arg_matricula:  	.asciiz "--matricula"
	arg_curso:			.asciiz "--curso"
	arg_devolucao: 		.asciiz "--devolucao"
	arg_data:           .asciiz "--data"
	arg_hora:           .asciiz "--hora"
	
	# Mensagens de confirma��o:
	msgC_livro_cadastrado: 		.asciiz "Livro cadastrado"
	msgC_usuario_cadastrado: 	.asciiz "Usuario cadastrado"
	msgC_emprestimo_realizado: 	.asciiz "Empr�stimo realizado"
	msgC_livro_removido:        .asciiz "Livro removido"
	msgC_usuario_removido:      .asciiz "Usuario removido"
	msgC_com_sucesso: 			.asciiz " com sucesso!"
	
	# Mensagens de erro:
	msgE_comando_invalido:         			 .asciiz "Comando invalido!"
	msgE_acervo_vazio:						 .asciiz "O acervo esta vazio."
	msgE_esprestimo_indisponivel: 		     .asciiz "Livro indisponivel para o emprestimo."
	msgE_relatorio_indisponivel:  			 .asciiz "Nao ha dados disponiveis para gerar o relatorio."
	msgE_livro_nao_encontrado:     			 .asciiz "O livro informado nao foi encontrado no acervo."
	msgE_livro_esta_emprestado:    			 .asciiz "O livro nao pode ser removido por estar emprestado."
	msgE_usuario_nao_encontrado:    		 .asciiz "O usuario informado nao foi encontrado no acervo."
	msgE_usuario_tem_pendencias:    		 .asciiz "O usuario nao pode ser removido por ter devolucoes pendentes."
	msgE_parte1_falta_argumento_obrigatorio: .asciiz "O campo \"" 
	msgE_parte2_falta_argumento_obrigatorio: .asciiz "\" e obrigatorio, certifique de usa-lo para que a operacao seja realizada"
	


.text
.globl main

main:
	# Escrever aqui a funcao que le os dados do arquivo .txt 
	jal escrever_banner_display
	li $s7, 0 		# inicializa $s7 com 0
	jal esperar_input_teclado

	j main 
	        
esperar_display_carregar:
	li $t0, 0xFFFF0008   		   		  # Endereco do status do display
    lw $t0, 0($t0)        				  # Carrega o status do display diretamente em $t0
    beqz $t0, esperar_display_carregar    # Se status for 0, entra em loop
    
    jr $ra

escrever_string_display:
	# $t1: reg que possui o endereco da string a ser digitada no display
	
	# Aloca espaco no $sp para salvar o endereco de $ra
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    jal esperar_display_carregar 	# Pula para a funcao que espera o display carregar
    
    lw $ra, 0($sp) 			   		# resgata o $ra original do $sp
    addi $sp, $sp, 4		  		# devolve a pilha para a posicao original
    
    li $t0, 0xFFFF000C         		# Endereco do Transmiter data do display
	loop_string_display:
		lb $t2, 0($t1)   			# Carrega um caractere da string de $t1 para $t2
    	beqz $t2, fim    			# Se o caractere em $t2 for o caractere de fim de string, sai do loop
    	sw $t2, 0($t0)    			# Caso contrario, escreve o caractere no display
    	addi $t1, $t1, 1  			# Avanca para o proximo caractere
    	j loop_string_display       # Continua com loop
    
    fim:
    jr $ra

esperar_input_teclado:
	# $s7: reg que serve como um apontador para a proxima posicao do caractere a ser inserido em comando 
	
    li $t0, 0xFFFF0000   			 # Endereco do status do teclado
    lw $t0, 0($t0)        			 # Carrega o status do teclado diretamente em $t0
    beqz $t0, esperar_input_teclado  # Se status for 0, entra em loop
	
	li $t0, 0xFFFF0004       # Endereco do Receiver data do teclado
   	lw $t1, 0($t0)           # Carrega o caractere digitado em $t1

  	# O trecho seguinte armazena o caractere digitado no espaco reservado para comando
    la $s0, comando          # Carrega o endereco de comando em $s0
	li $t3, 0                # inicializa $t3 com 0
	
    loop_armazenar:
        lb $t2, 0($s0)       	 # Le o caractere atual do comando e armazena em $t2
        beq $s7, $t3, armazenar  # Se o caractere atual for nulo, armazena
        addi $s0, $s0, 1     	 # Caso contrario avanca para a proxima posicao
        addi $t3, $t3, 1         # Incrementa $t3
        j loop_armazenar	 	 # entra em loop

    armazenar:
        sb $t1, 0($s0)       # Salva o caractere digitado na posicao atual do comando
        
    addi $s7, $s7, 1        # Incrementa $s7 para a proxima posicao de insercao de caracteres em comando
    
    # Verifica se o caractere digitado e barra_n (\n)
	la $t2, barra_n                  # Carrega o endereco de barra_n
    lb $t2, 0($t2)                   # Carrega o valor de barra_n
    beq $t1, $t2, verificar_comando  # Se for barra_n, chama verificar_comando

    # caso contrario, exibe o caractere no display
    jal escrever_caractere_digitado_display
    
    j esperar_input_teclado # entra em loop para esperar o proximo caractere
    
escrever_caractere_digitado_display:
    # Aloca espaco no $sp para salvar o endereco de $ra
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    jal esperar_display_carregar
    
    lw $ra, 0($sp) 		  #resgata o $ra original do $sp
    addi $sp, $sp, 4      #devolve a pilha para a posicao original
	
    li $t0, 0xFFFF000C    # Endereco do Receiver data do display
	sw $t1, 0($t0)        # Escreve o caractere no display

	jr $ra	
	
escrever_barra_n_display:
    # Aloca espaco no $sp para salvar o endereco de $ra
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    jal esperar_display_carregar
    
    lw $ra, 0($sp) 			   #resgata o $ra original do $sp
    addi $sp, $sp, 4		   #devolve a pilha para a posicao original

    la $t1, barra_n            # Carrega o endereco de barra_n
    lb $t1, 0($t1)             # Carrega o valor de barra_n diretamente em $t1

    li $t0, 0xFFFF000C         # Endereco do Transmitter data do display
    sw $t1, 0($t0)             # Escreve o caractere \n no display

    jr $ra
    
escrever_banner_display:
	la $t1, banner      # Carrega o endereco do inicio da string do banner
	
    # Aloca espaco no $sp para salvar o endereco de $ra
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    jal escrever_string_display
    
    lw $ra, 0($sp) 		#resgata o $ra original do $sp
    addi $sp, $sp, 4	#devolve a pilha para a posicao original

    jr $ra

comparar_strings:
	#	$s0: reg que possui o endere�o do comando digitado pelo usu�rio
	#	$s1: reg que possui o endere�o da string a ser comparada com o comando
	#	$s2: reg que possui a quantidade de caracteres que deve ser lida 
   
	comparador_loop:
		beqz $s2, retorno_strings_iguais       		# Se $s2 � igual a zero significa que a contagem terminou e eles s�o iguais
		lb $t0, 0($s0)                          	# Carrega o caractere em $s0 em $t0
		lb $t1, 0($s1)                          	# Carrega o caractere em $s1 em $t1
		bne $t0, $t1, retorno_strings_diferentes    # se os caracteres s�o diferentes $v0 	
		addi $s0, $s0, 1                            # Incrementa $s0, para seguir com o pr�ximo caractere da string
		addi $s1, $s1, 1                            # Incrementa $s1, para seguir com o pr�ximo caractere da string
		subi $s2, $s2, 1							# Subtrai $s2, para verificar se a contagem terminou
		j comparador_loop
		
	retorno_strings_iguais:
		li $v0, 1         # D� ao reg $v0 valor 1 para sinalizar como flag que as strings s�o iguais
		j fim_loop 		  # pula para o fim do loop 
	
	retorno_strings_diferentes:
		li $v0, 0  		  # D� ao reg $v0 o valor 0 para sinalizar como flag que as strings s�o diferentes

	fim_loop: 
		jr $ra 

str_concat:
    # $s0: registrador que carrega a primeira parte da concatena��o
    # $s1: registrador que carrega a segunda parte da concatena��o (a parte que ser� copiada)

    # Encontra o final da string em $s0
    acha_final_concat:
        lb $t0, 0($s0)         # Carrega o caractere atual de $s0
        beq $t0, $zero, copia_para_s0  # Se encontrar NULL (\0), fim da string
        addi $s0, $s0, 1       # Avan�a o ponteiro de $s0
        j acha_final_concat    # Continua procurando o final

    # Copia a string de $s1 para o final de $s0
    copia_para_s0:
        lb $t0, 0($s1)         # Carrega o caractere atual de $s1
        beq $t0, $zero, fim_concat  # Se encontrar NULL (\0), fim da string de origem
        sb $t0, 0($s0)         # Escreve o caractere de $s1 no local apontado por $s0
        addi $s0, $s0, 1       # Avan�a o ponteiro de $s0
        addi $s1, $s1, 1       # Avan�a o ponteiro de $s1
        j copia_para_s0        # Continua copiando

    # Finaliza a string concatenada
    fim_concat:
        sb $zero, 0($s0)       # Adiciona NULL (\0) ao final da string concatenada
        jr $ra                 # Retorna

clear_buffer:
    # $s1: Aponta para o in�cio do buffer a ser limpo

    li $t0, 0            # Carrega 0 em $t0 (valor para limpar)
    
	clear_loop:
    	lb $t1, 0($s1)       # Carrega o byte atual do buffer
    	beq $t1, $zero, end_clear  # Se encontrar NULL (\0), fim da string
    	sb $t0, 0($s1)       # Substitui o byte por 0
    	addi $s1, $s1, 1     # Avan�a o ponteiro de $s0
    	j clear_loop         # Continua limpando

	end_clear:
    	jr $ra               # Retorna
		
verificar_comando:
	jal escrever_barra_n_display    # Pula para a funcao que escreve o caractere de quebra de linha (\n) no display
    sb $zero, 0($s0)       			# Substitui o \n digitado pelo usuario pelo caractere nulo (\0)
    
    # Verifica cadastrar_livro
  	la $s1, cmd_cadastrar_livro     # Carrega o endereco de cmd_cadastrar_livro
  	la $s0, comando                 # Carrega o endereco de comando em S0
  	li $s2, 15                      # Define a quantidade de caracteres de comando que irao ser comparados
  	jal comparar_strings            # Pula para a funcao que ira comparar as strings
  	beq $v0, 1, cadastrar_livro     # se $v0 for 1, significa que o comando digitado foi o de cadastrar_livro 
  	
  	# Verifica cadastrar_Usuario
  	la $s1, cmd_cadastrar_usuario   # Carrega o endereco de cmd_cadastrar_usuario
  	la $s0, comando                 # Carrega o endereco de comando em S0
  	li $s2, 17                      # Define a quantidade de caracteres de comando que irao ser comparados
  	jal comparar_strings            # Pula para a funcao que ira comparar as strings
  	beq $v0, 1, cadastrar_usuario   # se $v0 for 1, significa que o comando digitado foi o de cadastrar_usuario
  	
  	# Verifica cmd_listar_livro
  	la $s1, cmd_listar_livro        # Carrega o endereco de cmd_listar_livro
  	la $s0, comando                 # Carrega o endereco de comando em S0
  	li $s2, 12                      # Define a quantidade de caracteres de comando que irao ser comparados
  	jal comparar_strings            # Pula para a funcao que ira comparar as strings
  	beq $v0, 1, listar_livro        # se $v0 for 1, significa que o comando digitado foi o de listar_livro
  	
  	# Verifica cmd_reg_emprestimo
  	la $s1, cmd_reg_emprestimo      # Carrega o endereco de cmd_reg_emprestimo
  	la $s0, comando                 # Carrega o endereco de comando em S0
  	li $s2, 20                      # Define a quantidade de caracteres de comando que irao ser comparados
  	jal comparar_strings            # Pula para a funcao que ira comparar as strings
  	beq $v0, 1, listar_livro        # se $v0 for 1, significa que o comando digitado foi o de reg_emprestimo
  	
  	# Verifica cmd_gerar_relatorio
  	la $s1, cmd_gerar_relatorio     # Carrega o endereco de cmd_gerar_relatorio
  	la $s0, comando                 # Carrega o endereco de comando em S0
  	li $s2, 20                      # Define a quantidade de caracteres de comando que irao ser comparados
  	jal comparar_strings            # Pula para a funcao que ira comparar as strings
  	beq $v0, 1, gerar_relatorio     # se $v0 for 1, significa que o comando digitado foi o de gerar_relatorio
  	
  	# Verifica cmd_remover_livro
  	la $s1, cmd_remover_livro       # Carrega o endereco de cmd_remover_livro
  	la $s0, comando                 # Carrega o endereco de comando em S0
  	li $s2, 13                      # Define a quantidade de caracteres de comando que irao ser comparados
  	jal comparar_strings            # Pula para a funcao que ira comparar as strings
  	beq $v0, 1, remover_livro       # se $v0 for 1, significa que o comando digitado foi o de remover_livro
  	
  	# Verifica cmd_remover_usuario
  	la $s1, cmd_remover_usuario     # Carrega o endereco de cmd_remover_usuario
  	la $s0, comando                 # Carrega o endereco de comando em S0
  	li $s2, 15                      # Define a quantidade de caracteres de comando que irao ser comparados
  	jal comparar_strings            # Pula para a funcao que ira comparar as strings
  	beq $v0, 1, remover_usuario     # se $v0 for 1, significa que o comando digitado foi o de remover_usuario
  	
  	# Verifica cmd_salvar_dados
  	la $s1, cmd_salvar_dados         # Carrega o endereco de cmd_savar_dados
    la $s0, comando                 # Carrega o endereco de comando em S0
  	li $s2, 12                      # Define a quantidade de caracteres de comando que irao ser comparados
  	jal comparar_strings            # Pula para a funcao que ira comparar as strings
  	beq $v0, 1, salvar_dados         # se $v0 for 1, significa que o comando digitado foi o de savar_dados
  	
  	# Verifica cmd_formatar_dados
  	la $s1, cmd_formatar_dados      # Carrega o endereco de cmd_formatar_dados
    la $s0, comando                 # Carrega o endereco de comando em S0
  	li $s2, 14                      # Define a quantidade de caracteres de comando que irao ser comparados
  	jal comparar_strings            # Pula para a funcao que ira comparar as strings
  	beq $v0, 1, formatar_dados      # se $v0 for 1, significa que o comando digitado foi o de formatar_dados
  	
  	# Verifica cmd_data_hora
  	la $s1, cmd_data_hora           # Carrega o endereco de cmd_data_hora
    la $s0, comando                 # Carrega o endereco de comando em S0
  	li $s2, 9                       # Define a quantidade de caracteres de comando que irao ser comparados
  	jal comparar_strings            # Pula para a funcao que ira comparar as strings
  	beq $v0, 1, formatar_dados      # se $v0 for 1, significa que o comando digitado foi o de data_hora
    
    j escrever_comando_invalido_display

guardar_info_buffer:
	# $t1: cont�m qual o buffer a ser usado
	# $s0: cont�m o comando dado pelo usu�rio
	
	lb $t0, 0($s0)           # Carrega o pr�ximo caractere
	li $t2, 34 			   	# Carrega aspas duplas
    bne $t0, $t2, escrever_comando_invalido_display 	# caso o pr�ximo caracter n�o for de aspas duplas, o comando � inv�lido
    addi $s0, $s0, 1

	# Copia os caracteres at� a segunda aspa dupla
	copy_loop:
    	lb $t0, 0($s0)           # Carrega o pr�ximo caractere
    	beqz $t0, end            # Se for nulo (fim da string), encerra
    	beq $t0, $t2, finalize    # Se for aspas duplas ('"'), finaliza a c�pia
    	sb $t0, 0($t1)           # Copia o caractere para o buffer do t�tulo
    	addi $s0, $s0, 1         # Avan�a para o pr�ximo caractere
    	addi $t1, $t1, 1         # Avan�a no buffer do t�tulo
    	j copy_loop

	# Finaliza o buffer adicionando a v�rgula
	finalize:
		addi $s0, $s0, 1 			#Passa das aspas
    	jr $ra
    end:
    	j escrever_comando_invalido_display 	# Caso haja um caracter nulo e n�o um de aspas duplas, o comando � inv�lido

cadastrar_livro:
	# Em constru��o
	
	# Primeiro, verificamos se o argumento a seguir � o esperado
	la $s1, arg_titulo
	# $s0 j� tem o comando a ser passado
	addi $s0, $s0, 1 	# Passa um caractere para frente, por conta do espa�o entre os comandos
	li $s2, 8
	jal comparar_strings
	beqz $v0, escrever_falta_argumento_titulo_display
	
	addi $s0, $s0, 1 	# Passa um caractere para frente, por conta do espa�o entre os comandos
	# Pega o que est� entre aspas e salva no buffer
	la $t1, titulo
	jal guardar_info_buffer
	# Colocar a v�rgula no fim do buffer
	la $t2, virgula               # Carrega o valor ASCII da v�rgula (',')
    sb $t2, 0($t1)           # Adiciona a v�rgula ao final do t�tulo
	
	# Verificamos se o argumento a seguir � v�lido
	la $s1, arg_autor
	# $s0 j� tem o comando a ser passado
	addi $s0, $s0, 1 	# Passa um caractere para frente, por conta do espa�o entre os comandos
	li $s2, 7
	jal comparar_strings
	beqz $v0, escrever_falta_argumento_autor_display
	
	addi $s0, $s0, 1 	# Passa um caractere para frente, por conta do espa�o entre os comandos
	# Pega o que est� entre aspas e salva no buffer
	la $t1, autor
	jal guardar_info_buffer
	la $t2, virgula               # Carrega o valor ASCII da v�rgula (',')
    sb $t2, 0($t1)           # Adiciona a v�rgula ao final do autor
	
	# Verificamos se o argumento a seguir � v�lido
	la $s1, arg_ISBN
	# $s0 j� tem o comando a ser passado
	addi $s0, $s0, 1 	# Passa um caractere para frente, por conta do espa�o entre os comandos
	li $s2, 6
	jal comparar_strings
	beqz $v0, escrever_falta_argumento_ISBN_display
	
	addi $s0, $s0, 1 	# Passa um caractere para frente, por conta do espa�o entre os comandos
	# Pega o que est� entre aspas e salva no buffer
	la $t1, ISBN
	jal guardar_info_buffer
	la $t2, virgula               # Carrega o valor ASCII da v�rgula (',')
    sb $t2, 0($t1)           # Adiciona a v�rgula ao final do ISBN
    
    # Verificamos se o argumento a seguir � v�lido
	la $s1, arg_quantidade
	# $s0 j� tem o comando a ser passado
	addi $s0, $s0, 1 	# Passa um caractere para frente, por conta do espa�o entre os comandos
	li $s2, 5
	jal comparar_strings
	beqz $v0, escrever_falta_argumento_quantidade_display
	
	addi $s0, $s0, 1 	# Passa um caractere para frente, por conta do espa�o entre os comandos
	# Pega o que est� entre aspas e salva no buffer
	la $t1, quantidade
	jal guardar_info_buffer
	la $t2, barra_n               # Carrega o valor ASCII de \n
    sb $t2, 0($t1)           # Adiciona ao final da quantidade
	
	# Agora vamos salvar no reposit�rio (buffer) de livros
	# Para isso, vamos concatenar todas as informa��es que obtivemos em uma �nica string e coloca-la no repo
	la $s0, repo_livro
	la $s1, titulo
	jal str_concat
	
	jal clear_buffer	# Limpa o buffer de titulo
	
	la $s1, autor
	jal str_concat
	
	jal clear_buffer	# Limpa o buffer de autor
	
	la $s1, ISBN
	jal str_concat
	
	jal clear_buffer	# Limpa o buffer de ISBN
	
	la $s1, quantidade
	jal str_concat
	
	jal clear_buffer	# Limpa o buffer de qtd
	
	# Teste para ver o que est� no reposit�rio
	la $t1, repo_livro
	jal escrever_string_display
	jal escrever_barra_n_display    # pula para a fun��o que ir� imprimir uma quebra de linha no display
	
	# Limpa o buffer de comando
	la $s1, comando
	jal clear_buffer
	
	la $t1, msgC_livro_cadastrado   # Carrega o endere�o de msgC_livro_cadastrado
	j escrever_com_sucesso_display

remover_livro:
	# Em constru��o
	
	# Limpa o buffer de comando
	la $s1, comando
	jal clear_buffer
	
	la $t1, msgC_livro_removido     # Carrega o endere�o de msgC_livro_removido
	j escrever_com_sucesso_display

listar_livro:
	# Em constru��o	
	
	# Limpa o buffer de comando
	la $s1, comando
	jal clear_buffer
	
	j main

cadastrar_usuario:
	# Em constru��o
	
	# Limpa o buffer de comando
	la $s1, comando
	jal clear_buffer
	
	
	la $t1, msgC_usuario_cadastrado # Carrega o endere�o de msgC_usuario_cadastrado 
	j escrever_com_sucesso_display
	
remover_usuario:
	# Em constru��o
	
	# Limpa o buffer de comando
	la $s1, comando
	jal clear_buffer
	
	la $t1, msgC_usuario_removido   # Carrega o endere�o de msgC_usuario_removido
	j escrever_com_sucesso_display
	
registrar_emprestimo:
	# Em constru��o
	
	# Limpa o buffer de comando
	la $s1, comando
	jal clear_buffer
	
	la $t1, msgC_emprestimo_realizado  # Carrega o endere�o de msgC_emprestimo_realizado
	j escrever_com_sucesso_display

gerar_relatorio:
	# Em constru��o
	
	# Limpa o buffer de comando
	la $s1, comando
	jal clear_buffer
	
	j main

salvar_dados:
	# Agr aqui tu faz o L aqui, parceira.
	
	# Limpa o buffer de comando
	la $s1, comando
	jal clear_buffer
	
	j main
	
formatar_dados:
	# Do your jump, mari
	
	# Limpa o buffer de comando
	la $s1, comando
	jal clear_buffer
	
	j main
	
data_hora:
	# Agr aqui tu faz o L aqui, parceira.
	
	# Limpa o buffer de comando
	la $s1, comando
	jal clear_buffer
	
	j main

	# Fun��o �nica para mensagens de confirma��o
escrever_com_sucesso_display:
	# $t1: reg possui a primeira parte da mensagem de confirma��o

	jal escrever_string_display  # Pula para a fun��o gen�rica que ir� imprimir a string armazenada em $t1
	la $t1, msgC_com_sucesso  # Carrega o ende�o de msgC_com_sucesso
	jal escrever_string_display  # Pula para a fun��o gen�rica que ir� imprimir a string armazenada em $t1
	jal escrever_barra_n_display    # pula para a fun��o que ir� imprimir uma quebra de linha no display
	
	j main

escrever_comando_invalido_display:
	la $t1, msgE_comando_invalido   # Carrega o endereco de msgE_comando_invalido
    jal escrever_string_display     # Pula para a funcao generica que ira imprimir a string armazenada em $t1
    jal escrever_barra_n_display    # pula para a funcao que ira imprimir uma quebra de linha no display   
    j main   
	
escrever_acervo_vazio_display:
    la $t1, msgE_acervo_vazio       # Carrega o endereco de msgE_acervo_vazio
    jal escrever_string_display     # Pula para a funcao generica que ira imprimir a string armazenada em $t1
    jal escrever_barra_n_display    # pula para a funcao que ira imprimir uma quebra de linha no display
    j main   

escrever_esprestimo_indisponivel_display:
    la $t1, msgE_esprestimo_indisponivel   # Carrega o endereco de msgE_comando_invalido
    jal escrever_string_display            # Pula para a funcao generica que ira imprimir a string armazenada em $t1
    jal escrever_barra_n_display           # pula para a funcao que ira imprimir uma quebra de linha no display
    j main   

escrever_relatorio_indisponivel_display:
    la $t1, msgE_relatorio_indisponivel   # Carrega o endereco de msgE_relatorio_indisponivel
    jal escrever_string_display           # Pula para a funcao generica que ira imprimir a string armazenada em $t1
    jal escrever_barra_n_display    	  # pula para a funcao que ira imprimir uma quebra de linha no display
    j main   
    
escrever_livro_nao_encontrado_display:
    la $t1, msgE_livro_nao_encontrado   # Carrega o endereco de msgE_livro_nao_encontrado 
    jal escrever_string_display         # Pula para a funcao generica que ira imprimir a string armazenada em $t1
    jal escrever_barra_n_display    	# pula para a funcao que ira imprimir uma quebra de linha no display
    j main   

escrever_livro_esta_emprestado_display:
    la $t1, msgE_livro_esta_emprestado   # Carrega o endereco de msgE_livro_esta_emprestado
    jal escrever_string_display          # Pula para a funcao generica que ira imprimir a string armazenada em $t1
    jal escrever_barra_n_display    	 # pula para a funcao que ira imprimir uma quebra de linha no display
    j main   
    
escrever_usuario_nao_encontrado_display:
    la $t1, msgE_usuario_nao_encontrado   # Carrega o endereco de msgE_usuario_nao_encontrado
    jal escrever_string_display           # Pula para a funcao generica que ira imprimir a string armazenada em $t1
    jal escrever_barra_n_display    	  # pula para a funcao que ira imprimir uma quebra de linha no display
    j main   
    
escrever_usuario_tem_pendencias_display:
    la $t1, msgE_usuario_tem_pendencias   # Carrega o endereco de msgE_usuario_tem_pendencias
    jal escrever_string_display           # Pula para a funcao generica que ira imprimir a string armazenada em $t1
    jal escrever_barra_n_display    	  # pula para a funcao que ira imprimir uma quebra de linha no display
    j main   

# Funcao generica que imprime a mensagem de falta de qualquer argumento no display
escrever_falta_argumento_obrigatorio_display:
	# $s1: reg que possui o endereco do argumento faltante
	
	# Aloca espaco no $sp para salvar o endereco de $ra
    addi $sp, $sp, -4
    sw $ra, 0($sp)
	
	la $t1, msgE_parte1_falta_argumento_obrigatorio  # Carrega o endereco de msgE_parte1_falta_argumento_obrigatorio
	jal escrever_string_display  # Pula para a funcao generica que ira imprimir a string armazenada em $t1
	
	addi $t1, $s1, 0   # soma $s1 com 0 e armazena em t1 (em outras palavras copia o endereco de $s1 pra $t1)
	jal escrever_string_display   
	
	la $t1, msgE_parte2_falta_argumento_obrigatorio  # Carrega o endereco de msgE_parte2_falta_argumento_obrigatorio
	jal escrever_string_display     
	
	lw $ra, 0($sp) 		#resgata o $ra original do $sp
    addi $sp, $sp, 4	#devolve a pilha para a posicao original

    jr $ra                 
	  
escrever_falta_argumento_titulo_display:
	la $s1, arg_titulo  # Carrega o endereco arg_titulo
	jal escrever_falta_argumento_obrigatorio_display
    jal escrever_barra_n_display    	  # pula para a funcao que ira imprimir uma quebra de linha no display
    j main   
	
escrever_falta_argumento_autor_display:
	la $s1, arg_autor  # Carrega o endereco arg_autor
	jal escrever_falta_argumento_obrigatorio_display
    jal escrever_barra_n_display    	  # pula para a funcao que ira imprimir uma quebra de linha no display
    j main   
	
escrever_falta_argumento_ISBN_display:
	la $s1, arg_ISBN  # Carrega o endereco arg_ISBN
	jal escrever_falta_argumento_obrigatorio_display
    jal escrever_barra_n_display    # pula para a funcao que ira imprimir uma quebra de linha no display
    j main   
	
escrever_falta_argumento_quantidade_display:
	la $s1, arg_quantidade  # Carrega o endereco arg_quantidade 
	jal escrever_falta_argumento_obrigatorio_display
    jal escrever_barra_n_display    # pula para a funcao que ira imprimir uma quebra de linha no display
    j main   
	
escrever_falta_argumento_nome_display:
	la $s1, arg_nome  # Carrega o endereco arg_nome
	jal escrever_falta_argumento_obrigatorio_display
    jal escrever_barra_n_display    # pula para a funcao que ira imprimir uma quebra de linha no display
    j main   
	
escrever_falta_argumento_matricula_display:
	la $s1, arg_matricula  # Carrega o endereco arg_matricula
	jal escrever_falta_argumento_obrigatorio_display
    jal escrever_barra_n_display    # pula para a funcao que ira imprimir uma quebra de linha no display
    j main   
	
escrever_falta_argumento_curso_display:
	la $s1, arg_curso  # Carrega o endereco arg_curso
	jal escrever_falta_argumento_obrigatorio_display
    jal escrever_barra_n_display    # pula para a funcao que ira imprimir uma quebra de linha no display
    j main   
	
escrever_falta_argumento_devolucao_display:
	la $s1, arg_devolucao  # Carrega o endereco arg_devolucao
	jal escrever_falta_argumento_obrigatorio_display
    jal escrever_barra_n_display    # pula para a funcao que ira imprimir uma quebra de linha no display
    j main  
    
escrever_falta_argumento_data_display:
	la $s1, arg_data  # Carrega o endereco arg_data
	jal escrever_falta_argumento_obrigatorio_display
    jal escrever_barra_n_display    # pula para a funcao que ira imprimir uma quebra de linha no display
    j main   
	 	     	            
escrever_falta_argumento_hora_display:
	la $s1, arg_hora  # Carrega o endereco arg_hora
	jal escrever_falta_argumento_obrigatorio_display
    jal escrever_barra_n_display    # pula para a funcao que ira imprimir uma quebra de linha no display
    j main  

incrementar_s0:
	addi $s0, $s0, 1
    jr $ra	      
               	         

