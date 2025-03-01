# Projeto 1 VA Arquitetura e Organizacao de Computadores - 2024.2
# Alunos: Heitor Leander Feitosa da silva
#         Joao victor Morais Barreto da silva
#         Mariane Elisa dos Santos Souza
#         Samuel Roberto de Carvalho Bezerra

# O presente arquivo descreve o codigo do sistema de uma biblioteca e apresenta funcionalidades como:
# Criacao, remocao e visualizacao de livros; criacao, remocao e visualizacao de usuarios; criacao, atualizacao e visualizacao de emprestimos;
# sistema de data e hora utilizando syscall 30; sistema de data e hora personalizado; salvamento de dados em arquivos; e geracao de relatorios
# de emprestimos.

# Para que a funcionalidade do salvamento de dados funcione plenamente, eh necessario que sejam previamente criados os arquivos txt com os nomes
# descritos a seguir: repo_livros (para o repositorio de livros), repo_usuarios (para o repositorio de usuarios), repo_emprestimos (para o repositorio de emprestimos).

.data

	# Constantes
.eqv	keyboard_status 0xFFFF0000  # Endereco do status do teclado
.eqv	display_status  0xFFFF0008  # Endereco do status do display
.eqv	keyboard_buffer 0xFFFF0004  # Endereco do buffer do teclado
.eqv	display_buffer  0xFFFF000C  # Endereco do buffer do display

	banner:  		.asciiz "MIPShelf-shell>>"
	comando: 		.space 100    # Espaco reservado para o comando digitado pelo usuario
	
	# Variaveis:
	data_config_usuario:       	.space 20   # Variavel reservada para armazenar a data do sistema configurada pelo usuario
	hora_config_usuario:       	.space 20   # Variavel reservada para armazenar a hora do sistema configurado pelo usuario
	data_atual: 	           	.space 20   # Variavel reservada para armazenar a data atual 
	hora_atual:                	.space 20   # Variavel reservada para armazenar a data atual
	tempo_hora_configurada0:   	.word  0    # Variavel reservada para armazenar o tempo em que o usuario configurou a hora no sistema (os bits menos signficativos)
    tempo_hora_configurada1:   	.word  0    # Variavel reservada para armazenar o tempo em que o usuario configurou a hora no sistema (os bits mais signficativos)
 
	# Caracteres
	barra_n:   		.byte 10      # Valor em ASCII do caractere de quebra de linha '\n'
	espaco:			.byte 32      # Valor em ASCII do caractere de espaco ' '       
	aspas_duplas:   .byte 34      # Valor em AscII do caractere de aspas duplas ""
	virgula:		.byte 44      # Valor em AscII do caractere da virgula (',')
	dois_pontos:    .byte 58      # Valor em ASCII do caractere de dois pontos (':')
    barra:          .byte 47      # Valor em ASCII do caractere de barra ('/')
	backspace:      .byte 8       # Valor em ASCII do caractere de backspace (botao de apagar)
	barra_vertical: .byte 124		# Valor em ASCII do caractere de barra vertical ('|')
	
	# Livro:
	titulo:  	      		   .space 35     # Espaco reservado para o titulo do livro
	autor:    	      		   .space 35     # Espaco reservado para o nome do autor do livro
	ISBN:             		   .space 15     # Espaco reservado para o codigo de ISBN do livro
	quantidade_total: 		   .space 10  	 # Espaco reservado para a quantidade_total de livros 
	quantidade_disponivel: 	   .space 10     # Espaco reservado para a quantidade de livros disponiveis
	quantidade_emprestado:    .space 10     # Espaco reservado para a quantidade de livros emprestados
	
	# Usuario:
	nome:   	.space 35     # Espaco reservado para o nome do usuario
	matricula:	.space 15     # Espaco reservado para o numero de matricula do usuario
	curso:      .space 40     # Espaco reservado para o curso do usuario
	
	# Emprestimo:
	data_registro:  		.space 15    # Espaco reservado para a data em que foi registrado o emprestimo
	data_devolucao: 		.space 15    # Espaco reservado para a data de devolucao do emprestimo
	flag_foi_devolvido:      .space 3    # Espaco reservado para uma flag que serve para indicar se a devolucao foi feita ou nao
	
	# Repositorios Temporarios
	repo_livro:           				.space 4500 # Espaco reservado para a gravacao temporaria dos livros cadastrados
	repo_usuario:         				.space 4500 # Espaco reservado para a gravacao temporaria dos usuarios cadastrados
	repo_emprestimo:      				.space 4500 # Espaco reservado para a gravacao temporaria dos emprestimos cadastrados
	buffer_aux_conversao: 				.space 20   # Espaco reservado para um buffer que auxilia no processo de conversao de string para int
	
	# Buffers de Auxilio para Gerar Relatorios
	buffer_aux_livros_emprestados:	.space 4500 	# Espaco reservado para guardar temporariamente os livros que estão emprestados
	buffer_aux_usuario_atrasados:		.space 4500 	# Espaco reservado para guardar temporariamente os usuarios que estao atrasados na devolucao
	acumulador:							.word 0			# Acumula os dias no calculo de dias entre datas
	
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
	cmd_listar_usuarios:    .asciiz "listar_usuarios"
	
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
	msgC_devolucao_registrada:   .asciiz "Devolucao registrada"
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
	msgE_data_invalida:                      .asciiz "A data inserida e invalida" 
	msgE_hora_invalida:                      .asciiz "A hora inserida e invalida" 
	msgE_operacao_cadastro_invalida:         .asciiz "Operacao de cadastro invalida"
	msgE_livro_ja_cadastrado:                .asciiz " o isbn fornecido ja esta associada a um outro livro no acervo" 
	msgE_usuario_ja_cadastrado:              .asciiz " a matricula fornecida ja esta associada a um outro usuario"
	msgE_emprestimo_nao_encontrado:          .asciiz "Nao existe nenhum emprestimo associado ao usuaro fornecido"
	msgE_usuario_ja_possui_emprestimo_livro: .asciiz " o usuario indicado ja possui um emprestimo pendente do livro associado ao iSBN fornecido."
	
	# strings auxiliares para impressoes
	string_data:     .asciiz "Data: "
    string_hora:     .asciiz "Hora: "
    string_livros_emprestados: .asciiz "Livros emprestados:"
    string_usuarios_atrasados: .asciiz "Usuarios em atraso:"
    string_isbn:           .asciiz "ISBN: "
	string_autor:          .asciiz "Autor: "
	string_livro:          .asciiz "Livro: "
	string_qtd:            .asciiz "Qtd: "
	string_qtd_disponivel: .asciiz "Qtd Disponivel: "
	string_qtd_emprestada: .asciiz "Qtd Indisponivel: "
	string_nome:			.asciiz "Nome: "
	string_matricula:		.asciiz "Matricula: "
	string_curso:			.asciiz "Curso: "
	string_dias_atraso: 	.asciiz "Dias de atraso: "
	string_data_devolucao: .asciiz "Data de Devolucao: "
    
.text
.globl main

carregar_dados:
	jal ler_dados  # pula para a funcao que vai ler os dados em arquivo
	
main:
	jal escrever_banner_display   # Funcao que escreve o banner no display
	li $s7, 0 		              # Inicializa $s7 com 0
	jal esperar_input_teclado     # Funcao que fica em looping esperando o input do teclado do usuario

	j main 
	        
esperar_display_carregar:
	li $t0, display_status   		   		  # Endereco do status do display
    lw $t0, 0($t0)        				  # Carrega o status do display diretamente em $t0
    beqz $t0, esperar_display_carregar    # Se status for 0, entra em loop
    
    jr $ra

escrever_string_display:
	# $t1: reg que possui o endereco da string a ser digitada no display
	
	# Aloca espaco no $sp para salvar o endereco de $ra
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    jal esperar_display_carregar 	# Pula para a funcao que espera o display carregar
    
    lw $ra, 0($sp) 			   		#  Resgata o $ra original do $sp
    addi $sp, $sp, 4		  		# Devolve a pilha para a posicao original
    
    li $t0, display_buffer         		# Endereco do Transmiter data do display
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
	
    li $t0, keyboard_status   	     # Endereco do status do teclado
    lw $t0, 0($t0)        			 # Carrega o status do teclado diretamente em $t0
    beqz $t0, esperar_input_teclado  # Se status for 0, entra em loop
	
	li $t0, keyboard_buffer  # Endereco do Receiver data do teclado
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
	beqz $t0, limpar_rescrever_display    # se o primeiro byte for nulo, entao comando ta vazio, logo nao precisa remover
  	addi $s7, $s7, -1                     # Caso nao seja, decrementa $s7 para apontar para o ultimo caractere digitado
  	li $t2, 0 			                  # Reg auxiliar para loop
  	
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
  li $t0, display_buffer   # Endere�o do Receiver data do display
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
	
    li $t0, display_buffer    # Endereco do Receiver data do display
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

    li $t0, display_buffer         # Endereco do Transmitter data do display
    sw $t1, 0($t0)             # Escreve o caractere \n no display

    jr $ra
    
escrever_barra_vertical_display:
    # Aloca espaco no $sp para salvar o endereco de $ra
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    jal esperar_display_carregar   
    
    lw $ra, 0($sp) 			   # Resgata o $ra original do $sp
    addi $sp, $sp, 4		   # Devolve a pilha para a posicao original

    la $t1, barra_vertical            # Carrega o endereco de barra_n
    lb $t1, 0($t1)             # Carrega o valor de barra_n diretamente em $t1

    li $t0, display_buffer         # Endereco do Transmitter data do display
    sw $t1, 0($t0)             # Escreve o caractere \n no display

    jr $ra

escrever_banner_display:
	la $t1, banner      # Carrega o endereco do inicio da string do banner
	
    # Aloca espaco no $sp para salvar o endereco de $ra
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    jal escrever_string_display
    
    lw $ra, 0($sp) 		# Resgata o $ra original do $sp
    addi $sp, $sp, 4	# Devolve a pilha para a posicao original

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
	jal verificar_cmd_ajustar_data
    jal verificar_cmd_reg_devolucao
    jal verificar_cmd_listar_usuarios
    
    # Se nao foi digitado nenhum dos comandos 
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
  	
  	lw $ra, 0($sp) 		# Resgata o $ra original do $sp
    addi $sp, $sp, 4	# Devolve a pilha para a posicao original
    
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
	
	lw $ra, 0($sp) 		# Resgata o $ra original do $sp
    addi $sp, $sp, 4	# Devolve a pilha para a posicao original
	
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
  	
  	lw $ra, 0($sp) 		# Resgata o $ra original do $sp
    addi $sp, $sp, 4	# Devolve a pilha para a posicao original
    
  	jr $ra
  	
verificar_cmd_reg_emprestimo:
	# Aloca espaco no $sp para salvar o endereco de $ra
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
  	la $s1, cmd_reg_emprestimo         # Carrega o endereco de cmd_reg_emprestimo
  	la $s0, comando                    # Carrega o endereco de comando em S0
  	li $s2, 20                         # Define a quantidade de caracteres de comando que irao ser comparados
  	jal comparar_strings               # Pula para a funcao que ira comparar as strings
  	beq $v0, 1, registrar_emprestimo   # se $v0 for 1, significa que o comando digitado foi o de reg_emprestimo
	
	lw $ra, 0($sp) 		# Resgata o $ra original do $sp
    addi $sp, $sp, 4	# Devolve a pilha para a posicao original
    
	jr $ra
	
verificar_cmd_gerar_relatorio:
	# Aloca espaco no $sp para salvar o endereco de $ra
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
  	la $s1, cmd_gerar_relatorio     # Carrega o endereco de cmd_gerar_relatorio
  	la $s0, comando                 # Carrega o endereco de comando em S0
  	li $s2, 15                      # Define a quantidade de caracteres de comando que irao ser comparados
  	jal comparar_strings            # Pula para a funcao que ira comparar as strings
  	beq $v0, 1, gerar_relatorio     # se $v0 for 1, significa que o comando digitado foi o de gerar_relatorio
	
	lw $ra, 0($sp) 		# Resgata o $ra original do $sp
    addi $sp, $sp, 4	# Devolve a pilha para a posicao original
    
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
  	
  	lw $ra, 0($sp) 		# Resgata o $ra original do $sp
    addi $sp, $sp, 4	# Devolve a pilha para a posicao original
    
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
	
	lw $ra, 0($sp) 		# Resgata o $ra original do $sp
    addi $sp, $sp, 4	# Devolve a pilha para a posicao original
    
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
  	
  	lw $ra, 0($sp) 		# Resgata o $ra original do $sp
    addi $sp, $sp, 4	# Devolve a pilha para a posicao original
    
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
  	
  	lw $ra, 0($sp) 		# Resgata o $ra original do $sp
    addi $sp, $sp, 4	# Devolve a pilha para a posicao original
    
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
  	
  	lw $ra, 0($sp) 		# Resgata o $ra original do $sp
    addi $sp, $sp, 4	# Devolve a pilha para a posicao original
    
  	jr $ra
  	
verificar_cmd_ajustar_data:	
	# Aloca espaco no $sp para salvar o endereco de $ra
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
  	la $s1, cmd_ajustar_data        # Carrega o endereco de ajustar_data
    la $s0, comando                 # Carrega o endereco de comando em S0
  	li $s2, 12                      # Define a quantidade de caracteres de comando que irao ser comparados
  	jal comparar_strings            # Pula para a funcao que ira comparar as strings
  	beq $v0, 1, ajustar_data        # se $v0 for 1, significa que o comando digitado foi o de ajustar_data
  	
  	lw $ra, 0($sp) 		# Resgata o $ra original do $sp
    addi $sp, $sp, 4	# Devolve a pilha para a posicao original
    
  	jr $ra
  	
verificar_cmd_reg_devolucao:
	# Aloca espaco no $sp para salvar o endereco de $ra
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    la $s1, cmd_reg_devolucao        # Carrega o endereco de reg_devolucao
    la $s0, comando                  # Carrega o endereco de comando em S0
  	li $s2, 19                       # Define a quantidade de caracteres de comando que irao ser comparados
  	jal comparar_strings             # Pula para a funcao que ira comparar as strings
  	beq $v0, 1, registrar_devolucao  # se $v0 for 1, significa que o comando digitado foi o de reg_devolucao
    
    lw $ra, 0($sp) 		# Resgata o $ra original do $sp
    addi $sp, $sp, 4	# Devolve a pilha para a posicao original
    
  	jr $ra	
  	
verificar_cmd_listar_usuarios:
	# Aloca espaco no $sp para salvar o endereco de $ra
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    la $s1, cmd_listar_usuarios      # Carrega o endereco de reg_devolucao
    la $s0, comando                  # Carrega o endereco de comando em S0
  	li $s2, 15                       # Define a quantidade de caracteres de comando que irao ser comparados
  	jal comparar_strings             # Pula para a funcao que ira comparar as strings
  	beq $v0, 1, listar_usuarios      # se $v0 for 1, significa que o comando digitado foi o de reg_devolucao
    
    lw $ra, 0($sp) 		# Resgata o $ra original do $sp
    addi $sp, $sp, 4	# Devolve a pilha para a posicao original
    
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
    	beq $t0, $t2, finalize    # Se for aspas duplas (""), finaliza a copia
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
	# Pega o que estiver entre aspas e salva no buffer
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
	move $t9, $s0       # copia o endereco de $s0 em $t9
	
	# Pega o que estah entre aspas e salva no buffer
	la $t1, quantidade_total
	jal guardar_info_buffer  # Adiciona ao final da quantidade
	la $t2, virgula          # Carrega o endereco de virgula
	lb $t2, 0($t2)           # Carrega o byte do caractere de virgula (',') 
    sb $t2, 0($t1)           # Escreve o caractere ','
	
	# Vamos verificar agora se o isbn fornecido estah associado a algum outro livro no acervo
    la $s1, repo_livro              # Carrega o endereco de repo_livro
    la $s3, ISBN                    # Carrega o endereco de ISBN
    jal fazer_busca_no_repositorio  # Pula para a funcao que vai fazer uma busca do ISBN em repo_livro
    beq $v0, 1, escrever_livro_ja_cadastrado_display  # Caso v0 seja 1, pula para a funcao que vai escrever livro ja cadastrado
	
	# Agora vamos copiar a quantidade_total digitada e armazenar em quantidade_dispon�vel
	move $s0, $t9     # Recupera o endereco que contem os bytes da quantidade digitada
	la $t1, quantidade_disponivel   # Carrega o endereco de quantidade_disponivel
	jal guardar_info_buffer  # Adiciona os bytes da quantidade em quantidade_dispon�vel 

	la $t2, quantidade_disponivel  # Recarrega o endereco de quantidade_disponivel
	jal descobrir_qtd_digitos      # Chama a funcao que varre quantidade_disponivel e retorna em $s7 qtd de digitos (bytes)
	
	la $t2, virgula          # Carrega o endereco de virgula
	lb $t2, 0($t2)           # Carrega o byte do caractere de virgula (',') 
    sb $t2, 0($t1)           # Escreve o caractere ','
    
	# Vamos agora inserir o caractere 0 em quantidade_emprestado
 	la $t1, quantidade_emprestado   # Carrega o endereco de quantidade_emprestado
	li $t7, 48                       # Inicializa o byte 48 (caractere de 0) 
	
	jal inserir_caractere0    
	
	la $t2, barra_n          # Carrega o endereco de barra_n
	lb $t2, 0($t2)           # Carrega o byte do caractere de barra n ('\n') 
    sb $t2, 0($t1)           # Escreve o caractere '\n'
    
	# Agora vamos salvar no repositorio (buffer) de livros
	# Para isso, vamos concatenar todas as informacoes que obtivemos em uma unica string e coloca-la no repo_livro
	la $s0, repo_livro  # Carrega o endereco de repo_livro
	la $s1, ISBN        # Carrega o endereco de isbn
	jal str_concat      # Pula para a funcao que vai concatenar os dados de isbn em repo_livro
	la $s1, ISBN        # Recarrega o endereco de isbn novamente (para voltar ao primeiro caractere)
	jal clear_buffer	# Limpa o buffer de ISBN
	
	la $s1, titulo		# Carrega o endereco de titulo
	jal str_concat      # Pula para a funcao que vai concatenar os dados de titulo em repo_livro
	la $s1, titulo      # Recarrega o endereco de titulo novamente (para voltar ao primeiro caractere)
	jal clear_buffer	# Limpa o buffer de titulo
	
	la $s1, autor       # Carrega o endereco de autor
	jal str_concat      # Pula para a funcao que vai concatenar os dados de autor em repo_livro
	la $s1, autor       # Recarrega o endereco de autor novamente (para voltar ao primeiro caractere)
	jal clear_buffer	# Limpa o buffer de autor
	
	la $s1, quantidade_total  # Carrega o endereco de quantidade_total
	jal str_concat      # Pula para a funcao que vai concatenar os dados de quantidade_total em repo_livro
	la $s1, quantidade_total  # Recarrega o endereco de quantidade_total novamente (para voltar ao primeiro caractere)
	jal clear_buffer	# Limpa o buffer de quantidade_total
	
	la $s1, quantidade_disponivel
	jal str_concat      # Pula para a funcao que vai concatenar os dados de quantidade_total em repo_livro
	la $s1, quantidade_disponivel  # Recarrega o endereco de quantidade_disponivel novamente (para voltar ao primeiro caractere)
	jal clear_buffer	# Limpa o buffer de quantidade_disponivel
	
	la $s1, quantidade_emprestado
	jal str_concat      # Pula para a funcao que vai concatenar os dados de quantidade_emprestado em repo_livro
	la $s1, quantidade_emprestado  # Recarrega o endereco de quantidade_emprestado novamente (para voltar ao primeiro caractere)
	jal clear_buffer	# Limpa o buffer de quantidade_emprestado
	
	# Limpa o buffer de comando
	la $s1, comando
	jal clear_buffer
	
	la $t1, msgC_livro_cadastrado   # Carrega o endereco de msgC_livro_cadastrado
	j escrever_com_sucesso_display

inserir_caractere0:
	# $t1: reg que possui o endereco do buffer que serah feita a insercao do caractere 0
	# $s7: reg que possui a quantidade de vezes que o loop irah ocorrer
	
	loop_inserir_caractere0:
		sb $t7, 0($t1)      # Escreve o caractere 0
		addi $t1, $t1, 1    # Avanca para o proximo endereco
		subi $s7, $s7, 1    # Decrementa $s7
		bnez $s7, loop_inserir_caractere0   # Se $s7 nao for igual a 0 entra em loop 
	
	jr $ra

