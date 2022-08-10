
//////////////////////////////////////////////////////////////////////
//
// 8/10/2022 KJS, this version is based on original
// but has bee reformatted to compile inside of:
//		SIMH running pdp11 running 211bsd, running 'as' assembler.
//
// a main() stub
//

.globl  _main
.text
_main:
~main:
jsr     r5,csv
jbr     L1
L2:~x=177766
~y=177764
mov     $144,-12(r5)
mov     $2,-14(r5)
mov     -12(r5),r1
mul     -14(r5),r1
mov     r1,(sp)
jmp		kenadv
L3:jmp  cret
L1:sub  $4,sp
jbr     L2

//////////////////////////////////////////////////////////////////////

//
//	cpsc5.s
// This version has these changes applied:
//		- comments ; to /
//		- .ascii replaced with .bytes
//		- lower case file
//		- replaced $NUM with NUM.
//		- replaced # with $
//		- '%' Binary strings replaced with octal
//

kenadv:	mov	$rmtable,r4
		mov	$title,r1
		jsr	pc,prez
		jsr	pc,prcr
mainx:	jsr	pc,movstf
		jsr	pc,prroom
		jsr	pc,probj
getcom:	jsr	pc,prcr
		jsr	pc,prprom
		jsr	pc,getcmd
		jsr	pc,nulcmd
		mov	$buffer,r0		/point to first cmd.
		mov	$get,r1			/point to cnd list.
		jsr	pc,comand		/find command
		cmp	r0,$00			/command not found?
		bne	skip5			/if not then skip
		jsr	pc,errcmd
		br	getcom
skip5:	dec	r0
		asl	r0
		add	$runtbl,r0		/r0 point to adress to run.
		mov	(r0),pc			/jump to command.

title:	 .byte 124,150,151,163,40,160,162,157,147,162,141,155,40,162,145,143,157,147,156,151,172,145,163,40,164,150,145,40,146,157,154,154,157,167,151,156,147,40,143,157,155,155,141,156,144,163,72 / "this program recognizes the following commands:"
		.byte 12
		 .byte 40,40,40,40,147,157,54,155,157,166,145,54,147,145,164,54,160,165,164,54,164,141,153,145,54,144,162,157,160,54,150,145,154,160,52,54,154,157,147,151,156,52,54,141,163,153,52,54,162,145,141,144,52 / "    go,move,get,put,take,drop,help*,login*,ask*,read*"
		.byte 12
		 .byte 40,40,40,40,144,162,151,156,153,54,145,141,164,54,154,157,157,153,54,167,141,151,164,54,151,156,166,145,156,164,157,162,171,54,163,143,157,162,145,40,141,156,144,40,161,165,151,164,56 / "    drink,eat,look,wait,inventory,score and quit."
		.byte 12
		 .byte 125,163,145,40,156,157,162,164,150,54,163,157,165,164,150,54,145,141,163,164,40,157,162,40,167,145,163,164,40,164,157,40,155,157,166,145,40,151,156,163,164,145,141,144,40,157,146,40,147,157,56 / "use north,south,east or west to move instead of go."
		.byte 12
		 .byte 116,117,124,105,72,40,52,40,144,145,156,157,164,145,163,40,141,156,40,151,155,160,157,162,164,141,156,164,40,143,157,155,155,141,156,144,56 / "note: * denotes an important command."
		.byte 12,00
		.even

movstf:	mov	r0,-(sp)
		mov	r1,-(sp)
		mov	r2,-(sp)
		mov	r3,-(sp)
		cmp	objcnt,$49.
		bne	skip20
		clr	objcnt
skip20:	mov	objcnt,r0
		asl	r0
		mov	r0,r1			/save r0
		mov	profmv(r0),r3		/move prof
		asl	r3
		mov	objhak,r2
		add	r2,r3
		mov	(r3),objhak
		mov	r1,r0			/move insane
		mov	insmv(r0),r3
		asl	r3
		mov	objins,r2
		add	r2,r3
		mov	(r3),objins
		jsr	pc,chkdrk		/check for drink in termr
		mov	(sp)+,r3
		mov	(sp)+,r2
		mov	(sp)+,r1
		mov	(sp)+,r0
		inc	objcnt
		rts	pc

profmv:	2;3;3;1;2;3;1;2;3;3;2;2;4;4;2;1;4;4;1;4;1;4;1
		2;3;2;2;3;3;1;2;3;1;1;1;2;2;2;3;3;1;1;4;4;4;2;1;4;1
insmv:	2;4;1;2;4;1;3;3;1;2;3;2;3;2;4;1
		2;4;1;2;4;1;3;3;1;2;3;2;3;2;4;1
		2;4;1;2;4;1;3;3;1;2;3;2;3;2;4;1;3
		.even

chkdrk:		cmp	objjlt,$tma112
		beq	movem
		cmp	objsev,$tma112
		beq	movem
		cmp	objcok,$tma112
		beq	movem
		mov	$tew8,objsup
		rts	pc
movem:		mov	$tma112,objsup
		rts	pc

prroom:		mov	r1,-(sp)
		mov	(r4),r1
		jsr	pc,prez
		mov	(sp)+,r1
		rts	pc

prcr:		mov	r0,-(sp)
/// new4 ///////////////////////////////////////////////////////////////////
		mov	$1,-(sp)		/ KJS
		mov	$temp1,-(sp)
		mov	$1,-(sp)		/ stdout
		jsr	pc,*$_write
		cmp	(sp)+,(sp)+
		tst (sp)+
//////////////////////////////////////////////////////////////////////

/// old4 ///////////////////////////////////////////////////////////////////
/		mov	$1,r0
/		trap	4
/		temp1
/		1
//////////////////////////////////////////////////////////////////////
		mov	(sp)+,r0
		rts	pc
temp1:		.byte 12
		.even

probj:		mov	r3,-(sp)
		mov	r1,-(sp)
		mov	$obtable,r3
loop1:		cmp	(r3),$00
		beq	exit1
		cmp	(r3),r4
		beq	printit
		add	$4,r3
		br	loop1

printit:	mov	$temp2,r1
		jsr	pc,prez
		add	$2,r3		
		mov	(r3),r1
		jsr	pc,prez
		add	$2,r3
		mov	$temp3,r1
		jsr	pc,prez
		jsr	pc,prcr
		br	loop1
exit1:		mov	(sp)+,r1
		mov	(sp)+,r3
		rts	pc
temp3:		 .byte 40,151,163,40,150,145,162,145,56 / " is here." 
		.byte 0
temp2:		 .byte 101,40 / "a " 
		.byte 0
		.even

prprom:		mov	r1,-(sp)
		mov	$prompt,r1
		jsr	pc,prez
		mov	(sp)+,r1
		rts	pc
prompt:		 .byte 127,145,154,154,77,40 / "well? " 
		.byte 0
		.even

getcmd:		mov	r0,-(sp)

/// new3 ///////////////////////////////////////////////////////////////////
		mov $78.,-(sp)			// kjs added -
		mov $buffer,-(sp)
		mov $0,-(sp)		/ stdin
		jsr pc,*$_read
		cmp	(sp)+,(sp)+
		tst (sp)+				// kjs added
		cmp	r0,$78.
//////////////////////////////////////////////////////////////////////

/// old3 ///////////////////////////////////////////////////////////////////
/		mov	$0,r0
/		trap	3
/		buffer
/		78.
/		cmp	r0,$78.
//////////////////////////////////////////////////////////////////////
		blo	exit2

loop3:
/// new3 ///////////////////////////////////////////////////////////////////
		mov $10.,-(sp)			// kjs added
		mov $flushy,-(sp)
		mov $0,-(sp)		/ stdin
		jsr pc,*$_read
		cmp	(sp)+,(sp)+
		tst	(sp)+				// kjs added
		cmp	r0,$10.
//////////////////////////////////////////////////////////////////////

/// old3 ///////////////////////////////////////////////////////////////////
/		mov	$0,r0
/		trap	3
/		flushy
/		10.
/		cmp	r0,$10.
//////////////////////////////////////////////////////////////////////
		bhis	loop3
exit2:		mov	(sp)+,r0

/		movb	$'l,buffer
/		movb	$'o,buffer+1
/		movb	$'o,buffer+2
/		movb	$'k,buffer+3
/		movb	$12,buffer+4
		rts	pc

nulcmd:		mov	r1,-(sp)
		mov	r0,-(sp)
		mov	$buffer,r1
		clr	r0
loop4:		cmpb	(r1),$40		/space
		bne	skip3
		cmp	r0,$0
		bne	skip4
		inc	r0
		mov	r1,secwrd
		inc	secwrd
skip4:		movb	$00,(r1)
skip3:		cmpb	(r1),$12
		beq	exit3
		cmp	r1,$buffer+78.
		beq	exit3
		inc	r1
		br	loop4
exit3:		movb	$00,(r1)
		inc	r1
		movb	$00,(r1)
		mov	(sp)+,r0
		mov	(sp)+,r1
		rts	pc

errcmd:		mov	r1,-(sp)
		mov	$temp4,r1
		jsr	pc,prez
		mov	(sp)+,r1
		jsr	pc,prcr
		rts	pc
temp4:		 .byte 111,156,166,141,154,151,144,40,103,120,123,103,40,157,160,145,162,141,164,151,157,156,56 / "invalid cpsc operation." 
		.byte 0
		.even

cgo:	mov	r0,-(sp)
		mov	r1,-(sp)
		mov	r2,-(sp)
		mov	r3,-(sp)
		mov	$secwrd,r0
		mov	(r0),r0
		mov	$north,r1
		jsr	pc,comand
		cmp	r0,$00
		bne	skip7
		mov	$temp8,r1
		jsr	pc,prez
		jsr	pc,prcr
		mov	(sp)+,r3
		mov	(sp)+,r2
		mov	(sp)+,r1
		mov	(sp)+,r0
		jsr	pc,movstf
		jmp	getcom
skip7:		mov	r0,r2			/save r0
		mov	r4,r3			/save r4
		asl	r0
		add	r4,r0
		cmp	(r0),$tma153		/going to daves room?
		beq	shtst1
		br	gonext
shtst1:		jmp	gotst1
gonext:		cmp	(r0),$tma174		/going to machine room?
		beq	shtst2
		br	gobak
shtst2:		jmp	gotst2
gobak:		mov	(r0),r4
		mov	$0177757,r0 / %1111111111101111
loop8:		asr	r0
		dec	r2
		bne	loop8
		add	$10.,r3
		mov	(r3),r1
		bic	r0,r1
		bne	skip8
		mov	$temp9,r1
		jsr	pc,prez
		jsr	pc,prcr
		mov	(sp)+,r3
		mov	(sp)+,r2
		mov	(sp)+,r1
		mov	(sp)+,r0
		jmp	getcom
skip8:		mov	(sp)+,r3
		mov	(sp)+,r2
		mov	(sp)+,r1
		mov	(sp)+,r0
		jmp	mainx

