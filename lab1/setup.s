!
! SYS_SIZE is the number of clicks (16 bytes) to be loaded.
! 0x3000 is 0x30000 bytes = 196kB, more than enough for current
! versions of linux
!
SYSSIZE = 0x3000
!
!	bootsect.s		(C) 1991 Linus Torvalds
!
! bootsect.s is loaded at 0x7c00 by the bios-startup routines, and moves
! iself out of the way to address 0x90000, and jumps there.
!
! It then loads 'setup' directly after itself (0x90200), and the system
! at 0x10000, using BIOS interrupts. 
!
! NOTE! currently system is at most 8*65536 bytes long. This should be no
! problem, even in the future. I want to keep it simple. This 512 kB
! kernel size should be enough, especially as this doesn't contain the
! buffer cache as in minix
!
! The loader has been made as simple as possible, and continuos
! read errors will result in a unbreakable loop. Reboot by hand. It
! loads pretty fast by getting whole sectors at a time whenever possible.

.globl begtext, begdata, begbss, endtext, enddata, endbss
.text
begtext:
.data
begdata:
.bss
begbss:
.text

SETUPLEN = 4				! nr of setup-sectors
BOOTSEG  = 0x07c0			! original address of boot-sector
INITSEG  = 0x9000			! we move boot here - out of the way
SETUPSEG = 0x9020			! setup starts here
SYSSEG   = 0x1000			! system loaded at 0x10000 (65536).
ENDSEG   = SYSSEG + SYSSIZE		! where to stop loading

! ROOT_DEV:	0x000 - same type of floppy as boot.
!		0x301 - first partition on first drive etc
ROOT_DEV = 0x306

entry _start
_start:
	mov	ax,cs
	mov	ds,ax
	
        mov     es,ax

	mov	ah,#0x03		! read cursor pos
	xor	bh,bh
	int	0x10
	
	mov	cx,#28
	mov	bx,#0x0007		! page 0, attribute 7 (normal)
	mov	bp,#msg1
	mov	ax,#0x1301		! write string, move cursor
	int	0x10

! ok, we've written the message, now

! 光标 0x9000:0
      
        mov     ax,#INITSEG
        mov     ds,ax
        mov     ah,#0x03
        xor     bh,bh
        int     0x10
        mov     [0],dx                  !将光标的位置写入0x9000:0

! memory         0x9000:2

        mov     ah,#0x88
        int     0x15
        mov     [2],ax


! 重置ds为0x9000
       mov      ax,#INITSEG
       mov      ds,ax
       mov      ax,#SETUPSEG
       mov      es,ax

!显示字符串
       mov      ah,#0x03
       xor      bh,bh
       int      0x10
       mov      cx,#11
       mov      bx,#0x007
       mov      bp,#cur
       mov      ax,#0x1301
       int      0x10 

!输出
       mov     ax,[0]
       call    print_hex 
       call    print_nl

!显示字符串--内存
       mov      ah,#0x03
       xor      bh,bh
       int      0x10
       mov      cx,#12
       mov      bx,#0x007
       mov      bp,#mem
       mov      ax,#0x1301
       int      0x10 

!显示信息
       mov      ax,[2]
       call     print_hex
       call     print_nl


! 循环啊喂！！！

l: jmp l
print_hex:
	mov cx,#4   ! 4个十六进制数字
	mov dx,ax   ! 将ax所指的值放入dx中，ax作为参数传递寄存器
print_digit:
	rol dx,#4  ! 循环以使低4比特用上 !! 取dx的高4比特移到低4比特处。
	mov ax,#0xe0f  ! ah = 请求的功能值,al = 半字节(4个比特)掩码。
	and al,dl ! 取dl的低4比特值。
	add al,#0x30  ! 给al数字加上十六进制0x30
	cmp al,#0x3a
	jl outp  !是一个不大于十的数字
	add al,#0x07  !是a~f,要多加7
outp:
	int 0x10
	loop print_digit
	ret

!打印回车换行
print_nl:
	mov ax,#0xe0d
	int 0x10
	mov al,#0xa
	int 0x10
	ret

msg1:
	.byte 13,10
	.ascii "Now we are in SETUP..."
	.byte 13,10,13,10

cur:
        .ascii "Cursor POS:"

mem:
        .ascii "Memory Size:"



.text
endtext:
.data
enddata:
.bss
endbss:
