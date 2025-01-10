# Projeto 1 VA Arquitetura e Organiza��o de Computadores - 2024.2
# Alunos: Heitor Leander Feitosa da silva
#         Jo�o victor Morais Barreto da silva
#         Mariane Elisa dos Santos Souza
#         Samuel Roberto de Carvalho Bezerra

.data
	banner:  	.asciiz "MIPShelf-shell>>"
	barra_n:    .byte 10      # Valor em ASCII do caractere de quebra de linha \n
	comando: 	.space 100    # Espa�o reservado para o comando digitado pelo usu�rio
	
	# Livro:
	titulo:  	.space 50     # Espa�o reservado para o t�tulo do livro
	autor:    	.space 50     # Espa�o reservado para o nome do autor do livro
	ISBN:       .space 10     # Espa�o reservado para o c�digo de ISBN do livro
	quantidade: .space 5   	  # Espa�o reservado para a quantidade de livros dispon�veis:
	
	# Usu�rio:
	nome:   	.space 50     # Espa�o reservado para o nome do usu�rio
	matricula:	.space 10     # Espa�o reservado para o n�mero de matr�cula do usu�rio
	curso:      .space 25     # Espa�o reservado para o curso do usu�rio
	
	# Empr�stimo:
	matricula_usuario_ass: 	.space 10   # Espa�o reservado para a matr�cula do usu�rio associado ao empr�stimo
	ISBN_livro_ass:         .space 10   # Espa�o reservado para o c�digo de ISBN do livro associado ao empr�stimo
	data_registro:  	.space 10       # Espa�o reservado para a data em que foi registrado o empr�stimo
	data_devolucao: 	.space 10       # Espa�o reservado para a data de devolu��o do empr�stimo
	
	# Comandos:
	cmd_data_hora: 			.asciiz "data_hora"
	cmd_cadastrar_livro: 	.asciiz "cadastrar_livro"
	cmd_cadastrar_usuario:  .asciiz "cadastrar_usuario"
	cmd_listar_livro: 		.asciiz "listar_livro"
	cmd_reg_emprestimo:     .asciiz "registrar_emprestimo"
	cmd_gerar_relatorio:    .asciiz "gerar_relatorio"
	cmd_remover_livro:      .asciiz "remover_livro"
	cmd_remover_usuario: 	.asciiz "remover_usuario"
	cmd_savar_dados: 	    .asciiz "salvar_dados"
	cmd_formatar_dados: 	.asciiz "formatar_dados"
	
	# Mensagens de confirma��o:
	msgC_livro_cadastrado: 		.asciiz "Livro cadastrado com sucesso!"
	msgC_usuario_cadastrado: 	.asciiz "Usuario cadastrado com sucesso!"
	msgC_emprestimo_realizado: 	.asciiz "Empr�stimo realizado com sucesso!"
	msgC_livro_removido:        .asciiz "Livro removido com sucesso!"
	msgC_usuario_removido:      .asciiz "usuario removido com sucesso!"
	
	# Mensagens de erro:
	msgE_comando_invalido:          .asciiz "Comando inv�lido"
	msgE_acervo_vazio:				.asciiz "O acervo est� vazio."
	msgE_esprestimo_indisponivel: 	.asciiz "Livro indispon�vel para o empr�stimo."
	msgE_relatorio_indisponivel:    .asciiz "N�o h� dados dispon�veis para gerar o relat�rio."
	msgE_livro_nao_encontrado:      .asciiz "O livro informado n�o foi encontrado no acervo."
	msgE_livro_esta_emprestado:     .asciiz "O livro n�o pode ser removido por estar emprestado."
	msgE_usuario_nao_encontrado:    .asciiz "O usu�rio informado n�o foi encontrado no acervo."
	msgE_usuario_tem_pendencias:    .asciiz "O usu�rio n�o pode ser removido por ter devolu��es pend�ntes."
	
.text
.globl main

main:
	# Escrever aqui a fun��o que l� os dados do arquivo .txt	
	jal escrever_banner_display
	jal esperar_input_teclado
	
	j main # entra em loop
	
