onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /mem_unit_test/clk
add wave -noupdate -radix hexadecimal /mem_unit_test/rst
add wave -noupdate -radix hexadecimal /mem_unit_test/in_control.go
add wave -noupdate -divider Instruction
add wave -noupdate -label pc -radix hexadecimal /mem_unit_test/in_data.instruction.pc
add wave -noupdate -label opcode -radix hexadecimal /mem_unit_test/in_data.instruction.op
add wave -noupdate -label valid -radix hexadecimal /mem_unit_test/in_data.instruction.valid
add wave -noupdate -divider {Od JZP}
add wave -noupdate -label reg_address -radix hexadecimal /mem_unit_test/in_data.address
add wave -noupdate -label reg_value -radix hexadecimal /mem_unit_test/in_data.reg_value
add wave -noupdate -divider {Od memorije}
add wave -noupdate -radix hexadecimal /mem_unit_test/in_data.data
add wave -noupdate -divider {Ka Hazard detektoru}
add wave -noupdate -label mem_reg -radix hexadecimal /mem_unit_test/out_data.mem_reg
add wave -noupdate -divider {Ka memoriji}
add wave -noupdate -label address_to_mem -radix hexadecimal /mem_unit_test/out_data.address
add wave -noupdate -label data_to_mem -radix hexadecimal /mem_unit_test/out_data.data
add wave -noupdate -divider {WSU data}
add wave -noupdate -label pc -radix hexadecimal /mem_unit_test/out_data.wsu_data.pc
add wave -noupdate -label reg_address -radix hexadecimal /mem_unit_test/out_data.wsu_data.address
add wave -noupdate -label reg_value -radix hexadecimal /mem_unit_test/out_data.wsu_data.value
add wave -noupdate -label valid -radix hexadecimal /mem_unit_test/out_data.wsu_data.valid
add wave -noupdate -divider {Kontrolni signali}
add wave -noupdate -label mem_load -radix hexadecimal /mem_unit_test/out_control.mem_load
add wave -noupdate -label mem_busy -radix hexadecimal /mem_unit_test/out_control.mem_busy
add wave -noupdate -label rd -radix hexadecimal /mem_unit_test/out_control.rd
add wave -noupdate -label wr -radix hexadecimal /mem_unit_test/out_control.wr
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {19751 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 236
configure wave -valuecolwidth 78
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
WaveRestoreZoom {0 ps} {120118 ps}
