# Implementando LDRB

- **LDRB** (load byte): Carrega um byte da memória para um registrador. A localização de memória é especificada por um endereço e pode ser deslocada com base em um valor contido em outro registrador.


## LDRB
![image](https://user-images.githubusercontent.com/66538880/207986395-783dd7f1-24c4-4085-acf3-b7d64fa5a8af.png)
![image](https://user-images.githubusercontent.com/66538880/207986422-ec6cfd17-40fd-44fe-b887-34a4becc1186.png)
![image](https://user-images.githubusercontent.com/66538880/207986450-74d5f4e3-81d0-4d16-aca0-ef12794e0d24.png)
![image](https://user-images.githubusercontent.com/66538880/207986469-2eaa85d8-f126-4514-b758-c8c717338f5d.png)


Acontece que o nosso processador não oferece uma forma para podermos obter o valor de um imediato, visto que o datapath sempre utiliza o ALUResult. Para resolver esse problema, adicionamos um mux que é controlado pela flag 'MovFlag'.

* ${MovFlag = 0 \rightarrow }$ a saída a ser considerada é o ALUResult;
* ${MovFlag = 1 \rightarrow }$ a saída a ser considerada é o imediato;

![image](https://user-images.githubusercontent.com/66538880/213033234-13cf85dc-850b-4225-bde3-c3169649be90.png)

Para decodificar uma instrução MOV




|$\leftarrow$ [Lista de instruções](https://github.com/Batchuka/Projeto-ARM-Single-Cycle-IFES/blob/main/Documenta%C3%A7%C3%A3o/2%20%E2%80%94%20ARM%20SINGLE%20CYCLE%20AS-IS/Controller.md#controler) | [Sumário](https://github.com/Batchuka/Projeto-ARM-Single-Cycle-IFES#sum%C3%A1rio) |
|-|-|