esperar_display_carregar:
	li $t0, 0xFFFF0008   		   		  # Endere�o do status do display
    lw $t1, 0($t0)        				  # Carrega o status do display em $t1
    beqz $t1, esperar_display_carregar    # Se status for 0, entra em loop
    
    jr $ra

# fun��o gen�rica que escreve qualquer string cujo endere�o esteja armazenado em $t2 no display 
escrever_string_display:
	# Aloca espa�o no $sp para salvar o endere�o de $ra
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    jal esperar_display_carregar
    
    lw $ra, 0($sp) 			   #resgata o $ra original do $sp
    addi $sp, $sp, 4		   #devolve a pilha para a posicao original
    
    li $t0, 0xFFFF000C         # Endere�o do Transmiter data do display

	loop_string_display:
		lb $t3, 0($t2)   			# Carrega um caractere da string de $t2 para $t3
    	beqz $t3, fim    			# Se o caractere em $t3 for o caractere de fim de string, sai do loop
    	sw $t3, 0($t0)    			# Caso contr�rio, escreve o caractere no display
    	addi $t2, $t2, 1  			# Avan�a para o pr�ximo caractere
    	j loop_string_display       # Continua com loop
    
    fim:
    jr $ra

esperar_input_teclado:
    li $t0, 0xFFFF0000   			 # Endere�o do status do teclado
    lw $t1, 0($t0)        			 # Carrega o status do teclado em $t1
    beqz $t1, esperar_input_teclado  # Se status for 0, entra em loop
	
	li $t0, 0xFFFF0004       # Endere�o do Receiver data do teclado
   	lw $t2, 0($t0)           # Carrega o caractere digitado em $t2
    
  	# O trecho seguinte armazena o caractere digitado no espa�o reservado para comando
    la $t3, comando          # Carrega o endere�o de comando em $t3
    
    loop_armazenar:
        lb $t4, 0($t3)       # L� o caractere atual do comando e armazena em $t4
        beqz $t4, armazenar  # Se o caractere atual for nulo, armazena
        addi $t3, $t3, 1     # Caso contr�rio avan�a para a pr�xima posi��o
        j loop_armazenar	 # entra em loop

    armazenar:
        sb $t2, 0($t3)       # Salva o caractere digitado na posi��o atual do comando
    
    # Verifica se o caractere digitado � barra_n (\n)
    la $t6, barra_n                  # Carrega o endere�o de barra_n
    lb $t6, 0($t6)                   # Carrega o valor de barra_n
    beq $t2, $t6, verificar_comando  # Se for barra_n, chama verificar_comando

    # caso contr�rio, exibe o caractere no display
    jal escrever_caractere_digitado_display
    
    j esperar_input_teclado # entra em loop para esperar o pr�ximo caractere
    
escrever_caractere_digitado_display:
    # Aloca espa�o no $sp para salvar o ende�o de $ra
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    jal esperar_display_carregar
    
    lw $ra, 0($sp) 		  #resgata o $ra original do $sp
    addi $sp, $sp, 4      #devolve a pilha para a posicao original
	
    li $t0, 0xFFFF000C    # Endere�o do Receiver data do display
	sw $t2, 0($t0)        # Escreve o caractere no display

	jr $ra	
	
escrever_barra_n_display:
    # Aloca espa�o no $sp para salvar o endere�o de $ra
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    jal esperar_display_carregar
    
    lw $ra, 0($sp) 			   #resgata o $ra original do $sp
    addi $sp, $sp, 4		   #devolve a pilha para a posicao original

    la $t2, barra_n            # Carrega o endere�o de barra_n
    lb $t2, 0($t2)             # Carrega o valor de barra_n em $t2

    li $t0, 0xFFFF000C         # Endere�o do Transmitter data do display
    sw $t2, 0($t0)             # Escreve o caractere \n no display

    jr $ra
    
escrever_banner_display:
	la $t2, banner        # Carrega o endere�o do in�cio da string do banner
	
    # Aloca espa�o no $sp para salvar o endere�o de $ra
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    jal escrever_string_display
    
    lw $ra, 0($sp) 			   #resgata o $ra original do $sp
    addi $sp, $sp, 4		   #devolve a pilha para a posicao original

    jr $ra

