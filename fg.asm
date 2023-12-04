    .data
result_prompt:      .asciiz "Fibonacci series: "
newline:            .asciiz "\n"
space_str:          .asciiz " "

    .text
    .globl main

main:
    # Initialize variables
    li $t1, 0                       # $t1 = 0 (primer numero de Fibonacci)
    li $t2, 1                       # $t2 = 1 (segundo numero de Fibonacci)
    li $t3, 0                       # contador de bucle
    li $t0, 50                      # numero total de iteraciones

    # Imprimir la serie inicial
    li $v0, 4                       # syscall code for print_str
    la $a0, result_prompt
    syscall

print_fibonacci:
    # Imprimir el numero de Fibonacci actual
    move $a0, $t1
    li $v0, 1                       # syscall code for print_int
    syscall

    # Imprimir espacio
    li $v0, 4                       # syscall code for print_str
    la $a0, space_str               # load the address of the space string
    syscall

    # Calcular el siguiente numero de Fibonacci
    add $t4, $t1, $t2               # $t4 = $t1 + $t2
    move $t1, $t2                   # $t1 = $t2
    move $t2, $t4                   # $t2 = $t4

    # Incrementar el contador de bucle
    addi $t3, $t3, 1

    # Verificar si se alcanza el numero deseado de iteraciones
    bne $t3, $t0, print_fibonacci

    # Imprimir nueva linea
    li $v0, 11                      # syscall code for print_char
    li $a0, 10                       # ASCII code for newline character
    syscall

    # Salir del programa
    li $v0, 10                      # syscall code for exit
    syscall
