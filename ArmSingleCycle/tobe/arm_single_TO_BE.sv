// arm_single.sv MAIN
// David_Harris@hmc.edu and Sarah_Harris@hmc.edu 25 June 2013
// Single-cycle implementation of a subset of ARMv4
// 
// run 210
// Expect simulator to print "Simulation succeeded"
// when the value 7 is written to address 100 (0x64)

// 16 32-bit registers
// Data-processing instructions
//   ADD, SUB, AND, ORR
//   INSTR<cond><S> rd, rn, #immediate
//   INSTR<cond><S> rd, rn, rm
//    rd <- rn INSTR rm	      if (S) Update Status Flags
//    rd <- rn INSTR immediate	if (S) Update Status Flags
//   Instr[31:28] = cond
//   Instr[27:26] = op = 00
//   Instr[25:20] = funct
//                  [25]:    1 for immediate, 0 for register
//                  [24:21]: 0100 (ADD) / 0010 (SUB) /
//                           0000 (AND) / 1100 (ORR)
//                  [20]:    S (1 = update CPSR status Flags)
//   Instr[19:16] = rn
//   Instr[15:12] = rd
//   Instr[11:8]  = 0000
//   Instr[7:0]   = imm8      (for #immediate type) / 
//                  {0000,rm} (for register type)
//   
// Load/Store instructions
//   LDR, STR
//   INSTR rd, [rn, #offset]
//    LDR: rd <- Mem[rn+offset]
//    STR: Mem[rn+offset] <- rd
//   Instr[31:28] = cond
//   Instr[27:26] = op = 01 
//   Instr[25:20] = funct
//                  [25]:    0 (A)
//                  [24:21]: 1100 (P/U/B/W)
//                  [20]:    L (1 for LDR, 0 for STR)
//   Instr[19:16] = rn
//   Instr[15:12] = rd
//   Instr[11:0]  = imm12 (zero extended)
//
// Branch instruction (PC <= PC + offset, PC holds 8 bytes past Branch Instr)
//   B
//   B target
//    PC <- PC + 8 + imm24 << 2
//   Instr[31:28] = cond
//   Instr[27:25] = op = 10
//   Instr[25:24] = funct
//                  [25]: 1 (Branch)
//                  [24]: 0 (link)
//   Instr[23:0]  = imm24 (sign extend, shift left 2)
//   Note: no Branch delay slot on ARM
//
// Other:
//   R15 reads as PC+8
//   Conditional Encoding
//    cond  Meaning                       Flag
//    0000  Equal                         Z = 1
//    0001  Not Equal                     Z = 0
//    0010  Carry Set                     C = 1
//    0011  Carry Clear                   C = 0
//    0100  Minus                         N = 1
//    0101  Plus                          N = 0
//    0110  Overflow                      V = 1
//    0111  No Overflow                   V = 0
//    1000  Unsigned Higher               C = 1 & Z = 0
//    1001  Unsigned Lower/Same           C = 0 | Z = 1
//    1010  Signed greater/equal          N = V
//    1011  Signed less                   N != V
//    1100  Signed greater                N = V & Z = 0
//    1101  Signed less/equal             N != V | Z = 1
//    1110  Always                        any

module testbench();

  logic        clk;
  logic        reset;

  logic [31:0] WriteData, DataAdr;
  logic        MemWrite;

  // instantiate device to be tested
  top dut(clk, reset, WriteData, DataAdr, MemWrite);
  
  initial@(posedge clk)
	begin
	$display(" ");
	$display(" ");
	$display("______ INÍCIO DO DISPOSITIVO ______");
	$display("___________________________________");
	$display(" ");
	$display(" ");
	$display("______ CLOCK + ______");
	end

  // initialize test
  initial
    begin
      reset <= 1; # 3; reset <= 0;
    end

  // generate clock to sequence tests
  always
    begin
      clk <= 1; # 5; clk <= 0; # 5;
	$display("______ CLOCK + ______");
    end

  // check results
  always @(negedge clk)
    begin
	$display("______ CLOCK - ______");
      if(MemWrite) begin
        if(DataAdr === 100 & WriteData === 7) begin
          $display("Simulation succeeded");
          //$stop;
        end else if (DataAdr !== 96) begin
          $display("Simulation failed");
          //$stop;
        end
      end
    end
