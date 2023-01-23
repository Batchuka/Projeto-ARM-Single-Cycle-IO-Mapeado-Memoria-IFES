# Implementando STRB


- **STRB** (store byte): armazena o valor contido em um registrador em uma localização de memória especificada. A localização de memória é especificada por um endereço e pode ser deslocada com base em um valor contido em outro registrador.


## STRB
![image](https://user-images.githubusercontent.com/66538880/207985656-fcdf5a10-e41c-4662-b0d0-a74e32d9ea63.png)
![image](https://user-images.githubusercontent.com/66538880/207985720-7f56fc35-a5dd-4947-b5d3-0ea64ab169a8.png)
![image](https://user-images.githubusercontent.com/66538880/207986329-06c704b2-0017-4de6-b44e-eebcb662787a.png)
![image](https://user-images.githubusercontent.com/66538880/207986352-fc82cb41-ca31-4635-be2c-ef2217cac3e9.png)


Acontece que o nosso processador não oferece uma forma para podermos obter o valor de um imediato, visto que o datapath sempre utiliza o ALUResult. Para resolver esse problema, adicionamos um mux que é controlado pela flag 'MovFlag'.

* ${MovFlag = 0 \rightarrow }$ a saída a ser considerada é o ALUResult;
* ${MovFlag = 1 \rightarrow }$ a saída a ser considerada é o imediato;

![image](https://user-images.githubusercontent.com/66538880/213033234-13cf85dc-850b-4225-bde3-c3169649be90.png)

Para decodificar uma instrução MOV




|$\leftarrow$ [Lista de instruções](https://github.com/Batchuka/Projeto-ARM-Single-Cycle-IFES/blob/main/Documenta%C3%A7%C3%A3o/3%20%E2%80%94%20AS%20NOVAS%20INSTRU%C3%87%C3%95ES%20TO-BE/AS%20NOVAS%20INSTRU%C3%87%C3%95ES%20TO-BE.md#implementando-as-fun%C3%A7%C3%B5es) | [Sumário](https://github.com/Batchuka/Projeto-ARM-Single-Cycle-IFES#sum%C3%A1rio) |
|-|-|

