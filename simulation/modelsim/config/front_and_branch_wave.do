onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /cpu_part_test/clk
add wave -noupdate -radix hexadecimal /cpu_part_test/rst
add wave -noupdate -divider <NULL>
add wave -noupdate -color Gold -label stall -radix hexadecimal /cpu_part_test/fe_control_in.stall
add wave -noupdate -color Orange -label jump -radix hexadecimal /cpu_part_test/fe_control_in.jump
add wave -noupdate -divider <NULL>
add wave -noupdate -label jump_address -radix hexadecimal /cpu_part_test/fe_data_in.jump_address
add wave -noupdate -divider -height 25 <NULL>
add wave -noupdate -color {Medium Orchid} -label pc -radix hexadecimal /cpu_part_test/br_data_in.instruction.pc
add wave -noupdate -color {Cornflower Blue} -label opcode -radix hexadecimal /cpu_part_test/br_data_in.instruction.op
add wave -noupdate -color {Cornflower Blue} -label offset -radix hexadecimal /cpu_part_test/br_data_in.instruction.offset
add wave -noupdate -label valid -radix hexadecimal /cpu_part_test/br_data_in.instruction.valid
add wave -noupdate -divider <NULL>
add wave -noupdate -color Gray50 -label {link address} -radix hexadecimal /cpu_part_test/br_data_out.link_address
add wave -noupdate -label write -radix hexadecimal /cpu_part_test/br_control_out.wr
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 185
configure wave -valuecolwidth 119
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
WaveRestoreZoom {133994 ps} {256106 ps}
