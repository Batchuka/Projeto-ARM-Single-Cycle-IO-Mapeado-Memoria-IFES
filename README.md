
# Sumário

- [PROJETO & OBJETIVO](https://github.com/Batchuka/Projeto-ARM-Single-Cycle-IFES/blob/main/README.md#projeto)

- [ARM SINGLE CYCLE (AS-IS)](https://github.com/Batchuka/Projeto-ARM-Single-Cycle-IFES/blob/main/Documenta%C3%A7%C3%A3o/2%20%E2%80%94%20ARM%20SINGLE%20CYCLE%20AS-IS/2%20%E2%80%94%20ARM%20SINGLE%20CYCLE%20AS-IS.md#arm-single-cycle-as-is)
  - [Datapath](https://github.com/Batchuka/Projeto-ARM-Single-Cycle-IFES/blob/main/Documenta%C3%A7%C3%A3o/2%20%E2%80%94%20ARM%20SINGLE%20CYCLE%20AS-IS/Datapath.md#datapath)
  - [Controller](https://github.com/Batchuka/Projeto-ARM-Single-Cycle-IFES/blob/main/Documenta%C3%A7%C3%A3o/2%20%E2%80%94%20ARM%20SINGLE%20CYCLE%20AS-IS/Controller.md#controler)

- [ARM NOVAS INSTRUÇÕES (TO-BE)](https://github.com/Batchuka/Projeto-ARM-Single-Cycle-IFES/blob/main/Documenta%C3%A7%C3%A3o/3%20%E2%80%94%20AS%20NOVAS%20INSTRU%C3%87%C3%95ES%20TO-BE/3%20%E2%80%94%20AS%20NOVAS%20INSTRU%C3%87%C3%95ES%20TO-BE.md#arm-novas-instru%C3%A7%C3%B5es-to-be)

- [FRAME DAS NOVAS INSTRUÇÕES](https://github.com/Batchuka/Projeto-ARM-Single-Cycle-IFES/blob/main/Documenta%C3%A7%C3%A3o/A%20%E2%80%94%20FRAME%20DAS%20NOVAS%20INSTRU%C3%87%C3%95ES%20-%20Copia.md#a---novas-instru%C3%A7%C3%B5es)


- [TABELA - FRAME VS. COMPOENTE](https://github.com/Batchuka/Projeto-ARM-Single-Cycle-IFES/blob/main/Documenta%C3%A7%C3%A3o/B%20%E2%80%94%20TABELA%20-%20FRAME%20VS.%20COMPOENTE.md#b--tabela---frame-vs-componente)

# PROJETO & OBJETIVO

O projeto em questão é implementação de um ARM 32 bits Single Cycle, capaz de executar as seguintes instruções:

	ADD - DataProcessing
	
	SUB - DataProcessing
	
	AND - DataProcessing
	
	ORR - DataProcessing
	
	LDR - Memory 
  
	STR - Memory 
  
	B - Branch 
  

Ele é baseado no ARM Single-Cycle do livro [*Digital Design and Computer Architecture, ARM Edition*](https://www.amazon.com.br/Digital-Design-Computer-Architecture-English-ebook/dp/B00XHN8RI4/ref=sr_1_3?__mk_pt_BR=%C3%85M%C3%85%C5%BD%C3%95%C3%91&crid=2O6BFDVAZ5RH&keywords=harris+assembly+arm&qid=1672873390&sprefix=harris+assembly+ar%2Caps%2C230&sr=8-3), de Sarah L. Harris e David Harris.

O objetivo é estender a capacidade de instruções a serem executadas por esse processador, tomando como referência a implementação ARM©. AS instruções adicionais serão implementadas no projeto TO-BE, serão elas:

	MOV - DataProcessing
		
Copia o valor de Rd no Operand2.
	
	CMP - DataProcessing
		
Compara o valor de Rn com o Operand2. Setta as flags. Não muda o valor de nenhum registrador parâmetro.
	
	TST - DataProcessing
		
Faz uma operação do tipo ANDS  (comparação bit a bit) mas não modifica o valor de nenhum dos registradores origem, só setta as flags.
	
	EOR - DataProcessing
		
Opera uma comparação bit a bit, OR, Exclusiva, no operador recebedor.
	
	MVN - DataProcessing
		
Pega o valor de Rn, performa uma negação lógica bit a bit e setta no Rd.
	
	LSL - DataProcessing
		
Pega o valor de Rn e multiplica por potências de 2, preechendo o restante com zeros. Aparentemente é a função MOV com shift
	
	ASR - DataProcessing
		
Fornece um valor com sinal do conteúdo do registrador Rd dividido por potências de 2.
	
	LDRB - Memory 
		
Carregar o valor Byte (imediato) 
Calcula um endereço a partir de um valor de registro base e um deslocamento imediato
Carrega bytes da memória
O estende para zero para formar uma palavra de 32 bits e
O grava em um registro. 
Ele pode usar endereçamento offset, pós-indexado ou pré-indexado. 
	
	STRB - Memory

Armazenar byte de registrador (registro);
Calcula um endereço a partir de um valor de registrador base e um valor de registrador de deslocamento 
Armazena um byte de um registrador na memória. 
O valor do registrador de deslocamento pode opcionalmente ser deslocado.


| [sumário](https://github.com/Batchuka/Projeto-ARM-Single-Cycle-IFES#sum%C3%A1rio) | [ARM Single Cycle AS-IS](https://github.com/Batchuka/Projeto-ARM-Single-Cycle-IFES/blob/main/Documenta%C3%A7%C3%A3o/2%20%E2%80%94%20ARM%20SINGLE%20CYCLE%20AS-IS/2%20%E2%80%94%20ARM%20SINGLE%20CYCLE%20AS-IS.md#arm-single-cycle-as-is) $\rightarrow$ |
|-|-|
