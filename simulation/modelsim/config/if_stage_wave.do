onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /test_if_stage/clk
add wave -noupdate -divider -height 25 control
add wave -noupdate -radix hexadecimal /test_if_stage/reset
add wave -noupdate -divider -height 20 <NULL>
add wave -noupdate -color Yellow -radix hexadecimal /test_if_stage/control_in.stall
add wave -noupdate -divider -height 25 <NULL>
add wave -noupdate -color Orange -radix hexadecimal /test_if_stage/control_in.jump
add wave -noupdate -divider -height 25 {jump address}
add wave -noupdate -radix hexadecimal /test_if_stage/data_in.jump_address
add wave -noupdate -divider -height 30 rd
add wave -noupdate -radix hexadecimal /test_if_stage/control_out.rd
add wave -noupdate -divider -height 35 addresses
add wave -noupdate -radix hexadecimal /test_if_stage/data_out.addresses(0)
add wave -noupdate -radix hexadecimal -childformat {{/test_if_stage/data_out.addresses(1)(31) -radix hexadecimal} {/test_if_stage/data_out.addresses(1)(30) -radix hexadecimal} {/test_if_stage/data_out.addresses(1)(29) -radix hexadecimal} {/test_if_stage/data_out.addresses(1)(28) -radix hexadecimal} {/test_if_stage/data_out.addresses(1)(27) -radix hexadecimal} {/test_if_stage/data_out.addresses(1)(26) -radix hexadecimal} {/test_if_stage/data_out.addresses(1)(25) -radix hexadecimal} {/test_if_stage/data_out.addresses(1)(24) -radix hexadecimal} {/test_if_stage/data_out.addresses(1)(23) -radix hexadecimal} {/test_if_stage/data_out.addresses(1)(22) -radix hexadecimal} {/test_if_stage/data_out.addresses(1)(21) -radix hexadecimal} {/test_if_stage/data_out.addresses(1)(20) -radix hexadecimal} {/test_if_stage/data_out.addresses(1)(19) -radix hexadecimal} {/test_if_stage/data_out.addresses(1)(18) -radix hexadecimal} {/test_if_stage/data_out.addresses(1)(17) -radix hexadecimal} {/test_if_stage/data_out.addresses(1)(16) -radix hexadecimal} {/test_if_stage/data_out.addresses(1)(15) -radix hexadecimal} {/test_if_stage/data_out.addresses(1)(14) -radix hexadecimal} {/test_if_stage/data_out.addresses(1)(13) -radix hexadecimal} {/test_if_stage/data_out.addresses(1)(12) -radix hexadecimal} {/test_if_stage/data_out.addresses(1)(11) -radix hexadecimal} {/test_if_stage/data_out.addresses(1)(10) -radix hexadecimal} {/test_if_stage/data_out.addresses(1)(9) -radix hexadecimal} {/test_if_stage/data_out.addresses(1)(8) -radix hexadecimal} {/test_if_stage/data_out.addresses(1)(7) -radix hexadecimal} {/test_if_stage/data_out.addresses(1)(6) -radix hexadecimal} {/test_if_stage/data_out.addresses(1)(5) -radix hexadecimal} {/test_if_stage/data_out.addresses(1)(4) -radix hexadecimal} {/test_if_stage/data_out.addresses(1)(3) -radix hexadecimal} {/test_if_stage/data_out.addresses(1)(2) -radix hexadecimal} {/test_if_stage/data_out.addresses(1)(1) -radix hexadecimal} {/test_if_stage/data_out.addresses(1)(0) -radix hexadecimal}} -subitemconfig {/test_if_stage/data_out.addresses(1)(31) {-height 15 -radix hexadecimal} /test_if_stage/data_out.addresses(1)(30) {-height 15 -radix hexadecimal} /test_if_stage/data_out.addresses(1)(29) {-height 15 -radix hexadecimal} /test_if_stage/data_out.addresses(1)(28) {-height 15 -radix hexadecimal} /test_if_stage/data_out.addresses(1)(27) {-height 15 -radix hexadecimal} /test_if_stage/data_out.addresses(1)(26) {-height 15 -radix hexadecimal} /test_if_stage/data_out.addresses(1)(25) {-height 15 -radix hexadecimal} /test_if_stage/data_out.addresses(1)(24) {-height 15 -radix hexadecimal} /test_if_stage/data_out.addresses(1)(23) {-height 15 -radix hexadecimal} /test_if_stage/data_out.addresses(1)(22) {-height 15 -radix hexadecimal} /test_if_stage/data_out.addresses(1)(21) {-height 15 -radix hexadecimal} /test_if_stage/data_out.addresses(1)(20) {-height 15 -radix hexadecimal} /test_if_stage/data_out.addresses(1)(19) {-height 15 -radix hexadecimal} /test_if_stage/data_out.addresses(1)(18) {-height 15 -radix hexadecimal} /test_if_stage/data_out.addresses(1)(17) {-height 15 -radix hexadecimal} /test_if_stage/data_out.addresses(1)(16) {-height 15 -radix hexadecimal} /test_if_stage/data_out.addresses(1)(15) {-height 15 -radix hexadecimal} /test_if_stage/data_out.addresses(1)(14) {-height 15 -radix hexadecimal} /test_if_stage/data_out.addresses(1)(13) {-height 15 -radix hexadecimal} /test_if_stage/data_out.addresses(1)(12) {-height 15 -radix hexadecimal} /test_if_stage/data_out.addresses(1)(11) {-height 15 -radix hexadecimal} /test_if_stage/data_out.addresses(1)(10) {-height 15 -radix hexadecimal} /test_if_stage/data_out.addresses(1)(9) {-height 15 -radix hexadecimal} /test_if_stage/data_out.addresses(1)(8) {-height 15 -radix hexadecimal} /test_if_stage/data_out.addresses(1)(7) {-height 15 -radix hexadecimal} /test_if_stage/data_out.addresses(1)(6) {-height 15 -radix hexadecimal} /test_if_stage/data_out.addresses(1)(5) {-height 15 -radix hexadecimal} /test_if_stage/data_out.addresses(1)(4) {-height 15 -radix hexadecimal} /test_if_stage/data_out.addresses(1)(3) {-height 15 -radix hexadecimal} /test_if_stage/data_out.addresses(1)(2) {-height 15 -radix hexadecimal} /test_if_stage/data_out.addresses(1)(1) {-height 15 -radix hexadecimal} /test_if_stage/data_out.addresses(1)(0) {-height 15 -radix hexadecimal}} /test_if_stage/data_out.addresses(1)
add wave -noupdate -divider -height 35 {mem values}
add wave -noupdate -radix hexadecimal /test_if_stage/data_in.instructions(0)
add wave -noupdate -radix hexadecimal /test_if_stage/data_in.instructions(1)
add wave -noupdate -divider -height 35 {stage buffer}
add wave -noupdate -color Plum -radix hexadecimal /test_if_stage/data_out.instructions(0).pc
add wave -noupdate -color Plum -radix hexadecimal /test_if_stage/data_out.instructions(0).instruction
add wave -noupdate -color Green -radix hexadecimal /test_if_stage/data_out.instructions(0).valid
add wave -noupdate -divider -height 25 separator
add wave -noupdate -color Aquamarine -radix hexadecimal /test_if_stage/data_out.instructions(1).pc
add wave -noupdate -color Aquamarine -radix hexadecimal /test_if_stage/data_out.instructions(1).instruction
add wave -noupdate -color Green -radix hexadecimal /test_if_stage/data_out.instructions(1).valid
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 134
configure wave -valuecolwidth 86
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
WaveRestoreZoom {0 ps} {130556 ps}