avancar_ate_barra_n:
	# $s1: reg que possui o endereco do repositiorio que estah sendo varrido
	
	la $t1, barra_n   # Carrega o endereco de barra_n
	lb $t1, 0($t1)    # Carrega o byte que carrega o byte do caractere '\n'
	 
	loop_avancar_barra_n:
		lb $t2, 0($s1)                  # Carrega o byte em repo_livro
		beq $t2, $t1, fim_loop_avancar  # Caso $s1 seja tenha o caractere \n, o loop encerra
		addi $s1, $s1, 1                # Contrario avanca o caractere
		j loop_avancar_barra_n          # Entra em loop
	
	fim_loop_avancar:
		jr $ra
		
avancar_ate_virgula:
	# $s1: reg que possui o endereco do repositiorio que estah sendo varrido
	
	la $t1, virgula   # Carrega o endereco de virgula
	lb $t1, 0($t1)    # Carrega o byte que carrega o byte do caractere  ','
	 
	loop_avancar_virgula:
		lb $t2, 0($s1)                          # Carrega o byte do repositorio
		beq $t2, $t1, fim_loop_avancar_virgula  # Caso $s1 seja tenha o caractere ',', o loop encerra
		addi $s1, $s1, 1                        # Contrario avanca o caractere
		j loop_avancar_virgula                  # Entra em loop
	
	fim_loop_avancar_virgula:
		addi $s1, $s1, 1       # Avanca mais um caractere
		jr $ra
		
voltar_ate_virgula:
	# $s1: reg que possui o endereco do repositiorio que estah sendo varrido
	
	la $t1, virgula   # Carrega o endereco de virgula
	lb $t1, 0($t1)    # Carrega o byte que correspondente ao caractere de virgula
	 
	loop_voltar_virgula:
		lb $t2, 0($s1)                          # Carrega o byte do repositorio
		beq $t2, $t1, fim_loop_voltar_virgula   # Caso $s1 seja tenha o caractere ',', o loop encerra
		beqz $t2, fim_loop_voltar_virgula       # Se o byte lido for o byte nulo o loop tambem eh encerrado
		subi $s1, $s1, 1                        # Caso contrario retorna para byte anterior c
		j loop_voltar_virgula                   # Entra em loop
	
	fim_loop_voltar_virgula:
		addi $s1, $s1, 1       # Avanca mais um byte, para que a virgula seja ignorada
		jr $ra

voltar_ate_barra_n:
	# $s7: reg que possui o endereco do repositiorio que estah sendo varrido
	
	la $t1, barra_n   # Carrega o endereco de virgula
	lb $t1, 0($t1)    # Carrega o byte que correspondente ao caractere de virgula
	la $t8, repo_emprestimo
	 
	loop_voltar_barra_n:
		lb $t2, 0($s7)                          	# Carrega o byte do repositorio
		beq $t2, $t1, fim_loop_barra_n   			# Caso $s1 seja tenha o caractere '\n', o loop encerra
		beq $s7, $t8, fim_loop_barra_n      		# Se o byte lido for o byte nulo o loop tambem eh encerrado
		subi $s7, $s7, 1                        	# Caso contrario retorna para byte anterior c
		j loop_voltar_barra_n                   	# Entra em loop
	
	fim_loop_barra_n:
		addi $s7, $s7, 1	# Passa um para sair do /n
		jr $ra

descobrir_qtd_caracteres_comparacao:
	# $s1: reg que possui o endereco do repositiorio que estah sendo varrido
	
	la $t1, virgula  # Carrega o endereco de virgula
	lb $t1, 0($t1)   # Carrega o byte que contem o valor do caractere virgula em ascii
	
	li, $s7, 0       # Inicializa $s7 com 0 (reg que servira como contador de digitos do isbn)
	li, $s6, 0       # Inicializa $s6 com 0 (reg que tbm eh um contador, a qual serve como condicao de parada em voltar_s1
	
	loop_qtd_caracteres:
		lb $t2, 0($s1)            # Carrega o caractere
		beq $t2, $t1, voltar_s1   # Caso o caractere em $s1, seja  virgula pula para funcao que volta o $s1 para o comeco da linha
		addi $s1, $s1, 1          # Avanca para o proximo caractere
		addi $s6, $s6, 1          # Incrementa $s6
		addi $s7, $s7, 1          # Incrementa $s7
		j loop_qtd_caracteres     # Entra em loop
	
	# loop que retorna a quantidade de caracteres avancados em $s1 pelo loop_qtd_digitos
	voltar_s1:
		beqz $s6, encerrar_loop    # Quando $s6 for igual a 0 encerra o loop
		subi $s6, $s6, 1           # Decrementa $s6
		subi $s1, $s1, 1           # retorna 1 caractere
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
    
    # Verificamos se o primeiro byte eh nulo
    lb $s7, 0($s1)           
    beqz $s7, tratar_repositorio_vazio 
    
    loop_busca_repositorio:
    	jal descobrir_qtd_caracteres_comparacao    # Pula para a funcao que descobre a quantidade de digitos do isbn
    	move $s0, $s3                     # copia o valor do endereco de $s3 (o endereco do atributo a ser avaliado) para $s0                      
    	move $s2, $s7                     # Copia o valor de $s7, para $s2
    	jal comparar_strings              # pula para a funcao que vai comparar o ibsn do livro com o isbn digitado
    	beq $v0, 1, entidade_encontrada   # Se $v0 for igual a 1 a busca eh encerrada
    	jal avancar_ate_barra_n           # Caso contrario, pula para a funcao que avanca ate o barra n
    	addi $s1, $s1, 1                  # Avanca para o proximo caractere apos o \n
    	lb $v1, 0($s1)                    # Carrega o byte de $s1
    	beqz $v1, fim_loop_busca          # Caso em $v1 seja o nulo \0 o loop eh encerrado 
    	j loop_busca_repositorio
    
    tratar_repositorio_vazio:
    	li $v0, 0           # Inicializa v0 com 0
    	j fim_loop_busca
    	
    entidade_encontrada:
    	jal decrementar_s1  # funcao que ajusta $s1 para o endereco do primieiro byte da entidade encontrada 
    	
    fim_loop_busca:
    	lw $ra, 0($sp) 	    # Resgata o $ra original do $sp
    	addi $sp, $sp, 4	# Devolve a pilha para a posicao original
     	jr $ra	

fazer_busca_isbn_repo_emprestimo_remocao:
	# $s1: reg que possui o endereco do repositorio que irah ser feita a busca
	# $s3: reg que possui o endereco do atributo que contem os dados da busca (livro -> isbn, usuario -> matricula)
	
	# Aloca espaco no $sp para salvar o endereco de $ra
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    # Verificamos se o primeiro byte eh nulo
    lb $s7, 0($s1)           
    beqz $s7, tratar_repo_emprestimo_vazio1
    
    loop_busca_isbn_repo_emprestimo:
    	jal avancar_ate_virgula           # pula para a funcao que avanca ate a virgula para que seja comparado somente o isbn
    	jal descobrir_qtd_caracteres_comparacao    # Pula para a funcao que descobre a quantidade de digitos do isbn
    	move $s0, $s3                     # copia o valor do endereco de $s3 (o endereco do atributo a ser avaliado) para $s0                      
    	move $s2, $s7                     # Copia o valor de $s7, para $s2
    	jal comparar_strings              # pula para a funcao que vai comparar o ibsn do livro com o isbn digitado
    	addi $ra, $ra, 12                 # Atualiza o $ra para que caso a condicao abaixo seja verdadeira o fluxo retorne para a linha seguinte, por meio do jr $ra 
    	beq $v0, 1, verificar_livro_tem_devolucoes_pendentes  # Se $v0 for igual a 1 a nos verificamos se o livro tem devolucoes pendentes
    	jal avancar_ate_barra_n           # Caso contrario, pula para a funcao que avanca ate o barra n
    	addi $s1, $s1, 1                  # Avanca para o proximo caractere apos o \n
    	lb $v1, 0($s1)                    # Carrega o byte de $s1
    	beqz $v1, fim_loop_busca_isbn     # Caso em $v1 seja o nulo \0 o loop eh encerrado 
    	j loop_busca_isbn_repo_emprestimo
    
    tratar_repo_emprestimo_vazio1:
    	li $v0, 0           # Inicializa v0 com 0
    	
    fim_loop_busca_isbn:
    	jal decrementar_s1  # funcao que ajusta $s1 para o endereco do primieiro byte da entidade encontrada 
    	lw $ra, 0($sp) 	    # Resgata o $ra original do $sp
    	addi $sp, $sp, 4	# Devolve a pilha para a posicao original
     	jr $ra
     	
verificar_livro_tem_devolucoes_pendentes:
	# Aloca espaco no $sp para salvar o $ra
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	jal avancar_ate_virgula  # Avanca os bytes que contem a matricula
	jal avancar_ate_virgula  # Avanca os bytes que contem o ISBN 
	jal avancar_ate_virgula  # Avanca os bytes que contem a data_registro
	lb $t0, 0($s1)           # Carrega o byte que contem a flag se o emprestimo foi devolvido ou nao
  	beq $t0, 48, escrever_livro_esta_emprestado_display  # se o byte for igual 48 (caractere 0) significa que nao houve a devolucao do emprestimo
  	
	lw $ra, 0($sp) 		# Resgata o $ra original do $sp
	addi $sp, $sp, 4	# Devolve a pilha para a posicao original
	jr $ra

# Essa funcao decrementa $s1 para que ele contenha o apos a execucao 
# dessa funcao o endereco exato do primeiro byte do livro a ser removido
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
		
limpar_bytes_ultima_linha:
	# $s2: reg que possui o endereco do primeiro byte a ser sobrescrito com byte nulo no repositorio

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
	# $s1: reg que possui o endereco do primeiro byte da entidade a ser removida no repositorio
	
	# Aloca espaco no $sp para salvar o endereco de $ra
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
	move $s2, $s1             # Copia o endereco de s1 para $s2
	jal avancar_ate_barra_n   # Avanca $s1 para ate o caractere de barra n '\n'
	addi $s1, $s1 , 1         # avanca mais um caractere
	
	# Agora neste ponto $s1 contem o primeiro byte do livro posterior 
	# e $s2 contem o primeiro byte do livro a ser removido
	
	# O trecho abaixo verifica se o byte de $s1 eh o caractere nulo '\0' Caso seja, significa 
    # que a entidade a ser removida estah na ultima posicao do repositorio
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
   	
# Move os dados subsequentes para preencher o espaco deixado pela entidade removida
    sobrescrever_com_as_entidades_posteriores:
    	lb $t0, 0($s1)            # Carrega o proximo byte do repositorio
    	beqz $t0, fim_sobrescrita # Se for fim de string, termina
    	sb $t0, 0($s2)            # Sobrescreve o byte no endereco indicado por $s2
   		addi $s1, $s1, 1          # Avanca $s1 para o proximo byte
    	addi $s2, $s2, 1          # Avanca $s2 para o proximo byte
    	j sobrescrever_com_as_entidades_posteriores   # Entra em loop

	fim_sobrescrita:
    	sb $zero, 0($s2)                     # Coloca o caractere de fim de string no final do repositorio
    	jal limpar_bytes_ultima_linha        # pula para a funcao que vai sobrescrever a ultima linha com byte nulo
    	j finalizar_remocao                  # Finaliza a funcao
    	
    finalizar_remocao:
		lw $ra, 0($sp) 		# Resgata o $ra original do $sp
    	addi $sp, $sp, 4	# Devolve a pilha para a posicao original
		jr $ra
	
remover_livro:
	# O trecho abaixo verifica se repo_livro estah vazio
	la $s1, repo_livro    # Carrega o endereco de repo_livro
	lb $s1, 0($s1)        # Carrega o primeiro byte de repo livro
	beqz $s1, escrever_acervo_vazio_display    # Caso $s1, seja zero, pula para funcao que imprime a mensagem de acervo vazio
	
	addi $s0, $s0, 1 # Caso contrario, passa um caractere para frente, por conta do espaco entre os comandos
	
	# Verificamos se o argumento --isbn eh valido
	la $s1, arg_ISBN
	# $s0 ja tem o comando a ser passado
	li $s2, 6              # Passa a quantidade de caracteres em $s0 que sera comparada com $s1
	jal comparar_strings   # Pula para a funcao que ira comparar
	beqz $v0, escrever_falta_argumento_ISBN_display  # se $v0 for igual a 0, significa que o argumento digitado nao eh o de --isbn 
	
	addi $s0, $s0, 1 	# Passa um caractere para frente, por conta do espaco entre os comandos
	# Pega o que estiver entre aspas e salva no buffer
	la $t1, ISBN
	jal guardar_info_buffer
    
    # O trecho abaixo faz uma busca em repo_livro para ver se o livro existe em repo_livro
    la $s1, repo_livro              # Carrega o endereco de repo_livro
    la $s3, ISBN                    # Carrega o endereco de ISBN
    jal fazer_busca_no_repositorio  # Pula para a funcao que vai fazer uma busca do ISBN em repo_livro
    beqz $v0, escrever_livro_nao_encontrado_display   # Caso v0 seja 0 pula para a funcao que escreve livro nao encontrado
    
    move $t9, $s1    # Copia o endereco de $s1 em $t9
    
    # O trecho abaixo faz uma busca em repo_emprestimo para ver se o livro possui devolucoes pendentes
    la $s1, repo_emprestimo         # Carrega o endereco de repo_emprestimo
    la $s3, ISBN                    # Carrega o endereco de ISBN
    jal fazer_busca_isbn_repo_emprestimo_remocao     # Pula para a funcao que vai fazer uma busca do ISBN no repo_emprestimo

	# Se possui devolucoes pendentes do livro uma mensagem eh impressa no display 
	# e o fluxo de execucao retorna pro main, caso contrario o fluxo de execucao 
	# volta para ca
	
  	move $s1, $t9    # Recupera o endereco de $s1 que estava armazenado $t9

    # Se $v0 for igual a 1, significa que o livro existe, e em $s1
    # ira conter o endereco do primeiro byte do livro a ser removido
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
    la $s1, repo_livro             # Carrega o endereco da base de dados de livros
    lb $t0, 0($s1)                 # Verifica se o primeiro byte e nulo (indica repositorio vazio)
    beqz $t0, escrever_acervo_vazio_display # Se o repositorio estiver vazio, exibe uma mensagem

loop_listar_livros:
    # Guarda as informacoes nos buffers temporarios
    move $s7, $s1  # Salva o endereco atual de $s1 para restaura-lo depois
    la $t1, ISBN
    jal guardar_info_buffer_relatorio  # Armazena o ISBN no buffer
    
    la $t1, titulo
    jal guardar_info_buffer_relatorio  # Armazena o titulo no buffer
    
    la $t1, autor
    jal guardar_info_buffer_relatorio  # Armazena o autor no buffer
    
    la $t1, quantidade_total
    jal guardar_info_buffer_relatorio  # Armazena a quantidade total no buffer
    
    la $t1, quantidade_disponivel
    jal guardar_info_buffer_relatorio  # Armazena a quantidade disponivel no buffer
    
    la $t1, quantidade_emprestado
    jal guardar_info_buffer_relatorio  # Armazena a quantidade emprestada no buffer
    
    # Exibir ISBN
    la $t1, string_isbn  # Carrega o rotulo "ISBN: "
    jal escrever_string_display  # Exibe "ISBN: "
    la $t1, ISBN  # Carrega o ISBN
    jal escrever_string_display  # Exibe o ISBN
    jal escrever_barra_vertical_display  # Adiciona uma barra vertical para separacao
    
    la $s1, ISBN 
    jal clear_buffer  # Limpa o buffer

    # Exibir Titulo
    la $t1, string_livro  # Carrega o rotulo "Livro: "
    jal escrever_string_display  # Exibe "Livro: "
    la $t1, titulo  # Carrega o titulo do livro
    jal escrever_string_display  # Exibe o titulo do livro
    jal escrever_barra_vertical_display  # Adiciona uma barra vertical para separacao
    
    la $s1, titulo  
    jal clear_buffer  # Limpa o buffer

    # Exibir Autor
    la $t1, string_autor  # Carrega o rotulo "Autor: "
    jal escrever_string_display  # Exibe "Autor: "
    la $t1, autor  # Carrega o autor do livro
    jal escrever_string_display  # Exibe o autor do livro
    jal escrever_barra_vertical_display  # Adiciona uma barra vertical para separacao
    
    la $s1, autor  
    jal clear_buffer  # Limpa o buffer

    # Exibir Quantidade Total
    la $t1, string_qtd  # Carrega o rotulo "Qtd: "
    jal escrever_string_display  # Exibe "Qtd: "
    la $t1, quantidade_total  # Carrega a quantidade total
    jal escrever_string_display  # Exibe a quantidade total
    jal escrever_barra_vertical_display  # Adiciona uma barra vertical para separacao
    
    la $s1, quantidade_total  
    jal clear_buffer  # Limpa o buffer

    # Exibir Quantidade Disponivel
    la $t1, string_qtd_disponivel  # Carrega o rotulo "Qtd Disponivel: "
    jal escrever_string_display  # Exibe "Qtd Disponivel: "
    la $t1, quantidade_disponivel  # Carrega a quantidade disponivel
    jal escrever_string_display  # Exibe a quantidade disponivel
    jal escrever_barra_vertical_display  # Adiciona uma barra vertical para separacao
    
    la $s1, quantidade_disponivel  
    jal clear_buffer  # Limpa o buffer

    # Exibir Quantidade Emprestada
    la $t1, string_qtd_emprestada  # Carrega o rotulo "Qtd Emprestada: "
    jal escrever_string_display  # Exibe "Qtd Emprestada: "
    la $t1, quantidade_emprestado  # Carrega a quantidade emprestada
    jal escrever_string_display  # Exibe a quantidade emprestada
    jal escrever_barra_n_display  # Adiciona uma nova linha para separacao
    
    la $s1, quantidade_emprestado  
    jal clear_buffer  # Limpa o buffer

    move $s1, $s7  # Restaura o endereco original do livro para continuar a leitura
    lb $t0, 0($s1) # Verifica se ainda ha livros na lista
    bnez $t0, loop_listar_livros  # Continua se houver mais livros

    j main  # Retorna para a chamada anterior


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
	
	# Vamos verificar agora se a matricula fornecida estah associada a algum outro usuario
    la $s1, repo_usuario            # Carrega o endereco de repo_usuario
    la $s3, matricula               # Carrega o endereco de matricula
    jal fazer_busca_no_repositorio  # Pula para a funcao que vai fazer uma busca da matricula em repo_usuario
    beq $v0, 1, escrever_usuario_ja_cadastrado_display  # Caso v0 seja 1, pula para a funcao que vai escrever usuario ja cadastrado
	
    # Concatena as informacoes no repositorio de usuarios
    la $s0, repo_usuario    # Carrega o endereco do repositorio de usuarios em $s0.

    la $s1, matricula   	# Carrega o endereco do buffer `matricula` em $s1.
    jal str_concat      	# Concatena a matricula ao repositorio de usuarios.
	la $s1, matricula  		# Recarrega o endereco de matricula novamente (para voltar ao primeiro caractere)
	jal clear_buffer    	# Limpa o buffer "matricula".
	
	la $s1, nome            # Carrega o endereco do buffer "nome" em $s1.
    jal str_concat          # Concatena o nome ao repositario de usuarios.
    la $s1, nome            # Recarrega o endereco de nome novamente (para voltar ao primeiro caractere)
    jal clear_buffer        # Limpa o buffer "nome".

    la $s1, curso       	# Carrega o endereco do buffer `curso` em $s1.
    jal str_concat      	# Concatena o curso ao repositorio de usuarios.
    la $s1, curso       	# Recarrega o endereco de curso novamente (para voltar ao primeiro caractere)	
    jal clear_buffer    	# Limpa o buffer "curso".
	
	# Limpa o buffer de comando
    la $s1, comando       # Carrega o endereco do buffer `comando` em $s1.
    jal clear_buffer      # Limpa o buffer de comando.

    # Mensagem de sucesso
    la $t1, msgC_usuario_cadastrado   # Carrega a mensagem de sucesso em $t1.
    j escrever_com_sucesso_display    # Exibe a mensagem de sucesso.
    
