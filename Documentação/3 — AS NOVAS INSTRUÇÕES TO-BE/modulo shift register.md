# Implementando modulo shift register

Este módulo é um registrador deslocamento. Ele tem três entradas: Sh, Shnt e ScrB, e uma saída: shifted. A entrada Sh é usada para especificar se o deslocamento é para a esquerda (LSL) ou para a direita (ASR). A entrada Shnt é usada para especificar a quantidade de bits para deslocar. A entrada ScrB é o valor que será deslocado. A saída shifted é o resultado do deslocamento.

O módulo usa uma lógica combinacional para realizar o deslocamento. Ele verifica se as entradas Sh e Shnt são diferentes de zero, se sim, ele usa um case statement para selecionar qual operação de deslocamento realizar, LSL ou ASR, de acordo com o valor de Sh. Se as entradas Sh e Shnt são igual a zero, ele passa o valor original de ScrB para a saída shifted.



|$\leftarrow$ [Lista de instruções](https://github.com/Batchuka/Projeto-ARM-Single-Cycle-IFES/blob/main/Documenta%C3%A7%C3%A3o/3%20%E2%80%94%20AS%20NOVAS%20INSTRU%C3%87%C3%95ES%20TO-BE/AS%20NOVAS%20INSTRU%C3%87%C3%95ES%20TO-BE.md#implementando-as-fun%C3%A7%C3%B5es) | [Sumário](https://github.com/Batchuka/Projeto-ARM-Single-Cycle-IFES#sum%C3%A1rio) |
|-|-|

