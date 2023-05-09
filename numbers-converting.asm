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

	cmp	al,51h		; ASCII Q key
	je	end_program
	cmp	al,71h
	je	end_program	; ASCII q key

	cmp	al,08h		; ASCII backspace key
	je	clear_input

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


end_program:
	invoke ExitProcess

clear_input:
	wyswietl       test_msg
	jmp    input

section '.data' data readable writeable

	row_position	dw	0,0

	test_msg	db	'Dzialam!',0
	msg1	db	'Wprowadz dane: ',0
	result_bin	db	  '[bin] = Wynik w postaci binarnej',0
	result_oct	db	  '[oct] = Wynik w postaci oktalnej',0
	result_dec	db	  '[dec] = Wynik w postaci decymalnej',0
	result_hex	db	  '[hex] = Wynik w postaci hexadecymalnej',0