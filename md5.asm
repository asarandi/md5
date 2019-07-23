bits 64
default rel
section .text

%ifidn __OUTPUT_FORMAT__, macho64
 global _md5
 _md5:
%elifidn __OUTPUT_FORMAT__, elf64
 global md5
 md5:
%endif

            push    rbx
            push    r12
            push    r13
            push    r14

            mov     r9, rsi                     ; rdi = void *buf, rsi = size_t count
            xor     r14, r14

            mov     r10, 0x67452301             ; A
            mov     r11, 0xefcdab89             ; B
            mov     r12, 0x98badcfe             ; C
            mov     r13, 0x10325476             ; D

.new_block:
            cmp     rsi, 64
            jae     .full_block

            mov     rcx, rsi
            mov     rdx, rsi
            lea     rsi, [rel buf]
            xchg    rdi, rsi
            rep     movsb
            mov     al, 0x80
            stosb
            inc     rdx

            mov     rcx, 64
            mov     rsi, rcx
            sub     rcx, rdx
            cmp     rcx, 8
            jae     .size
            add     rcx, 64
            add     rsi, 64
.size:      sub     rcx, 8
            xor     al, al
            rep     stosb

            shl     r9, 3
            mov     dword [rdi], r9d
            shr     r9, 32
            mov     dword [rdi+4], r9d

            lea     rdi, [rel buf]
            inc     r14

.full_block:
            xor     rcx, rcx
            push    r10
            push    r11
            push    r12
            push    r13
.round_1:
            cmp     rcx, 16
            jae     .round_2
            mov     rbx, rcx                    ; g
            mov     rax, r13
            xor     rax, r12
            and     rax, r11
            xor     rax, r13
            jmp     .funnel
.round_2:
            cmp     rcx, 32
            jae     .round_3
            mov     rax, 5
            mul     rcx
            inc     rax
            mov     rbx, rax                    ; g        
            mov     rax, r12
            xor     rax, r11
            and     rax, r13
            xor     rax, r12
            jmp     .funnel
.round_3:
            cmp     rcx, 48
            jae     .round_4
            mov     rax, 3
            mul     rcx
            add     rax, 5
            mov     rbx, rax                    ; g
            mov     rax, r11
            xor     rax, r12
            xor     rax, r13
            jmp     .funnel
.round_4:
            mov     rax, 7
            mul     rcx
            mov     rbx, rax                    ; g
            mov     rax, r13
            not     rax
            or      rax, r11
            xor     rax, r12
.funnel:
            add     rax, r10                    ; F += A
            lea     rdx, [rel K_const]
            mov     edx, dword [rdx + rcx*4]      ; F += K[i]
            add     eax, edx
            and     rbx, 15
            mov     edx, dword [rdi + rbx*4]      ; F += M[g]
            add     eax, edx

            lea     rdx, [rel s_const]
            mov     rbx, rcx
            shr     rbx, 2
            and     rbx, 12
            add     rdx, rbx
            mov     rbx, rcx
            and     rcx, 3
            mov     cl, byte [rdx + rcx]
            rol     eax, cl
            mov     rcx, rbx

            mov     r10, r13                    ; A = D
            mov     r13, r12                    ; D = C
            mov     r12, r11                    ; C = B
            add     r11, rax                    ; B += leftrotate(F, s[i])
            inc     rcx
            test    rcx, 64
            jz      .round_1

            mov     rax, r13
            pop     r13
            add     r13, rax

            mov     rax, r12
            pop     r12
            add     r12, rax

            mov     rax, r11
            pop     r11
            add     r11, rax

            mov     rax, r10
            pop     r10
            add     r10, rax

            add     rdi, 64
            sub     rsi, 64
            test    rsi, rsi
            jnz     .new_block
.done:
            test    r14, r14
            jz      .new_block

            lea     rax, [rel result]

            bswap   r10d
            mov     dword [rax], r10d
            bswap   r11d
            mov     dword [rax + 4], r11d
            bswap   r12d
            mov     dword [rax + 8], r12d
            bswap   r13d
            mov     dword [rax + 12], r13d

            pop     r14
            pop     r13
            pop     r12
            pop     rbx

            ret


section .data

s_const     db 7, 12, 17, 22
            db 5,  9, 14, 20
            db 4, 11, 16, 23
            db 6, 10, 15, 21

K_const     dd 0xd76aa478, 0xe8c7b756, 0x242070db, 0xc1bdceee
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

result      times 4 dd 0

buf         times 128 db 0
