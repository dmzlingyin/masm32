;һ���򵥵ĶԻ�������
;ʱ�䣺2018-08-30���������ƴ�ĵ�һ�죨������
;���ߣ�����
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

			.386
			.model	flat,stdcall
			option	casemap:none

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
include	windows.inc
include	user32.inc
includelib	user32.lib
include	kernel32.inc
includelib	kernel32.lib

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;EQU��ֵ����
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
ICO_MAIN		equ		1000h
DIALOG_MAIN	equ		2000h

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
			.data?
hInstance		dd	?
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
			.code

_ProcDlgMain	proc	uses edi esi ebx hWnd,wMsg,wParam,lParam
			mov	eax,wMsg
			.if	eax == WM_CLOSE
				invoke	EndDialog,hWnd,NULL
			.elseif	eax == WM_INITDIALOG
				invoke	LoadIcon,hInstance,ICO_MAIN
				invoke	SendMessage,hWnd,WM_SETICON,ICO_MAIN,eax
			.elseif	eax == WM_COMMAND
				mov	eax,wParam
				.if	eax == IDOK
					invoke	EndDialog,hWnd,NULL
				.endif
			.else
				mov	eax,FALSE	
				RET
			.endif

			mov	eax,TRUE
			ret
_ProcDlgMain	endp






start:
		invoke	GetModuleHandle,NULL
		mov		hInstance,eax
		invoke	DialogBoxParam,hInstance,DIALOG_MAIN,NULL,offset _ProcDlgMain,NULL
		invoke	ExitProcess,NULL
		end		start