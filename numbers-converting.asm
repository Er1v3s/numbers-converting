format PE Console 4.0

entry start
include 'win32a.inc'
include 'win_macros.inc'

section '.code' code readable executable

start:

program:
	wyswietl	msg1
	mov	ecx,5	       ; loop counter initialization
	xor	ebx, ebx       ; clear registers before the next loop run
	xor	eax, eax       ; clear registers before the next loop run
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

	sub	al, '0' 	; from hex to ASCII
	or	ebx,ebx 	; check ebx is equal 0
	jz	first_bit	; if yes create first bit
	rcl	ebx,1		; shift bits to left
	cmp	al,1		; if al = 1 add 1 to eax if al == 0 go ahead
	je	add_one

   return_after_bits_operation:

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
   invalid_input:
	jmp	input

first_bit:
	mov	ebx, eax
	jmp	return_after_bits_operation

add_one:
	add	ebx,1
	jmp	return_after_bits_operation

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
	temp_ebx	dd	?

	msg1	db	'Wprowadz dane: ',0
	result_bin	db	  '[bin] = Wynik w postaci binarnej',0
	result_oct	db	  '[oct] = Wynik w postaci oktalnej',0
	result_dec	db	  '[dec] = Wynik w postaci decymalnej',0
	result_hex	db	  '[hex] = Wynik w postaci hexadecymalnej',0

