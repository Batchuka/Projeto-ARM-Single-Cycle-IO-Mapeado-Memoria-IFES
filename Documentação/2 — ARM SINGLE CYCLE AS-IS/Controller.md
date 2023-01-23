
# CONTROLER

O módulo "controller" instancia outro módulo, chamado "decoder", que é responsável por decodificar a instrução fornecida e produzir sinais de controle adequados. O módulo "condlogic" é usado para implementar a lógica de condição do processador. Juntos, os módulos "controller", "decoder" e "condlogic" implementam a lógica de controle do processador ARM.

O *controller* é a circuitaria, majoritariamente, combinacional —  em grande parte, não depende do clock — para orquestrar os estados dos circuitos que compôem o *Datapath*. Ele, somente depende do: 
- Cabeçalho da instrução: $Cond$, $Funct$ e $Op$
- Registrador de destino, $Rd$ ; e
- $AluFlags$

![image](https://user-images.githubusercontent.com/66538880/213886119-cfc1c9d1-a41f-4e1a-a3e2-e7c39ebce5ee.png)


## A lógica do Controller

Este é um módulo Verilog chamado "controlador" que recebe várias entradas: 

- um sinal de clock (clk), um sinal de reset;
- um vetor de 20 bits chamado "Instr" — que é a composição de $Cond$, $Funct$, $Op$ e $Rd$ — e um vetor de 4 bits chamado "ALUFlags". 

Ele também possui várias saídas: 

- um vetor de 2 bits chamado "RegSrc", 
- um sinal de 1 bit chamado "RegWrite", 
- um vetor de 2 bits chamado "ImmSrc", 
- um sinal de 1 bit chamado "ALUSrc", 
- um vetor de 2 bits chamado "ALUControl", 
- um sinal de 1 bit chamado "MemWrite", 
- um sinal de 1 bit chamado "MemtoReg" e 
- um sinal de 1 bit chamado "PCSrc".

O módulo serve basicamente para "chamar" dois sub-módulos "decoder" e "condlogic", passando alguns dos inputs e algumas das saídas dos sub-módulos para as entradas e saídas do "controller". Em linhas gerais, o objetivo é decodificar a instrução e interpretar as condições em que elas devem ser executadas para elas serem executadas.


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
|![image](https://user-images.githubusercontent.com/66538880/207778472-627997a4-2efe-4d88-89c9-3c36182e290c.png)|![image](https://user-images.githubusercontent.com/66538880/213886168-b97d2c3b-f52d-4fe7-a6bd-a756e09bc3a5.png)|
|-|-|


## Modulo decoder

como entradas, o modulo tem:
<div align="center">
	
|Sinal                      |Descrição                                                  |
|---------------------------|-----------------------------------------------------------|
|"Instr[27:26]" ( $Op$ )    |Indica o tipo de instrução específica está sendo executada |
|"Instr[25:20]" ( $Funct$ ) |Indica informações adicionais sobre a instrução            |
|"Instr[15:12]" ( $Rd$ )    | Registrador destino da instrução                          |

>
</div>

e produz várias saídas: 

<div align="center">

|Sinal       |Descrição                                                                 |
|------------|--------------------------------------------------------------------------|
|FlagW:      |Controla se as flags devem ser atualizadas.                               |
|PCS:        |Controla se o PC deve ser atualizado.                                     |
|RegW:       |Controla se o registrador deve ser escrito.                               |
|MemW:       |Controla se a memória deve ser escrita.                                   |
|MemtoReg:   |Controla se o valor de memória deve ser carregado para o registrador.     |
|ALUSrc:     |Controla se o operando da ALU é proveniente do registrador ou do imediato.|
|ImmSrc:     |Controla qual conjunto de bits do imediato devem ser usados.              |
|RegSrc:     |Controla qual registrador deve ser usado como operando.                   |
|ALUControl: |Controla qual operação a ALU deve realizar.                               |

>
</div>

Além disso, temos os sinais internos do módulo:

<div align="center">

|Sinal       |Descrição                                                                 |
|------------|--------------------------------------------------------------------------|
|Branch:     |Controla se deve haver desvio de fluxo de programa.                       |
|ALUOp:      |Controla se a operação é uma operação de processamento de dados ou não.   |

>
</div>
	
Então, primeiramente declaramos os sinais de entrada e saída, bem como os sinais internos.

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
```

Agora, devemos começar a definir como interpretar os diferentes frames de bits que recebemos. Obviamente, usamos uma estrutura *switch-case* para definir quais serão os 10 bits de saída em função das entradas. Essa lógica **não depende de clock**, por isso é combinacional, *always_comb*. Observe os comentários do código.


```
// Main Decoder
  
  always_comb
  	
	case(Op)
	
	// Caso op = 00 (processamento de dados), temos dois casos: 
  	                        
				// Funct[5] (bit I) = 1 : instrução de processamento de dados com imediato 
  	  2'b00: if (Funct[5])  controls = 10'b0000101001; 
  	                        
				// ou 0 : instrução de processamento de dados com registrador
  	         else           controls = 10'b0000001001; 
  	                        
				
	// Caso op = 01 (memória), temos dois casos: Funct[0] = 1 ou 0 (que é o else)
	
				// Funct[0] (bit L) = 1 : LDR
  	  2'b01: if (Funct[0])  controls = 10'b0001111000; 
  	                        
				// ou 0 : STR
  	         else           controls = 10'b1001110100; 
  	                        
	// Caso op = 10 (branch), temos um caso apenas: branch
				
				// B
  	  2'b10:                controls = 10'b0110100010; 
  	                        
	// Finalmente, qualquer outro valor para OP será "não implementado", retornado 10 bits 'x'
	
				// Unimplemented
  	  default:              controls = 10'bx;          
  	endcase
	
// Aqui, destribuímos os bits nas saídas definidas em um array 'controls'

  assign {RegSrc, ImmSrc, ALUSrc, MemtoReg, RegW, MemW, Branch, ALUOp} = controls; 
     
```

Outro componente sempre combinacional (*always_comb*) é o ALUControl, cujo objetivo é controlar o ALU para executar instruções aritméticas. 


<div align="center">
    <img src= https://user-images.githubusercontent.com/66538880/213918754-0905861c-1e99-4996-b7e4-9896dfe7b505.png >
</div>

Podemos ver que este esse bloco de lógica opera em função de $ALUop$ e $Funct$. Novamente, temos uma estrutura *switch-case*. Observe os comentários no código abaixo.

```
  // ALU Decoder 
            
  always_comb
    
    // Se tivermos uma instrução de processamento de dados que envolva ALU, ALUop = 1
    if (ALUOp) begin
      
      // Aqui, já sabemos que é uma instrução de ALU, precisamos saber qual é e atribuir à 'ALUControl'
      case(Funct[4:1]) 
  	    4'b0100: ALUControl = 2'b00; // ADD
  	    4'b0010: ALUControl = 2'b01; // SUB
            4'b0000: ALUControl = 2'b10; // AND
  	    4'b1100: ALUControl = 2'b11; // ORR
  	    default: ALUControl = 2'bx;  // unimplemented
      endcase
      
      // Aqui, atribuímos ao bit FlagW[1] o valor do bit Funct[0], que é 'S' : 
      // S = 1 —> guardar flags;
      // S = 0 —> ñ guardar flags;
      FlagW[1] = Funct[0];
      
      // Além disso, as flags podem ser obtidas com uma operação de SUB ou ADD;
      // Isso fica armazenado no bit FlagW[0] = 'S-bit' AND ('ADD' OR 'SUB')
      FlagW[0] = Funct[0] & (ALUControl == 2'b00 | ALUControl == 2'b01); 
    
    end else begin
      
      // Se não tivermos uma operação de ALU (ALUop = 0)
      
      ALUControl = 2'b00; // Definimos ALUControl em 'ADD';
      FlagW      = 2'b00; // E não fazemos o update de flag;
      
    end
```
O sub-modulo 'PC Logic' é o último que falta. Nele, entramos com os 4 bits do $Rd$, com o bit de $Branch$ — proveniente do 'main decoder' — e o bit de $RegW$ — também proveniente de 'main decoder'. A saída é o único bit $PCS$, que indica se PC será atualizado ou não. Isso dependerá:

- Se o valor de Rd é igual a 4'b1111 (15 em decimal) e a variável RegW é verdadeira.
- ou Se a variável Branch é verdadeira

<div align="center">
    <img src= https://user-images.githubusercontent.com/66538880/213921301-2d8ef86d-c2f1-4407-a629-9f2faafc0265.png >
</div>

Existem várias maneiras de o valor do PC ser atualizado, como por exemplo, ao executar uma instrução de branch (desvio) ou retorno de chamada de subrotina. Se a instrução atual é um branch, então a variável Branch será verdadeira, e o PC será atualizado com o endereço especificado na instrução de branch. 

Se a instrução atual é uma instrução de retorno de chamada de subrotina, então o registrador Rd terá o valor 4'b1111 e a variável RegW será verdadeira, e o PC será atualizado com o endereço de retorno armazenado em outro registrador.

```
  // PC Logic
  
  // Se Rd for o registrador 15 e tivermos permissão para escrever
  // Se Branch = 1
  
  assign PCS  = ((Rd == 4'b1111) & RegW) | Branch; 
endmodul
```

## Modulo condlogic

O módulo "condlogic" tem por objetivo comparar valores de flags para executar ou não instruções. Recebe os valores de "clk", "reset", pois agora queremos que haja sincronismo com as operações que ocorrem no datapath. Além disso, temos "Instr[31:28]" ( $Cond$ ) e "ALUFlags" como entradas principais, onde ALUFlags é justamente o retorno do módulo ALU.

Os sinais obtidos do decoder, "FlagW", "PCS", "RegW" e "MemW", irão produzir as saídas: "PCSrc", "RegWrite" e "MemWrite", se as condições forem estabelecidas.

<div align="center">
	
|Sinal       |Descrição                                                                 |
|------------|--------------------------------------------------------------------------|
|PCSrc:        |Controla se o PC deve ser atualizado.                                   |
|RegWrite:       |Controla se o registrador deve ser escrito.                           |
|MemWrite:       |Controla se a memória deve ser escrita.                               |
	
>	
</div>

são basicamente os mesmos sinais que entraram, que só serão propagados se as condições forem cumpridas.

<div align="center">
    <img src= https://user-images.githubusercontent.com/66538880/213948155-bf3dd15e-b951-4c6c-8cbb-cf306c251bc6.png >
</div>

Primeiro, declaramos os sinais de entrada e saída, bem como os internos.

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
```
O módulo define primeiro um vetor de 2 bits chamado $FlagWrite$, um vetor de 4 bits chamado $Flags4 e um sinal de 1 bit chamado $CondEx$.

Então ele instancia duas instâncias de um módulo chamado "flopenr", ambos com os mesmos inputs : "clk", "reset", "FlagWrite[0/1]", "ALUFlags[1:0/3:2]" e "Flags[1:0/3:2]". Essas duas instâncias são destinadas a atualizar o vetor "Flags".

Depois invocaremos o módulo "condcheck", tendo como entrada "Cond" e "Flags" e produzindo a saída "CondEx".

Em seguida, na linha seguinte, a saída "FlagWrite" é atribuída como a entrada "FlagW" AND com 2 cópias do sinal "CondEx". A saída "RegWrite" é atribuída como a entrada "RegW" AND com "CondEx" e a saída "MemWrite" é atribuída como a entrada "MemW" AND com "CondEx", a saída "PCSrc" é atribuída como a entrada "PCS" AND com "CondEx"

```
  
  flopenr #(2)flagreg1(clk, reset, FlagWrite[1], ALUFlags[3:2], Flags[3:2]);
  
  flopenr #(2)flagreg0(clk, reset, FlagWrite[0], ALUFlags[1:0], Flags[1:0]);

  // write controls are conditional
  
  condcheck cc(Cond, Flags, CondEx);
  
  assign FlagWrite = FlagW & {2{CondEx}};
  assign RegWrite  = RegW  & CondEx;
  assign MemWrite  = MemW  & CondEx;
  assign PCSrc     = PCS   & CondEx;

endmodule
```

Este módulo está usando a entrada "Cond" para controlar se as saídas "FlagWrite", "RegWrite", "MemWrite" e "PCSrc" estão habilitadas ou não. Se "CondEx" for verdadeiro, então a saída correspondente é habilitada, caso contrário, ela é desabilitada.

Vamos dar uma olhada no módulo 'condcheck'.

### condcheck
```
module condcheck(input  logic [3:0] Cond,
                 input  logic [3:0] Flags,
                 output logic       CondEx);
  
  // cinco sinais internos
  logic neg, zero, carry, overflow, ge;
  

  // aqui criamos as flags
  assign {neg, zero, carry, overflow} = Flags;
  
  // aqui criamos o bit 'greater or equal'
  assign ge = (neg == overflow);
  
  // lembrando que o cond é uma estrutura de 4 bits;
  // abaixo temos a simples atribuição de valores;
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
### flopenr

Por último, mas não menos importante, o sub-modulo invocado duas vezes flopenr é uma implementação de um registrador de deslocamento. Tem uma entrada WIDTH como parâmetro, por padrão, é definido como 8, usado para identificar o tamanho dos sinais de entrada.

O registrador é implementado usando uma porta lógica always com uma cláusula de sincronização @(posedge clk, posedge reset). A porta lógica sempre verifica se o Clock e o reset estão em nível alto. Se o reset estiver em nível alto, o registrador é redefinido para 0. Caso contrário, se o en estiver em nível alto, o dado é escrito no registrador.

> ✩ DICA : 'always_ff' é usado para criar um bloco síncrono de código, sequêncial. Basicamente um flip-flop.

As entradas são:

- en : é um sinal de entrada lógico que habilita ou desabilita a escrita no registrador.
- d : é um sinal de entrada de WIDTH bits, que contém o dado que será escrito no registrador.

E as saídas são:

- q : é um sinal de saída de WIDTH bits, que contém o dado armazenado no registrador.


```
module flopenr #(parameter WIDTH = 8)
                (input  logic clk, reset, en,
                 input  logic [WIDTH-1:0] d, 
                 output logic [WIDTH-1:0] q);

  always_ff @(posedge clk, posedge reset)
    if (reset)   q <= 0;
    else if (en) q <= d;
endmodule
```

|$\leftarrow$ [Datapath](https://github.com/Batchuka/Projeto-ARM-Single-Cycle-IFES/blob/main/Documenta%C3%A7%C3%A3o/2%20%E2%80%94%20ARM%20SINGLE%20CYCLE%20AS-IS/Datapath.md#datapath) | [Sumário](https://github.com/Batchuka/Projeto-ARM-Single-Cycle-IFES#sum%C3%A1rio) | [ARM NOVAS INSTRUÇÕES (TO-BE)](https://github.com/Batchuka/Projeto-ARM-Single-Cycle-IFES/blob/main/Documenta%C3%A7%C3%A3o/3%20%E2%80%94%20AS%20NOVAS%20INSTRU%C3%87%C3%95ES%20TO-BE/AS%20NOVAS%20INSTRU%C3%87%C3%95ES%20TO-BE.md#arm-novas-instru%C3%A7%C3%B5es-to-be) $\rightarrow$|
|-|-|-|
