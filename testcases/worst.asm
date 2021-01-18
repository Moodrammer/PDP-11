mov #10, R0 ; address = 0, 1
mov #13, R1; address = 2, 3
add @3(R0), @1(R1); address = 4, 5, 6
NOP ; 7
NOP ; 8
NOP ; 9
NOP ; 10
NOP ; 11
HLT ; address = 12
Define X 15 ; at address 13
Define S 16 ; at address 14
Define M 100 ; at address 15
Define N 50 ; at address 16
; 13 : 15
; 15 : 100
; 14 : 16
; 16 : 50

; output
; at 16 -> 150
