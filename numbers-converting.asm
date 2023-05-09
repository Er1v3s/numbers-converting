format PE Console 4.0

entry start
include 'win32a.inc'
include 'win_macros.inc'

section '.code' code readable executable

start:

program:
	wyswietl	msg1
	mov	ecx,16
input:
	pob_znak_ECHO
	loop	input

	add	     [row_position],2
	ustaw_kursor [row_position],0
	inc	     [row_position]
	wyswietl     result_bin

	ustaw_kursor [row_position],0
	inc	     [row_position]
	wyswietl     result_oct

	ustaw_kursor [row_position],0
	inc	     [row_position]
	wyswietl     result_dec

	ustaw_kursor [row_position],0
	add	     [row_position],2
	wyswietl     result_hex

	ustaw_kursor [row_position],0
	call	     program


section '.data' data readable writeable

	row_position	dw	0,0
	msg1	db	'Wprowadz dane: ',0
	result_bin	db	  '[bin] = Wynik w postaci binarnej',0
	result_oct	db	  '[oct] = Wynik w postaci oktalnej',0
	result_dec	db	  '[dec] = Wynik w postaci decymalnej',0
	result_hex	db	  '[hex] = Wynik w postaci hexadecymalnej',0