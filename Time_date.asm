; This code is written by Wael & Faisal as part of EE 391 project (12-11-2023)

org 00h
CE   equ   P3.5
IO   equ   P3.4
SCLK equ   P3.6


MAIN:
CALL Setup
again:
call Init_lcd
call Get_Date
call Get_Time

sjmp again

Get_Date:
mov dptr,#Line_one
mov r5,#5
Writing_loop:
clr a
movc a,@a+dptr
call disp
mov a,#06h
call cmnd
inc dptr
djnz r5,Writing_loop
mov a,#'2'
call disp
mov a,#'0'
call disp
call Get_Years
mov a,#'/'
call disp
call Get_Months
mov a,#'/'
call disp
call Get_Days

ret

Get_Time:
mov a,#0c0h
call cmnd
mov dptr,#Line_two
mov r5,#5
Writing_loop_2:
clr a
movc a,@a+dptr
call disp
mov a,#06h
call cmnd
inc dptr
djnz r5,Writing_loop_2

call Get_Hours
mov a,#':'
call disp
call Get_Minutes
mov a,#':'
call disp
call Get_Seconds

ret


Get_Days:
mov a,#06h
call read
CALL Convert
ret

Get_Months:
mov a,#08h
call read
CALL Convert
ret

Get_Years:
mov a,#0Ch
call read
CALL Convert
ret


Get_Seconds:
mov a,#00h
call read
CALL Convert
ret

Get_Minutes:
mov a,#02h
call read
CALL Convert
ret

Get_Hours:
mov a,#04h
call read
CALL Convert
ret



Read:
clr CE
clr SCLK
SETB CE
orl a,#81h
;mov a,#81h
CALL WriteByte
CALL ReadByte
ret
Setup:

;Remove protection:
	mov r5,#00h
	mov a,#8Eh
call Single_WriteByte

;Set hours:
	mov r5,#00100011b ;2pm?
	mov a,#04h
call Single_WriteByte

;Set Minutes:
	mov r5,#59h
	mov a,#02h
call Single_WriteByte

;Set Seconds:
	mov r5,#00h
	mov a,#00h
call Single_WriteByte

;Set days:
	mov r5,#00000110b
	mov a,#06h
call Single_WriteByte

;Set months:
	mov r5,#00010010b
	mov a,#08h
call Single_WriteByte

;Set years:
	mov r5,#00100011b
	mov a,#0Ch
call Single_WriteByte

ret



Convert:
;Init_lcd
mov r7,a
anl a,#0f0h
swap a
add a,#30h
call disp
mov a,r7
anl a,#0fh
add a,#30h
call disp
call delay
ret


Single_WriteByte:
clr CE
clr SCLK
SETB CE
orl A,#80h
CALL WriteByte
mov a,r5
CALL WriteByte
clr CE
ret


WriteByte:
clr SCLK
nop 
nop
mov r2,#8
write_loop:
mov C,ACC.0
MOV IO,C
SETB SCLK
RR A
CLR SCLK
djnz r2,Write_loop
ret

ReadByte:
CLR IO
nop
nop
mov r2,#8
Read_loop:
mov C,IO
mov acc.0,C
SETB SCLK
RR A
CLR SCLK
djnz r2,Read_loop
ret

Init_lcd:
MOV A,#38H
ACALL CMND
MOV A,#0FH
ACALL CMND
MOV A,#06H
ACALL CMND
MOV A,#080H
ACALL CMND

ret

CMND: MOV P0,A
CLR P2.5
CLR P2.6
SETB P2.7
ACALL DELAY
CLR P2.7
RET

DISP: MOV P0,A
SETB P2.6
CLR P2.5
SETB P2.7
ACALL DELAY
CLR P2.7
RET

delay: mov r6,#255
bk:djnz r6,bk
ret



org 500h
Line_one: db "DATE "
Line_two: db "TIME "
end