fazer_busca_matricula_repo_emprestimo_remocao:
	# $s1: reg que possui o endereco do repositorio que irah ser feita a busca
	# $s3: reg que possui o endereco do atributo que contem os dados da busca (livro -> isbn, usuario -> matricula)
	
	# Aloca espaco no $sp para salvar o endereco de $ra
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    # Verificamos se o primeiro byte eh nulo
    lb $s7, 0($s1)           
    beqz $s7, tratar_repo_emprestimo_vazio2
    
    loop_busca_matricula_repo_emprestimo:
    	jal descobrir_qtd_caracteres_comparacao    # Pula para a funcao que descobre a quantidade de digitos do isbn
    	move $s0, $s3                     # copia o valor do endereco de $s3 (o endereco do atributo a ser avaliado) para $s0                      
    	move $s2, $s7                     # Copia o valor de $s7, para $s2
    	jal comparar_strings              # pula para a funcao que vai comparar o ibsn do livro com o isbn digitado
    	addi $ra, $ra, 12                 # atualiza o $ra para que caso a condicao abaixo seja verdadeira, o fluxo do codigo retorna para a linha seguinte por meio do jr $ra
    	beq $v0, 1, verificar_usuario_tem_devolucoes_pendentes  # Se $v0 for igual a 1 a nos verificamos se o livro tem devolucoes pendentes
    	jal avancar_ate_barra_n           # Caso contrario, pula para a funcao que avanca ate o barra n
    	addi $s1, $s1, 1                  # Avanca para o proximo caractere apos o \n
    	lb $v1, 0($s1)                    # Carrega o byte de $s1
    	beqz $v1, fim_loop_busca_matricula     # Caso em $v1 seja o nulo \0 o loop eh encerrado 
    	j loop_busca_matricula_repo_emprestimo
    
    tratar_repo_emprestimo_vazio2:
    	li $v0, 0           # Inicializa v0 com 0
    	
    fim_loop_busca_matricula:
    	jal decrementar_s1  # funcao que ajusta $s1 para o endereco do primieiro byte da entidade encontrada
    	lw $ra, 0($sp) 	    # Resgata o $ra original do $sp
    	addi $sp, $sp, 4	# Devolve a pilha para a posicao original
     	jr $ra

verificar_usuario_tem_devolucoes_pendentes:
	# Aloca espaco no $sp para salvar o $ra
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	jal avancar_ate_virgula  # Avanca os bytes que contem a matricula
	jal avancar_ate_virgula  # Avanca os bytes que contem o ISBN 
	jal avancar_ate_virgula  # Avanca os bytes que contem a data_registro
	jal avancar_ate_virgula  # Avanca os bytes que contem a data_devolucao 
	lb $t0, 0($s1)           # Carrega o byte que contem a flag se o emprestimo foi devolvido ou nao
  	beq $t0, 48, escrever_usuario_tem_pendencias_display  # se o byte for igual 48 (caractere 0) significa que nao houve a devolucao do emprestimo
  	
	lw $ra, 0($sp) 		# Resgata o $ra original do $sp
	addi $sp, $sp, 4	# Devolve a pilha para a posicao original
	jr $ra	

remover_usuario:
	addi $s0, $s0, 1 # Passa um caractere para frente, por conta do espaco entre os comandos
	
	# Verificamos se o argumento --matricula eh valido
	la $s1, arg_matricula
	# $s0 ja tem o comando a ser passado
	li $s2, 11             # Passa a quantidade de caracteres em $s0 que sera comparada com $s1
	jal comparar_strings   # Pula para a funcao que irah comparar
	beqz $v0, escrever_falta_argumento_ISBN_display  # se $v0 for igual a 0, significa que o argumento digitado nao eh o de --matricula
	
	addi $s0, $s0, 1 	# Passa um caractere para frente, por conta do espaco entre os comandos
	# Pega o que estiver entre aspas e salva no buffer
	la $t1, matricula
	jal guardar_info_buffer
	
	 # O trecho abaixo faz uma busca em repo_usuario para ver se o usuario existe
    la $s1, repo_usuario            # Carrega o endereco de repo_usuario
    la $s3, matricula               # Carrega o endereco de matricula
    jal fazer_busca_no_repositorio  # Pula para a funcao que vai fazer uma busca do ISBN em repo_usuario
    beqz $v0, escrever_usuario_nao_encontrado_display   # Caso v0 seja 0 pula para a funcao que imprime usuario nao encontrado
    
    move $t9, $s1    # Copia o endereco de $s1 em $t9
    
    # O trecho abaixo faz uma busca em repo_emprestimo para ver se o usuario possui devolucoes pendentes
    la $s1, repo_emprestimo    # Carrega o endereco de repo_emprestimo
    la $s3, matricula          # Carrega o endereco de matricula
    jal fazer_busca_matricula_repo_emprestimo_remocao     # Pula para a funcao que vai fazer uma busca do ISBN no repositorio
    
    # Se o usuario possui devolucoes pendentes uma mensagem eh impressa no display 
	# e o fluxo de execu��o retorna pro main, caso contrario o fluxo de execucao 
	# volta para ca
    
  	move , $s1, $t9    # Recupera o endereco de $s1 que estava armazenado $t9

    # Se $v0 for igual a 1, significa que o livro existe, e em $s1
    # irah conter o endereco do primeiro byte do livro a ser removido
    jal deletar_entidade_no_repositorio  
	
	# Limpa os buffers de comando e matricula
	la $s1, comando
	jal clear_buffer
	
	la $s1, matricula
	jal clear_buffer
	
	# Escreve a mensagem de confirmaca	
	la $t1, msgC_usuario_removido   # Carrega o endereco de msgC_usuario_removido
	j escrever_com_sucesso_display
	
listar_usuarios:
    la $s1, repo_usuario          # Carrega o endereco da base de dados de usuarios
    lb $t0, 0($s1)                # Verifica se o primeiro byte e nulo (indica repositorio vazio)
    beqz $t0, escrever_acervo_vazio_display # Se o repositorio estiver vazio, exibe uma mensagem

loop_listar_usuarios:
    # Guarda as informacoes nos buffers temporarios
    move $s7, $s1  # Salva o endereco atual de $s1 para restaurar depois
    
    la $t1, matricula
    jal guardar_info_buffer_relatorio  # Armazena a matricula no buffer
    
    la $t1, nome
    jal guardar_info_buffer_relatorio  # Armazena o nome no buffer
    
    la $t1, curso
    jal guardar_info_buffer_relatorio  # Armazena o curso no buffer
    
    # Exibir Nome
    la $t1, string_nome  # Carrega o rotulo "Nome: "
    jal escrever_string_display  # Exibe "Nome: "
    la $t1, nome  # Carrega o nome do usuario
    jal escrever_string_display  # Exibe o nome do usuario
    jal escrever_barra_vertical_display  # Adiciona uma barra vertical para separacao
    
    la $s1, nome  
    jal clear_buffer  # Limpa o buffer para evitar lixo de memoria

    # Exibir Matricula
    la $t1, string_matricula  # Carrega o rotulo "Matricula: "
    jal escrever_string_display  # Exibe "Matricula: "
    la $t1, matricula  # Carrega a matricula do usuario
    jal escrever_string_display  # Exibe a matricula do usuario
    jal escrever_barra_vertical_display  # Adiciona uma barra vertical para separacao
    
    la $s1, matricula  
    jal clear_buffer  # Limpa o buffer

    # Exibir Curso
    la $t1, string_curso  # Carrega o rotulo "Curso: "
    jal escrever_string_display  # Exibe "Curso: "
    la $t1, curso  # Carrega o curso do usuario
    jal escrever_string_display  # Exibe o curso do usuario
    jal escrever_barra_n_display  # Adiciona uma nova linha para separacao
    
    la $s1, curso  
    jal clear_buffer  # Limpa o buffer

    move $s1, $s7  # Restaura o endereco original do usuario para continuar a leitura
    lb $t0, 0($s1) # Verifica se ainda ha usuarios na lista
    bnez $t0, loop_listar_usuarios  # Continua se houver mais usuarios

    j main # Retorna para a main


registrar_emprestimo:
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

    # Verifica o argumento "--isbn"
    la $s1, arg_ISBN			# Carrega o endereco da string "--matricula"  em $s1
	addi $s0, $s0, 1           	# Move o ponteiro para o proximo argumento
    li $s2, 6               	# Tamanho esperado do argumento
    jal comparar_strings       	# funcao para comparar strings
    beqz $v0, escrever_falta_argumento_ISBN_display # Se as strings nao forem iguais, exibe erro
	
	addi $s0, $s0, 1            # Move o ponteiro para a proxima info
    la $t1, ISBN           		# Carrega o endereco do matricula em $t1
    jal guardar_info_buffer     # Guarda o conteudo entre aspas no bufffer ISBN
    la $t2, virgula             # Carrega o endereco da virgula (',')
	lb $t2, 0($t2)              # Carrega o byte do caractere da virgula
    sb $t2, 0($t1)              # Adiciona virgula ao final da matricula
	
	# A linha pula para a funcao que verifica se o usuario colocou o argumento --data 
	# caso nao tenha colocado a funcao obtem a data ou por meio da data configurada pelo 
	# usuario ou por meio da funcao que gera e monta a data atual
	jal verificar_data_registro   
	addi $ra, $ra, 8
	beqz $s5, recuperar_endereco_s0
	
	# Verifica o argumento --devolucao
	la $s1, arg_devolucao 		# Carrega o endereco da string "--devolucao"  em $s1
	addi $s0, $s0, 1			# Move o ponteiro para o proximo argumento
	li $s2, 11					# Tamanho esperado do argumento
	jal comparar_strings		# funcao para comparar strings
	beqz $v0, escrever_falta_argumento_devolucao_display # Se as strings nao forem iguais, exibe erro
	
	addi $s0, $s0, 1			# Move o ponteiro para a proxima info
	la $t1, data_devolucao		# Carrega o endereco do matricula em $t1
	jal guardar_info_buffer		# Guarda o conteudo entre aspas no bufffer data_devolucao
	la $t2, virgula				# Carrega o endereco da virgula (',')
	lb $t2, 0($t2)				# Carrega o byte do caractere ','
	sb $t2, 0($t1)              # Adiciona o caractere de virgula ao final da data de devolucao 
	
	# Vamos agora validar a data de devolucao digitada pelo usuario
	la $t1, data_devolucao	
	jal validar_data       # Caso o usuario tenha digitado uma data valida, o fluxo do codigo volta pra ca
	
	## Verificacoes nos repositorios
	
	# Verifica se o usuario ja possui um emprestimo pendente do livro associado ao Isbn fornecido
	li $t9, 1     # inicializa $t9 com 1 (flag para que a funcao indentifique que estamos fazendo uma busca em registrar_emprestimo)
	jal buscar_emprestimo
	beq $v1, 1, escrever_usuario_ja_possui_emprestimo_livro_display   
	
	# Verifica se matricula fornecida esta associada a um usuario cadastrado
	la $s1, repo_usuario              # Carrega o endereco de repo_usuario
	la $s3, matricula                 # Carrega o endereco de matricula
	jal fazer_busca_no_repositorio    # pula para a funcao que faz a busca
	beqz $v0, escrever_usuario_nao_encontrado_display  # se v0 for 0 significa a matricula nao esta associado a nenhum usuario
	
	# Verifica se o ISBN fornecido estah associado a um livro cadastrado
	la $s1, repo_livro                # Carrega o endereco de repo_usuario
	la $s3, ISBN                      # Carrega o endereco do ISBN
	jal fazer_busca_no_repositorio    # Pula para a funcao que faz a busca
	beqz $v0, escrever_livro_nao_encontrado_display # se v0 for 0 significa que o ISBN nao esta associado a nenhum livro
	
	# Verifica se ha livros disponiveis para realizar o emprestimo
	jal verifica_qtd_disponivel
	beqz $a0, escrever_esprestimo_indisponivel_display    # se a qtd de livro eh 0, imprime emprestimo indisponivel
	
	# Se a quantidade_disponivel for maior que 0 pulamos para a funcao responsavel por atualizar quantidades
	jal atualizar_qtd_disponivel_para_menos
	addi $s1, $s1, 1      # Avanca para o proximo endereco (por causa da virgula entre os atributos)
	
	# Agora vamos obter o valor inteiro de quantidade_emprestado e atualizar ele em repo_livro
	jal obter_conveter_qtd_emprestados_para_int
	jal atualizar_qtd_emprestados_para_mais
	
	# Agora vamos inicializar o buffer flag_foi_devolvido 
	li $t0, 48                   # Inicializa $t0 com 48 (Caractere 0 em ASCII)
	la $t1, flag_foi_devolvido   # Carrega o endereco flag_foi_devolvido
	sb $t0, 0($t1)               # Escreve o byte em flag_foi_devolvido
	addi $t1, $t1, 1             # Avanca para o proximo byte
	la $t2, barra_n				 # Carrega o endereco da barra_n
	lb $t2, 0($t2)				 # Carrega o byte do caractere \n
	sb $t2, 0($t1)               # Adiciona o caractere de ',' ao final da data de devolucao 
	
	## Salva emprestimo nos buffers
	# Concatena as informacoes no repo_emprestimo
	
    la $s0, repo_emprestimo # Carrega o endereco do repositorio de emprestimo em $s0.
    
    la $s1, matricula       # Carrega o endereco do buffer "matricula" em $s1.
    jal str_concat          # Concatena o matricula ao repositario de emprestimo.
    la $s1, matricula       # Recarrega o endereco de matricula novamente (para voltar ao 1e caractere)
    jal clear_buffer        # Limpa o buffer matricula.
	
    la $s1, ISBN       	    # Carrega o endereco do buffer `ISBN` em $s1.
    jal str_concat          # Concatena o ISBN ao repositorio de emprestimo.
    la $s1, ISBN       	    # Recarrega o endereco de curso novamente (para voltar ao 1e caractere)	
    jal clear_buffer        # Limpa o buffer "ISBN".
    
    la $s1, data_registro   # Carrega o endereco do buffer `registro` em $s1.
    jal str_concat      	# Concatena o data_registro ao repositorio de emprestimo.
    la $s1, data_registro   # Recarrega o endereco de curso novamente (para voltar ao 1e caractere)	
    jal clear_buffer    	# Limpa o buffer "registro".
    
    la $s1, data_devolucao  # Carrega o endereco do buffer `devolucao` em $s1.
    jal str_concat      	# Concatena o data_devolucao ao repositorio de emprestimo.
    la $s1, data_devolucao  # Recarrega o endereco de curso novamente (para voltar ao 1ecaractere)	
    jal clear_buffer    	# Limpa o buffer "devolucao".
    
    la $s1, flag_foi_devolvido # Carrega o endereco do buffer `flag_foi_devolvido` em $s1.
  	jal str_concat      	    # Concatena o flag_foi_devolvido ao repositorio de emprestimo.
  	la $s1, flag_foi_devolvido # Recarrega o endereco do buffer `flag_foi_devolvido` em $s1.
  	jal clear_buffer    	    # Limpa o buffer "flag_foi_devolvido".

	# Limpa o buffer de comando
	la $s1, comando
	jal clear_buffer
	
	la $t1, msgC_emprestimo_realizado  # Carrega o endereco de msgC_emprestimo_realizado
	j escrever_com_sucesso_display

recuperar_endereco_s0:
	move $s0, $s3   # copia o endereco de $s3 pra $s0
	subi $s0, $s0, 1
	jr $ra
	
verificar_data_registro:
	# Aloca espaco no $sp para salvar o $ra
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	la $s1, arg_data 			   # Carrega o endereco da string "--data"  em $s1
	addi $s0, $s0, 1			   # Move o ponteiro para o proximo argumento
	move $s3, $s0                  # Copia o endereco de $s0 em $s3 
	li $s2, 6					   # Define a quantidade de caracteres que serao comparados
	jal comparar_strings		   # Funcao para comparar strings
	beqz $v0, pegar_data_usuario   # se o comando nao tem argumento --data, entao pegar data gerada pelo usuario 
	
	# Se comando tem o argumento --data copia o conteudo entre aspas duplas para o buffer data_registro
	addi $s0, $s0, 1			   # Avanca um caractere (por conta do espa�o)
	li $s5, 1                      # Inicializa $s5 com 1 (flag para indicar que o usuario forneceu --data)	
	la $t1, data_registro		
	jal guardar_info_buffer	
	move $t7, $t1           # Copia o endereco de $t1 em $t7
	
	# Vamos agora validar a data digitada pelo usuario
	la $t1, data_registro	
	jal validar_data 	
	
	# Se o usuario forneceu uma data valida o fluxo do codigo retorna para ca
	move $t1 ,$t7       # Copia o endereco de $t7 em $t1 (Recupera o endereco de $t1)
	la $t2, virgula		# Carrega o endereco de virgula		
	lb $t2, 0($t2)		# Carrega o byte do caractere de virgula		
	sb $t2, 0($t1)      # Escreve o byte de virgula
	j fim_verificar_data_registro
	
	pegar_data_usuario:
	li $s5, 0                      # Inicializa $s5 com 0 (flag para indicar que o usuario nao forneceu --data)
	move $s0, $s3                  # Copia o endereco de $s3 em $s0 (recuperando o endereco)
	la $t0, data_config_usuario    # Carrega o endereco de data_config_usuario
	lb $t0, 0($t0)                 # Carrega o primeiro byte de data_config_usuario
	beqz $t0, gerar_data           # Se o byte for nulo, entao nao configurou nenhua data. logo, pula pro gerar_data
	
	# Caso contrario, se for diferente de 0 esse trecho de codigo abaixo copia e cola data que ta configurado
	# de data_config_usuario para data_registro
	li $a2, 11                      # Define a quantidade de bytes a ser copiados 
	la $a1, data_config_usuario     # Define o reg de origem dos bytes a ser copiados
	la $a0, data_registro           # Define o reg de destino 
	jal memcpy                      # Chama a funcao que faz a copia
	addi $a1, $a1, 1                # Avanca 1 byte
	la $t1, virgula                 # Carrega o endereco de virgula
	lb $t1, 0($t1)                  # Carrega o byte de ','
	sb $t1, 0($a1)                  # Escreve a virgula em data_registro
	j fim_verificar_data_registro   # Pula para a funcao que encerra a copia        

	gerar_data: 
		la $a3, data_registro           # Carrega o endereco de data_atual 
		jal gerar_e_montar_data_atual   # Pula para a funcao que vai gerar e montar a daya no formato dd/mm/aaaa em $a3
		move $a3, $t6                   # Copia o endereco de $t6 para $a3
		addi $a3, $a3, 1                # Avanca para o proximo byte
		la $t1, virgula                 # Carrega o endereco de virgula
		lb $t1, 0($t1)                  # Carrega o byte de ','
		sb $t1, 0($a3)                  # Escreve a virgula em data_registro
		  
	fim_verificar_data_registro:
		lw $ra, 0($sp) 		# Resgata o $ra original do $sp
		addi $sp, $sp, 4	# Devolve a pilha para a posicao original
		jr $ra

obter_qtd:
	# $s1 reg que possui o endereco dos bytes que contem a quantidade do livro
	# $s2 reg que possui buffer onde serao armazenadas os bytes da quantidade
	
	la $t1, virgula     # Carrega o endereco de virgula
	lb $t1, 0($t1)      # Carrega o byte de ','
	move $s3, $s1       # Copia o endereco de $s1
	
	loop_obter_qtd:
		lb $t2, 0($s3)                    # Carrega o byte de $s3
		beq $t1, $t2, fim_lopp_obter_qtd  # Se o byte em $t2 for igual ao caractere de virgula o loop eh encerrado
		sb $t2, 0($s2)                    # Caso contrario, escreve o byte em $s2
		addi $s3, $s3, 1                  # Avanca para o proximo byte
		addi $s2, $s2, 1                  # Avanca para o proximo byte a ser inserido
		j loop_obter_qtd                  # Entra em loop
		
	fim_lopp_obter_qtd:
	jr $ra
	
verifica_qtd_disponivel:
	# $s1: reg que possui o endereco do primeiro byte do livro que precisamos obter a quantidade

	# Aloca espaco no $sp para salvar o endereco de $ra
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	jal avancar_ate_virgula # Avanca os bytes que contem o isbn
	jal avancar_ate_virgula # Avanca os bytes que contem o titulo
	jal avancar_ate_virgula # Avanca os bytes que contem o autor
	jal avancar_ate_virgula # Avanca os bytes de contem a quantidade total
	
	la $s2, buffer_aux_conversao   # Carrega o buffer_aux_conversao
	jal obter_qtd                  # Pula para a funcao que obtem a quantidade disponivel do livro e armazena em $s2
	
	la $t2, buffer_aux_conversao   # Carrega o buffer_aux_conversao
	jal converter_string_para_int  # Pula para a funcao que converte a string da quantidade disponivel pra int
	
	lw $ra, 0($sp) 		# Resgata o $ra original do $sp
    addi $sp, $sp, 4	# Devolve a pilha para a posicao original
	
	jr $ra

