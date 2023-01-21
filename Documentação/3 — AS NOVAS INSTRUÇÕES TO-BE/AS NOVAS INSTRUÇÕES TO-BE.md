# ARM NOVAS INSTRUÇÕES (TO-BE)

Agora temos tudo que precisamos para poder discutir as modificações necessárias para as instruções que queremos implementar. Temos sempre que pensar:

1. O que a instrução faz;
2. O que eu preciso fazer no datapath para que essa instrução ocorra;
3. Como devo configurar os sinais do controller para assionar o datapath corretamente;

Além disso, é preciso ter em mente:

4. Como é frame da instrução — para isso consulte o [Apêndice A](https://github.com/Batchuka/Projeto-ARM-Single-Cycle-IFES/blob/main/Documenta%C3%A7%C3%A3o/1%20%E2%80%94%20INTRODU%C3%87%C3%83O%20e%20APENDICES/A%20%E2%80%94%20FRAME%20DAS%20NOVAS%20INSTRU%C3%87%C3%95ES.md#a---novas-instru%C3%A7%C3%B5es)
5. O que cada sinal de controller faz; e
6. Talvez seja necessário adicionar sinais e até mesmo módulos.

## Os operandos

Para pensar com clareza a respeito de como implementar essas instruções, é importante saber o que não é responsabilidade delas. Tomemos como exemplo a primeira instrução que faremos, MOV. Não é responsabilidade de MOV obter os operandos. Isso pode parecer óbvio, mas é um ideia singela que pode confundir os incaltos: *as instruções partem do pressuposto que os operandos estão disponíveis!* Não há o que se pensar a respeito de como "pegar" a matéria prima para executar a operação, só devemos pensar na operação. Então, precisamos pensar ou levar em consideração os registradores em si, só precisamos dizer se a operação envolve ou não registradores, imediatos, etc.

## O significado de cada sinal de controller

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
|Branch:     |Controla se deve haver desvio de fluxo de programa.                       |
|ALUOp:      |Controla se a operação é uma operação de processamento de dados ou não.   |

> [Implementando MOV](https://github.com/Batchuka/Projeto-ARM-Single-Cycle-IFES/blob/main/Documenta%C3%A7%C3%A3o/3%20%E2%80%94%20AS%20NOVAS%20INSTRU%C3%87%C3%95ES%20TO-BE/mov.md#implementando-mov)

> [Implementando CMP]()

> [Implementando TST]()

> [Implementando MVN]()

> [Implementando EOR]()

Agora vamos para  principal diferença entre LDR e LDRB, e STR e STRB é que as instruções LDR e STR acessam 4 bytes de memória, enquanto LDRB e STRB acessam somente 1 byte.

> [Implementando LSL]()

> [Implementando ASR]()

> [Implementando LDRB]()

> [Implementando STRB]()



A Instrução [CMP](https://github.com/Batchuka/Projeto-ARM-Single-Cycle-IFES/edit/main/Documenta%C3%A7%C3%A3o/1%20%E2%80%94%20INTRODU%C3%87%C3%83O%20e%20APENDICES/A%20%E2%80%94%20FRAME%20DAS%20NOVAS%20INSTRU%C3%87%C3%95ES.md#cmp) (compare), compara dois valores e atualiza os registradores de status N, Z e C para indicar se o primeiro é menor, igual ou maior que o segundo. Assim, precisaremos configurar:

- o sinal $FlagW$ para indicar que as flags devem ser atualizadas;
- o $ALUControl$ para realizar a operação de subtração;
- o sinal $RegWrite$ para não atualizar o registrador e;
- será bom assinalar o sinal $MemtoReg$ para '0', para garantir que o resultado da operação não seja escrito em um endereço de memória. 


```
4'b1010: begin
  ALUControl = 3'b100; // CMP
  NoWrite = 1'b1; // Não escreva o resultado no registrador
end
```

A instrução CMP compara dois operandos e não armazena o resultado, por isso, eu configurei o controlador ALU para realizar uma operação de subtração (que é usada para comparar dois operandos) e configurei a flag NoWrite para 1, para indicar que o resultado não deve ser escrito em um registrador.

```
4'b0101: begin
  ALUControl = 3'b000; // ADD (mas é usado para movimentar)
  NoWrite = 1'b0; // Escreva o resultado no registrador
end
```

A instrução MOV move um operando para outro, então eu configurei o controlador ALU para realizar uma operação de adição (que é usada para copiar um operando para outro registrador), mas eu configurei a flag NoWrite para 0, para indicar que o resultado deve ser escrito em um registrador.

```
4'b0110: begin
  ALUControl = 3'b010; // AND
  NoWrite = 1'b1; // Não escreva o resultado no registrador
end
```

A instrução TST realiza uma operação lógica AND entre dois operandos, mas não armazena o resultado, então eu configurei o controlador ALU para realizar uma operação AND e configurei a flag NoWrite para 1, para indicar que o resultado não deve ser escrito em um registrador.

```
4'b0111: begin
  ALUControl = 3'b011; // ORR (com o operando 2 invertido)
  NoWrite = 1'b0; // Escreva o resultado no registrador
end
```

A instrução MVN inverta o operando e realiza uma operação ORR, então eu configurei o controlador ALU para realizar uma operação ORR com o operando 2 invertido e configurei a flag NoWrite para 0, para indicar que o resultado deve ser escrito em um registrador.

```
4'b1000: begin
  ALUControl = 3'b110; // EOR
  NoWrite = 1'b0; // Escreva o resultado no registrador
end
```

A instrução EOR realiza uma operação lógica XOR entre dois operandos, então eu configurei o controlador ALU para realizar uma operação XOR e configurei a flag NoWrite para 0, para indicar que o resultado deve ser escrito em um registrador.



Este módulo é um registrador deslocamento. Ele tem três entradas: Sh, Shnt e ScrB, e uma saída: shifted. A entrada Sh é usada para especificar se o deslocamento é para a esquerda (LSL) ou para a direita (ASR). A entrada Shnt é usada para especificar a quantidade de bits para deslocar. A entrada ScrB é o valor que será deslocado. A saída shifted é o resultado do deslocamento.

O módulo usa uma lógica combinacional para realizar o deslocamento. Ele verifica se as entradas Sh e Shnt são diferentes de zero, se sim, ele usa um case statement para selecionar qual operação de deslocamento realizar, LSL ou ASR, de acordo com o valor de Sh. Se as entradas Sh e Shnt são igual a zero, ele passa o valor original de ScrB para a saída shifted.



|$\leftarrow$ [Controller](https://github.com/Batchuka/Projeto-ARM-Single-Cycle-IFES/blob/main/Documenta%C3%A7%C3%A3o/2%20%E2%80%94%20ARM%20SINGLE%20CYCLE%20AS-IS/Controller.md#controler) | [Sumário](https://github.com/Batchuka/Projeto-ARM-Single-Cycle-IFES#sum%C3%A1rio) | [?]() $\rightarrow$|
|-|-|-|
