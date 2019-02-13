global _start
section .data

    strin1: db "tesfsdfsdfse", 10

section .bss

    char_buf: resb 1           ;buffer para print_char
    int_buf: resb 1

section .text

exit:                           ; exit((rdi)exit_code)

    mov rax, 60                 ; 60 = sys_exit
    syscall

    ret

string_length:                  ;string_length((rdi) *string)
    xor rax, rax                ; zera o valor de rax, rax = retorno

    .loop:
        cmp byte[rdi+rax], 0    ; compara se caractere na posição rax é zero
                                ; = rdi.charAt(rax) == 0; (0 == caractere nulo de saida de string)
        jz .end                 ;pula para o final do loop se for

        inc rax                 ; incrementa 1, = proxima posição
        jmp .loop               ; e pula para o começo do loop
    .end:

    ret

print_string:                   ;print_string((rdi) *string)

    call string_length          ;pega o tamanho da string
    mov rdx, rax                ;coloca o tamanho da string em rdx
    mov rsi, rdi                ;coloca o ponteiro da string em rsi
    mov rdi, 1                  ;rdi = FD, 1 = stdout
    mov rax, 1                  ;rax = syscall, 1 = sys_write
    syscall

    ret

print_char:                     ;print_char((rdi)char[1])

    mov [char_buf], rdi         ;move o caractere para o buffer na memoria
    mov rdi, char_buf           ;coloca o endereço do buffer em rdi
    call print_string           ;chama a função print_string

    ret

print_newline:

    mov rdi, 10                 ;10 = quebra de lina
    call print_char             ;chama print_char

    ret

print_uint:
    xor rax, rax
    .loop:

    .end:


    ret
_start: