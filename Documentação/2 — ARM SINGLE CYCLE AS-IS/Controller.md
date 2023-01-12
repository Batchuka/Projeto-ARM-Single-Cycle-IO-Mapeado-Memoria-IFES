
# CONTROLER

O módulo "controller" instancia outro módulo, chamado "decoder", que é responsável por decodificar a instrução fornecida e produzir sinais de controle adequados. O módulo "condlogic" é usado para implementar a lógica de condição do processador. Juntos, os módulos "controller", "decoder" e "condlogic" implementam a lógica de controle do processador ARM.

O *controller* é a circuitaria, majoritariamente, combinacional —  em grande parte, não depende do clock — para orquestrar os estados dos circuitos que compôem o *Datapath*. Ele, somente depende do: 
- Cabeçalho da instrução;
- Registrador de destino, $Rd$ ; e
- Flags


## Macros do Controller

Demaneira análoga, faremos a análise das macros utilizadas no Controller. Começaremos pela mais interna

### $\rightarrow$ flopenr
```
module flopenr #(parameter WIDTH = 8)
                (input  logic             clk, reset, en,
                 input  logic [WIDTH-1:0] d, 
                 output logic [WIDTH-1:0] q);

  always_ff @(posedge clk, posedge reset)
    if (reset)   q <= 0;
    else if (en) q <= d;
endmodule
```

Este é um módulo chamado flopenr que tem uma entrada WIDTH como parâmetro, por padrão, é definido como 8. Este módulo tem várias entradas e saídas.

As entradas são:

- clk e reset : são sinais de entrada para o relógio e o reset do sistema, respectivamente.
- en : é um sinal de entrada lógico que habilita ou desabilita a escrita no registrador.
- d : é um sinal de entrada de WIDTH bits, que contém o dado que será escrito no registrador.

E as saídas são:

- q : é um sinal de saída de WIDTH bits, que contém o dado armazenado no registrador.

> ✩ DICA : 'always_ff' é usado para criar um bloco síncrono de código, sequêncial. Já 'always_comb' é usado para a descrição de lógica puramente combinacional.

O módulo flopenr é uma implementação de um registrador de deslocamento. O registrador contém uma porta de entrada para o dado, uma porta de entrada para o clock, e uma porta de entrada para o reset. A saída do registrador é conectada ao dado armazenado. O registrador é implementado usando uma porta lógica always com uma cláusula de sincronização @(posedge clk, posedge reset). 

A porta lógica sempre verifica se o relógio e o reset estão em nível alto. Se o reset estiver em nível alto, o registrador é redefinido para 0. Caso contrário, se o en estiver em nível alto, o dado é escrito no registrador.

### $\rightarrow$ condcheck
```
// Recebem dois inputs de 4 bits e um retorno de tamanho indefinido
module condcheck(input  logic [3:0] Cond,
                 input  logic [3:0] Flags,
                 output logic       CondEx);
  
  // cinco sinais internos
  logic neg, zero, carry, overflow, ge;
  
  // duas estruturas baseadas nos sinais. Uma chamada 'Flags' e outra 'ge' (greater or equal)
  assign {neg, zero, carry, overflow} = Flags;
  assign ge = (neg == overflow);
                  
  always_comb
    case(Cond)
      4'b0000: CondEx = zero;             // EQ
      4'b0001: CondEx = ~zero;            // NE
      4'b0010: CondEx = carry;            // CS
      4'b0011: CondEx = ~carry;           // CC
      4'b0100: CondEx = neg;              // MI
      4'b0101: CondEx = ~neg;             // PL
      4'b0110: CondEx = overflow;         // VS
      4'b0111: CondEx = ~overflow;        // VC
      4'b1000: CondEx = carry & ~zero;    // HI
      4'b1001: CondEx = ~(carry & ~zero); // LS
      4'b1010: CondEx = ge;               // GE
      4'b1011: CondEx = ~ge;              // LT
      4'b1100: CondEx = ~zero & ge;       // GT
      4'b1101: CondEx = ~(~zero & ge);    // LE
      4'b1110: CondEx = 1'b1;             // Always
      default: CondEx = 1'bx;             // undefined
    endcase
endmodule
```
Este é um módulo Verilog chamado "condcheck", que recebe dois inputs: um vetor de 4 bits chamado "Cond" e um vetor de 4 bits chamado "Flags". Ele também tem uma saída: um sinal lógico de 1 bit chamado "CondEx".

