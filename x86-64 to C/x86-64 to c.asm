%include "io64.inc"

section .data
    fmt db "Dot Product: %f", 10, 0 

section .text
global main
global dot_product_asm

main:
    ; Initialize stack frame
    push rbp
    mov rbp, rsp
    
    ; Call the dot_product_asm function
    ; Pass parameters: rdi = n, rsi = A, rdx = B, rcx = &sdot
    call dot_product_asm
    
    ; Print the result
    mov rdi, fmt
    mov rax, 0
    ; Exit program
    mov rax, 0
    leave
    ret

dot_product_asm:
    mov r8, 0        ; Initialize sdot to 0
    xor r9d, r9d     ; Loop counter

dot_product_loop:
    cmp r9d, edi     ; Compare loop counter with n
    je dot_product_end  ; Jump to the end if equal

    movss xmm0, [rsi + r9*4]  ; Load A[i] into xmm0
    movss xmm1, [rdx + r9*4]  ; Load B[i] into xmm1
    mulss xmm0, xmm1           ; Multiply A[i] * B[i]
    addss xmm0, [rsp]          ; Add the result to sdot (stored on the stack)
    movss [rsp], xmm0          ; Store the result back to sdot

    inc r9d          ; Increment loop counter
    jmp dot_product_loop  ; Jump back to the loop

dot_product_end:
    movss xmm0, [rsp]  ; Load sdot from the stack to xmm0
    movss [rcx], xmm0  ; Store the final result in sdot
    ret