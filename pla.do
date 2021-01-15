vsim work.pla
add wave -position end  sim:/pla/i
add wave -position end  sim:/pla/o
force -freeze sim:/pla/i 1111000100000000 0
force -freeze sim:/pla/enable 1 0
run
force -freeze sim:/pla/i 1111001000000000 0
run
force -freeze sim:/pla/i 1111010000000000 0
run
force -freeze sim:/pla/i 1111001100000000 0
run
force -freeze sim:/pla/i 1111010100000000 0
run
force -freeze sim:/pla/i 1101010100000000 0
run
force -freeze sim:/pla/i 1011010100000000 0
run
force -freeze sim:/pla/i 1000010100000000 0
run