gotst1:		cmp	objsup,$tew8			/super-user gone?
		bne	gobak
		mov	$temp30,r1
		jsr	pc,prez
		jsr	pc,prcr
		br	gosk1
gotst2:		cmp	obtable,$001			/1=you
		beq	gobak
		mov	$temp31,r1
		jsr	pc,prez
		jsr	pc,prcr
gosk1:		mov	(sp)+,r3
		mov	(sp)+,r2
		mov	(sp)+,r1
		mov	(sp)+,r0
		jmp	getcom
temp8:		 .byte 125,163,145,40,116,157,162,164,150,54,123,157,165,164,150,54,105,141,163,164,40,157,162,40,127,145,163,164,56 / "use north,south,east or west." 
		.byte 0
temp9:		 .byte 124,150,151,163,40,162,157,157,155,40,144,157,145,163,40,156,157,164,40,150,141,166,145,40,141,156,40,145,170,151,164,40,164,150,141,164,40,167,141,171,56 / "this room does not have an exit that way." 
		.byte 0
temp30:		 .byte 124,150,145,40,163,165,160,145,162,55,165,163,145,162,40,142,154,157,143,153,163,40,171,157,165,162,40,167,141,171,41 / "the super-user blocks your way!" 
		.byte 0
temp31:		 .byte 124,150,145,40,155,141,143,150,151,156,145,40,162,157,157,155,40,151,163,40,154,157,143,153,145,144,56,40,101,40,153,145,171,40,151,163,40,162,145,161,165,151,162,145,144,56 / "the machine room is locked. a key is required." 
		.byte 0
		.even

cget:		mov	r0,-(sp)
		mov	r1,-(sp)
		mov	$secwrd,r1
		mov	(r1),r0
		mov	$key,r1
		jsr	pc,comand
		cmp	r0,$00
		bne	skip11
back1:		mov	$temp11,r1
		jsr	pc,prez
		jsr	pc,prcr
		mov	(sp)+,r1
		mov	(sp)+,r0
		jmp	getcom
skip11:		cmp	r0,$15.
		blo	skip12
		mov	$temp15,r1
		jsr	pc,prez
		dec	r0
		asl	r0
		asl	r0
		add	$obtable,r0
		add	$2,r0
		mov	(r0),r1
		jsr	pc,prez
		mov	$temp16,r1
		jsr	pc,prez
		jsr	pc,prcr
		mov	(sp)+,r1
		mov	(sp)+,r0
		jmp	getcom
skip12:		dec	r0
		asl	r0
		asl	r0
		add	$obtable,r0
		cmp	(r0),r4
		bne	back1
		mov	$01,(r0)
		add	$2,r0
		mov	(r0),r1
		jsr	pc,prez
		mov	$temp12,r1
		jsr	pc,prez
		jsr	pc,prcr
		mov	(sp)+,r1
		mov	(sp)+,r0
		jsr	pc,movstf
		jmp	getcom
temp11:		 .byte 124,150,141,164,40,157,142,152,145,143,164,40,151,163,40,156,157,164,40,150,145,162,145,56 / "that object is not here." 
		.byte 0
temp12:		 .byte 40,164,141,153,145,156,56 / " taken." 
		.byte 0
temp15:		 .byte 131,157,165,40,143,141,156,156,157,164,40,147,145,164,40,164,150,145,40 / "you cannot get the " 
		.byte 0
temp16:		 .byte 41 / "!" 
		.byte 0
		.even

cput:		mov	r0,-(sp)
		mov	r1,-(sp)
		mov	$secwrd,r1
		mov	(r1),r0
		mov	$key,r1
		jsr	pc,comand
		cmp	r0,$00
		bne	skip13
back2:		mov	$temp13,r1
		jsr	pc,prez
		jsr	pc,prcr
		mov	(sp)+,r1
		mov	(sp)+,r0
		jmp	getcom
skip13:		dec	r0
		asl	r0
		asl	r0
		add	$obtable,r0
		cmp	(r0),$001
		bne	back2
		mov	r4,(r0)
		add	$2,r0
		mov	(r0),r1
		jsr	pc,prez
		mov	$temp14,r1
		jsr	pc,prez
		jsr	pc,prcr
		mov	(sp)+,r1
		mov	(sp)+,r0
		jsr	pc,movstf
		jmp	getcom
temp13:		 .byte 131,157,165,40,144,157,156,47,164,40,150,141,166,145,40,164,150,141,164,41 / "you don't have that!" 
		.byte 0
temp14:		 .byte 40,150,141,163,40,142,145,145,156,40,163,145,164,40,144,157,167,156,56 / " has been set down." 
		.byte 0
		.even

cuse:		jmp	notimp

cinv:		mov	r0,-(sp)
		mov	r1,-(sp)
		mov	$temp10,r1
		jsr	pc,prez
		jsr	pc,prcr
		mov	$obtable,r0
loop10:		cmp	(r0),$01		/ 1=you.
		bne	skip9
		add	$2,r0
		mov	(r0),r1
		jsr	pc,prez
		jsr	pc,prcr
		add	$2,r0
		br	loop10
skip9:		cmp	(r0),$00		/ 0=table end.
		beq	exit4
		add	$4,r0
		br	loop10
exit4:		mov	(sp)+,r1
		mov	(sp)+,r0
		jsr	pc,prcr
		jsr	pc,movstf
		jmp	getcom
temp10:		 .byte 131,157,165,162,40,125,40,157,146,40,103,40,142,141,147,40,143,157,156,164,141,151,156,163,40,164,150,145,40,146,157,154,154,157,167,151,156,147,72 / "your u of c bag contains the following:" 
		.byte 0
		.even

ceat:
		mov	secwrd,r0
		mov	$key,r1
		jsr	pc,comand
		cmp	r0,$00
		beq	eterr1
		dec	r0
		asl	r0
		asl	r0
		mov	obtable(r0),r1
		cmp	r1,$01
		bne	eterr2
		mov	$02,obtable(r0)
		mov	$etmsg4,r1
		jsr	pc,prez
		jsr	pc,prcr
		jmp	getcom
eterr1:		mov	$etmsg3,r1
		jsr	pc,prez
		jsr	pc,prcr
		jmp	getcom
eterr2:		mov	$etmsg2,r1
		jsr	pc,prez
		jsr	pc,prcr
		jmp	getcom
etmsg3:		 .byte 111,40,144,157,156,47,164,40,165,156,144,145,162,163,164,141,156,144,40,164,150,141,164,40,146,157,157,144,56 / "i don't understand that food." 
		.byte 0
etmsg2:		 .byte 131,157,165,40,143,141,156,47,164,40,145,141,164,40,167,150,141,164,40,171,157,165,40,144,157,40,156,157,164,40,150,141,166,145,56 / "you can't eat what you do not have." 
		.byte 0
etmsg4:		 .byte 131,157,165,40,146,145,145,154,40,142,145,164,164,145,162,54,40,142,165,164,40,164,150,145,40,157,142,152,145,143,164,163,40,147,157,156,145,56 / "you feel better, but the objects gone." 
		.byte 0
		.even



cquit:		mov	$temp7,r1
		jsr	pc,prcr
		jsr	pc,prez
		jsr	pc,prcr
		jsr	pc,prcr
		jmp	cret				/ EXIT

temp7:		 .byte 110,141,144,40,145,156,157,165,147,150,40,157,146,40,103,120,123,103,40,146,157,162,40,157,156,145,40,144,141,171,54,40,145,150,77,40,114,157,147,157,165,164,40,116,157,167,41 / "had enough of cpsc for one day, eh? logout now!" 
		.byte 0
		.even

clogin:
		cmp	r4,$tma160
		beq	logsk
logbak:		mov	$lgmsg1,r1
		jsr	pc,prez
		jsr	pc,prcr
		jmp	lgend
logsk:		mov	$lgmsg2,r1
		jsr	pc,prez
		jsr	pc,getcmd
		jsr	pc,prcr
		jsr	pc,nulcmd
		mov	$buffer,r0
		mov	$root,r1
		jsr	pc,compr
		cmp	r0,$01
		bne	logne
		mov	$lgmsg3,r1
		jsr	pc,prez
		jsr	pc,getcmd
		jsr	pc,prcr
		jsr	pc,nulcmd
		mov	$buffer,r0
		mov	$rotpas,r1
		jsr	pc,compr
		cmp	r0,$01
		bne	logpe
		cmp	objpsw,$01
		bne	logpe
redoo:		mov	$lgmsg4,r1
		jsr	pc,prez
		jsr	pc,getcmd
		jsr	pc,prcr
		jsr	pc,nulcmd
		mov	$buffer,r0
		mov	$rbtcmd,r1
		jsr	pc,compr
		cmp	r0,$01
		beq	winner
		mov	$lgtcmd,r1
		mov	$buffer,r0
		jsr	pc,compr
		cmp	r0,$01
		beq	lgend
		br	logce
logce:		mov	$lgmsg5,r1
		jsr	pc,prez
		br	redoo
logne:		mov	$lgmsg6,r1
		jsr	pc,prez
		br	lgend
logpe:		mov	$lgmsg7,r1
		jsr	pc,prez
		br	lgend
lgend:		jmp	getcom
winner:		mov	$lgmsg8,r1
		jsr	pc,prez
		jsr	pc,prcr
		jsr	pc,prcr
		jmp	cret			/ EXIT
lgmsg8:		 .byte 56,56,56,56,40,156,157,167,40,162,145,55,142,157,157,164,151,156,147,40,56,56,56,56 / ".... now re-booting ...."
		.byte 12
		 .byte 101,154,154,40,164,150,145,40,164,145,162,155,151,156,141,154,163,40,144,151,163,160,154,141,171,40,147,141,162,142,141,147,145,40,157,156,40,164,150,145,40,163,143,162,145,145,156,56 / "all the terminals display garbage on the screen."
		.byte 12
		 .byte 103,157,156,147,162,141,144,165,154,141,164,151,157,156,163,40,171,157,165,40,150,141,166,145,40,162,145,163,145,164,40,164,150,145,40,126,101,130,40,171,157,165,40,127,111,116,41,41,41,41 / "congradulations you have reset the vax you win!!!!"
		.byte 12
		 .byte 46,45,43,44,45,47,51,46,45,44,45,47,47,45,46,45,44,45,46,44,124,131,106,131,124,46,45,107,106,50,46,45,106,46,50,50,46,45,106,45,46,176,176,176,176,176,176 / "&%$$%')&%$%''%&%$%&$tyfyt&%gf(&%f&((&%f%&~~~~~~"
		.byte 12,12,00
lgmsg1:		 .byte 131,157,165,40,141,162,145,40,165,156,141,142,154,145,40,164,157,40,154,157,147,151,156,40,150,145,162,145,56 / "you are unable to login here."
		.byte 12,00
