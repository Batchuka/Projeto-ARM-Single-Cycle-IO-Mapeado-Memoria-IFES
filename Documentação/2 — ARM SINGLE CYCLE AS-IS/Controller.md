
# CONTROLER

## 2.2 — Control

Esse é o código de um módulo SystemVerilog chamado "controller". Este módulo é usado para controlar o fluxo de dados e as operações do processador em um modelo em linguagem de hardware descritiva de um processador ARM. Ele tem entradas lógicas para clock (clk), reset, instrução (Instr) e flags de ALU (ALUFlags), bem como várias saídas lógicas que são usadas para controlar o funcionamento do processador.

O módulo "controller" instancia outro módulo, chamado "decoder", que é responsável por decodificar a instrução fornecida e produzir sinais de controle adequados. O módulo "condlogic" é usado para implementar a lógica de condição do processador. Juntos, os módulos "controller", "decoder" e "condlogic" implementam a lógica de controle do processador ARM.

O *control* é a circuitaria, majoritariamente, combinacional —  em grande parte, não depende do clock — para orquestrar os estados dos circuitos que compôem o *Datapath*. Ele, somente depende do: 
- Cabeçalho da instrução;
- Registrador de destino, $Rd$ ; e
- Flags

O controle tem dois sub-blocos, o ${Decoder}$  que é responsável por gerar os sinais de controle com base no cabeçalho e ${Conditional Logic}$, que mantém o valor das flags e executa baseado em condições relacionadas a elas.

### 2.2.1 — Decoder

É constituído pelo *Main Decoder* que é o principal gerador de sinais para controle e o *ALUDecoder*, que usará o campo ${Funct}$ para determinar o tipo de instrução *Data-processing*. Há também um controle para atualizar o valor de PC, chamado ${PCSrc}$. Considerando que são circuitos combinacionais, temos a vantagem de poder usar tabelas-verdade para sua implementação.

![image](https://user-images.githubusercontent.com/66538880/207778472-627997a4-2efe-4d88-89c9-3c36182e290c.png)

### 2.2.2 — Conditional Check

O que é produzido pelo *Decoder* não necessariamente é transmitido, pois há condições para a execução de uma instrução em muitos casos. Com efeito, a interpretação das instuções fica em prontidão para transmissão a depender do sinal ${CondEx}$ que "abre as portas" para os outros sinais condicionalmente. *Conditional Check* depende do clock, o que faz sentido visto que são comandos que devem ser dados de maneira sincronizada ao estado arquitetural do *Datapath*.

![image](https://user-images.githubusercontent.com/66538880/207780798-e3ca60fe-f899-4d81-a8c1-e1001fb9107d.png)

$\leftarrow$ [voltar](https://github.com/Batchuka/Projeto-ARM-Single-Cycle-IFES#sum%C3%A1rio)
