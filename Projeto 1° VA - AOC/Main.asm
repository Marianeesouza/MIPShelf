# Projeto 1 VA Arquitetura e Organizacao de Computadores - 2024.2
# Alunos: Heitor Leander Feitosa da silva
#         Joao victor Morais Barreto da silva
#         Mariane Elisa dos Santos Souza
#         Samuel Roberto de Carvalho Bezerra

.data

	# Constantes
.eqv	keyboard_status 0xFFFF0000  # endereco do status do teclado
.eqv	display_status  0xFFFF0008  # endereco do status do display
.eqv	keyboard_buffer 0xFFFF0004  # endereco do buffer do teclado
.eqv	display_buffer  0xFFFF000C  # endereco do buffer do display

	banner:  		.asciiz "MIPShelf-shell>>"
	comando: 		.space 100    # Espaco reservado para o comando digitado pelo usuario
	
	# Variaveis:
	data_config_usuario:       .space 20   # Variavel reservada para armazenar a data do sistema configurada pelo usuario
	hora_config_usuario:       .space 20   # Variavel reservada para armazenar a hora do sistema configurado pelo usuario
	data_atual: 	           .space 20   # Variavel reservada para armazenar a data atual 
	hora_atual:                .space 20   # Variavel reservada para armazenar a data atual
	tempo_hora_configurada0:   .word  0    # Variavel reservada para armazenar o tempo em que o usuario configurou a hora no sistema (os bits menos signficativos)
    tempo_hora_configurada1:   .word  0    # Variavel reservada para armazenar o tempo em que o usuario configurou a hora no sistema (os bits mais signficativos)

	# Caracteres
	barra_n:   		.byte 10      # Valor em ASCII do caractere de quebra de linha '\n'
	espaco:			.byte 32      # Valor em ASCII do caractere de espaco ' '       
	aspas_duplas:   .byte 34      # Valor em AscII do caractere de aspas duplas ""
	virgula:		.byte 44      # Valor em AscII do caractere da virgula (',')
	dois_pontos:    .byte 58      # Valor em ASCII do caractere de dois pontos (':')
    barra:          .byte 47      # Valor em ASCII do caractere de barra ('/')
	backspace:      .byte 8       # Valor em ASCII do caractere de backspace (botao de apagar)
	
	# Livro:
	titulo:  	.space 50     # Espaco reservado para o titulo do livro
	autor:    	.space 50     # Espaco reservado para o nome do autor do livro
	ISBN:       .space 15     # Espaco reservado para o codigo de ISBN do livro
	quantidade: .space 10  	  # Espaco reservado para a quantidade de livros disponiveis:
	
	# Usuario:
	nome:   	.space 50     # Espaco reservado para o nome do usuario
	matricula:	.space 20     # Espaco reservado para o numero de matricula do usuario
	curso:      .space 40     # Espaco reservado para o curso do usuario
	
	# Emprestimo:
	matricula_usuario_ass: 	.space 10   # Espaco reservado para a matricula do usuario associado ao emprestimo
	ISBN_livro_ass:         .space 10   # Espaco reservado para o codigo de ISBN do livro associado ao emprestimo
	data_registro:  		.space 10   # Espaco reservado para a data em que foi registrado o emprestimo
	data_devolucao: 		.space 10   # Espaco reservado para a data de devolucao do emprestimo
	
	# Repositorios Temporarios
	repo_livro:      .space 4500 # Espaco reservado para a gravacao temporaria dos livros cadastrados
	repo_usuario:    .space 4500 # Espaco reservado para a gravacao temporaria dos usuarios cadastrados
	repo_emprestimo: .space 4000 # Espaco reservado para a gravacao temporaria dos emprestimos cadastrados
	
	# Locais dos arquivos salvos
	local_arquivo_livros:      .asciiz  "repo_livros.txt"
	local_arquivo_usuario:     .asciiz  "repo_usuarios.txt"
	local_arquivo_emprestimo:  .asciiz  "repo_emprestimos.txt"	
	
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
	cmd_ajustar_data: 	    .asciiz "ajustar_data"
	cmd_reg_devolucao:      .asciiz "registrar_devolucao"
	
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
	
	# Mensagens de confirmacao:
	msgC_livro_cadastrado: 		 .asciiz "Livro cadastrado"
	msgC_usuario_cadastrado: 	 .asciiz "Usuario cadastrado"
	msgC_emprestimo_realizado:   .asciiz "Emprestimo realizado"
	msgC_livro_removido:         .asciiz "Livro removido"
	msgC_usuario_removido:       .asciiz "Usuario removido"
	msgC_dados_salvos:           .asciiz "Dados salvos"
	msgC_dados_apagados:         .asciiz "Dados apagados"
	msgC_data_hora_configurada:  .asciiz "Data e hora configurada"
	msgC_devolucao_registrada:   .asciiz "Devolucao regisrada"
	msgC_com_sucesso: 			 .asciiz " com sucesso!"
	
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
	msgE_data_hora_mal_formatada:            .asciiz "O formato da data ou hora esta incorreto."         
	
	# strings auxiliares para impressoes
	string_data:     .asciiz "Data: "
    string_hora:     .asciiz "Hora: "
.text
.globl main

carragar_dados:
	jal ler_dados  # pula para a funcao que vai ler os dados em arquivo
	
main:
	jal escrever_banner_display   # Funcao que escreve o banner no display
	li $s7, 0 		              # Inicializa $s7 com 0
	jal esperar_input_teclado     # Funcao que fica em looping esperando o input do teclado do usuario

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
	
	# Verifica se o caractere digitado eh o de backspace, caso seja pula para a funcao que trata isso
	la $t4, backspace        		 # Carrega o endereco do caractere de backspace
	lb $t4, 0($t4)           		 # Carrega o caractere de endereco
	beq $t1, $t4, tratar_backspace   
	
  	# O trecho seguinte armazena o caractere digitado no espaco reservado para comando
    la $s0, comando         		 # Carrega o endereco de comando em $s0
	li $t3, 0               		 # Inicializa $t3 com 0
	
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

    # Caso contrario, exibe o caractere no display
    jal escrever_caractere_digitado_display
    
    j esperar_input_teclado # entra em loop para esperar o proximo caractere
    
tratar_backspace:
	la $s0, comando                       # Carrega o endereco de comando
	lb $t0, 0($s0)                        # Carrega o primeiro byte de comando
	beqz $t0, limpar_rescrever_display    # se o 1� byte for nulo, entao comando ta vazio, logo nao precisa remover
  	addi $s7, $s7, -1    # Caso n�o seja, decrementa $s7 para apontar para o �ltimo caractere digitado
  	li $t2, 0 			 # Reg auxiliar para loop
  	
 	loop_apagar_ultimo_caractere:
  		beq $t2, $s7, apagar_ultimo_caractere  # Quando $t2 e $s7 forem iguais entao estaremos posicionados no ultimo caractere digitado em comando
  		addi $s0, $s0, 1                       # Avanca para o proximo caractere                      
 		addi $t2, $t2, 1                       # Incrementa $t2
  		j loop_apagar_ultimo_caractere         # Entra em loop
  	
  	apagar_ultimo_caractere:
		sb $zero, 0($s0) # Apaga o ultimo caractere do comando
	
	limpar_rescrever_display:
		jal limpar_display              # Funcao que escreve limpa rodo o display
		jal escrever_banner_display     # Rescreve o banner de novo
		la $t1, comando                 # carrega o comando em $t1
		jal escrever_string_display     # Rescreve no display oq tiver em comando
		j esperar_input_teclado         # volta a esperar um proximo caractere

limpar_display:
  li $t0, 0xFFFF000C   # Endere�o do Receiver data do display
  li $t1, 12           # Caractere de controle para limpar o display (c�digo ASCII 12)
  sw $t1, 0($t0)       # Escreve o caractere de controle no display
  jr $ra

escrever_caractere_digitado_display:
    # Aloca espaco no $sp para salvar o endereco de $ra
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    jal esperar_display_carregar
    
    lw $ra, 0($sp) 		  # Resgata o $ra original do $sp
    addi $sp, $sp, 4      # Devolve a pilha para a posicao original
	
    li $t0, 0xFFFF000C    # Endereco do Receiver data do display
	sw $t1, 0($t0)        # Escreve o caractere no display

	jr $ra	
	
escrever_barra_n_display:
    # Aloca espaco no $sp para salvar o endereco de $ra
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    jal esperar_display_carregar   
    
    lw $ra, 0($sp) 			   # Resgata o $ra original do $sp
    addi $sp, $sp, 4		   # Devolve a pilha para a posicao original

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
	#	$s0: reg que possui o endereco do comando digitado pelo usuario
	#	$s1: reg que possui o endereco da string a ser comparada com o comando
	#	$s2: reg que possui a quantidade de caracteres que deve ser lida 
   
	comparador_loop:
		
		lb $t0, 0($s0)                          	# Carrega o caractere em $s0 em $t0
		lb $t1, 0($s1)                          	# Carrega o caractere em $s1 em $t1
		bne $t0, $t1, retorno_strings_diferentes    # se os caracteres sao diferentes $v0 	
		addi $s0, $s0, 1                            # Incrementa $s0, para seguir com o proximo caractere da string
		addi $s1, $s1, 1                            # Incrementa $s1, para seguir com o proximo caractere da string
		subi $s2, $s2, 1							# Subtrai $s2, para verificar se a contagem terminou
		beqz $s2, retorno_strings_iguais       		# Se $s2 eh igual a zero significa que a contagem terminou e eles sao iguais
		j comparador_loop
		
	retorno_strings_iguais:
		li $v0, 1         # Da ao reg $v0 valor 1 para sinalizar como flag que as strings sao iguais
		j fim_loop 		  # pula para o fim do loop 
	
	retorno_strings_diferentes:
		li $v0, 0  		  # Da ao reg $v0 o valor 0 para sinalizar como flag que as strings sao diferentes

	fim_loop: 
		jr $ra 

str_concat:
    # $s0: registrador que carrega a primeira parte da concatenacao
    # $s1: registrador que carrega a segunda parte da concatenacao (a parte que sera copiada)

    # Encontra o final da string em $s0
    acha_final_concat:
        lb $t0, 0($s0)                 # Carrega o caractere atual de $s0
        beq $t0, $zero, copia_para_s0  # Se encontrar NULL (\0), fim da string
        addi $s0, $s0, 1               # Avanca o ponteiro de $s0
        j acha_final_concat            # Continua procurando o final

    # Copia a string de $s1 para o final de $s0
    copia_para_s0:
        lb $t0, 0($s1)              # Carrega o caractere atual de $s1
        beq $t0, $zero, fim_concat  # Se encontrar NULL (\0), fim da string de origem
        sb $t0, 0($s0)              # Escreve o caractere de $s1 no local apontado por $s0
        addi $s0, $s0, 1            # Avanca o ponteiro de $s0
        addi $s1, $s1, 1            # Avanca o ponteiro de $s1
        j copia_para_s0             # Continua copiando

    # Finaliza a string concatenada
    fim_concat:
        sb $zero, 0($s0)       # Adiciona NULL (\0) ao final da string concatenada
        jr $ra                 # Retorna