obter_conveter_qtd_disponivel_para_int:
	# $s1: reg que possui o endereco exato quantidade_disponivel
	
	# Aloca espaco no $sp para salvar o endereco de $ra
    addi $sp, $sp, -8
    sw $ra, 0($sp)
    sw $s1, 4($sp)   # Salva o endereco de $s1
    
    # Primeiro vamos limpar o buffer_aux_conversao
	la $s1, buffer_aux_conversao   # Carrega o endereco do buffer_aux_conversao
	jal clear_buffer
	
    lw $s1, 4($sp)                 # Resgata o endereco de $s1
    la $t2, buffer_aux_conversao   # Recarrega o endereco do buffer_aux_conversao
	jal copiar_ate_virgula         # Pula para a funcao que vai copiar os dados e armazenar em buffer_aux_conversao
	la $t2, buffer_aux_conversao   # Recarrega o endereco do buffer_aux_conversao (Para voltar para o primeiro byte)
	jal converter_string_para_int  # Pula para a funcao que vai converter os dados obtidos para inteiro 
		
	lw $s1, 4($sp)      # Resgata o endereco de $s1
	lw $ra, 0($sp)      # Resgata o $ra original do $sp
   	addi $sp, $sp, 8    # Devolve a pilha para a posicao original
	jr $ra

obter_conveter_qtd_emprestados_para_int:
	# $s1: reg que possui o endereco exato de quantidade_emprestado
	
	# Aloca espaco no $sp para salvar o endereco de $ra
    addi $sp, $sp, -8
    sw $ra, 0($sp)
    sw $s1, 4($sp)   # Salva o endereco de $s1
    
    # Primeiro vamos limpar o buffer_aux_conversao
	la $s1, buffer_aux_conversao   # Carrega o endereco do buffer_aux_conversao
	jal clear_buffer
	
    lw $s1, 4($sp)                 # Resgata o endereco de $s1
    la $t2, buffer_aux_conversao   # Recarrega o endereco do buffer_aux_conversao
	jal copiar_ate_barra_n         # Pula para a funcao que vai copiar os dados e armazenar em buffer_aux_conversao
	la $t2, buffer_aux_conversao   # Recarrega o endereco do buffer_aux_conversao (Para voltar para o primeiro byte)
	jal converter_string_para_int  # Pula para a funcao que vai converter os dados obtidos para inteiro 
		
	lw $s1, 4($sp)      # Resgata o endereco de $s1
	lw $ra, 0($sp)      # Resgata o $ra original do $sp
   	addi $sp, $sp, 8    # Devolve a pilha para a posicao original
	jr $ra
	
atualizar_qtd_disponivel_para_menos:
	# $s1: reg que possui o endereco dos bytes da quantidade disponivel do livro que iremos atualizar
	# $a0: reg que possui a quantidade disponivel convertida para inteiro
	 
	# Aloca espaco no $sp para salvar o endereco de $ra
    addi $sp, $sp, -8
    sw $ra, 0($sp)
    sw $s1, 4($sp)   # Salva o endereco de $s1
    
    # Primeiro vamos limpar o buffer_aux_conversao
	la $s1, buffer_aux_conversao   # Carrega o endereco do buffer_aux_conversao
	jal clear_buffer
	
	# agora vamos converter o valor inteiro de quantidade_disponivel para string 
	subi $a0, $a0, 1               # Decrementa 1 da quantidade disponivel 
	la $t6, buffer_aux_conversao   # Carrega o endereco do buffer_aux_conversao
	move $t7, $a0                  # Copia o valor inteira da quantidade disponivel de $a0 para $t7
	jal converter_int_para_string  # Pula para a funcao que vai converter o inteiro para string e armazenar em buffer_aux_conversao
	
	# Vamos agora obter a qtd de bytes da string convertida
	la $t2, buffer_aux_conversao   # Recarrega o endereco do buffer_aux_conversao
	jal descobrir_qtd_digitos      # Chama a funcao que vai descobrir a qtd de digitos (bytes) da string corvertida
	move $s6, $s7                  # Copia a quantidade de digitos (bytes) de $s7 para $s6
	
	# Agora vamos obter a qtd de bytes de quantidade_total 
	lw $s1, 4($sp)                 # Resgata o endereco de $s1
	move $s2, $s1                  # Copia o endereco de $s1 para $s2
	subi $s1, $s1, 2               # Retorna 2 bytes (por conta da virgula que tem antes dos bytes de quantidade_disponivel)
	jal voltar_ate_virgula         # Pula para a funcao que fazer com o endereco de $s1 retorne alguns bytes
	move $t2, $s1                  # Copia o endereco de $s1
	jal descobrir_qtd_digitos      # Chama a funcao que vai descobrir a qtd de digitos (bytes) em quantidade_total
	
	# Agora vamos comparar a quantidade de digitos 
	addi $ra, $ra, 12  # Atualiza o $ra, para que caso a condicao abaixo seja verdadeira o fluxo de execucao retorne para a linha seguinte
	blt $s6, $s7, inserir_caractere0_em_buffer_aux   # se $s6 for menor que $s7 pula para a funcao que insere o caractere 0 no comeco de buffer_aux 
	
	lw $s1, 4($sp)             # Resgata o endereco de $s1
	la $t6, buffer_aux_conversao   # Recarrega o endereco do buffer_aux_conversao
	jal escrever_ate_virgula   # Pula para a funcao responsavel pela escrita da string em $s1
	
	lw $ra, 0($sp)      # Resgata o $ra original do $sp
    addi $sp, $sp, 8    # Devolve a pilha para a posicao original
	
	jr $ra
	
atualizar_qtd_disponivel_para_mais:
	# $s1: reg que possui o endereco dos bytes da quantidade disponivel do livro que iremos atualizar
	# $a0: reg que possui a quantidade disponivel convertida para inteiro
	 
    addi $sp, $sp, -8
    sw $ra, 0($sp)
    sw $s1, 4($sp)   # Salva o endereco de $s1
	
	# Primeiro vamos limpar o buffer_aux_conversao
	la $s1, buffer_aux_conversao   # Carrega o endereco do buffer_aux_conversao
	jal clear_buffer
	
	# Agora vamos converter o valor inteiro de quantidade_disponivel para string
	addi $a0, $a0, 1               # Incrementa 1 da quantidade disponivel 
	la $t6, buffer_aux_conversao   # Carrega o endereco do buffer_aux_conversao
	move $t7, $a0                  # Copia o valor inteira da quantidade disponivel de $a0 para $t7
	jal converter_int_para_string  # Pula para a funcao que vai converter o inteiro para string e armazenar em buffer_aux_conversao
	
	# Vamos agora obter a qtd de bytes da string convertida
	la $t2, buffer_aux_conversao   # Recarrega o endereco do buffer_aux_conversao
	jal descobrir_qtd_digitos      # Chama a funcao que vai descobrir a qtd de digitos (bytes) da string corvertida
	move $s6, $s7                  # Copia a quantidade de digitos (bytes) de $s7 para $s6
	
	# Agora vamos obter a qtd de bytes de quantidade_total 
	lw $s1, 4($sp)                 # Resgata o endereco de $s1
	move $s2, $s1                  # Copia o endereco de $s1 para $s2
	subi $s1, $s1, 2               # Retorna 2 bytes (por conta da virgula que tem antes dos bytes de quantidade_disponivel)
	jal voltar_ate_virgula         # Pula para a funcao que fazer com o endereco de $s1 retorne alguns bytes
	move $t2, $s1                  # Copia o endereco de $s1
	jal descobrir_qtd_digitos      # Chama a funcao que vai descobrir a qtd de digitos (bytes) em quantidade_total
	
	# Agora vamos comparar a quantidade de digitos 
	addi $ra, $ra, 12  # Atualiza o $ra, para que caso a condicao abaixo seja verdadeira o fluxo de execucao retorne para a linha seguinte
	blt $s6, $s7, inserir_caractere0_em_buffer_aux   # se $s6 for menor que $s7 pula para a funcao que insere o caractere 0 no comeco de buffer_aux 
	
	lw $s1, 4($sp)                 # Resgata o endereco de $s1
	la $t6, buffer_aux_conversao   # Recarrega o endereco do buffer_aux_conversao
	jal escrever_ate_virgula       # Pula para a funcao responsavel pela escrita da string em $s1
	
	lw $ra, 0($sp)      # Resgata o $ra original do $sp
    addi $sp, $sp, 8    # Devolve a pilha para a posicao original
	
	jr $ra
	
atualizar_qtd_emprestados_para_menos:
	# $s1: reg que possui o endereco dos bytes da quantidade_emprestado do livro que iremos atualizar
	# $a0: reg que possui a quantidade_emprestado convertidos para inteiro
	 
	# Aloca espaco no $sp para salvar o endereco de $ra
    addi $sp, $sp, -8
    sw $ra, 0($sp)
    sw $s1, 4($sp)   # Salva o endereco de $s1
	
	# Primeiro vamos limpar o buffer_aux_conversao
	la $s1, buffer_aux_conversao   # Carrega o endereco do buffer_aux_conversao
	jal clear_buffer
	
	# Agora vamos converter o valor inteiro de quantidade_emprestado para string 
	subi $a0, $a0, 1               # Decrementa 1 da quantidade disponivel 
	la $t6, buffer_aux_conversao   # Carrega o endereco do buffer_aux_conversao
	move $t7, $a0                  # Copia o valor inteira da quantidade disponivel de $a0 para $t7
	jal converter_int_para_string  # Pula para a funcao que vai converter o inteiro para string e armazenar em buffer_aux_conversao
	
	# Vamos agora obter a qtd de bytes da string convertida
	la $t2, buffer_aux_conversao   # Recarrega o endereco do buffer_aux_conversao
	jal descobrir_qtd_digitos      # Chama a funcao que vai descobrir a qtd de digitos (bytes) da string corvertida
	move $s6, $s7                  # Copia a quantidade de digitos (bytes) de $s7 para $s6
	
	# Agora vamos obter a qtd de bytes de quantidade_total 
	lw $s1, 4($sp)                 # Resgata o endereco de $s1
	move $s2, $s1                  # Copia o endereco de $s1 para $s2
	subi $s1, $s1, 2               # Retorna 2 bytes (por conta da virgula que tem antes dos bytes de quantidade_disponivel)
	jal voltar_ate_virgula         # Pula para a funcao que fazer com o endereco de $s1 retorne alguns bytes
	jal voltar_ate_virgula         # Pula para a funcao que fazer com o endereco de $s1 retorne alguns bytes
	move $t2, $s1                  # Copia o endereco de $s1
	jal descobrir_qtd_digitos      # Chama a funcao que vai descobrir a qtd de digitos (bytes) em quantidade_total
	
	# Agora vamos comparar a quantidade de digitos 
	addi $ra, $ra, 12  # Atualiza o $ra, para que caso a condicao abaixo seja verdadeira o fluxo de execucao retorne para a linha seguinte
	blt $s6, $s7, inserir_caractere0_em_buffer_aux   # se $s6 for menor que $s7 pula para a funcao que insere o caractere 0 no comeco de buffer_aux 
	
	lw $s1, 4($sp)             # Resgata o endereco de $s1
	la $t6, buffer_aux_conversao   # Recarrega o endereco do buffer_aux_conversao
	jal escrever_ate_barra_n   # Pula para a funcao responsavel pela escrita da string em $s1
	
	lw $ra, 0($sp)      # Resgata o $ra original do $sp
    addi $sp, $sp, 8    # Devolve a pilha para a posicao original
	
	jr $ra
	
atualizar_qtd_emprestados_para_mais:
	# $s1: reg que possui o endereco dos bytes da quantidade_emprestado do livro que iremos atualizar
	# $a0: reg que possui a quantidade_emprestado convertida para inteiro
	
	# Aloca espaco no $sp para salvar o endereco de $ra
	addi $sp, $sp, -8
    sw $ra, 0($sp)
    sw $s1, 4($sp)   # Salva o endereco de $s1
	
	# Primeiro vamos limpar o buffer_aux_conversao
	la $s1, buffer_aux_conversao   # Carrega o endereco do buffer_aux_conversao
	jal clear_buffer
	
	# Agora vamos converter o valor inteiro de quantidade_emprestado para string 
	addi $a0, $a0, 1               # Incrementa 1 da quantidade disponivel 
	la $t6, buffer_aux_conversao   # Carrega o endereco do buffer_aux_conversao
	move $t7, $a0                  # Copia o valor inteira da quantidade disponivel de $a0 para $t7
	jal converter_int_para_string  # Pula para a funcao que vai converter o inteiro para string e armazenar em buffer_aux_conversao
	
	# Vamos agora obter a qtd de bytes da string convertida
	la $t2, buffer_aux_conversao   # Recarrega o endereco do buffer_aux_conversao
	jal descobrir_qtd_digitos      # Chama a funcao que vai descobrir a qtd de digitos (bytes) da string corvertida
	move $s6, $s7                  # Copia a quantidade de digitos (bytes) de $s7 para $s6
	
	# Agora vamos obter a qtd de bytes de quantidade_total 
	lw $s1, 4($sp)                 # Resgata o endereco de $s1
	move $s2, $s1                  # Copia o endereco de $s1 para $s2
	subi $s1, $s1, 2               # Retorna 2 bytes (por conta da virgula que tem antes dos bytes de quantidade_disponivel)
	jal voltar_ate_virgula         # Pula para a funcao que fazer com o endereco de $s1 retorne alguns bytes
	jal voltar_ate_virgula         # Pula para a funcao que fazer com o endereco de $s1 retorne alguns bytes
	move $t2, $s1                  # Copia o endereco de $s1
	jal descobrir_qtd_digitos      # Chama a funcao que vai descobrir a qtd de digitos (bytes) em quantidade_total
	
	# Agora vamos comparar a quantidade de digitos 
	addi $ra, $ra, 12  # Atualiza o $ra, para que caso a condicao abaixo seja verdadeira o fluxo de execucao retorne para a linha seguinte
	blt $s6, $s7, inserir_caractere0_em_buffer_aux   # se $s6 for menor que $s7 pula para a funcao que insere o caractere 0 no comeco de buffer_aux 
	
	lw $s1, 4($sp)                 # Resgata o endereco de $s1
	la $t6, buffer_aux_conversao   # Recarrega o endereco do buffer_aux_conversao
	jal escrever_ate_barra_n       # Pula para a funcao responsavel pela escrita da string em $s1
	
	lw $ra, 0($sp)      # Resgata o $ra original do $sp
    addi $sp, $sp, 8    # Devolve a pilha para a posicao original
	
	jr $ra

inserir_caractere0_em_buffer_aux:
	# Aloca espaco no $sp para salvar o endereco de $ra
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
	sub $s7, $s7, $s6                 # Subtrai $s7 com $s6 para obter a quantidade de caracteres 0 a serem inseridos
	la $t1, buffer_aux_conversao      # Carrega o endereco de buffer_aux_conversao
	jal guardar_bytes_strings_no_sp   # Pula para a funcao que vai guardar os bytes da string no $sp
	la $t1, buffer_aux_conversao      # Recarrega o endereco do buffer de quantidade_disponivel 
	li $t7, 48                        # Inicializa $t7 com o byte 48 (o caractere 0 em ascII)
	jal inserir_caractere0            # Pula para a funcao que vai inserir os caracteres 0 em quantidade_disponivel
	jal obter_bytes_string_do_sp      # pula para a funcao que vai recuperar o bytes da string que estavam armazenados no $sp
	
	lw $ra, 0($sp)         # Resgata o $ra original do $sp
    addi $sp, $sp, 4    # Devolve a pilha para a posicao original
    
	jr $ra
	
guardar_bytes_strings_no_sp:
	#$t1: reg que possui o endereco dos bytes da string a ser armazenado no $sp
	
	move $t2, $t1    # Copia o endereco de $t1 em $t2
	
	avancar_ate_byte_nulo:
		addi $t2, $t2, 1                 # Avan�a para o proximo byte
		lb $t3, 0($t2)                   # Carrega o byte de $t2
		bnez $t3, avancar_ate_byte_nulo  # Se nao for o byte nulo entra em loop
		
	subi $t2, $t2, 1     # Retorna 1 byte para que o byte nulo nao seja armazenado no $sp
	li $t9, 0            # Inicializa $t9 com 0 (reg que servirah como contador)
		
	loop_guardar_guardar_string:
		lb $t3, 0($t2)       # Carrega o byte de $t2
		addi $sp, $sp, -1  	 # Aloca espaco no $sp para armazenar o caractere da string
    	sb $t3, 0($sp)       # Insere o caractere no sp
    	addi $t9, $t9, 1     # Incrementa $t9
    	beq $t2, $t1, fim_loop_guardar_string  # Caso $t2 e $t1 tenham o mesmo endereco o loop encerra
    	subi $t2, $t2, 1     # Decrementa o endereco de $t2
    	j loop_guardar_guardar_string
    	
	 fim_loop_guardar_string:
	 	jr $ra

obter_bytes_string_do_sp:
	# $t1: reg que possui o endereco doo buffer que iremos armazenar os bytes de string
	# $t9: reg que possuia a quantidade de caracteres que estao armazenados no $sp
	
	loop_obter_bytes_string:
		lb $t2, 0($sp)           # Carrega o caractere do topo da pilha
     	sb $t2, 0($t1)           # Armazena o caractere em $t0
     	addi $sp, $sp, 1         # Incrementa o ponteiro do $sp voltando 1
     	subi $t9, $t9, 1         # Decrementa $t9
     	beqz $t9, fim_loop_obter_bytes_string     # Se $t9 for igual a 0 o loop encerra
	j loop_obter_bytes_string    # Caso contrario, entra em loop
	
	fim_loop_obter_bytes_string:
		jr $ra
		
escrever_ate_virgula:
	# $s1: reg que possui o endereco exato onde ocorrerah a escrita
	# $t6: reg que possui o buffer contendo os bytes que iremos escrever
	
	la $t0, virgula   # Carrega o endereco de virgula
	lb $t0, 0($t0)    # Carrega o byte que corresponde ao caractere de virgula
	
	loop_escrever_ate_virgula:
		lb $t2, 0($s1)                   # Carrega o byte de $s1
		beq $t2, $t0, fim_loop_escrita_ate_virgula   # Se o byte for o caractere de virgula o loop encerra
		lb $t9, 0($t6)                   # Caso contrario, leh o byte de $t6
		sb $t9, 0($s1)                   # Escreve o caractere em $s1
		addi $s1, $s1, 1                 # Avanca para o proximo endereco
		addi $t6, $t6, 1                 # Avanca para o proximo byte
		j loop_escrever_ate_virgula      # Entra em loop
		
	fim_loop_escrita_ate_virgula:
		jr $ra
	
escrever_ate_barra_n:
	# $s1: reg que possui o endereco exato onde ocorrerah a escrita
	# $t6: reg que possui o buffer contendo os bytes que iremos escrever
	
	la $t0, barra_n  # Carrega o endereco de barra_n
	lb $t0, 0($t0)    # carrega o byte que corresponde ao caractere de barra n '\n'
	
	loop_escrever_ate_barra_n:
		lb $t2, 0($s1)                   # Carrega o byte de $s1
		beq $t2, $t0, fim_loop_escrita_ate_barra_n   # Se o byte for o caractere de '\n' o loop encerra
		lb $t9, 0($t6)                   # Caso contrario, leh o byte de $t6
		sb $t9, 0($s1)                   # Escreve o caractere em $s1
		addi $s1, $s1, 1                 # Avanca para o proximo endereco
		addi $t6, $t6, 1                 # Avanca para o proximo byte
		j loop_escrever_ate_virgula      # Entra em loop
		
	fim_loop_escrita_ate_barra_n:
		jr $ra
		
copiar_ate_virgula:
	# $s1: reg que contem o endereco exato dos bytes que iremos copiar
	# $t2: reg que iremos armazenar os bytes copiados
	
	la $t0, virgula     # Carrega o endereco de virgula
	lb $t0, 0($t0)      # Carrega o byte correspondente ao caractere de virgula em ascII
	
	loop_copiar_ate_virgula:
		lb $s2, 0($s1)      # Carrega o byte de $s1
		beq $s2, $t0, fim_loop_copiar_ate_virgula    # se o byte de $s1 for igual ao caractere de virgula o loop encerra  
		sb $s2, 0($t2)      # Caso contrario, escreve o byte lido em $t2
		addi $s1, $s1, 1    # Avanca para o proximo byte
		addi $t2, $t2, 1    # Avanca para o proximo byte a ser inserido
		j loop_copiar_ate_virgula # Entra em loop
		
	fim_loop_copiar_ate_virgula:
		jr $ra
		
copiar_ate_barra_n:
	# $s1: reg que contem o endereco exato dos bytes que iremos copiar
	# $t2: reg que iremos armazenar os bytes copiados

	la $t0, barra_n   # Carrega o endereco de barra_n
	lb $t0, 0($t0)    # Carrega o byte correspondente ao caractere de \n
	
	loop_copiar_ate_barra_n:
		lb $s2, 0($s1)      # Carrega o byte de $s1
		beq $s2, $t0, fim_loop_copiar_ate_barra_n    # se o byte de $s1 for igual ao caractere de \n o loop encerra  
		sb $s2, 0($t2)      # Caso contrario, escreve o byte lido em $t2
		addi $s1, $s1, 1    # Avanca para o proximo byte
		addi $t2, $t2, 1    # Avanca para o proximo byte a ser inserido
		j loop_copiar_ate_barra_n # Entra em loop
		
	fim_loop_copiar_ate_barra_n:
		jr $ra
		
