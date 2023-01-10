# ARM SINGLE CYCLE (AS-IS)

O processador desenvolvido nesse projeto trata-se de um ARM 32 bits — isto é, suas instruções possuem frames de 32 bits. A manipulação desses frames, por parte do hardware, pode ser entendida se pensarmos em dois grandes fluxos de sinal: datapath e o control. 

> <sub>! DICA :  recomenda-se a leitura dessa parte observando-se atentamente a imagem do Single-Cycle abaixo.</sub>

![image](https://user-images.githubusercontent.com/66538880/210674620-4de346a3-292b-405a-9565-33519ffe27f7.png)

## ARM


O módulo **arm** instancia dois outros módulos, "controller" e "datapath". O módulo "controller" controla o fluxo de dados e as operações do processador, enquanto o módulo "datapath" implementa as operações lógicas e aritméticas do processador. Juntos, os módulos "arm", "controller" e "datapath" modelam o comportamento do processador ARM.

```
// Este é o módulo principal do processador ARM
module arm(
  
  // Entradas do processador
  input  logic        clk,        // Clock
  input  logic        reset,      // Reset
  input  logic [31:0] Instr,      // Instrução atual
  input  logic [31:0] ReadData    // Dados lidos da memória
  
  // Saídas do processador
  output logic [31:0] PC,         // Contador de programa
  output logic        MemWrite,   // Escrever na memória
  output logic [31:0] ALUResult,  // Resultado da ALU
  output logic [31:0] WriteData,  // Dados a serem escritos
);
  
  // Instância o módulo Controller
  controller c(clk, reset, Instr[31:12], ALUFlags, 
               RegSrc, RegWrite, ImmSrc, 
               ALUSrc, ALUControl,
               MemWrite, MemtoReg, PCSrc);
  
  // Instância o módulo datapath
  datapath dp(clk, reset, 
              RegSrc, RegWrite, ImmSrc,
              ALUSrc, ALUControl,
              MemtoReg, PCSrc,
              ALUFlags, PC, Instr,
              ALUResult, WriteData, ReadData);
endmodule
```


$\leftarrow$ [voltar](https://github.com/Batchuka/Projeto-ARM-Single-Cycle-IFES#sum%C3%A1rio)
