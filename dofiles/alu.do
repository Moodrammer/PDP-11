vsim work.pdp11
add wave -position insertpoint  \
sim:/pdp11/clk\
sim:/pdp11/reset\
sim:/pdp11/internal_bus\
sim:/pdp11/Z_in\
sim:/pdp11/Yregister\
sim:/pdp11/F6\
sim:/pdp11/ALU_output\
sim:/pdp11/flagregister\
sim:/pdp11/ALU_carryFlag \
sim:/pdp11/ALU_zeroFlag \
sim:/pdp11/ALU_negativeFlag\

force -freeze sim:/pdp11/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/pdp11/internal_bus 16#aaaa 0
force -freeze sim:/pdp11/Yregister 16#0001 0
force -freeze sim:/pdp11/F6 0011 0
force -freeze sim:/pdp11/reset 1 0
force -freeze sim:/pdp11/Z_in 0 0


run

force -freeze sim:/pdp11/reset 0 0
