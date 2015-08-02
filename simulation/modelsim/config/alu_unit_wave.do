onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /alu_unit_test/clk
add wave -noupdate -radix hexadecimal /alu_unit_test/rst
add wave -noupdate -label go -radix hexadecimal /alu_unit_test/in_control.go
add wave -noupdate -divider -height 25 <NULL>
add wave -noupdate -color {Yellow Green} -label PSW_in -radix hexadecimal /alu_unit_test/in_data.psw
add wave -noupdate -divider <NULL>
add wave -noupdate -color {Medium Orchid} -label pc -radix hexadecimal /alu_unit_test/in_data.instruction.pc
add wave -noupdate -color Gray55 -label op -radix hexadecimal /alu_unit_test/in_data.instruction.op
add wave -noupdate -color Gray55 -label R3 -radix hexadecimal /alu_unit_test/in_data.instruction.r3
add wave -noupdate -label valid -radix hexadecimal /alu_unit_test/in_data.instruction.valid
add wave -noupdate -divider <NULL>
add wave -noupdate -color Gold -label R1 -radix hexadecimal /alu_unit_test/in_data.operand_A.out_value
add wave -noupdate -color Gold -label R2 -radix hexadecimal /alu_unit_test/in_data.operand_B.out_value
add wave -noupdate -divider <NULL>
add wave -noupdate -color Gray55 -label address -radix hexadecimal /alu_unit_test/out_data.result.address
add wave -noupdate -color Gold -label result -radix hexadecimal /alu_unit_test/out_data.result.value
add wave -noupdate -label pc -radix hexadecimal /alu_unit_test/out_data.result.pc
add wave -noupdate -label ok -radix hexadecimal /alu_unit_test/out_data.result.valid
add wave -noupdate -divider <NULL>
add wave -noupdate -color {Yellow Green} -label N -radix hexadecimal /alu_unit_test/out_data.psw.psw_value(31)
add wave -noupdate -color {Yellow Green} -label Z -radix hexadecimal /alu_unit_test/out_data.psw.psw_value(30)
add wave -noupdate -color {Yellow Green} -label C -radix hexadecimal /alu_unit_test/out_data.psw.psw_value(29)
add wave -noupdate -color {Yellow Green} -label V -radix hexadecimal /alu_unit_test/out_data.psw.psw_value(28)
add wave -noupdate -divider <NULL>
add wave -noupdate -color {Cornflower Blue} -label update_psw -radix hexadecimal /alu_unit_test/out_data.psw.update_psw
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {19467 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 177
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {127616 ps}
