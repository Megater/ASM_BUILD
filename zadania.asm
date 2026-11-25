section .text
    org 100h
    xor bx, bx
    xor dx, dx

start:
    mov dx, todo
    call print_str ; using procedure of printing

    xor dx, dx
    jmp reading

reading: ; Reading keys in loop
    mov ah, 1
    int 21h

    cmp al, 8 ; Checking if sign is BACKSPACE
    je end

    cmp al, '$' 
    je wrong

    cmp al, 0 ; Checking if key is not function key
    je eat_key

    cmp al, 13 ; Checking if sign is ENTER
    je last_s

    mov [text + bx], al ; Changing place of writing sign
    inc bx

    cmp bx, 49 ; Checking if string is not too long
    je last_s

    jmp reading

eat_key: ; Function keys delete
    mov ah, 8
    int 21h
    jmp wrong

wrong:
    mov dx, wrongmes
    call print_str

    xor al, al
    xor bx, bx
    xor dx, dx
    jmp start

last_s:
    cmp bx, 0 ; Checking if string contains sth
    je wrong

    mov byte [text + bx], '$' ; Adding ending sign
    xor dx, dx

    jmp letter

letter:
    xor dx, dx

    mov dx, letterline ; Printing what to do
    call print_str
    xor dx, dx

    mov ah, 1
    int 21h

    cmp al, 8
    je end

    cmp al, 13 ; Checking if sign is not null
    je null_warning

    cmp al, 0
    je eat_key_letter

    mov bx, 0
    jmp find

null_warning:
    mov dx, warningmes
    call print_str
    jmp letter

eat_key_letter:
    mov ah, 8 ; Function keys delete
    int 21h
    jmp wrong_letter

wrong_letter:
    mov dx, wrongmes
    call print_str

    xor al, al
    xor bx, bx
    xor dx, dx
    jmp letter

find: ; Finding if string contains letter
    cmp byte [text + bx], '$'
    je lack_sign

    cmp byte [text + bx], al
    je prepare_f

    inc bx
    jmp find

lack_sign:
    mov dx, luck_of_sign
    jmp print

prepare_f: ; Adding mes what was done
    mov dx, changedline
    call print_str
    jmp overwrite

overwrite:
    mov dx, text ; Moving start point
    add dx, bx
    jmp print

print:
    call print_str

    xor dx, dx
    xor bx, bx
    jmp start

end:
    mov dx, endline ; Ending mes
    call print_str

    mov ax, 4C00h
    int 21h


print_str: ;Prining procedure
    push ax
    mov ah, 9
    int 21h
    pop ax
    ret

section .data
    text times 50 db 0
    todo db 13, 10, 13, 10, "Insert string to change: $"
    endline db 13, 10, 13, 10, "End of the program!$"
    letterline db 13, 10, "Insert sign to start the string: $"
    changedline db 13, 10, 13, 10, "Changed string: $"
    wrongmes db 13, 10, 13, 10, "Wrong input!$"
    luck_of_sign db 13, 10, 13, 10, "String does not contain this sign!$"
    warningmes db 13, 10, 13, 10, "You did not write any sign!$"