lgmsg2:		 .byte 125,156,151,166,145,162,163,151,164,171,40,157,146,40,103,141,154,147,141,162,171,40,40,40,40,64,56,62,40,102,123,104,40,40,125,156,151,170,40,40,40,40,40,40,40,133,166,141,170,144,135 / "university of calgary    4.2 bsd  unix       [vaxd]"
		.byte 12,12
		 .byte 154,157,147,151,156,72,40 / "login: "
		.byte 00
lgmsg3:		 .byte 160,141,163,163,167,157,162,144,72,40 / "password: " 
		.byte 0
lgmsg4:		 .byte 45,40 / "% " 
		.byte 0
lgmsg5:		 .byte 143,157,155,155,141,156,144,40,156,157,164,40,146,157,165,156,144,56 / "command not found."
		.byte 12,00
lgmsg6:		 .byte 165,163,145,162,40,156,157,164,40,146,157,165,156,144,56 / "user not found."
		.byte 12,00
lgmsg7:		 .byte 154,157,147,151,156,40,151,156,143,157,162,162,145,143,164,56 / "login incorrect."
		.byte 12,00
root:		 .byte 162,157,157,164 / "root" 
		.byte 0
		.byte 00
rotpas:		 .byte 46,163,144,145,41,160,65 / "&sde!p5" 
		.byte 0
		.byte 00
rbtcmd:		 .byte 162,145,142,157,157,164 / "reboot" 
		.byte 0
lgtcmd:		 .byte 154,157,147,157,165,164 / "logout" 
		.byte 0
		.even


clogout:	jmp	notimp
creboot:	jmp	notimp

clook:		jmp	mainx

chelp:		mov	r1,-(sp)
		cmp	r4,$tma114
		beq	help1
		mov	$temp6,r1
back4:		jsr	pc,prez
		jsr	pc,prcr
		mov	(sp)+,r1
		jsr	pc,movstf
		jmp	getcom
help1:		mov	$temp61,r1
		jmp	back4
temp6:		 .byte 101,163,153,40,124,150,145,157,40,104,145,162,141,141,144,164,54,40,157,162,40,147,157,40,164,157,40,164,150,145,40,143,157,156,164,151,156,157,165,163,40,164,165,164,157,162,151,141,154,40,146,157,162,40,150,145,154,160,56 / "ask theo deraadt, or go to the continous tutorial for help."
		.byte 12
		 .byte 124,141,154,153,151,156,147,40,164,157,40,141,156,171,157,156,145,40,145,154,163,145,40,143,157,165,154,144,40,142,145,40,162,151,163,153,171,56 / "talking to anyone else could be risky." 
		.byte 0
temp61:		 .byte 124,150,145,40,103,124,40,160,145,162,163,157,156,40,151,163,40,157,165,164,40,164,157,40,154,165,156,143,150,56,40,102,165,164,40,141,40,163,151,147,156,40,156,145,141,162,142,171,40,162,145,141,144,163,72 / "the ct person is out to lunch. but a sign nearby reads:"
		.byte 12
		 .byte 56,56,56,56,56,125,163,145,40,122,105,102,117,117,124,40,164,157,40,167,151,156,56,56,56,56,56,56 / ".....use reboot to win......" 
		.byte 0
		.even

cdrink:
		mov	secwrd,r0
		mov	$key,r1
		jsr	pc,comand
		cmp	r0,$00
		beq	drerr1
		dec	r0
		asl	r0
		asl	r0
		mov	obtable(r0),r1
		cmp	r1,$01
		bne	drerr2
		cmp	r1,objjlt
		beq	drbev
		cmp	r1,objcok
		beq	drbev
		cmp	r1,objsev
		beq	drbev
		mov	$drmsg1,r1
		jsr	pc,prez
		jsr	pc,prcr
		jmp	getcom
drerr1:		mov	$drmsg2,r1
		jsr	pc,prez
		jsr	pc,prcr
		jmp	getcom
drerr2:		mov	$drmsg3,r1
		jsr	pc,prez
		jsr	pc,prcr
		jmp	getcom
drbev:		mov	$02,obtable(r0)
		mov	$drmsg4,r1
		jsr	pc,prez
		jsr	pc,prcr
		jmp	getcom
drmsg1:		 .byte 131,157,165,40,143,157,156,156,157,164,40,144,162,151,156,153,40,164,150,141,164,40,151,164,145,155,41 / "you connot drink that item!" 
		.byte 0
drmsg2:		 .byte 111,40,144,157,156,47,164,40,165,156,144,145,162,163,164,141,156,144,40,164,150,141,164,40,142,145,166,145,162,141,147,145,56 / "i don't understand that beverage." 
		.byte 0
drmsg3:		 .byte 131,157,165,40,144,157,156,47,164,40,150,141,166,145,40,164,150,141,164,56 / "you don't have that." 
		.byte 0
drmsg4:		 .byte 124,150,145,40,144,162,151,156,153,40,143,154,145,141,162,163,40,171,157,165,162,40,150,145,141,144,56 / "the drink clears your head." 
		.byte 0
		.even

		

cread:		mov	r0,-(sp)
		mov	r1,-(sp)
		mov	r2,-(sp)
		jsr	pc,prcr
		mov	secwrd,r0
		mov	$key,r1
		jsr	pc,comand
		cmp	r0,$00
		beq	skip16
		mov	r0,r2			/save r0.
		dec	r2
		asl	r2
		asl	r2
		add	$obtable,r2
		cmp	(r2),$001		/1=you
		bne	test1
		br	skip17
test1:		cmp	(r2),r4
		bne	skip16
skip17:		dec	r0
		asl	r0
		add	$redtbl,r0
		mov	(r0),r1
		jsr	pc,prez
		jsr	pc,prcr
		jsr	pc,prcr
		mov	(sp)+,r2
		mov	(sp)+,r1
		mov	(sp)+,r0
		jsr	pc,movstf
		jmp	getcom
skip16:		mov	$temp17,r1
		jsr	pc,prez
		jsr	pc,prcr
		jsr	pc,prcr
		mov	(sp)+,r2
		mov	(sp)+,r1
		mov	(sp)+,r0
		jmp	getcom
temp17:		 .byte 116,157,164,40,141,166,141,151,154,141,142,154,145,40,146,157,162,40,162,145,141,144,151,156,147,56 / "not available for reading." 
		.byte 0
		.even

redtbl:		mkey
		mpsw
		mpas
		mcoin
		mpdp
		mmat
		mjlt
		mcok
		msev
		mchp
		mbrd
		mprt
		mfma
		mrs2
		mamb
		msun
		mv52
		mv50
		mins
		msys
		mman
		mhak
		
mkey:		 .byte 56,56,56,56,56,40,126,101,130,40,61,61,57,67,70,60,40,56,56,56,56,56,56 / "..... vax 11/780 ......" 
		.byte 0
mhak:		 .byte 122,145,141,144,151,156,147,40,164,150,145,40,160,162,157,146,146,145,163,157,162,40,151,163,156,47,164,40,141,154,154,157,167,145,144,56 / "reading the proffesor isn't allowed." 
		.byte 0
mpsw:		 .byte 124,150,145,40,160,141,163,163,167,157,162,144,40,163,141,171,163,72,40,46,163,144,145,41,160,65 / "the password says: &sde!p5" 
		.byte 0
mpas:		 .byte 124,150,145,40,142,157,157,153,40,163,141,171,163,72,40,101,144,166,145,156,164,165,162,145,40,167,162,151,164,164,145,156,40,142,171,40,113,145,156,40,123,164,141,165,146,146,145,162,56 / "the book says: adventure written by ken stauffer." 
		.byte 0
mcoin:		 .byte 124,150,145,40,143,157,151,156,40,162,145,141,144,163,40,154,151,153,145,40,141,156,40,157,164,150,145,162,40,65,60,40,143,145,156,164,40,160,151,145,143,145,56 / "the coin reads like an other 50 cent piece." 
		.byte 0
mpdp:		 .byte 124,150,145,40,142,157,157,153,40,163,141,171,163,72,40,47,120,104,120,55,61,61,40,141,163,163,145,155,142,154,171,40,160,162,157,147,162,141,155,155,151,156,147,47 / "the book says: 'pdp-11 assembly programming'" 
		.byte 0
mmat:		 .byte 123,157,162,162,171,40,164,150,151,163,40,142,157,157,153,40,151,163,40,151,156,40,147,162,145,145,153,56 / "sorry this book is in greek." 
		.byte 0
mjlt:		 .byte 124,150,145,40,143,141,156,40,157,146,40,112,157,154,164,40,163,141,171,163,72 / "the can of jolt says:"
		.byte 12
		 .byte 11,127,101,122,116,111,116,107,72,40,111,156,40,145,170,160,145,162,151,155,145,156,164,141,154,40,164,145,163,164,163,40,167,151,164,150,40,163,164,165,144,145,156,164,163,40,56,56,56 / "	warning: in experimental tests with students ..." 
		.byte 0
mcok:		 .byte 124,150,145,40,143,141,156,40,163,141,171,163,40,103,157,153,145,56 / "the can says coke." 
		.byte 0
msev:		 .byte 124,150,145,40,163,145,166,145,156,40,145,154,145,166,145,156,40,163,154,165,162,160,151,145,40,150,141,163,40,156,157,164,150,151,156,147,40,157,156,40,151,164,40,164,157,40,162,145,141,144,56 / "the seven eleven slurpie has nothing on it to read." 
		.byte 0
mchp:		 .byte 124,150,145,40,114,123,111,40,143,150,151,160,40,150,141,163,40,160,162,151,156,164,145,144,40,157,156,40,151,164,72,40,132,151,154,157,147,40,132,70,60,103,120,125 / "the lsi chip has printed on it: zilog z80cpu" 
		.byte 0
mbrd:		 .byte 124,150,145,40,114,123,111,40,143,150,151,160,40,150,141,163,40,132,151,154,157,147,40,160,162,151,156,164,145,144,40,157,156,40,151,164,56 / "the lsi chip has zilog printed on it." 
		.byte 0
mprt:		 .byte 120,141,162,164,40,157,146,40,164,150,145,40,160,162,151,156,164,40,157,165,164,40,162,145,141,144,163,40,141,163,40,146,157,154,154,157,167,163,72 / "part of the print out reads as follows:"
		.byte 12
		 .byte 124,150,145,40,166,141,170,40,143,141,156,40,157,156,154,171,40,142,145,40,122,105,102,117,117,124,145,144,40,142,171,40,162,157,157,164,56,40,122,157,157,164,163,40,160,141,163,163,167,157,162,144 / "the vax can only be rebooted by root. roots password"
		.byte 12
		 .byte 151,163,40,43,43,43,43,43,43,43,43,43,43,56 / "is $$$$$$$$$$."
		.byte 12
		 .byte 124,150,145,40,43,43,43,40,164,145,170,164,40,151,163,40,163,143,162,141,164,143,150,145,144,40,157,146,146,56 / "the $$$ text is scratched off." 
		.byte 0
