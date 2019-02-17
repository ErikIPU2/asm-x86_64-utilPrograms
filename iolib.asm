global _start

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

    mov rax, rdi                ;move o valor em rdi para rax
    mov rdi, rsp                ;salva o ponteiro da pilha em rdi
    sub rsp, 2                  ;aloca o bytes na pilha, char + fim de string
    dec rdi                     ;move o ponteiro para a proxima posição
    mov byte[rdi], 0            ;coloca o valor de fim de string na pilha
    dec rdi                     ;vai para a proxima posição
    mov byte[rdi], al           ;coloca o caractere na pilha
    call print_string           ;imprime a string no endereço de rdi
    add rsp, 2                  ;restaura o ponteiro da pilha
    ret                         

print_newline:

    mov rdi, 10                 ;10 = quebra de lina
    call print_char             ;chama print_char

    ret

print_uint:                     ;print_uint((rdi) uint64_t)

    mov rax, rdi                ;move o numero de rdi para rax
    mov rdi, rsp                ;rdi ponteiro para o buffer


    sub rsp, 21                 ;aloca 21 bytes na pilha, 21 = tamanho maximo de um numero de 64 bits + 1
    mov r8, 10                  ;define a base como 10

    dec rdi
    mov byte[rdi], 0            ;coloca o valor 0 no topo da pilha, ele vai servir como final de String

    .loop:                      ;loop serve para divisão
        dec rdi                 ;vai para a proxima posição
        xor rdx, rdx            ;zera rdx, rdx = resto da divisão
        div r8                  ;divide rax pela base
        add dl, '0'             ;converte o numero em dl(8-rdx) em um numero ascii
        mov [rdi], dl           ;move o numero em dl para a pilha

        test rax, rax           ;verifica se não existe mais nenhum numero para ser dividido
        jnz .loop               ;repete o numero se tiver

    call print_string           ;imprime a string em rdi
    add rsp, 21                 ;reseta o valor da pilha
    ret


print_int:                      ;print_int((rdi) int64_t)
    cmp rdi, 0                  ;compara o valor de rdi com 0

    jge .print_uint             ;verifica se ele é maior ou igual a zero, se for imprime o numero
                                ;caso não seja, imprime o sinal de menos e converte o valor para positivo
    push rdi                    ;salva o valor de rdi
    mov rdi, '-'                ;move o simbolo de menos para rdi
    call print_char             ;imprime o caractere em rdi
    pop rdi                     ;restaura o valor de rid
    neg rdi                     ;passa rdi para positivo

    .print_uint:            
        call print_uint         ;imprime o valor em rdi

    ret

_start:

    mov rdi, 0
    call exit


