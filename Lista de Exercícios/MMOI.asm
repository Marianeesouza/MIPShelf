.data

.text
.globl main

main:
    # Loop infinito para leitura do teclado e escrita no display
echo_loop:
    # L� o status do teclado (Keyboard Control - 0xFFFF0004)
    li $t0, 0xFFFF0004        # Endere�o do Keyboard Control
    lw $t1, 0($t0)            # L� o valor do Keyboard Control
    andi $t1, $t1, 0x1        # Verifica se o bit de disponibilidade est� ativo (bit 0)
    beqz $t1, echo_loop       # Se n�o estiver ativo, volta ao in�cio do loop

    # L� o caractere do teclado (Keyboard Data - 0xFFFF0000)
    li $t0, 0xFFFF0000        # Endere�o do Keyboard Data
    lw $t2, 0($t0)            # L� o caractere digitado

    # Aguarda o display estar pronto (Display Control - 0xFFFF0008)
wait_display:
    li $t0, 0xFFFF0008        # Endere�o do Display Control
    lw $t3, 0($t0)            # L� o valor do Display Control
    andi $t3, $t3, 0x1        # Verifica se o bit de disponibilidade est� ativo (bit 0)
    beqz $t3, wait_display    # Se n�o estiver ativo, espera

    # Escreve o caractere no display (Display Data - 0xFFFF000C)
    li $t0, 0xFFFF000C        # Endere�o do Display Data
    sw $t2, 0($t0)            # Escreve o caractere lido no display

    # Retorna ao in�cio do loop para continuar o Echo
    j echo_loop
