# Datapath

## Macros do Datapath

Para entender o que acontece no módulo **datapath**, é necessário entender as macros que ele instancia, a saber:

> <sub>! DICA :  uma macro é uma espécie de atalho para um trecho de código que é usado comumente..</sub>

### $\rightarrow$ mux2
```
module mux2 #(parameter WIDTH = 8)
             (input  logic [WIDTH-1:0] d0, d1, 
              input  logic             s, 
              output logic [WIDTH-1:0] y);

  assign y = s ? d1 : d0; 
endmodule
```

Esse é o código de uma macro que implementa uma porta multiplexadora de 2 entradas. A porta multiplexadora tem duas entradas, "d0" e "d1", um sinal de controle "s" e uma saída "y". O comprimento dos sinais de entrada e saída é especificado pelo parâmetro "WIDTH", que é definido como 8 por padrão.

A linha "assign y = s ? d1 : d0;" é a implementação da lógica da porta multiplexadora. Ela diz que a saída "y" deve assumir o valor de "d1" se "s" for verdadeiro e o valor de "d0" caso contrário.

### $\rightarrow$ flopr

```
module flopr #(parameter WIDTH = 8)
              (input  logic             clk, reset,
               input  logic [WIDTH-1:0] d, 
               output logic [WIDTH-1:0] q);

  always_ff @(posedge clk, posedge reset)
    if (reset) q <= 0;
    else       q <= d;
endmodule
```

Esse é o código de uma macro que implementa um flip-flop D com reset. O flip-flop D tem uma entrada "d", uma saída "q", um clock "clk" e um sinal de reset "reset". O comprimento dos sinais de entrada e saída é especificado pelo parâmetro "WIDTH", que é definido como 8 por padrão.

A declaração "always_ff @(posedge clk, posedge reset)" indica que a lógica do flip-flop deve ser atualizada sempre que ocorrer uma transição positiva no sinal "clk" ou no sinal "reset".

A lógica do flip-flop é implementada no bloco "if (reset) q <= 0; else q <= d;". Ela diz que a saída "q" deve ser configurada para 0 se "reset" for verdadeiro e para o valor da entrada "d" caso contrário.


### $\rightarrow$ adder

```
module adder #(parameter WIDTH=8)
              (input  logic [WIDTH-1:0] a, b,
               output logic [WIDTH-1:0] y);
             
  assign y = a + b;
endmodule
```
Esse é o código de uma macro que implementa um somador. O somador tem duas entradas "a" e "b" e uma saída "y". O comprimento dos sinais de entrada e saída é especificado pelo parâmetro "WIDTH", que é definido como 8 por padrão.

A linha "assign y = a + b;" é a implementação da lógica do somador. Ela diz que a saída "y" deve assumir o valor da soma de "a" e "b".

### $\rightarrow$ regfile
```
module regfile(input  logic        clk, 
               input  logic        we3, 
               input  logic [3:0]  ra1, ra2, wa3, 
               input  logic [31:0] wd3, r15,
               output logic [31:0] rd1, rd2);

  logic [31:0] rf[14:0];

  always_ff @(posedge clk)
    if (we3) rf[wa3] <= wd3;	

  assign rd1 = (ra1 == 4'b1111) ? r15 : rf[ra1];
  assign rd2 = (ra2 == 4'b1111) ? r15 : rf[ra2];
endmodule
```

Em resumo, essa é uma macro que implementa um registrador de arquivo com duas entradas de leitura, uma entrada de escrita e um clock. 

Quando há uma transição positiva no sinal de clock e "we3" é verdadeiro, o registrador de arquivo escreve o valor especificado por "wd3" no registrador especificado por "wa3". As saídas de leitura "rd1" e "rd2" são combinatoriamente ligadas aos registradores especificados por "ra1" e "ra2", respectivamente. Se "ra1" ou "ra2" são iguais a 15, as saídas de leitura "rd1" e "rd2" são configuradas para o valor especificado por "r15".

### $\rightarrow$ extend
```
module extend(input  logic [23:0] Instr,
              input  logic [1:0]  ImmSrc,
              output logic [31:0] ExtImm);
 
  always_comb
    case(ImmSrc) 
               // 8-bit unsigned immediate
      2'b00:   ExtImm = {24'b0, Instr[7:0]};  
               // 12-bit unsigned immediate 
      2'b01:   ExtImm = {20'b0, Instr[11:0]}; 
               // 24-bit two's complement shifted branch 
      2'b10:   ExtImm = {{6{Instr[23]}}, Instr[23:0], 2'b00}; 
      default: ExtImm = 32'bx; // undefined
    endcase             
endmodule
```

