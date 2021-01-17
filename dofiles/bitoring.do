vsim work.bitoring
add wave -position insertpoint  \
sim:/bitoring/IR \
sim:/bitoring/or_dst \
sim:/bitoring/or_ind_src \
sim:/bitoring/or_ind_dst \
sim:/bitoring/or_result \
sim:/bitoring/or_branch \
sim:/bitoring/or_operation \
sim:/bitoring/zeroFlag \
sim:/bitoring/carryFlag \
sim:/bitoring/microIR \
sim:/bitoring/microIR_or_dst \
sim:/bitoring/microIR_or_ind_src \
sim:/bitoring/microIR_or_ind_dst \
sim:/bitoring/microIR_or_result \
sim:/bitoring/microIR_or_branch \
sim:/bitoring/microIR_or_operation

force -freeze sim:/bitoring/IR 0000000000000000 0
force -freeze sim:/bitoring/or_dst 0 0
force -freeze sim:/bitoring/or_ind_src 0 0
force -freeze sim:/bitoring/or_ind_dst 0 0
force -freeze sim:/bitoring/or_result 0 0
force -freeze sim:/bitoring/or_branch 0 0
force -freeze sim:/bitoring/or_operation 0 0
force -freeze sim:/bitoring/zeroFlag 0 0
force -freeze sim:/bitoring/carryFlag 0 0
run

# test or dst
force -freeze sim:/bitoring/IR 0000000000111000 0
force -freeze sim:/bitoring/or_dst 1 0
run


# test or ind src
force -freeze sim:/bitoring/or_dst 0 0
force -freeze sim:/bitoring/IR 0000000000111000 0
force -freeze sim:/bitoring/or_ind_src 1 0
run

# test or ind dst
force -freeze sim:/bitoring/or_ind_src 0 0
force -freeze sim:/bitoring/IR 0000000000110000 0
force -freeze sim:/bitoring/or_ind_dst 1 0
run

# test or result
force -freeze sim:/bitoring/or_ind_dst 0 0
force -freeze sim:/bitoring/IR 0000000000000000 0
force -freeze sim:/bitoring/or_result 1 0
run


# test or branch
force -freeze sim:/bitoring/or_result 0 0
force -freeze sim:/bitoring/IR 1101000100000000 0
force -freeze sim:/bitoring/or_branch 1 0
run


# test or operation
force -freeze sim:/bitoring/or_branch 0 0
force -freeze sim:/bitoring/IR 1011000100000000 0
force -freeze sim:/bitoring/or_operation 1 0
run
