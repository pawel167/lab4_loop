; multi-segment executable file template.

data segment
    ; add your data here!
    pkey db "press any key...$"  
    S dw ? ; Переменная для хранен
    N dw ? ; Переменная для хранен
    perenos db 13,10,"$" ; Символыонца
    vvod_N db 13,10,"Vvedite N=$" 
    vivod_S db "S=$" ; Сообщение д
ends

stack segment
    dw   128  dup(0)
ends

code segment
start:
; set segment registers:
    mov ax, data
    mov ds, ax
    mov es, ax


    ; Input N
    xor ax, ax
    mov dx, offset vvod_N
    mov ah, 9
    int 21h
    mov ah, 1
    int 21h
    sub al, 30h
    cbw
    mov N, ax

    ; Calculate product of series
mov ax, 3   ; Start with 3
mov bx, 5   ; Next term is 5
mov cx, 1   ; Loop counter
mov dx, 1   ; Product

@repeat:
    cmp cx, N
    je done
    
    ; Multiply current term
    mul bx
    mov dx, ax
    
    ; Compute next term
    cmp cx, 2
    je special1
    cmp cx, 3
    je special2
    add bx, 3
    inc cx
    jmp @repeat

special1:
    ; After 120, add 4
    add bx, 4
    inc cx
    jmp @repeat

special2:
    ; After 1440, add 5
    add bx, 5
    inc cx
    jmp @repeat

done:
    mov S, dx   ; Store final product in S

    ; Display result
    mov dx, offset perenos
    mov ah, 9
    int 21h
    mov dx, offset vivod_S
    mov ah, 9
    int 21h
    mov ax, S
    call print_num

    mov dx, offset perenos
    mov ah, 9
    int 21h
    mov ah, 1
    int 21h

    mov ax, 4c00h
    int 21h

print_num:
    push -1
    mov cx, 10
L1:
    mov dx, 0
    div cx
    push dx
    cmp ax, 0
    jne L1
L2:
    pop dx
    cmp dx, -1
    je sled8
    add dl, 30h
    mov ah, 2
    int 21h
    jmp L2
sled8:
    ret
            
    lea dx, pkey
    mov ah, 9
    int 21h        ; output string at ds:dx
    
    ; wait for any key....    
    mov ah, 1
    int 21h
    
    mov ax, 4c00h ; exit to operating system.
    int 21h    
ends

end start ; set entry point and stop the assembler.
