global _start

section .text

_start:
	mov rax, 1; SYS_write syscall number
	mov rdi, X; FIX THIS
	mov rsi, msg; Set the output buffer to our message
	mov rdx, XYZ; FIX THIS
	syscall;

	mov rax, 60; SYS_exit syscall number
	mov rdi, 0; EXIT_SUCCESS exit status
	syscall;

section .data
	msg db "Hello, World!", 0xa ; our message string, plus a 0xa (newline character)
	msglen equ $ - msg