O módulo primeiro atribui os bits individuais da entrada "Flags" para sinais lógicos separados chamados "neg", "zero", "carry" e "overflow". Ele também atribui o sinal "ge" como o resultado de "neg" ser igual a "overflow".

No bloco always_comb, o módulo usa um comando case para avaliar a entrada "Cond" e atribui a saída "CondEx" com base no valor de "Cond". Dependendo do valor de 4 bits de "Cond", diferentes combinações dos sinais "neg", "zero", "carry", "overflow" e "ge" são usadas para determinar o valor de "CondEx".

A declaração case tem 16 opções possíveis para o valor de "Cond", cada uma das quais atribui um valor específico a "CondEx". A última opção é um caso padrão, que atribui "CondEx" o valor de 'x' quando o valor de "Cond" não é uma das definições.

![image](https://user-images.githubusercontent.com/66538880/207780798-e3ca60fe-f899-4d81-a8c1-e1001fb9107d.png)

### $\rightarrow$ condlogic
```
module condlogic(input  logic       clk, reset,
                 input  logic [3:0] Cond,
                 input  logic [3:0] ALUFlags,
                 input  logic [1:0] FlagW,
                 input  logic       PCS, RegW, MemW,
                 output logic       PCSrc, RegWrite, MemWrite);
                 
  logic [1:0] FlagWrite;
  logic [3:0] Flags;
  logic       CondEx;

  flopenr #(2)flagreg1(clk, reset, FlagWrite[1], 
                       ALUFlags[3:2], Flags[3:2]);
  flopenr #(2)flagreg0(clk, reset, FlagWrite[0], 
                       ALUFlags[1:0], Flags[1:0]);

  // write controls are conditional
  condcheck cc(Cond, Flags, CondEx);
  assign FlagWrite = FlagW & {2{CondEx}};
  assign RegWrite  = RegW  & CondEx;
  assign MemWrite  = MemW  & CondEx;
  assign PCSrc     = PCS   & CondEx;
endmodule
```
Este é um módulo Verilog chamado "condlogic" que recebe vários inputs: um sinal de clock (clk), um sinal de reset, um vetor de 4 bits chamado "Cond", um vetor de 4 bits chamado "ALUFlags", um vetor de 2 bits chamado "FlagW" e três sinais de 1 bit chamados "PCS", "RegW" e "MemW". Ele também tem quatro saídas: "PCSrc", "RegWrite", "MemWrite" e "CondEx".

O módulo define primeiro um vetor de 2 bits chamado "FlagWrite", um vetor de 4 bits chamado "Flags" e um sinal de 1 bit chamado "CondEx".

Então ele instancia duas instâncias de um módulo chamado "flopenr" que ambos tem os mesmos inputs como "clk", "reset", "FlagWrite[0/1]", "ALUFlags[1:0/3:2]" e "Flags[1:0/3:2]" respectivamente, essas duas instâncias são destinadas a atualizar o vetor "Flags".

O módulo "condcheck" é então instanciado, tendo como entrada "Cond" e "Flags" e produzindo a saída "CondEx".

Em seguida, na linha seguinte, a saída "FlagWrite" é atribuída como a entrada "FlagW" AND com 2 cópias do sinal "CondEx". A saída "RegWrite" é atribuída como a entrada "RegW" AND com "CondEx" e a saída "MemWrite" é atribuída como a entrada "MemW" AND com "CondEx", a saída "PCSrc" é atribuída como a entrada "PCS" AND com "CondEx"

Este módulo está usando a entrada "Cond" para controlar se as saídas "FlagWrite", "RegWrite", "MemWrite" e "PCSrc" estão habilitadas ou não. Se "CondEx" for verdadeiro, então a saída correspondente é habilitada, caso contrário, ela é desabilitada.

### $\rightarrow$ decoder
```
module decoder(input  logic [1:0] Op,
               input  logic [5:0] Funct,
               input  logic [3:0] Rd,
               output logic [1:0] FlagW,
               output logic       PCS, RegW, MemW,
               output logic       MemtoReg, ALUSrc,
               output logic [1:0] ImmSrc, RegSrc, ALUControl);

  logic [9:0] controls;
  logic       Branch, ALUOp;

  // Main Decoder
  
  always_comb
  	case(Op)
  	                        // Data processing immediate
  	  2'b00: if (Funct[5])  controls = 10'b0000101001; 
  	                        // Data processing register
  	         else           controls = 10'b0000001001; 
  	                        // LDR
  	  2'b01: if (Funct[0])  controls = 10'b0001111000; 
  	                        // STR
  	         else           controls = 10'b1001110100; 
  	                        // B
  	  2'b10:                controls = 10'b0110100010; 
  	                        // Unimplemented
  	  default:              controls = 10'bx;          
  	endcase

  assign {RegSrc, ImmSrc, ALUSrc, MemtoReg, 
          RegW, MemW, Branch, ALUOp} = controls; 
          
  // ALU Decoder 
            
  always_comb
    if (ALUOp) begin                 // which DP Instr?
      case(Funct[4:1]) 
  	    4'b0100: ALUControl = 2'b00; // ADD
  	    4'b0010: ALUControl = 2'b01; // SUB
            4'b0000: ALUControl = 2'b10; // AND
  	    4'b1100: ALUControl = 2'b11; // ORR
  	    default: ALUControl = 2'bx;  // unimplemented
      endcase
      // update flags if S bit is set 
	// (C & V only updated for arith instructions)
      FlagW[1]      = Funct[0]; // FlagW[1] = S-bit
	// FlagW[0] = S-bit & (ADD | SUB)
      FlagW[0]      = Funct[0] & 
        (ALUControl == 2'b00 | ALUControl == 2'b01); 
    end else begin
      ALUControl = 2'b00; // add for non-DP instructions
      FlagW      = 2'b00; // don't update Flags
    end
              
  // PC Logic
  assign PCS  = ((Rd == 4'b1111) & RegW) | Branch; 
endmodul
```
Este é um módulo Verilog chamado "decodificador", que recebe várias entradas: um vetor de 2 bits chamado "Op", um vetor de 6 bits chamado "Funct" e um vetor de 4 bits chamado "Rd". O módulo possui várias saídas: um vetor de 2 bits chamado "FlagW", 3 sinais de 1 bit chamados "PCS", "RegW" e "MemW", 3 sinais de 1 bit chamados "MemtoReg", "ALUSrc" e "RegSrc" e um sinal de 2 bits chamado "ALUControl".

O módulo possui um bloco always_comb que usa uma declaração case para decodificar o valor de "Op" e atribui o vetor de 10 bits "controls" um valor específico dependendo do valor de "Op" e "Funct" bem como um valor "não implementado" para o padrão.

Depois disso, ele atribui várias saídas "RegSrc", "ImmSrc", "ALUSrc", "MemtoReg", "RegW", "MemW", "Branch", "ALUOp" a partir do vetor "controls".

Então, há outro bloco always_comb que usa outra declaração case dentro de uma declaração condicional que avalia o sinal "ALUOp" e "Funct[4:1]" para determinar o valor da saída "ALUControl". Ele também atribui valores à saída "FlagW" com base no valor de "Funct[0]", se é uma instrução de processamento de dados e se é uma operação de adição ou subtração.

A última parte do módulo atribui o valor da saída "PCS" usando uma lógica combinatória baseada na entrada "Rd", "RegW" e "Branch"

Em geral, o módulo decodificador recebe várias entradas e as decodifica para determinar vários sinais de controle que são usados para controlar o comportamento de outras partes do sistema.


É constituído pelo *Main Decoder* que é o principal gerador de sinais para controle e o *ALUDecoder*, que usará o campo ${Funct}$ para determinar o tipo de instrução *Data-processing*. Há também um controle para atualizar o valor de PC, chamado ${PCSrc}$. Considerando que são circuitos combinacionais, temos a vantagem de poder usar tabelas-verdade para sua implementação.

![image](https://user-images.githubusercontent.com/66538880/207778472-627997a4-2efe-4d88-89c9-3c36182e290c.png)


## A lógica do Controller

```
module controller(input  logic         clk, reset,
                  input  logic [31:12] Instr,
                  input  logic [3:0]   ALUFlags,
                  output logic [1:0]   RegSrc,
                  output logic         RegWrite,
                  output logic [1:0]   ImmSrc,
                  output logic         ALUSrc, 
                  output logic [1:0]   ALUControl,
                  output logic         MemWrite, MemtoReg,
                  output logic         PCSrc);

  logic [1:0] FlagW;
  logic       PCS, RegW, MemW;
  
  decoder dec(Instr[27:26], Instr[25:20], Instr[15:12],
              FlagW, PCS, RegW, MemW,
              MemtoReg, ALUSrc, ImmSrc, RegSrc, ALUControl);
  condlogic cl(clk, reset, Instr[31:28], ALUFlags,
               FlagW, PCS, RegW, MemW,
               PCSrc, RegWrite, MemWrite);
endmodule
```
Este é um módulo Verilog chamado "controlador" que recebe várias entradas: um sinal de clock (clk), um sinal de reset, um vetor de 20 bits chamado "Instr" e um vetor de 4 bits chamado "ALUFlags". Ele também possui várias saídas: um vetor de 2 bits chamado "RegSrc", um sinal de 1 bit chamado "RegWrite", um vetor de 2 bits chamado "ImmSrc", um sinal de 1 bit chamado "ALUSrc", um vetor de 2 bits chamado "ALUControl", um sinal de 1 bit chamado "MemWrite", um sinal de 1 bit chamado "MemtoReg" e um sinal de 1 bit chamado "PCSrc".

O módulo instancia dois sub-módulos "decodificador" e "condlogic", passando alguns dos inputs e algumas das saídas dos sub-módulos para as entradas e saídas do "controlador".

O módulo "decodificador" recebe os valores de "Instr[27:26]", "Instr[25:20]" e "Instr[15:12]" como entradas, e produz várias saídas: "FlagW", "PCS", "RegW", "MemW", "MemtoReg", "ALUSrc", "ImmSrc", "RegSrc" e "ALUControl".

O módulo "condlogic" recebe os valores de "clk", "reset", "Instr[31:28]" e "ALUFlags como entradas, e as saídas de "FlagW", "PCS", "RegW" e "MemW" do módulo "decodificador" como entrada, ele também produz saídas: "PCSrc", "RegWrite" e "MemWrite".

O módulo "controlador" combina a funcionalidade dos módulos "decodificador" e "condlogic" para produzir as saídas finais do controlador. Ele combina as saídas do decodificador, verificando as condições e flags correspondentes e atua como um intermediário entre a entrada e as saídas finais.


|$\leftarrow$ [Datapath](https://github.com/Batchuka/Projeto-ARM-Single-Cycle-IFES/blob/main/Documenta%C3%A7%C3%A3o/2%20%E2%80%94%20ARM%20SINGLE%20CYCLE%20AS-IS/Datapath.md#datapath) | [Sumário](https://github.com/Batchuka/Projeto-ARM-Single-Cycle-IFES#sum%C3%A1rio) | [ARM NOVAS INSTRUÇÕES (TO-BE)](https://github.com/Batchuka/Projeto-ARM-Single-Cycle-IFES/blob/main/Documenta%C3%A7%C3%A3o/3%20%E2%80%94%20AS%20NOVAS%20INSTRU%C3%87%C3%95ES%20TO-BE/3%20%E2%80%94%20AS%20NOVAS%20INSTRU%C3%87%C3%95ES%20TO-BE.md#arm-novas-instru%C3%A7%C3%B5es-to-be) $\rightarrow$|
|-|-|-|