mfma:		 .byte 156,157,156,55,144,157,163,40,144,151,163,153,56,40,105,162,162,157,162,40,162,145,141,144,151,156,147,40,144,151,163,153,56,40,127,141,156,164,40,164,157,40,146,157,162,155,141,164,40,151,164,77 / "non-dos disk. error reading disk. want to format it?" 
		.byte 0
mrs2:		 .byte 124,150,145,40,143,141,142,154,145,40,163,141,171,163,40,47,101,115,120,47,40,157,156,40,164,150,145,40,163,151,144,145,56 / "the cable says 'amp' on the side." 
		.byte 0
mamb:		 .byte 124,150,145,40,163,143,162,145,145,156,40,163,150,157,167,163,40,141,40,143,163,150,40,160,162,157,155,160,164,56 / "the screen shows a csh prompt." 
		.byte 0
msun:		 .byte 124,150,145,40,163,143,162,145,145,156,40,150,141,163,40,163,156,141,153,145,163,40,155,157,166,151,156,147,40,141,143,162,157,163,163,40,164,150,145,40,163,143,162,145,145,156,56 / "the screen has snakes moving across the screen." 
		.byte 0
mv52:		 .byte 124,150,145,40,163,143,162,145,145,156,40,150,141,163,40,141,40,154,157,147,151,156,40,142,141,156,156,145,162,72 / "the screen has a login banner:"
		.byte 12,12
		 .byte 125,156,151,166,145,162,163,151,164,171,40,157,146,40,103,141,154,147,141,162,171,40,40,64,56,62,40,102,123,104,40,125,156,151,170,40,40,40,40,133,166,141,170,144,51 / "university of calgary  4.2 bsd unix    [vaxd)"
		.byte 12,12
		 .byte 154,157,147,151,156,72 / "login:" 
		.byte 0
mv50:		 .byte 131,157,165,40,163,145,145,40,141,156,40,162,167,150,157,40,157,146,40,164,150,145,40,166,141,170,47,163,56 / "you see an rwho of the vax's."
		.byte 12
		 .byte 111,164,40,144,157,145,163,40,156,157,164,40,141,160,160,145,141,162,40,141,163,40,164,150,157,165,147,150,40,144,141,166,145,40,151,163,40,154,157,147,147,145,144,40,151,156,56 / "it does not appear as though dave is logged in." 
		.byte 0
mins:		 .byte 131,157,165,40,143,141,156,156,157,164,40,162,145,141,144,40,164,150,145,40,151,156,163,141,156,145,40,150,141,143,153,145,162,56 / "you cannot read the insane hacker." 
		.byte 0
msys:		 .byte 131,157,165,40,143,141,156,156,157,164,40,162,145,141,144,40,164,150,145,40,163,165,160,145,162,40,165,163,145,162,56 / "you cannot read the super user." 
		.byte 0
mman:		 .byte 101,40,163,151,147,156,40,157,156,40,164,150,145,40,163,151,144,145,40,157,146,40,164,150,145,40,166,141,170,40,162,145,141,144,163,72 / "a sign on the side of the vax reads:"
		.byte 12
		 .byte 40,40,40,126,101,130,40,61,61,57,67,70,60,40,157,160,145,162,141,164,151,156,147,40,165,156,144,145,162,40,64,56,62,40,102,123,104,40,125,156,151,170 / "   vax 11/780 operating under 4.2 bsd unix" 
		.byte 0
		.even

cask:		mov	r0,-(sp)
		mov	r1,-(sp)
		mov	r2,-(sp)
		jsr	pc,prcr
		mov	secwrd,r0
		mov	$key,r1
		jsr	pc,comand
		cmp	r0,$00
		beq	asknfe
		mov	r0,r2
		dec	r2
		asl	r2
		asl	r2
		add	$obtable,r2
		cmp	(r2),$001
		bne	askt2
		br	asksk7
askt2:		cmp	(r2),r4
		bne	askdoe
asksk7:		cmp	r4,objhak
		beq	askhak
askret:		dec	r0
		asl	r0
		add	$asktbl,r0
		mov	(r0),r1
		jmp	askend
asknfe:		mov	$askm4,r1
		jmp	askend
askdoe:		mov	$askm1,r1
		jmp	askend
askhak:		cmp	objcon,$001
		beq	askcon
		mov	$askm2,askins
		jmp	askret
askcon:		mov	$002,objcon
		mov	$askm3,askins
		jmp	askret
askend:		jsr	pc,prez
		jsr	pc,prcr
		mov	(sp)+,r2
		mov	(sp)+,r1
		mov	(sp)+,r0
		jmp	getcom
askm4:		 .byte 111,40,144,157,156,47,164,40,153,156,157,167,40,150,157,167,40,164,157,40,141,163,153,40,164,150,141,164,40,164,150,151,156,147,41 / "i don't know how to ask that thing!" 
		.byte 0
askm1:		 .byte 116,157,164,40,150,145,162,145,40,164,157,40,141,163,153,56 / "not here to ask." 
		.byte 0
askm2:		 .byte 124,150,145,40,160,162,157,146,146,145,163,157,162,40,163,141,171,163,72 / "the proffesor says:"
		.byte 12
		 .byte 40,40,40,40,47,107,157,157,144,40,150,145,154,160,40,151,163,40,150,141,162,144,40,164,157,40,146,151,156,144,56,40,111,164,40,151,163,40,145,166,145,156,40,167,157,162,164,150 / "    'good help is hard to find. it is even worth"
		.byte 12
		 .byte 40,40,40,40,160,141,171,151,156,147,40,146,157,162,56,56,56,47 / "    paying for...'"
		.byte 12,00
askm3:		 .byte 124,150,145,40,150,141,160,160,171,40,160,162,157,146,146,145,163,157,162,40,164,141,153,145,163,40,171,157,165,162,40,143,157,151,156,54,40,163,155,151,154,145,163,40,141,156,144,40,163,141,171,163,72 / "the happy proffesor takes your coin, smiles and says:"
		.byte 12
		 .byte 40,40,40,40,47,123,165,160,145,162,40,165,163,145,162,163,40,144,157,156,47,164,40,141,154,154,157,167,40,146,157,157,144,40,157,162,40,104,122,111,116,113,40,151,156,40,164,150,145 / "    'super users don't allow food or drink in the"
		.byte 12
		 .byte 40,40,40,40,40,164,145,162,155,151,156,141,154,40,162,157,157,155,163,56,56,56,47 / "     terminal rooms...'"
		.byte 12,00
		.even
asktbl:		akey
		apsw
		apas
		acoin
		apdp
		amat
		ajlt
		acok
		asev
		achp
		abrd
		aprt
		afma
		ars2
		aamb
		asun
		av52
		av50
		ains
		asys
		aman
askins:		ahak
akey:		 .byte 111,40,142,145,154,157,156,147,40,164,157,40,144,141,166,145,56 / "i belong to dave." 
		.byte 0
aprt:
afma:
apsw:		 .byte 162,145,141,144,40,155,145,41 / "read me!" 
		.byte 0
acoin:		 .byte 163,160,145,156,144,40,155,145,41 / "spend me!" 
		.byte 0
amat:
apas:
apdp:		 .byte 124,150,145,40,142,157,157,153,40,144,157,145,163,40,156,157,164,40,162,145,160,154,171,56 / "the book does not reply." 
		.byte 0
asev:
acok:
ajlt:		 .byte 104,162,151,156,153,40,155,145,41 / "drink me!" 
		.byte 0
achp:		 .byte 154,144,40,141,54,64,65,73,40,152,162,156,172,40,63,64,60,60,73,40,157,165,164,40,146,61,54,141,73,40,154,144,40,110,114,54,102,103,73,40,56,56,56,56 / "ld a,45; jrnz 3400; out f1,a; ld hl,bc; ...." 
		.byte 0
ars2:
abrd:		 .byte 61,60,61,61,61,60,61,60,61,60,60,60,61,60,61,60,61,60,61,61,61,60,61,60 / "101110101000101010111010" 
		.byte 0
aamb:
asun:
av52:
av50:		 .byte 124,150,145,40,164,145,162,155,151,156,141,154,40,143,141,156,40,157,156,154,171,40,162,145,160,154,171,40,55,143,154,151,143,153,55,143,154,151,143,153,55,142,145,145,160,41 / "the terminal can only reply -click-click-beep!" 
		.byte 0
aman:		 .byte 111,155,40,151,156,163,141,156,145,56 / "im insane." 
		.byte 0
ains:		 .byte 124,150,145,40,151,156,163,141,156,145,40,150,141,143,153,145,162,40,155,165,155,142,154,145,163,72 / "the insane hacker mumbles:"
		.byte 12
		 .byte 40,40,40,40,47,104,141,166,145,40,153,145,145,160,163,40,141,40,153,145,171,40,164,157,40,164,150,145,40,155,141,143,150,151,156,145,40,162,157,157,155 / "    'dave keeps a key to the machine room"
		.byte 12
		 .byte 40,40,40,40,151,156,40,150,151,163,40,157,146,146,151,143,145,56,47 / "    in his office.'" 
		.byte 0
asys:		 .byte 124,150,145,40,163,165,160,145,162,40,165,163,145,162,40,145,170,154,141,151,155,163,72 / "the super user exlaims:"
		.byte 12
		 .byte 40,40,40,47,110,151,54,40,111,155,40,160,162,145,166,145,156,164,151,156,147,40,171,157,165,40,146,162,157,155,40,145,156,164,145,162,151,156,147,41,47 / "   'hi, im preventing you from entering!'" 
		.byte 0
ahak:		.byte 12,00
		.even


cscore:		clr	scrpts
		mov	$obtable,r0
		mov	$scoretb,r1
sclop:		cmp	(r0),$00
		beq	scend
		cmp	(r0),$01
		bne	scskp
		add	(r1),scrpts
scskp:		add	$4,r0
		add	$2,r1
		br	sclop
scend:		mov	$scmsg1,r1
		jsr	pc,prez
		mov	scrpts,r1
		jsr	pc,proct
		jsr	pc,prcr
		jmp	getcom
scmsg1:		 .byte 131,157,165,162,40,144,145,143,151,155,141,154,40,163,143,157,162,145,40,151,163,72,40 / "your decimal score is: " 
		.byte 0
		.even
scoretb:	200.; 200.; 45.; 47.; 48.; 120.; 55.; 65.; 75.
			50.; 101.; 51.; 56; 0; 0; 0; 0; 0; 0; 0; 0

cnorth:
csouth:
ceast:
cwest:
		mov	$buffer,secwrd
		jmp	cgo

cwait:		mov	r1,-(sp)
		mov	$temp21,r1
		jsr	pc,prez
		jsr	pc,prcr
		jsr	pc,movstf
		mov	(sp)+,r1
		jmp	getcom
temp21:		 .byte 56,56,56,56,40,124,151,155,145,40,120,141,163,163,145,163,40,56,56,56,56 / ".... time passes ...." 
		.byte 0

notimp:		mov	r1,-(sp)
		mov	$temp5,r1
		jsr	pc,prez
		jsr	pc,prcr
		mov	(sp)+,r1
		jmp 	getcom