gerar_relatorio:
	# Funcao que mostra os livros que estao emprestados e os usuarios que estao em atraso
	# A funcao recebe o repositorio de emprestimos no $s7 e faz um conjunto de calculos e verificacoes para
	# determinar quais livros estao emprestados e quais usuarios estao em atraso
	
	la $s7, repo_emprestimo		# Carrega o repo_emprestimo em $s7
	
	loop_encontrar_nao_devolvidos:
		la $t1, barra_n   # Carrega o endereco de barra_n
		lb $t1, 0($t1)    # Carrega o byte que carrega o byte do caractere '\n'
	 
		loop_avancar_barra_n_relatorio:
			lb $t2, 0($s7)                  				# Carrega o byte em repo_livro
			beq $t2, $t1, fim_loop_avancar_relatorio  	# Caso $s7 esteja no caractere \n, o loop encerra e passa para verificar se o emprestimo estah ativo
			beqz $t2, fim_gerar_relatorio					# Caso $s7 esteja no caractere nulo, o loop encerra e encerra tambem a funcao, pois chegou as final do repositorio
			addi $s7, $s7, 1                				# Contrario avanca o caractere
			j loop_avancar_barra_n_relatorio          	# Entra em loop
			
		fim_loop_avancar_relatorio:
			subi $s7, $s7, 1								# Volta um caracter para analisar a flag de emprestimo
			lb $t2, 0($s7)									# Carrega a flag
			beq $t2, 48	, emprestimo_ativo					# Se a flag eh 0, o emprestimo esta ativo
			# Se nao for 0, o emprestimo esta finalizado e podemos continuar a busca 
			addi $s7, $s7, 2								# Passa dois caracteres para passar do "/n"
			j loop_avancar_barra_n_relatorio
		
		fim_gerar_relatorio:
			# Apos a finalizacao da funcao, apresentamos os dados obtidos
			la $t1, string_livros_emprestados					# Carrega a string "Livros emprestados:"
			jal escrever_string_display						# Apresenta a string
			jal escrever_barra_n_display						# Pula linha
			
			la $s7, buffer_aux_livros_emprestados				# Carrega o buffer que comtém os livros emprestados
			jal loop_escrever_livros_emprestados_display		# Passa para a funcao que apresenta as informacoes formatadas
			jal escrever_barra_n_display						# Pula linha
			
			la $t1, string_usuarios_atrasados					# Carrega a string "Livros emprestados:"
			jal escrever_string_display						# Apresenta a string
			jal escrever_barra_n_display						# Pula linha
			
			la $s7, buffer_aux_usuario_atrasados				# Carrega o buffer que comtém os usuarios que estao em atraso
			jal loop_escrever_usuarios_atrasados_display		# Passa para a funcao que apresenta as informacoes formatadas
			jal escrever_barra_n_display						# Pula linha
			
			# Limpa o buffer de comando
			la $s1, comando
			jal clear_buffer
		
			j main
			
			loop_escrever_livros_emprestados_display:
			# Funcao que formata e exibe as informacoes do livros que estao emprestados
				addi $sp, $sp, -4
    			sw $ra, 0($sp)
				
				loop_escrever_relatorio_emprestados:
					# Guarda as infos nos buffers
					# Em $t1 eh passado o buffer no qual a informacao vai ser temporariamenete armazenada para impressao
					# Em $s7 estah o buffer_aux_livros_emprestados que contem as infos de todos os livros que ainda estao emprestados
					# Esses registradores sao usados na funcao guardar_info_buffer_relatorio
					la $t1, ISBN
					jal guardar_info_buffer_relatorio
					
					la $t1, titulo
					jal guardar_info_buffer_relatorio
    				
    				la $t1, data_devolucao
					jal guardar_info_buffer_relatorio
					
					# Exibir ISBN
    				la $t1, string_isbn						# Carrega a string "ISBN: "
    				jal escrever_string_display				# Escreve no display
    				la $t1, ISBN								# Carrega o buffer do ISBN
    				jal escrever_string_display				# Escreve no display
    				jal escrever_barra_vertical_display		# Escreve o caractere de "|"
    				
    				# Limpa o buffer do ISBN
    				la $s1, ISBN
    				jal clear_buffer

   					 # Exibir Título
    				la $t1, string_livro						# Carrega a string "Livro: "
    				jal escrever_string_display				# Escreve no display
   	 				la $t1, titulo								# Carrega o buffer de titulo
    				jal escrever_string_display				# Escreve no display
    				jal escrever_barra_vertical_display		# Escreve o caractere de "|"
    				
    				# Limpa o buffer do titulo
    				la $s1, titulo
    				jal clear_buffer

    				# Exibir Data de Devolucao
    				la $t1, string_data_devolucao
    				jal escrever_string_display
    				la $t1, data_devolucao
    				jal escrever_string_display
    				jal escrever_barra_n_display
    				
    				# Limpa o buffer da data_devolucao
    				la $s1, data_devolucao
    				jal clear_buffer
    				
    				lb $t0, 0($s7)                 					# Verifica se chegamos ao fim
    				bnez $t0, loop_escrever_relatorio_emprestados   # Continua se ainda houver dados
					
					lw $ra, 0($sp)         # Resgata o $ra original do $sp
    				addi $sp, $sp, 4    	# Devolve a pilha para a posicao original
    				jr $ra
			
			loop_escrever_usuarios_atrasados_display:
				addi $sp, $sp, -4
    			sw $ra, 0($sp)
				
				loop_escrever_relatorio_atrasados:
					# Guarda as infos nos buffers
					# Em $t1 eh passado o buffer no qual a informacao vai ser temporariamenete armazenada para impressao
					# Em $s7 estah o buffer_aux_usuario_atrasados que contem as infos de todos os livros que ainda estao emprestados
					# Esses registradores sao usados na funcao guardar_info_buffer_relatorio
					
					la $t1, matricula
					jal guardar_info_buffer_relatorio
					
					la $t1, nome
					jal guardar_info_buffer_relatorio
					
					la $t1, ISBN
					jal guardar_info_buffer_relatorio
					
					la $t1, titulo
					jal guardar_info_buffer_relatorio
    				
    				la $t1, data_devolucao
					jal guardar_info_buffer_relatorio
					
					la $t1, buffer_aux_conversao
					jal guardar_info_buffer_relatorio
					
					# Exibir Matricula
    				la $t1, string_matricula	
    				jal escrever_string_display
    				la $t1, matricula
    				jal escrever_string_display
    				jal escrever_barra_vertical_display
    				
    				# Limpa o buffer da matricula
    				la $s1, matricula
    				jal clear_buffer
					
					# Exibir Nome
    				la $t1, string_nome
    				jal escrever_string_display
    				la $t1, nome
    				jal escrever_string_display
    				jal escrever_barra_vertical_display
    				
    				# Limpa o buffer do nome
    				la $s1, nome
    				jal clear_buffer
					
					# Exibir ISBN
    				la $t1, string_isbn
    				jal escrever_string_display
    				la $t1, ISBN
    				jal escrever_string_display
    				jal escrever_barra_vertical_display
    				
    				# Limpa o buffer do ISBN
    				la $s1, ISBN
    				jal clear_buffer

   					 # Exibir Título
    				la $t1, string_livro
    				jal escrever_string_display
   	 				la $t1, titulo
    				jal escrever_string_display
    				jal escrever_barra_vertical_display
    				
    				# Limpa o buffer do titulo
    				la $s1, titulo
    				jal clear_buffer

    				# Exibir Data de Devolucao
    				la $t1, string_data_devolucao
    				jal escrever_string_display
    				la $t1, data_devolucao
    				jal escrever_string_display
    				jal escrever_barra_vertical_display
    				
    				# Limpa o buffer da data_devolucao
    				la $s1, data_devolucao
    				jal clear_buffer
    				
    				# Exibir Dias de atraso
    				la $t1, string_dias_atraso
    				jal escrever_string_display
    				la $t1, buffer_aux_conversao
    				jal escrever_string_display
    				jal escrever_barra_n_display
    				
    				# Limpa o buffer que guarda os dias de atraso
    				la $s1, buffer_aux_conversao
    				jal clear_buffer
    				
    				lb $t0, 0($s7)                 					# Verifica se chegamos ao fim
    				bnez $t0, loop_escrever_relatorio_atrasados   	# Continua se ainda houver dados
					
					lw $ra, 0($sp)         # Resgata o $ra original do $sp
    				addi $sp, $sp, 4    # Devolve a pilha para a posicao original
    				jr $ra
			
			
			emprestimo_ativo:
			# Ja que o emprestimo esta ativo vamos guardar as infos necessarias nos buffers
			# Antes vamos preservar o endereco do $s7 guardando ele no stack, pois ele eh usado em algumas funcoes mais pra frente
				addi $sp, $sp, -4
    			sw $s7, 0($sp)
    			
    			subi $s7, $s7, 2
				jal voltar_ate_barra_n		# Volta ate o inicio do elemento
				# Os emprestimos sao salvos como: ISBN,matricula,data_registro,data_devolucao
				# Vamos salvar nos buffers as infos de ISBN, matricula e data_devolucao
				
				# Primeiro vamos salvar a matricula do usuario que realizou o emprestimo
    			la $t1, matricula
				jal guardar_info_buffer_relatorio
				la $t2, virgula          # Carrega o endereco da virgula (',')
				lb $t2, 0($t2)           # Carrega o byte do caractere da virgula
    			sb $t2, 0($t1)           # Adiciona a virgula ao final
				
				# Guardamos agora o ISBN do livro que foi emprestado
				la $t1, ISBN
				jal guardar_info_buffer_relatorio
				la $t2, virgula          # Carrega o endereco da virgula (',')
				lb $t2, 0($t2)           # Carrega o byte do caractere da virgula
    			sb $t2, 0($t1)           # Adiciona a virgula ao final
    			
    			# Pula a data de registro avancando ateh a proxima virgula e ignorando a da registro
    			move $s1, $s7
    			jal avancar_ate_virgula
    			move $s7, $s1
    			
    			# E guardamos por ultimo a data de devolucao
    			la $t1, data_devolucao
				jal guardar_info_buffer_relatorio
				
				# Cada uma das informacoes agora esta salva em seus respectivos buffers
				# A data_devolucao eh a unica que nao tem um separador adicionado ao fim (diferente do ISBN, por exemplo, que colocamos uma virgula ao fim)
				# pois esse buffer eh possivelmente usado tambem para as infos dos usuarios em atraso, e cada uma dessas ocorrencias necessita
				# de separadores distintos.
			
				# Agora precisamos descobri o titulo do livro que foi emprestado
				la $s1, repo_livro						# Carregamos o repositorio de livros 
				la $s3, ISBN							# Carregamos o ISBN que salvamos anteriormente
				jal fazer_busca_no_repositorio		   	#Buscamos no repositorio de livros pelo ISBN salvo
				
				# E agora guardamos o titulo do livro no buffer
				jal avancar_ate_virgula				# Passamos da virgula, pois a primeira info eh o ISBN
				move $s7, $s1							# Guarda o $s1 no registrador $s7 pois esse eh o usado para a funcao guardar_info_buffer_relatorio
				la $t1, titulo							# Carregamos o endereco do buffer de titulo
				jal guardar_info_buffer_relatorio
				la $t2, virgula          # Carrega o endereco da virgula (',')
				lb $t2, 0($t2)           # Carrega o byte do caractere da ','
    			sb $t2, 0($t1)           # Adiciona a ',' ao final
    			
    			# Agora vamos guardar essas infos no buffer de livros emprestados
    			# Para isso, vamos concatenar todas as informacoes que obtivemos em uma unica string e coloca-la no buffer_aux_livros_emprestados
				la $s0, buffer_aux_livros_emprestados  # Carrega o endereco de buffer_aux_livros_emprestados
				
				la $s1, ISBN        # Carrega o endereco de isbn
				jal str_concat      # Pula para a funcao que vai concatenar os dados de isbn em repo_livro
	
				la $s1, titulo		# Carrega o endereco de titulo
				jal str_concat      # Pula para a funcao que vai concatenar os dados de titulo em repo_livro
	
				la $s1, data_devolucao      # Carrega o endereco de autor
				jal str_concat      # Pula para a funcao que vai concatenar os dados de autor em repo_livro
				
				# Aqui adicionamos um /n ao final do elemento salvo no buffer, de modo que temos uma separacao clara entre os elementos
				la $t0, barra_n
				lb $t0, 0($t0)
				sb $t0, 0($s0)
				
				lw $s7, 0($sp) 		   # Resgata o $s7 original do $sp
	
				# Agora temos todas as infos que precisamos para a parte dos livros que estao emprestados
				# Vamos descobri se esse emprestimo ativo estah atrasado
				# Para isso vamos calcular se a data atual do sistema eh anterior ou posterior a data_devolucao
				# e tambem vamos calcular de quantos dias eh essa diferenca
				
				# Para isso vamos transformar a data_devolucao e a data atual do sistema em valores numericos e salva-las
				# nos seguintes registradores: 
				# data inicial (data do sistema) -> $s0: ano, $s1: mes, $s2: dia
				# data final (data de devolucao) -> $s3: ano, $s4: mes, $s5: dia
				
				# Para pegarmos a data final, basta pegar o que estah no buffer data_devolucao e transformar em valor numerico
				# A funcao memcpy usa os registradores $a0 (destination), $a1 (source) e $a2 (contador)
				
				li $a2, 2						# Define que serao copiados 2 caracteres (dia)
				la $a1, data_devolucao			# Define data_devolucao como o buffer de origem
				la $a0, buffer_aux_conversao	# Define buffer_aux_conversao como buffer de destino
				jal memcpy						# Copia os dois caracteres do dia para o buffer de conversao 
				
				la $t2, buffer_aux_conversao		# Carrega o endereco do buffer de conversao
				jal converter_string_para_int		# Converte a string que representa o dia para um inteiro 
				# Por exemplo, se antes tinhamos os caracteres "02" agora temos o inteiro 2
				move $s5, $a0	# Passa o inteiro convertido para o registrador $s5 para ser usado posteriormente na funcao de calculo de dias entre datas
				
				addi $a1, $a1, 3 					# Passa 3 caracteres no buffer de data_devolucao para chegar nos caracteres do mes
				li $a2, 2							# Define que serao copiados 2 caracteres (mes)
				la $a0, buffer_aux_conversao		# Define buffer_aux_conversao como buffer de destino
				jal memcpy							# Copia os dois caracteres do dia para o buffer de conversao 
				
				la $t2, buffer_aux_conversao		# Carrega o endereco do buffer de conversao
				jal converter_string_para_int		# Converte a string que representa o mes para um inteiro
				move $s4, $a0						# Move o inteiro convertido do mes para $s4
				
				addi $a1, $a1, 3					# Passa 3 caracteres no buffer de data_devolucao para chegar nos caracteres do ano
				li $a2, 4							# Define que serao copiados 4 caracteres	(ano)
				la $a0, buffer_aux_conversao
				jal memcpy
				
				la $t2, buffer_aux_conversao
				jal converter_string_para_int
				move $s3, $a0						# Move o inteiro convertido do ano para $s3
				
				# Limpa o buffer de conversao
				la $s1, buffer_aux_conversao
				jal clear_buffer
				
				# Agora precisamos verificar qual a data atual do sistema, se eh customizada (se o usuario definiu uma data) ou se eh a data gerada
				la $a1, data_config_usuario	# Carrega o buffer que guarda a data definida pelo usuario
				lb $t0, 0($a1)					# Carrega o primeiro byte do buffer data_config_usuario
				beqz $t0, data_atual_gerada 	# Se for igual a zero, o buffer esta vazio e a data a ser usada eh a gerada e nao a configurada
				# Se eh diferente de zero, a data foi configurada, entao deve-se resgatar o valor definido pelo usuario para a data
				
				# O processo a seguir pega a data configurada pelo usuario e transforma em inteiros semelhante
				# ao processo feito anteriormente
				li $a2, 2
				la $a1, data_config_usuario
				la $a0, buffer_aux_conversao
				jal memcpy
				
				la $t2, buffer_aux_conversao
				jal converter_string_para_int
				move $s2, $a0						# Move o inteiro convertido do dia configurado para $s2
				
				li $a2, 2
				addi $a1, $a1, 3
				la $a0, buffer_aux_conversao
				jal memcpy							
				
				la $t2, buffer_aux_conversao
				jal converter_string_para_int
				move $s1, $a0						# Move o inteiro convertido do mes configurado para $s1
				
				li $a2, 4
				addi $a1, $a1, 3
				la $a0, buffer_aux_conversao
				jal memcpy
				
				la $t2, buffer_aux_conversao
				jal converter_string_para_int
				move $s0, $a0						# Move o inteiro convertido do ano configurado para $s0
				
				# Limpa o buffer de conversao
				la $s1, buffer_aux_conversao
				jal clear_buffer
				
				# Passa para o calculo dos dias entre as duas datas registradas
				j calculo_atraso
				
				data_atual_gerada:
					# Caso a data do sistema nao tenha sido configurada pelo usuario, geramos a data atual
					# utilizando o syscall 30
					# Essa funcao ja coloca o dia, mes e ano nos registradores esperados para serem usados na funcao de calculo
					# de dias entre duas datas
					# $s0 = ano | $s1 = mes | $s2 = dia
					jal gerar_data_atual
				
				calculo_atraso:
				# Calcula a diferenca entre as datas de devolucao e atual e guarda em $t7 a diferenca em dias
					jal calcula_entre_datas				# Chama a funcao que de fato calcula os dias entre as datas
					bgez $t7, fim_emprestimo_ativo		#Se $t7 for maior ou igual a zero, o usuario ainda nao esta em atraso
					# pois significa que a data de devolucao eh posterior a data atual
					
					sub $t7, $zero, $t7			# No momento, $t7 carrega um valor negativo, entao transformamos em um valor positivo ao subtrair com zero
					# Vamos trasformar o numero de dias de valor numerico para string
					la $t6, buffer_aux_conversao		# Carrega o buffer que armazenarah o valor numerico transformado em string
					jal converter_int_para_string		# Converte o que esta em $t7 para string
					
					# Busca no repositorio de usuario o nome do usuario que esta em atraso
					la $s1, repo_usuario
					la $s3, matricula
					jal fazer_busca_no_repositorio
					
					# E agora guardamos o nome do usuario no buffer
					jal avancar_ate_virgula				# Passa da matricula que eh a primeira informacao guardada do usuario
					move $s7, $s1							# Passa para $s7 o endereco salvo em $s1
					la $t1, nome							# Carrega o endereco do buffer de nome
					jal guardar_info_buffer_relatorio
					la $t2, virgula          # Carrega o endereco da virgula 
					lb $t2, 0($t2)           # Carrega o byte do caractere da ,
    				sb $t2, 0($t1)           # Adiciona a , ao final
					
					# Agora vamos colocar tudo no buffer_aux_usuario_atrasados
					la $s0, buffer_aux_usuario_atrasados  # Carrega o endereco de buffer_aux_livros_emprestados
					
					la $s1, matricula        		# Carrega o endereco de matricula
					jal str_concat      			# Pula para a funcao que vai concatenar os dados no buffer
					
					la $s1, nome        			# Carrega o endereco de nome
					jal str_concat      			# Pula para a funcao que vai concatenar os dados no buffer
					
					la $s1, ISBN        			# Carrega o endereco de isbn
					jal str_concat      			# Pula para a funcao que vai concatenar os dados no buffer
	
					la $s1, titulo					# Carrega o endereco de titulo
					jal str_concat      			# Pula para a funcao que vai concatenar os dados no buffer
	
					la $s1, data_devolucao      	# Carrega o endereco de data_devolucao
					jal str_concat      			# Pula para a funcao que vai concatenar os dados no buffer
					
					# Adiciona o separador de virgula apos a data_devolucao ser adicionada
					la $t0, virgula
					lb $t0, 0($t0)
					sb $t0, 0($s0)
					
					la $s1, buffer_aux_conversao      	# Carrega o endereco do buffer que guarda os dias de atraso
					jal str_concat      			# Pula para a funcao que vai concatenar os dados no buffer
					
					# Adiciona o separador de /n ao fim dos dias de atraso
					la $t2, barra_n          			# Carrega o endereco da barra_n 
					lb $t2, 0($t2)          			# Carrega o byte do caractere da barra_n
    				sb $t2, 0($s0)           			# Adiciona a barra_n ao final
					
					fim_emprestimo_ativo:
						# Limpando todos os buffers usados
						la $s1,ISBN			
						jal clear_buffer
						
						la $s1, titulo			
						jal clear_buffer
						
						la $s1, matricula			
						jal clear_buffer
						
						la $s1, nome			
						jal clear_buffer
						
						la $s1, data_devolucao			
						jal clear_buffer
						
						la $s1, acumulador			
						jal clear_buffer
						
						la $s1, buffer_aux_conversao			
						jal clear_buffer
						
						lw $s7, 0($sp) 		   # Resgata o $s7 original do $sp
						addi $s7, $s7, 2       # Avanca 2 bytes para ir para a proxima linha
    					addi $sp, $sp, 4	   # Devolve a pilha para a posicao original
						
						j loop_encontrar_nao_devolvidos  # Continua procurando por emprestimos ativos

