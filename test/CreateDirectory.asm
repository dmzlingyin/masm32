			.386
			.model flat,stdcall
			option casemap:none

include		windows.inc
include		user32.inc
includelib	user32.lib
include		kernel32.inc
includelib	kernel32.lib

.const
szDriver	db	'e:\dirtest',0
szAlerm	db	'sorry,the directory is exting',0

.code

main:
	invoke	CreateDirectory,offset	szDriver,NULL
	.if	eax == FALSE
		invoke	MessageBox,NULL,offset szAlerm,NULL,MB_OK
	.endif
	invoke	ExitProcess,NULL
	end		main