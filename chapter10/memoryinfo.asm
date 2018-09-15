;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
		.386
		.model flat, stdcall
		option casemap :none
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Include 文件定义
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
include		windows.inc
include		user32.inc
includelib	user32.lib
include		kernel32.inc
includelib	kernel32.lib
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Equ 等值定义
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
ICO_MAIN	equ	1000
DLG_MAIN	equ	100
IDC_INFO	equ 	101
			.data?

hInstance		dd	?
hWinMain		dd	?
			.const
szInfo		db	'物理内存总数     %lu 字节',0dh,0ah
		db	'空闲物理内存     %lu 字节',0dh,0ah
		db	'虚拟内存总数     %lu 字节',0dh,0ah
		db	'空闲虚拟内存     %lu 字节',0dh,0ah
		db	'已用内存比例     %d%%',0dh,0ah
		db	'————————————————',0dh,0ah
		db	'用户地址空间总数 %lu 字节',0dh,0ah
		db	'用户可用地址空间 %lu 字节',0dh,0ah,0
			.code

_GetMeoInfo	proc
		local	@stMemInfo:MEMORYSTATUS
		local	@szBuffer[1024]:byte

		mov	@stMemInfo.dwLength,sizeof @stMemInfo
		invoke	GlobalMemoryStatus,addr @stMemInfo
		invoke	wsprintf,addr @szBuffer,offset szInfo,@stMemInfo.dwTotalPhys,@stMemInfo.dwAvailPhys,\
			@stMemInfo.dwTotalPageFile,@stMemInfo.dwAvailPageFile,\
			@stMemInfo.dwMemoryLoad,\
			@stMemInfo.dwTotalVirtual,@stMemInfo.dwAvailVirtual
		invoke SetDlgItemText,hWinMain,IDC_INFO,addr @szBuffer
		ret

			
_GetMeoInfo	endp

_ProcDlgMain proc	uses edi esi ebx,hWnd,wMsg,wParam,lParam
			mov	eax,wMsg
			.if	eax == WM_TIMER
				invoke	_GetMeoInfo
			.elseif	eax == WM_CLOSE
				invoke	KillTimer,hWnd,1
				invoke	EndDialog,hWnd,NULL
			.elseif	eax == WM_INITDIALOG
				push hWnd
				pop	hWinMain
				invoke	LoadIcon,hInstance,ICO_MAIN
				invoke	SendMessage,hWnd,WM_SETICON,ICON_BIG,eax
				invoke	SetTimer,hWnd,1,1000,NULL
				call	_GetMeoInfo
			.else
				mov eax,FALSE
				ret
			.endif
			mov	eax,TRUE
			ret
_ProcDlgMain	endp
start:
	invoke	GetModuleHandle,NULL
	mov		hInstance,eax
	invoke	DialogBoxParam,hInstance,DLG_MAIN,NULL,offset	_ProcDlgMain,NULL
	invoke	ExitProcess,NULL
	end		start