clear_buffer:
    # $s1: Aponta para o inicio do buffer a ser limpo

    li $t0, 0            # Carrega 0 em $t0 (valor para limpar)
    
	clear_loop:
    	lb $t1, 0($s1)             # Carrega o byte atual do buffer
    	beq $t1, $zero, end_clear  # Se encontrar NULL (\0), fim da string
    	sb $t0, 0($s1)             # Substitui o byte por 0
    	addi $s1, $s1, 1           # Avanca o ponteiro de $s0
    	j clear_loop               # Continua limpando

	end_clear:
    	jr $ra               # Retorna
		
verificar_comando:
	jal escrever_barra_n_display    # Pula para a funcao que escreve o caractere de quebra de linha (\n) no display
    sb $zero, 0($s0)       			# Substitui o \n digitado pelo usuario pelo caractere nulo (\0)
    
  	jal verificar_cmd_cadastrar_livro
  	jal verificar_cmd_cadastrar_usuario
  	jal verificar_cmd_listar_livro
  	jal verificar_cmd_reg_emprestimo
	jal verificar_cmd_gerar_relatorio
  	jal verificar_cmd_remover_livro
	jal verificar_cmd_remover_usuario
  	jal verificar_cmd_salvar_dados
  	jal verificar_cmd_formatar_dados
  	jal verificar_cmd_data_hora
	jal verificar_ajustar_data
    
    # Se n�o foi digitado nenhum dos comandos 
    j escrever_comando_invalido_display

verificar_cmd_cadastrar_livro:
	# Aloca espaco no $sp para salvar o endereco de $ra
    addi $sp, $sp, -4
    sw $ra, 0($sp)
	
  	la $s1, cmd_cadastrar_livro     # Carrega o endereco de cmd_cadastrar_livro
  	la $s0, comando                 # Carrega o endereco de comando em S0
  	li $s2, 15                      # Define a quantidade de caracteres de comando que irao ser comparados
  	jal comparar_strings            # Pula para a funcao que ira comparar as strings
  	beq $v0, 1, cadastrar_livro     # se $v0 for 1, significa que o comando digitado foi o de cadastrar_livro 
  	
  	lw $ra, 0($sp) 		#resgata o $ra original do $sp
    addi $sp, $sp, 4	#devolve a pilha para a posicao original
    
  	jr $ra

verificar_cmd_cadastrar_usuario:
	# Aloca espaco no $sp para salvar o endereco de $ra
    addi $sp, $sp, -4
    sw $ra, 0($sp)
	
  	la $s1, cmd_cadastrar_usuario   # Carrega o endereco de cmd_cadastrar_usuario
  	la $s0, comando                 # Carrega o endereco de comando em S0
  	li $s2, 17                      # Define a quantidade de caracteres de comando que irao ser comparados
  	jal comparar_strings            # Pula para a funcao que ira comparar as strings
  	beq $v0, 1, cadastrar_usuario   # se $v0 for 1, significa que o comando digitado foi o de cadastrar_usuario
	
	lw $ra, 0($sp) 		#resgata o $ra original do $sp
    addi $sp, $sp, 4	#devolve a pilha para a posicao original
	
	jr $ra
	
verificar_cmd_listar_livro:
	# Aloca espaco no $sp para salvar o endereco de $ra
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
  	la $s1, cmd_listar_livro        # Carrega o endereco de cmd_listar_livro
  	la $s0, comando                 # Carrega o endereco de comando em S0
  	li $s2, 12                      # Define a quantidade de caracteres de comando que irao ser comparados
  	jal comparar_strings            # Pula para a funcao que ira comparar as strings
  	beq $v0, 1, listar_livro        # se $v0 for 1, significa que o comando digitado foi o de listar_livro
  	
  	lw $ra, 0($sp) 		#resgata o $ra original do $sp
    addi $sp, $sp, 4	#devolve a pilha para a posicao original
    
  	jr $ra
  	
verificar_cmd_reg_emprestimo:
	# Aloca espaco no $sp para salvar o endereco de $ra
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
  	la $s1, cmd_reg_emprestimo      # Carrega o endereco de cmd_reg_emprestimo
  	la $s0, comando                 # Carrega o endereco de comando em S0
  	li $s2, 20                      # Define a quantidade de caracteres de comando que irao ser comparados
  	jal comparar_strings            # Pula para a funcao que ira comparar as strings
  	beq $v0, 1, listar_livro        # se $v0 for 1, significa que o comando digitado foi o de reg_emprestimo
	
	lw $ra, 0($sp) 		#resgata o $ra original do $sp
    addi $sp, $sp, 4	#devolve a pilha para a posicao original
    
	jr $ra
	
verificar_cmd_gerar_relatorio:
	# Aloca espaco no $sp para salvar o endereco de $ra
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
  	la $s1, cmd_gerar_relatorio     # Carrega o endereco de cmd_gerar_relatorio
  	la $s0, comando                 # Carrega o endereco de comando em S0
  	li $s2, 20                      # Define a quantidade de caracteres de comando que irao ser comparados
  	jal comparar_strings            # Pula para a funcao que ira comparar as strings
  	beq $v0, 1, gerar_relatorio     # se $v0 for 1, significa que o comando digitado foi o de gerar_relatorio
	
	lw $ra, 0($sp) 		#resgata o $ra original do $sp
    addi $sp, $sp, 4	#devolve a pilha para a posicao original
    
	jr $ra
	
verificar_cmd_remover_livro:
	# Aloca espaco no $sp para salvar o endereco de $ra
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
  	la $s1, cmd_remover_livro       # Carrega o endereco de cmd_remover_livro
  	la $s0, comando                 # Carrega o endereco de comando em S0
  	li $s2, 13                      # Define a quantidade de caracteres de comando que irao ser comparados
  	jal comparar_strings            # Pula para a funcao que ira comparar as strings
  	beq $v0, 1, remover_livro       # se $v0 for 1, significa que o comando digitado foi o de remover_livro
  	
  	lw $ra, 0($sp) 		#resgata o $ra original do $sp
    addi $sp, $sp, 4	#devolve a pilha para a posicao original
    
  	jr $ra
  	
verificar_cmd_remover_usuario:
	# Aloca espaco no $sp para salvar o endereco de $ra
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
  	la $s1, cmd_remover_usuario     # Carrega o endereco de cmd_remover_usuario
  	la $s0, comando                 # Carrega o endereco de comando em S0
  	li $s2, 15                      # Define a quantidade de caracteres de comando que irao ser comparados
  	jal comparar_strings            # Pula para a funcao que ira comparar as strings
  	beq $v0, 1, remover_usuario     # se $v0 for 1, significa que o comando digitado foi o de remover_usuario
	
	lw $ra, 0($sp) 		#resgata o $ra original do $sp
    addi $sp, $sp, 4	#devolve a pilha para a posicao original
    
	jr $ra

verificar_cmd_salvar_dados:
	# Aloca espaco no $sp para salvar o endereco de $ra
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
  	la $s1, cmd_salvar_dados        # Carrega o endereco de cmd_savar_dados
    la $s0, comando                 # Carrega o endereco de comando em S0
  	li $s2, 12                      # Define a quantidade de caracteres de comando que irao ser comparados
  	jal comparar_strings            # Pula para a funcao que ira comparar as strings
  	beq $v0, 1, salvar_dados        # se $v0 for 1, significa que o comando digitado foi o de savar_dados
  	
  	lw $ra, 0($sp) 		#resgata o $ra original do $sp
    addi $sp, $sp, 4	#devolve a pilha para a posicao original
    
  	jr $ra
  	
verificar_cmd_formatar_dados:
	# Aloca espaco no $sp para salvar o endereco de $ra
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
  	la $s1, cmd_formatar_dados      # Carrega o endereco de cmd_formatar_dados
    la $s0, comando                 # Carrega o endereco de comando em S0
  	li $s2, 14                      # Define a quantidade de caracteres de comando que irao ser comparados
  	jal comparar_strings            # Pula para a funcao que ira comparar as strings
  	beq $v0, 1, formatar_dados      # se $v0 for 1, significa que o comando digitado foi o de formatar_dados
  	
  	lw $ra, 0($sp) 		#resgata o $ra original do $sp
    addi $sp, $sp, 4	#devolve a pilha para a posicao original
    
	jr $ra
	
verificar_cmd_data_hora:
	# Aloca espaco no $sp para salvar o endereco de $ra
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
  	la $s1, cmd_data_hora           # Carrega o endereco de cmd_data_hora
    la $s0, comando                 # Carrega o endereco de comando em S0
  	li $s2, 9                       # Define a quantidade de caracteres de comando que irao ser comparados
  	jal comparar_strings            # Pula para a funcao que ira comparar as strings
  	beq $v0, 1, data_hora           # se $v0 for 1, significa que o comando digitado foi o de data_hora
  	
  	lw $ra, 0($sp) 		#resgata o $ra original do $sp
    addi $sp, $sp, 4	#devolve a pilha para a posicao original
    
  	jr $ra
  	
verificar_ajustar_data:	
	# Aloca espaco no $sp para salvar o endereco de $ra
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
  	la $s1, cmd_ajustar_data        # Carrega o endereco de ajustar_data
    la $s0, comando                 # Carrega o endereco de comando em S0
  	li $s2, 12                      # Define a quantidade de caracteres de comando que irao ser comparados
  	jal comparar_strings            # Pula para a funcao que ira comparar as strings
  	beq $v0, 1, ajustar_data           # se $v0 for 1, significa que o comando digitado foi o de ajustar_data
  	
  	lw $ra, 0($sp) 		#resgata o $ra original do $sp
    addi $sp, $sp, 4	#devolve a pilha para a posicao original
    
  	jr $ra
	