temp5:		 .byte 124,150,141,164,40,143,157,155,155,141,156,144,40,144,157,145,163,40,156,157,164,40,157,160,145,162,141,164,145,40,171,145,164,56 / "that command does not operate yet." 
		.byte 0
		.even

runtbl:		cget
		cnorth
		csouth
		ceast
		cwest
		cget			/ctake
		cput			/cdrop
		cput
		clook
		chelp
		cinv
		clogin
		cdrink
		cread
		cquit
		cgo			/cmove
		cwait
		cuse
		ceat
		clogout
		creboot
		cscore
		cgo
		cask

//////////////////////////////////////////////////////////////////////

/-----------------------------------------------------------------------------/
/ command decoder in pdp-11, searches a command table pointed to by r1, for a /
/ command pointed to by r0.						      /
/ the table consists of null-teriminated ascii strings, with two nulls	      /
/ indicating the end of the table.					      /
/ the command to find is a null-terminated string.			      /
/ the command is decoded to a number in r0, with a zero indicating that the   /
/ command was not found.						      /
/-----------------------------------------------------------------------------/

comand:	mov r0,comandx
	mov r1,table
	mov r2,-(sp)
	mov r3,-(sp)
	mov r4,-(sp)
	mov r5,-(sp)

	mov $1,r5	/command counter = 1 ie. command $1

findme:	movb (r1),r2	/get byte from table
	bic $177400,r2	/clear high bits
	beq nofind	/end of table, command not found
	jsr pc,check	/check for command in table
	cmp r4,$1	/was it a match?
	beq find	/ yes -- exit with command # in r0
	jsr pc,skip	/skip to next entry in command table
	inc r5		/next message
	jmp findme	/continue to search for a match

skip:	movb (r1),r2	/
	inc r1		/this will move r1 to point to the next entry in
	bic $177400,r2	/the command table.
	bne skip	/
	rts pc		/

check:	clr r4		/clear match flag, 0=no match, 1=match
	mov comandx,r0	/set pointer to start of command
scan:	movb (r1),r2	/get byte from table
	bic $177400,r2	/clear high bits
	beq endchk	/end of command in table, ie. no match
	movb (r0),r3	/get byte from command
	bic $177400,r3	/clear high bits
	beq endchk	/end of command
	cmp r2,r3	/are they the same?
	beq yes		/ yes -- put a 1 in r4
no:	clr r4		/put a 0 in r4, ie. no match
	jmp endchk	/did not match, no need to check the remaining chars.
yes:	mov $1,r4	/put a 1 in r4 ie. match
	inc r1
	inc r0
	jmp scan	/continue scaning
endchk:	rts pc		/return

nofind:	clr r0		/no match
	jmp quit	/done
find:	mov r5,r0	/put command # into r0
quit:	mov (sp)+,r5
	mov (sp)+,r4
	mov (sp)+,r3
	mov (sp)+,r2
	mov table,r1
	rts pc

			/print a variable length string of text terminated
			/with a null byte.
			/entry:
			/	r1 -- contains start address of sting to print
			/exit:
			/	all registers preserved, cc undefined.

prez:	mov r0,-(sp)
	mov r2,-(sp)
	mov r1,buff
	clr r2		/zero counter
byte:	movb (r1),r0	/get byte.
	beq quitxx	/null? exit if so...
	inc r2		/count it
	inc r1		/point to next
	bic $177400,r0	/mask off high-byte of r0
	jmp byte	/loop back
quitxx:	mov r2,len
	jsr pc,printxx
	mov buff,r1
	mov (sp)+,r2
	mov (sp)+,r0
	rts pc
printxx:
/// new4 ///////////////////////////////////////////////////////////////////
		mov	len,-(sp)		// kjs added '-'
		mov	*$buff,-(sp)
		mov	$1,-(sp)		/ stdout
		jsr	pc,*$_write
		cmp	(sp)+,(sp)+
		tst (sp)+			// kjs added this instructon
//////////////////////////////////////////////////////////////////////

/// old4 ///////////////////////////////////////////////////////////////////
/	mov $1,r0
/	trap 4
/buff:	0
/len:	0
//////////////////////////////////////////////////////////////////////
	rts pc

		.even
proct:		mov	r1,-(sp)		/r1 contains value.
		mov	r2,-(sp)
		mov	r0,-(sp)

		mov	$lsdig+2,r2		/r2 points to ascii.

		tst	r1			/is value negative?
		bpl	loop			/if not exit.
		mov	$'-,sign		/else put minus sign.
		neg	r1			/get absolute value of r1

loop:		clr	r0			/upper half of divisor.
		div	$10.,r0		/divide value by 10
		add	r1,-(r2)		/put remainder in string.
		mov	r0,r1			/reinitialize divisor.
		cmp	r1,$00			/done yet?
		bne	loop			/if not continue...

/// new4 ///////////////////////////////////////////////////////////////////
		mov	$14.,(sp)
		mov	$sign,-(sp)
		mov	$1,-(sp)		/ stdout
		jsr	pc,*$_write
		cmp	(sp)+,(sp)+
//////////////////////////////////////////////////////////////////////

/// old4 ///////////////////////////////////////////////////////////////////
/		mov	$1,r0			/print number out.
/		trap	4
/		sign
/		14.
//////////////////////////////////////////////////////////////////////

		mov	$'0,msdig		/re-store data....
		mov	$'0,msdig+2
		mov	$'0,msdig+4
		mov	$'0,msdig+6
		mov	$'0,lsdig
		mov	$'+,sign

		mov	(sp)+,r0		/re-store registers...
		mov	(sp)+,r2
		mov	(sp)+,r1
		rts	pc

compr:		mov	r1,-(sp)
again:		cmpb	(r0),(r1)
		bne	notequ
		cmpb	(r1),$00
		beq	done
		inc	r0
		inc	r1
		br	again
done:		mov	$01,r0
		mov	(sp)+,r1
		rts	pc
notequ:		mov	$00,r0
		mov	(sp)+,r1
		rts	pc

rmtable:	 outsid
 		 rmtable
		 rmtable
		 rmtable
		 tns3
		 01 / %0001
tns1:		 ns1
		 tma134
		 tma145
		 tew1
		 tew14
		 017 / %1111
tma176:		 ma176
		 tma112
		 tew13
		 tma176
		 tma176
		 014 / %1100
tew1:		 ew1
		 tma132
		 tma142
		 tew2
		 tns1
		 017 / %1111
tma132:		 ma132
		 tma132
		 tew1
		 tma132
		 tma132
		 04 / %0100
tew2:		 ew2
		 tmens
		 twomens
		 tew3
		 tew1
		 017 / %1111
tew3:		 ew3
		 tout2
		 tns2
		 tew4
		 tew2
		 017 / %1111
tew4:		 ew4
		 tma120
		 tma119
		 tew5
		 tew3
		 017 / %1111
tew5:		 ew5
		 tma116
		 tma160
		 tew6
		 tew4
		 017 / %1111
tew6:		 ew6
		 tma114
		 tprint
		 tma112
		 tew5
		 017 / %1111
tew7:		 ew7
		 tma139
		 tma151
		 tew8
		 tma145
		 017 / %1111
tew8:		 ew8
		 tns2
		 tma153
		 tew9
		 tew7
		 017 / %1111
tew9:		 ew9
		 tma154
		 tma155
		 tew10
		 tew8
		 017 / %1111
tma154:		 ma154
		 tma154
		 tew9
		 tma154
		 tns2
		 05 / %0101
tma155:		 ma155
		 tew9
		 tma155
		 tma155
		 tma155
		 010 / %1000
tew10:		 ew10
		 tma119
		 tma161
		 tew11
		 tew9
		 017 / %1111
tma161:		 ma161
		 tew10
		 tma161
		 tma161
		 tma161
		 010 / %1000
tcommed:	 commed
		 tns3
		 tcommed
		 tcommed
		 tcommed
		 010 / %1000
tma169:		 ma169
		 tew12
		 tma169
		 tma169
		 tma169
		 010 / %1000
tma165:		 ma165
		 tew11
		 tma165
		 tma165
		 tma165
		 010 / %1000
tma153:		 ma153
		 tew8
		 tma153
		 tma153
		 tma153
		 010 / %1000
tma151:		 ma151
		 tew7
		 tma151
		 tma151
		 tma151
		 010 / %1000
tma145:		 ma145
		 tns1
		 tma145
		 tew7
		 tma145
		 012 / %1010
tma112:		 ma112
		 tma112
		 tma176
		 tns3
		 tew6
		 07 / %0111
tma160:		 ma160
		 tew5
		 tew11
		 tma160
		 tma160
		 014 / %1100
tma119:		 ma119
		 tew4
		 tew10
		 tma119
		 tma119
		 014 / %1100
tprint:		 printstr
		 tew6
		 tprint
		 tprint
		 tprint
		 010 / %1000
tma174:		 ma174
		 tma174
		 tew12
		 tma174
		 tma174
		 04 / %0100
tma139:		 ma139
		 tma139
		 tew7
		 tma139
		 tma139
		 04 / %0100
tns2:		 ns2
		 tew3
		 tew8
		 tma154
		 tns2
		 016 / %1110
tns3:		 ns3
		 tns3
		 tcommed
		 rmtable
		 tew13
		 07 / %0111
tma114:		 ma114
		 tma114
		 tew6
		 tma114
		 tma114
		 04 / %0100
tma116:		 ma116
		 tma116
		 tew5
		 tma116
		 tma116
		 04 / %0100
tma134:		 ma134
		 tma134
		 tns1
		 tma134
		 tma134
		 04 / %0100
tma120:		 ma120
		 tma120
		 tew4
		 tma120
		 tma120
		 04 / %0100
tmens:		 mens
		 tmens
		 tew2
		 tmens
		 tstall
		 05 / %0101
tstall:		stall
		twomens
		tstall
		tmens
		tstall
		012 / %1010
tma136:		ma136
		tma136
		tew14
		tma136
		tma136
		04 / %0100
tma142:		ma142
		tew1
		tma142
		tma142
		tma142
		010 / %1000
tstore:		store
		tew13
		tstore
		tstore
		tstore
		010 / %1000
tew14:		ew14
		tma136
		tew14
		tns1
		tew14
		012 / %1010
tout2:		out2
		tout2
		tew3
		tout2
		tout2
		04 / %0100
tew13:		ew13
		tma176
		tstore
		tns3
		tew12
		017 / %1111
tew12:		ew12
		tma174
		tma169
		tew13
		tew11
		017 / %1111
tew11:		ew11
		tma160
		tma165
		tew12
		tew10
		017 / %1111
twomens:	womans
		tew2
		tstall
		twomens
		twomens
		014 / %1100



obtable:	tma153
		key

objpsw:		tma174
		psw

		tma112
		pas

objcon:		tma136
		coin

		tma176
		pdp

		rmtable
		mat

objjlt:		tew12
		jltss

objcok:		tma145
		cok

