global _start

section .text

_start:
	sub rsp, 0x8;
	mov rax, 0;
	mov rdi, 0;
	mov rsi, rsp;
	mov rdx, 5;
	syscall;
	
	mov rbx, 0xffffffff
	and [rsp], rbx;
	

	mov rax, [rsp];
	and rax, 0xff;
	sub rax, 48;

	mov rbx, [rsp+1];
	and rbx, 0xff;
	sub rbx, 48;

	mov rcx, [rsp+2];
	and rcx, 0xff;
	sub rcx, 48;


	mov rdx, [rsp+3];
	and rdx, 0xff;
	sub rdx, 48;
	
	mov rdi, 0;
	add rdi, rax;
	add rdi, rbx;
	add rdi, rcx;
	add rdi, rdx;

	imul rax, rbx;
	imul rax, rcx;
	imul rax, rdx;
	add rdi, rax;

	cmp rdi, 0x4d;
	je .correct

	mov rax, 1;
	mov rdi, 1;
	mov rsi, incorrect;
	mov rdx, iclen;
	syscall;

	mov rax, 60;
	mov rdi, 0;
	syscall;

	.correct:
	mov rax, 1;
	mov rdi, 1;
	mov rsi, correct;
	mov rdx, clen;
	syscall;

	mov rax, 60;
	mov rdi, 0;
	syscall;

section .data
	correct db "Correct! Well done :)", 0xa, 0x0;
	clen equ $ - correct;
	
	incorrect db ":(", 0xa, 0x0;
	iclen equ $ - incorrect;