endmodule

module top(input  logic        clk, reset, 
           output logic [31:0] WriteData, DataAdr, 
           output logic        MemWrite);

  logic [31:0] PC, Instr, ReadData;

always@(negedge clk)
begin
$display(" ");
$display("____ saída do top ____");
$display("MemWrite  : %b",MemWrite);
$display("B         : %b", Instr[22]);
$display("DataAdr   : %b", DataAdr);
$display("WriteData : %b", WriteData);
$display("ReadData  : %b", ReadData);
end
  
  // instantiate processor and memories
  arm arm(clk, reset, PC, Instr, MemWrite, DataAdr, WriteData, ReadData);
  imem imem(PC, Instr);
  dmem dmem(clk, MemWrite, Instr[22], DataAdr, WriteData, ReadData);
endmodule

module dmem(input logic clk, we,
	    input logic ByteFlag,
            input  logic [31:0] a, wd,
            output logic [31:0] rd);

  logic [31:0] RAM[63:0];
  logic [31:0] wdb;

  always_comb
	if (ByteFlag) begin
		assign rd = RAM[a[31:2]] & 8'hFF;	
	end else begin 
		assign rd = RAM[a[31:2]]; // word aligned
	end

  always_ff @(posedge clk)
    if (we) begin

	if (ByteFlag) begin
			assign wdb = wd & 8'hFF;
			RAM[a[31:2]] <= wdb;
		end else begin 
			RAM[a[31:2]] <= wd;
		end
	end
endmodule

module imem(input  logic [31:0] a,
            output logic [31:0] rd);

  logic [31:0] RAM[63:0];

  initial
      	//$readmemh("memfile.dat",RAM);
	//$readmemh("memfile_MOV_CMP.dat",RAM);
	//$readmemh("memfile_TST_MVN_EOR.dat",RAM);
	$readmemh("memfile_LSL_ASR.dat",RAM);
	//$readmemh("memfile_LDRB_STRB.dat",RAM);

  assign rd = RAM[a[31:2]]; // word aligned
endmodule

module arm(input  logic        clk, reset,
           output logic [31:0] PC,
           input  logic [31:0] Instr,
           output logic        MemWrite,
           output logic [31:0] ALUResult, WriteData,
           input  logic [31:0] ReadData);

  logic [3:0] ALUFlags;
  logic       RegWrite, ALUBypass,ALUSrc, MemtoReg, PCSrc;
  logic [1:0] RegSrc, ImmSrc;
  logic [2:0] ALUControl;

reg [7:0] counter = 8'b0;
always@(negedge clk)
begin
counter <= counter+1;
$display(" ");
$display("____ saída do arm ____");
$display("%dº INSTRUÇÂO",counter);
$display("cond : %b | op   : %b | Funct   : %b ",Instr[31:28],Instr[27:26],Instr[25:20]);
$display("Rn   : %b | Rd   : %b",Instr[19:16],Instr[15:12]);
$display("Src2 : %b %b %b",Instr[11:8],Instr[7:4],Instr[3:0]);
end


  controller c(clk, reset, Instr[31:12], ALUFlags, 
               RegSrc, RegWrite, ImmSrc, 
               ALUSrc, ALUControl, ALUBypass,ShiftOp,
               MemWrite, MemtoReg, PCSrc);

  datapath dp(clk, reset, 
              RegSrc, RegWrite, ImmSrc,
              ALUSrc, ALUControl,
              MemtoReg, PCSrc, ALUBypass,ShiftOp,
              ALUFlags, PC, Instr,
              ALUResult, WriteData, ReadData);
endmodule

module controller(input  logic         clk, reset,
                  input  logic [31:12] Instr,
                  input  logic [3:0]   ALUFlags,

                  output logic [1:0]   RegSrc,
                  output logic         RegWrite,
                  output logic [1:0]   ImmSrc,
                  output logic         ALUSrc, 
                  output logic [2:0]   ALUControl,
		  output logic	       ALUBypass,ShiftOp,
                  output logic         MemWrite, MemtoReg,
                  output logic         PCSrc);

  	logic [1:0] FlagW;
  	logic       PCS, RegW, MemW, ALUBps;