objsev:		tew7
		sevxx

		tma120
		chp

		tma120
		brd

		tprint
		prt

		tma142
		fma

		tma165
		rs2

		tma114
		amb			/permanent objects....

		tma119
		sun

		tma160
		v52

		tma116
		v50

objins:		tns2
		ins

objsup:		tew8
		sysxx

		tma174
		man

objhak:		tmens
		hak

outsid:		 .byte 131,157,165,40,141,162,145,40,157,165,164,163,151,144,145,40,164,150,145,40,103,120,123,103,40,146,154,157,157,162,56,40,124,157,40,145,156,164,145,162,40,164,150,145 / "you are outside the cpsc floor. to enter the"
		.byte 12
		 .byte 164,145,162,155,151,156,141,154,40,162,157,157,155,163,54,40,147,157,40,167,145,163,164,56 / "terminal rooms, go west."
		.byte 12,00
ns1:		 .byte 131,157,165,40,141,162,145,40,151,156,40,141,40,156,157,162,164,150,55,163,157,165,164,150,40,150,141,154,154,167,141,171,54,40,164,157,40,164,150,145,40,167,145,163,164 / "you are in a north-south hallway, to the west"
		.byte 12
		 .byte 154,145,141,144,163,40,164,157,40,164,150,145,40,103,123,125,123,40,157,146,146,151,143,145,56 / "leads to the csus office."
		.byte 12,00
ma176:		 .byte 124,150,151,163,40,151,163,40,164,150,145,40,126,101,130,103,40,164,145,162,155,151,156,141,154,40,162,157,157,155,56,40,124,150,145,162,145,40,151,163,40,141,156,40,145,170,151,164 / "this is the vaxc terminal room. there is an exit"
		.byte 12
		 .byte 164,157,40,164,150,145,40,156,157,162,164,150,40,141,156,144,40,163,157,165,164,150,56,40,124,150,145,162,145,40,141,162,145,40,162,157,167,163,40,157,146,40,126,124,61,60,62,47,163,40,150,145,162,145,56 / "to the north and south. there are rows of vt102's here."
		.byte 12,00
stall:		 .byte 131,157,165,40,141,162,145,40,156,157,167,40,151,156,40,164,150,145,40,163,151,164,55,144,157,167,156,40,165,162,151,156,141,154,56,40,101,156,40,165,156,160,154,145,141,163,141,156,164 / "you are now in the sit-down urinal. an unpleasant"
		.byte 12
		 .byte 157,144,157,162,40,151,163,40,160,162,145,163,145,156,164,56,40,127,150,141,164,40,156,157,167,77 / "odor is present. what now?"
		.byte 12,00
ma136:		 .byte 124,150,151,163,40,151,163,40,164,150,145,40,103,123,125,123,40,157,146,146,151,143,145,56,40,116,157,164,151,143,145,40,164,150,145,40,141,162,164,167,157,162,153,56,40,101 / "this is the csus office. notice the artwork. a"
		.byte 12
		 .byte 144,157,157,162,167,141,171,40,157,165,164,40,154,145,141,144,163,40,164,157,40,164,150,145,40,163,157,165,164,150,56 / "doorway out leads to the south."
		.byte 12,00
ew1:		 .byte 131,157,165,40,141,162,145,40,141,164,40,164,150,145,40,145,156,144,40,157,146,40,141,40,154,157,156,147,40,145,141,163,164,55,167,145,163,164,40,150,141,154,154,167,141,171,56 / "you are at the end of a long east-west hallway."
		.byte 12
		 .byte 101,156,40,157,160,145,156,151,156,147,40,164,157,40,164,150,145,40,156,157,162,164,150,40,154,145,141,144,163,40,164,157,40,141,40,163,155,141,154,154,40,162,157,157,155,56,40,124,157,40,164,150,145 / "an opening to the north leads to a small room. to the"
		.byte 12
		 .byte 163,157,165,164,150,40,151,163,40,141,40,163,154,151,147,150,164,154,171,40,154,141,162,147,145,40,162,157,157,155,56 / "south is a slightly large room."
		.byte 12,00

ew12:		 .byte 124,150,151,163,40,151,163,40,160,141,162,164,40,157,146,40,141,40,154,157,156,147,40,145,141,163,164,55,167,145,163,164,40,150,141,154,154,167,141,171,56,40,131,157,165,40,143,141,156,40,150,145,141,162 / "this is part of a long east-west hallway. you can hear"
		.byte 12
		 .byte 154,157,165,144,40,162,165,155,142,154,151,156,147,40,156,157,151,163,145,40,164,157,40,164,150,145,40,156,157,162,164,150,56 / "loud rumbling noise to the north."
		.byte 12,00

ew6:		 .byte 131,157,165,40,141,162,145,40,151,156,40,141,40,150,141,154,154,167,141,171,40,152,165,163,164,40,157,165,164,163,151,144,145,40,164,150,145,40,164,165,164,157,162,151,141,154,40,162,157,157,155,56,40,124,157,40,164,150,145 / "you are in a hallway just outside the tutorial room. to the"
		.byte 12
		 .byte 163,157,165,164,150,40,171,157,165,40,143,141,156,40,150,145,162,145,40,141,40,143,150,141,164,164,145,162,151,156,147,40,163,157,165,156,144,56 / "south you can here a chattering sound."
		.byte 12,00
ew11:
ew10:
ew5:
ew2:		 .byte 131,157,165,40,141,162,145,40,151,156,40,160,141,162,164,40,157,146,40,141,40,154,157,156,147,40,145,141,163,164,55,167,145,163,164,40,150,141,154,154,167,141,171,56,40,105,170,151,164,163,40,154,145,141,144 / "you are in part of a long east-west hallway. exits lead"
		.byte 12
		 .byte 156,157,162,164,150,40,141,156,144,40,163,157,165,164,150,56 / "north and south."
		.byte 12,00
ew3:		 .byte 131,157,165,40,141,162,145,40,151,156,40,141,156,40,157,160,145,156,40,150,141,154,154,167,141,171,54,40,167,151,164,150,40,145,154,145,166,141,164,157,162,163,40,164,157,40,164,150,145,40,163,157,165,164,150 / "you are in an open hallway, with elevators to the south"
		.byte 12
		 .byte 124,150,145,162,145,40,141,162,145,40,147,154,141,163,163,40,144,157,157,162,163,40,164,157,40,145,141,163,164,56,40,116,157,162,164,150,40,154,145,141,144,163,40,157,165,164,56 / "there are glass doors to east. north leads out."
		.byte 12,00
ew4:		 .byte 131,157,165,40,141,162,145,40,151,156,40,141,40,105,141,163,164,55,127,145,163,164,40,150,141,154,154,167,141,171,54,40,167,151,164,150,40,147,154,141,163,163,40,144,157,157,162,163,40,164,157,40,164,150,145,40,167,145,163,164,56 / "you are in a east-west hallway, with glass doors to the west."
		.byte 12
		 .byte 120,141,163,163,141,147,145,163,40,147,157,40,156,157,162,164,150,40,141,156,144,40,163,157,165,164,150,56 / "passages go north and south."
		.byte 12,00
commed:		 .byte 124,150,151,163,40,151,163,40,164,150,145,40,143,157,155,155,55,155,145,144,151,141,40,162,157,157,155,56,40,101,40,163,151,156,147,154,145,40,145,170,151,164,40,147,157,145,163,40,156,157,162,164,150,56 / "this is the comm-media room. a single exit goes north."
		.byte 12,00
ma169:		 .byte 131,157,165,40,141,162,145,40,151,156,40,164,150,145,40,141,144,166,141,156,143,145,144,40,147,162,141,160,150,151,143,163,40,154,141,142,56,40,124,150,145,162,145,40,151,163,40,141,40,163,151,156,147,154,145,40,165,156,55,167,141,164,143,150,145,144 / "you are in the advanced graphics lab. there is a single un-watched"
		.byte 12
		 .byte 151,162,151,163,40,164,145,162,155,151,141,154,40,150,145,162,145,56,40,117,164,150,145,162,40,164,145,162,155,151,156,151,141,154,163,40,141,162,145,40,144,157,151,156,147,40,162,141,171,55,164,141,143,151,156,147,40,163,164,165,146,146,56 / "iris termial here. other terminials are doing ray-tacing stuff."
		.byte 12
		 .byte 101,156,40,145,170,151,164,40,147,157,145,163,40,156,157,162,164,150,56 / "an exit goes north."
		.byte 12,00
ma165:		 .byte 131,157,165,40,141,162,145,40,151,156,40,164,150,145,40,144,145,166,145,154,156,145,164,40,164,145,162,155,151,156,141,154,40,162,157,157,155,56,40,124,150,145,162,145,40,141,162,145 / "you are in the develnet terminal room. there are"
		.byte 12
		 .byte 163,145,166,145,162,141,154,40,164,145,162,155,151,156,141,154,163,40,150,157,157,153,145,144,40,165,160,40,164,157,40,144,145,166,145,154,145,164,40,150,145,162,145,56 / "several terminals hooked up to develet here."
		.byte 12,00
ma153:		 .byte 124,150,151,163,40,151,163,40,144,141,166,145,47,163,40,157,146,146,151,143,145,56,40,101,156,40,145,170,151,164,40,154,151,145,163,40,164,157,40,164,150,145,40,116,157,162,164,150,56 / "this is dave's office. an exit lies to the north."
		.byte 12
		 .byte 124,150,145,162,145,40,151,163,40,141,40,154,141,162,147,145,40,164,145,162,155,151,156,141,154,40,150,145,162,145,56,40,131,157,165,40,144,157,156,47,164,40,163,145,145,40,104,141,166,145,40,163,157,40,171,157,165 / "there is a large terminal here. you don't see dave so you"
		.byte 12
		 .byte 144,157,156,47,164,40,155,151,156,144,40,163,156,157,157,160,151,156,147,56 / "don't mind snooping."
		.byte 12,00
ma151:		 .byte 124,150,151,163,40,151,163,40,113,151,145,164,150,47,163,40,141,156,144,40,124,145,162,162,171,47,163,40,157,146,146,151,143,145,56,40,101,40,160,141,163,163,141,147,145,40,154,145,141,144,163,40,156,157,162,164,150,56 / "this is kieth's and terry's office. a passage leads north."
		.byte 12,00
ma145:		 .byte 131,157,165,40,141,162,145,40,151,156,40,164,150,145,40,103,123,125,123,40,154,157,165,156,147,145,56,40,101,40,103,157,153,145,40,155,141,143,150,151,156,145,40,141,164,164,162,141,143,164,163,40,171,157,165,40,141,164,164,145,156,164,151,157,156,56 / "you are in the csus lounge. a coke machine attracts you attention."
		.byte 12
		 .byte 131,157,165,40,156,157,164,151,143,145,40,141,156,40,145,170,151,164,40,156,157,162,164,150,40,141,156,144,40,145,141,163,164,56 / "you notice an exit north and east."
		.byte 12,00