guardar_info_buffer:
	# $t1: contem qual o buffer a ser usado
	# $s0: contem o comando dado pelo usuario
	
	lb $t0, 0($s0)           # Carrega o proximo caractere
	li $t2, 34 			   	 # Carrega aspas duplas
    bne $t0, $t2, escrever_comando_invalido_display 	# caso o proximo caracter nao for de aspas duplas, o comando eh invalido
    addi $s0, $s0, 1

	# Copia os caracteres ateh a segunda aspa dupla
	copy_loop:
    	lb $t0, 0($s0)            # Carrega o proximo caractere
    	beqz $t0, end             # Se for nulo (fim da string), encerra
    	beq $t0, $t2, finalize    # Se for aspas duplas ('"'), finaliza a copia
    	sb $t0, 0($t1)            # Copia o caractere para o buffer do titulo
    	addi $s0, $s0, 1          # Avanca para o proximo caractere
    	addi $t1, $t1, 1          # Avanca no buffer do titulo
    	j copy_loop

	# Finaliza o buffer adicionando a virgula
	finalize:
		addi $s0, $s0, 1 			#Passa das aspas
    	jr $ra
    end:
    	j escrever_comando_invalido_display 	# Caso haja um caracter nulo e nao um de aspas duplas, o comando eh invalido

cadastrar_livro:
	
	# Primeiro, verificamos se o argumento a seguir eh o esperado
	la $s1, arg_titulo
	# $s0 ja tem o comando a ser passado
	addi $s0, $s0, 1 	# Passa um caractere para frente, por conta do espaco entre os comandos
	li $s2, 8           # Define a quantidade de caracteres a ser avaliados
	jal comparar_strings
	beqz $v0, escrever_falta_argumento_titulo_display
	
	addi $s0, $s0, 1 	# Passa um caractere para frente, por conta do espaco entre os comandos
	# Pega o que estah entre aspas e salva no buffer
	la $t1, titulo
	jal guardar_info_buffer
	# Colocar a virgula no fim do buffer
	la $t3, virgula          # Carrega o endereco da virgula (',')
	lb $t2, 0($t3)           # Carrega o byte do caractere da virgula
    sb $t2, 0($t1)           # Adiciona a virgula ao final do titulo
	
	# Verificamos se o argumento a seguir eh valido
	la $s1, arg_autor
	# $s0 ja tem o comando a ser passado
	addi $s0, $s0, 1 	# Passa um caractere para frente, por conta do espaco entre os comandos
	li $s2, 7
	jal comparar_strings
	beqz $v0, escrever_falta_argumento_autor_display
	
	addi $s0, $s0, 1 	# Passa um caractere para frente, por conta do espaco entre os comandos
	# Pega o que estah entre aspas e salva no buffer
	la $t1, autor
	jal guardar_info_buffer
	la $t2, virgula          # Carrega o endereco da virgula (',')
	lb $t2, 0($t2)           # Carrega o byte do caractere da virgula
    sb $t2, 0($t1)           # Adiciona a virgula ao final do autor
	
	# Verificamos se o argumento a seguir eh valido
	la $s1, arg_ISBN
	# $s0 ja tem o comando a ser passado
	addi $s0, $s0, 1 	# Passa um caractere para frente, por conta do espaco entre os comandos
	li $s2, 6
	jal comparar_strings
	beqz $v0, escrever_falta_argumento_ISBN_display
	
	addi $s0, $s0, 1 	# Passa um caractere para frente, por conta do espaco entre os comandos
	# Pega o que est�ver entre aspas e salva no buffer
	la $t1, ISBN
	jal guardar_info_buffer
	la $t2, virgula          # Carrega o endereco da virgula (',')
	lb $t2, 0($t2)           # Carrega o byte do caractere da virgula
    sb $t2, 0($t1)           # Adiciona a virgula ao final do ISBN
    
    # Verificamos se o argumento a seguir eh valido
	la $s1, arg_quantidade
	# $s0 ja tem o comando a ser passado
	addi $s0, $s0, 1 	# Passa um caractere para frente, por conta do espaco entre os comandos
	li $s2, 5
	jal comparar_strings
	beqz $v0, escrever_falta_argumento_quantidade_display
	
	addi $s0, $s0, 1 	# Passa um caractere para frente, por conta do espaco entre os comandos
	# Pega o que estah entre aspas e salva no buffer
	la $t1, quantidade
	jal guardar_info_buffer  # Adiciona ao final da quantidade
	la $t2, barra_n          # Carrega o endereco de barra_n
	lb $t2, 0($t2)           # Carrega o byte do caractere de barra n ('\n') 
    sb $t2, 0($t1)           # Escreve o caractere \n
	
	# Agora vamos salvar no repositorio (buffer) de livros
	# Para isso, vamos concatenar todas as informacoes que obtivemos em uma unica string e coloca-la no repo_livro
	la $s0, repo_livro  # Carrega o endereco de repo_livro
	la $s1, ISBN        # Carrega o endereco de isbn
	jal str_concat      # Pula para a funcao que vai concatenar os dados de isbn em repo_livro
	la $s1, ISBN        # Recarrega o endereco de isbn novamente (para voltar ao 1� caractere)
	jal clear_buffer	# Limpa o buffer de ISBN
	
	la $s1, titulo		# Carrega o endereco de titulo
	jal str_concat      # Pula para a funcao que vai concatenar os dados de t�tulo em repo_livro
	la $s1, titulo      # Recarrega o endereco de titulo novamente (para voltar ao 1� caractere)
	jal clear_buffer	# Limpa o buffer de titulo
	
	la $s1, autor       # Carrega o endereco de autor
	jal str_concat      # Pula para a funcao que vai concatenar os dados de autor em repo_livro
	la $s1, autor       # Recarrega o endereco de autor novamente (para voltar ao 1� caractere)
	jal clear_buffer	# Limpa o buffer de autor
	
	la $s1, quantidade  # Carrega o endereco de quantidade
	jal str_concat      # Pula para a funcao que vai concatenar os dados de quantidade em repo_livro
	la $s1, quantidade  # Recarrega o endereco de quantidade novamente (para voltar ao 1� caractere)
	jal clear_buffer	# Limpa o buffer de quantidade
	
	# Limpa o buffer de comando
	la $s1, comando
	jal clear_buffer
	
	la $t1, msgC_livro_cadastrado   # Carrega o endereco de msgC_livro_cadastrado
	j escrever_com_sucesso_display

avancar_ate_barra_n:
	# $s1: reg que possui o endereco do repositiorio que estah sendo varrido
	
	la $t1, barra_n   # Carrega o endereco de barra_n
	lb $t1, 0($t1)    # Carrega o byte que carrega o byte do caractere '\n'
	 
	loop_avancar_barra_n:
		lb $t2, 0($s1)                  # Carrega o caractere em repo_livro
		beq $t2, $t1, fim_loop_avancar  # Caso $s1 seja tenha o caractere \n, o loop encerra
		addi $s1, $s1, 1                # Contrario avanca o caractere
		j loop_avancar_barra_n          # Entra em loop
	
	fim_loop_avancar:
		jr $ra

descobrir_qtd_caracteres_comparacao:
	# $s1: reg que possui o endereco do repositiorio que estah sendo varrido
	
	la $t1, virgula  # Carrega o endereco de virgula
	lb $t1, 0($t1)    # Carrega o byte que contem o valor do caractere virgula em ascii
	
	li, $s7, 0       # Inicializa $s7 com 0 (reg que servir� como contador de digitos do isbn)
	li, $s6, 0       # Inicializa $s6 com 0 (reg que tbm � um contador, a qual serve como condicao de parada em voltar_s1
	
	loop_qtd_digitos:
		lb $t2, 0($s1)            # Carrega o caractere
		beq $t2, $t1, voltar_s1   # Caso o caractere em $s1, seja  virgula pula para funcao que volta o $s1 para o comeco da linha
		addi $s1, $s1, 1          # Avanca para o proximo caractere
		addi $s6, $s6, 1          # Incrementa $s6
		addi $s7, $s7, 1          # Incrementa $s7
		j loop_qtd_digitos        # Entra em loop
	
	# loop que retorna a quantidade de caracteres avancados em $s1 pelo loop_qtd_digitos
	voltar_s1:
		beqz $s6, encerrar_loop    # Quando $s6 for igual a 0 encerra o loop
		subi $s6, $s6, 1           # Decrementa $s6
		subi $s1, $s1, 1            # retorna 1 caractere
		j voltar_s1                # Entra em loop
	
	encerrar_loop:
		# Apos a execucao dessa funcao $s7 irah conter a quantidade de digitos do isbn do livro analisado
		jr $ra

fazer_busca_no_repositorio:
	# $s1: reg que possui o endereco do repositorio que irah ser feita a busca
	# $s3: reg que possui o endereco do atributo que contem os dados da busca (livro -> isbn, usuario -> matricula)
	
	# Aloca espaco no $sp para salvar o endereco de $ra
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    loop_busca_repo_livro:
    	jal descobrir_qtd_caracteres_comparacao    # Pula para a funcao que descobre a quantidade de digitos do isbn
    	move $s0, $s3                     # copia o valor do endereco de $s3 para $s0                      
    	move $s2, $s7                     # Copia o valor de $s7, para $s2
    	jal comparar_strings              # pula para a funcao que vai comparar o ibsn do livro com o isbn digitado
    	beq $v0, 1, entidade_encontrada   # Se $v0 for igual a 1 a busca eh encerrada
    	jal avancar_ate_barra_n           # Caso contrario, pula para a funcao que avanca ate o barra n
    	addi $s1, $s1, 1                  # Avanca para o proximo caractere apos o \n
    	beqz $s1, fim_loop_busca          # Caso em $s1 tenha o caractere de nulo \0 o loop eh encerrado 
    	j loop_busca_repo_livro
    
    entidade_encontrada:
    	jal decrementar_s1  # funcao que ajusta $s1 para o endereco do 1� byte da entidade encontrada 
    	
    fim_loop_busca:
    	lw $ra, 0($sp) 	    # Resgata o $ra original do $sp
    	addi $sp, $sp, 4	# Devolve a pilha para a posicao original
     	jr $ra
		
# Essa funcao decrementa $s1 para que ele contenha o apos a execucao 
# dessa funcao o endereco exato do 1� byte do livro a ser removido
decrementar_s1:
    # $s7: reg que possui a quantidade de caracteres que deve regredidos em $s1
    # $s1: reg que possui o endereco do repositorio que irah ser feita a busca

	loop_decrementar_s1:
		beqz $s7, fim_loop_decrementar    # Quando $s7 for igual a 0 encerra o loop
		subi $s7, $s7, 1                  # Decrementa $s7
		subi $s1, $s1, 1                  # retorna 1 caractere
		j loop_decrementar_s1             # Entra em loop
	
	fim_loop_decrementar:
		jr $ra
		