always@(negedge clk)
begin
$display(" ");
$display(" ");
$display("____ saída do controller ____");
$display("Instr  : %b",Instr);
end

  
  decoder dec(Instr[27:26], Instr[25:20], 
		Instr[15:12],FlagW, PCS, RegW, MemW, ALUBps,ShiftOp, 
		MemtoReg, ALUSrc, ImmSrc, RegSrc, ALUControl);

  condlogic cl(clk, reset, Instr[31:28], ALUFlags,FlagW, PCS, 
		RegW, MemW,ALUBps, PCSrc, RegWrite, MemWrite, ALUBypass);

endmodule

module decoder(input  logic [1:0] Op,
               input  logic [5:0] Funct,
               input  logic [3:0] Rd,

               output logic [1:0] FlagW,
               output logic       PCS, RegW, MemW, ALUBps, ShiftOp,
               output logic       MemtoReg, ALUSrc,
               output logic [1:0] ImmSrc, RegSrc, 
               output logic [2:0] ALUControl);

  logic [9:0] controls;
  logic       Branch, ALUOp;
	

  // Main Decoder
  
  always_comb
	
  	case(Op)

	// Instruções de 'Processamento de Dados'
	2'b00:begin
		
		$display("INSTRUÇÃO : Processamento de dados");
		$display("Funct     : %b",Funct);
	
		case(Funct[5:1])
		
		// SUB register
		5'b00010: controls = 12'b000000100100;

		// SUB immediate
		5'b10010: controls = 12'b000000100100;

		// ADD register
		5'b00100: controls = 12'b000000100100;

		// ADD immediate
		5'b10100: controls = 12'b000000100100;

		// AND register
		5'b00000: controls = 12'b000000100100;

		// AND immediate
		5'b10000: controls = 12'b000000100100;

		// ORR register
		5'b01100: controls = 12'b000000100100;

		// ORR immediate
		5'b11100: controls = 12'b000000100100;

		// CMP register
		5'b01010: controls = 12'b000000000100;

		// CMP immediate
		5'b11010: controls = 12'b000010000100;

		// TST register (Like CMP)
		5'b01000: controls = 12'b000000000100;

		// TST immediate (Like CMP)
		5'b11000: controls = 12'b000010000100;

		// MVN register (Like MOV) VERIFICAR ERRO!
		5'b01111: controls = 12'b000010100100;

		// MVN immediate (Like MOV)
		5'b11111: controls = 12'b000010100100;

		// EOR register
		5'b00001: controls = 12'b000000100100;

		// EOR immediate
		5'b10001: controls = 12'b000010100100;

		// MOV immediate
		5'b11101: controls = 12'b100010100010;

		// MOV, LSL, ASR register
		5'b01101: controls = 12'b10xx00100011;

		// Unimplemented
		default: controls = 12'bx;

		endcase

		$display("Controls  : %b",controls); 
	
	end

  	// Instruções de 'Memória'                      
  	2'b01:begin

		$display("INSTRUÇÃO : Memória");
		$display("Funct     : %b",Funct);

		case(Funct[0])
			
		// LDR 
		1'b1: controls = 12'b000111100000; 

		// STR
		1'b0: controls = 12'b100111010000;

		// LDRB
		1'b1: controls = 12'b000111100000; 

		// STRB
		1'b0: controls = 12'b100111010000; 

		// Unimplemented
		default: controls = 12'bx;

		endcase

		$display("Controls  : %b",controls); 
		
  	end

	// Instruções de 'Branch'
  	2'b10:begin

		$display("INSTRUÇÃO : Branch");
		$display("Funct     : %b",Funct);

		//case(Funct[5:4])
			
		// B (2'b10)
		controls = 12'b011010001000;

		// B Label
		//2'b12: controls = 11'b011010001000;

		// Unimplemented
		//default: controls = 12'bx;

		//endcase

		$display("Controls  : %b",controls);        

	end
  	             
        // Instrução desconhecida
  	default:begin

		$display("INSTRUÇÃO : Não implementada");
		$display("Funct     : %b",Funct);
              
		// Unimplemented
		controls = 12'bx;

		$display("Controls  : %b",controls); 
	end          
  	endcase


  assign {RegSrc, ImmSrc, ALUSrc, MemtoReg, RegW, MemW, Branch, ALUOp, ALUBps, ShiftOp} = controls; 
    
  // ALU Decoder 
            
  always_comb
    if (ALUOp) begin

	$display("ALUOp     : %b",ALUOp);                
	
	// Descobrir qual instrução de processamento de dados
      case(Funct[4:1]) 
  	    4'b0100: ALUControl = 3'b000; // ADD
  	    4'b0010: ALUControl = 3'b001; // SUB
            4'b0000: ALUControl = 3'b010; // AND
  	    4'b1100: ALUControl = 3'b011; // ORR
  	    4'b1010: ALUControl = 3'b001; // SUB (para o MOV)
            4'b1000: ALUControl = 3'b010; // AND (para o TST)
            4'b1111: ALUControl = 3'b100; // MVN
            4'b0001: ALUControl = 3'b101; // EOR
  	    default: ALUControl = 3'bx;  // unimplemented
      endcase

	$display("ALUControl: %b",ALUControl); 
      
	// update flags if S bit is set 
	// (C & V only updated for arith instructions)

      FlagW[1]      = Funct[0]; // FlagW[1] = S-bit

	// FlagW[0] = S-bit & (ADD | SUB)
      FlagW[0]      = Funct[0] & (ALUControl == 3'b000 | ALUControl == 3'b001);
 
    end else begin

      ALUControl = 3'b000; // add for non-DP instructions
      FlagW      = 2'b00; // don't update Flags

    end
              
  // PC Logic

  assign PCS  = ((Rd == 4'b1111) & RegW) | Branch;  

endmodule

module condlogic(input  logic       clk, reset,
                 input  logic [3:0] Cond,
                 input  logic [3:0] ALUFlags,
                 input  logic [1:0] FlagW,
                 input  logic       PCS, RegW, MemW, MovF,

                 output logic       PCSrc, RegWrite, MemWrite, MovFlag);
                 
  	logic [1:0] FlagWrite;
  	logic [3:0] Flags;
  	logic       CondEx;


  flopenr #(2)flagreg1(clk, reset, FlagWrite[1], ALUFlags[3:2], Flags[3:2]);
  flopenr #(2)flagreg0(clk, reset, FlagWrite[0], ALUFlags[1:0], Flags[1:0]);

  // write controls are conditional
  condcheck cc(Cond, Flags, CondEx);

  	assign FlagWrite = FlagW & {2{CondEx}};
  	assign RegWrite  = RegW  & CondEx;
  	assign MemWrite  = MemW  & CondEx;
	assign PCSrc     = PCS   & CondEx;
	assign MovFlag	 = MovF  & CondEx;

endmodule    

module condcheck(input  logic [3:0] Cond,
                 input  logic [3:0] Flags,
                 output logic       CondEx);
  
  logic neg, zero, carry, overflow, ge;
  
  assign {neg, zero, carry, overflow} = Flags;
  assign ge = (neg == overflow);
                  
  always_comb
    case(Cond)
      4'b0000: CondEx = zero;             // EQ
      4'b0001: CondEx = ~zero;            // NE
      4'b0010: CondEx = carry;            // CS
      4'b0011: CondEx = ~carry;           // CC
      4'b0100: CondEx = neg;              // MI
      4'b0101: CondEx = ~neg;             // PL
      4'b0110: CondEx = overflow;         // VS
      4'b0111: CondEx = ~overflow;        // VC
      4'b1000: CondEx = carry & ~zero;    // HI
      4'b1001: CondEx = ~(carry & ~zero); // LS
      4'b1010: CondEx = ge;               // GE
      4'b1011: CondEx = ~ge;              // LT
      4'b1100: CondEx = ~zero & ge;       // GT
      4'b1101: CondEx = ~(~zero & ge);    // LE
      4'b1110: CondEx = 1'b1;             // Always
      default: CondEx = 1'bx;             // undefined
    endcase
endmodule

module datapath(input  logic        clk, reset,
                input  logic [1:0]  RegSrc,
                input  logic        RegWrite,
                input  logic [1:0]  ImmSrc,
                input  logic        ALUSrc,
                input  logic [2:0]  ALUControl,
                input  logic        MemtoReg,
                input  logic        PCSrc,
		input  logic	    ALUBypass,ShiftOp,

                output logic [3:0]  ALUFlags,
                output logic [31:0] PC,
                input  logic [31:0] Instr,
                output logic [31:0] ALUResult, WriteData,
                input  logic [31:0] ReadData);

  logic [31:0] PCNext, PCPlus4, PCPlus8;
  logic [31:0] ExtImm, SrcA, Shifted, SrcB, Result, SrcBOrALUResult;
  logic [3:0]  RA1, RA2;

always@(negedge clk)
begin
$display(" ");
$display(" ");
$display("____ saída do datapath ____");
$display(" ");
$display("ALUBps  : %b",ALUBypass);
$display("RegWrite: %b",RegWrite);
$display("RegSrc  : %b",RegSrc);
$display("ALUFlags: %b",ALUFlags);
$display(" ");
$display("RA1     : %b",RA1);
$display("RA2     : %b",RA2);
$display("Rn      : %b",Instr[19:16]);
$display("Rd      : %b",Instr[15:12]);
$display(" ");
$display("Rm      : %b",Instr[3:0]);
$display("bS|alu  : %b",ALUResult);
$display("SrcA    : %b",SrcA);
$display("SrcB    : %b",SrcB);
$display("WriteD  : %b",WriteData);
$display("ExtImm  : %b",ExtImm);
$display(" ");
$display("ReadD   : %b",ReadData);
$display("movmux  : %b",SrcBOrALUResult);
$display("Result  : %b",Result);
$display(" ");
end

  // next PC logic
  mux2 #(32)  pcmux(PCPlus4, Result, PCSrc, PCNext);
  flopr #(32) pcreg(clk, reset, PCNext, PC);
  adder #(32) pcadd1(PC, 32'b100, PCPlus4);
  adder #(32) pcadd2(PCPlus4, 32'b100, PCPlus8);

  // register file logic
  mux2 #(4)   ra1mux(Instr[19:16], 4'b1111, RegSrc[0], RA1);
  mux2 #(4)   ra2mux(Instr[3:0], Instr[15:12], RegSrc[1], RA2);
  mux2 #(32)  alubpsmux(ALUResult, SrcB, ALUBypass, SrcBOrALUResult);
  mux2 #(32)  resmux(SrcBOrALUResult, ReadData, MemtoReg, Result);

  regfile     rf(clk, RegWrite, RA1, RA2,Instr[15:12], Result, PCPlus8, SrcA, WriteData); 
  extend      ext(Instr[23:0], ImmSrc, ExtImm);

  // ALU logic
  shifter     s(ShiftOp, Instr[6:5], Instr[11:7], WriteData, Shifted);
  mux2 #(32)  srcbmux(Shifted, ExtImm, ALUSrc, SrcB);
  alu         alu(SrcA, SrcB, ALUControl, ALUResult, ALUFlags);

endmodule

module regfile(input  logic        clk, 
               input  logic        we3, 
               input  logic [3:0]  ra1, ra2, wa3, 
               input  logic [31:0] wd3, r15,
               output logic [31:0] rd1, rd2);

  logic [31:0] rf[14:0];

always@(negedge clk)
begin
$display(" ");
$display(" ");
$display("____ saída do regfile ____");
$display("we3 : %b",we3);
$display("ra1: %b | ra2: %b | wa3 : %b",ra1,ra2,wa3);
$display("wd3: %b",wd3);
$display("rd1: %b",rd1);
$display("rd2: %b",rd2);
end

  // three ported register file
  // read two ports combinationally
  // write third port on rising edge of clock
  // register 15 reads PC+8 instead

  always_ff @(posedge clk)
    if (we3) rf[wa3] <= wd3;	

  assign rd1 = (ra1 == 4'b1111) ? r15 : rf[ra1];
  assign rd2 = (ra2 == 4'b1111) ? r15 : rf[ra2];
endmodule

module shifter (
  // Entrada lógica para ativar ou não o modulo
  input logic ShiftOp,
  // Entrada de 2 bits para indicar o tipo de shift
  input logic [1:0] Sh,
  // Entrada de 5 bits para indicar o número de bits a serem deslocados
  input logic [4:0] Shnt,
  // Entrada de 32 bits com o valor a ser deslocado
  input logic [31:0] ScrB,
  // Saída de 32 bits com o resultado do deslocamento
  output logic [31:0] shifted
);

// Variável para armazenar o resultado do deslocamento
logic [31:0] result;

// O código deve ser sempre combinacional, portanto, usamos always_comb
always_comb

begin

  // Se Sh e Shnt não são nulos (0), realiza o deslocamento
  if (ShiftOp) begin
	
	$display("in ScrB : %b",ScrB);

	$display("shant5 : %b  | sh : %b", Shnt, Sh);

    // Verifica o tipo de deslocamento a ser realizado
    case (Sh)

      // LSL - Logical Shift Left
      2'b00: result = (ScrB << Shnt);
 
      // ASR - Arithmetic Shift Right
      2'b10: result = ($signed(ScrB) >>> Shnt); 

      // Caso contrário, o resultado é o próprio ScrB
      default: result = ScrB;

    endcase

  // Se Sh e Shnt são nulos (0), o resultado é o próprio ScrB
  end else begin

    result = ScrB;

  end

  // Atribui o resultado do deslocamento à saída shifted
  assign shifted = result;

end
endmodule

module extend(input  logic [23:0] Instr,
              input  logic [1:0]  ImmSrc,
              output logic [31:0] ExtImm);
 
  always_comb
    case(ImmSrc) 
               // 8-bit unsigned immediate
      2'b00:   ExtImm = {24'b0, Instr[7:0]};  
               // 12-bit unsigned immediate 
      2'b01:   ExtImm = {20'b0, Instr[11:0]}; 
               // 24-bit two's complement shifted branch 
      2'b10:   ExtImm = {{6{Instr[23]}}, Instr[23:0], 2'b00}; 
      default: ExtImm = 32'bx; // undefined
    endcase             
endmodule

module adder #(parameter WIDTH=8)
              (input  logic [WIDTH-1:0] a, b,
               output logic [WIDTH-1:0] y);
             
  assign y = a + b;
endmodule

module flopenr #(parameter WIDTH = 8)
                (input  logic             clk, reset, en,
                 input  logic [WIDTH-1:0] d, 
                 output logic [WIDTH-1:0] q);

  always_ff @(posedge clk, posedge reset)
    if (reset)   q <= 0;
    else if (en) q <= d;
endmodule

module flopr #(parameter WIDTH = 8)
              (input  logic             clk, reset,
               input  logic [WIDTH-1:0] d, 
               output logic [WIDTH-1:0] q);

  always_ff @(posedge clk, posedge reset)
    if (reset) q <= 0;
    else       q <= d;
endmodule

module mux2 #(parameter WIDTH = 8)
             (input  logic [WIDTH-1:0] d0, d1, 
              input  logic             s, 
              output logic [WIDTH-1:0] y);

  assign y = s ? d1 : d0; 
endmodule

module alu(input  logic [31:0] a, b,
           input  logic [2:0]  ALUControl,
           output logic [31:0] Result,
           output logic [3:0]  ALUFlags);

  logic        neg, zero, carry, overflow;
  logic [31:0] condinvb;
  logic [32:0] sum;

  assign condinvb = ALUControl[0] ? ~b : b;
  assign sum = a + condinvb + ALUControl[0];

  always_comb
    casex (ALUControl[2:0])
      3'b0?: Result = sum;
      3'b010: Result = a & b;
      3'b011: Result = a | b;
      3'b100: Result = ~b;
      3'b101: Result = a^b;
    endcase

  assign neg      = Result[31];
  assign zero     = (Result == 32'b0);
  assign carry    = (ALUControl[1] == 1'b0) & sum[32];
  assign overflow = (ALUControl[1] == 1'b0) & ~(a[31] ^ b[31] ^ ALUControl[0]) & (a[31] ^ sum[31]); 
  assign ALUFlags    = {neg, zero, carry, overflow};

endmodule
