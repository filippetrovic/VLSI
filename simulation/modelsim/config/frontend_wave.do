onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /frontend_test/clk
add wave -noupdate -radix hexadecimal /frontend_test/rst
add wave -noupdate -divider {control signals}
add wave -noupdate -color Gold -label stall -radix hexadecimal /frontend_test/control_in.stall
add wave -noupdate -color Orange -label jump -radix hexadecimal /frontend_test/control_in.jump
add wave -noupdate -label jump_address -radix hexadecimal /frontend_test/data_in.jump_address
add wave -noupdate -divider <NULL>
add wave -noupdate -label read /frontend_test/control_out.read
add wave -noupdate -divider addresses
add wave -noupdate -label {first address} -radix hexadecimal /frontend_test/mem_address(0)
add wave -noupdate -label {second address} -radix hexadecimal /frontend_test/mem_address(1)
add wave -noupdate -divider -height 25 {decoded instructions}
add wave -noupdate -color {Dark Orchid} -radix hexadecimal /frontend_test/data_out.instructions(0).pc
add wave -noupdate -color Goldenrod -radix hexadecimal /frontend_test/data_out.instructions(0).op
add wave -noupdate -color Goldenrod -radix hexadecimal /frontend_test/data_out.instructions(0).r1
add wave -noupdate -color Goldenrod -radix hexadecimal /frontend_test/data_out.instructions(0).r2
add wave -noupdate -color Goldenrod -radix hexadecimal /frontend_test/data_out.instructions(0).r3
add wave -noupdate -color Goldenrod -radix hexadecimal /frontend_test/data_out.instructions(0).imm
add wave -noupdate -color Goldenrod -radix hexadecimal /frontend_test/data_out.instructions(0).offset
add wave -noupdate -radix hexadecimal /frontend_test/data_out.instructions(0).valid
add wave -noupdate -divider {second instruction}
add wave -noupdate -color {Dark Orchid} -radix hexadecimal /frontend_test/data_out.instructions(1).pc
add wave -noupdate -color Goldenrod -radix hexadecimal /frontend_test/data_out.instructions(1).op
add wave -noupdate -color Goldenrod -radix hexadecimal /frontend_test/data_out.instructions(1).r1
add wave -noupdate -color Goldenrod -radix hexadecimal /frontend_test/data_out.instructions(1).r2
add wave -noupdate -color Goldenrod -radix hexadecimal /frontend_test/data_out.instructions(1).r3
add wave -noupdate -color Goldenrod -radix hexadecimal /frontend_test/data_out.instructions(1).imm
add wave -noupdate -color Goldenrod -radix hexadecimal /frontend_test/data_out.instructions(1).offset
add wave -noupdate -radix hexadecimal /frontend_test/data_out.instructions(1).valid
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {22141 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 201
configure wave -valuecolwidth 68
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
WaveRestoreZoom {0 ps} {142766 ps}
