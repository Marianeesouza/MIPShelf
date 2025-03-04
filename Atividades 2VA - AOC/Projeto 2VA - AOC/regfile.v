/* Projeto 2° VA - Arquitetura e Organização de Computadores - 2024.2
   Alunos: Heitor Leander Feitosa da Silva
           Joao Victor Morais Barreto da Silva
           Mariane Elisa dos Santos Souza
           Samuel Roberto de Carvalho Bezerra
   Descrição do arquivo: Banco de Registradores (regfile). Guarda os valores dos registradores.
*/

module regfile (ReadAddr1, ReadAddr2, ReadData1, ReadData2, WriteAddr, WriteData, clock, reset, RegWrite);
	
	//Descrição das entradas e saidas:
	input wire clock, reset, RegWrite; 						// Sinais relacionados ao clock e módulo de controle
   input wire [4:0] ReadAddr1, ReadAddr2, WriteAddr; 	// Endereços dos registradores (0 a 31)
   input wire [31:0] WriteData; 								// Dado a ser escrito no registrador
   output wire [31:0] ReadData1, ReadData2; 				// Dados lidos dos registradores

    // Banco de Registradores: 32 registradores de 32 bits
    reg [31:0] regs [0:31];

    always @(posedge clock or posedge reset) begin
        // Se reset for ativado, todos os registradores são zerados
        if (reset) begin
            integer i;
            for (i = 0; i < 32; i = i + 1) begin
                regs[i] <= 32'b0;
            end
        end else if (RegWrite) begin // Se o sinal de escrita estiver ativo...
            if (WriteAddr != 5'b0) begin // Impede escrita no registrador $zero
                regs[WriteAddr] <= WriteData;
            end else begin
                $display ("Registrador $zero não pode ser sobrescrito");
            end
        end
    end

    // Saídas para leitura dos registradores
    assign ReadData1 = (ReadAddr1 == 5'b0) ? 32'b0 : regs[ReadAddr1];
    assign ReadData2 = (ReadAddr2 == 5'b0) ? 32'b0 : regs[ReadAddr2];

endmodule
