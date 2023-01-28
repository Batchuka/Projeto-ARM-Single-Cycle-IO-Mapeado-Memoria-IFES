# Implementando TST

- **TST** (test): faz uma operação "E" bit a bit entre um operando e os registradores de status e atualiza os registradores de status N, Z

## TST
![image](https://user-images.githubusercontent.com/66538880/207985875-7fed8114-cd1d-4a5c-862f-6c3a2f7d7035.png)
![image](https://user-images.githubusercontent.com/66538880/207985902-50b8ea05-cc96-4173-aab5-78ba743f878e.png)

Acontece que o nosso processador não oferece uma forma para podermos obter o valor de um imediato, visto que o datapath sempre utiliza o ALUResult. Para resolver esse problema, adicionamos um mux que é controlado pela flag 'MovFlag'.

* ${MovFlag = 0 \rightarrow }$ a saída a ser considerada é o ALUResult;
* ${MovFlag = 1 \rightarrow }$ a saída a ser considerada é o imediato;

![image](https://user-images.githubusercontent.com/66538880/213033234-13cf85dc-850b-4225-bde3-c3169649be90.png)

Para decodificar uma instrução MOV


```
4'b0110: begin
  ALUControl = 3'b010; // AND
  NoWrite = 1'b1; // Não escreva o resultado no registrador
end
```

A instrução TST realiza uma operação lógica AND entre dois operandos, mas não armazena o resultado, então eu configurei o controlador ALU para realizar uma operação AND e configurei a flag NoWrite para 1, para indicar que o resultado não deve ser escrito em um registrador.


|$\leftarrow$ [Lista de instruções](https://github.com/Batchuka/Projeto-ARM-Single-Cycle-IFES/blob/main/Documenta%C3%A7%C3%A3o/3%20%E2%80%94%20AS%20NOVAS%20INSTRU%C3%87%C3%95ES%20TO-BE/AS%20NOVAS%20INSTRU%C3%87%C3%95ES%20TO-BE.md#implementando-as-fun%C3%A7%C3%B5es) | [Sumário](https://github.com/Batchuka/Projeto-ARM-Single-Cycle-IFES#sum%C3%A1rio) |
|-|-|