guardar_info_buffer_relatorio:
	# $t1: contem qual o buffer a ser usado
	# $s7: contem a info a ser guardada
	
	la $t0, virgula     	# Carrega o endereco de virgula
	lb $t2, 0($t0)      	# Carrega o byte correspondente ao caractere de virgula em ascII
	
	la $t0, barra_n			# Carrega o endereco barra_n
	lb $t3, 0($t0)			# Carrega o byte correspondente ao caractere de barra_n em ascII
	
	# Copia os caracteres ateh a virgula
	copy_loop_relatorio:
    	lb $t0, 0($s7)           				# Carrega o proximo caractere
      	beq $t0, $t2, finalize_relatorio    	# Se for virgula, finaliza a copia
      	beq $t0, $t3, finalize_relatorio		# Se for barra_n, finaliza a copia
      	beqz $t0, finalize_relatorio			# Se achar um byte nulo, finaliza a copia
    	sb $t0, 0($t1)            				# Copia o caractere para o buffer
    	addi $s7, $s7, 1          				# Avanca para o proximo caractere
    	addi $t1, $t1, 1          				# Avanca no buffer
    	j copy_loop_relatorio

	# Finaliza o buffer adicionando a virgula
	finalize_relatorio:
		sb $zero, 0($t1)			# Adiciona um byte nulo ao fim do buffer que guarda a copia
		addi $s7, $s7, 1 			# Passa da virgula
    	jr $ra

registrar_devolucao:
	## Verifica argumentos obrigaorios
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

    # Verifica o argumento "--isbn"
    la $s1, arg_ISBN			# Carrega o endereco da string "--matricula"  em $s1
	addi $s0, $s0, 1           	# Move o ponteiro para o proximo argumento
    li $s2, 6               	# Tamanho esperado do argumento
    jal comparar_strings       	# funcao para comparar strings
    beqz $v0, escrever_falta_argumento_ISBN_display # Se as strings nao forem iguais, exibe erro
	
	addi $s0, $s0, 1            # Move o ponteiro para a proxima info
    la $t1, ISBN           		# Carrega o endereco do matricula em $t1
    jal guardar_info_buffer     # Guarda o conteudo entre aspas no bufffer ISBN
    la $t2, virgula             # Carrega o endereco da virgula (',')
	lb $t2, 0($t2)              # Carrega o byte do caractere da virgula
    sb $t2, 0($t1)              # Adiciona virgula ao final da matricula

	## Agora verificamos se o emprestimo com a matricula e ISBN fornecidos existe 
	li $t9, 0   # inicializamos $t9 com 0 (flag para indicar que estamos fazendo uma busca por meio da funcao registrar_devolucao)
	jal buscar_emprestimo
	
	# Se existir, vamos para a funcao que atualiza o status para devolvido
	# e atualizamos os atributos quantidade_disponivel e quantidade_emprestado
	jal fazer_devolucao
	
	# Limpa os buffers de comando, matricula e ISBN, quantidade_disponivel e quantidade_emprestado
	la $s1, comando
	jal clear_buffer
	
	la $s1, matricula
	jal clear_buffer
	
    la $s1, ISBN
    jal clear_buffer  
    
    la $s1, quantidade_disponivel
    jal clear_buffer  
    
    la $s1, quantidade_emprestado
    jal clear_buffer
	
	# Imprime uma mensagem de que a devolucao foi concluida no display
	la $t1, msgC_devolucao_registrada
	jal escrever_com_sucesso_display	
	
buscar_emprestimo:
	# Aloca espaco no $sp para salvar o endereco de $ra
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    # Obtendo a quantidade de bytes de matricula
    la $t2, matricula
    jal descobrir_qtd_digitos 	# Pula para a funcao que calcula a qtd de bytes do buffer matricula
    move $s5, $s7 		        # Copia a quantidade de bytes de $s7 para $s5
    
    # Obtendo a quantidade de bytes de isbn
    la $t2, ISBN
    jal descobrir_qtd_digitos 	# Pula para a funcao que calcula a qtd de de bytes do buffer isbn
    move $s6, $s7 		        # Copia a quantidade de bytes de $s7 para $s5
    
  	# Vamos agora verificar se ha alguma matricula e isbn na mesma linha
  	la $s0, repo_emprestimo # inicializa s1 com endereco do repo_emprestimo para comparacoes
  	
  	loop_busca_matricula:     # busca primeiro por matricula
  		# Verifica se esta no final de repo_emprestimo
  		lb $t0, 0($s0)
  		beqz $t0, verificar_flag_t9
  		
  		# Verifica se matricula foi encontrada
  		la $s1, matricula            # Carrega t0 com o buffer matricula
  		move $s2, $s5                # s2 recebe o numero de bytes de matricula para fazer a comparacao
  		jal comparar_strings         # Compara se a matricula dessa linha e o procurada
  		beq $v0, 1, loop_busca_isbn  # Se encontrou a matricula naquela linha faz busca do isbn
  		
  		# pula ate a proxima linha
  		move $s1, $s0            # copia o endereco de $s0 em $s1 
  		jal avancar_ate_barra_n  # pula para a funcao que avanca ateh o caractere de \n
  		addi $s1, $s1, 1         # avanca para a proxima linha do registro
  		move $s0, $s1            # atualiza $s0 com o novo endereco de $s1 obtido pela chamada da funcao acima
  		j loop_busca_matricula   # Recomeca o loop
  		
  		loop_busca_isbn:
  			move $s1, $s0            # copia o endereco de $s0 em $s1 
  			jal avancar_ate_virgula  # avanca ate a virgula
  			move $s0, $s1            # atualiza $s0 com o novo endereco de $s1 obtido pela chamada da funcao acima
  			
  			# Verifica se isbn foi encontrado
  			la $s1, ISBN 	                   		   # Carrega o endereco de isbn em t0
  			move $s2, $s6 	                   		   # Carrega o tamanho de isbn em t5
  			jal comparar_strings               		   # Compara se a matricula dessa linha e o procurada
  			beq $v0, 1, verificar_flag_foi_devolvido   # Se v0 eh igual 1 o emprestimo foi encotrado
  			
  			# Caso nao seja pula para a proxima linha
  			move $s1, $s0            # copia o endereco de $s0 em $s1 
  			jal avancar_ate_barra_n
  			addi $s1, $s1, 1         # Avanca para a proxima linha do registro
  			move $s0, $s1            # Atualiza $s0 com o novo endereco de $s1 obtido pela chamada da funcao acima
  			j loop_busca_matricula   # Recomeca o loop
  			
  			verificar_flag_foi_devolvido:
  				li $v1, 0                  # Inicializa $v1 com 0 (flag para indicar que o emprestimo nao foi encontrado)
  				move $s1, $s0              # copia o endereco de $s0 em $s1
  				addi $s1, $s1, 1           # Avanca mais um byte (por conta da virgula depois do isbn) 
  				jal avancar_ate_virgula    # Avanca os bytes de data_registro
  				jal avancar_ate_virgula    # Avanca os bytes de data_devolucao
  				lb $a3, 0($s1)             # Carrega o byte da flag
  				beq $a3, 48, atualizar_flag_v1
  				
  				# Caso nao seja pula para a proxima linha
  				addi $s1, $s1, 1         # Avanca para a proxima linha do registro
  				move $s0, $s1            # Atualiza $s0 com o novo endereco de $s1 obtido pela chamada da funcao acima
  				j loop_busca_matricula   # Recomeca o loop
  			
  			atualizar_flag_v1:
				li $v1, 1     # Atualiza a flag de $v1
  			
	fim_busca_emprestimo:
	move $s1, $s0  # copia o endereco de $s0 em $s1 (reg a qual iremos usar a partir desse ponto)
	## s1 vai ter o endereco do primeiro byte de ISBN do repositorio_emprestimo do registro desejado
	
    lw $ra, 0($sp) 		   # Resgata o $ra original do $sp
    addi $sp, $sp, 4	   # Devolve a pilha para a posicao original
    jr $ra
    
verificar_flag_t9:
	beq $t9, 1, fim_busca_emprestimo   # se $a3 for igual a 1, signigica que estamos fazendo uma busca dentro de registrar_empresitmo
	beqz $t9, escrever_emprestimo_nao_encontrado_display # se for igual a 0, n�s imprimos a mensagem 

fazer_devolucao:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
	# Marca a flag do emprestimo em 1
	jal avancar_ate_virgula    # Avanca ate virgula antes data registro
	jal avancar_ate_virgula    # Avanca ate virgula antes data devolucao
	jal avancar_ate_virgula    # Avanca ate a virgula antes flag
	subi $s1, $s1, 1           # retorna 1 byte do endereco de $s1
	li $t1, 49                 # Inicializa $t1 com o byte 49 (caractere 1)
	sb $t1, 1($s1)             # Escreve o caractere 1 
	
	## Faz a busca no repo_livro, soma 1 das quantias disponiveis, subtrai 1 das quantias emprestadas
	
	# busca o registro do livro no repositorio livro
	la $s1, repo_livro
	la $s3, ISBN
	li $s4, 1
 	jal fazer_busca_no_repositorio
 	
 	# Avancamos ate quantidade_disponivel
 	jal avancar_ate_virgula    # Avanca os bytes que contem o isbn
 	jal avancar_ate_virgula    # Avanca os byte que contem o titulo
 	jal avancar_ate_virgula    # Avanca os bytes que contem o autor
 	jal avancar_ate_virgula    # Avanca os byts que contem quantidade_total
 	
 	# pula para a funcao que obtem e converte quantidade_disponivel para 
 	# inteiro, para que logo em seguida o seu valor seja atualizado 
 	jal obter_conveter_qtd_disponivel_para_int
 	jal atualizar_qtd_disponivel_para_mais
	addi $s1, $s1, 1      # Avanca para o proximo endereco (por causa da virgula entre os atributos)
	
	# Agora vamos obter o valor inteiro de quantidade_emprestado e atualizar ele em repo_livro
	jal obter_conveter_qtd_emprestados_para_int
	jal atualizar_qtd_emprestados_para_menos
	
	lw $ra, 0($sp) 		   # Resgata o $ra original do $sp
    addi $sp, $sp, 4	   # Devolve a pilha para a posicao original
    jr $ra

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
	lb $t4, ($t3)             # carrega o byte de t3
	addi $t3, $t3, 1          # Incrementa $t3
	addi $t2, $t2, 1          # Incrementa $t2
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
	
	li $v0, 16 
	move $a0, $s0
	syscall # chama o syscall 16 para fechar o descritor do arquivo
	
	# Limpa o buffer de comando
	la $s1, comando
	jal clear_buffer
	
	lw $ra, 0($sp) 		# Resgata o $ra original do $sp
    addi $sp, $sp, 4	# Devolve a pilha para a posicao original
	
	jr $ra
	
formatar_dados:
    # Limpa o repositório de livros
    la   $s1, repo_livro
    jal  clear_buffer

    # Limpa o repositório de usuários
    la   $s1, repo_usuario
    jal  clear_buffer

    # Limpa o repositório de empréstimos
    la   $s1, repo_emprestimo
    jal  clear_buffer

    # Limpa a variável data_config_usuario
    la   $s1, data_config_usuario
    jal  clear_buffer

    # Limpa a variável hora_config_usuario
    la   $s1, hora_config_usuario
    jal  clear_buffer

    # Salva os dados (os buffers já estão limpos, logo os arquivos serão atualizados com os dados vazios)
    jal  salvar_dados

    # Exibe "Dados Apagados"
    la   $t1, msgC_dados_apagados  
    jal  escrever_string_display
    
    # Limpa o buffer de comando
	la $s1, comando
	jal clear_buffer

j main
data_hora:
    la $t0, data_config_usuario   					# Carrega o endereco de data_config_usuario
    lb $t1, 0($t0)          						# Carrega o byte 
    beqz $t1, gerar_e_imprimir_data_hora_atual  	# Se o byte for 0, pula para a funcao que vai imprimir a data e hora atual
    
    # Caso contrario, entao o usuario armazenou a data e hora da configuradas por ele
    jal imprimir_data_hora_usuario
	
	j main
	
gerar_e_montar_data_atual:
	# $a3: reg que possui o endereco do buffer que irah ser amarzenada a string da data atual
	
	# Aloca espaco no $sp para salvar o endereco de $ra
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	jal gerar_data_atual  # Funcao que armazena o ano no $s0, o mes no $s1 e o dia no $s2

    move $t0, $s0  # Copia o ano para $t0
    move $t1, $s1  # Copia o mes para $t1
    move $t2, $s2  # Copia o dia para $t2
    
	move $t6, $a3         # Copia o endereco do buffer onde serah armazenada a data
	li $t5, 10            # inicializa $t5 com 10
	
	# Atualiza o $ra para que caso, a condicao abaixo seja verdadeira o fluxo do codigo
	# por meio do jr $ra do inserir_zero retorne volte para a linha:  move $t7, $t2 (6 linhas abaixo)                    
	addi $ra, $ra, 32
	
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
	
	lw $ra, 0($sp) 		# Resgata o $ra original do $sp
    addi $sp, $sp, 4	# Devolve a pilha para a posicao original
	
	jr $ra
	
gerar_e_imprimir_data_hora_atual:
	la $a3, data_atual              # carrega o endereco de data_atual 
	jal gerar_e_montar_data_atual   # pula para a funcao que vai gerar a data e montar ela no formato dd/mm/aaaa em $a3
	
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
   		
gerar_data_hora_atual_minutos:
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
    
    jr $ra  
   		 		
gerar_data_atual:
   	# Aloca espaco no $sp para salvar o endereco de $ra
    addi $sp, $sp, -4
    sw $ra, 0($sp)
	
	jal gerar_data_hora_atual_minutos

	lw $ra, 0($sp)         # Resgata o $ra original do $sp
    addi $sp, $sp, 4    # Devolve a pilha para a posicao original

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
    	bleu $t0, $t1, dia_do_mesU  # Se $t0 <= $t1, pula para a funcao que calcula o dia do mes 
    	subu $t0, $t0, $t1          # Remove os dias do mes de $s1 do total de dias decorridos
    	addiu $s1, $s1, 1           # Incrementa o mes
    	j mes_loopU

	dia_do_mesU:
    	move $s2, $t0        # Move os dias que restaram para $s2
    	jr $ra

