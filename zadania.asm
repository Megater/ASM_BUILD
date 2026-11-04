section .text
    org 100h


start:
    mov bx, 0
    mov cx, 0
petla:
    mov dl, [constant + bx]
    inc bx
    cmp dl, '$'
    je wynik
    cmp dl, ' '
    je dodawanie

    jmp petla

dodawanie:
    inc cx
    jmp petla

wynik:
    mov dx, msg
    mov ah, 9
    int 21h

    mov dl, cl
    add dl, '0'

    mov ah, 2
    int 21h

mov ax, 4C00h
int 21h

section .data
    constant db "A l a m a ko t a i psa$"
    msg db "Number of spaces: $"