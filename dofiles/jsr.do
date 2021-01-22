vsim work.pdp11
add wave -position insertpoint  -radix decimal\
sim:/pdp11/ram_out

add wave -position insertpoint  \
sim:/pdp11/carryFlag \
sim:/pdp11/zeroFlag \
sim:/pdp11/negativeFlag 

add wave -position insertpoint  -radix dec \
sim:/pdp11/ALU_output

add wave -position insertpoint  \
sim:/pdp11/halt 

add wave -position insertpoint -radix dec \
sim:/pdp11/tempregister \
sim:/pdp11/Yregister \
sim:/pdp11/Zregister 

add wave -position insertpoint  \
sim:/pdp11/iregister 

add wave -position insertpoint  -radix dec\
sim:/pdp11/internal_bus 

add wave -position insertpoint  \
sim:/pdp11/clock \
sim:/pdp11/reset 

add wave -position insertpoint -radix dec \
sim:/pdp11/register0 \
sim:/pdp11/register1 \
sim:/pdp11/register2 \
sim:/pdp11/register3 \
sim:/pdp11/register4 \
sim:/pdp11/register5 \
sim:/pdp11/register6 \
sim:/pdp11/register7 \
sim:/pdp11/maregister 

add wave -position insertpoint  \
sim:/pdp11/mdregister 

add wave -position insertpoint -radix oct \
sim:/pdp11/microAr_output

add wave -position insertpoint  \
sim:/pdp11/control_word 

mem load -i {<Path according to working directory>\PDP-11\rom.mem} /pdp11/rom/ram
mem load -i {<Path according to working directory>\PDP-11\testcases\jsr.mem} /pdp11/ram0/ram



force -freeze sim:/pdp11/clock 1 0, 0 {50 ps} -r 100
force -freeze sim:/pdp11/reset 1 0
force -freeze sim:/pdp11/halt 0 0

run 
force -freeze sim:/pdp11/reset 0 0
noforce sim:/pdp11/halt
