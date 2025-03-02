/* Projeto 2° VA - Arquitetura e Organização de Computadores - 2024.2
   Alunos: Heitor Leander Feitosa da Silva
           Joao Victor Morais Barreto da Silva
           Mariane Elisa dos Santos Souza
           Samuel Roberto de Carvalho Bezerra
   Descrição do arquivo: Somador para o Jump (PC + endereço deslocado)
*/

module somador_PC_jump (endereco_PC, endereco_deslocado, endereco_jump);

   // Descrição das entradas e saídas:
   input wire [31:0] endereco_PC;          // Valor atual do PC
   input wire [31:0] endereco_deslocado; 	 // Endereço deslocado (após o Shift Left 2)
   output wire [31:0] endereco_jump;       // Endereço final do Jump (Saída) 

   // Comportamento:
   assign endereco_jump = endereco_PC + endereco_deslocado;  // soma os endereco do pc e o endereco deslocado e retorna em endereco_jump

endmodule