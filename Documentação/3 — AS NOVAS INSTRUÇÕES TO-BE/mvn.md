# Implementando MVN

- **MVN** (move not): move o valor de negação de uma fonte para um destino.

## MVN
![image](https://user-images.githubusercontent.com/66538880/207986045-8486a762-1756-41bc-9d98-875c43237750.png)
![image](https://user-images.githubusercontent.com/66538880/207986076-de96426f-475c-4337-bf6b-989c94f26622.png)

```
4'b0111: begin
  ALUControl = 3'b011; // ORR (com o operando 2 invertido)
  NoWrite = 1'b0; // Escreva o resultado no registrador
end
```

A instrução MVN inverta o operando e realiza uma operação ORR, então eu configurei o controlador ALU para realizar uma operação ORR com o operando 2 invertido e configurei a flag NoWrite para 0, para indicar que o resultado deve ser escrito em um registrador.




|$\leftarrow$ [Lista de instruções](https://github.com/Batchuka/Projeto-ARM-Single-Cycle-IFES/blob/main/Documenta%C3%A7%C3%A3o/3%20%E2%80%94%20AS%20NOVAS%20INSTRU%C3%87%C3%95ES%20TO-BE/AS%20NOVAS%20INSTRU%C3%87%C3%95ES%20TO-BE.md#implementando-as-fun%C3%A7%C3%B5es) | [Sumário](https://github.com/Batchuka/Projeto-ARM-Single-Cycle-IFES#sum%C3%A1rio) |
|-|-|

