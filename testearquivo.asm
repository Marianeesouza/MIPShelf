.data


registro_tamanho:		.word 0	
filelivro:			.asciiz "livros.txt"
registro:			.asciiz "Dom Casmurro,Machado de Assis,123456789,5\n"
prompt1: 			.asciiz "Arquivo salvo com sucesso"

repositorio_livro: 	.word 0 # local do endereco do espaço alocado
buffer:				.space 1
tamanho_arquivo:	.word 0 # variavel para contar tamanho do arquivo

teste_repositorio:	.asciiz "Teste,Teste,123456789,10"

quantidade:			.asciiz "12345"


.text 	
.globl main

main:
#jal cadastrar_livro
#jal aloca_rep
#jal imprime_rep_livro
#la $t0, filelivro
#la $t1, teste_repositorio
#jal salvar_dados

li $t0, 5
li $t2, 1
jal calcular_inteiro 
move $s0, $v0


li $v0, 10
syscall

calcular_inteiro:
# $t0 número de bytes de quantidade
# $t1 endereço de quantidade
# $t2, multiplicador
# $t3 acumulador
	subi $t0, $t0, 1 # subtrai 1 de t0
	la $t1, quantidade
	add $t1, $t1, $t0 
	lb $t1, ($t1) # carrega o byte de t1
	subi $t1, $t1, 48
	mul $t1, $t1, $t2 #multiplica t1 pela respectiva casa decimal 
	add $t3, $t1, $t3 # soma ao acumulador
	mul $t2, $t2, 10
	bnez $t0, calcular_inteiro # se numero de bytes != 0 recomeçar funcao
	
	move $v0, $t3 # move o acumulador para $v0
	jr $ra
	

cadastrar_livro:
	# abre o arquivo com no modo leitura+append
	li $v0, 13
	la $a0, filelivro
	li $a1, 9
	li $a2, 0
	syscall 
	move $s0, $v0 # salva descritor em $s0
	lw $t0, registro_tamanho #tamanho do registro
	la $t1, registro # endereço da string do registro
	j contar_tamanho_registro
	
contar_tamanho_registro:
	lb $t2, ($t1)  
	beqz $t2, salvar_livro
	addi $t0, $t0, 1
	addi $t1, $t1, 1
	j contar_tamanho_registro
	
salvar_livro:
	sw $t0, registro_tamanho
	#escreve o registro no arquivo
	li $v0, 15
	move $a0, $s0
	la $a1, registro
	lw $a2, registro_tamanho
	syscall
	
	
	#fecha o descritor
	li $v0, 16
	move $a0, $s0
	syscall
	
	li $v0, 4
	la $a0, prompt1
	syscall
	
	jr $ra
	
aloca_rep:
	li $v0, 13
	la $a0, filelivro
	li $a1, 0
	li $a2, 0
	syscall
	move $s0, $v0
	j conta_arquivo

	
conta_arquivo:
	li $v0, 14
	move $a0, $s0
	la $a1, buffer
	li $a2, 100
	syscall # salva valor lido no buffer, e número de bytes lido em $v0
	beqz $v0, alocar_espaco
	add $t0, $v0, $t0
	j conta_arquivo 
	
alocar_espaco:
	li $v0, 16
	move $a0, $s0
	syscall # fecha arquivo
	
	sw $t0, tamanho_arquivo
	li $v0, 9
	lw $a0, tamanho_arquivo
	syscall # aloca o espaco do tamanho do arquivo
	
	sw $v0, repositorio_livro # armazena endereço do espaco  alocado em repositorio_livro
	jr $ra
	

imprime_rep_livro:
	# abre o arquivo com no modo leitura
	li $v0, 13 
	la $a0, filelivro
	li $a1, 0
	li $a2, 0
	syscall 
	move $s0, $v0
	
	# le o arquivo e envia dados no repositorio
	li $v0, 14
	move $a0, $s0
	lw $a1, repositorio_livro
	lw $a2, tamanho_arquivo
	syscall
	
	# imprime conteudo do repositorio
	li $v0, 4
	lw $a0, repositorio_livro
	syscall
	
	jr $ra
repositorio_len:	

	lb $t4, ($t3) # carrega o byte de t3
	addi $t3, $t3, 1 
	addi $t2, $t2, 1
	bnez $t4, repositorio_len # se t4 é diferente de 0 recomeça a função
	subi $t2, $t2, 1 # subtrai 1 de t2 no final da função
	jr $ra #volta para ra
salvar_dados:
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
	lw $ra, 0($sp) 		#resgata o $ra original do $sp
    addi $sp, $sp, 4	#devolve a pilha para a posicao original
    
	li $v0, 15       # syscall para escrita
	move $a0, $s0    # move descritor para a0
	move $a1, $t1    # move endereco do repositorio para a1
	move $a2, $t2    # move tamanho do repositorio para a2
	syscall          # chama syscall de escrita
	
	# Limpa o buffer de comando
	#addi $sp, $sp, -4
 #   sw $ra, 0($sp)
#	la $s1, comando
#	jal clear_buffer
#	lw $ra, 0($sp) 		#resgata o $ra original do $sp
 #   addi $sp, $sp, 4	#devolve a pilha para a posicao original
	
	jr $ra



	
		

	
	
