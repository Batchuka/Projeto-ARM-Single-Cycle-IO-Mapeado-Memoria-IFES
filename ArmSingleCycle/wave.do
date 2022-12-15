onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testbench/dut/arm/clk
add wave -noupdate /testbench/dut/arm/reset
add wave -noupdate -radix hexadecimal /testbench/dut/arm/PC
add wave -noupdate -radix hexadecimal -childformat {{{/testbench/dut/arm/Instr[31]} -radix hexadecimal} {{/testbench/dut/arm/Instr[30]} -radix hexadecimal} {{/testbench/dut/arm/Instr[29]} -radix hexadecimal} {{/testbench/dut/arm/Instr[28]} -radix hexadecimal} {{/testbench/dut/arm/Instr[27]} -radix hexadecimal} {{/testbench/dut/arm/Instr[26]} -radix hexadecimal} {{/testbench/dut/arm/Instr[25]} -radix hexadecimal} {{/testbench/dut/arm/Instr[24]} -radix hexadecimal} {{/testbench/dut/arm/Instr[23]} -radix hexadecimal} {{/testbench/dut/arm/Instr[22]} -radix hexadecimal} {{/testbench/dut/arm/Instr[21]} -radix hexadecimal} {{/testbench/dut/arm/Instr[20]} -radix hexadecimal} {{/testbench/dut/arm/Instr[19]} -radix hexadecimal} {{/testbench/dut/arm/Instr[18]} -radix hexadecimal} {{/testbench/dut/arm/Instr[17]} -radix hexadecimal} {{/testbench/dut/arm/Instr[16]} -radix hexadecimal} {{/testbench/dut/arm/Instr[15]} -radix hexadecimal} {{/testbench/dut/arm/Instr[14]} -radix hexadecimal} {{/testbench/dut/arm/Instr[13]} -radix hexadecimal} {{/testbench/dut/arm/Instr[12]} -radix hexadecimal} {{/testbench/dut/arm/Instr[11]} -radix hexadecimal} {{/testbench/dut/arm/Instr[10]} -radix hexadecimal} {{/testbench/dut/arm/Instr[9]} -radix hexadecimal} {{/testbench/dut/arm/Instr[8]} -radix hexadecimal} {{/testbench/dut/arm/Instr[7]} -radix hexadecimal} {{/testbench/dut/arm/Instr[6]} -radix hexadecimal} {{/testbench/dut/arm/Instr[5]} -radix hexadecimal} {{/testbench/dut/arm/Instr[4]} -radix hexadecimal} {{/testbench/dut/arm/Instr[3]} -radix hexadecimal} {{/testbench/dut/arm/Instr[2]} -radix hexadecimal} {{/testbench/dut/arm/Instr[1]} -radix hexadecimal} {{/testbench/dut/arm/Instr[0]} -radix hexadecimal}} -subitemconfig {{/testbench/dut/arm/Instr[31]} {-radix hexadecimal} {/testbench/dut/arm/Instr[30]} {-radix hexadecimal} {/testbench/dut/arm/Instr[29]} {-radix hexadecimal} {/testbench/dut/arm/Instr[28]} {-radix hexadecimal} {/testbench/dut/arm/Instr[27]} {-radix hexadecimal} {/testbench/dut/arm/Instr[26]} {-radix hexadecimal} {/testbench/dut/arm/Instr[25]} {-radix hexadecimal} {/testbench/dut/arm/Instr[24]} {-radix hexadecimal} {/testbench/dut/arm/Instr[23]} {-radix hexadecimal} {/testbench/dut/arm/Instr[22]} {-radix hexadecimal} {/testbench/dut/arm/Instr[21]} {-radix hexadecimal} {/testbench/dut/arm/Instr[20]} {-radix hexadecimal} {/testbench/dut/arm/Instr[19]} {-radix hexadecimal} {/testbench/dut/arm/Instr[18]} {-radix hexadecimal} {/testbench/dut/arm/Instr[17]} {-radix hexadecimal} {/testbench/dut/arm/Instr[16]} {-radix hexadecimal} {/testbench/dut/arm/Instr[15]} {-radix hexadecimal} {/testbench/dut/arm/Instr[14]} {-radix hexadecimal} {/testbench/dut/arm/Instr[13]} {-radix hexadecimal} {/testbench/dut/arm/Instr[12]} {-radix hexadecimal} {/testbench/dut/arm/Instr[11]} {-radix hexadecimal} {/testbench/dut/arm/Instr[10]} {-radix hexadecimal} {/testbench/dut/arm/Instr[9]} {-radix hexadecimal} {/testbench/dut/arm/Instr[8]} {-radix hexadecimal} {/testbench/dut/arm/Instr[7]} {-radix hexadecimal} {/testbench/dut/arm/Instr[6]} {-radix hexadecimal} {/testbench/dut/arm/Instr[5]} {-radix hexadecimal} {/testbench/dut/arm/Instr[4]} {-radix hexadecimal} {/testbench/dut/arm/Instr[3]} {-radix hexadecimal} {/testbench/dut/arm/Instr[2]} {-radix hexadecimal} {/testbench/dut/arm/Instr[1]} {-radix hexadecimal} {/testbench/dut/arm/Instr[0]} {-radix hexadecimal}} /testbench/dut/arm/Instr
add wave -noupdate -radix hexadecimal /testbench/dut/arm/MemWrite
add wave -noupdate -radix hexadecimal -childformat {{{/testbench/dut/arm/ALUResult[31]} -radix hexadecimal} {{/testbench/dut/arm/ALUResult[30]} -radix hexadecimal} {{/testbench/dut/arm/ALUResult[29]} -radix hexadecimal} {{/testbench/dut/arm/ALUResult[28]} -radix hexadecimal} {{/testbench/dut/arm/ALUResult[27]} -radix hexadecimal} {{/testbench/dut/arm/ALUResult[26]} -radix hexadecimal} {{/testbench/dut/arm/ALUResult[25]} -radix hexadecimal} {{/testbench/dut/arm/ALUResult[24]} -radix hexadecimal} {{/testbench/dut/arm/ALUResult[23]} -radix hexadecimal} {{/testbench/dut/arm/ALUResult[22]} -radix hexadecimal} {{/testbench/dut/arm/ALUResult[21]} -radix hexadecimal} {{/testbench/dut/arm/ALUResult[20]} -radix hexadecimal} {{/testbench/dut/arm/ALUResult[19]} -radix hexadecimal} {{/testbench/dut/arm/ALUResult[18]} -radix hexadecimal} {{/testbench/dut/arm/ALUResult[17]} -radix hexadecimal} {{/testbench/dut/arm/ALUResult[16]} -radix hexadecimal} {{/testbench/dut/arm/ALUResult[15]} -radix hexadecimal} {{/testbench/dut/arm/ALUResult[14]} -radix hexadecimal} {{/testbench/dut/arm/ALUResult[13]} -radix hexadecimal} {{/testbench/dut/arm/ALUResult[12]} -radix hexadecimal} {{/testbench/dut/arm/ALUResult[11]} -radix hexadecimal} {{/testbench/dut/arm/ALUResult[10]} -radix hexadecimal} {{/testbench/dut/arm/ALUResult[9]} -radix hexadecimal} {{/testbench/dut/arm/ALUResult[8]} -radix hexadecimal} {{/testbench/dut/arm/ALUResult[7]} -radix hexadecimal} {{/testbench/dut/arm/ALUResult[6]} -radix hexadecimal} {{/testbench/dut/arm/ALUResult[5]} -radix hexadecimal} {{/testbench/dut/arm/ALUResult[4]} -radix hexadecimal} {{/testbench/dut/arm/ALUResult[3]} -radix hexadecimal} {{/testbench/dut/arm/ALUResult[2]} -radix hexadecimal} {{/testbench/dut/arm/ALUResult[1]} -radix hexadecimal} {{/testbench/dut/arm/ALUResult[0]} -radix hexadecimal}} -subitemconfig {{/testbench/dut/arm/ALUResult[31]} {-radix hexadecimal} {/testbench/dut/arm/ALUResult[30]} {-radix hexadecimal} {/testbench/dut/arm/ALUResult[29]} {-radix hexadecimal} {/testbench/dut/arm/ALUResult[28]} {-radix hexadecimal} {/testbench/dut/arm/ALUResult[27]} {-radix hexadecimal} {/testbench/dut/arm/ALUResult[26]} {-radix hexadecimal} {/testbench/dut/arm/ALUResult[25]} {-radix hexadecimal} {/testbench/dut/arm/ALUResult[24]} {-radix hexadecimal} {/testbench/dut/arm/ALUResult[23]} {-radix hexadecimal} {/testbench/dut/arm/ALUResult[22]} {-radix hexadecimal} {/testbench/dut/arm/ALUResult[21]} {-radix hexadecimal} {/testbench/dut/arm/ALUResult[20]} {-radix hexadecimal} {/testbench/dut/arm/ALUResult[19]} {-radix hexadecimal} {/testbench/dut/arm/ALUResult[18]} {-radix hexadecimal} {/testbench/dut/arm/ALUResult[17]} {-radix hexadecimal} {/testbench/dut/arm/ALUResult[16]} {-radix hexadecimal} {/testbench/dut/arm/ALUResult[15]} {-radix hexadecimal} {/testbench/dut/arm/ALUResult[14]} {-radix hexadecimal} {/testbench/dut/arm/ALUResult[13]} {-radix hexadecimal} {/testbench/dut/arm/ALUResult[12]} {-radix hexadecimal} {/testbench/dut/arm/ALUResult[11]} {-radix hexadecimal} {/testbench/dut/arm/ALUResult[10]} {-radix hexadecimal} {/testbench/dut/arm/ALUResult[9]} {-radix hexadecimal} {/testbench/dut/arm/ALUResult[8]} {-radix hexadecimal} {/testbench/dut/arm/ALUResult[7]} {-radix hexadecimal} {/testbench/dut/arm/ALUResult[6]} {-radix hexadecimal} {/testbench/dut/arm/ALUResult[5]} {-radix hexadecimal} {/testbench/dut/arm/ALUResult[4]} {-radix hexadecimal} {/testbench/dut/arm/ALUResult[3]} {-radix hexadecimal} {/testbench/dut/arm/ALUResult[2]} {-radix hexadecimal} {/testbench/dut/arm/ALUResult[1]} {-radix hexadecimal} {/testbench/dut/arm/ALUResult[0]} {-radix hexadecimal}} /testbench/dut/arm/ALUResult
add wave -noupdate -radix hexadecimal -childformat {{{/testbench/dut/arm/WriteData[31]} -radix hexadecimal} {{/testbench/dut/arm/WriteData[30]} -radix hexadecimal} {{/testbench/dut/arm/WriteData[29]} -radix hexadecimal} {{/testbench/dut/arm/WriteData[28]} -radix hexadecimal} {{/testbench/dut/arm/WriteData[27]} -radix hexadecimal} {{/testbench/dut/arm/WriteData[26]} -radix hexadecimal} {{/testbench/dut/arm/WriteData[25]} -radix hexadecimal} {{/testbench/dut/arm/WriteData[24]} -radix hexadecimal} {{/testbench/dut/arm/WriteData[23]} -radix hexadecimal} {{/testbench/dut/arm/WriteData[22]} -radix hexadecimal} {{/testbench/dut/arm/WriteData[21]} -radix hexadecimal} {{/testbench/dut/arm/WriteData[20]} -radix hexadecimal} {{/testbench/dut/arm/WriteData[19]} -radix hexadecimal} {{/testbench/dut/arm/WriteData[18]} -radix hexadecimal} {{/testbench/dut/arm/WriteData[17]} -radix hexadecimal} {{/testbench/dut/arm/WriteData[16]} -radix hexadecimal} {{/testbench/dut/arm/WriteData[15]} -radix hexadecimal} {{/testbench/dut/arm/WriteData[14]} -radix hexadecimal} {{/testbench/dut/arm/WriteData[13]} -radix hexadecimal} {{/testbench/dut/arm/WriteData[12]} -radix hexadecimal} {{/testbench/dut/arm/WriteData[11]} -radix hexadecimal} {{/testbench/dut/arm/WriteData[10]} -radix hexadecimal} {{/testbench/dut/arm/WriteData[9]} -radix hexadecimal} {{/testbench/dut/arm/WriteData[8]} -radix hexadecimal} {{/testbench/dut/arm/WriteData[7]} -radix hexadecimal} {{/testbench/dut/arm/WriteData[6]} -radix hexadecimal} {{/testbench/dut/arm/WriteData[5]} -radix hexadecimal} {{/testbench/dut/arm/WriteData[4]} -radix hexadecimal} {{/testbench/dut/arm/WriteData[3]} -radix hexadecimal} {{/testbench/dut/arm/WriteData[2]} -radix hexadecimal} {{/testbench/dut/arm/WriteData[1]} -radix hexadecimal} {{/testbench/dut/arm/WriteData[0]} -radix hexadecimal}} -subitemconfig {{/testbench/dut/arm/WriteData[31]} {-radix hexadecimal} {/testbench/dut/arm/WriteData[30]} {-radix hexadecimal} {/testbench/dut/arm/WriteData[29]} {-radix hexadecimal} {/testbench/dut/arm/WriteData[28]} {-radix hexadecimal} {/testbench/dut/arm/WriteData[27]} {-radix hexadecimal} {/testbench/dut/arm/WriteData[26]} {-radix hexadecimal} {/testbench/dut/arm/WriteData[25]} {-radix hexadecimal} {/testbench/dut/arm/WriteData[24]} {-radix hexadecimal} {/testbench/dut/arm/WriteData[23]} {-radix hexadecimal} {/testbench/dut/arm/WriteData[22]} {-radix hexadecimal} {/testbench/dut/arm/WriteData[21]} {-radix hexadecimal} {/testbench/dut/arm/WriteData[20]} {-radix hexadecimal} {/testbench/dut/arm/WriteData[19]} {-radix hexadecimal} {/testbench/dut/arm/WriteData[18]} {-radix hexadecimal} {/testbench/dut/arm/WriteData[17]} {-radix hexadecimal} {/testbench/dut/arm/WriteData[16]} {-radix hexadecimal} {/testbench/dut/arm/WriteData[15]} {-radix hexadecimal} {/testbench/dut/arm/WriteData[14]} {-radix hexadecimal} {/testbench/dut/arm/WriteData[13]} {-radix hexadecimal} {/testbench/dut/arm/WriteData[12]} {-radix hexadecimal} {/testbench/dut/arm/WriteData[11]} {-radix hexadecimal} {/testbench/dut/arm/WriteData[10]} {-radix hexadecimal} {/testbench/dut/arm/WriteData[9]} {-radix hexadecimal} {/testbench/dut/arm/WriteData[8]} {-radix hexadecimal} {/testbench/dut/arm/WriteData[7]} {-radix hexadecimal} {/testbench/dut/arm/WriteData[6]} {-radix hexadecimal} {/testbench/dut/arm/WriteData[5]} {-radix hexadecimal} {/testbench/dut/arm/WriteData[4]} {-radix hexadecimal} {/testbench/dut/arm/WriteData[3]} {-radix hexadecimal} {/testbench/dut/arm/WriteData[2]} {-radix hexadecimal} {/testbench/dut/arm/WriteData[1]} {-radix hexadecimal} {/testbench/dut/arm/WriteData[0]} {-radix hexadecimal}} /testbench/dut/arm/WriteData
add wave -noupdate -radix hexadecimal /testbench/dut/arm/ReadData
add wave -noupdate -radix binary /testbench/dut/arm/ALUFlags
add wave -noupdate -radix binary /testbench/dut/arm/RegWrite
add wave -noupdate -radix binary /testbench/dut/arm/ALUSrc
add wave -noupdate -radix binary /testbench/dut/arm/MemtoReg
add wave -noupdate -radix binary /testbench/dut/arm/PCSrc
add wave -noupdate -radix binary /testbench/dut/arm/RegSrc
add wave -noupdate -radix binary /testbench/dut/arm/ImmSrc
add wave -noupdate -radix binary /testbench/dut/arm/ALUControl
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {50 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 217
configure wave -valuecolwidth 210
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {89 ps}
