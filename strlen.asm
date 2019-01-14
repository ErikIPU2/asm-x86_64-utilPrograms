section .text
    strlen: ; = strlen( (rdi)string )

        xor rax, rax ; zera o valor de rax, rax = retorno

        .loop:
            cmp byte[rdi+rax], 0 ; compara se caractere na posição rax é zero
                                 ; = rdi.charAt(rax) == 0; (0 == caractere nulo de saida de string)
            jz .end ;pula para o final do loop se for

            inc rax ; incrementa 1, = proxima posição
            jmp .loop ; e pula para o começo do loop
        .end:

        ret
