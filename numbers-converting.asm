format PE Console 4.0

entry start
include 'win32a.inc'
include 'win_macros.inc'

section '.code' code readable executable

start:
	wyswietl	msg1
	mov	ecx,16		; loop counter initialization
	xor	ebx,ebx 	; clear registers before the next loop run
	xor	eax,eax 	; clear registers before the next loop run
   input:
	pob_znak

	cmp	al,51h		; ASCII Q key
	je	end_program
	cmp	al,71h		; ASCII q key
	je	end_program
	cmp	al,08h		; ASCII backspace key
	je	remove_char
	cmp	al,0dh		; ASCII enter key
	je	leave_loop
	jmp	char_validator

   correct_validation:
	wysw_znak	al
	inc	[counter]

	sub	al,'0'		; from hex to ASCII
	or	ebx,ebx 	; check ebx register is empty
	jz	first_bit	; if yes create first bit
	rcl	ebx,1		; shift bits to left
	cmp	al,1		; if al = 1 add 1 to eax if al == 0 go ahead
	je	add_one

   return_after_bits_operation:
	loop	input

   leave_loop:
	mov	[temp_ebx], bx

;SHOW_BIN
	add	     [row_position],2
	ustaw_kursor [row_position],0
	inc	     [row_position]
	wyswietl     result_bin_text

	mov	     cx,16
	mov	     bx,[temp_ebx]

   bin_ety1:
	push	cx
	rcl	bx,1
	jc	bin_ety2
	mov	dl,'0'
	jmp	bin_ety3

   bin_ety2:
	mov	dl,'1'

   bin_ety3:
	wysw_znak	dl

	pop	cx
	loop	bin_ety1

;SHOW HEX
	ustaw_kursor [row_position],0
	inc	     [row_position]
	wyswietl     result_hex_text

	;16-12 bits
	mov	ax,[temp_ebx]
	shr ah,4
	cmp ah,10
	jb hex_ety1
	add ah,55
	jmp hex_ety2

   hex_ety1:
	add ah,30h
   hex_ety2:
	wysw_znak ah

	;12-8 bits
	mov	ax,[temp_ebx]
	and ah,0Fh
	cmp ah,10
	jb hex_ety3
	add ah,55
	jmp hex_ety4
   hex_ety3:
	add ah,30h
   hex_ety4:
	wysw_znak ah

	;8-4 bits
	mov	ax,[temp_ebx]
	shr al,4
	cmp al,10
	jb hex_ety2_1
	add al,55
	jmp hex_ety2_2
   hex_ety2_1:
	add al,30h
   hex_ety2_2:
	wysw_znak al

	;4-0 bits
	mov	ax,[temp_ebx]
	and al,0Fh
	cmp al,10
	jb hex_ety2_3
	add al,55
	jmp hex_ety2_4
   hex_ety2_3:
	add al,30h
   hex_ety2_4:
	wysw_znak al


;SHOW OCT
	ustaw_kursor [row_position],0
	inc	     [row_position]
	wyswietl     result_oct_text

;SHOW DEC
	ustaw_kursor [row_position],0
	add	     [row_position],2
	wyswietl     result_dec_text

	mov	ax,[temp_ebx]
	mov	bx,10
	mov	cx,0

   dec_ety1:
	xor	dx,dx
	div	bx		; division ax by bx
	push	dx
	inc	cx
	test	ax, ax		; ax == 0 ?
	jnz	dec_ety1

   dec_ety2:
	pop	dx
	add	dl, '0' 	; from hex to ASCII
	wysw_znak   dl
	loop	dec_ety2

;RESTART PROGRAM
	ustaw_kursor [row_position],0
	mov	     [counter],15
	call	     start

char_validator:
	cmp	al,30h
	je	correct_validation
	cmp	al,31h
	je	correct_validation
   invalid_input:
	jmp	input

first_bit:
	mov	ebx,eax
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
	temp_ebx	dw	?

	msg1	db	'Wprowadz dane: ',0
	result_bin_text      db        '[bin] = ',0
	result_hex_text      db        '[hex] = ',0
	result_oct_text      db        '[oct] = ',0
	result_dec_text      db        '[dec] = ',0

