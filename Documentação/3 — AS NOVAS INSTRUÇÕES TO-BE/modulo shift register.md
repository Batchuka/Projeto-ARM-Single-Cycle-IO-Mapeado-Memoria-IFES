# Implementando modulo shift register

Este módulo é um registrador deslocamento. Ele tem três entradas: 
- $Sh$ — dois bits
- $Shnt$ — cinco bits
- $ScrB$ — 32 bits, que é o valor a ser operado de fato.

e uma saída:

- $shifted$ 

Antes de mais nada, é importante entender que deslocamento de bits existe em três sabores:

1. Você pode querer a posição de um bit no frame para esquerda ou direita, simplesmente. Isso é chamado de "Logical Shift", porque é uma operação lógica somente, que modifica o valor dos bits de 0 para 1, ou vice-versa. Em outras palavras, entende-se que o conteúdo manipulado é só uma palavra sem valor matemático.
2. Você pode querer a posi


A entrada Sh é usada para especificar se o deslocamento é para a esquerda (LSL) ou para a direita (ASR). A entrada Shnt é usada para especificar a quantidade de bits para deslocar. A entrada ScrB é o valor que será deslocado. A saída shifted é o resultado do deslocamento.

O módulo usa uma lógica combinacional para realizar o deslocamento. Ele verifica se as entradas Sh e Shnt são diferentes de zero, se sim, ele usa um case statement para selecionar qual operação de deslocamento realizar, LSL ou ASR, de acordo com o valor de Sh. Se as entradas Sh e Shnt são igual a zero, ele passa o valor original de ScrB para a saída shifted.



|$\leftarrow$ [Lista de instruções](AS%20NOVAS%20INSTRU%C3%87%C3%95ES%20TO-BE.md) | [Sumário](../../README.md) |
|-|-|

