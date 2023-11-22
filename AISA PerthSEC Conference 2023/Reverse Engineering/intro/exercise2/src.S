global _start

section .text

_start:
	mov rbx, 0;   set the counter to 0 to start
	.loop:;       mark this position with `loop` so we can jump to it
	;   increment the number we are printing.... FIX ME
	mov rsi, rbx; move it into rsi to be the buffer we print
	add rsi, 48;  convert number from decimal to it's ascii code
	push rsi;     put it on the stack so we can get the address
	mov rsi, rsp; get the address of the first item of the stack, so we can print it
	mov rdi, 1;   set fd to stdout
	mov rdx, 1;   we are writing one byte
	mov rax, 1;   set syscall number to SYS_write
	syscall;

	mov rax, 1;   set syscall number to SYS_write
	mov rdi, 1;   set fd to stdout
	mov rsi, 0xa; newline character
	push rsi;     put it on the stack so we can get the address
	mov rsi, rsp; get the address of the first item of the stack, so we can print it
	mov rdx, 1;   we are writing one byte
	syscall; 

	cmp rbx, 8;  compare to the max number we will print, minus 1
	jle XYZ;    if less than, jump back to ... FIX THIS

	mov rax, 60; set syscall number to SYS_exit
	mov rdi, 0; set code to EXIT_SUCCESS
	; There should be an instruction here... FIX THIS
