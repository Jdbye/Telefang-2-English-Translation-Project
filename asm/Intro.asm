 ; Telefang 2 Power Intro Hack by Jdbye
 ; Purpose: Adds an intro to the ROM

.gba				; Set the architecture to GBA
.open "rom/power_patched.gba",0x08000000		; Open input.gba for output.
					; 0x08000000 will be used as the
					; header size
					
.macro adr,destReg,Address
here:
	.if (here & 2) != 0
		add destReg, r15, (Address-here)-2
	.else
		add destReg, r15, (Address-here)
	.endif
.endmacro
.arm
.org 0x8000000
b main

.org 0x8870000
main:
mov r3, #0x10
ldr r4, =0x4000054
strh r3, [r4] ; set brightness to max (white)

mov r0, #0x4000000 ; the usual set up routine
mov r1, #0x400 ; 0x403 is BG 2 enable, and mode 3.
add r1, r1, #3
strh r1, [r0] ; the memory I/O value we're setting is actually 16bits, let's not mess
; something else up by writting 32.
mov r0, #0x6000000 ; address of VRAM
ldr r1, =splashScreen; using this form of LDR with a label will put the address of the label into r1.
mov r2, #0x960 ; the amount of 32 BYTE writes to fill the screen (we'll be using a new instruction)
loop1:
ldmia r1!, r3,r4,r5,r6,r7,r8,r9,r10 ; will start with the address in r1, it will load each listed register
; with 32bits from memory, incrementing the address by 4 each time. The final address used +4
; will be written back into r1 (because of the !). Note this instruction doesn't use
; brackets around the register used for the address.
stmia r0!, r3,r4,r5,r6,r7,r8,r9,r10 ; will start with the address in r1, it will store each listed register
; into memory (32bit write), adding 4 to the address. The final address used +4 will 
; be written back.
; These instructions are a fast(er) way to do block memory copying, they are only useful when you have alot of
; registers available (registers 3-10 were used here, but I could have said r2,r4, they don't have to be in order
; just don't use the address register in the destination list.
subs r2, r2, #1 ; subtraction setting the flags
bne loop1 ; will loop if r2 wasn't zero.

mov r0, #0x10
mov r1, #0x0
ldr r2, =0x4000054
fadein:
swi 0x5 ;VBlankIntrWait
swi 0x5 ;VBlankIntrWait
swi 0x5 ;VBlankIntrWait
sub r0, r0, #0x1
strh r0, [r2] ; set brightness to r0
cmp r0, r1
bhi fadein
infin:
ldr r0, =CheckKeys
bx r0
CheckKeys:
ldr r0, =0x4000130
ldrh r0, [r0]
;mov r1, #0xA3FE ;A+B+L+R
ldr r1, [buttons]
cmp r0, r1
beq 0x80000C0 ; jump to original code when A pressed
b infin ; infinite loop
; .ltorg ; give the assembler a place to put the immediate value "pool", needed for the ldr REG,= (s). pic:
; a label to indicate the address of the included data.
.align 4
.align 4
buttons:
	.word 0x000003FE
	
.pool
splashScreen:
.incbin "asm/bin/splashScreen.bin" ; include the binary file
