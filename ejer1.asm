.model small
.stack 100h

.data
    X dw 1000          ; Monto inicial del comerciante en soles
    Y dw 2000          ; Monto inicial del empleado en soles
    comerciante dw 0  ; Monto actual del comerciante
    empleado dw 0    ; Monto actual del empleado
    meses dw 0        ; Contador de meses

.code
    mov ax, @data
    mov ds, ax

    mov ax, 0   ; Inicializar el registro AX a 0
    mov bx, X
    mov cx, Y
    mov comerciante, bx
    mov empleado, cx
    mov meses, 0

    ; Realizar el cálculo en un bucle hasta que el comerciante tenga más dinero que el empleado
    bucle:
        cmp bx, cx     ; Compara el monto del comerciante con el monto del empleado
        jae fin         ; Salta al final si el comerciante tiene más dinero o igual
        add bx, 70   ; Agrega 7% de interés al comerciante (7% de 1000)
        add cx, 40   ; Agrega 2% de interés al empleado (2% de 2000)
        add comerciante, 70
        add empleado, 40
        inc meses       ; Incrementa el contador de meses
        jmp bucle       ; Vuelve al inicio del bucle

    fin:
        mov ah, 9       ; Función para imprimir cadena
        lea dx, meses   ; Carga la dirección de la variable 'meses'
        int 21h         ; Imprime el valor de 'meses'

        mov ax, 4C00h  ; Función para salir del programa
        int 21h

    mov ax, 4C00h
    int 21h
