vsim work.pdp11
add wave -position insertpoint  \
sim:/pdp11/internal_bus \
sim:/pdp11/register2 \
sim:/pdp11/register3 \
sim:/pdp11/register4 \
sim:/pdp11/register5 \
sim:/pdp11/register6 \
sim:/pdp11/register7 \
sim:/pdp11/tempregister \
sim:/pdp11/Yregister \
sim:/pdp11/Zregister \
sim:/pdp11/ram_out \
sim:/pdp11/carryFlag \
sim:/pdp11/zeroFlag \
sim:/pdp11/negativeFlag \
sim:/pdp11/ALU_output \
sim:/pdp11/halt \
sim:/pdp11/r_src_out \
sim:/pdp11/r_dst_out \
sim:/pdp11/r_src_in \
sim:/pdp11/r_dst_in \
sim:/pdp11/r0_out \
sim:/pdp11/r1_out \
sim:/pdp11/r2_out \
sim:/pdp11/r3_out \
sim:/pdp11/r4_out \
sim:/pdp11/r5_out \
sim:/pdp11/r6_out \
sim:/pdp11/r7_out \
sim:/pdp11/pc_out \
sim:/pdp11/pla_output \
sim:/pdp11/pla_out \
sim:/pdp11/ir_in \
sim:/pdp11/iregister \
sim:/pdp11/clock \
sim:/pdp11/clk \
sim:/pdp11/reset \
sim:/pdp11/register0 \
sim:/pdp11/register1 \
sim:/pdp11/mdregister \
sim:/pdp11/maregister \
sim:/pdp11/microAr_input \
sim:/pdp11/microAr_output \
sim:/pdp11/control_word \
sim:/pdp11/mdr_out \
sim:/pdp11/F10 \
sim:/pdp11/mem_read \
sim:/pdp11/mem_write \
sim:/pdp11/iregister_address \
sim:/pdp11/ir_address_out

mem load -i {G:/3rd grade CMP/1st term/Computer Architecture/project/PDP-11/rom.mem} /pdp11/rom/ram
mem load -i {G:/3rd grade CMP/1st term/Computer Architecture/project/PDP-11/memory.mem} /pdp11/ram0/ram

force -freeze sim:/pdp11/clock 1 0, 0 {50 ps} -r 100
force -freeze sim:/pdp11/reset 1 0
force -freeze sim:/pdp11/halt 0 0

run 
force -freeze sim:/pdp11/reset 0 0
noforce sim:/pdp11/halt
