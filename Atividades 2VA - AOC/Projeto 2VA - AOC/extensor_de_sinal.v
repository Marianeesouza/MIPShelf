/* Projeto 2° VA - Arquitetura e Organização de Computadores - 2024.2
   Alunos: Heitor Leander Feitosa da Silva
           Joao Victor Morais Barreto da Silva
           Mariane Elisa dos Santos Souza
           Samuel Roberto de Carvalho Bezerra
   Descrição do arquivo: Extensor de Sinal (16 bits → 32 bits)
*/

module extensor_de_sinal (imediato, extensor_out);

   //Descrição das entradas e saídas:
   input wire [15:0] imediato;      // Valor imediato de 16 bits
   output wire [31:0] extensor_out; // Valor estendido para 32 bits

   //Comportamento:
   assign extensor_out = {{16{imediato[15]}}, imediato}; //Pega o bit mais significativo do imediato (imediato[15]), replica ele 16x e contaceta com o imediato 

endmodule