ew7:		 .byte 131,157,165,40,141,162,145,40,141,164,40,164,150,145,40,145,156,144,40,157,146,40,141,40,147,162,145,141,164,40,145,141,163,164,55,167,145,163,164,40,150,141,154,154,167,141,171,56,40,124,157,40,164,150,145 / "you are at the end of a great east-west hallway. to the"
		.byte 12
		 .byte 156,157,162,164,150,40,151,163,40,141,40,163,155,141,154,154,40,164,145,162,155,151,156,141,154,40,162,157,157,155,56 / "north is a small terminal room."
		.byte 12,00
ma174:		 .byte 131,157,165,40,141,162,145,40,151,156,40,164,150,145,40,155,141,143,150,151,156,145,40,162,157,157,155,56,40,124,150,145,40,166,141,170,47,163,40,141,162,145,40,141,154,154,40,150,145,162,145,56 / "you are in the machine room. the vax's are all here."
		.byte 12
		 .byte 124,150,145,40,154,157,165,144,40,162,165,155,142,154,145,40,157,146,40,155,141,143,150,151,156,145,162,171,40,143,141,156,40,142,145,40,150,145,141,162,144,56 / "the loud rumble of machinery can be heard."
		.byte 12
		 .byte 101,40,154,141,162,147,145,40,151,162,157,156,40,144,157,157,162,40,151,163,40,157,156,40,164,150,145,40,163,157,165,164,150,40,167,141,154,154,56 / "a large iron door is on the south wall."
		.byte 12,00
printstr:		 .byte 131,157,165,40,141,162,145,40,151,156,40,141,40,163,155,141,154,154,40,162,157,157,155,40,167,151,164,150,40,141,40,160,162,151,156,164,145,162,40,150,145,162,145,56,40,111,164,40,151,163 / "you are in a small room with a printer here. it is"
		.byte 12
		 .byte 146,141,151,164,150,146,165,154,154,171,40,160,162,151,156,164,151,156,147,40,141,167,141,171,56,40,101,40,163,155,141,154,154,40,144,157,157,162,40,151,163,40,157,156,40,164,150,145,40,156,157,162,164,150,40,167,141,154,154,56 / "faithfully printing away. a small door is on the north wall."
		.byte 12,00
ma160:		 .byte 124,150,151,163,40,151,163,40,164,150,145,40,126,101,130,104,40,164,145,162,155,151,156,141,154,40,162,157,157,155,56,40,124,157,40,164,150,145,40,156,157,162,164,150,40,151,163,40,141,156,40,145,170,151,164,56 / "this is the vaxd terminal room. to the north is an exit."
		.byte 12
		 .byte 124,150,145,162,145,40,151,163,40,141,156,40,145,170,151,164,40,163,157,165,164,150,56,40,124,150,145,162,145,40,141,162,145,40,172,70,60,40,144,145,163,151,147,156,163,40,157,156,40,164,150,145,40,143,150,141,154,153 / "there is an exit south. there are z80 designs on the chalk"
		.byte 12
		 .byte 142,157,141,162,144,56 / "board."
		.byte 12,00
ma119:		 .byte 131,157,165,40,141,162,145,40,151,156,40,164,150,145,40,163,165,156,40,164,145,162,155,151,156,141,154,40,162,157,157,155,56,40,123,157,155,145,157,156,145,40,150,141,163,40,146,157,162,147,157,164 / "you are in the sun terminal room. someone has forgot"
		.byte 12
		 .byte 164,157,40,154,157,147,157,165,164,56,40,124,150,145,162,145,40,151,163,40,141,156,40,145,170,151,164,40,156,157,162,164,150,40,141,156,144,40,163,157,165,164,150,56 / "to logout. there is an exit north and south."
		.byte 12,00
ns2:		 .byte 124,150,151,163,40,151,163,40,164,150,145,40,156,157,162,164,150,55,163,157,165,164,150,40,150,141,154,154,167,141,171,56,40,124,157,40,164,150,145,40,145,141,163,164,40,151,163,40,141 / "this is the north-south hallway. to the east is a"
		.byte 12
		 .byte 105,154,145,143,164,162,157,156,151,143,163,40,154,141,142,56 / "electronics lab."
		.byte 12,00
ma139:		 .byte 124,150,151,163,40,151,163,40,164,150,145,40,123,171,163,164,145,155,163,40,154,141,142,56,40,131,157,165,40,163,145,145,40,164,145,162,155,151,156,141,154,163,54,154,141,162,147,145,40,163,143,162,145,145,156,163,54 / "this is the systems lab. you see terminals,large screens,"
		.byte 12
		 .byte 141,156,144,40,155,151,143,145,40,157,165,162,40,145,166,145,162,171,167,150,145,162,145,56 / "and mice our everywhere."
		.byte 12,00
ns3:		 .byte 124,150,151,163,40,151,163,40,141,40,163,155,141,154,154,40,156,157,162,164,150,55,163,157,165,164,150,40,150,141,154,154,167,141,171,56,40,124,157,40,164,150,145,40,156,157,162,164,150,40,141,162,145,40,163,157,155,145 / "this is a small north-south hallway. to the north are some"
		.byte 12
		 .byte 154,157,143,153,145,144,40,147,154,141,163,163,40,144,157,157,162,163,56,40,101,156,40,157,160,145,156,151,156,147,40,164,157,40,164,150,145,40,145,141,163,164,40,154,145,141,144,163,40,157,165,164,163,151,144,145,56 / "locked glass doors. an opening to the east leads outside."
		.byte 12,00
ew13:		 .byte 124,150,151,163,40,151,163,40,164,150,145,40,163,164,141,162,164,40,157,146,40,141,40,154,157,156,147,40,145,141,163,164,55,167,145,163,164,40,150,141,154,154,167,141,171,56,40,124,157,40,164,150,145,40,167,145,163,164 / "this is the start of a long east-west hallway. to the west"
		.byte 12
		 .byte 141,162,145,40,163,157,155,145,40,147,154,141,163,163,40,144,157,157,162,163,56,40,124,157,40,164,150,145,40,156,157,162,164,150,40,151,163,40,141,40,154,141,162,147,145,40,164,145,162,155,151,156,141,154,40,162,157,157,155,56 / "are some glass doors. to the north is a large terminal room."
		.byte 12,00

ew8:		 .byte 124,150,151,163,40,151,163,40,160,141,162,164,40,157,146,40,141,40,154,157,156,147,40,145,141,163,164,55,167,145,163,164,40,150,141,154,154,167,141,171,54,40,167,151,164,150,40,141 / "this is part of a long east-west hallway, with a"
		.byte 12
		 .byte 154,141,162,147,145,40,144,157,157,162,40,164,157,40,164,150,145,40,163,157,165,164,150,56,40,124,150,145,40,163,151,147,156,40,157,156,40,164,150,145,40,144,157,157,162,40,163,141,171,163,40,47,104,101,126,105,47,56 / "large door to the south. the sign on the door says 'dave'."
		.byte 12,00
ew9:		 .byte 124,150,151,163,40,151,163,40,160,141,162,164,40,157,146,40,141,40,154,157,156,147,40,145,141,163,164,55,167,145,163,164,40,150,141,154,154,167,141,171,56 / "this is part of a long east-west hallway."
		.byte 12,00
ma112:		 .byte 131,157,165,40,141,162,145,40,151,156,40,141,40,150,165,147,145,40,164,145,162,155,151,156,141,154,40,162,157,157,155,56,40,50,166,141,170,141,51 / "you are in a huge terminal room. (vaxa)"
		.byte 12
		 .byte 123,150,150,150,54,40,163,157,155,145,40,62,61,61,47,145,162,163,40,141,162,145,40,163,154,145,145,160,151,156,147,40,150,145,162,145,56,40,105,170,151,164,163,40,147,157,40,163,157,165,164,150 / "shhh, some 211'ers are sleeping here. exits go south"
		.byte 12
		 .byte 145,141,163,164,40,141,156,144,40,167,145,163,164,56 / "east and west."
		.byte 12,00
ma114:		 .byte 131,157,165,40,141,162,145,40,151,156,40,164,150,145,40,143,157,156,164,151,156,157,165,163,40,164,165,164,157,162,151,141,154,40,162,157,157,155,56,40,124,150,145 / "you are in the continous tutorial room. the"
		.byte 12
		 .byte 141,155,142,141,163,163,141,144,157,162,40,164,145,162,155,151,156,141,154,40,167,141,163,40,154,145,146,164,40,151,156,40,143,163,150,56,40,101,40,163,151,156,147,154,145,40,145,170,151,164 / "ambassador terminal was left in csh. a single exit"
		.byte 12
		 .byte 147,157,145,163,40,163,157,165,164,150,56 / "goes south."
		.byte 12,00
ma116:		 .byte 131,157,165,40,150,141,166,145,40,145,156,164,145,162,145,144,40,151,156,164,157,40,164,150,145,40,147,162,141,160,150,151,143,163,40,164,145,162,155,151,156,141,154,40,162,157,157,155,56 / "you have entered into the graphics terminal room."
		.byte 12
		 .byte 124,157,40,164,150,145,40,163,157,165,164,150,40,151,163,40,141,156,40,145,170,151,164,56,40,101,40,126,65,65,60,40,151,163,40,144,162,141,167,151,156,147,40,163,164,165,146,146,56 / "to the south is an exit. a v550 is drawing stuff."
		.byte 12,00
ma120:		 .byte 124,150,151,163,40,151,163,40,164,150,145,40,152,165,156,151,157,162,40,154,157,147,151,143,40,154,141,142,56,40,124,150,145,162,145,40,141,162,145,40,167,151,162,145,163,40,141,156,144,40,143,150,151,160,163 / "this is the junior logic lab. there are wires and chips"
		.byte 12
		 .byte 145,166,145,162,171,167,150,145,162,145,56,40,101,40,154,141,162,147,145,40,144,157,157,162,40,151,163,40,157,156,40,164,150,145,40,163,157,165,164,150,40,167,141,154,154,56 / "everywhere. a large door is on the south wall."
		.byte 12,00
mens:		 .byte 124,150,151,163,40,151,163,40,164,150,145,40,155,145,156,47,163,40,167,141,163,150,40,162,157,157,155,56,40,124,150,145,162,145,40,151,163,40,156,157,164,150,151,156,147,40,150,145,162,145 / "this is the men's wash room. there is nothing here"
		.byte 12
		 .byte 142,165,164,40,165,162,151,156,141,154,163,56,40,127,141,163,150,40,171,157,165,162,40,150,141,156,144,163,77,40,101,40,144,157,157,162,40,151,163,40,157,156,40,164,150,145,40,163,157,165,164,150,40,167,141,154,154,56 / "but urinals. wash your hands? a door is on the south wall."
		.byte 12,00
