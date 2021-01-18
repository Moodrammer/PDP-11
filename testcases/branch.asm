; carry = 0
blo label_blo ; a = 0
NOP ; a = 1
NOP ; a = 2
NOP ; a = 3
NOP ; a = 4
NOP ; a = 5
NOP ; a = 6
label_blo: 
mov R7, R1 ; a = 7
; zero = 0
bne label_bne ; a = 8
NOP ; a = 9
NOP ; a = 10
NOP ; a = 11
label_bne:
mov R7, R1 ; a = 12
; no condition
br label_br ; a = 13
NOP ; a = 14
NOP ; a = 15
NOP ; a = 16
label_br:
mov R7, R1 ; a = 17
xor R0, R0 ; a = 18
bne label_blo ; a = 19
mov R7, R1 ; a = 20
NOP ; a = 21
NOP ; a = 22
NOP ; a = 23
; zero = 1
xor R0, R0 ; a = 24
beq label_beq ; a = 25
NOP ; a = 26
NOP ; a = 27
NOP ; a = 28
label_beq:
mov R7, R1 ; a = 29
NOP ; a = 30
NOP ; a = 31
NOP ; a = 32
; carry = 0 | zero = 1
bls label_bls ; a = 33
NOP ; a = 34
NOP ; a = 35
NOP ; a = 36
label_bls:
mov R7, R1 ; a = 37
NOP ; a = 38
NOP ; a = 39
NOP ; a = 40
mov #65535, R2 ; a = 41
lsl R2 ; a = 43
; carry = 1
bhi label_bhi ; a = 44
NOP ; a = 45
NOP ; a = 46
NOP ; a = 47
label_bhi: 
mov R7, R1 ; a = 48
NOP ; a = 49
NOP ; a =  50
NOP ; a = 51
; zero = 1 | carry = 1
mov #65535, R2 ; a = 52, 53
Add #1, R2 ; a = 54, 55
bhs label_bhs ; a = 56
NOP ; a = 57
NOP ; a = 58
NOP ; a = 59
label_bhs:
hlt ; a = 60