limpar_bytes_entidade_removida:
	# $s2: reg que possui o endereco do 1� byte a ser sobrescrito com byte nulo no repositorio

	loop_limpar:
		lb $s7, 0($s2)                  # Carrega o byte em $s2
		beq $zero, $s7, fim_loop_limpar # Verifica se $s7 eh o byte nulo (fim dos dados do repositorio)
		sb $zero, 0($s2)                # Caso nao seja, sobrescreve com o byte nulo
		addi $s2, $s2, 1                # Avanca para o proximo caractere
		j loop_limpar
		
	fim_loop_limpar:
		jr $ra
		
# funcao generica que remove livro, usuario ou emprestimo em qualquer repositorio
deletar_entidade_no_repositorio:
	# $s1: reg que possui o endereco do 1� byte da entidade a ser removida no repositorio
	
	# Aloca espaco no $sp para salvar o endereco de $ra
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
	move $s2, $s1             # Copia o endereco de s1 para $s2
	jal avancar_ate_barra_n   # Avanca $s1 para at� o caractere de barra n '\n'
	addi $s1, $s1 , 1         # avan�a mais um caractere
	
	# Agora neste ponto $s1 contem o 1� byte do livro posterior e 
	# $s2 cont�m o 1� byte do livro a ser removido
	
	# O trecho abaixo verifica se o byte de $s1 � o caractere nulo '\0' Caso seja, significa 
    # que a entidade a ser removida est� na ultima posi��o do reposit�rio
    # OBS: ultima n�o sentido de ser a �nica entidade no repositorio, mas sim no sentido 
    # de ser a �ltima entidade registrada
    lb $t1, 0($s1)    
	beqz $t1, preencher_entidade_com_byte_nulo 
	# Caso nao seja, nos sobrescrevemos os dados de $s2 com dados das entidades posteriores $s1
	j sobrescrever_com_as_entidades_posteriores 
	
	preencher_entidade_com_byte_nulo:
		lb $s2, 0($s2)                      # Carrega o byte de $s2
   		beq $s2, $zero, finalizar_remocao   # Se $s2 seja o byte nulo, o loop encerra
   		sb $zero, 0($s2)                    # Caso contrario, preenche com o byte de $s2 com o byte nulo
   		addi $s2, $s2, 1                    # Avanca mais um caractere
   		j preencher_entidade_com_byte_nulo  # Entra em looping
   	
# Move os dados subsequentes para preencher o espa�o deixado pela entidade removida
    sobrescrever_com_as_entidades_posteriores:
    	lb $t2, 0($s2)
    	lb $t0, 0($s1)            # Carrega o pr�ximo byte do reposit�rio
    	beqz $t0, fim_sobrescrita # Se for fim de string, termina
    	sb $t0, 0($s2)            # Sobrescreve o byte no endere�o indicado por $s2
    	lb $t3, 0($s2)
   		addi $s1, $s1, 1          # Avan�a $s1 para o pr�ximo byte
    	addi $s2, $s2, 1          # Avan�a $s2 para o pr�ximo byte
    	j sobrescrever_com_as_entidades_posteriores   # Entra em loop

	fim_sobrescrita:
    	sb $zero, 0($s2)                     # Coloca o caractere de fim de string no final do reposit�rio
    	jal limpar_bytes_entidade_removida   # pula para a funcao que vai fazer uma pequena correcao
    	j finalizar_remocao                  # Finaliza a fun��o
    	
    finalizar_remocao:
		lw $ra, 0($sp) 		#resgata o $ra original do $sp
    	addi $sp, $sp, 4	#devolve a pilha para a posicao original
		jr $ra
	
remover_livro:
	# O trecho abaixo verifica se repo_livro est� vazio
	la $s1, repo_livro    # Carrega o endereco de repo_livro
	lb $s1, 0($s1)        # Carrega o 1� byte de repo livro
	beqz $s1, escrever_acervo_vazio_display    # Caso $s1, seja zero, pula para funcao que imprime a mensagem de acervo vazio
	
	addi $s0, $s0, 1 # Caso contr�rio, passa um caractere para frente, por conta do espaco entre os comandos
	
	# Verificamos se o argumento --isbn eh valido
	la $s1, arg_ISBN
	# $s0 ja tem o comando a ser passado
	li $s2, 6              # Passa a quantidade de caracteres em $s0 que ser� comparada com $s1
	jal comparar_strings   # Pula para a funcao que ir� comparar
	beqz $v0, escrever_falta_argumento_ISBN_display  # se $v0 for igual a 0, significa que o argumento digitado n�o � o de --isbn 
	
	addi $s0, $s0, 1 	# Passa um caractere para frente, por conta do espaco entre os comandos
	# Pega o que est�ver entre aspas e salva no buffer
	la $t1, ISBN
	jal guardar_info_buffer
    
    # O trecho abaixo faz uma busca em repo_emprestimo para ver se o livro possui devolucoes pendentes
    #la $s1, repo_emprestimo            # Carrega o endereco de repo_emprestimo
    #la $s3, la $s3, ISBN               # Carrega o endereco de ISBN_livro_ass
    #jal fazer_busca_no_repositorio     # Pula para a funcao que vai fazer uma busca do ISBN no reposit�rio
    #beq $v0, 1, escrever_livro_esta_emprestado_display   # Caso v0 seja 1 pula para a funcao que imprime livro possui devolucoes pendentes
    
    # O trecho abaixo faz uma busca em repo_livro para ver se o livro existe em repo_livro
    la $s1, repo_livro              # Carrega o endereco de repo_livro
    la $s3, ISBN                    # Carrega o endereco de ISBN
    jal fazer_busca_no_repositorio  # Pula para a funcao que vai fazer uma busca do ISBN em repo_livro
    beqz $v0, escrever_livro_nao_encontrado_display   # Caso v0 seja 0 pula para a funcao que impre livro nao encontrado

    # Se $v0 for igual a 1, significa que o livro existe, e em $s1
    # ir� conter o endereco do 1� byte do livro a ser removido
    jal deletar_entidade_no_repositorio  
	
	# Limpa os buffers de comando e isbn
	la $s1, comando
	jal clear_buffer
	
	la $s1, ISBN
	jal clear_buffer
	
	# Escreve a mensagem de confirmacao
	la $t1, msgC_livro_removido     # Carrega o endereco de msgC_livro_removido
	j escrever_com_sucesso_display

listar_livro:
		
	la $t1, repo_livro             # Carrega o endereco de repo_livro
	jal escrever_string_display    # Pula para a funcao que imprime strings (ele todo no caso)
	la $s1, comando
	jal clear_buffer
	
	j main

cadastrar_usuario:

    # Verifica o argumento "--nome"
    la $s1, arg_nome          # Carrega o endereco string "--nome" em $s1
    addi $s0, $s0, 1          # Passa um caractere para frente por conta do espaco
    li $s2, 6                 # Tamanho esperado argumento
    jal comparar_strings      # funcao para comparar strings
    beqz $v0, escrever_falta_argumento_nome_display # Se as strings nao forem iguai, exibe erro

    addi $s0, $s0, 1           # Move o ponteiro para a proxima info
    la $t1, nome               # Carrega o endereco do nome em $t1
    jal guardar_info_buffer    # Guarda o conteudo entre aspas no bufffer nome
    la $t2, virgula            # Carrega o endereco da virgula (',')
	lb $t2, 0($t2)             # Carrega o byte do caractere da virgula
	sb $t2, 0($t1)             # Adiciona o caractere de virgula no final de nome

    # Verifica o argumento "--matricula"
    la $s1, arg_matricula      # Carrega o endereco da string "--matricula"  em $s1
    addi $s0, $s0, 1           # Move o ponteiro para o proximo argumento
    li $s2, 11                 # Tamanho esperado do argumento
    jal comparar_strings       # funcao para comparar strings
    beqz $v0, escrever_falta_argumento_matricula_display # Se as strings nao forem iguais, exibe erro

    addi $s0, $s0, 1            # Move o ponteiro para a proxima info
    la $t1, matricula           # Carrega o endereco do matricula em $t1
    jal guardar_info_buffer     # Guarda o conteudo entre aspas no bufffer matricula
    la $t2, virgula             # Carrega o endereco da virgula (',')
	lb $t2, 0($t2)              # Carrega o byte do caractere da virgula
    sb $t2, 0($t1)              # Adiciona virgula ao final da matricula

    # Verifica o argumento "--curso"
    la $s1, arg_curso           # Carrega o endereco string "--curso"em $s1
    addi $s0, $s0, 1            # Passa um caractere para frente por conta do espaco
    li $s2, 7                   # Tamanho esperado do argumento
    jal comparar_strings        # funcao para comparar strings
    beqz $v0, escrever_falta_argumento_curso_display # Se as strings nao forem iguais, exibe erro

    addi $s0, $s0, 1           # Move o ponteiro para a proxima info
    la $t1, curso              # Carrega o endereco do curso em $t1
    jal guardar_info_buffer    # Guarda o conteudo entre aspas no buffer curso
    la $t2, barra_n            # Carrega o endereco de barra_n
	lb $t2, 0($t2)             # Carrega o byte do caractere de barra n ('\n') 
    sb $t2, 0($t1)             # Adiciona \n ao final do curso

    # Concatena as informacoes no repositorio de usuarios
    la $s0, repo_usuario    # Carrega o endereco do repositorio de usuarios em $s0.
    la $s1, nome            # Carrega o endereco do buffer "nome" em $s1.
    jal str_concat          # Concatena o nome ao repositario de usuarios.
    la $s1, nome            # Recarrega o endereco de nome novamente (para voltar ao 1� caractere)
    jal clear_buffer        # Limpa o buffer "nome".

    la $s1, matricula   	# Carrega o endereco do buffer `matricula` em $s1.
    jal str_concat      	# Concatena a matricula ao repositorio de usuarios.
	la $s1, matricula  		# Recarrega o endereco de matricula novamente (para voltar ao 1� caractere)
	jal clear_buffer    	# Limpa o buffer "matricula".

    la $s1, curso       	# Carrega o endereco do buffer `curso` em $s1.
    jal str_concat      	# Concatena o curso ao repositorio de usuarios.
    la $s1, curso       	# Recarrega o endereco de curso novamente (para voltar ao 1� caractere)	
    jal clear_buffer    	# Limpa o buffer "curso".
	
	la $t1, repo_usuario            # Carrega o endereco do repositorio de usuarios em $t1.
	jal escrever_string_display     # Exibe o conteudo do repositorio de usuarios.
	
	# Limpa o buffer de comando
    la $s1, comando       # Carrega o endereco do buffer `comando` em $s1.
    jal clear_buffer      # Limpa o buffer de comando.

    # Mensagem de sucesso
    la $t1, msgC_usuario_cadastrado   # Carrega a mensagem de sucesso em $t1.
    j escrever_com_sucesso_display    # Exibe a mensagem de sucesso.