gerar_hora_atual:
    # Aloca espaco no $sp para salvar o endereco de $ra
    addi $sp, $sp, -4
    sw $ra, 0($sp)
	
	jal gerar_data_hora_atual_minutos

	lw $ra, 0($sp)         # Resgata o $ra original do $sp
    addi $sp, $sp, 4    # Devolve a pilha para a posicao original

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
	subu $t1, $a1, $t1    # Subtrai a parte mais significativa 
	subu $t0, $a0, $t0,   # Subtrai a parte menos significativa
	
	# Conversao da parte menos significativa dos milissegundos para minutos
    li $t2, 60000      	  # Carrega em $t2 a quantidade de milissegundos em 1 minuto
    divu $t0, $t2         # Opera $t0 / 60000 (parte baixa para horas) 
    mflo $t0              # Move para $t0 as horas decorridas da menos significativa
	
    # Conversao da parte mais significativa de milissegundos para horas
    # A conversao eh feita com base na seguinte formula: $t1 * 2^32 / 60000
    li $t2, 71582         # Carrega 71582 em $t2 que eh o resultado aproximado (2^32) / 60000
    mulu $t1, $t1, $t2    # Multiplica 71582 com $t1 para obter as minutos decorridos com a parte mais significativa
	
	# Soma $t0 (quantidade de minutos decorridos da parte menos significativa)
    # com $t1 (quantidade de minutos decorridos da parte mais significativa)
    addu $t0, $t0, $t1
	
	blt $t0, 1, imprimir_data_tempo  # Se $t0, for menor que 1 minuto pula logo para a funcao que vai imprimir
	
	la $t1, hora_config_usuario    # Carrega o endereco de hora_config_usuario
	la $t2, buffer_aux_conversao   # Carrega o endereco de buffer_aux_conversao
	lb $t3, 3($t1)                 # Carrega primeiro byte que contem o minuto
	sb $t3, 0($t2)                 # Escreve o primeiro byte que contem o minuto em buffer_aux_conversao
	lb $t3, 4($t1)                 # Carrega segundo byte que contem o minuto
	sb $t3, 1($t2)                 # Escreve o segundo byte que contem o minuto em buffer_aux_conversao
	
	la $t2, buffer_aux_conversao    # Recarrega o endereco de buffer_aux_conversao
	jal converter_string_para_int   # Pula para a funcao que vai converter os minutos para inteiro
	
	addu $t0, $t0, $a0           # Soma os minutos configurados pelo usuario com os minutos decorridos
	
	# A linha abaixo verifica se o tempo em $t0 eh maior que 60 minutos 
	bge $t0, 60, ajustar_minutos      # Se o tempo em minutos for maior ou igual a 60 pula para a funcao que vai ajustar o tempo
	
	# Caso contrario, vamos converter o total de minutos para string
	la $s1, buffer_aux_conversao    # Recarregamos o endereco de buffer_aux_conversao
	jal clear_buffer                # Limpamos o buffer 
	move $t7, $t0                   # Copiamos o valor inteiro dos minutos de $t0 para $t7
	la $t6, buffer_aux_conversao    # Recarregamos buffer_aux_conversao em $t6
	jal converter_int_para_string   # Pulamos para a funcao que vai converter os minutos para string 
	la $t2, buffer_aux_conversao    # Recarregamos buffer_aux_conversao em $t2
	jal descobrir_qtd_digitos       # Pulamos para a funcao que descobre a quantidade de digitos (bytes) em buffer_aux_conversao
	beq $s7, 1, inserir_caractere0_em_buffer_aux   # Se a qtd de digitos for igual a 1 chama a funcao que insere o caractere 0 
	
	# Agora vamos atualizar os bytes que contem os minutos
	la $t0, buffer_aux_conversao    # Recarregamos buffer_aux_conversao em $t0
	lb $t2, 0($t0)                  # Carregamos o primeiro byte dos minutos
 	sb $t2, 3($t1)                  # sobrescrevemos o primeiro byte dos minutos em hora_config_usuario 
 	addi $t0, $t0, 1                # Avancamos para o proximo byte a ser inserido
 	lb $t2, 0($t0)                  # Carregamos o segundo byte dos minutos
 	sb $t2, 4($t1)                  # sobrescrevemos o segundo byte dos minutos em hora_config_usuario 
	j imprimir_data_tempo           # por fim Pulamos para a impressao da data e tempo
	
	ajustar_minutos:
		li $t1, 60      # Carrega $t1 com 60
		divu $t0, $t1   # Opera o tempo de corrido em minutos / 60
		mflo $t1        # Move para $t1 o quociente (horas decorridas)
		mfhi $t9        # move para $t2 o resto     (minutos restantes)
		
		la $t1, hora_config_usuario     # Carregamos o endereco de hora_config_usuario
		la $t2, buffer_aux_conversao    # Carregamos o endereco de buffer_aux_conversao
		lb $t3, 0($t1)                  # Carregamos primeiro byte que contem a hora
		sb $t3, 0($t2)                  # Escrevemos o primeiro byte que contem o minuto em buffer_aux_conversao
		lb $t3, 1($t1)                  # Carregamos segundo byte que contem o minuto
		sb $t3, 1($t1)                  # Escrevemos o segundo byte que contem o minuto em buffer_aux_conversao
		
		la $t2, buffer_aux_conversao    # Recarrega o endereco de buffer_aux_conversao
		jal converter_string_para_int   # Pula para a funcao que vai converter os minutos para inteiro
		
		addu $t0, $a0, $t1              # Soma a hora configurada pelo usuario com as horas decorridas
		bge $t0, 24, ajustar_hora       # Verifica se o total de horas eh maior que 24 horas
		
		# Caso contrario, vamos converter o total de horas para string
		la $s1, buffer_aux_conversao    # Caso contrario, Recarregamos o endereco de buffer_aux_conversao
		jal clear_buffer                # Limpamos o buffer 
		move $t7, $t0                   # Copiamos o valor inteiro do total de horas de $t0 para $t7
		la $t6, buffer_aux_conversao    # Recarregamos buffer_aux_conversao em $t6
		jal converter_int_para_string   # Pulamos para a funcao que vai converter as horas para string 
		la $t2, buffer_aux_conversao    # Recarregamos buffer_aux_conversao em $t2
		jal descobrir_qtd_digitos       # Pulamos para a funcao que descobre a quantidade de digitos (bytes) em buffer_aux_conversao
		beq $s7, 1, inserir_caractere0_em_buffer_aux   # Se a qtd de digitos for igual a 1 chama a funcao que insere o caractere 0 
		
		# Agora vamos atualizar os bytes que contem as horas
		la $t0, buffer_aux_conversao    # Recarregamos buffer_aux_conversao em $t0
		lb $t2, 0($t0)                  # Carregamos o primeiro byte dos minutos
 		sb $t2, 0($t1)                  # sobrescrevemos o primeiro byte dos minutos em hora_config_usuario 
 		addi $t0, $t0, 1                # Avancamos para o proximo byte a ser inserido
 		lb $t2, 0($t0)                  # Carregamos o segundo byte dos minutos
 		sb $t2, 1($t1)                  # sobrescrevemos o segundo byte dos minutos em hora_config_usuario 
		j imprimir_data_tempo           # por fim Pulamos para a impressao da data e tempo
		
		# Agora vamos converter o minutos para string
		la $s1, buffer_aux_conversao    # Caso contrario, Recarregamos o endereco de buffer_aux_conversao
		jal clear_buffer                # Limpamos o buffer 
		move $t7, $t9                   # Copiamos o valor inteiro dos minutos de $t9 para $t7
		la $t6, buffer_aux_conversao    # Recarregamos buffer_aux_conversao em $t6
		jal converter_int_para_string   # Pulamos para a funcao que vai converter os minutos para string 
		la $t2, buffer_aux_conversao    # Recarregamos buffer_aux_conversao em $t2
		jal descobrir_qtd_digitos       # Pulamos para a funcao que descobre a quantidade de digitos (bytes) em buffer_aux_conversao
		beq $s7, 1, inserir_caractere0_em_buffer_aux   # Se a qtd de digitos for igual a 1 chama a funcao que insere o caractere 0 
	
		# Agora vamos atualizar os bytes que contem os minutos
		la $t0, buffer_aux_conversao    # Recarregamos buffer_aux_conversao em $t0
		lb $t2, 0($t0)                  # Carregamos o primeiro byte dos minutos
 		sb $t2, 3($t1)                  # sobrescrevemos o primeiro byte dos minutos em hora_config_usuario 
 		addi $t0, $t0, 1                # Avancamos para o proximo byte a ser inserido
 		lb $t2, 0($t0)                  # Carregamos o segundo byte dos minutos
 		sb $t2, 4($t1)                  # sobrescrevemos o segundo byte dos minutos em hora_config_usuario 
		j imprimir_data_tempo           # por fim Pulamos para a impressao da data e tempo
		
		ajustar_hora:
			li $t1, 24     # Carrega $t1 com 24
			divu $t0, $t1  # Opera o tempo de corrido em horas / 24
			mfhi $t4       # Move o quociente para $t4 (horas restantes)
			
			la $t1, hora_config_usuario  # Carrega o endereco de hora_config_usuario
			
			# vamos agora converter o total de horas para string
			la $s1, buffer_aux_conversao    # Caso contrario, Recarregamos o endereco de buffer_aux_conversao
			jal clear_buffer                # Limpamos o buffer 
			move $t7, $t4                   # Copiamos o valor inteiro do total de horas de $t0 para $t7
			la $t6, buffer_aux_conversao    # Recarregamos buffer_aux_conversao em $t6
			jal converter_int_para_string   # Pulamos para a funcao que vai converter as horas para string 
			la $t2, buffer_aux_conversao    # Recarregamos buffer_aux_conversao em $t2
			jal descobrir_qtd_digitos       # Pulamos para a funcao que descobre a quantidade de digitos (bytes) em buffer_aux_conversao
			beq $s7, 1, inserir_caractere0_em_buffer_aux   # Se a qtd de digitos for igual a 1 chama a funcao que insere o caractere 0 
		
			# Agora vamos atualizar os bytes que contem as horas
			la $t0, buffer_aux_conversao    # Recarregamos buffer_aux_conversao em $t0
			lb $t2, 0($t0)                  # Carregamos o primeiro byte dos minutos
 			sb $t2, 0($t1)                  # sobrescrevemos o primeiro byte dos minutos em hora_config_usuario 
 			addi $t0, $t0, 1                # Avancamos para o proximo byte a ser inserido
 			lb $t2, 0($t0)                  # Carregamos o segundo byte dos minutos
 			sb $t2, 1($t1)                  # sobrescrevemos o segundo byte dos minutos em hora_config_usuario 
			j imprimir_data_tempo           # por fim Pulamos para a impressao da data e tempo
		
			# Agora vamos converter o minutos para string
			la $s1, buffer_aux_conversao    # Caso contrario, Recarregamos o endereco de buffer_aux_conversao
			jal clear_buffer                # Limpamos o buffer 
			move $t7, $t9                   # Copiamos o valor inteiro dos minutos de $t9 para $t7
			la $t6, buffer_aux_conversao    # Recarregamos buffer_aux_conversao em $t6
			jal converter_int_para_string   # Pulamos para a funcao que vai converter os minutos para string 
			la $t2, buffer_aux_conversao    # Recarregamos buffer_aux_conversao em $t2
			jal descobrir_qtd_digitos       # Pulamos para a funcao que descobre a quantidade de digitos (bytes) em buffer_aux_conversao
			beq $s7, 1, inserir_caractere0_em_buffer_aux   # Se a qtd de digitos for igual a 1 chama a funcao que insere o caractere 0 
	
			# Agora vamos atualizar os bytes que contem os minutos
			la $t0, buffer_aux_conversao    # Recarregamos buffer_aux_conversao em $t0
			lb $t2, 0($t0)                  # Carregamos o primeiro byte dos minutos
 			sb $t2, 3($t1)                  # sobrescrevemos o primeiro byte dos minutos em hora_config_usuario 
 			addi $t0, $t0, 1                # Avancamos para o proximo byte a ser inserido
 			lb $t2, 0($t0)                  # Carregamos o segundo byte dos minutos
 			sb $t2, 4($t1)                  # sobrescrevemos o segundo byte dos minutos em hora_config_usuario 
			j imprimir_data_tempo           # por fim Pulamos para a impressao da data e tempo
			
			# Por fim vamos atualizar a data
			la $t1, data_config_usuario  # Carrega o endereco de data_config_usuario
			lb $t2, 0($t1)               # Carrega o byte de dias em data_config_usuario
			addiu $t5, $t2, 1            # Soma a quantidade de dias da data configurada com 1
			sb  $t5, 0($t1)    			 # Sobrescreve o byte de dias em data_config_usuario
			
			# Nao irei me dar ao trabalho de verificar se o dia, mes e ano sao validos, apos essa soma de dias, 
			# seria muito custoso ter que fazer tudo isso ja que os dados da data e hora configurados pelo usuario 
			# nao sao salvos em arquivos .txt.
			
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
	
	addi $s0, $s0, 3    # Avanca 3 caracteres
	lb $t2, 0($s0)      # Carrega o caractere
	bne  $t2, $t1, escrever_formato_data_hora_incorreto_display  # verifica novamente
	
	# Caso esteja tudo nos conformes, volta o $s0 para a sua posicao anterior a essas 2 verificacoes
	subi $s0, $s0, 6
	
	la $t1, data_config_usuario   # Carrega o endereco de data_config_usuario  
	jal guardar_info_buffer  	  # Pula para a funcao que pega o que estah entre aspas e salva no data_config_usuario
	
	# Vamos por fim verificar se a data armazenada eh uma data valida
	la $t1, data_config_usuario   # Carrega o endereco de data_config_usuario
	jal validar_data              # Funcao que vai validar a data digitada 
	
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
	
	# Vamos agora verifica se a data eh uma hora valida
	la $t1, hora_config_usuario   # Carrega o endereco de hora_config_usuario
	jal validar_hora              # Funcao que vai validar a hora digitada
	
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

descobrir_qtd_digitos:
	# $t2: reg que possui o endereco do buffer a ser analizado: 
	move $t3, $t2
	
	li $s7, 0   # Inicializa $s7 com 0 (reg que servirah como contador de digitos)
	  
	loop_qtd_digitos:
		lb $t4 0($t3)   # Carrega o byte em $t4
		beqz  $t4, fim_loop_qtd_digitos    # se o byte em $t4 for o byte o nulo o loop eh encerrado
		beq $t4, 44, fim_loop_qtd_digitos  # se o byte em $t4 for o byte 44 (caractere de virgula) o loop tamb�m eh encerrado
		addi $t3, $t3, 1      # Avanca para o proximo caractere 
		addi $s7, $s7, 1      # Incrementa $s7
		j loop_qtd_digitos    # Entra em loop
		
	fim_loop_qtd_digitos:
		jr $ra

mult_por_10_x_vezes:
	# $s6: reg que possui a quantidade de vezes que o loop abaixo tem que repetir 
	# $t3: reg que possui o inteiro a ser multiplicado por 10
	
	move $t0, $s6   # Caso contrario copia a quantidade de $s6 para $t0
	li $t8, 10      # Inicializa $t2 com 10
	 
	loop_multi_10_x_vezes: 
		beqz $t0, fim_loop_multi_10_x_vezes  # Quando $t0 for 0, o loop e encerrado 
		mult $t3, $t8                        # Opera a multiplicacao
		mflo $t3                             # Move o resultado da multiplicacao para $t3
		subi $t0, $t0, 1                     # Decrementa $t0
		j loop_multi_10_x_vezes              # Entra em loop
		
	fim_loop_multi_10_x_vezes:
		jr $ra  
	
converter_string_para_int:
	# $t2: reg que possui o endereco de buffer_aux_conversao contendo a string a ser convertida para inteiro
	
	# Aloca espaco no $sp para salvar o endereco de $ra
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
	jal descobrir_qtd_digitos     # Pula para a funcao que varre $t2 para decobrir a quantidade de digitos que o seu valor inteiro deve ter
	move $s6, $s7                 # Copia a quantidade de digitos a string para $s6
	subi $s6, $s6, 1              # Decrementa $s6 com 1 
	li $a0, 0                     # Inicializa $s0 com 0  
	addi $ra, $ra, 36             # Incrementa o $ra para que por meio do jr $ra de mult_por_10_x_vezes volte para a linha add $s0, $s0, $t3
	
	loop_conversao_string_int:
		lb $t3, 0($t2)           # Carrega o byte de $t2
		subi $t3, $t3, 48       # Converte o byte de char para int
		bnez $s6, mult_por_10_x_vezes    # Se $s6 for diferente de 0 chama a funcao que multiplica o valor de $t3 por 10 pela qtd em $s6
		add $a0, $a0, $t3       # Soma o valor de $s0 com $t3
		addi $t2, $t2, 1        # Avanca para o proximo byte a ser convertido
		subi $s6, $s6, 1        # Decrementa o valor de $s6 
		subi $s7, $s7, 1        # Decrementa o valor de $s7
		beqz $s7, fim_conversao_string_int   # Se $s7, seja 0 o loop encerra
		j loop_conversao_string_int         # Caso contrario, entra em loop
	
	fim_conversao_string_int:
		# Apos o fim da conversao $s0 contera o valor da string de $t2 convertido para int 
		lw $ra, 0($sp) 		   # Resgata o $ra original do $sp
    	addi $sp, $sp, 4	   # Devolve a pilha para a posicao original
		jr $ra

validar_data:
	# $t1: reg que possui o endereco da data configurada pelo usuario
	
	# Aloca espaco no $sp para salvar o endereco de $ra
    addi $sp, $sp, -4
    sw $ra, 0($sp)
	
	# O trecho abaixo carrega e armazena os bytes correspondente ao dia e armazena em buffer_aux_conversao
	la $t2, buffer_aux_conversao  # Carrega o endereco de buffer_aux_conversao
	lb $t3, 0($t1)     # Carrega o byte de $t1 
	sb $t3, 0($t2)     # Armazena o byte em $t2
	
	addi $t1, $t1, 1   # Avanca um caractere
	addi $t2, $t2, 1   # Avanca um caractere
	
	lb $t3, 0($t1)     # Carrega o byte de $t1 
	sb $t3, 0($t2)     # Armazena o byte em $t2
	subi $t2, $t2, 1   # Retorna um caractere
	
	jal converter_string_para_int   # Pula para a funcao que converte os caracteres do dia para int
	move $s1, $a0                   # Copia o valor inteiro convertido de $s0 para $s1
	
	# Verifica se o valor do dia eh maior do que 31 e menor que 0
	bgt $s1, 31, escrever_data_invalida_display_display    # Se for maior que 31 escreve data invalida
	bltz $s1, escrever_data_invalida_display_display       # se for menor que 0 tambem escreve data invalida
	
	# Agora vamos validar o valor digitado para o mes
	# Agora vamos validar o valor digitado para o mes
	addi $t1, $t1, 2   # Avanca 2 caracteres em t1 (para ignorar o caractere de barra)
	subi $t2, $t2, 2   # Retorna dois caracteres em $t2 (para que os valores do mes sobrescrevam os valores do dias)
	
	lb $t3, 0($t1)     # Carrega o byte de $t1 
	sb $t3, 0($t2)     # Armazena o byte em $t2
	
	addi $t1, $t1, 1   # Avanca um caractere
	addi $t2, $t2, 1   # Avanca um caractere
	
	lb $t3, 0($t1)     # Carrega o byte de $t1 
	sb $t3, 0($t2)     # Armazena o byte em $t2
	subi $t2, $t2, 1   # retorna um caractere
	
	jal converter_string_para_int   # Pula para a funcao que converte os caracteres do mes para int
	move $s2, $a0          # Copia o valor inteiro convertido de $s0 para $s2
	
	# Verifica se o valor do mes eh maior do que 12 e menor que 0
	bgt $s2, 12, escrever_data_invalida_display_display    # Se for maior que 12 escreve data invalida
	bltz $s2, escrever_data_invalida_display_display       # se for menor que 0 tambem escreve data invalida
	
	# Agora vamos converter o valor digitado para o ano
	addi $t1, $t1, 2   # Avanca dois caracteres em t1 
	subi $t2, $t2, 2   # Retorna dois caracteres em $t2 (para que os valores do ano sobrescrevam os valores do mes)
	
	loop_armazenar_ano:
		lb $t3, 0($t1)        # Carrega o byte de $t1 
		beqz $t3, fim_loop_armazenar_ano     # se o valor de $t3 for o byte nulo o loop eh encerrado 
		beq $t3, 10, fim_loop_armazenar_ano  # Se o valor de $t3 for igual a byte de quebra linha o loop tbm eh encerrado 
		sb $t3, 0($t2)        # Armazena o byte em $t2
		addi $t1, $t1, 1      # Avanca um caractere
		addi $t2, $t2, 1      # Avanca um caractere
		j loop_armazenar_ano  # Entra em loop
	
	fim_loop_armazenar_ano:
	la $t2, buffer_aux_conversao     # Recarrega o endereco inicial de data_config_usuario em $t2
	jal converter_string_para_int   # Pula para a funcao que converte os caracteres do ano para int
	move $s3, $a0          # Copia o valor inteiro convertido de $s0 para $s2
	
	# Vamos agora verificar se o usuario colocou a data dia 29 de fevereiro em um ano nao bissexto
	jal verificar_29_fevereiro   # Funcao que faz essa verificacao
	
	# Vamos verificar agr se o valor digitado para o dia foi 31 em um mes que tem somente 30 dias
	jal verificar_mes_com_31 
	
	# Limpa o buffer auxiliar
	la $s1, buffer_aux_conversao
	jal clear_buffer
	
	lw $ra, 0($sp) 		   # Resgata o $ra original do $sp
    addi $sp, $sp, 4	   # Devolve a pilha para a posicao original
	
	jr $ra

verificar_29_fevereiro:
	li $t9, 29       # Inicializa $t9 com 29
	beq $s1, $t9, continuar_verificacao_fevereiro1   # Verifica se o dia eh 29
	j encerrar_verificacao_fevereiro    # Caso nao seja nos pulamos a verificacao
	
	continuar_verificacao_fevereiro1:
		li $t9, 2      # Inicializa $t9 com 2
		beq $s2, 2, continuar_verificacao_fevereiro2   # Verifica se o mes eh feveireiro
		j encerrar_verificacao_fevereiro    # Caso nao seja nos pulamos a verificacao
	
	continuar_verificacao_fevereiro2:	
		li $t7, 4            # Inicializa $t2 com 4
    	rem $t3, $s3, $t7    # Armazena o resto da divisao de $s0 com $t7 
		bnez $t3, escrever_data_invalida_display_display   # Se o resto da divisao nao for 0 significa que o ano nao eh bisexto
	
	encerrar_verificacao_fevereiro:
		jr $ra
		
verificar_mes_com_31:
	beq $s1, 31, continuar_verificacao_31   # Verifica se o dia eh 31
	j encerrar_verificacao_mes_31    # Caso nao seja nos pulamos a verificacao
	
	continuar_verificacao_31:
		beq $s2, 2, escrever_data_invalida_display_display    # Verifica se o mes eh feveireiro
		beq $s2, 4, escrever_data_invalida_display_display    # Verifica se o mes eh abril
		beq $s2, 6, escrever_data_invalida_display_display    # Verifica se o mes eh junho
		beq $s2, 9, escrever_data_invalida_display_display    # Verifica se o mes eh setembro
		beq $s2, 11, escrever_data_invalida_display_display   # Verifica se o mes eh novembro
	
	encerrar_verificacao_mes_31:
		jr $ra
	
validar_hora:
	# $t1: reg que possui o endereco da hors configurada pelo usuario
	
	# Aloca espaco no $sp para salvar o endereco de $ra
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    # O trecho abaixo carrega e armazena os bytes correspondente a hora e armazena em buffer_aux_conversao
	la $t2, buffer_aux_conversao  # Carrega o endereco de buffer_aux_conversao
	lb $t3, 0($t1)     # Carrega o byte de $t1 
	sb $t3, 0($t2)     # Armazena o byte em $t2
	
	addi $t1, $t1, 1   # Avanca um caractere
	addi $t2, $t2, 1   # Avanca um caractere
	
	lb $t3, 0($t1)     # Carrega o byte de $t1 
	sb $t3, 0($t2)     # Armazena o byte em $t2
	subi $t2, $t2, 1   # retorna um caractere
	
	jal converter_string_para_int   # Pula para a funcao que converte os caracteres da hora para int
	move $s1, $a0                   # Copia o valor inteiro convertido de $s0 para $s1
	
	# Verifica se o valor da hora eh maior do que 23 e menor que 0
	bgt $s1, 23, escrever_hora_invalida_display_display    # Se for maior que 23 escreve hora invalida
	bltz $s1, escrever_hora_invalida_display_display       # se for menor que 0 tambem escreve hora invalida
	
	# Agora vamos validar o valor digitado para minutos
	addi $t1, $t1, 2   # Avanca um caractere em t1 (para ignorar o caractere de barra)
	subi $t2, $t2, 2   # Retorna dois caracteres em $t2 (para que os valores do mes sobrescrevam os valores das horas)
	
	lb $t3, 0($t1)     # Carrega o byte de $t1 
	sb $t3, 0($t2)     # Armazena o byte em $t2
	
	addi $t1, $t1, 1   # Avanca um caractere
	addi $t2, $t2, 1   # Avanca um caractere
	
	lb $t3, 0($t1)     # Carrega o byte de $t1 
	sb $t3, 0($t2)     # Armazena o byte em $t2
	subi $t2, $t2, 1   # retorna um caractere
	
	jal converter_string_para_int   # Pula para a funcao que converte os caracteres dos minutos para int
	move $s2, $a0                   # Copia o valor inteiro convertido de $s0 para $s2
	
	# Verifica se o valor do minuto eh maior do que 59 e menor que 0
	bgt $s2, 59, escrever_hora_invalida_display_display    # Se for maior que 59 escreve hora invalida
	bltz $s2, escrever_hora_invalida_display_display       # se for menor que 0 tambem escreve hora invalida
    
    lw $ra, 0($sp) 		   # Resgata o $ra original do $sp
    addi $sp, $sp, 4	   # Devolve a pilha para a posicao original
	jr $ra
	