Essa é uma macro que estende um valor imediato de 24 bits para um valor de 32 bits. O tipo de extensão é determinado pelo sinal "ImmSrc", que pode assumir um de três valores:

    2'b00: O valor imediato é estendido com zeros para os bits mais significativos, resultando em um valor imediato sem sinal de 8 bits.
    2'b01: O valor imediato é estendido com zeros para os bits mais significativos, resultando em um valor imediato sem sinal de 12 bits.
    2'b10: O valor imediato é estendido com o bit mais significativo duplicado para os bits mais significativos, resultando em um valor imediato com sinal de 24 bits.

Se o sinal "ImmSrc" assumir qualquer outro valor, o sinal de saída "ExtImm" é configurado para um valor indefinido ("x" na notação Verilog).

### $\rightarrow$ alu

```
module alu(input  logic [31:0] a, b,
           input  logic [1:0]  ALUControl,
           output logic [31:0] Result,
           output logic [3:0]  ALUFlags);

  logic        neg, zero, carry, overflow;
  logic [31:0] condinvb;
  logic [32:0] sum;

  assign condinvb = ALUControl[0] ? ~b : b;
  assign sum = a + condinvb + ALUControl[0];

  always_comb
    casex (ALUControl[1:0])
      2'b0?: Result = sum;
      2'b10: Result = a & b;
      2'b11: Result = a | b;
    endcase

  assign neg      = Result[31];
  assign zero     = (Result == 32'b0);
  assign carry    = (ALUControl[1] == 1'b0) & sum[32];
  assign overflow = (ALUControl[1] == 1'b0) & 
                    ~(a[31] ^ b[31] ^ ALUControl[0]) & 
                    (a[31] ^ sum[31]); 
  assign ALUFlags    = {neg, zero, carry, overflow};
endmodule
```
Este código define um módulo de unidade lógico-aritmética (ALU, na sigla em inglês). A ALU recebe dois operandos de 32 bits (a e b) e um controle de 2 bits (ALUControl) e produz um resultado também de 32 bits (Result). Além disso, a ALU produz um conjunto de 4 flags (ALUFlags) que indicam, respectivamente, se o resultado é negativo, se é zero, se houve "carry" e se houve "overflow" durante a operação.

O comportamento da ALU é determinado pelo valor dos 2 bits de controle ALUControl. O código usa uma estrutura "casex" para avaliar os possíveis valores de ALUControl e atribuir um valor a Result de acordo. Se ALUControl for 00, então Result recebe a soma de a e b. Se ALUControl for 10, então Result recebe o "and" lógico de a e b. Se ALUControl for 11, então Result recebe o "or" lógico de a e b.

Antes de calcular a soma, o código calcula o operando b invertido, condicionalmente, de acordo com o primeiro bit de ALUControl. Isso é feito através da linha "assign condinvb = ALUControl[0] ? ~b : b;". Depois, a soma é calculada como a soma de a, b invertido e o primeiro bit de ALUControl, através da linha "assign sum = a + condinvb + ALUControl[0];".


## Lógica do Datapath

O **Datapath** representa todos os barramentos por onde sinais de dados podem passar. Aqui, é importante que se diga que o projeto atual implementa um single-cycle baseado na arquitetura de Harvard — isto é, a memória de instrução está separada da memória de dados. Abaixo, as entradas, saídas e variáveis internas:

```
// Este módulo implementa as operações lógicas e aritméticas do processador
module datapath(
  
  // Entradas do processador
  input  logic        clk,        // Clock
  input  logic        reset,      // Reset
  input  logic [1:0]  RegSrc,     // Seleção de registrador
  input  logic        RegWrite,   // Habilita a escrita no banco de registradores
  input  logic [1:0]  ImmSrc,     // Seleção de imediato
  input  logic        ALUSrc,     // Seleção de operando da ALU
  input  logic [1:0]  ALUControl, // Controle da ALU
  input  logic        MemtoReg,   // Habilita a leitura da memória
  input  logic        PCSrc,      // Seleção do próximo PC
  input  logic [31:0] Instr,      // Instrução atual
  input  logic [31:0] ReadData    // Dados lidos da memória
  
  // Saídas do processador
  output logic [3:0]  ALUFlags,
  output logic [31:0] PC,          // Contador de programa
  output logic [31:0] ALUResult,   // Resultado da ALU
  output logic [31:0] WriteData,   // Dados a serem escritos
)

// Declara algumas variáveis internas
  logic [31:0] PCNext, PCPlus4, PCPlus8;
  logic [31:0] ExtImm, SrcA, SrcB, Result;
  logic [3:0]  RA1, RA2;
```

Com isso, temos as lógicas que criam várias instancias dessas macros para construir componentes que atuem como os hardwares descritos na imagem.

### $\rightarrow$ Lógica para o próximo PC

Por exemplo:

```
  mux2 #(32)  pcmux(PCPlus4, Result, PCSrc, PCNext);
  flopr #(32) pcreg(clk, reset, PCNext, PC);
  adder #(32) pcadd1(PC, 32'b100, PCPlus4);
  adder #(32) pcadd2(PCPlus4, 32'b100, PCPlus8);

```