remover_usuario:
	addi $s0, $s0, 1 # Passa um caractere para frente, por conta do espaco entre os comandos
	
	# Verificamos se o argumento --matricula eh valido
	la $s1, arg_matricula
	# $s0 ja tem o comando a ser passado
	li $s2, 11             # Passa a quantidade de caracteres em $s0 que ser� comparada com $s1
	jal comparar_strings   # Pula para a funcao que ir� comparar
	beqz $v0, escrever_falta_argumento_ISBN_display  # se $v0 for igual a 0, significa que o argumento digitado n�o � o de --isbn 
	
	addi $s0, $s0, 1 	# Passa um caractere para frente, por conta do espaco entre os comandos
	# Pega o que est�ver entre aspas e salva no buffer
	la $t1, matricula
	jal guardar_info_buffer
    
    # O trecho abaixo faz uma busca em repo_emprestimo para ver se o livro possui devolucoes pendentes
    #la $s1, repo_emprestimo            # Carrega o endereco de repo_emprestimo
    #la $s3, la $s3, matricula          # Carrega o endereco de ISBN_livro_ass
    #jal fazer_busca_no_repositorio     # Pula para a funcao que vai fazer uma busca do ISBN no reposit�rio
    #beq $v0, 1, escrever_livro_esta_emprestado_display   # Caso v0 seja 1 pula para a funcao que imprime livro possui devolucoes pendentes
    
    # O trecho abaixo faz uma busca em repo_usuario para ver se o usuario existe
    la $s1, repo_usuario            # Carrega o endereco de repo_usuario
    la $s3, matricula               # Carrega o endereco de matricula
    jal fazer_busca_no_repositorio  # Pula para a funcao que vai fazer uma busca do ISBN em repo_usuario
    beqz $v0, escrever_usuario_nao_encontrado_display   # Caso v0 seja 0 pula para a funcao que imprime usuario nao encontrado

    # Se $v0 for igual a 1, significa que o livro existe, e em $s1
    # ir� conter o endereco do 1� byte do livro a ser removido
    jal deletar_entidade_no_repositorio  
	
	# Limpa os buffers de comando e matricula
	la $s1, comando
	jal clear_buffer
	
	la $s1, matricula
	jal clear_buffer
	
	# Escreve a mensagem de confirmaca	
	la $t1, msgC_usuario_removido   # Carrega o endereco de msgC_usuario_removido
	j escrever_com_sucesso_display
	
registrar_emprestimo:
	# Em construcao
	
	# Limpa o buffer de comando
	la $s1, comando
	jal clear_buffer
	
	la $t1, msgC_emprestimo_realizado  # Carrega o endereco de msgC_emprestimo_realizado
	j escrever_com_sucesso_display

gerar_relatorio:
	# Em construcao
	
	# Limpa o buffer de comando
	la $s1, comando
	jal clear_buffer
	
	j main

salvar_dados:
  	la $t0, local_arquivo_livros      # Carrega o endereco do caminho do arquivo txt de livros
  	la $t1, repo_livro                # Carrega o endereco do repositorio que contem os dados a ser salvos
  	jal salvar_dados_no_arquivo       # pula para a funcao generica que salva os dados no arquivo .txt
  	
  	la $t0, local_arquivo_usuario     # Carrega o endereco do caminho do arquivo .txt de usuarios
  	la $t1, repo_usuario              # Carrega o endereco do repositorio que contem os dados a ser salvos
  	jal salvar_dados_no_arquivo       # pula para a funcao generica que salva os dados no arquivo .txt
  	
  	la $t0, local_arquivo_emprestimo  # Carrega o endereco do caminho do arquivo .txt de emprestimo
  	la $t1, repo_emprestimo           # Carrega o endereco do repositorio que contem os dados a ser salvos
  	jal salvar_dados_no_arquivo       # pula para a funcao generica que salva os dados no arquivo .txt
    
    la $t1, msgC_dados_salvos         # Imprime a mensagem dados confirmando que os dados foram salvos
    jal escrever_com_sucesso_display         

repositorio_len:	
	lb $t4, ($t3)            # carrega o byte de t3
	addi $t3, $t3, 1 
	addi $t2, $t2, 1
	bnez $t4, repositorio_len # se t4 eh diferente de 0 recomeca a funcao
	subi $t2, $t2, 1          # subtrai 1 de t2 no final da funcao
	jr $ra                    # volta para ra
	
salvar_dados_no_arquivo:
	#$t0  reg que possui o caminho arquivo de destino
	#$t1  reg que possui o endereco do repositiorio
	#$t2  usado para contar o tamanho do repositorio, nao eh necessario informar valor
	#$t3  usado na funcao de repositorio_len
	#$t4  usado na funcao de repositorio_len
	#$s0  usado para salvar descritor
	#$s1  usado para armazenar $ra
	
	li $t2, 0      # inicializa t2 com 0
	li $v0, 13     # abre o arquivo no modo leitura
	move $a0, $t0  # move nome do arquivo output em a0
	li $a1, 1      # mode escrita
	li $a2, 0      # valor padrao
	syscall

	move $s0, $v0         # salva descritor em s0
	move $s1, $ra         # salvar o valor atual de ra em s1
	move $t3, $t1         # salva o endereco de t1 em t3
	
	# Aloca espaco no $sp para salvar o endereco de $ra
    addi $sp, $sp, -4
    sw $ra, 0($sp)
	
	jal repositorio_len   # conta o tamanho do repositorio e salva em t2
	
	li $v0, 15       # syscall para escrita
	move $a0, $s0    # move descritor para a0
	move $a1, $t1    # move endereco do repositorio para a1
	move $a2, $t2    # move tamanho do repositorio para a2
	syscall          # chama syscall de escrita
	
	# Limpa o buffer de comando
	la $s1, comando
	jal clear_buffer
	
	lw $ra, 0($sp) 		#resgata o $ra original do $sp
    addi $sp, $sp, 4	#devolve a pilha para a posicao original
	
	jr $ra
	
formatar_dados:
	# Do your jump, mari
	
	# Limpa o buffer de comando
	la $s1, comando
	jal clear_buffer
	
	la $t1, msgC_dados_apagados        # Imprime a mensagem dados confirmando que os dados foram apagados
	jal escrever_com_sucesso_display

data_hora:
    la $t0, data_config_usuario   					# Carrega o endereco de data_config_usuario
    lb $t1, 0($t0)          						# Carrega o byte 
    beqz $t1, gerar_e_imprimir_data_hora_atual  	# Se o byte for 0, pula para a funcao que vai imprimir a data e hora atual
    
    # Caso contrario, entao o usuario armazenou a data e hora da configuradas por ele
    jal imprimir_data_hora_usuario
	
	j main
	
gerar_e_imprimir_data_hora_atual:
	jal gerar_data_atual  # Funcao que armazena o ano no $s0, o mes no $s1 e o dia no $s2

    move $t0, $s0  # Copia o ano para $t0
    move $t1, $s1  # Copia o mes para $t1
    move $t2, $s2  # Copia o dia para $t2
    
	la $t6, data_atual    # Carrega o endereco de data_atual 

	li $t5, 10            # inicializa $t5 com 10
	
	# Atualiza o $ra para que caso, a condicao abaixo seja verdadeira o fluxo do codigo
	# por meio do jr $ra do inserir_zero retorne volte para a linha:  move $t7, $t2 (6 linhas abaixo)                    
	addi $ra, $ra, 12
	
	# Verifica se o dia eh menor que 10, se for, pula para a funcao que coloca o 0 primeiro em data_sistema
	blt $t2, $t5, inserir_zero
	
	move $t7, $t2                    # Copia o valor de $t2 em $t7  (o dia)
    jal  converter_int_para_string   # Pula para a funcao que vai converter o inteiro para string e inserir em data_atual 
	
	addi $t6, $t6, 1        # Avanca para a proxima posicao
	la $t4, barra           # Carrega o endereco do caractere de barra
	lb $t4, 0($t4)          # Carrega o caractere de barra em $t4
    sb $t4, 0($t6)         	# Insere o caractere de barra em data_atual
	addi $t6, $t6, 1        # Avanca para a proxima posicao
	
	li $t5, 10              # inicializa $t5 com 10
	
	# Atualiza o $ra para que caso, a condicao abaixo seja verdadeira o fluxo do codigo
	# por meio do jr $ra do inserir_zero retorne volte para a linha:  move $t7, $t1 (7 linhas abaixo)                    
	addi $ra, $ra, 40 
	
    # Verifica se o mes eh menor que 10 e se for, pula para colocar um zero na frente
    blt $t1, $t5, inserir_zero
    move $t7, $t1                    # Copia o valor de $t1 em $t7 (O mes) 
    jal  converter_int_para_string   # Pula para a funcao que vai converter o inteiro para string e inserir em data_atual 
    
    addi $t6, $t6, 1        # Avanca para a proxima posicao
    la $t4, barra           # Carrega o endereco do caractere de barra
	lb $t4, 0($t4)          # Carrega o caractere de barra em $t4
    sb $t4, 0($t6)         	# Insere o caractere de barra em data_atual
    addi $t6, $t6, 1        # Avanca para a proxima posicao
    
	sb $t4, 0($t6)        			 # Insere o caractere de barra em data_sistema
	move $t7, $t0                    # Copia o valor de $t2 em $t7 (O ano) 
    jal  converter_int_para_string   # Pula para a funcao que vai converter o inteiro para string e inserir em data_atual 
	
	la $t1, string_data
	jal escrever_string_display   # Escreve a string "Data: " no display
	
	la $t1, data_atual				
	jal escrever_string_display   # Escreve a data  no display
	jal escrever_barra_n_display  # Causa uma quebra de linha no display
	
	jal gerar_hora_atual  # Funcao que armazena a hora no $s0 e o minuto no $s1 
	
	move $t0, $s0 		  # Copia a hora para $t0
    move $t1, $s1 		  # Copia o minuto para $t1
	
	la $t6, hora_atual    # Carrega o endereco de hora_Atual
	li $t5, 10            # inicializa $t5 com 10
	
	# Atualiza o $ra para que caso, a condicao abaixo seja verdadeira o fluxo do codigo
	# por meio do jr $ra do inserir_zero retorne volte para a linha:  move $t7, $t0 (5 linhas abaixo)                    
	addi $ra, $ra, 32
	
	# Verifica se a hora eh menor que 10, se for, pula para a funcao que coloca o 0 primeiro em data_sistema
	blt $t0, $t5, inserir_zero       
	move $t7, $t0                    # Copia o valor de $t1 em $t7 (O mes) 
    jal  converter_int_para_string   # Pula para a funcao que vai converter o inteiro para string e inserir em hora_atual 
	
	addi $t6, $t6, 1        # Avanca para a proxima posicao
    la $t4, dois_pontos     # Carrega o endereco do caractere de barra
	lb $t4, 0($t4)          # Carrega o caractere de barra em $t4
    sb $t4, 0($t6)         	# Insere o caractere de barra em data_atual
    addi $t6, $t6, 1        # Avanca para a proxima posicao
	
	li $t5, 10            # inicializa $t5 com 10
	
	# Atualiza o $ra para que caso, a condicao abaixo seja verdadeira o fluxo do codigo
	# por meio do jr $ra do inserir_zero retorne volte para a linha:  move $t7, $t1 (4 linhas abaixo)                    
	addi $ra, $ra, 40
	
	blt $t1, $t5, inserir_zero	  # Verifica se o minuto eh menor que 10, se for, pula para a funcao que coloca o 0 primeiro em data_sistema
	move $t7, $t1                     # Copia o valor de $t1 em $t7 (O mes) 
    jal  converter_int_para_string    # Pula para a funcao que vai converter o inteiro para string e inserir em hora_atual 
	
	la $t1, string_hora
	jal escrever_string_display   # Escreve a string "Hora: " no display
	
	la $t1, hora_atual				
	jal escrever_string_display   # Escreve a hora  no display
	jal escrever_barra_n_display  # Causa uma quebra de linha no display
	
	j main