escrever_livro_cadastrado_display:
    la $t2, msgC_livro_cadastrado   # Carrega o endere�o de msgC_livro_cadastrado
    jal escrever_string_display     # Pula para a fun��o gen�rica que ir� imprimir a string armazenada em $t2
    j main   
    
escrever_usuario_cadastrado_display:
    la $t2, msgC_usuario_cadastrado # Carrega o endere�o de msgC_usuario_cadastrado 
    jal escrever_string_display     # Pula para a fun��o gen�rica que ir� imprimir a string armazenada em $t2
    j main
    
escrever_emprestimo_realizado_display:
    la $t2, msgC_emprestimo_realizado  # Carrega o endere�o de msgC_emprestimo_realizado
    jal escrever_string_display        # Pula para a fun��o gen�rica que ir� imprimir a string armazenada em $t2
    j main     
    
escrever_livro_removido_display:
    la $t2, msgC_livro_removido   # Carrega o endere�o de msgC_livro_removido
    jal escrever_string_display   # Pula para a fun��o gen�rica que ir� imprimir a string armazenada em $t2
    j main    
    
escrever_usuario_removido_display:
    la $t2, msgC_usuario_removido   # Carrega o endere�o de msgC_usuario_removido
    jal escrever_string_display     # Pula para a fun��o gen�rica que ir� imprimir a string armazenada em $t2
    j main            

escrever_comando_invalido_display:
	la $t2, msgE_comando_invalido   # Carrega o endere�o de msgE_comando_invalido
    jal escrever_string_display     # Pula para a fun��o gen�rica que ir� imprimir a string armazenada em $t2
    j main
	
escrever_acervo_vazio_display:
    la $t2, msgE_acervo_vazio     # Carrega o endere�o de msgE_acervo_vazio
    jal escrever_string_display   # Pula para a fun��o gen�rica que ir� imprimir a string armazenada em $t2
    j main            

escrever_esprestimo_indisponivel_display:
    la $t2, msgE_esprestimo_indisponivel   # Carrega o endere�o de msgE_comando_invalido
    jal escrever_string_display            # Pula para a fun��o gen�rica que ir� imprimir a string armazenada em $t2
    j main          

escrever_relatorio_indisponivel_display:
    la $t2, msgE_relatorio_indisponivel   # Carrega o endere�o de msgE_relatorio_indisponivel
    jal escrever_string_display           # Pula para a fun��o gen�rica que ir� imprimir a string armazenada em $t2
    j main 
    
escrever_livro_nao_encontrado_display:
    la $t2, msgE_livro_nao_encontrado   # Carrega o endere�o de msgE_livro_nao_encontrado 
    jal escrever_string_display         # Pula para a fun��o gen�rica que ir� imprimir a string armazenada em $t2
    j main         

escrever_livro_esta_emprestado_display:
    la $t2, msgE_livro_esta_emprestado   # Carrega o endere�o de msgE_livro_esta_emprestado
    jal escrever_string_display          # Pula para a fun��o gen�rica que ir� imprimir a string armazenada em $t2
    j main   
    
escrever_usuario_nao_encontrado_display:
    la $t2, msgE_usuario_nao_encontrado   # Carrega o endere�o de msgE_usuario_nao_encontrado
    jal escrever_string_display           # Pula para a fun��o gen�rica que ir� imprimir a string armazenada em $t2
    j main    
    
escrever_usuario_tem_pendencias_display:
    la $t2, msgE_usuario_tem_pendencias   # Carrega o endere�o de msgE_usuario_tem_pendencias
    jal escrever_string_display           # Pula para a fun��o gen�rica que ir� imprimir a string armazenada em $t2
    j main    

verificar_comando:
	jal escrever_barra_n_display    # pula para a fun��o que escreve o caractere de quebra de linha (\n) no display
    sb $zero, 0($t3)       			# Substitui o \n pelo caractere de fim de string (\0)
    
    # Aqui ser� implementada a l�gica de verifica��o de comando
    
    j main   #  pula pro main