ler_dados:
    # Aloca espaco no $sp para salvar o endereco de $ra
    addi $sp, $sp, -4
    sw $ra, 0($sp)
	 
    la $a0, local_arquivo_livros       # Carrega o caminho do arquivo de livros
    la $a1, repo_livro                 # Carrega o endereco do repositorio onde os dados serao carregados
    li $a2, 4500
    jal ler_dados_do_arquivo           # Chama a funcao generica para leitura do arquivo

    la $a0, local_arquivo_usuario      # Carrega o caminho do arquivo de usuarios
    la $a1, repo_usuario               # Carrega o endereco do repositorio onde os dados serao carregados
    li $a2, 4500
    jal ler_dados_do_arquivo           # Chama a funcao generica para leitura do arquivo

    la $a0, local_arquivo_emprestimo   # Carrega o caminho do arquivo de emprestimos
    la $a1, repo_emprestimo            # Carrega o endereco do repositorio onde os dados serao carregados
    li $a2, 4500
    jal ler_dados_do_arquivo           # Chama a funcao generica para leitura do arquivo
	
	lw $ra, 0($sp) 		   # Resgata o $ra original do $sp
    addi $sp, $sp, 4	   # Devolve a pilha para a posicao original
	
    jr $ra

ler_dados_do_arquivo:
	# $a0: Reg que possui o endereco do nome do arquivo
	# $a1: Reg que possui o endereco do buffer de destino 
	# $a2: Reg que possui o tamanho maximo do buffer
	
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

    # Le o conteudo do arquivo
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
		
	la $s1, quantidade_total   # Carrega o endereco de quantidade
	jal clear_buffer     # Limpa o buffer de quantidade
	
	la $s1, quantidade_disponivel
	jal clear_buffer     # Limpa o buffer de quantidade_disponiveis
	
	la $s1, quantidade_emprestado
	jal clear_buffer     # Limpa o buffer de quantidade_emprestado
	
	la $s1, nome         # Carrega o endereco de nome
	jal clear_buffer     # Limpa o buffer de nome
		
	la $s1, matricula    # Carrega o endereco de matricula
	jal clear_buffer     # Limpa o buffer de matricula
		
	la $s1, curso        # Carrega o endereco de curso
	jal clear_buffer     # Limpa o buffer de curso
		
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
    jal escrever_barra_n_display    # Pula para a funcao que ira imprimir uma quebra de linha no display   
    jal limpar_todos_buffers_das_entidades
    j main   
	
escrever_acervo_vazio_display:
    la $t1, msgE_acervo_vazio       # Carrega o endereco de msgE_acervo_vazio
    jal escrever_string_display     # Pula para a funcao generica que ira imprimir a string armazenada em $t1
    jal escrever_barra_n_display    # Pula para a funcao que ira imprimir uma quebra de linha no display
    jal limpar_todos_buffers_das_entidades
    j main   

escrever_esprestimo_indisponivel_display:
    la $t1, msgE_esprestimo_indisponivel   # Carrega o endereco de msgE_comando_invalido
    jal escrever_string_display            # Pula para a funcao generica que ira imprimir a string armazenada em $t1
    jal escrever_barra_n_display           # Pula para a funcao que ira imprimir uma quebra de linha no display
    jal limpar_todos_buffers_das_entidades 
    j main   

escrever_relatorio_indisponivel_display:
    la $t1, msgE_relatorio_indisponivel   # Carrega o endereco de msgE_relatorio_indisponivel
    jal escrever_string_display           # Pula para a funcao generica que ira imprimir a string armazenada em $t1
    jal escrever_barra_n_display    	  # Pula para a funcao que ira imprimir uma quebra de linha no display
    j main   
    
escrever_livro_nao_encontrado_display:
    la $t1, msgE_livro_nao_encontrado   # Carrega o endereco de msgE_livro_nao_encontrado 
    jal escrever_string_display         # Pula para a funcao generica que ira imprimir a string armazenada em $t1
    jal escrever_barra_n_display    	# Pula para a funcao que ira imprimir uma quebra de linha no display
    jal limpar_todos_buffers_das_entidades
    j main   

escrever_livro_esta_emprestado_display:
    la $t1, msgE_livro_esta_emprestado   # Carrega o endereco de msgE_livro_esta_emprestado
    jal escrever_string_display          # Pula para a funcao generica que ira imprimir a string armazenada em $t1
    jal escrever_barra_n_display    	 # Pula para a funcao que ira imprimir uma quebra de linha no display
	jal limpar_todos_buffers_das_entidades   
    j main   
    
escrever_usuario_nao_encontrado_display:
    la $t1, msgE_usuario_nao_encontrado   # Carrega o endereco de msgE_usuario_nao_encontrado
    jal escrever_string_display           # Pula para a funcao generica que ira imprimir a string armazenada em $t1
    jal escrever_barra_n_display    	  # Pula para a funcao que ira imprimir uma quebra de linha no display
    jal limpar_todos_buffers_das_entidades
    j main   
    
escrever_usuario_tem_pendencias_display:
    la $t1, msgE_usuario_tem_pendencias   # Carrega o endereco de msgE_usuario_tem_pendencias
    jal escrever_string_display           # Pula para a funcao generica que ira imprimir a string armazenada em $t1
    jal escrever_barra_n_display    	  # Pula para a funcao que ira imprimir uma quebra de linha no display
    jal limpar_todos_buffers_das_entidades
    j main   
    
escrever_formato_data_hora_incorreto_display:
    la $t1, msgE_data_hora_mal_formatada  # Carrega o endereco de msgE_data_hora_mal_formatada
    jal escrever_string_display           # Pula para a funcao generica que ira imprimir a string armazenada em $t1
    jal escrever_barra_n_display    	  # Pula para a funcao que ira imprimir uma quebra de linha no display
    la $s1, data_config_usuario      # Limpa o buffer de data_config usuario
    jal clear_buffer
    la $s1, data_registro	         # Limpa o buffer de data_registro	
	jal clear_buffer	
    
    j main   
    
escrever_livro_ja_cadastrado_display:
	la $t1, msgE_operacao_cadastro_invalida    # Carrega o endereco de operacao_cadastro_invalida
	jal escrever_string_display                # Pula para a funcao generica que ira imprimir a string armazenada em $t1
	la $t1, msgE_livro_ja_cadastrado           # Carrega o endereco de livro_ja_cadastrado 
	jal escrever_string_display
	jal escrever_barra_n_display    # Pula para a funcao que ira imprimir uma quebra de linha no display
	j main

escrever_usuario_ja_cadastrado_display:
	la $t1, msgE_operacao_cadastro_invalida    # Carrega o endereco de operacao_cadastro_invalida
	jal escrever_string_display                # Pula para a funcao generica que ira imprimir a string armazenada em $t1
	la $t1, msgE_usuario_ja_cadastrado         # Carrega o endereco de usuario_ja_cadastrado 
	jal escrever_string_display
	jal escrever_barra_n_display    # Pula para a funcao que ira imprimir uma quebra de linha no display
	j main
	
escrever_usuario_ja_possui_emprestimo_livro_display:
	la $t1, msgE_operacao_cadastro_invalida    # Carrega o endereco de operacao_cadastro_invalida
	jal escrever_string_display                # Pula para a funcao generica que ira imprimir a string armazenada em $t1
	la $t1, msgE_usuario_ja_possui_emprestimo_livro         # Carrega o endereco de usuario_ja_cadastrado 
	jal escrever_string_display
	jal escrever_barra_n_display    # Pula para a funcao que ira imprimir uma quebra de linha no display
	j main	
	
escrever_data_invalida_display_display:
    la $t1, msgE_data_invalida       # Carrega o endereco de msgE_data_invalida
    jal escrever_string_display      # Pula para a funcao generica que ira imprimir a string armazenada em $t1
    jal escrever_barra_n_display     # Pula para a funcao que ira imprimir uma quebra de linha no display
    la $s1, data_config_usuario      # Limpa o buffer de data_config usuario
    jal clear_buffer
    la $s1, data_registro	         # Limpa o buffer de data_registro	
	jal clear_buffer
    j main 
    
escrever_hora_invalida_display_display:
    la $t1, msgE_hora_invalida       # Carrega o endereco de msgE_hora_invalida
    jal escrever_string_display      # Pula para a funcao generica que ira imprimir a string armazenada em $t1
    jal escrever_barra_n_display     # Pula para a funcao que ira imprimir uma quebra de linha no display
    la $s1, data_config_usuario      # Limpa o buffer de data_config usuario
    jal clear_buffer
    la $s1, data_registro	         # Limpa o buffer de data_registro
	jal clear_buffer
    j main 

escrever_emprestimo_nao_encontrado_display:
    la $t1, msgE_emprestimo_nao_encontrado  # Carrega o endereco de msgE_hora_invalida
    jal escrever_string_display      		# Pula para a funcao generica que ira imprimir a string armazenada em $t1
    jal escrever_barra_n_display    	    # Pula para a funcao que ira imprimir uma quebra de linha no display
    jal limpar_todos_buffers_das_entidades
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
    jal escrever_barra_n_display    	  # Pula para a funcao que ira imprimir uma quebra de linha no display
    jal limpar_todos_buffers_das_entidades
    j main   
	
escrever_falta_argumento_autor_display:
	la $s1, arg_autor  # Carrega o endereco arg_autor
	jal escrever_falta_argumento_obrigatorio_display
    jal escrever_barra_n_display    	  # Pula para a funcao que ira imprimir uma quebra de linha no display
    jal limpar_todos_buffers_das_entidades
    j main   
	
escrever_falta_argumento_ISBN_display:
	la $s1, arg_ISBN  # Carrega o endereco arg_ISBN
	jal escrever_falta_argumento_obrigatorio_display
    jal escrever_barra_n_display    # Pula para a funcao que ira imprimir uma quebra de linha no display
    jal limpar_todos_buffers_das_entidades
    j main   
	
escrever_falta_argumento_quantidade_display:
	la $s1, arg_quantidade  # Carrega o endereco arg_quantidade 
	jal escrever_falta_argumento_obrigatorio_display
    jal escrever_barra_n_display    # Pula para a funcao que ira imprimir uma quebra de linha no display
    jal limpar_todos_buffers_das_entidades
    j main   
	
escrever_falta_argumento_nome_display:
	la $s1, arg_nome  # Carrega o endereco arg_nome
	jal escrever_falta_argumento_obrigatorio_display
    jal escrever_barra_n_display    # Pula para a funcao que ira imprimir uma quebra de linha no display
    jal limpar_todos_buffers_das_entidades
    j main   
	
escrever_falta_argumento_matricula_display:
	la $s1, arg_matricula  # Carrega o endereco arg_matricula
	jal escrever_falta_argumento_obrigatorio_display
    jal escrever_barra_n_display    # Pula para a funcao que ira imprimir uma quebra de linha no display
    jal limpar_todos_buffers_das_entidades
    j main   
	
escrever_falta_argumento_curso_display:
	la $s1, arg_curso  # Carrega o endereco arg_curso
	jal escrever_falta_argumento_obrigatorio_display
    jal escrever_barra_n_display    # Pula para a funcao que ira imprimir uma quebra de linha no display
    jal limpar_todos_buffers_das_entidades
    j main   
	
escrever_falta_argumento_devolucao_display:
	la $s1, arg_devolucao  # Carrega o endereco arg_devolucao
	jal escrever_falta_argumento_obrigatorio_display
    jal escrever_barra_n_display    # Pula para a funcao que ira imprimir uma quebra de linha no display
    jal limpar_todos_buffers_das_entidades
    j main  
    
escrever_falta_argumento_data_display:
	la $s1, arg_data  # Carrega o endereco arg_data
	jal escrever_falta_argumento_obrigatorio_display
    jal escrever_barra_n_display    # Pula para a funcao que ira imprimir uma quebra de linha no display
    j main   
	 	     	            
escrever_falta_argumento_hora_display:
	la $s1, arg_hora  # Carrega o endereco arg_hora
	jal escrever_falta_argumento_obrigatorio_display
    jal escrever_barra_n_display    # Pula para a funcao que ira imprimir uma quebra de linha no display
    j main    

memcpy: # Copia uma quantidade num (a2) de caracteres de uma string do source (a1) para o destination (a0) 
        
	# Salvar os valores originais de $a0 e $a1 na pilha
	sub $sp, $sp, 8          # Cria espaco para dois valores de 4 bytes
    sw $a0, 0($sp)           # Salva $a0 na pilha
	sw $a1, 4($sp)           # Salva $a1 na pilha
		
	copia_memcpy:
      	beqz $a2, fim_copia_memcpy # Se o contador chegar a 0, finaliza
       	lb $t0, 0($a1) # Carrega o caractere atual para o t0
		sb $t0, 0($a0) # Guarda o caractere atual do t0 para o a0
			
		# Passa para o proximo byte da string
		addi $a1, $a1, 1 
		addi $a0, $a0, 1
			
		addi $a2, $a2, -1 # subtrai em 1 o contador
		j copia_memcpy
			
	fim_copia_memcpy:		
		# Restaura os valores originais de $a0 e $a1
        lw $a0, 0($sp)        # Restaura $a0 da pilha
        lw $a1, 4($sp)        # Restaura $a1 da pilha
        addi $sp, $sp, 8      # Desaloca o espaco usado na pilha
             		
		# Retorna da funcao
		jr $ra

calcula_entre_datas:
	# Recebe duas datas armazenadas nos registradores a seguir e calcula a quantidade
	# de dias que se passaram entre essas duas datas
	# $s2: dia inicial / $s1: mes inicial / $s0: ano inicial
	# $s5: dia final / $s4: mes final / $s3: ano final
	# Armazena em $t7 a diferença de dias entre as datas
		
	addi $sp, $sp, -4
  	sw $ra, 0($sp)
   	
   	# Move para registradores temporarios os valores do ano, mes e dia atual respectivamente
    move $t0, $s0
    move $t1, $s1
    move $t2, $s2
    
    jal calcula_dias_de_data 		# Calcula os dias que se passaram entre a data passada e 01/01/1970
    
    # Resgata a quantidade de dias adicionada no acumulador
    la $t6, acumulador
    lw $s6, 0($t6)		# Guarda a quantidade de dias calculado em $s6
   	sw $zero, 0($t6)	# Zera o conteúdo do acumulador
   	
   	# Move para registradores temporarios os valores do ano, mes e dia final respectivamente
    move $t0, $s3
    move $t1, $s4
    move $t2, $s5
    jal calcula_dias_de_data		# Calcula os dias que se passaram entre a data passada e 01/01/1970
   		
    # Calcula a diferença em dias das duas datas
    la $t6, acumulador		# Carrega o endereco do acumulador
   	lw $t7, 0($t6)			# Pega a quantidade de dias que estava em $t7
    subu $t7, $t7, $s6		# Faz a subtracao da (quantidade de dias passados ate a data final) - (quantidade de dias passados ate a data inicial)
    sw $t7, 0($t6)
    
    lw $ra, 0($sp)         # Resgata o $ra original do $sp
    addi $sp, $sp, 4    # Devolve a pilha para a posicao original
   	jr $ra

    	calcula_dias_de_data:
    		# Transforma uma data em dia usando como base 01/01/0000
    		# Usa $t0: ano, $t1: mes, $t2: dia
    		# Salva o resultado temporariamente em $s6
    		
    		addi $sp, $sp, -4
    		sw $ra, 0($sp)
    		
    		move $t4, $t0	# Coloca em $t4 o ano da data atual para poder calcular em cima dele
    		
    			loop_quantos_dias_anos_completos:
    			# Acumula os dias passados no anos que se passaram de 0 ate o que esta em $t4
    				subi $t4, $t4, 1				# Usa $t4 como contagem regressiva, do ano anterior ao atual ate 1970
    				beq $t4, 1969, loop_dias_passados_ano_atual
    				li $t5, 365				# Considera 365 a quantidade padrao de dias
    				li $t6, 4 				# Para fazer a divisao para calcular se o ano é bissexto
    				remu $t7, $t4, $t6  			# Armazena o resto da divisao de $s0 com $t2 como unsigned
    				beqz $t7, ano_bissexto_dias_anos_completos		# $t7 eh divisivel por 4, o ano eh bissexto
    				
    				# Adiciona a quantidade de dias no acumulador
    				la $t6, acumulador						# Carrega endereco do acumulador
    				lw $t7, 0($t6)							# Carrega o que esta no acumulador
    				add $t7, $t7, $t5						# Soma o que jah existe no acumulador com a quantidade de dias adicional
    				sw $t7, 0($t6)							# Guarda a soma no acumulador
    				j loop_quantos_dias_anos_completos	# Volta para o loop
    				
    				ano_bissexto_dias_anos_completos:
    					li $t5, 366		# Se o ano for bissexto a quantidade de dias acumulados eh 366
    					# Adiciona a quantidade de dias no acumulador
    					la $t6, acumulador
    					lw $t7, 0($t6)
    					add $t7, $t7, $t5
    					sw $t7, 0($t6)
    					j loop_quantos_dias_anos_completos
    			
    			loop_dias_passados_ano_atual:
    			# Em t1 esta o mes atual, vamos calcular quantos dias de passaram no ano atual
    			move $t4, $t1		# Coloca o que esta em $t1 em $t4 para calcular em cima de $t4
    				
    				loop_meses_ano_atual:
    				# Calcula quantos dias de passaram nos meses anteriores ao atual
    				subi $t4, $t4, 1					# Usa $t4 como uma contagem regressiva, do mes atual ate 0
    				beqz $t4, dias_mes_atual			# Se chegar em 0, nao ha mais meses para analisar
    				li $t5, 30						# Considera 30 a quantidade padrao de dias
    				beq $t4, 1, mes_com_31_dias_mes_atual   		# Se o mes em $t4 for 1, pula para a funcao que ajusta pra 31 dias       
    				beq $t4, 2, verificar_dias_fevereiro_mes_atual		# Se o mes em $t4 for 2, pula para a funcao que verifica a quantidade de dias
    				beq $t4, 3, mes_com_31_dias_mes_atual   		# Se o mes em $t4 for 3, pula para a funcao que ajusta pra 31 dias
    				beq $t4, 5, mes_com_31_dias_mes_atual   		# Se o mes em $t4 for 5, pula para a funcao que ajusta pra 31 dias
    				beq $t4, 7, mes_com_31_dias_mes_atual  		# Se o mes em $t4 for 7, pula para a funcao que ajusta pra 31 dias
    				beq $t4, 8, mes_com_31_dias_mes_atual   		# Se o mes em $t4 for 8, pula para a funcao que ajusta pra 31 dias
    				beq $t4, 10, mes_com_31_dias_mes_atual  		# Se o mes em $t4 for 10, pula para a funcao que ajusta pra 31 dias
    				beq $t4, 12, mes_com_31_dias_mes_atual			# Se o mes em $t4 for 12, pula para a funcao que ajusta pra 31 dias
    				
    				# Acumula 30 dias no acumulador
    				la $t6, acumulador
    				lw $t7, 0($t6)
    				add $t7, $t7, $t5
    				sw $t7, 0($t6)
    				j loop_meses_ano_atual
    			
				mes_com_31_dias_mes_atual:
					addi $t5, $t5, 1		# Guarda 31 no $t5
					# Acumula 31 dias no acumulador
					la $t6, acumulador
    				lw $t7, 0($t6)
    				add $t7, $t7, $t5
    				sw $t7, 0($t6)
    				j loop_meses_ano_atual
				
				verificar_dias_fevereiro_mes_atual:
						# Verifica se o ano eh bissexto
						li $t7, 4 
    					remu $t6, $t0, $t2   				# Armazena o resto da divisao de $s0 com $t2 como unsigned
    					beqz $t6, mes_com_29_dias_mes_atual  		# Se resto de $t3 for 0, significa que o ano eh bissexto 
    					subi $t5, $t5, 2  				# Se o ano nao eh bissexto ajusta a qtd de dias para 28
    					# Acumula 28 dias no acumulador
    					la $t6, acumulador
    					lw $t7, 0($t6)
    					add $t7, $t7, $t5
    					sw $t7, 0($t6)
    					j loop_meses_ano_atual
    				
    				mes_com_29_dias_mes_atual:
    					subi $t5, $t5, 1  				# Se o ano eh bissexto ajusta a qtd de dias para 29
    					# Acumula 29 dias no acumulador
    					la $t6, acumulador
    					lw $t7, 0($t6)
    					add $t7, $t7, $t5
    					sw $t7, 0($t6)
    					j loop_meses_ano_atual
    					
    			dias_mes_atual:
    				# Pega o dia, que eh a quantidade de dias passados no mes atual e acumula
    				la $t6, acumulador
    				lw $t7, 0($t6)
    				add $t7, $t7, $t2
    				sw $t7, 0($t6)  			
    			
    				lw $ra, 0($sp)         # Resgata o $ra original do $sp
    				addi $sp, $sp, 4    	# Devolve a pilha para a posicao original
    				jr $ra
