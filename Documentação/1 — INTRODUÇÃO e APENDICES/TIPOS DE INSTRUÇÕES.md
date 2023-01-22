# TIPOS DE INSTRUÇÕES

O *Instruction Memory* é uma memória que guarda as instruções a serem executadas. Para acessar essas instruções, devemos saber o endereço delas — fornecido pelo PC. O ato de imputar um endereço para obter o frame da instrução, dá-se o nome de *fetch* da instrução. O barramento de saída desta memória será chamado *Instr*. Muitos blocos utilizam este frame, cada uma deles se interessa por um pedaço específico dos 32 bits. Sendo assim, farei uma breve digressão para explicar os diferentes frames de instrução que podemos ter.

## Os 3 tipos de *Instr* pertinentes

Atualmente, existem 9 formas diferentes de estruturar [Frames de instruções](https://developer.arm.com/documentation/dui0068/b/ARM-Instruction-Reference) propostos pela Arm© Corporation. Neste projeto, para as instruções que pretendemos implementar ou que já estão implementadas, só importam 3 estruturas, a saber:


### Instruções de Processamento de dados;

>![image](https://user-images.githubusercontent.com/66538880/207770745-1a78fc26-88ab-47f5-9618-b26d150adb99.png)

Onde *Src2* — o terceiro parâmetro — assume um, e somente uma, das 3 formas:
1. imediato, quando $I = 1$; 
2. registrador, $R_m$ , pivotado por uma constante (shamt5) ou;
3. registrador, $R_m$ , pivotado por outro registrador, $R_s$.

> ![image](https://user-images.githubusercontent.com/66538880/207770965-fc9b2a22-d6e1-4ab7-a03f-379f460deb45.png)

### Instruções de Memória;

> ![image](https://user-images.githubusercontent.com/66538880/207771611-5fe7ffae-1399-4e08-b6b4-51b01f0980d9.png)

Onde os bits 25:20 formam o *funct* e podemos modificar Src2 com base no fato de haver ou não imediato.

> ![image](https://user-images.githubusercontent.com/66538880/207771631-bdc411f2-07dd-4071-bce0-10170585d319.png)

Onde os bits 25:20 formam o *funct* e podmeos modificar Src2b com base no fato de haver ou não imediato.


### Instruções de Branch;

> ![image](https://user-images.githubusercontent.com/66538880/207771086-25546d27-8b9b-4451-9a11-4fe4483b04e2.png)

onde L define se teremos branch com Label ou não.



