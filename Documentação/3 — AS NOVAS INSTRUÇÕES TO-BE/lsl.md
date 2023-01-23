# Implementando LSL

- **LSL** (logical shift left): desloca os bits de um operando para a esquerda por uma determinada quantidade, preenchendo os bits vazios com zeros.


## LSL
![image](https://user-images.githubusercontent.com/66538880/207986139-80130ff1-6ecf-4480-abd4-be6dcc68e471.png)
![image](https://user-images.githubusercontent.com/66538880/207986160-0520caf8-9b33-49a0-a1ae-acb43686d989.png)


Acontece que o nosso processador não oferece uma forma para podermos obter o valor de um imediato, visto que o datapath sempre utiliza o ALUResult. Para resolver esse problema, adicionamos um mux que é controlado pela flag 'MovFlag'.

* ${MovFlag = 0 \rightarrow }$ a saída a ser considerada é o ALUResult;
* ${MovFlag = 1 \rightarrow }$ a saída a ser considerada é o imediato;

![image](https://user-images.githubusercontent.com/66538880/213033234-13cf85dc-850b-4225-bde3-c3169649be90.png)

Para decodificar uma instrução MOV




|$\leftarrow$ [Lista de instruções](https://github.com/Batchuka/Projeto-ARM-Single-Cycle-IFES/blob/main/Documenta%C3%A7%C3%A3o/2%20%E2%80%94%20ARM%20SINGLE%20CYCLE%20AS-IS/Controller.md#controler) | [Sumário](https://github.com/Batchuka/Projeto-ARM-Single-Cycle-IFES#sum%C3%A1rio) |
|-|-|

