# Implementando MOV

A Instrução $MOV$, move o valor de uma fonte para um destino. A fonte pode ser um registrador ou o imediato, baseado no que indicar o bit $I$, como se vê nos dois frames abaixo:

|![image](https://user-images.githubusercontent.com/66538880/207912543-ea973fdc-6bf1-44d4-afbc-11b054015c38.png)| ![image](https://user-images.githubusercontent.com/66538880/207912628-35fb79e4-5ffd-408f-bb1a-29935768845d.png)|
|-|-|

## Controller

- $MOV$ não envolve o Hardware $ALU$, por isso não necessita passar pelo $ALU Decoder$;
- Também não tem a ver com instruções de Branch, por isso não passará por $PC Logic$;
- Somente envolve o $Main Decoder$. 
- Apesar disso, queremos que o $MOV$ ocorra baseado em condições, por isso deve estar relacionado ao $Condition Check$

![image](https://user-images.githubusercontent.com/66538880/215270569-fdbb3016-1011-48c4-a1f9-c71a52ec15a7.png)

## Datapath

Já no datapath, nosso processador não oferece uma forma para podermos obter o valor de um imediato $SrcB$ — visto que o datapath sempre utiliza o $ALUResult$. Para resolver esse problema, adicionamos um $mux2$, que é controlado pela flag $MovFlag$.

|![image](https://user-images.githubusercontent.com/66538880/215270879-9790408d-75a2-4552-80d8-fe6d12df7ea8.png)|![image](https://user-images.githubusercontent.com/66538880/215270897-9b2bd52e-1be0-4d6e-ae0a-5d4fd32dbd2d.png)|
|-|-|

* ${MovFlag = 0 \rightarrow }$ a saída a ser considerada é o ALUResult;
* ${MovFlag = 1 \rightarrow }$ a saída a ser considerada é o imediato, $SrcB$;

## Modificações no código

✩ NOTA ✩
> É importante que a ordem da passagem dos argumentos na instancia, respeite a ordem declarada nas macros. Por exemplo, se $clk$ é o primeiro sinal declarado na macro 'controller', ao instanciar um objeto 'controller c', o primeiro argumento passado para ele deve ser $clk$

Primeiro precisamos passar o *novo* sinal $MovFlag$ entre as instancias de módulos 'controller c' e 'datapath dp':

![image](https://user-images.githubusercontent.com/66538880/215271586-9bc3fb6c-6903-4c9e-8ca8-53124ba46a57.png)

Dentro de controller, temos o sinal $MovF$ que é a origem do output $MovFlag$ na macro do controller. Assim, devemos acertar esse sinal e argumento na macro Controller, bem como as instancias 'decoder dec' e 'condlogic cl':

![image](https://user-images.githubusercontent.com/66538880/215272568-66ffd4af-6521-4f4d-ae23-773c85a1c395.png)

Dentro do $Decoder$ acontecem as mudanças mais significativas. Além de declarar o sinal $MovF$:

![image](https://user-images.githubusercontent.com/66538880/215273967-37db1092-7138-49d8-8a82-fdc0387f41ec.png)

Precisamos observar que nosso array $Controls$ sempre assina $ALUOp$ como 1, para instruções de processamento de dados. Assim sendo, mesmo que o MOV não envolva o hardware ALU, o $ALUDecoder$ precisa interpretar esse sinal.

![image](https://user-images.githubusercontent.com/66538880/215273977-4fbf46fe-f825-4c2f-8041-0ad810b75c86.png)

Basicamente, adicionamos a instrução $MOV$ no $ALUDecorder$ o que é errado, visto que é uma lógica do $Main Decoder$

![image](https://user-images.githubusercontent.com/66538880/215274130-d50b617f-bd7e-4cfb-847a-bf24ad6c81b3.png)



|$\leftarrow$ [Lista de instruções](https://github.com/Batchuka/Projeto-ARM-Single-Cycle-IFES/blob/main/Documenta%C3%A7%C3%A3o/3%20%E2%80%94%20AS%20NOVAS%20INSTRU%C3%87%C3%95ES%20TO-BE/AS%20NOVAS%20INSTRU%C3%87%C3%95ES%20TO-BE.md#implementando-as-fun%C3%A7%C3%B5es) | [Sumário](https://github.com/Batchuka/Projeto-ARM-Single-Cycle-IFES#sum%C3%A1rio) |
|-|-|