womans:		 .byte 131,157,165,40,141,162,145,40,151,156,40,164,150,145,40,167,157,155,145,156,47,163,40,142,141,164,150,162,157,157,155,56,40,125,156,154,151,153,145,40,164,150,145,40,155,145,156,47,163,40,142,141,164,150,162,157,157,155 / "you are in the women's bathroom. unlike the men's bathroom"
		.byte 12
		 .byte 164,150,151,163,40,162,157,157,155,40,151,163,40,163,160,157,164,154,145,163,163,154,171,40,143,154,145,141,156,56,40,101,40,144,157,157,162,40,151,163,40,157,156,40,164,150,145,40,156,157,162,164,150,40,167,141,154,154,56 / "this room is spotlessly clean. a door is on the north wall."
		.byte 12,00
ma142:		 .byte 131,157,165,40,150,141,166,145,40,145,156,164,145,162,145,144,40,164,150,145,40,115,151,143,162,157,40,103,157,155,160,165,164,145,162,40,114,141,142,56,40,122,157,167,163,40,157,146,40,66,65,60,62,40,142,141,163,145,144 / "you have entered the micro computer lab. rows of 6502 based"
		.byte 12
		 .byte 155,141,143,150,151,156,145,163,40,141,162,145,40,150,145,162,145,56,40,101,156,40,145,170,151,164,40,147,157,145,163,40,156,157,162,164,150,56 / "machines are here. an exit goes north."
		.byte 12,00
ma134:		 .byte 131,157,165,40,141,162,145,40,151,156,40,164,150,145,40,144,151,163,141,142,154,145,144,40,163,164,165,144,145,156,164,163,40,143,157,155,160,165,164,145,162,40,154,141,142,56,40,124,150,145,162,145,40,151,163 / "you are in the disabled students computer lab. there is"
		.byte 12
		 .byte 141,40,163,151,156,147,154,145,40,145,170,151,164,40,163,157,165,164,150,56 / "a single exit south."
		.byte 12,00
out2:		 .byte 131,157,165,40,150,141,166,145,40,167,141,156,144,145,162,145,144,40,157,165,164,40,151,156,164,157,40,164,150,145,40,165,156,151,166,145,162,163,151,164,171,40,143,141,155,160,165,163,56 / "you have wandered out into the university campus."
		.byte 12
		 .byte 107,157,40,163,157,165,164,150,40,164,157,40,162,145,55,145,156,164,145,162,40,164,150,145,40,103,120,123,103,40,146,154,157,157,162,56 / "go south to re-enter the cpsc floor."
		.byte 12,00
ma132:		 .byte 124,150,151,163,40,151,163,40,164,150,145,40,65,60,64,40,114,141,142,56,40,116,157,164,40,155,165,143,150,40,150,145,162,145,54,40,145,170,143,145,160,164,40,141,40,144,157,157,162,40,157,156 / "this is the 504 lab. not much here, except a door on"
		.byte 12
		 .byte 164,150,145,40,163,157,165,164,150,40,167,141,154,154,56 / "the south wall."
		.byte 12,00
ma161:		 .byte 124,150,151,163,40,151,163,40,164,150,145,40,163,145,156,151,157,162,40,154,157,147,151,143,40,154,141,142,56,40,131,157,165,40,163,145,145,40,163,164,162,141,156,147,145,40,150,141,162,144,167,141,162,145 / "this is the senior logic lab. you see strange hardware"
		.byte 12
		 .byte 143,162,145,141,164,151,157,156,163,40,150,145,162,145,56,40,101,40,144,157,157,162,40,154,145,141,144,163,40,156,157,162,164,150,56 / "creations here. a door leads north."
		.byte 12,00
ma154:		 .byte 131,157,165,40,141,162,145,40,151,156,40,164,150,145,40,105,154,145,143,164,162,157,156,151,143,163,40,114,141,142,56,40,101,40,144,157,157,162,40,154,145,141,144,163,40,167,145,163,164,56,40,124,150,145,162,145 / "you are in the electronics lab. a door leads west. there"
		.byte 12
		 .byte 151,163,40,141,156,40,145,170,151,164,40,163,157,165,164,150,56,40,124,150,145,162,145,40,151,163,40,141,40,154,157,164,40,157,146,40,163,164,165,146,146,40,150,145,162,145,56 / "is an exit south. there is a lot of stuff here."
		.byte 12,00
ew14:		 .byte 131,157,165,40,141,162,145,40,151,156,40,141,40,163,155,141,154,154,40,143,157,162,162,151,144,157,162,40,152,165,163,164,40,157,165,164,163,151,144,145,40,164,150,145,40,103,123,125,123,40,157,146,146,151,143,145,56 / "you are in a small corridor just outside the csus office."
		.byte 12
		 .byte 101,40,150,141,154,154,167,141,171,40,147,157,145,163,40,164,157,40,164,150,145,40,145,141,163,164,56,40,124,157,40,164,150,145,40,156,157,162,164,150,40,151,163,40,164,150,145,40,157,146,146,151,143,145,56 / "a hallway goes to the east. to the north is the office."
		.byte 12,00
ma155:		 .byte 124,150,151,163,40,151,163,40,164,150,145,40,150,141,162,144,167,141,162,145,40,164,145,143,150,156,151,143,141,154,40,163,165,160,160,157,162,164,40,157,146,146,151,143,145,56,40,141 / "this is the hardware technical support office. a"
		.byte 12
		 .byte 154,141,162,147,145,40,144,157,157,162,40,151,163,40,157,156,40,164,150,145,40,156,157,162,164,150,40,167,141,154,154,56 / "large door is on the north wall."
		.byte 12,00
store:		 .byte 131,157,165,40,141,162,145,40,151,156,40,141,40,163,155,141,154,154,40,163,164,157,162,141,147,145,40,162,157,157,155,56,40,112,165,156,153,40,151,163,40,150,145,162,145,56 / "you are in a small storage room. junk is here."
		.byte 12
		 .byte 101,156,40,145,170,151,164,40,147,157,145,163,40,156,157,162,164,150,56 / "an exit goes north."
		.byte 12,00


/-------- object table -------------/
/           text		    /

key:		 .byte 153,145,171 / "key" 
		.byte 0
psw:		 .byte 160,141,163,163,167,157,162,144 / "password" 
		.byte 0
pas:		 .byte 160,141,163,143,141,154,40,164,145,170,164 / "pascal text" 
		.byte 0
coin:		 .byte 143,157,151,156 / "coin" 
		.byte 0
pdp:		 .byte 160,144,160,55,61,61,40,164,145,170,164 / "pdp-11 text" 
		.byte 0
mat:		 .byte 155,141,164,150,62,67,61,40,164,145,170,164 / "math271 text" 
		.byte 0
jltss:		 .byte 152,157,154,164 / "jolt" 
		.byte 0
cok:		 .byte 143,157,153,145 / "coke" 
		.byte 0
sevxx:		 .byte 163,145,166 / "sev" 
		.byte 0
chp:		 .byte 172,70,60,40,143,160,165 / "z80 cpu" 
		.byte 0
brd:		 .byte 144,141,162,164 / "dart" 
		.byte 0
prt:		 .byte 160,162,151,156,164,157,165,164 / "printout" 
		.byte 0
fma:		 .byte 144,151,163,153 / "disk" 
		.byte 0
rs2:		 .byte 162,163,62,63,62,40,143,141,142,154,145 / "rs232 cable" 
		.byte 0
amb:		 .byte 141,155,142,141,163,163,141,144,157,162,40,164,145,162,155,151,156,141,154 / "ambassador terminal"  
		.byte 0
sun:		 .byte 163,165,156,40,164,145,162,155,151,156,141,154 / "sun terminal" 
		.byte 0
v52:		 .byte 166,164,61,60,62,40,164,145,162,155,151,156,141,154 / "vt102 terminal" 
		.byte 0
v50:		 .byte 166,65,65,60,40,164,145,162,155,151,156,141,154 / "v550 terminal" 
		.byte 0
ins:		 .byte 151,156,163,141,156,145,40,150,141,143,153,145,162 / "insane hacker" 
		.byte 0
sysxx:		 .byte 163,165,160,145,162,40,165,163,145,162 / "super user" 
		.byte 0
man:		 .byte 166,141,170,40,61,61,57,67,70,60 / "vax 11/780" 
		.byte 0
hak:		 .byte 160,162,157,146,146,145,163,157,162 / "proffesor" 
		.byte 0
		.byte 00

/------- directions table --------
/-----      text ------

north:		 .byte 156,157,162,164,150 / "north" 
		.byte 0
south:		 .byte 163,157,165,164,150 / "south" 
		.byte 0
east:		 .byte 145,141,163,164 / "east" 
		.byte 0
west:		 .byte 167,145,163,164 / "west" 
		.byte 0
		.byte 00


/------- commands table -------
/----- text ------

get:		 .byte 147,145,164 / "get" 
		.byte 0
cnorthstr:		 .byte 156,157,162,164,150 / "north" 
		.byte 0
csouthstr:		 .byte 163,157,165,164,150 / "south" 
		.byte 0
ceaststr:		 .byte 145,141,163,164 / "east" 
		.byte 0
cweststr:		 .byte 167,145,163,164 / "west" 
		.byte 0
take:		 .byte 164,141,153,145 / "take" 
		.byte 0
drop:		 .byte 144,162,157,160 / "drop" 
		.byte 0
put:		 .byte 160,165,164 / "put" 
		.byte 0
look:		 .byte 154,157,157,153 / "look" 
		.byte 0
help:		 .byte 150,145,154,160 / "help" 
		.byte 0
inv:		 .byte 151,156,166,145,156,164,157,162,171 / "inventory" 
		.byte 0
login:		 .byte 154,157,147,151,156 / "login" 
		.byte 0
drink:		 .byte 144,162,151,156,153 / "drink" 
		.byte 0
read:		 .byte 162,145,141,144 / "read" 
		.byte 0
quitstr:		 .byte 161,165,151,164 / "quit" 
		.byte 0
move:		 .byte 155,157,166,145 / "move" 
		.byte 0
waitstr:		 .byte 167,141,151,164 / "wait" 
		.byte 0
use:		 .byte 165,163,145 / "use" 
		.byte 0
eat:		 .byte 145,141,164 / "eat" 
		.byte 0
logout:		 .byte 154,157,147,157,165,164 / "logout" 
		.byte 0
reboot:		 .byte 162,145,142,157,157,164 / "reboot" 
		.byte 0
score:		 .byte 163,143,157,162,145 / "score" 
		.byte 0
go:		 .byte 147,157 / "go" 
		.byte 0
ask:		 .byte 141,163,153 / "ask" 
		.byte 0
		.byte 00

//////////////////////////////////////////////////////////////////////
// data section
//////////////////////////////////////////////////////////////////////
		.data

objcnt:	0



buffer:	.=.+78.		// .blkb 78.
		.byte 00

flushy:	.=.+10.		// .blkb 10.
		.even

secwrd:	.=.+2	// .blkw 1
		.even

scrpts:		0
comandx:	0
table:		0
buff:		0
len:		0
sign:		'+

msdig:		'0
			'0
			'0
			'0
lsdig:		'0
			12
		.even