inserir_zero:
	# $t6: reg que possui o endereco da data_atual onde o 0 sera inserido
	
	li $t9, 0           # Carrega o valor de 0 em $t8
	addi $t9, $t9, 48   # Converte o valor 0 para o caractere ASCII '0'
	sb $t9, 0($t6)      # Insere o 0 na posicao em data_sistema
	addi $t6, $t6, 1    # Avanca para a proxima posicao
	
	jr $ra
	
converter_int_para_string:
	# $t6: reg que possui espaco de memoria que ira ser inserida a string
	# $t7: reg que possui o inteiro a ser convertido para string 
	
    li $t2, 10  # Carrega o valor 10 em t1 
    li $t3, 0   # Carrega $t3 com 0 (reg que servira como contador de digitos do inteiro)
    
    loop_string:
        div $t7, $t2         		    # Opera $t2 / $t1
        mflo $t4 						# Move o quociente para $t4 
        mfhi $t5 						# Move o resto para $t5 
        addi $t5, $t5, 48   			# Converte o resto para caractere
    	addi $sp, $sp, -1  			    # Aloca espaco no $sp para inserir o caractere
    	sb $t5, 0($sp)                  # insere o caractere no sp
    	addi $t3, $t3, 1                # Incrementa $t3 
        move $t7, $t4	    			# Atualiza o $t4 com o quociente
        bne $t7, $zero, loop_string 	# Entra em loop ate que o inteiro seja 0
        
     loop_inserir_string_t0:
     	lb $t2, 0($sp)                   # Carrega o caractere do topo da pilha
     	sb $t2, 0($t6)                   # Armazena o caractere em $t0
     	addi $sp, $sp, 1                 # Incrementa o ponteiro do $sp voltando 1
     	subi $t3, $t3, 1                 # Decrementa $t3
     	beqz $t3, fim_loop_inserir       # Se $t3 for 0, quer dizer que todos os caracteres foram inseridos em $t0
     	addi $t6, $t6, 1                 # Caso contrario, incrementa $t6, para a insercao do proximo caractere
     	j loop_inserir_string_t0         # Entra em loop
     	
     fim_loop_inserir:
    	jr $ra
   		
gerar_data_atual:
    li $v0, 30     # Syscall para obter o tempo do sistema
    li $a1, 0      # Inicializa a1
    syscall

    move $t0, $a0        # Move a parte menos significativa dos milissegundos para $t0
    move $t1, $a1        # Move a parte mais significativa dos milissegundos para $t1

    # Conversao da parte menos significativa dos milissegundos para minutos
    li $t2, 60000        # Carrega em $t2 a quantidade de milissegundos em 1 minuto
    divu $t0, $t0, $t2   # Opera $t0 / 60000 (parte baixa para minutos) como unsigned
    mflo $t0             # Move para $t0 os minutos decorridos da parte menos significativa

    # Conversao da parte mais significativa de milissegundos para minutos
    # A conversao eh feita com base na seguinte formula: $t1 * 2^32 / 60000
    li $t2, 71582        # Carrega 71582 em $t2 que eh o resultado aproximado (2^32) / 60000
    mul $t1, $t1, $t2    # Multiplica 71582 com $t1 para obter os minutos decorridos com a parte mais significativa

    # Soma $t0 (quantidade de minutos decorridos da parte menos significativa)
    # com $t1 (quantidade de minutos decorridos da parte mais significativa)
    # para obter a quantidade total de minutos decorridos de 01/01/1970 pra ca
    addu $t0, $t0, $t1

    # O trecho abaixo soma o total de minutos com 138, isso porque a multiplicacao de 71582 * $t1
    # utilizou um valor aproximado, desconsiderando os seis digitos depois da virgula, e a ausencia
    # desses valores causa um atraso de 138 minutos para que a data seja atualizada, por isso o 
    # trecho abaixo corrige esse tempo de atraso 
    addiu $t0, $t0, 139

    # Conversao do total de minutos decorridos para dias
    li $t1, 1440         # Inicializa $t1 com 1440 (quantidade de minutos em um dia)
    divu $t0, $t0, $t1   # Opera $t0 / $t1 para obter a quantidade total de dias decorridos
    mflo $t0             # Armazena em $t0 a quantidade total de dias decorridos

    # Calculo dos anos decorridos (considerando anos bissextos)
    li $s0, 1970         # Inicializa $s0 com 1970 (a qual vai ser constantemente incrementado)

	ano_loopU:
   		li $t1, 365          # Inicializa $t1 com 365 (quantidade de dias em um ano nao bissexto)
    	li $t2, 4            # Inicializa $t2 com 4
    	remu $t3, $s0, $t2   # Armazena o resto da divisao de $s0 com $t2 como unsigned
    	beqz $t3, ano_bissextoU # Se resto de $t3 for 0, o ano eh bissexto
    	j verificar_dias_restantes_anoU

	ano_bissextoU:
    	addiu $t1, $t1, 1    # Incrementa $t1 com 1 para dizer que o ano em $s0 eh um ano que possui 366 dias

	verificar_dias_restantes_anoU:
    	bltu $t0, $t1, calcular_mesU # Se $t0 < $t1 pula para a funcao que calcula o mes
    	subu $t0, $t0, $t1    # Remove os dias do ano de $s0 do total de dias decorridos
    	addiu $s0, $s0, 1     # Incrementa o ano
    	j ano_loopU

	calcular_mesU:
    	li $s1, 1            # Inicializa $s1 com 1 (reg que vai conter o mes do ano)
    	addiu $t0, $t0, 1    # Incrementando $t0 para corrigir a diferenca de 1 dia menos

	mes_loopU:
    	li $t1, 30
    	beq $s1, 1, mes_com_31_diasU   # Se o mes em $s1 for 1, pula para a funcao que ajusta pra 31 dias       
    	beq $s1, 2, verificar_dias_fevereiroU # Se o mes em $s1 for 2, pula para a funcao que verifica a quantidade de dias
    	beq $s1, 3, mes_com_31_diasU   # Se o mes em $s1 for 3, pula para a funcao que ajusta pra 31 dias
    	beq $s1, 5, mes_com_31_diasU   # Se o mes em $s1 for 5, pula para a funcao que ajusta pra 31 dias
    	beq $s1, 7, mes_com_31_diasU   # Se o mes em $s1 for 7, pula para a funcao que ajusta pra 31 dias
    	beq $s1, 8, mes_com_31_diasU   # Se o mes em $s1 for 8, pula para a funcao que ajusta pra 31 dias
    	beq $s1, 10, mes_com_31_diasU  # Se o mes em $s1 for 10, pula para a funcao que ajusta pra 31 dias
    	j verificar_dias_restantes_mesU

	mes_com_31_diasU:
    	addiu $t1, $t1, 1  # Incrementa $t1 com 1 para indicar que o mes em $s1 eh um mes de 31 dias
    	j verificar_dias_restantes_mesU

	mes_com_29_diasU:
    	subiu $t1, $t1, 1  # Decrementa $t1 com 1 para indicar que o mes em $s1 eh um mes de 29 dias
    	j verificar_dias_restantes_mesU

	mes_com_28_diasU:
    	subiu $t1, $t1, 2  # Decrementa $t1 com 2 para indicar que o mes em $s1 eh um mes de 28 dias    
    	j verificar_dias_restantes_mesU

	verificar_dias_fevereiroU:
    	li $t2, 4 
    	remu $t3, $s0, $t2   # Armazena o resto da divisao de $s0 com $t2 como unsigned
    	beqz $t3, mes_com_29_diasU  # Se resto de $t3 for 0, significa que o ano eh bissexto 
    	j mes_com_28_diasU  # Se o ano nao eh bissexto pula para a funcao que ajusta a qtd de dias para 28

	verificar_dias_restantes_mesU:
    	bltu $t0, $t1, dia_do_mesU  # Se $t0 < $t1, pula para a funcao que calcula o dia do mes
    	subu $t0, $t0, $t1          # Remove os dias do mes de $s1 do total de dias decorridos
    	addiu $s1, $s1, 1           # Incrementa o mes
    	j mes_loopU

	dia_do_mesU:
    	move $s2, $t0        # Move os dias que restaram para $s2
    	jr $ra

