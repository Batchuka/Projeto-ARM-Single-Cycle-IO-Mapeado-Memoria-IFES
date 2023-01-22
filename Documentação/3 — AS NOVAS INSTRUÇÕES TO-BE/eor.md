# Implementando EOR

- **EOR** (exclusive or): faz uma operação "OU exclusivo" bit a bit entre dois operandos e armazena o resultado no primeiro operando


## EOR
![image](https://user-images.githubusercontent.com/66538880/207985972-12aa84c0-f8ef-493b-9677-bc90cb0d0b5f.png)
![image](https://user-images.githubusercontent.com/66538880/207985999-eefb1e1f-0ab2-4ed9-9a84-6f893fa5f1b9.png)



```
4'b1000: begin
  ALUControl = 3'b110; // EOR
  NoWrite = 1'b0; // Escreva o resultado no registrador
end
```

A instrução EOR realiza uma operação lógica XOR entre dois operandos, então eu configurei o controlador ALU para realizar uma operação XOR e configurei a flag NoWrite para 0, para indicar que o resultado deve ser escrito em um registrador.



|$\leftarrow$ [Lista de instruções](https://github.com/Batchuka/Projeto-ARM-Single-Cycle-IFES/blob/main/Documenta%C3%A7%C3%A3o/3%20%E2%80%94%20AS%20NOVAS%20INSTRU%C3%87%C3%95ES%20TO-BE/AS%20NOVAS%20INSTRU%C3%87%C3%95ES%20TO-BE.md#implementando-as-fun%C3%A7%C3%B5es) | [Sumário](https://github.com/Batchuka/Projeto-ARM-Single-Cycle-IFES#sum%C3%A1rio) |
|-|-|

