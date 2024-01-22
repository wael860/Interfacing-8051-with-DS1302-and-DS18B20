; This code is written by Wael & Faisal as part of EE 391 project (12-11-2023)

port 	equ P3.7
input 	equ P0


org 00h
main:
call Read_Temp
call Seven_Seg
sjmp main

Seven_Seg:
mov a,r2
mov r6,a
anl a,#11110000b
swap a
mov r2,a
mov a,r3
anl a,#0fh
swap a
orl a,r2
call Conv_hex_to_decimal
mov dptr,#Look_up
mov r0,#01h
mov r5,#3
loop:
movc a,@a+dptr
mov @r0,a
inc r0
mov a,@r0
djnz r5,loop
; The last four digits of the 7-segment display -------------------
mov a,r6
anl a,#00001111b
push 1
push 2
push 6
push 7
call fraction
BACK_Again:mov a,r1
call Conv_hex_to_decimal_OUT_2
mov 03ah,r6
mov 03bh,r7
mov a,r2
call Conv_hex_to_decimal_OUT_2
mov 03ch,r6
mov 03dh,r7
mov r5,#4
mov dptr,#Look_up
mov r1,#03ah
loop_4: 
mov a, @r1 
movc a,@a+dptr
mov @r1,a
inc r1
djnz r5,loop_4
pop 7
pop 6
pop 2
pop 1

; Translate the numbers from decimal to values in look_up table of 7-seg. display -------------------
mov r5,#4
push 0
mov r0,#0h
loop_:
movc a,@a+dptr
mov @r0,a
inc r0
mov a,@r0
djnz r5,loop_
pop 0
setb p2.4
call set_seg_1
call set_seg_2
call set_seg_3
clr p2.4
call set_seg_5
call set_seg_6
call set_seg_7
call set_seg_8

ret

; Subroutine for the first digit of 7-sig. display -------------------
Set_Seg_1:
setb p2.3
clr p2.2
mov p0,r1
mov r5,#255
call delay
mov r5,#255
call delay
ret

; Subroutine for the second digit of 7-sig. display -------------------

Set_Seg_2:
clr p2.3
setb p2.2
mov p0,r2
mov r5,#255
call delay
mov r5,#255
call delay
ret


; Subroutine for the third digit of 7-sig. display -------------------
Set_Seg_3:
clr p2.3
clr p2.2
mov a,r3
orl a,#80h
mov r3,a
mov p0,r3
mov r5,#255
call delay
mov r5,#255
call delay
ret

; Subroutine for the fourth (fraction) digit of 7-sig. display -------------------
Set_Seg_5:
setb p2.3
setb p2.2
mov p0,03ah
mov r5,#255
call delay
mov r5,#255
call delay
ret

; Subroutine for the fifth (fraction) digit of 7-sig. display -------------------
Set_Seg_6:
setb p2.3
clr p2.2
mov p0,03bh
mov r5,#255
call delay
mov r5,#255
call delay
ret

; Subroutine for the sixth (fraction) digit of 7-sig. display -------------------
Set_Seg_7:
clr p2.3
setb p2.2
mov p0,03ch
mov r5,#255
call delay
mov r5,#255
call delay
ret

; Subroutine for the seventh (fraction) digit of 7-sig. display -------------------
Set_Seg_8:
clr p2.3
clr p2.2
mov p0,03dh
mov r5,#255
call delay
ret

; Subroutine to translate hex to decimal and output 2 decimal numbers at a time.. (this subroutine for the four digits after the decimal point) -------------------
Conv_hex_to_decimal_OUT_2:
mov b,#10
div ab   ;divide 10
mov r6,a
mov r7,b
;output would be like so: r1r2, where r1 is MSB
ret

; Subroutine to translate hex to decimal and output 3 decimal numbers at a time.. (this subroutine for the first three digits) -------------------
Conv_hex_to_decimal:
mov b,#10
div ab   ;divide 10
mov r3,b
mov b,#10 ;divide 10
div ab
mov r1,a
mov r2,b
;output would be like so: r1r2r3, where r1 is MSB
ret

