bits 64
default rel
global _start
section .text

_start:
    lea     rdi, [rel hello]
    mov     rsi, 11
    call    _md5
    mov     rax, 60
    syscall

_md5:                               ; rdi = data
                                    ; rsi = size
    push    rsi

    mov     r10, 0x67452301         ; A
    mov     r11, 0xefcdab89         ; B
    mov     r12, 0x98badcfe         ; C
    mov     r13, 0x10325476         ; D

.new_block:
    xor     rcx, rcx
.loop:
    cmp     rcx, 16
    jae     .round_2
    mov     rbx, rcx    ; g
    mov     rax, r11
    mov     rdx, rax
    not     rax
    and     rax, r13
    and     rdx, r12
    or      rax, rdx
    jmp     .funnel
.round_2:
    cmp     rcx, 32
    jae     .round_3
    mov     rax, 5
    mul     rcx
    inc     rax
    mov     rbx, rax    ; g
    mov     rax, r13
    mov     rdx, rax
    not     rax
    and     rax, r12
    and     rdx, r11
    or      rax, rdx
    jmp     .funnel
.round_3:
    cmp     rcx, 48
    jae     .round_4
    mov     rax, 3
    mul     rcx
    add     rax, 5
    mov     rbx, rax    ; g
    mov     rax, r11
    xor     rax, r12
    xor     rax, r13
    jmp     .funnel
.round_4:
    mov     rax, 7
    mul     rcx
    mov     rbx, rax    ; g
    mov     rax, r13
    not     rax
    or      rax, r11
    xor     rax, r12    
.funnel:
    add     rax, r10
    lea     rdx, [rel K]
    add     eax, dword [rdx + rcx]
    and     rbx, 15
    add     eax, dword [rdi + rbx]

    mov     r10, r13
    mov     r13, r12
    mov     r12, r11
    lea     rdx, [rel s]
    mov     rbx, rcx
    shr     rbx, 2
    and     rbx, 12
    add     rdx, rbx
    mov     rbx, rcx
    and     rbx, 3
    add     rdx, rbx
    mov     bl, byte [rdx]
    xchg    rbx, rcx
    rol     eax, cl
    xchg    rbx, rcx
    add     r11, rax
    inc     rcx
    test    rcx, 64
    jz      .loop
    add     rdi, 64
    sub     rsi, 64
    cmp     rsi, 0
    jle     .done

    jmp     .new_block
.done:
    pop     rsi
    ret


section .data


hello:
db "hello world"

s:
db 7, 12, 17, 22
db 5,  9, 14, 20
db 4, 11, 16, 23
db 6, 10, 15, 21

K:
dd 0xd76aa478, 0xe8c7b756, 0x242070db, 0xc1bdceee
dd 0xf57c0faf, 0x4787c62a, 0xa8304613, 0xfd469501
dd 0x698098d8, 0x8b44f7af, 0xffff5bb1, 0x895cd7be
dd 0x6b901122, 0xfd987193, 0xa679438e, 0x49b40821
dd 0xf61e2562, 0xc040b340, 0x265e5a51, 0xe9b6c7aa
dd 0xd62f105d, 0x02441453, 0xd8a1e681, 0xe7d3fbc8
dd 0x21e1cde6, 0xc33707d6, 0xf4d50d87, 0x455a14ed
dd 0xa9e3e905, 0xfcefa3f8, 0x676f02d9, 0x8d2a4c8a
dd 0xfffa3942, 0x8771f681, 0x6d9d6122, 0xfde5380c
dd 0xa4beea44, 0x4bdecfa9, 0xf6bb4b60, 0xbebfbc70
dd 0x289b7ec6, 0xeaa127fa, 0xd4ef3085, 0x04881d05
dd 0xd9d4d039, 0xe6db99e5, 0x1fa27cf8, 0xc4ac5665
dd 0xf4292244, 0x432aff97, 0xab9423a7, 0xfc93a039
dd 0x655b59c3, 0x8f0ccc92, 0xffeff47d, 0x85845dd1
dd 0x6fa87e4f, 0xfe2ce6e0, 0xa3014314, 0x4e0811a1
dd 0xf7537e82, 0xbd3af235, 0x2ad7d2bb, 0xeb86d391
