.model small
.stack 100h

.data
    entrada_hora db 0      ; Hora de entrada (formato hh:mm:ss)
    entrada_min db 0
    entrada_seg db 0
    salida_hora db 0       ; Hora de salida (formato hh:mm:ss)
    salida_min db 0
    salida_seg db 0
    entradatotal dw 0
    salidatotal dw 0
    tiempoestacionado dw 0
    importe dw 0           ; Importe a pagar en centavos
    tarifa_inicial dw 33 ; Tarifa por segundo o fracción antes de las 12:00
    ;tarifa_inicial dd 333333  ; Declarar una variable DQword
    tarifa_posterior dw 27 ; Tarifa por segundo o después de las 12:00
    ;tarifa_posterior dd  277777
    aux dw 0

.code
    mov ax, @data
    mov ds, ax

    ; Ingresa la hora de entrada (por ejemplo, 10:30:15)
    ;mov ah, 10
    ;mov al, 30
    ;mov bl, 15
    mov ah, 0
    mov al, 0
    mov bl, 0
    mov entrada_hora, ah
    mov entrada_min, al
    mov entrada_seg, bl

    ; Ingresa la hora de salida (por ejemplo, 13:45:30)
    ;mov ah, 13
    ;mov al, 45
    ;mov bl, 30
    mov ah, 5
    mov al, 15
    mov bl, 0
    mov salida_hora, ah
    mov salida_min, al
    mov salida_seg, bl
                       
    xor ax, ax
    xor bx, bx
    xor cx, cx
    ; Calcula el tiempo de estacionamiento en segundos
    mov al, entrada_hora
    mov bl, 60
    mul bx
    add al, entrada_min
    mov bl, 60
    mul bx
    add al, entrada_seg
    mov cx, ax
    mov entradatotal, ax
    
    xor ax, ax
    
    mov al, salida_hora
    mov bl, 60
    mul bx
    add al, salida_min
    mov bl, 60
    mul bx
    add al, salida_seg
    mov salidatotal, ax
    sub ax, cx  ; Duración en segundos
    mov tiempoestacionado, ax
           
           
    ;definir el tiempo correspondiente por tarifa
    xor ax, ax
    xor cx, cx
    mov cx, salidatotal
    mov ax, 43200
    cmp ax, cx
    jb tarifa_posterior2
    ja tarifa_inicial2
    
    
    tarifa_inicial1: 
        xor bx, bx
        sub ax, cx
        mov bx, 3
        mul bx
        xor cx, cx
        xor bx, bx
        mov bx, 10
        mov cx, ax
        div bx
        add cx, ax
        mov importe, cx
        jmp tarifa_posterior1
        
    tarifa_posterior2:
        mov cx, entradatotal    ; si hora entrada y hora salida son mayor a 12:00:00, hallar el importe
        mov ax, 43200
        cmp ax, cx
        ja tarifa_inicial1      ; caso contrario hallar importe inicial y luego hallar importe final
        xor bx, bx
        mov ax, tiempoestacionado
        mov bx, 2
        mul bx
        xor cx, cx
        xor bx, bx
        mov bx, 10
        mov aux, ax
        mov ax, salidatotal
        mov cx, 43200
        sub ax, cx
        div bx
        mov bx, 7 
        mul bx
        mov cx, aux
        add cx, ax
        mov importe, cx
        jmp fin
        
    tarifa_inicial2:
        xor bx, bx
        mov ax, tiempoestacionado
        mov bx, 3
        mul bx
        xor cx, cx
        xor bx, bx
        mov bx, 10
        mov cx, ax
        div bx
        add cx, ax
        mov importe, cx
        jmp fin
        
    tarifa_posterior1:
        xor ax, ax 
        xor bx, bx 
        xor cx, cx 
        mov cx, 43200
        mov ax, salidatotal
        sub ax, cx
        mov bx, 2
        mul bx
        xor cx, cx
        xor bx, bx
        mov bx, 10
        mov aux, ax
        mov ax, salidatotal
        mov cx, 43200
        sub ax, cx
        div bx
        mov bx, 7 
        mul bx
        mov cx, aux
        add cx, ax
    
    tarifatotal:
        xor ax, ax
        mov ax, importe
        add cx, ax
        mov importe, cx
    
    
   ;completa el programa

    fin:
    mov ah, 4Ch
    int 21h
