# 2 — ARM SINGLE CYCLE (AS-IS)

O processador desenvolvido nesse projeto trata-se de um ARM 32 bits — isto é, suas instruções possuem frames de 32 bits. A manipulação desses frames, por parte do hardware, pode ser entendido se pensarmos em dois grandes fluxos de sinal: datapath e o control. A partir de agora, irei explicar o [projeto AS-IS](https://github.com/Batchuka/Projeto-ARM-Single-Cycle-IFES/blob/main/ArmSingleCycle/arm_single_AS_IS.sv) do ARM. O projeto é baseado no ARM Single-Cycle do livro [*Digital Design and Computer Architecture, ARM Edition*](https://www.amazon.com.br/Digital-Design-Computer-Architecture-English-ebook/dp/B00XHN8RI4/ref=sr_1_3?__mk_pt_BR=%C3%85M%C3%85%C5%BD%C3%95%C3%91&crid=2O6BFDVAZ5RH&keywords=harris+assembly+arm&qid=1672873390&sprefix=harris+assembly+ar%2Caps%2C230&sr=8-3), de Sarah L. Harris e David Harris.

> <sub>! DICA :  recomenda-se a leitura dessa parte observando-se atentamente a imagem do Single-Cycle abaixo. A explicação será dada tomando como referência o código (cima -> baixo) e a imagem (esquerda -> direita).</sub>

![image](https://user-images.githubusercontent.com/66538880/210674620-4de346a3-292b-405a-9565-33519ffe27f7.png)

## 2.1 — ARM


O módulo **arm** instancia dois outros módulos, "controller" e "datapath". O módulo "controller" controla o fluxo de dados e as operações do processador, enquanto o módulo "datapath" implementa as operações lógicas e aritméticas do processador. Juntos, os módulos "arm", "controller" e "datapath" modelam o comportamento do processador ARM.

```
// Este é o módulo principal do processador ARM
module arm(
  
  // Entradas do processador
  input  logic        clk,        // Clock
  input  logic        reset,      // Reset
  
  // Saídas do processador
  output logic [31:0] PC,         // Contador de programa
  
  // Entradas do processador
  input  logic [31:0] Instr,      // Instrução atual
 
 // Saídas do processador
  output logic        MemWrite,   // Escrever na memória
  output logic [31:0] ALUResult,  // Resultado da ALU
  output logic [31:0] WriteData,  // Dados a serem escritos
  
  // Entradas do processador
  input  logic [31:0] ReadData    // Dados lidos da memória
);
  
  // Instância os módulos de controle e caminho de dados do processador
  controller c(clk, reset, Instr[31:12], ALUFlags, 
               RegSrc, RegWrite, ImmSrc, 
               ALUSrc, ALUControl,
               MemWrite, MemtoReg, PCSrc);
  datapath dp(clk, reset, 
              RegSrc, RegWrite, ImmSrc,
              ALUSrc, ALUControl,
              MemtoReg, PCSrc,
              ALUFlags, PC, Instr,
              ALUResult, WriteData, ReadData);
endmodule
```

## 2.2 — Datapath

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

Para entender o que acontece no módulo **datapath**, é necessário entender as macros que ele instancia, a saber:

> <sub>! DICA :  uma macro é uma espécie de atalho para um trecho de código que é usado comumente..</sub>

#### mux2 ####
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


#### flopr ####

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


#### adder ####

```
module adder #(parameter WIDTH=8)
              (input  logic [WIDTH-1:0] a, b,
               output logic [WIDTH-1:0] y);
             
  assign y = a + b;
endmodule
```
Esse é o código de uma macro que implementa um somador. O somador tem duas entradas "a" e "b" e uma saída "y". O comprimento dos sinais de entrada e saída é especificado pelo parâmetro "WIDTH", que é definido como 8 por padrão.

A linha "assign y = a + b;" é a implementação da lógica do somador. Ela diz que a saída "y" deve assumir o valor da soma de "a" e "b".

#### regfile
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

#### extend ####
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

#### alu ####

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


Com isso, pode-se entender o **datapath**.

```
// Lógica para o próximo PC
  mux2 #(32)  pcmux(PCPlus4, Result, PCSrc, PCNext);
  flopr #(32) pcreg(clk, reset, PCNext, PC);
  adder #(32) pcadd1(PC, 32'b100, PCPlus4);
  adder #(32) pcadd2(PCPlus4, 32'b100, PCPlus8);

```

O trecho de código acima é responsável por atualizar o valor do PC (Program Counter) na CPU. O mux2 "pcmux" é um multiplexador de 2 entradas que escolhe qual valor deve ser passado para o próximo PC, dependendo da entrada "PCSrc". Se "PCSrc" for 0, o próximo PC será o valor armazenado em "PCPlus4". Se "PCSrc" for 1, o próximo PC será o valor armazenado em "Result". O próximo PC é então armazenado no flip-flop "pcreg". Os dois adders, "pcadd1" e "pcadd2", são responsáveis por somar 4 e 8, respectivamente, ao valor atual do PC e armazenar o resultado em "PCPlus4" e "PCPlus8".

```
// Lógica do banco de registradores
  mux2 #(4)   ra1mux(Instr[19:16], 4'b1111, RegSrc[0], RA1);
  mux2 #(4)   ra2mux(Instr[3:0], Instr[15:12], RegSrc[1], RA2);
  regfile     rf(clk, RegWrite, RA1, RA2,
                 Instr[15:12], Result, PCPlus8, 
                 SrcA, WriteData); 
  mux2 #(32)  resmux(ALUResult, ReadData, MemtoReg, Result);
  extend      ext(Instr[23:0], ImmSrc, ExtImm);
```


```
// Lógica da ALU
  mux2 #(32)  srcbmux(WriteData, ExtImm, ALUSrc, SrcB);
  alu         alu(SrcA, SrcB, ALUControl, 
                  ALUResult, ALUFlags);
  
  
```

