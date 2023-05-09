format PE Console 4.0

entry start
include 'win32a.inc'
include 'win_macros.inc'

section '.code' code readable executable

start:

program:
	wyswietl	msg1
	mov	ecx,16		; loop counter initialization
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

SHOW_BIN:
	add	     [row_position],2
	ustaw_kursor [row_position],0
	inc	     [row_position]
	wyswietl     result_bin_text
	mov	     [result_bin], bx
	mov cx, 16
	mov bx, [result_bin]

   ety1:
	push	cx
	rcl	bx, 1
	jc	ety2
	mov	dl, '0'
	jmp	ety3

   ety2:
	mov	dl, '1'

   ety3:
	wysw_znak	dl

	pop	cx
	loop	ety1

SHOW_HEX:
	ustaw_kursor [row_position],0
	inc	     [row_position]
	wyswietl     result_hex_text

SHOW_OCT:
	ustaw_kursor [row_position],0
	inc	     [row_position]
	wyswietl     result_oct_text
SHOW_DEC:
	ustaw_kursor [row_position],0
	add	     [row_position],2
	wyswietl     result_dec_text

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
;	 temp_ebx	 dd	 ?

	msg1	db	'Wprowadz dane: ',0
	result_bin_text      db        '[bin] = ',0
	result_bin	     dw        ?,0
	result_hex_text      db        '[hex] = ',0
	result_hex	     dd        "d",0
	result_oct_text      db        '[oct] = ',0
	result_oct	     db        ?,0
	result_dec_text      db        '[dec] = ',0
	result_dec	     db        ?,0

