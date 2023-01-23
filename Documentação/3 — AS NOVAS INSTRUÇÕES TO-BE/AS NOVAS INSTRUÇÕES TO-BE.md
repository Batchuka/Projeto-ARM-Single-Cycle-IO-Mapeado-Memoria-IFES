# ARM NOVAS INSTRUÇÕES (TO-BE)

Agora temos tudo que precisamos para poder discutir as modificações necessárias para as instruções que queremos implementar. Temos sempre que pensar:

1. O que a instrução faz;
2. O que eu preciso fazer no datapath para que essa instrução ocorra;
3. Como devo configurar os sinais do controller para assionar o datapath corretamente;

Além disso, é preciso ter em mente:

4. Como é frame da instrução;
5. O que cada sinal de controller faz; e
6. Talvez seja necessário adicionar sinais e até mesmo módulos.

## Os operandos

Para pensar com clareza a respeito de como implementar essas instruções, é importante saber o que não é responsabilidade delas. Tomemos como exemplo a primeira instrução que faremos, MOV. Não é responsabilidade de MOV obter os operandos. Isso pode parecer óbvio, mas é um ideia singela que pode confundir os incaltos: *as instruções partem do pressuposto que os operandos estão disponíveis!* Não há o que se pensar a respeito de como "pegar" a matéria prima para executar a operação, só devemos pensar na operação. Então, precisamos pensar ou levar em consideração os registradores em si, só precisamos dizer se a operação envolve ou não registradores, imediatos, etc.


## Implementando as funções

Primeiro vamos acrescentar as [instruções de processamento de dados](https://github.com/Batchuka/Projeto-ARM-Single-Cycle-IFES/blob/main/Documenta%C3%A7%C3%A3o/1%20%E2%80%94%20INTRODU%C3%87%C3%83O%20e%20APENDICES/TIPOS%20DE%20INSTRU%C3%87%C3%95ES.md#instru%C3%A7%C3%B5es-de-processamento-de-dados), pois são mais fáceis — em muitos casos, verá que é uma extensão natural de outras instruções.

> [Implementando MOV](https://github.com/Batchuka/Projeto-ARM-Single-Cycle-IFES/blob/main/Documenta%C3%A7%C3%A3o/3%20%E2%80%94%20AS%20NOVAS%20INSTRU%C3%87%C3%95ES%20TO-BE/mov.md#implementando-mov)

> [Implementando CMP](https://github.com/Batchuka/Projeto-ARM-Single-Cycle-IFES/blob/main/Documenta%C3%A7%C3%A3o/3%20%E2%80%94%20AS%20NOVAS%20INSTRU%C3%87%C3%95ES%20TO-BE/cmp.md#implementando-cmp)

> [Implementando TST](https://github.com/Batchuka/Projeto-ARM-Single-Cycle-IFES/blob/main/Documenta%C3%A7%C3%A3o/3%20%E2%80%94%20AS%20NOVAS%20INSTRU%C3%87%C3%95ES%20TO-BE/tst.md#implementando-tst)

> [Implementando MVN](https://github.com/Batchuka/Projeto-ARM-Single-Cycle-IFES/blob/main/Documenta%C3%A7%C3%A3o/3%20%E2%80%94%20AS%20NOVAS%20INSTRU%C3%87%C3%95ES%20TO-BE/mvn.md#implementando-mvn)

> [Implementando EOR](https://github.com/Batchuka/Projeto-ARM-Single-Cycle-IFES/blob/main/Documenta%C3%A7%C3%A3o/3%20%E2%80%94%20AS%20NOVAS%20INSTRU%C3%87%C3%95ES%20TO-BE/eor.md#implementando-eor)

Agora vamos para as [instruções de memória](https://github.com/Batchuka/Projeto-ARM-Single-Cycle-IFES/blob/main/Documenta%C3%A7%C3%A3o/1%20%E2%80%94%20INTRODU%C3%87%C3%83O%20e%20APENDICES/TIPOS%20DE%20INSTRU%C3%87%C3%95ES.md#instru%C3%A7%C3%B5es-de-mem%C3%B3ria), que via de regra são mais delicadas. Isso porque precisam de lógica de deslocamento (shift), visto que os endereços de memória que podem ser expressos como um deslocamento a partir de um registrador base, isto é, em vez de especificar o endereço de memória exato, uma instrução de store ou load especifica um registrador base e um deslocamento para 'pivotar'. 

A lógica de deslocamento permite que o processador desloque o valor contido em um registrador para a esquerda ou para a direita, e depois adicione ou subtraia o deslocamento. O deslocamento é geralmente especificado como um valor imediato, mas pode ser especificado como um valor contido em outro registrador. Isso é útil porque permite que o processador acesse diferentes endereços de memória com uma única instrução, enquanto economiza espaço de instrução. Além disso, isso também melhora a performance do sistema, pois o processador não precisa carregar o endereço exato antes de cada operação de store ou load. 

> [Implementando modulo shift register](https://github.com/Batchuka/Projeto-ARM-Single-Cycle-IFES/blob/main/Documenta%C3%A7%C3%A3o/3%20%E2%80%94%20AS%20NOVAS%20INSTRU%C3%87%C3%95ES%20TO-BE/modulo%20shift%20register.md#implementando-modulo-shift-register)

> [Implementando LSL]()

> [Implementando ASR]()

A principal diferença entre LDR e LDRB, e STR e STRB é que as instruções LDR e STR acessam 4 bytes de memória, enquanto LDRB e STRB acessam somente 1 byte.

> [Implementando LDRB]()

> [Implementando STRB]()




|$\leftarrow$ [Controller](https://github.com/Batchuka/Projeto-ARM-Single-Cycle-IFES/blob/main/Documenta%C3%A7%C3%A3o/2%20%E2%80%94%20ARM%20SINGLE%20CYCLE%20AS-IS/Controller.md#controler) | [Sumário](https://github.com/Batchuka/Projeto-ARM-Single-Cycle-IFES#sum%C3%A1rio) | [?]() $\rightarrow$|
|-|-|-|
