# Implementando MOV

A Instrução MOV, move o valor de uma fonte para um destino. A fonte pode ser um registrador ou o imediato, baseado no que indicar o bit 'I', como se vê no frame:


## ASR
![image](https://user-images.githubusercontent.com/66538880/207986225-74aaf5cc-9b68-4651-aaf3-4d14da0568e8.png)
![image](https://user-images.githubusercontent.com/66538880/207986249-d015a1aa-f11f-4f51-aa6f-fe31c80c0b15.png)


Acontece que o nosso processador não oferece uma forma para podermos obter o valor de um imediato, visto que o datapath sempre utiliza o ALUResult. Para resolver esse problema, adicionamos um mux que é controlado pela flag 'MovFlag'.

* ${MovFlag = 0 \rightarrow }$ a saída a ser considerada é o ALUResult;
* ${MovFlag = 1 \rightarrow }$ a saída a ser considerada é o imediato;

![image](https://user-images.githubusercontent.com/66538880/213033234-13cf85dc-850b-4225-bde3-c3169649be90.png)

Para decodificar uma instrução MOV




|$\leftarrow$ [Lista de instruções](https://github.com/Batchuka/Projeto-ARM-Single-Cycle-IFES/blob/main/Documenta%C3%A7%C3%A3o/2%20%E2%80%94%20ARM%20SINGLE%20CYCLE%20AS-IS/Controller.md#controler) | [Sumário](https://github.com/Batchuka/Projeto-ARM-Single-Cycle-IFES#sum%C3%A1rio) |
|-|-|

