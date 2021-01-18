mov #12 , R0 ; r0 = 12  ; address = 0, 1
mov #13 , R1 ; r1 = 13 ; address = 2, 3
add R0, R1 ; r1 = 25 ; address = 4
add #65535, R0 ; r0 = 11 c = 1 ; address = 5, 6
adc R0, R1 ; r1 = 37 ; address = 7
sub R0, R1 ; r1 = 26 ; address = 8
add #65535, R0 ; r0 = 10 carry = 1 ; address = 9, 10
sbc R0, R1 ; r1 = 15 ; address = 11
and R0, R1 ; r1 = 10 ; address = 12
or R0, R1 ; r1 = 10 ; address = 13
xor R0, R1 ; r1 = 0 ; address = 14
cmp R0, R1 ; not equal ; address = 15
bne labelx ;address = 16
mov #10, R0 ; not executed ; address = 17, 18
labelx  :
mov R1, R0 ; r0 = 5 ; address = 19
xor R1, R1 ; r1 = 0 ; address = 20
hlt