Read_Temp:
	call Init_DS18B20
	mov a,#0cch ;skip ROM
	call WriteByte
	mov a,#44h  ; Temp. conversion
	call WriteByte
	; We need to reset and do presence again
	call Init_DS18B20
	mov a,#0cch ;skip ROM
	call WriteByte
	mov a,#0beh ;read scratchpad
	call WriteByte
	;Now, time to read temperature.. where r2 and r3 are going to be used to save the readings..
	call ReadByte
	mov r2,a
	call ReadByte
	mov r3,a
	
ret
	
	
Init_DS18B20:

SETB port ;reset
mov r5,#50
call delay

clr port 
mov r5,#200
call delay

SETB port
mov r5,#100
call delay

check:jnb port, check
mov r5,#40
call delay
ret



WriteByte:
mov r0,#8
Writing_loop:
	clr port
	mov c,acc.0
	mov port,c
	mov r5,#60
	rr a
	call delay
	setb port
	djnz r0,Writing_loop
mov r5,#50
call delay
ret

ReadByte:
mov r0,#8
Reading_loop:
	clr port
	clr c
	mov acc.0,c
	rr a
	setb port
	jnb port,_skip
	orl a,#80h ;negative
	_skip:
		mov r5,#50
		call delay
	djnz r0,Reading_loop
ret
	


fraction:
cjne a,#01h,jump
sjmp pos1 ;0625
ret
jump:cjne a,#02h,jump1
sjmp pos2 ;1250
ret
jump1:cjne a,#03h,jump2
sjmp pos3 ;1875
ret
jump2:cjne a,#04h,jump3
sjmp pos4 ;2500
ret
jump3:cjne a,#05h,jump4
sjmp pos5 ;3125
ret
jump4:cjne a,#06h,jump5
sjmp pos6 ;3750
ret
jump5:cjne a,#07h,jump6
sjmp pos7 ;4375
ret
jump6:cjne a,#08h,jump7
sjmp pos8 ;5000
ret
jump7:cjne a,#09h,jump8
sjmp pos9 ;5625
ret
jump8:cjne a,#0ah,jump9
sjmp pos10 ;6250
ret
jump9:cjne a,#0bh,jump10
sjmp pos11 ;6875
ret
jump10:cjne a,#0ch,jump11
sjmp pos12 ;7500
ret
jump11:cjne a,#0dh,jump12
sjmp pos13 ;8125
ret
jump12:cjne a,#0eh,jump13
sjmp pos14 ;8750
ret
jump13:cjne a,#0fh,jump14
sjmp pos15 ;9375
ret
jump14:sjmp pos16
ret

pos1:
mov r1,#06
mov r2,#25
ret
pos2:
mov r1,#12
mov r2,#50
ret
pos3:
mov r1,#18
mov r2,#75
ret
pos4:
mov r1,#25
mov r2,#00
ret
pos5:
mov r1,#31
mov r2,#25
ret
pos6:
mov r1,#37
mov r2,#50
ret
pos7:
mov r1,#43
mov r2,#75
ret
pos8:
mov r1,#50
mov r2,#00
ret
pos9:
mov r1,#56
mov r2,#25
ret
pos10:
mov r1,#62
mov r2,#50
ret
pos11:
mov r1,#68
mov r2,#75
ret
pos12:
mov r1,#75
mov r2,#00
ret
pos13:
mov r1,#81
mov r2,#25
ret
pos14:
mov r1,#87
mov r2,#05
ret
pos15:
mov r1,#93
mov r2,#75
ret
pos16:
mov r1,#00
mov r2,#00
ret

;Delay routine

delay:
	djnz r5,delay
	ret
	
;Lookp table for 7-segment display
org 500h
Look_up: db 3Fh,06h,5Bh,4Fh,66h,6Dh,7Dh,07h,7Fh,6Fh
	
end