O trecho de código acima é responsável por atualizar o valor do PC (Program Counter) na CPU. O mux2 "pcmux" é um multiplexador de 2 entradas que escolhe qual valor deve ser passado para o próximo PC, dependendo da entrada "PCSrc". Se "PCSrc" for 0, o próximo PC será o valor armazenado em "PCPlus4". Se "PCSrc" for 1, o próximo PC será o valor armazenado em "Result". O próximo PC é então armazenado no flip-flop "pcreg". Os dois adders, "pcadd1" e "pcadd2", são responsáveis por somar 4 e 8, respectivamente, ao valor atual do PC e armazenar o resultado em "PCPlus4" e "PCPlus8".


### $\rightarrow$ Lógica do banco de registradores
```
  mux2 #(4)   ra1mux(Instr[19:16], 4'b1111, RegSrc[0], RA1);
  mux2 #(4)   ra2mux(Instr[3:0], Instr[15:12], RegSrc[1], RA2);
  regfile     rf(clk, RegWrite, RA1, RA2,
                 Instr[15:12], Result, PCPlus8, 
                 SrcA, WriteData); 
  mux2 #(32)  resmux(ALUResult, ReadData, MemtoReg, Result);
  extend      ext(Instr[23:0], ImmSrc, ExtImm);
```

Esse trecho de código é responsável por gerenciar o banco de registradores do processador. 

A função mux2 ra1mux seleciona o endereço de um registrador a ser lido baseado na entrada RegSrc[0] e no campo de endereço de registrador presente na instrução (Instr[19:16]). 

A saída desse multiplexador é usada como endereço do registrador na entrada ra1 da regfile. O mesmo ocorre com a função mux2 ra2mux, que seleciona o endereço de outro registrador a ser lido baseado em RegSrc[1] e Instr[15:12]. A regfile é a instância do banco de registradores propriamente dito e é responsável por realizar as leituras nos endereços fornecidos por ra1 e ra2 e escrever no endereço fornecido por Instr[15:12] caso we3 (RegWrite) esteja ativo. 

O resultado da leitura do endereço ra1 é armazenado em SrcA e o resultado da leitura do endereço ra2 é armazenado em WriteData. O multiplexador resmux seleciona o valor a ser armazenado na saída Result baseado em MemtoReg e em ALUResult ou ReadData. A extend é uma instância que extende o valor presente em Instr[23:0] para 32 bits de acordo com o valor de ImmSrc e armazena o resultado em ExtImm.

### $\rightarrow$ Lógica da ALU
```
  mux2 #(32)  srcbmux(WriteData, ExtImm, ALUSrc, SrcB);
  alu         alu(SrcA, SrcB, ALUControl, 
                  ALUResult, ALUFlags);
```
A lógica do ALU (Arithmetic Logic Unit) é responsável por realizar operações aritméticas e lógicas sobre os operandos. No caso deste código, o ALU recebe dois operandos, "SrcA" e "SrcB", e um controlador "ALUControl" que determina qual operação deve ser realizada.

A operação a ser realizada é determinada pelos dois bits menos significativos de "ALUControl". Se os dois bits forem "00", então a soma de "SrcA" e "SrcB" é calculada e armazenada em "Result". Se os dois bits forem "10", então a operação lógica "E" (and) é realizada sobre "SrcA" e "SrcB" e o resultado é armazenado em "Result". Se os dois bits forem "11", então a operação lógica "OU" (or) é realizada sobre "SrcA" e "SrcB" e o resultado é armazenado em "Result".

Além disso, o ALU também calcula algumas flags de estado baseadas no resultado da operação. A flag "neg" é "1" se o bit mais significativo de "Result" for "1", o que indica um número negativo. A flag "zero" é "1" se "Result" for igual a zero. A flag "carry" é "1" se houver um carry-out na operação de soma. A flag "overflow" é "1" se houver um overflow na operação de soma. Todas essas flags são armazenadas em "ALUFlags".

$\leftarrow$ [ARM Single Cycle (AS-IS)](https://github.com/Batchuka/Projeto-ARM-Single-Cycle-IFES/blob/main/Documenta%C3%A7%C3%A3o/2%20%E2%80%94%20ARM%20SINGLE%20CYCLE%20AS-IS/2%20%E2%80%94%20ARM%20SINGLE%20CYCLE%20AS-IS.md#arm-single-cycle-as-is) | [sumário](https://github.com/Batchuka/Projeto-ARM-Single-Cycle-IFES#sum%C3%A1rio) | [Controller](https://github.com/Batchuka/Projeto-ARM-Single-Cycle-IFES/blob/main/Documenta%C3%A7%C3%A3o/2%20%E2%80%94%20ARM%20SINGLE%20CYCLE%20AS-IS/Controller.md#controler) $\rightarrow$
|-|-|-|
