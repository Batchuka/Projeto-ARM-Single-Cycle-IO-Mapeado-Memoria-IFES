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

##

# TABELA DE SINAIS SUGERIDA

