onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /cpu_test/clk
add wave -noupdate -radix hexadecimal /cpu_test/rst
add wave -noupdate -divider Init
add wave -noupdate -radix hexadecimal /cpu_test/init_pc
add wave -noupdate -divider {PC values}
add wave -noupdate -label {fica PC} -radix hexadecimal /cpu_test/cpu_out_data.inst_address(0)
add wave -noupdate -label {fedja PC} -radix hexadecimal /cpu_test/cpu_out_data.inst_address(1)
add wave -noupdate -divider {Raw instructions}
add wave -noupdate -label {raw instruction 0} -radix hexadecimal /cpu_test/cpu_in_data.mem_values(0)
add wave -noupdate -label {raw instruction 1} -radix hexadecimal /cpu_test/cpu_in_data.mem_values(1)
add wave -noupdate -divider {DATA lines}
add wave -noupdate -label DATA_IN -radix hexadecimal /cpu_test/cpu_in_data.mem_data
add wave -noupdate -label DATA_OUT -radix hexadecimal /cpu_test/cpu_out_data.mem_data
add wave -noupdate -divider {Address lines}
add wave -noupdate -label ADDRESS -radix hexadecimal /cpu_test/cpu_out_data.mem_address
add wave -noupdate -divider {Kontrolni signali (cpu)}
add wave -noupdate -label read_inst -radix hexadecimal /cpu_test/cpu_out_control.read_inst
add wave -noupdate -label read_data -radix hexadecimal /cpu_test/cpu_out_control.read_data
add wave -noupdate -label write_data -radix hexadecimal /cpu_test/cpu_out_control.write_data
add wave -noupdate -label stop -radix hexadecimal /cpu_test/cpu_out_control.stop
add wave -noupdate -divider -height 50 {IF STAGE}
add wave -noupdate -label stall -radix hexadecimal /cpu_test/dut/front/if_stage_inst/control_in.stall
add wave -noupdate -label jump -radix hexadecimal /cpu_test/dut/front/if_stage_inst/control_in.jump
add wave -noupdate -label jump_address -radix hexadecimal /cpu_test/dut/front/if_stage_inst/data_in.jump_address
add wave -noupdate -label read -radix hexadecimal /cpu_test/dut/front/if_stage_inst/control_out.read
add wave -noupdate -divider {PC vrednosti}
add wave -noupdate -label {fica PC} -radix hexadecimal /cpu_test/dut/front/if_stage_inst/data_out.addresses(0)
add wave -noupdate -label {fedja PC} -radix hexadecimal /cpu_test/dut/front/if_stage_inst/data_out.addresses(1)
add wave -noupdate -divider {Procitane instrukcije}
add wave -noupdate -label pc -radix hexadecimal /cpu_test/dut/front/if_stage_inst/data_out.instructions(0).pc
add wave -noupdate -label {raw instruction} -radix hexadecimal /cpu_test/dut/front/if_stage_inst/data_out.instructions(0).instruction
add wave -noupdate -label valid -radix hexadecimal /cpu_test/dut/front/if_stage_inst/data_out.instructions(0).valid
add wave -noupdate -label pc -radix hexadecimal /cpu_test/dut/front/if_stage_inst/data_out.instructions(1).pc
add wave -noupdate -label {raw instruction} -radix hexadecimal /cpu_test/dut/front/if_stage_inst/data_out.instructions(1).instruction
add wave -noupdate -label valid -radix hexadecimal /cpu_test/dut/front/if_stage_inst/data_out.instructions(1).valid
add wave -noupdate -divider {Interni signali}
add wave -noupdate -radix hexadecimal /cpu_test/dut/front/if_stage_inst/inc_pc
add wave -noupdate -radix hexadecimal /cpu_test/dut/front/if_stage_inst/ld_pc
add wave -noupdate -divider -height 50 {ID STAGE}
add wave -noupdate -label stall -radix hexadecimal /cpu_test/dut/front/id_stage_inst/control_in.stall
add wave -noupdate -label jump -radix hexadecimal /cpu_test/dut/front/id_stage_inst/control_in.jump
add wave -noupdate -divider {fica dekodovana}
add wave -noupdate -label pc -radix hexadecimal /cpu_test/dut/front/id_stage_inst/data_out.instructions(0).pc
add wave -noupdate -label op -radix hexadecimal /cpu_test/dut/front/id_stage_inst/data_out.instructions(0).op
add wave -noupdate -label r1 -radix hexadecimal /cpu_test/dut/front/id_stage_inst/data_out.instructions(0).r1
add wave -noupdate -label r2 -radix hexadecimal /cpu_test/dut/front/id_stage_inst/data_out.instructions(0).r2
add wave -noupdate -label r3 -radix hexadecimal /cpu_test/dut/front/id_stage_inst/data_out.instructions(0).r3
add wave -noupdate -label imm -radix hexadecimal /cpu_test/dut/front/id_stage_inst/data_out.instructions(0).imm
add wave -noupdate -label offset -radix hexadecimal /cpu_test/dut/front/id_stage_inst/data_out.instructions(0).offset
add wave -noupdate -label valid -radix hexadecimal /cpu_test/dut/front/id_stage_inst/data_out.instructions(0).valid
add wave -noupdate -divider {fedja dekodovana}
add wave -noupdate -label pc -radix hexadecimal /cpu_test/dut/front/id_stage_inst/data_out.instructions(1).pc
add wave -noupdate -label op -radix hexadecimal /cpu_test/dut/front/id_stage_inst/data_out.instructions(1).op
add wave -noupdate -label r1 -radix hexadecimal /cpu_test/dut/front/id_stage_inst/data_out.instructions(1).r1
add wave -noupdate -label r2 -radix hexadecimal /cpu_test/dut/front/id_stage_inst/data_out.instructions(1).r2
add wave -noupdate -label r3 -radix hexadecimal /cpu_test/dut/front/id_stage_inst/data_out.instructions(1).r3
add wave -noupdate -label imm -radix hexadecimal /cpu_test/dut/front/id_stage_inst/data_out.instructions(1).imm
add wave -noupdate -label offset -radix hexadecimal /cpu_test/dut/front/id_stage_inst/data_out.instructions(1).offset
add wave -noupdate -label valid -radix hexadecimal /cpu_test/dut/front/id_stage_inst/data_out.instructions(1).valid
add wave -noupdate -divider -height 50 MIDDLE
add wave -noupdate -divider -height 30 {Hazard detektor}
add wave -noupdate -label {ready bits} -radix hexadecimal -childformat {{/cpu_test/dut/middle_inst/haz_d/in_control.inst_ready(0) -radix hexadecimal} {/cpu_test/dut/middle_inst/haz_d/in_control.inst_ready(1) -radix hexadecimal}} -expand -subitemconfig {/cpu_test/dut/middle_inst/haz_d/in_control.inst_ready(0) {-height 15 -radix hexadecimal} /cpu_test/dut/middle_inst/haz_d/in_control.inst_ready(1) {-height 15 -radix hexadecimal}} /cpu_test/dut/middle_inst/haz_d/in_control.inst_ready
add wave -noupdate -label mem_busy -radix hexadecimal /cpu_test/dut/middle_inst/haz_d/in_control.mem_busy
add wave -noupdate -label mem_read -radix hexadecimal /cpu_test/dut/middle_inst/haz_d/in_control.mem_load
add wave -noupdate -label mem_reg -radix hexadecimal /cpu_test/dut/middle_inst/haz_d/in_control.mem_reg
add wave -noupdate -label hazard_type -radix hexadecimal /cpu_test/dut/middle_inst/haz_d/out_control.haz_type
add wave -noupdate -divider -height 35 {Stall generator}
add wave -noupdate -label hazard_type -radix hexadecimal /cpu_test/dut/middle_inst/stall_g/in_control.haz_type
add wave -noupdate -label mem_done -radix hexadecimal /cpu_test/dut/middle_inst/stall_g/in_control.mem_done
add wave -noupdate -divider {Kontrolni signali}
add wave -noupdate -radix hexadecimal /cpu_test/dut/middle_inst/stall_g/out_control.stall
add wave -noupdate -label {go signals} -radix hexadecimal -childformat {{/cpu_test/dut/middle_inst/stall_g/out_control.inst_go(0) -radix hexadecimal} {/cpu_test/dut/middle_inst/stall_g/out_control.inst_go(1) -radix hexadecimal}} -expand -subitemconfig {/cpu_test/dut/middle_inst/stall_g/out_control.inst_go(0) {-radix hexadecimal} /cpu_test/dut/middle_inst/stall_g/out_control.inst_go(1) {-radix hexadecimal}} /cpu_test/dut/middle_inst/stall_g/out_control.inst_go
add wave -noupdate -label {ready bits} -radix hexadecimal -childformat {{/cpu_test/dut/middle_inst/stall_g/out_control.inst_ready(0) -radix hexadecimal} {/cpu_test/dut/middle_inst/stall_g/out_control.inst_ready(1) -radix hexadecimal}} -expand -subitemconfig {/cpu_test/dut/middle_inst/stall_g/out_control.inst_ready(0) {-radix hexadecimal} /cpu_test/dut/middle_inst/stall_g/out_control.inst_ready(1) {-radix hexadecimal}} /cpu_test/dut/middle_inst/stall_g/out_control.inst_ready
add wave -noupdate -divider -height 35 Switch
add wave -noupdate -label {input go signals} -radix hexadecimal -childformat {{/cpu_test/dut/middle_inst/sw/control_in.inst_go(0) -radix hexadecimal} {/cpu_test/dut/middle_inst/sw/control_in.inst_go(1) -radix hexadecimal}} -expand -subitemconfig {/cpu_test/dut/middle_inst/sw/control_in.inst_go(0) {-radix hexadecimal} /cpu_test/dut/middle_inst/sw/control_in.inst_go(1) {-radix hexadecimal}} /cpu_test/dut/middle_inst/sw/control_in.inst_go
add wave -noupdate -label stop -radix hexadecimal /cpu_test/dut/middle_inst/sw/control_in.stop
add wave -noupdate -divider {Kontrolni go signali}
add wave -noupdate -label {ALU_0 go} -radix hexadecimal /cpu_test/dut/middle_inst/sw/data_out.func_control.alu_control(0).go
add wave -noupdate -label {ALU_1 go} -radix hexadecimal /cpu_test/dut/middle_inst/sw/data_out.func_control.alu_control(1).go
add wave -noupdate -label {Branch go} -radix hexadecimal /cpu_test/dut/middle_inst/sw/data_out.func_control.br_control.go
add wave -noupdate -label {Mem_unit go} -radix hexadecimal /cpu_test/dut/middle_inst/sw/data_out.func_control.mem_control.go
add wave -noupdate -divider Registri
add wave -noupdate -label R1 -radix hexadecimal /cpu_test/dut/middle_inst/sw/data_out.r1
add wave -noupdate -label R3 -radix hexadecimal /cpu_test/dut/middle_inst/sw/data_out.r3
add wave -noupdate -divider -height 35 Stopko
add wave -noupdate -label mem_busy -radix hexadecimal /cpu_test/dut/middle_inst/stopko/in_control.mem_busy
add wave -noupdate -label stop -radix hexadecimal /cpu_test/dut/middle_inst/stopko/out_control.stop
add wave -noupdate -label stall -radix hexadecimal /cpu_test/dut/middle_inst/stopko/out_control.stall
add wave -noupdate -divider -height 35 {JZP - ALU_0_0}
add wave -noupdate -radix hexadecimal -childformat {{/cpu_test/dut/middle_inst/jzp_for(0)/jzp_inst/in_data.from_wsu(0).address -radix hexadecimal} {/cpu_test/dut/middle_inst/jzp_for(0)/jzp_inst/in_data.from_wsu(0).value -radix hexadecimal} {/cpu_test/dut/middle_inst/jzp_for(0)/jzp_inst/in_data.from_wsu(0).write -radix hexadecimal}} -expand -subitemconfig {/cpu_test/dut/middle_inst/jzp_for(0)/jzp_inst/in_data.from_wsu(0).address {-radix hexadecimal} /cpu_test/dut/middle_inst/jzp_for(0)/jzp_inst/in_data.from_wsu(0).value {-radix hexadecimal} /cpu_test/dut/middle_inst/jzp_for(0)/jzp_inst/in_data.from_wsu(0).write {-radix hexadecimal}} /cpu_test/dut/middle_inst/jzp_for(0)/jzp_inst/in_data.from_wsu(0)
add wave -noupdate -radix hexadecimal -childformat {{/cpu_test/dut/middle_inst/jzp_for(0)/jzp_inst/in_data.from_wsu(1).address -radix hexadecimal} {/cpu_test/dut/middle_inst/jzp_for(0)/jzp_inst/in_data.from_wsu(1).value -radix hexadecimal} {/cpu_test/dut/middle_inst/jzp_for(0)/jzp_inst/in_data.from_wsu(1).write -radix hexadecimal}} -expand -subitemconfig {/cpu_test/dut/middle_inst/jzp_for(0)/jzp_inst/in_data.from_wsu(1).address {-radix hexadecimal} /cpu_test/dut/middle_inst/jzp_for(0)/jzp_inst/in_data.from_wsu(1).value {-radix hexadecimal} /cpu_test/dut/middle_inst/jzp_for(0)/jzp_inst/in_data.from_wsu(1).write {-radix hexadecimal}} /cpu_test/dut/middle_inst/jzp_for(0)/jzp_inst/in_data.from_wsu(1)
add wave -noupdate -radix hexadecimal -childformat {{/cpu_test/dut/middle_inst/jzp_for(0)/jzp_inst/in_data.from_wsu(2).address -radix hexadecimal} {/cpu_test/dut/middle_inst/jzp_for(0)/jzp_inst/in_data.from_wsu(2).value -radix hexadecimal} {/cpu_test/dut/middle_inst/jzp_for(0)/jzp_inst/in_data.from_wsu(2).write -radix hexadecimal}} -expand -subitemconfig {/cpu_test/dut/middle_inst/jzp_for(0)/jzp_inst/in_data.from_wsu(2).address {-radix hexadecimal} /cpu_test/dut/middle_inst/jzp_for(0)/jzp_inst/in_data.from_wsu(2).value {-radix hexadecimal} /cpu_test/dut/middle_inst/jzp_for(0)/jzp_inst/in_data.from_wsu(2).write {-radix hexadecimal}} /cpu_test/dut/middle_inst/jzp_for(0)/jzp_inst/in_data.from_wsu(2)
add wave -noupdate -radix hexadecimal -childformat {{/cpu_test/dut/middle_inst/jzp_for(0)/jzp_inst/in_data.from_wsu(3).address -radix hexadecimal} {/cpu_test/dut/middle_inst/jzp_for(0)/jzp_inst/in_data.from_wsu(3).value -radix hexadecimal} {/cpu_test/dut/middle_inst/jzp_for(0)/jzp_inst/in_data.from_wsu(3).write -radix hexadecimal}} -expand -subitemconfig {/cpu_test/dut/middle_inst/jzp_for(0)/jzp_inst/in_data.from_wsu(3).address {-radix hexadecimal} /cpu_test/dut/middle_inst/jzp_for(0)/jzp_inst/in_data.from_wsu(3).value {-radix hexadecimal} /cpu_test/dut/middle_inst/jzp_for(0)/jzp_inst/in_data.from_wsu(3).write {-radix hexadecimal}} /cpu_test/dut/middle_inst/jzp_for(0)/jzp_inst/in_data.from_wsu(3)
add wave -noupdate -label from_gpr -radix hexadecimal /cpu_test/dut/middle_inst/jzp_for(0)/jzp_inst/in_data.from_gpr
add wave -noupdate -label {reg address} -radix hexadecimal -childformat {{/cpu_test/dut/middle_inst/jzp_for(0)/jzp_inst/in_data.address(4) -radix hexadecimal} {/cpu_test/dut/middle_inst/jzp_for(0)/jzp_inst/in_data.address(3) -radix hexadecimal} {/cpu_test/dut/middle_inst/jzp_for(0)/jzp_inst/in_data.address(2) -radix hexadecimal} {/cpu_test/dut/middle_inst/jzp_for(0)/jzp_inst/in_data.address(1) -radix hexadecimal} {/cpu_test/dut/middle_inst/jzp_for(0)/jzp_inst/in_data.address(0) -radix hexadecimal}} -subitemconfig {/cpu_test/dut/middle_inst/jzp_for(0)/jzp_inst/in_data.address(4) {-radix hexadecimal} /cpu_test/dut/middle_inst/jzp_for(0)/jzp_inst/in_data.address(3) {-radix hexadecimal} /cpu_test/dut/middle_inst/jzp_for(0)/jzp_inst/in_data.address(2) {-radix hexadecimal} /cpu_test/dut/middle_inst/jzp_for(0)/jzp_inst/in_data.address(1) {-radix hexadecimal} /cpu_test/dut/middle_inst/jzp_for(0)/jzp_inst/in_data.address(0) {-radix hexadecimal}} /cpu_test/dut/middle_inst/jzp_for(0)/jzp_inst/in_data.address
add wave -noupdate -label {forwarded value} -radix hexadecimal /cpu_test/dut/middle_inst/jzp_for(0)/jzp_inst/out_data.out_value
add wave -noupdate -divider -height 35 {JZP - ALU_0_1}
add wave -noupdate -radix hexadecimal -childformat {{/cpu_test/dut/middle_inst/jzp_for(1)/jzp_inst/in_data.from_wsu(0).address -radix hexadecimal} {/cpu_test/dut/middle_inst/jzp_for(1)/jzp_inst/in_data.from_wsu(0).value -radix hexadecimal} {/cpu_test/dut/middle_inst/jzp_for(1)/jzp_inst/in_data.from_wsu(0).write -radix hexadecimal}} -expand -subitemconfig {/cpu_test/dut/middle_inst/jzp_for(1)/jzp_inst/in_data.from_wsu(0).address {-radix hexadecimal} /cpu_test/dut/middle_inst/jzp_for(1)/jzp_inst/in_data.from_wsu(0).value {-radix hexadecimal} /cpu_test/dut/middle_inst/jzp_for(1)/jzp_inst/in_data.from_wsu(0).write {-radix hexadecimal}} /cpu_test/dut/middle_inst/jzp_for(1)/jzp_inst/in_data.from_wsu(0)
add wave -noupdate -radix hexadecimal -childformat {{/cpu_test/dut/middle_inst/jzp_for(1)/jzp_inst/in_data.from_wsu(1).address -radix hexadecimal} {/cpu_test/dut/middle_inst/jzp_for(1)/jzp_inst/in_data.from_wsu(1).value -radix hexadecimal} {/cpu_test/dut/middle_inst/jzp_for(1)/jzp_inst/in_data.from_wsu(1).write -radix hexadecimal}} -expand -subitemconfig {/cpu_test/dut/middle_inst/jzp_for(1)/jzp_inst/in_data.from_wsu(1).address {-radix hexadecimal} /cpu_test/dut/middle_inst/jzp_for(1)/jzp_inst/in_data.from_wsu(1).value {-radix hexadecimal} /cpu_test/dut/middle_inst/jzp_for(1)/jzp_inst/in_data.from_wsu(1).write {-radix hexadecimal}} /cpu_test/dut/middle_inst/jzp_for(1)/jzp_inst/in_data.from_wsu(1)
add wave -noupdate -radix hexadecimal -childformat {{/cpu_test/dut/middle_inst/jzp_for(1)/jzp_inst/in_data.from_wsu(2).address -radix hexadecimal} {/cpu_test/dut/middle_inst/jzp_for(1)/jzp_inst/in_data.from_wsu(2).value -radix hexadecimal} {/cpu_test/dut/middle_inst/jzp_for(1)/jzp_inst/in_data.from_wsu(2).write -radix hexadecimal}} -expand -subitemconfig {/cpu_test/dut/middle_inst/jzp_for(1)/jzp_inst/in_data.from_wsu(2).address {-radix hexadecimal} /cpu_test/dut/middle_inst/jzp_for(1)/jzp_inst/in_data.from_wsu(2).value {-radix hexadecimal} /cpu_test/dut/middle_inst/jzp_for(1)/jzp_inst/in_data.from_wsu(2).write {-radix hexadecimal}} /cpu_test/dut/middle_inst/jzp_for(1)/jzp_inst/in_data.from_wsu(2)
add wave -noupdate -radix hexadecimal -childformat {{/cpu_test/dut/middle_inst/jzp_for(1)/jzp_inst/in_data.from_wsu(3).address -radix hexadecimal} {/cpu_test/dut/middle_inst/jzp_for(1)/jzp_inst/in_data.from_wsu(3).value -radix hexadecimal} {/cpu_test/dut/middle_inst/jzp_for(1)/jzp_inst/in_data.from_wsu(3).write -radix hexadecimal}} -expand -subitemconfig {/cpu_test/dut/middle_inst/jzp_for(1)/jzp_inst/in_data.from_wsu(3).address {-radix hexadecimal} /cpu_test/dut/middle_inst/jzp_for(1)/jzp_inst/in_data.from_wsu(3).value {-radix hexadecimal} /cpu_test/dut/middle_inst/jzp_for(1)/jzp_inst/in_data.from_wsu(3).write {-radix hexadecimal}} /cpu_test/dut/middle_inst/jzp_for(1)/jzp_inst/in_data.from_wsu(3)
add wave -noupdate -label from_gpr -radix hexadecimal /cpu_test/dut/middle_inst/jzp_for(1)/jzp_inst/in_data.from_gpr
add wave -noupdate -label reg_address -radix hexadecimal /cpu_test/dut/middle_inst/jzp_for(1)/jzp_inst/in_data.address
add wave -noupdate -label {forwarded value} -radix hexadecimal /cpu_test/dut/middle_inst/jzp_for(1)/jzp_inst/out_data.out_value
add wave -noupdate -divider -height 35 {JZP ALU_1_0}
add wave -noupdate -radix hexadecimal -childformat {{/cpu_test/dut/middle_inst/jzp_for(2)/jzp_inst/in_data.from_wsu(0).address -radix hexadecimal} {/cpu_test/dut/middle_inst/jzp_for(2)/jzp_inst/in_data.from_wsu(0).value -radix hexadecimal} {/cpu_test/dut/middle_inst/jzp_for(2)/jzp_inst/in_data.from_wsu(0).write -radix hexadecimal}} -expand -subitemconfig {/cpu_test/dut/middle_inst/jzp_for(2)/jzp_inst/in_data.from_wsu(0).address {-radix hexadecimal} /cpu_test/dut/middle_inst/jzp_for(2)/jzp_inst/in_data.from_wsu(0).value {-radix hexadecimal} /cpu_test/dut/middle_inst/jzp_for(2)/jzp_inst/in_data.from_wsu(0).write {-radix hexadecimal}} /cpu_test/dut/middle_inst/jzp_for(2)/jzp_inst/in_data.from_wsu(0)
add wave -noupdate -radix hexadecimal -childformat {{/cpu_test/dut/middle_inst/jzp_for(2)/jzp_inst/in_data.from_wsu(1).address -radix hexadecimal} {/cpu_test/dut/middle_inst/jzp_for(2)/jzp_inst/in_data.from_wsu(1).value -radix hexadecimal} {/cpu_test/dut/middle_inst/jzp_for(2)/jzp_inst/in_data.from_wsu(1).write -radix hexadecimal}} -expand -subitemconfig {/cpu_test/dut/middle_inst/jzp_for(2)/jzp_inst/in_data.from_wsu(1).address {-radix hexadecimal} /cpu_test/dut/middle_inst/jzp_for(2)/jzp_inst/in_data.from_wsu(1).value {-radix hexadecimal} /cpu_test/dut/middle_inst/jzp_for(2)/jzp_inst/in_data.from_wsu(1).write {-radix hexadecimal}} /cpu_test/dut/middle_inst/jzp_for(2)/jzp_inst/in_data.from_wsu(1)
add wave -noupdate -radix hexadecimal -childformat {{/cpu_test/dut/middle_inst/jzp_for(2)/jzp_inst/in_data.from_wsu(2).address -radix hexadecimal} {/cpu_test/dut/middle_inst/jzp_for(2)/jzp_inst/in_data.from_wsu(2).value -radix hexadecimal} {/cpu_test/dut/middle_inst/jzp_for(2)/jzp_inst/in_data.from_wsu(2).write -radix hexadecimal}} -expand -subitemconfig {/cpu_test/dut/middle_inst/jzp_for(2)/jzp_inst/in_data.from_wsu(2).address {-radix hexadecimal} /cpu_test/dut/middle_inst/jzp_for(2)/jzp_inst/in_data.from_wsu(2).value {-radix hexadecimal} /cpu_test/dut/middle_inst/jzp_for(2)/jzp_inst/in_data.from_wsu(2).write {-radix hexadecimal}} /cpu_test/dut/middle_inst/jzp_for(2)/jzp_inst/in_data.from_wsu(2)
add wave -noupdate -radix hexadecimal -childformat {{/cpu_test/dut/middle_inst/jzp_for(2)/jzp_inst/in_data.from_wsu(3).address -radix hexadecimal} {/cpu_test/dut/middle_inst/jzp_for(2)/jzp_inst/in_data.from_wsu(3).value -radix hexadecimal} {/cpu_test/dut/middle_inst/jzp_for(2)/jzp_inst/in_data.from_wsu(3).write -radix hexadecimal}} -expand -subitemconfig {/cpu_test/dut/middle_inst/jzp_for(2)/jzp_inst/in_data.from_wsu(3).address {-radix hexadecimal} /cpu_test/dut/middle_inst/jzp_for(2)/jzp_inst/in_data.from_wsu(3).value {-radix hexadecimal} /cpu_test/dut/middle_inst/jzp_for(2)/jzp_inst/in_data.from_wsu(3).write {-radix hexadecimal}} /cpu_test/dut/middle_inst/jzp_for(2)/jzp_inst/in_data.from_wsu(3)
add wave -noupdate -label from_gpr -radix hexadecimal /cpu_test/dut/middle_inst/jzp_for(2)/jzp_inst/in_data.from_gpr
add wave -noupdate -label reg_address -radix hexadecimal /cpu_test/dut/middle_inst/jzp_for(2)/jzp_inst/in_data.address
add wave -noupdate -label {forwarded value} -radix hexadecimal /cpu_test/dut/middle_inst/jzp_for(2)/jzp_inst/out_data.out_value
add wave -noupdate -divider -height 35 {JZP ALU_1_1}
add wave -noupdate -radix hexadecimal -childformat {{/cpu_test/dut/middle_inst/jzp_for(3)/jzp_inst/in_data.from_wsu(0).address -radix hexadecimal} {/cpu_test/dut/middle_inst/jzp_for(3)/jzp_inst/in_data.from_wsu(0).value -radix hexadecimal} {/cpu_test/dut/middle_inst/jzp_for(3)/jzp_inst/in_data.from_wsu(0).write -radix hexadecimal}} -expand -subitemconfig {/cpu_test/dut/middle_inst/jzp_for(3)/jzp_inst/in_data.from_wsu(0).address {-radix hexadecimal} /cpu_test/dut/middle_inst/jzp_for(3)/jzp_inst/in_data.from_wsu(0).value {-radix hexadecimal} /cpu_test/dut/middle_inst/jzp_for(3)/jzp_inst/in_data.from_wsu(0).write {-radix hexadecimal}} /cpu_test/dut/middle_inst/jzp_for(3)/jzp_inst/in_data.from_wsu(0)
add wave -noupdate -radix hexadecimal -childformat {{/cpu_test/dut/middle_inst/jzp_for(3)/jzp_inst/in_data.from_wsu(1).address -radix hexadecimal} {/cpu_test/dut/middle_inst/jzp_for(3)/jzp_inst/in_data.from_wsu(1).value -radix hexadecimal} {/cpu_test/dut/middle_inst/jzp_for(3)/jzp_inst/in_data.from_wsu(1).write -radix hexadecimal}} -expand -subitemconfig {/cpu_test/dut/middle_inst/jzp_for(3)/jzp_inst/in_data.from_wsu(1).address {-radix hexadecimal} /cpu_test/dut/middle_inst/jzp_for(3)/jzp_inst/in_data.from_wsu(1).value {-radix hexadecimal} /cpu_test/dut/middle_inst/jzp_for(3)/jzp_inst/in_data.from_wsu(1).write {-radix hexadecimal}} /cpu_test/dut/middle_inst/jzp_for(3)/jzp_inst/in_data.from_wsu(1)
add wave -noupdate -radix hexadecimal -childformat {{/cpu_test/dut/middle_inst/jzp_for(3)/jzp_inst/in_data.from_wsu(2).address -radix hexadecimal} {/cpu_test/dut/middle_inst/jzp_for(3)/jzp_inst/in_data.from_wsu(2).value -radix hexadecimal} {/cpu_test/dut/middle_inst/jzp_for(3)/jzp_inst/in_data.from_wsu(2).write -radix hexadecimal}} -expand -subitemconfig {/cpu_test/dut/middle_inst/jzp_for(3)/jzp_inst/in_data.from_wsu(2).address {-radix hexadecimal} /cpu_test/dut/middle_inst/jzp_for(3)/jzp_inst/in_data.from_wsu(2).value {-radix hexadecimal} /cpu_test/dut/middle_inst/jzp_for(3)/jzp_inst/in_data.from_wsu(2).write {-radix hexadecimal}} /cpu_test/dut/middle_inst/jzp_for(3)/jzp_inst/in_data.from_wsu(2)
add wave -noupdate -radix hexadecimal -childformat {{/cpu_test/dut/middle_inst/jzp_for(3)/jzp_inst/in_data.from_wsu(3).address -radix hexadecimal} {/cpu_test/dut/middle_inst/jzp_for(3)/jzp_inst/in_data.from_wsu(3).value -radix hexadecimal} {/cpu_test/dut/middle_inst/jzp_for(3)/jzp_inst/in_data.from_wsu(3).write -radix hexadecimal}} -expand -subitemconfig {/cpu_test/dut/middle_inst/jzp_for(3)/jzp_inst/in_data.from_wsu(3).address {-radix hexadecimal} /cpu_test/dut/middle_inst/jzp_for(3)/jzp_inst/in_data.from_wsu(3).value {-radix hexadecimal} /cpu_test/dut/middle_inst/jzp_for(3)/jzp_inst/in_data.from_wsu(3).write {-radix hexadecimal}} /cpu_test/dut/middle_inst/jzp_for(3)/jzp_inst/in_data.from_wsu(3)
add wave -noupdate -label from_gpr -radix hexadecimal /cpu_test/dut/middle_inst/jzp_for(3)/jzp_inst/in_data.from_gpr
add wave -noupdate -label reg_address -radix hexadecimal /cpu_test/dut/middle_inst/jzp_for(3)/jzp_inst/in_data.address
add wave -noupdate -label {forwarded value} -radix hexadecimal /cpu_test/dut/middle_inst/jzp_for(3)/jzp_inst/out_data.out_value
add wave -noupdate -divider -height 35 {JZP MEM_0}
add wave -noupdate -radix hexadecimal -childformat {{/cpu_test/dut/middle_inst/jzp_for(4)/jzp_inst/in_data.from_wsu(0).address -radix hexadecimal} {/cpu_test/dut/middle_inst/jzp_for(4)/jzp_inst/in_data.from_wsu(0).value -radix hexadecimal} {/cpu_test/dut/middle_inst/jzp_for(4)/jzp_inst/in_data.from_wsu(0).write -radix hexadecimal}} -expand -subitemconfig {/cpu_test/dut/middle_inst/jzp_for(4)/jzp_inst/in_data.from_wsu(0).address {-radix hexadecimal} /cpu_test/dut/middle_inst/jzp_for(4)/jzp_inst/in_data.from_wsu(0).value {-radix hexadecimal} /cpu_test/dut/middle_inst/jzp_for(4)/jzp_inst/in_data.from_wsu(0).write {-radix hexadecimal}} /cpu_test/dut/middle_inst/jzp_for(4)/jzp_inst/in_data.from_wsu(0)
add wave -noupdate -radix hexadecimal -childformat {{/cpu_test/dut/middle_inst/jzp_for(4)/jzp_inst/in_data.from_wsu(1).address -radix hexadecimal} {/cpu_test/dut/middle_inst/jzp_for(4)/jzp_inst/in_data.from_wsu(1).value -radix hexadecimal} {/cpu_test/dut/middle_inst/jzp_for(4)/jzp_inst/in_data.from_wsu(1).write -radix hexadecimal}} -expand -subitemconfig {/cpu_test/dut/middle_inst/jzp_for(4)/jzp_inst/in_data.from_wsu(1).address {-radix hexadecimal} /cpu_test/dut/middle_inst/jzp_for(4)/jzp_inst/in_data.from_wsu(1).value {-radix hexadecimal} /cpu_test/dut/middle_inst/jzp_for(4)/jzp_inst/in_data.from_wsu(1).write {-radix hexadecimal}} /cpu_test/dut/middle_inst/jzp_for(4)/jzp_inst/in_data.from_wsu(1)
add wave -noupdate -radix hexadecimal -childformat {{/cpu_test/dut/middle_inst/jzp_for(4)/jzp_inst/in_data.from_wsu(2).address -radix hexadecimal} {/cpu_test/dut/middle_inst/jzp_for(4)/jzp_inst/in_data.from_wsu(2).value -radix hexadecimal} {/cpu_test/dut/middle_inst/jzp_for(4)/jzp_inst/in_data.from_wsu(2).write -radix hexadecimal}} -expand -subitemconfig {/cpu_test/dut/middle_inst/jzp_for(4)/jzp_inst/in_data.from_wsu(2).address {-radix hexadecimal} /cpu_test/dut/middle_inst/jzp_for(4)/jzp_inst/in_data.from_wsu(2).value {-radix hexadecimal} /cpu_test/dut/middle_inst/jzp_for(4)/jzp_inst/in_data.from_wsu(2).write {-radix hexadecimal}} /cpu_test/dut/middle_inst/jzp_for(4)/jzp_inst/in_data.from_wsu(2)
add wave -noupdate -radix hexadecimal -childformat {{/cpu_test/dut/middle_inst/jzp_for(4)/jzp_inst/in_data.from_wsu(3).address -radix hexadecimal} {/cpu_test/dut/middle_inst/jzp_for(4)/jzp_inst/in_data.from_wsu(3).value -radix hexadecimal} {/cpu_test/dut/middle_inst/jzp_for(4)/jzp_inst/in_data.from_wsu(3).write -radix hexadecimal}} -expand -subitemconfig {/cpu_test/dut/middle_inst/jzp_for(4)/jzp_inst/in_data.from_wsu(3).address {-radix hexadecimal} /cpu_test/dut/middle_inst/jzp_for(4)/jzp_inst/in_data.from_wsu(3).value {-radix hexadecimal} /cpu_test/dut/middle_inst/jzp_for(4)/jzp_inst/in_data.from_wsu(3).write {-radix hexadecimal}} /cpu_test/dut/middle_inst/jzp_for(4)/jzp_inst/in_data.from_wsu(3)
add wave -noupdate -label from_gpr -radix hexadecimal /cpu_test/dut/middle_inst/jzp_for(4)/jzp_inst/in_data.from_gpr
add wave -noupdate -label reg_address -radix hexadecimal /cpu_test/dut/middle_inst/jzp_for(4)/jzp_inst/in_data.address
add wave -noupdate -label {forwarded value} -radix hexadecimal /cpu_test/dut/middle_inst/jzp_for(4)/jzp_inst/out_data.out_value
add wave -noupdate -divider -height 35 {JZP MEM_1}
add wave -noupdate -radix hexadecimal -childformat {{/cpu_test/dut/middle_inst/jzp_for(5)/jzp_inst/in_data.from_wsu(0).address -radix hexadecimal} {/cpu_test/dut/middle_inst/jzp_for(5)/jzp_inst/in_data.from_wsu(0).value -radix hexadecimal} {/cpu_test/dut/middle_inst/jzp_for(5)/jzp_inst/in_data.from_wsu(0).write -radix hexadecimal}} -expand -subitemconfig {/cpu_test/dut/middle_inst/jzp_for(5)/jzp_inst/in_data.from_wsu(0).address {-radix hexadecimal} /cpu_test/dut/middle_inst/jzp_for(5)/jzp_inst/in_data.from_wsu(0).value {-radix hexadecimal} /cpu_test/dut/middle_inst/jzp_for(5)/jzp_inst/in_data.from_wsu(0).write {-radix hexadecimal}} /cpu_test/dut/middle_inst/jzp_for(5)/jzp_inst/in_data.from_wsu(0)
add wave -noupdate -radix hexadecimal -childformat {{/cpu_test/dut/middle_inst/jzp_for(5)/jzp_inst/in_data.from_wsu(1).address -radix hexadecimal} {/cpu_test/dut/middle_inst/jzp_for(5)/jzp_inst/in_data.from_wsu(1).value -radix hexadecimal} {/cpu_test/dut/middle_inst/jzp_for(5)/jzp_inst/in_data.from_wsu(1).write -radix hexadecimal}} -expand -subitemconfig {/cpu_test/dut/middle_inst/jzp_for(5)/jzp_inst/in_data.from_wsu(1).address {-radix hexadecimal} /cpu_test/dut/middle_inst/jzp_for(5)/jzp_inst/in_data.from_wsu(1).value {-radix hexadecimal} /cpu_test/dut/middle_inst/jzp_for(5)/jzp_inst/in_data.from_wsu(1).write {-radix hexadecimal}} /cpu_test/dut/middle_inst/jzp_for(5)/jzp_inst/in_data.from_wsu(1)
add wave -noupdate -radix hexadecimal -childformat {{/cpu_test/dut/middle_inst/jzp_for(5)/jzp_inst/in_data.from_wsu(2).address -radix hexadecimal} {/cpu_test/dut/middle_inst/jzp_for(5)/jzp_inst/in_data.from_wsu(2).value -radix hexadecimal} {/cpu_test/dut/middle_inst/jzp_for(5)/jzp_inst/in_data.from_wsu(2).write -radix hexadecimal}} -expand -subitemconfig {/cpu_test/dut/middle_inst/jzp_for(5)/jzp_inst/in_data.from_wsu(2).address {-radix hexadecimal} /cpu_test/dut/middle_inst/jzp_for(5)/jzp_inst/in_data.from_wsu(2).value {-radix hexadecimal} /cpu_test/dut/middle_inst/jzp_for(5)/jzp_inst/in_data.from_wsu(2).write {-radix hexadecimal}} /cpu_test/dut/middle_inst/jzp_for(5)/jzp_inst/in_data.from_wsu(2)
add wave -noupdate -radix hexadecimal -childformat {{/cpu_test/dut/middle_inst/jzp_for(5)/jzp_inst/in_data.from_wsu(3).address -radix hexadecimal} {/cpu_test/dut/middle_inst/jzp_for(5)/jzp_inst/in_data.from_wsu(3).value -radix hexadecimal} {/cpu_test/dut/middle_inst/jzp_for(5)/jzp_inst/in_data.from_wsu(3).write -radix hexadecimal}} -expand -subitemconfig {/cpu_test/dut/middle_inst/jzp_for(5)/jzp_inst/in_data.from_wsu(3).address {-radix hexadecimal} /cpu_test/dut/middle_inst/jzp_for(5)/jzp_inst/in_data.from_wsu(3).value {-radix hexadecimal} /cpu_test/dut/middle_inst/jzp_for(5)/jzp_inst/in_data.from_wsu(3).write {-radix hexadecimal}} /cpu_test/dut/middle_inst/jzp_for(5)/jzp_inst/in_data.from_wsu(3)
add wave -noupdate -label from_gpr -radix hexadecimal /cpu_test/dut/middle_inst/jzp_for(5)/jzp_inst/in_data.from_gpr
add wave -noupdate -label reg_address -radix hexadecimal /cpu_test/dut/middle_inst/jzp_for(5)/jzp_inst/in_data.address
add wave -noupdate -label {forwarded value} -radix hexadecimal /cpu_test/dut/middle_inst/jzp_for(5)/jzp_inst/out_data.out_value
add wave -noupdate -divider -height 50 BACKEND
add wave -noupdate -divider -height 35 {ALU 0}
add wave -noupdate -label go -radix hexadecimal /cpu_test/dut/backend_inst/generate_alu(0)/alu_unit_inst/in_control.go
add wave -noupdate -label instruction -radix hexadecimal -childformat {{/cpu_test/dut/backend_inst/generate_alu(0)/alu_unit_inst/in_data.instruction.pc -radix hexadecimal} {/cpu_test/dut/backend_inst/generate_alu(0)/alu_unit_inst/in_data.instruction.op -radix hexadecimal} {/cpu_test/dut/backend_inst/generate_alu(0)/alu_unit_inst/in_data.instruction.r1 -radix hexadecimal} {/cpu_test/dut/backend_inst/generate_alu(0)/alu_unit_inst/in_data.instruction.r2 -radix hexadecimal} {/cpu_test/dut/backend_inst/generate_alu(0)/alu_unit_inst/in_data.instruction.r3 -radix hexadecimal} {/cpu_test/dut/backend_inst/generate_alu(0)/alu_unit_inst/in_data.instruction.imm -radix hexadecimal} {/cpu_test/dut/backend_inst/generate_alu(0)/alu_unit_inst/in_data.instruction.offset -radix hexadecimal} {/cpu_test/dut/backend_inst/generate_alu(0)/alu_unit_inst/in_data.instruction.valid -radix hexadecimal}} -subitemconfig {/cpu_test/dut/backend_inst/generate_alu(0)/alu_unit_inst/in_data.instruction.pc {-radix hexadecimal} /cpu_test/dut/backend_inst/generate_alu(0)/alu_unit_inst/in_data.instruction.op {-radix hexadecimal} /cpu_test/dut/backend_inst/generate_alu(0)/alu_unit_inst/in_data.instruction.r1 {-radix hexadecimal} /cpu_test/dut/backend_inst/generate_alu(0)/alu_unit_inst/in_data.instruction.r2 {-radix hexadecimal} /cpu_test/dut/backend_inst/generate_alu(0)/alu_unit_inst/in_data.instruction.r3 {-radix hexadecimal} /cpu_test/dut/backend_inst/generate_alu(0)/alu_unit_inst/in_data.instruction.imm {-radix hexadecimal} /cpu_test/dut/backend_inst/generate_alu(0)/alu_unit_inst/in_data.instruction.offset {-radix hexadecimal} /cpu_test/dut/backend_inst/generate_alu(0)/alu_unit_inst/in_data.instruction.valid {-radix hexadecimal}} /cpu_test/dut/backend_inst/generate_alu(0)/alu_unit_inst/in_data.instruction
add wave -noupdate -label {operand A} -radix hexadecimal /cpu_test/dut/backend_inst/generate_alu(0)/alu_unit_inst/in_data.operand_A
add wave -noupdate -label {operand B} -radix hexadecimal /cpu_test/dut/backend_inst/generate_alu(0)/alu_unit_inst/in_data.operand_B
add wave -noupdate -label {in PSW} -radix hexadecimal /cpu_test/dut/backend_inst/generate_alu(0)/alu_unit_inst/in_data.psw
add wave -noupdate -label result -radix hexadecimal -childformat {{/cpu_test/dut/backend_inst/generate_alu(0)/alu_unit_inst/out_data.result.address -radix hexadecimal} {/cpu_test/dut/backend_inst/generate_alu(0)/alu_unit_inst/out_data.result.value -radix hexadecimal} {/cpu_test/dut/backend_inst/generate_alu(0)/alu_unit_inst/out_data.result.pc -radix hexadecimal} {/cpu_test/dut/backend_inst/generate_alu(0)/alu_unit_inst/out_data.result.valid -radix hexadecimal}} -subitemconfig {/cpu_test/dut/backend_inst/generate_alu(0)/alu_unit_inst/out_data.result.address {-radix hexadecimal} /cpu_test/dut/backend_inst/generate_alu(0)/alu_unit_inst/out_data.result.value {-radix hexadecimal} /cpu_test/dut/backend_inst/generate_alu(0)/alu_unit_inst/out_data.result.pc {-radix hexadecimal} /cpu_test/dut/backend_inst/generate_alu(0)/alu_unit_inst/out_data.result.valid {-radix hexadecimal}} /cpu_test/dut/backend_inst/generate_alu(0)/alu_unit_inst/out_data.result
add wave -noupdate -label {out PSW} -radix hexadecimal /cpu_test/dut/backend_inst/generate_alu(0)/alu_unit_inst/out_data.psw
add wave -noupdate -divider -height 35 {ALU 1}
add wave -noupdate -label go -radix hexadecimal /cpu_test/dut/backend_inst/generate_alu(1)/alu_unit_inst/in_control.go
add wave -noupdate -label instruction -radix hexadecimal /cpu_test/dut/backend_inst/generate_alu(1)/alu_unit_inst/in_data.instruction
add wave -noupdate -label {operand A} -radix hexadecimal /cpu_test/dut/backend_inst/generate_alu(1)/alu_unit_inst/in_data.operand_A
add wave -noupdate -label {operand B} -radix hexadecimal /cpu_test/dut/backend_inst/generate_alu(1)/alu_unit_inst/in_data.operand_B
add wave -noupdate -label {in PSW} -radix hexadecimal /cpu_test/dut/backend_inst/generate_alu(1)/alu_unit_inst/in_data.psw
add wave -noupdate -label result -radix hexadecimal /cpu_test/dut/backend_inst/generate_alu(1)/alu_unit_inst/out_data.result
add wave -noupdate -label {out PSW} -radix hexadecimal /cpu_test/dut/backend_inst/generate_alu(1)/alu_unit_inst/out_data.psw
add wave -noupdate -divider -height 35 {Branch unit}
add wave -noupdate -label go -radix hexadecimal /cpu_test/dut/backend_inst/branch_unit_inst/control_in.go
add wave -noupdate -label jump -radix hexadecimal /cpu_test/dut/backend_inst/branch_unit_inst/control_out.jump
add wave -noupdate -label write -radix hexadecimal /cpu_test/dut/backend_inst/branch_unit_inst/control_out.wr
add wave -noupdate -label PSW -radix hexadecimal /cpu_test/dut/backend_inst/branch_unit_inst/data_in.psw
add wave -noupdate -label instruction -radix hexadecimal /cpu_test/dut/backend_inst/branch_unit_inst/data_in.instruction
add wave -noupdate -radix hexadecimal /cpu_test/dut/backend_inst/branch_unit_inst/N
add wave -noupdate -radix hexadecimal /cpu_test/dut/backend_inst/branch_unit_inst/Z
add wave -noupdate -radix hexadecimal /cpu_test/dut/backend_inst/branch_unit_inst/C
add wave -noupdate -radix hexadecimal /cpu_test/dut/backend_inst/branch_unit_inst/V
add wave -noupdate -label {jump address} -radix hexadecimal /cpu_test/dut/backend_inst/branch_unit_inst/data_out.jump_address
add wave -noupdate -label {link address} -radix hexadecimal /cpu_test/dut/backend_inst/branch_unit_inst/data_out.link_address
add wave -noupdate -label {instruction pc} -radix hexadecimal /cpu_test/dut/backend_inst/branch_unit_inst/data_out.pc
add wave -noupdate -divider -height 35 {Mem unit}
add wave -noupdate -label go -radix hexadecimal /cpu_test/dut/backend_inst/mem_unit_inst/in_control.go
add wave -noupdate -label mem_load -radix hexadecimal /cpu_test/dut/backend_inst/mem_unit_inst/out_control.mem_load
add wave -noupdate -label mem_busy -radix hexadecimal /cpu_test/dut/backend_inst/mem_unit_inst/out_control.mem_busy
add wave -noupdate -label mem_done -radix hexadecimal /cpu_test/dut/backend_inst/mem_unit_inst/out_control.mem_done
add wave -noupdate -label read -radix hexadecimal /cpu_test/dut/backend_inst/mem_unit_inst/out_control.rd
add wave -noupdate -label write -radix hexadecimal /cpu_test/dut/backend_inst/mem_unit_inst/out_control.wr
add wave -noupdate -label instruction -radix hexadecimal /cpu_test/dut/backend_inst/mem_unit_inst/in_data.instruction
add wave -noupdate -label R1 -radix hexadecimal /cpu_test/dut/backend_inst/mem_unit_inst/in_data.address
add wave -noupdate -label R3 -radix hexadecimal /cpu_test/dut/backend_inst/mem_unit_inst/in_data.reg_value
add wave -noupdate -label DATA_IN -radix hexadecimal /cpu_test/dut/backend_inst/mem_unit_inst/in_data.data
add wave -noupdate -label reg_address -radix hexadecimal /cpu_test/dut/backend_inst/mem_unit_inst/out_data.mem_reg
add wave -noupdate -label address -radix hexadecimal /cpu_test/dut/backend_inst/mem_unit_inst/out_data.address
add wave -noupdate -label DATA_OUT -radix hexadecimal /cpu_test/dut/backend_inst/mem_unit_inst/out_data.data
add wave -noupdate -radix hexadecimal -childformat {{/cpu_test/dut/backend_inst/mem_unit_inst/out_data.wsu_data.address -radix hexadecimal} {/cpu_test/dut/backend_inst/mem_unit_inst/out_data.wsu_data.value -radix hexadecimal} {/cpu_test/dut/backend_inst/mem_unit_inst/out_data.wsu_data.pc -radix hexadecimal} {/cpu_test/dut/backend_inst/mem_unit_inst/out_data.wsu_data.valid -radix hexadecimal}} -expand -subitemconfig {/cpu_test/dut/backend_inst/mem_unit_inst/out_data.wsu_data.address {-radix hexadecimal} /cpu_test/dut/backend_inst/mem_unit_inst/out_data.wsu_data.value {-radix hexadecimal} /cpu_test/dut/backend_inst/mem_unit_inst/out_data.wsu_data.pc {-radix hexadecimal} /cpu_test/dut/backend_inst/mem_unit_inst/out_data.wsu_data.valid {-radix hexadecimal}} /cpu_test/dut/backend_inst/mem_unit_inst/out_data.wsu_data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 292
configure wave -valuecolwidth 298
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
WaveRestoreZoom {0 ps} {86528 ps}