gerar_hora_atual:
    li $v0, 30           # Syscall 30 para obter o tempo do sistema
    syscall
    
    move $t0, $a0        # Move a parte menos significativa dos milissegundos para $t0
    move $t1, $a1        # Move a parte mais significativa dos milissegundos para $t1

    # Conversao da parte menos significativa dos milissegundos para minutos
    li $t2, 60000        # Carrega em $t2 a quantidade de milissegundos em 1 minuto
    divu $t0, $t2        # Opera $t0 / 60000 (unsigned) para calcular minutos
    mflo $t0             # Move para $t0 os minutos decorridos da parte menos significativa
	
    # Conversao da parte mais significativa de milissegundos para horas
    # A conversao eh feita com base na seguinte formula: $t1 * 2^32 / 60000
    li $t2, 71582        # Carrega 71582 em $t2 que eh o resultado aproximado (2^32) / 60000
    mulu $t1, $t1, $t2   # Multiplica (unsigned) 71582 com $t1 para obter os minutos decorridos com a parte mais significativa
    
    # Soma $t0 (quantidade de minutos decorridos da parte menos significativa)
    # com $t1 (quantidade de minutos decorridos da parte mais significativa)
    # para obter a quantidade total de minutos decorridos de 01/01/1970 pra ca
    addu $t0, $t0, $t1
    
    # O trecho abaixo soma o total de minutos com 138, isso porque a multiplicacao de 71582 * $t1
    # utilizou um valor aproximado, desconsiderando os seis digitos depois da virgula, e a ausencia
    # desses valores causa um atraso de 138 minutos para que a data seja atualizada, por isso o 
    # trecho abaixo corrige esse tempo de atraso 
    addiu $t0, $t0, 139

    # Obtencao do total de minutos do dia atual
    li $t1, 1440         # Inicializa t1 com 1440 (quantidade de minutos em um dia) 
    divu $t0, $t1        # Opera $t0 / $t1 (unsigned) para obter a quantidade total de dias decorridos
    mfhi $t0
	
    # Separar minutos em horas e minutos
    li $t1, 60           # Minutos por hora
    divu $t0, $t1        # Divide (unsigned) para obter horas e resto
    mflo $s0             # $s0 = horas do dia
    mfhi $s1             # $s1 = minutos restantes

    jr $ra               # Retorna ao chamador

imprimir_data_hora_usuario:
	li $v0, 30   # Chama o syscall 30 para obter o horario
    syscall
    
    la $t2, tempo_hora_configurada0   # Carrega o endereco da variavel tempo_hora_configurada0
	la $t3, tempo_hora_configurada1   # Carrega o endereco da variavel tempo_hora_configurada1 
	
	lw $t0, 0($t2)  # Carrega o dado armazenado na variavel tempo_hora_configurada0
	lw $t1, 0($t3)  # Carrega o dado armazenado na variavel tempo_hora_configurada1
	
	# O trecho abaixo vai operar a subtracao do instante que o usuario configurou a data e hora pro instante atual
	# o resultado dessa subtracao vai resultar na quantidade de millissegundos decorridos nesse intervalo de tempo
	
	sub $t1, $a1, $t1    # Subtrai a parte mais significativa 
	sub $t0, $a0, $t0,   # Subtrai a parte menos significativa
	
	# Conversao da parte menos significativa dos milissegundos para minutos
    li $t2, 60000      	 # Carrega em $t2 a quantidade de milissegundos em 1 minuto
    div $t0, $t2         # Opera $t0 / 60000 (parte baixa para horas) 
    mflo $t0             # Move para $t0 as horas decorridas da menos significativa
	
    # Conversao da parte mais significativa de milissegundos para horas
    # A conversao eh feita com base na seguinte formula: $t1 * 2^32 / 60000
    li $t2, 71582        # Carrega 71582 em $t2 que eh o resultado aproximado (2^32) / 60000
    mul $t1, $t1, $t2    # Multiplica 71582 com $t1 para obter as minutos decorridos com a parte mais significativa
	
	# Soma $t0 (quantidade de minutos decorridos da parte menos significativa)
    # com $t1 (quantidade de minutos decorridos da parte mais significativa)
    add $t0, $t0, $t1
	
	blt $t0, 1, imprimir_data_tempo  # Se $t0, for menor que 1 minuto pula logo para a funcao que vai imprimir
	
	la $t1, hora_config_usuario  # Carrega o endereco de hora_config_usuario
	lb $t1, 2($t1)               # Carrega o byte que contem o minuto

	add $t0, $t0, $t1        # Soma os minutos configurados pelo usuario com os minutos decorridos
	
	# A linha abaixo verifica se o tempo em $t0 eh maior que 60 minutos 
	bge $t0, 60, ajustar_tempo   # Se o tempo em minutos for maior ou igual a 60 pula para a funcao que vai ajustar o tempo
	sb  $t0, 2($t1)              # Caso contrario, sobrescreve o byte de minuto em hora_config_usuario 
	j imprimir_data_tempo        # Pula para a impressao da data e tempo
	
	ajustar_tempo:
		li $t1, 60     # Carrega $t1 com 60
		div $t0, $t1   # Opera o tempo de corrido em minutos / 60
		mflo $t1       # Move para $t1 o quociente (horas decorridas)
		mfhi $t2       # move para $t2 o resto     (minutos restantes)
		
		la $t3, hora_config_usuario      # Carrega o endereco de hora_config_usuario
		lb  $t4, 0($t3)                  # Carrega em $t4 o byte de hora em hora_config_usuario
		
		add $t0, $t4, $t1           # Soma a hora configurada pelo usuario com as horas decorridas
		bge $t0, 24, ajustar_hora   # Verifica se as horas decorridas eh maior que 24 horas
		sb  $t0, 0($t3)    			# Sobrescreve o byte de horas em hora_config_usuario
		sb  $t2, 2($t3)	   			# sobrescreve o byte de minutos em hora_config_usuario
		j imprimir_data_tempo 		# Pula para funcao que imprime a data e o tempo
		
		ajustar_hora:
			li $t1, 24     # Carrega $t1 com 24
			div $t0, $t1   # Opera o tempo de corrido em horas / 24
			mflo $t5       # Move o quociente para $t5 (qtd de dias decorridos)
			mfhi $t4       # Move o quociente para $t4 (horas restantes)
			
			la $t1, hora_config_usuario  # Carrega o endereco de hora_config_usuario
			sb  $t4, 0($t1)    			 # Sobrescreve o byte de horas em hora_config_usuario
			sb  $t2, 2($t1)	   			 # sobrescreve o byte de minutos em hora_config_usuario
			
			la $t1, data_config_usuario  # Carrega o endereco de data_config_usuario
			lb $t2, 0($t1)               # Carrega o byte de dias em data_config_usuario
			add $t5, $t5, $t2            # Soma a quantidade de dias da data configurada com a quantidade de dias decorridos
			sb  $t5, 0($t1)    			 # Sobrescreve o byte de dias em data_config_usuario
			
			# N�o irei me dar ao trabalho de verificar se o dia, mes e ano s�o v�lidos, apos essa soma de dias , 
			# somei e ja ta bom demais, seria muito custoso fazer tudo isso ja que os dados da data e hora 
			# configurados pelo usuario nao sao salvos em arquivos .txt.
			
	imprimir_data_tempo:
		la $t1, data_config_usuario   # Carrega o endereco de data_config_usuario			
		jal escrever_string_display   # Escreve a data no display
		jal escrever_barra_n_display  # Causa uma quebra de linha no display
		
		la $t1, hora_config_usuario   # Carrega o endereco de hora_config_usuario			
		jal escrever_string_display   # Escreve a hora no display
		jal escrever_barra_n_display  # Causa uma quebra de linha no display
		
		j main
	
ajustar_data:
	# O trecho abaixo compara se o usuario escreveu o argumento "--data"
	addi $s0, $s0, 1 	  # Passa um caractere para frente, por conta do espaco entre os comandos
	la $s1, arg_data      # Carrega o endereco do argumento para comparar
	li $s2, 6             # Define a quantidade de caracteres em comando que sera comparada
	jal comparar_strings
	beqz $v0, escrever_falta_argumento_data_display    # caso tenha faltado o argumento ou digitado incorretamente
	 
	addi $s0, $s0, 1 	# Passa um caractere para frente, por conta do espaco entre os comando
	
	# O trecho abaixo verifica se os dados estao no formato dd/mm/aaaa
	la $t1, barra     # Carrega o endereco de barra
	lb $t1, 0($t1)    # Carrega o caractere de barra
	
	addi $s0, $s0, 3    # Avanca 3 caracteres 
	lb $t2, 0($s0)      # Carrega o caractere 
	
	# Caso os caractere em $s0 nao seja igual ao de $t1, imprime a mensagem de formato incorreto
	bne  $t2, $t1, escrever_formato_data_hora_incorreto_display  
	
	addi $s0, $s0, 3   # Avanca 3 caracteres
	lb $t2, 0($s0)      # Carrega o caractere
	bne  $t2, $t1, escrever_formato_data_hora_incorreto_display  # verifica novamente
	
	# Caso esteja tudo nos conformes, volta o $s0 para a sua posicao anterior a essas 2 verificacoes
	subi $s0, $s0, 6
	
	la $t1, data_config_usuario   # Carrega o endereco de data_config_usuario  
	jal guardar_info_buffer  	  # Pula para a funcao que pega o que estah entre aspas e salva no data_config_usuario
	
	# O trecho abaixo compara se o usuario escreveu o argumento "--hora"
	addi $s0, $s0, 1 	  # Passa um caractere para frente, por conta do espaco entre os comandos
	la $s1, arg_hora      # Carrega o endereco do argumento para comparar
	li $s2, 6             # Define a quantidade de caracteres em comando que sera comparada
	jal comparar_strings
	beqz $v0, escrever_falta_argumento_hora_display    # caso tenha faltado o argumento ou digitado incorretamente
	
	addi $s0, $s0, 1 	# Passa um caractere para frente, por conta do espaco entre os comando
	
	# O trecho abaixo verifica se os dados estao no formato hh:mm
	la $t1, dois_pontos     # Carrega o endereco de dois_pontos
	lb $t1, 0($t1)    		# Carrega o caractere de dois_pontos
	
	addi $s0, $s0, 3    # Avanca 3 caracteres
	lb $t2, 0($s0)      # Carrega o caractere 
	# Vaso os caractere em $s0 nao seja igual ao de $t1, imprime a mensagem de formato incorreto
	bne  $t2, $t1, escrever_formato_data_hora_incorreto_display  
	
	# Caso esteje tudo nos conformes, volta o $s0 para a sua posicao anterior a essas 2 verificacoes
	subi $s0, $s0, 3
	
	la $t1, hora_config_usuario  # Carrega o endereco de data_config_usuario
	jal guardar_info_buffer  	 # Pula para a funcao que pega o que estah entre aspas e salva no data_config_usuario
	
	li $v0, 30   # Chama o syscall 30 para obter o instante que o usu�rio configurou o sistema
    syscall
    
    la $t0, tempo_hora_configurada0   # Carrega o endereco de tempo_hora_configurada0
    la $t1, tempo_hora_configurada1   # Carrega o endereco de tempo_hora_configurada0
	
	sw $a0, 0($t0)       # armazena a parte menos significativa dos milissegundos na variavel
    sw $a1, 0($t1)       # armazena a parte mais significativa dos milissegundos na variavel

	# Limpa o buffer de comando
	la $s1, comando
	jal clear_buffer
	
	la $t1, msgC_data_hora_configurada   # Carrega o endereco de msgC_data_hora_configurada
	j escrever_com_sucesso_display
	
