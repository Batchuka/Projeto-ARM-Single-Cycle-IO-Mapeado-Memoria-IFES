# Introdução

A partir de agora, irei explicar o [projeto AS-IS](https://github.com/Batchuka/Projeto-ARM-Single-Cycle-IFES/blob/main/ArmSingleCycle/arm_single_AS_IS.sv) do ARM. O projeto é baseado no ARM Single-Cycle do livro [*Digital Design and Computer Architecture, ARM Edition*](https://www.amazon.com.br/Digital-Design-Computer-Architecture-English-ebook/dp/B00XHN8RI4/ref=sr_1_3?__mk_pt_BR=%C3%85M%C3%85%C5%BD%C3%95%C3%91&crid=2O6BFDVAZ5RH&keywords=harris+assembly+arm&qid=1672873390&sprefix=harris+assembly+ar%2Caps%2C230&sr=8-3), de Sarah L. Harris e David Harris.

# Sumário

- [INTRODUÇÃO](https://github.com/Batchuka/Projeto-ARM-Single-Cycle-IFES/blob/main/Documenta%C3%A7%C3%A3o/1%20%E2%80%94%20INTRODU%C3%87%C3%83O%20e%20APENDICES/1%20%E2%80%94%20INTRODU%C3%87%C3%83O.md#1--introdu%C3%A7%C3%A3o)

- [ARM SINGLE CYCLE (AS-IS)](https://github.com/Batchuka/Projeto-ARM-Single-Cycle-IFES/blob/main/Documenta%C3%A7%C3%A3o/2%20%E2%80%94%20ARM%20SINGLE%20CYCLE%20AS-IS/2%20%E2%80%94%20ARM%20SINGLE%20CYCLE%20AS-IS.md#arm-single-cycle-as-is)
  - [Datapath](https://github.com/Batchuka/Projeto-ARM-Single-Cycle-IFES/blob/main/Documenta%C3%A7%C3%A3o/2%20%E2%80%94%20ARM%20SINGLE%20CYCLE%20AS-IS/Datapath.md#datapath)
  - [Controller](https://github.com/Batchuka/Projeto-ARM-Single-Cycle-IFES/blob/main/Documenta%C3%A7%C3%A3o/2%20%E2%80%94%20ARM%20SINGLE%20CYCLE%20AS-IS/Controller.md#controler)

- [ARM NOVAS INSTRUÇÕES (TO-BE)](https://github.com/Batchuka/Projeto-ARM-Single-Cycle-IFES/blob/main/Documenta%C3%A7%C3%A3o/3%20%E2%80%94%20AS%20NOVAS%20INSTRU%C3%87%C3%95ES%20TO-BE.md#3--arm-novas-instru%C3%A7%C3%B5es-to-be)

- [FRAME DAS NOVAS INSTRUÇÕES](https://github.com/Batchuka/Projeto-ARM-Single-Cycle-IFES/blob/main/Documenta%C3%A7%C3%A3o/A%20%E2%80%94%20FRAME%20DAS%20NOVAS%20INSTRU%C3%87%C3%95ES%20-%20Copia.md#a---novas-instru%C3%A7%C3%B5es)


- [TABELA - FRAME VS. COMPOENTE](https://github.com/Batchuka/Projeto-ARM-Single-Cycle-IFES/blob/main/Documenta%C3%A7%C3%A3o/B%20%E2%80%94%20TABELA%20-%20FRAME%20VS.%20COMPOENTE.md#b--tabela---frame-vs-componente)
