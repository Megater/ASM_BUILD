section .text
    org 100h
    
    
    
    mov bx, 0 

reading:

    mov ah, 1
    int 21h

    cmp al, 8
    je end

    cmp al, 13 ;comparing input with enter
    je last_s

    mov [text + bx], al ;overwritting to variable
    inc bx

    cmp bx, 49
    je last_s

    jmp reading

last_s:
    cmp bx, 0
    je end

    mov byte [text + bx], '$'

    mov ah, 1
    int 21h 

    mov byte [letter], al
    mov bx, 0 

    jmp finding


finding:
    cmp byte [text + bx], '$'
    je disagree

    cmp [text + bx], al
    je agree


    inc bx
    jmp finding

agree:
    mov ah, 2
    mov dl, 13
    int 21h
    mov dl, 10
    int 21h
    xor dl, dl


    mov dx, text        ; DX = adres początku napisu
    add dx, bx          ; przesuwamy adres startowy o BX bajtów w prawo

    jmp print
disagree:
    mov dx, null_mes
    jmp print

print:

    mov ah, 9
    int 21h


end:
    mov ax, 4C00h
    int 21h

section .data
letter db 0
text times 50 db 0 
null_mes db 13, 10, "Couldnt find variable to look for!$"