format PE Console 4.0

entry start
include 'win32a.inc'
include 'win_macros.inc'

section '.code' code readable executable

start:

program:
	wyswietl	msg1
	mov	ecx,5	       ; inicjalizacja licznika pêtli
input:
	pob_znak

	cmp	al,51h		; ASCII Q key
	je	end_program
	cmp	al,71h		; ASCII q key
	je	end_program
	cmp	al,08h		; ASCII backspace key
	je	remove_char
	jmp	char_validator

   correct_validation:

	wysw_znak	al
	inc	[counter]
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
	mov	     [counter], 15
	call	     program

char_validator:
	cmp	al, 30h
	je	correct_validation
	cmp	al, 31h
	je	correct_validation
	cmp	al, 32h
	je	correct_validation
	cmp	al, 33h
	je	correct_validation
	cmp	al, 34h
	je	correct_validation
	cmp	al, 35h
	je	correct_validation
	cmp	al, 36h
	je	correct_validation
	cmp	al, 37h
	je	correct_validation
	cmp	al, 38h
	je	correct_validation
	cmp	al, 39h
	je	correct_validation
   invalid_input:
	jmp	input

end_program:
	invoke ExitProcess

remove_char:
	cmp	[counter],15	  ; 15 is minimal coutner value
	jbe	continue
	dec	[counter]
	inc	ecx		  ;
   continue:
	ustaw_kursor [row_position],[counter]
	wysw_znak	20h
	ustaw_kursor [row_position],[counter]
	jmp    input

section '.data' data readable writeable

	row_position	dw	0,0
	counter 	dw	15,0	; msg1 length

	msg1	db	'Wprowadz dane: ',0
	result_bin	db	  '[bin] = Wynik w postaci binarnej',0
	result_oct	db	  '[oct] = Wynik w postaci oktalnej',0
	result_dec	db	  '[dec] = Wynik w postaci decymalnej',0
	result_hex	db	  '[hex] = Wynik w postaci hexadecymalnej',0

