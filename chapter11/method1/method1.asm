		.386
		.model flat, stdcall
		option casemap :none
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Include �ļ�����
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
include		windows.inc
include		user32.inc
includelib		user32.lib
include		kernel32.inc
includelib		kernel32.lib
include		dll.inc
includelib		dll.lib
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Equ ��ֵ����
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
ICO_MAIN	equ	1000
DLG_MAIN	equ	1000
IDC_COUNT	equ	1001
IDC_INC		equ	1002
IDC_DEC		equ	1003
IDC_NUM1	equ	1004
IDC_NUM2	equ	1005
IDC_MOD		equ	1006

.code

_ProcDlgMain	proc	uses ebx esi edi hWnd,wMsg,wParam,lParam
		mov	eax,wMsg
		.if	eax == WM_CLOSE
			invoke	EndDialog,hWnd,NULL
		.elseif	eax == WM_COMMAND
			mov	eax,wParam
				.if	ax == IDC_INC
					invoke	_IncCount
					invoke	SetDlgItemInt,hWnd,IDC_COUNT,eax,FALSE
				.elseif	ax == IDC_DEC
					invoke	_DecCount
					invoke	SetDlgItemInt,hWnd,IDC_COUNT,eax,FALSE
				.elseif	ax == IDC_NUM1 || IDC_NUM2
					invoke	GetDlgItemInt,hWnd,IDC_NUM1,NULL,FALSE
					push	eax
					invoke	GetDlgItemInt,hWnd,IDC_NUM2,NULL,FALSE
					pop ecx
					invoke	_Mod,ecx,eax
					invoke	SetDlgItemInt,hWnd,IDC_MOD,eax,FALSE
				.endif
		.else
			mov	eax,FALSE
			ret
		.endif
		mov	eax,TRUE
		ret


_ProcDlgMain	endp

main:
		invoke	GetModuleHandle,NULL
		invoke	DialogBoxParam,eax,DLG_MAIN,NULL,offset _ProcDlgMain,NULL

		invoke	ExitProcess,NULL
		end		main