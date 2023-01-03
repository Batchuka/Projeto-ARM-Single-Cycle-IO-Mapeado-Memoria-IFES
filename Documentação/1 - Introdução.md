# Summary
[1. ARM SINGLE CYCLE (AS-IS)](https://github.com/Batchuka/Projeto-ARM-Single-Cycle-IFES/edit/main/README.md#1--arm-single-cycle-as-is)

[2. ARM NOVAS INSTRUÇÕES (TO-BE)](https://github.com/Batchuka/Projeto-ARM-Single-Cycle-IFES/edit/main/README.md#2--arm-novas-instru%C3%A7%C3%B5es-to-be)

[3. TABELA DE SINAIS SUGERIDA](https://github.com/Batchuka/Projeto-ARM-Single-Cycle-IFES/edit/main/README.md#tabela-de-sinais-sugerida)


# 1 — ARM SINGLE CYCLE (AS-IS)

O processador desenvolvido nesse projeto trata-se de um ARM 32 bits — isto é, suas instruções possuem frames de 32 bits. A interpretação desses frames por parte do hardware pode ser entendido se pensarmos em dois grandes fluxos de sinal: 

- Datapath;
- Control;

O **Datapath** representa todos os barramentos por onde sinais de dados podem passar. Aqui, é importante que se diga que o projeto atual implementa um single-cycle baseado na arquitetura de Harvard — isto é, a memória de instrução está separada da memória de dados. Já o **Control**, é basicamente o núcleo que é responsável por acionar ou desligar os blocos de circuitarias combinacioais, multiplexadores e alguns registradores (PC, no caso do Single-Cycle). 

É fundamental entender a responsabilidade de cada um desses blocos e o que se espera que façam. É fundamental entender, também, como são construídas as instruções ARM. Discorrerei sobre esses dois temas a seguir.

## 1.1 — Datapath

obs.: recomenda-se a leitura dessa parte observando-se atentamente a imagem do Single-Cycle. A explicação será dada da esquerda para direita.

![image](https://user-images.githubusercontent.com/66538880/207740061-8f0d0103-c168-4f40-9c23-eaceb51ebaaa.png)


### 1.1.1 — PC

PC é um registrador que guarda o endereço de memória da próxima instrução a ser execudada. O barramento de saída do PC é conectado diretamente ao *Instruction Memory*. 

### 1.1.2 — Instruction Memory

É uma memória que guarda as instruções a serem executadas. Para acessar essas instruções, devemos saber o endereço delas — fornecido pelo PC. O ato de emputar um endereço para obter o frame da instrução, dá-se o nome de *fetch* da instrução. O barramento de saída desta memória será chamado *Instr*. Muitos blocos utilizam este frame, cada uma deles se interessa por um pedaço específico dos 32 bits. Sendo assim, farei uma breve digressão para explicar os diferentes frames de instrução que podemos ter.

### 1.1.3 — Os 3 tipos de *Instr* pertinentes

Atualmente, existem 9 formas diferentes de estruturar [Frames de instruções](https://developer.arm.com/documentation/dui0068/b/ARM-Instruction-Reference) propostos pela Arm© Corporation. Neste projeto, para as instruções que pretendemos implementar ou que já estão implementadas, só importam 3 estruturas, a saber:

#### 1.1.3.1 — Instruções de Processamento de dados;

>![image](https://user-images.githubusercontent.com/66538880/207770745-1a78fc26-88ab-47f5-9618-b26d150adb99.png)

Onde *Src2* — o terceiro parâmetro — assume um, e somente uma, das 3 formas:
1. imediato, quando $I = 1$; 
2. registrador, $R_m$ , pivotado por uma constante (shamt5) ou;
3. registrador, $R_m$ , pivotado por outro registrador, $R_s$.

> ![image](https://user-images.githubusercontent.com/66538880/207770965-fc9b2a22-d6e1-4ab7-a03f-379f460deb45.png)



#### 1.1.3.2 — Instruções de Memória;

> ![image](https://user-images.githubusercontent.com/66538880/207771611-5fe7ffae-1399-4e08-b6b4-51b01f0980d9.png)

Onde os bits 25:20 formam o *funct* e podemos modificar Src2 com base no fato de haver ou não imediato.

> ![image](https://user-images.githubusercontent.com/66538880/207771631-bdc411f2-07dd-4071-bce0-10170585d319.png)

Onde os bits 25:20 formam o *funct* e podmeos modificar Src2b com base no fato de haver ou não imediato.

#### 1.1.3.3 — Instruções de Branch;

> ![image](https://user-images.githubusercontent.com/66538880/207771086-25546d27-8b9b-4451-9a11-4fe4483b04e2.png)

onde L define se teremos branch com Label ou não.

### 1.1.4 — Register File

Sendo assim, a divisão dos 32 bits sempre se dará da maneira demonstrada na imagem. O cabeçalho de *Instr* bem como o registrador de destino servem de input para o fluxo *Control*, que explicarei mais adiante. Palavras de 4-bit para representarem registradores source são ligados ao inputs do *Register File*, esse sinais só serão ativados caso ${RegSrc}$ permita. Temos dois outputs importantes, dois ${ReadData}$, que alimentam o bloco ALU.

### 1.1.5 — Extend

É possível usar um valor de 32-bit de um registrador como offset para um outro registrador, que guarda outro valor 32-bit. Entretanto, seria útil se tivéssemos como por esse offset na própria declaração Assembly, como imediato. O problema disso é que o frame em si possui 32 bit, logo estaríamos limitados a usar um offset de ${Instr}_{11:0}$. É para resolver essa limitação que temos o *Extend*. Ele é capaz de produzir um ${SrcB}$ com 32-bit simplesmente preenchendo o imediato com tantos zeros quanto necessário para que o ALU possa processar.

### 1.1.6 — ALU

Assim, o ALU recebe dois operandos: ${SrcA}$, proveniente do *Register File* e ${SrcB}$, que pode ser do *Register File* ou do *Extend*. O ALU gera um valor de 32-bit chamado de ${ALUResult}$, que poderá ser um endereço de memória ou dados.

### 1.1.7 — Data Memory

${ALUResult}$ fornecer endereço, queremos ler dados. Quando fornecer dados, queremos gravar na memória. ${WriteEnable}$ é o sinal que controla essa dança. Finalmente, o que temos é o ${Result}$ que poderá ser ${ALUResult}$ ou ${ReadData}$ do *Data Memory*.

## 1.2 — Control

O *control* é a circuitaria, majoritariamente, combinacional —  em grande parte, não depende do clock — para orquestrar os estados dos circuitos que compôem o *Datapath*. Ele, somente depende do: 
- Cabeçalho da instrução;
- Registrador de destino, $Rd$ ; e
- Flags

O controle tem dois sub-blocos, o ${Decoder}$  que é responsável por gerar os sinais de controle com base no cabeçalho e ${Conditional Logic}$, que mantém o valor das flags e executa baseado em condições relacionadas a elas.

### 1.2.1 — Decoder

É constituído pelo *Main Decoder* que é o principal gerador de sinais para controle e o *ALUDecoder*, que usará o campo ${Funct}$ para determinar o tipo de instrução *Data-processing*. Há também um controle para atualizar o valor de PC, chamado ${PCSrc}$. Considerando que são circuitos combinacionais, temos a vantagem de poder usar tabelas-verdade para sua implementação.

![image](https://user-images.githubusercontent.com/66538880/207778472-627997a4-2efe-4d88-89c9-3c36182e290c.png)

### 1.2.2 — Conditional Check

O que é produzido pelo *Decoder* não necessariamente é transmitido, pois há condições para a execução de uma instrução em muitos casos. Com efeito, a interpretação das instuções fica em prontidão para transmissão a depender do sinal ${CondEx}$ que "abre as portas" para os outros sinais condicionalmente. *Conditional Check* depende do clock, o que faz sentido visto que são comandos que devem ser dados de maneira sincronizada ao estado arquitetural do *Datapath*.

![image](https://user-images.githubusercontent.com/66538880/207780798-e3ca60fe-f899-4d81-a8c1-e1001fb9107d.png)

# 2 — ARM NOVAS INSTRUÇÕES (TO-BE)

Agora temos tudo que precisamos para poder discutir as modificações necessárias para as instruções que queremos implementar. O primeiro passo é saber exatamente como é o frame de cada uma dessas instruções

## 2.1 — MOV

![image](https://user-images.githubusercontent.com/66538880/207912543-ea973fdc-6bf1-44d4-afbc-11b054015c38.png)
![image](https://user-images.githubusercontent.com/66538880/207912628-35fb79e4-5ffd-408f-bb1a-29935768845d.png)

## 2.2 — CMP
![image](https://user-images.githubusercontent.com/66538880/207985785-60acf438-9fd4-4fd3-9a87-9004325fb854.png)
![image](https://user-images.githubusercontent.com/66538880/207985811-e11e54b8-ee15-402f-a1cf-15bda3063a92.png)

## 2.3 — TST
![image](https://user-images.githubusercontent.com/66538880/207985875-7fed8114-cd1d-4a5c-862f-6c3a2f7d7035.png)
![image](https://user-images.githubusercontent.com/66538880/207985902-50b8ea05-cc96-4173-aab5-78ba743f878e.png)

## 2.4 — EOR
![image](https://user-images.githubusercontent.com/66538880/207985972-12aa84c0-f8ef-493b-9677-bc90cb0d0b5f.png)
![image](https://user-images.githubusercontent.com/66538880/207985999-eefb1e1f-0ab2-4ed9-9a84-6f893fa5f1b9.png)

## 2.5 — MVN
![image](https://user-images.githubusercontent.com/66538880/207986045-8486a762-1756-41bc-9d98-875c43237750.png)
![image](https://user-images.githubusercontent.com/66538880/207986076-de96426f-475c-4337-bf6b-989c94f26622.png)

## 2.6 — LSL
![image](https://user-images.githubusercontent.com/66538880/207986139-80130ff1-6ecf-4480-abd4-be6dcc68e471.png)
![image](https://user-images.githubusercontent.com/66538880/207986160-0520caf8-9b33-49a0-a1ae-acb43686d989.png)

## 2.7 — ASR
![image](https://user-images.githubusercontent.com/66538880/207986225-74aaf5cc-9b68-4651-aaf3-4d14da0568e8.png)
![image](https://user-images.githubusercontent.com/66538880/207986249-d015a1aa-f11f-4f51-aa6f-fe31c80c0b15.png)


## 2.8 — LDRB
![image](https://user-images.githubusercontent.com/66538880/207986395-783dd7f1-24c4-4085-acf3-b7d64fa5a8af.png)
![image](https://user-images.githubusercontent.com/66538880/207986422-ec6cfd17-40fd-44fe-b887-34a4becc1186.png)
![image](https://user-images.githubusercontent.com/66538880/207986450-74d5f4e3-81d0-4d16-aca0-ef12794e0d24.png)
![image](https://user-images.githubusercontent.com/66538880/207986469-2eaa85d8-f126-4514-b758-c8c717338f5d.png)

## 2.9 — STRB
![image](https://user-images.githubusercontent.com/66538880/207985656-fcdf5a10-e41c-4662-b0d0-a74e32d9ea63.png)
![image](https://user-images.githubusercontent.com/66538880/207985720-7f56fc35-a5dd-4947-b5d3-0ea64ab169a8.png)
![image](https://user-images.githubusercontent.com/66538880/207986329-06c704b2-0017-4de6-b44e-eebcb662787a.png)
![image](https://user-images.githubusercontent.com/66538880/207986352-fc82cb41-ca31-4635-be2c-ef2217cac3e9.png)

# TABELA DE SINAIS SUGERIDA

![image](https://user-images.githubusercontent.com/66538880/207990174-2ba57a76-1611-42e4-95b8-4bff6d1f7c4f.png)

