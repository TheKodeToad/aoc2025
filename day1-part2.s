BUFSIZ    equ 8192
SYS_READ  equ 0
SYS_WRITE equ 1
SYS_OPEN  equ 2
SYS_EXIT  equ 60
STDOUT    equ 1
STDERR    equ 2

section .bss
	file_buf resb BUFSIZ ; file buffer

section .data
	file               dd  0                  ; file descriptor
	file_buf_pos       dd  0
	dial               dd  50
	result             dd  0
	bad_prefix_msg     db  `bad prefix: '?'\n`
	bad_prefix_msg_len equ $ - bad_prefix_msg
	finished_msg       db  `the result is     0\n`
	finished_msg_len   equ $ - finished_msg

section .text
	filename           db  `input/day1.txt\0`
	open_error_msg     db  `failed to open file\n`
	open_error_msg_len equ $ - open_error_msg

global _start
_start:
	mov rax, SYS_OPEN
	mov rdi, filename ; filename
	mov rsi, 0        ; flags = read only
	mov rdx, 0        ; mode
	syscall

	mov [file], eax

	cmp eax, 0
	jge _iterate_file

	mov rax, SYS_WRITE
	mov rdi, STDERR
	mov rsi, open_error_msg
	mov rdx, open_error_msg_len
	syscall

	mov rax, SYS_EXIT
	mov rdi, 1       ; error_code
	syscall

_iterate_file:
	call get_char


	cmp al, 0 ; check for EOF
	je _finish

	cmp al, 'R'
	je _prefix_R
	cmp al, 'L'
	je _prefix_L

	mov [bad_prefix_msg + bad_prefix_msg_len - 3], al
	mov rax, SYS_WRITE
	mov rdi, STDERR
	mov rsi, bad_prefix_msg
	mov rdx, bad_prefix_msg_len
	syscall

_prefix_R:
	call read_number
	cmp rax, 0
	je _iterate_file

_loop_R:
	dec rax
	inc DWORD[dial]
	cmp DWORD[dial], 99

	jle _loop_R_tail
	mov DWORD[dial], 0
	inc DWORD[result]

_loop_R_tail:
	cmp rax, 0
	jne _loop_R
	jmp _iterate_file

_prefix_L:
	call read_number
	cmp rax, 0
	je _iterate_file

_loop_L:
	dec rax
	dec DWORD[dial]
	cmp DWORD[dial], 0

	je _loop_L_inc_result
	jg _loop_L_tail
	mov DWORD[dial], 99
	jmp _loop_L_tail

_loop_L_inc_result:
	inc DWORD[result]
_loop_L_tail:
	cmp rax, 0
	jne _loop_L
	jmp _iterate_file

	jmp _iterate_file

_finish:
	call print_result

	mov rax, SYS_EXIT
	mov edi, 0        ; error_code
	syscall

print_result:
	mov rax, 0
	mov eax, [result]
	mov r8, 10                   ; divisor
	mov r9, finished_msg_len - 2 ; cursor

_print_result_loop:
	cmp rax, 0
	je _print_result_syscall

	mov rdx, 0
	idiv r8
	add rdx, '0'

	mov [finished_msg + r9], dl
	dec r9

	jmp _print_result_loop


_print_result_syscall:
	mov rax, SYS_WRITE
	mov rdi, STDOUT           ; fd
	mov rsi, finished_msg     ; buf
	mov rdx, finished_msg_len ; count
	syscall

	ret


; gets char -> al
get_char:
	mov eax, [file_buf_pos]   ; something something SIB addressing needs a register
	cmp BYTE[file_buf + eax], 0 ; check for the null terminator we added
	jne _get_char_post_read

	mov DWORD[file_buf_pos], 0

	mov rax, SYS_READ
	mov rdi, [file]     ; fd
	mov rsi, file_buf   ; buf
	mov rdx, BUFSIZ - 1 ; count
	syscall

	mov BYTE[file_buf + eax], 0 ; add a null terminator

	cmp eax, 0
	je _get_char_ret

	mov eax, [file_buf_pos]
_get_char_post_read:
	mov al, [file_buf + eax]
	inc DWORD[file_buf_pos]
_get_char_ret:
	ret

; read number -> rax
read_number:
	mov rax, 0

_read_number_loop:

	push rax
	call get_char
	mov rbx, 0
	mov bl, al
	pop rax

	sub bl, '0'
	cmp bl, 0
	jl _read_number_ret
	cmp bl, 9
	jg _read_number_ret

	mov rcx, 10
	mul rcx

	add rax, rbx
	jmp _read_number_loop

_read_number_ret:

	ret