ler_dados:
    # Aloca espaco no $sp para salvar o endereco de $ra
    addi $sp, $sp, -4
    sw $ra, 0($sp)
	 
    la $a0, local_arquivo_livros       # Carrega o caminho do arquivo de livros
    la $a1, repo_livro                 # Carrega o endere�o do reposit�rio onde os dados ser�o carregados
    li $a2, 4500
    jal ler_dados_do_arquivo           # Chama a fun��o gen�rica para leitura do arquivo

    la $a0, local_arquivo_usuario      # Carrega o caminho do arquivo de usu�rios
    la $a1, repo_usuario               # Carrega o endere�o do reposit�rio onde os dados ser�o carregados
    li $a2, 4500
    jal ler_dados_do_arquivo           # Chama a fun��o gen�rica para leitura do arquivo

    la $a0, local_arquivo_emprestimo   # Carrega o caminho do arquivo de empr�stimos
    la $a1, repo_emprestimo            # Carrega o endere�o do reposit�rio onde os dados ser�o carregados
    li $a2, 4500
    jal ler_dados_do_arquivo           # Chama a fun��o gen�rica para leitura do arquivo
	
	lw $ra, 0($sp) 		   # Resgata o $ra original do $sp
    addi $sp, $sp, 4	   # Devolve a pilha para a posicao original
	
    jr $ra

ler_dados_do_arquivo:
	# $a0: Reg que possio o endere�o do nome do arquivo
	# $a1: Reg que possio o endere�o do buffer de destino 
	# $a2: Reg que possio o tamanho m�ximo do buffer
	
    # Aloca espaco no $sp para salvar o endereco de $ra, $s0 e $s1
    addi $sp, $sp, -12
    sw $ra, 8($sp)
    sw $s0, 4($sp)
    sw $s1, 0($sp)

    # Abre o arquivo para leitura
    move $s0, $a1           # Salva o endereco do buffer em $s0
    li $v0, 13              # Codigo de syscall para abrir arquivo
    li $a1, 0               # Modo leitura
    syscall
    move $s1, $v0           # Salva o descritor do arquivo em $s1

    # L� o conte�do do arquivo
    li $v0, 14              # Codigo de syscall para ler de arquivo
    move $a0, $s1           # Descritor do arquivo
    move $a1, $s0           # Endereco do buffer (recuperado de $s0)
    syscall

    # Fecha o arquivo
    li $v0, 16              # Codigo de syscall para fechar arquivo
    move $a0, $s1           # Descritor do arquivo
    syscall

    # Restaura $ra, $s0 e $s1 e retorna
    lw $s1, 0($sp)
    lw $s0, 4($sp)
    lw $ra, 8($sp)
    addi $sp, $sp, 12
    jr $ra
    
	# funcao generica para mensagens de confirmacao
escrever_com_sucesso_display:
	# $t1: reg possui a primeira parte da mensagem de confirmacao

	jal escrever_string_display     # Pula para a funcao generica que ira imprimir a string armazenada em $t1
	la $t1, msgC_com_sucesso  		# Carrega o endereco de msgC_com_sucesso
	jal escrever_string_display     # Pula para a funcao generica que ira imprimir a string armazenada em $t1
	jal escrever_barra_n_display    # pula para a funcao que ira imprimir uma quebra de linha no display
	
	j main
	
limpar_todos_buffers_das_entidades:
	# Aloca espaco no $sp para salvar o endereco de $ra
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
	la $s1, titulo       # Carrega o endereco de titulo
	jal clear_buffer     # Limpa o buffer de titulo
	
	la $s1, autor        # Carrega o endereco de autor
	jal clear_buffer     # Limpa o buffer de autor
	
	la $s1, ISBN         # Carrega o endereco de isbn 
	jal clear_buffer     # Limpa o buffer de ISBN
		
	la $s1, quantidade   # Carrega o endereco de quantidade
	jal clear_buffer     # Limpa o buffer de quantidade
		
	la $s1, nome         # Carrega o endereco de nome
	jal clear_buffer     # Limpa o buffer de nome
		
	la $s1, matricula    # Carrega o endereco de matricula
	jal clear_buffer     # Limpa o buffer de matricula
		
	la $s1, curso        # Carrega o endereco de curso
	jal clear_buffer     # Limpa o buffer de curso
		
	la $s1, matricula_usuario_ass    # Carrega o endereco de matricula_usuario_ass
	jal clear_buffer     			 # Limpa o buffer de matricula_usuario_ass
		
	la $s1, ISBN_livro_ass  # Carrega o endereco de ISBN_livro_ass
	jal clear_buffer        # Limpa o buffer de ISBN_livro_ass
		
	la $s1, data_registro   # Carrega o endereco de data_registro
	jal clear_buffer        # Limpa o buffer de data_registro
	
	la $s1, data_devolucao  # Carrega o endereco de data_devolucao
	jal clear_buffer        # Limpa o buffer de data_devolucao
	
	lw $ra, 0($sp) 		   # Resgata o $ra original do $sp
    addi $sp, $sp, 4	   # Devolve a pilha para a posicao original
	
	jr $ra
	
escrever_comando_invalido_display:
	la $t1, msgE_comando_invalido   # Carrega o endereco de msgE_comando_invalido
    jal escrever_string_display     # Pula para a funcao generica que ira imprimir a string armazenada em $t1
    jal escrever_barra_n_display    # pula para a funcao que ira imprimir uma quebra de linha no display   
    jal limpar_todos_buffers_das_entidades
    j main   
	
escrever_acervo_vazio_display:
    la $t1, msgE_acervo_vazio       # Carrega o endereco de msgE_acervo_vazio
    jal escrever_string_display     # Pula para a funcao generica que ira imprimir a string armazenada em $t1
    jal escrever_barra_n_display    # pula para a funcao que ira imprimir uma quebra de linha no display
    jal limpar_todos_buffers_das_entidades
    j main   

escrever_esprestimo_indisponivel_display:
    la $t1, msgE_esprestimo_indisponivel   # Carrega o endereco de msgE_comando_invalido
    jal escrever_string_display            # Pula para a funcao generica que ira imprimir a string armazenada em $t1
    jal escrever_barra_n_display           # pula para a funcao que ira imprimir uma quebra de linha no display
    jal limpar_todos_buffers_das_entidades 
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
    jal limpar_todos_buffers_das_entidades
    j main   

escrever_livro_esta_emprestado_display:
    la $t1, msgE_livro_esta_emprestado   # Carrega o endereco de msgE_livro_esta_emprestado
    jal escrever_string_display          # Pula para a funcao generica que ira imprimir a string armazenada em $t1
    jal escrever_barra_n_display    	 # pula para a funcao que ira imprimir uma quebra de linha no display
	jal limpar_todos_buffers_das_entidades   
    j main   
    
escrever_usuario_nao_encontrado_display:
    la $t1, msgE_usuario_nao_encontrado   # Carrega o endereco de msgE_usuario_nao_encontrado
    jal escrever_string_display           # Pula para a funcao generica que ira imprimir a string armazenada em $t1
    jal escrever_barra_n_display    	  # pula para a funcao que ira imprimir uma quebra de linha no display
    jal limpar_todos_buffers_das_entidades
    j main   
    
escrever_usuario_tem_pendencias_display:
    la $t1, msgE_usuario_tem_pendencias   # Carrega o endereco de msgE_usuario_tem_pendencias
    jal escrever_string_display           # Pula para a funcao generica que ira imprimir a string armazenada em $t1
    jal escrever_barra_n_display    	  # pula para a funcao que ira imprimir uma quebra de linha no display
    jal limpar_todos_buffers_das_entidades
    j main   
    
escrever_formato_data_hora_incorreto_display:
    la $t1, msgE_data_hora_mal_formatada  # Carrega o endereco de msgE_data_hora_mal_formatada
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
    jal limpar_todos_buffers_das_entidades
    j main   
	
escrever_falta_argumento_autor_display:
	la $s1, arg_autor  # Carrega o endereco arg_autor
	jal escrever_falta_argumento_obrigatorio_display
    jal escrever_barra_n_display    	  # pula para a funcao que ira imprimir uma quebra de linha no display
    jal limpar_todos_buffers_das_entidades
    j main   
	
escrever_falta_argumento_ISBN_display:
	la $s1, arg_ISBN  # Carrega o endereco arg_ISBN
	jal escrever_falta_argumento_obrigatorio_display
    jal escrever_barra_n_display    # pula para a funcao que ira imprimir uma quebra de linha no display
    jal limpar_todos_buffers_das_entidades
    j main   
	
escrever_falta_argumento_quantidade_display:
	la $s1, arg_quantidade  # Carrega o endereco arg_quantidade 
	jal escrever_falta_argumento_obrigatorio_display
    jal escrever_barra_n_display    # pula para a funcao que ira imprimir uma quebra de linha no display
    jal limpar_todos_buffers_das_entidades
    j main   
	
escrever_falta_argumento_nome_display:
	la $s1, arg_nome  # Carrega o endereco arg_nome
	jal escrever_falta_argumento_obrigatorio_display
    jal escrever_barra_n_display    # pula para a funcao que ira imprimir uma quebra de linha no display
    jal limpar_todos_buffers_das_entidades
    j main   
	
escrever_falta_argumento_matricula_display:
	la $s1, arg_matricula  # Carrega o endereco arg_matricula
	jal escrever_falta_argumento_obrigatorio_display
    jal escrever_barra_n_display    # pula para a funcao que ira imprimir uma quebra de linha no display
    jal limpar_todos_buffers_das_entidades
    j main   
	
escrever_falta_argumento_curso_display:
	la $s1, arg_curso  # Carrega o endereco arg_curso
	jal escrever_falta_argumento_obrigatorio_display
    jal escrever_barra_n_display    # pula para a funcao que ira imprimir uma quebra de linha no display
    jal limpar_todos_buffers_das_entidades
    j main   
	
escrever_falta_argumento_devolucao_display:
	la $s1, arg_devolucao  # Carrega o endereco arg_devolucao
	jal escrever_falta_argumento_obrigatorio_display
    jal escrever_barra_n_display    # pula para a funcao que ira imprimir uma quebra de linha no display
    jal limpar_todos_buffers_das_entidades
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
