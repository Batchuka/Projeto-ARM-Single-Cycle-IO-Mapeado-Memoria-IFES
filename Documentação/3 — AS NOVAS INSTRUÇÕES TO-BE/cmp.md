# Implementando CMP

**CMP** (compare), compara dois valores e atualiza os registradores de status N, Z e C para indicar se o primeiro é menor, igual ou maior que o segundo. Então, se eu quero ampliar a quantidade de operações que o meu hardware ALU executa, primeiro eu preciso aumentar a quantidade de operações que ele suporta. Isso significa que teremos que alterar a lógica do ALU Decoder para que um número maior de instruções possam ser decodificadas.

## CMP
![image](https://user-images.githubusercontent.com/66538880/207985785-60acf438-9fd4-4fd3-9a87-9004325fb854.png)
![image](https://user-images.githubusercontent.com/66538880/207985811-e11e54b8-ee15-402f-a1cf-15bda3063a92.png)

A Instrução CMP (compare), compara dois valores e atualiza os registradores de status N, Z e C para indicar se o primeiro é menor, igual ou maior que o segundo. Assim, precisaremos configurar:

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



|$\leftarrow$ [Lista de instruções](https://github.com/Batchuka/Projeto-ARM-Single-Cycle-IFES/blob/main/Documenta%C3%A7%C3%A3o/3%20%E2%80%94%20AS%20NOVAS%20INSTRU%C3%87%C3%95ES%20TO-BE/AS%20NOVAS%20INSTRU%C3%87%C3%95ES%20TO-BE.md#implementando-as-fun%C3%A7%C3%B5es) | [Sumário](https://github.com/Batchuka/Projeto-ARM-Single-Cycle-IFES#sum%C3%A1rio) |
|-|-|

