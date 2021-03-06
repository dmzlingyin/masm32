;date:2018-08-29
;author:dmzlingyin
;email:dmzlingyin@163.com
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
		.386
		.model flat, stdcall
		option casemap :none
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Include 文件定义
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
include		windows.inc
include		user32.inc
includelib		user32.lib
include		kernel32.inc
includelib		kernel32.lib
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Equ 等值定义
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>



ICO_MAIN	equ	1000h
IDM_MAIN	equ	2000h
IDA_MAIN	equ	2000h

IDM_ZQL	equ	3000h
IDM_WX	equ	3001h
IDM_WPZ	equ	3002h
IDM_XYH	equ	3003h


IDM_LC	equ	4000h
IDM_ZRS	equ	4001h
IDM_HYJ	equ	4002h
IDM_LW	equ	4003h
IDM_YH	equ	4004h
	


;******************************************************************************************
		.data?
hInstance	dd		?
hWinMain	dd		?
hMenu	dd		?
hSubMenu	dd		?
		.data
szDmbj	db	'盗墓笔记',0
szSh		db	'沙海',0

		.const
szClassName	db	'Menu',0
szCaptionMain	db	'MenuWindow!',0
szFormat		db	'你选择了 :%08x'




;显示选择的菜单项
		.code
_Display	proc	ID_VALUE
		local @buffer[256]:byte

		pushad
		invoke	wsprintf,addr @buffer,offset szFormat,ID_VALUE
		invoke	MessageBox,hWinMain,addr @buffer,offset szCaptionMain,MB_OK
		popad
		ret
	

_Display	endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 窗口过程
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_ProcWinMain	proc	uses ebx edi esi hWnd,uMsg,wParam,lParam
		local @stPos:POINT
	

		mov	eax,uMsg
;********************************************************************
		.if	eax == WM_CREATE
				invoke	GetSubMenu,hMenu,1
				mov	hSubMenu,eax
		
;********************************************************************
		.elseif eax ==	WM_CLOSE
			invoke	DestroyWindow,hWinMain
			invoke	PostQuitMessage,NULL
;********************************************************************
		.elseif eax == WM_COMMAND
			mov		eax,wParam
			movzx	eax,ax
			.if	eax >= IDM_ZQL && eax <= IDM_WPZ
				mov	ebx,eax
				invoke	GetMenuState,hMenu,ebx,NULL
				.if	eax == MF_CHECKED
					mov	eax,MF_UNCHECKED
				.else
					mov	eax,MF_CHECKED
				.endif
				invoke	CheckMenuItem,hMenu,ebx,eax
				invoke	MessageBox,hWinMain,offset szDmbj,offset szCaptionMain,MB_OK

			.elseif	eax >= IDM_LC && eax <= IDM_HYJ
				mov	ebx,eax
				invoke	GetMenuState,hMenu,ebx,NULL
				.if	eax == MF_CHECKED
					mov	eax,MF_UNCHECKED
				.else
					mov	eax,MF_CHECKED
				.endif
				invoke	CheckMenuItem,hMenu,ebx,eax
				invoke	MessageBox,hWinMain,offset szSh,offset szCaptionMain,MB_OK
					
			.else	
				invoke	_Display,wParam

			.endif
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;处理pop菜单
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

		.elseif	eax == WM_RBUTTONDOWN	
			invoke	GetCursorPos,addr @stPos
			invoke	TrackPopupMenu,hSubMenu,TPM_LEFTALIGN,@stPos.x,@stPos.y,NULL,hWinMain,NULL


;********************************************************************
		.else
			invoke	DefWindowProc,hWnd,uMsg,wParam,lParam
			ret
		.endif
;********************************************************************
		xor	eax,eax
		ret

_ProcWinMain	endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_WinMain	proc
		local	@stWndClass:WNDCLASSEX
		local	@stMsg:MSG
		local	@hAccelerator

		invoke	GetModuleHandle,NULL
		mov	hInstance,eax
		invoke	LoadMenu,hInstance,IDM_MAIN
		mov	hMenu,eax
		invoke	LoadAccelerators,hInstance,IDA_MAIN
		mov	@hAccelerator,eax
		invoke	RtlZeroMemory,addr @stWndClass,sizeof @stWndClass
;********************************************************************
; 注册窗口类
;********************************************************************
		invoke	LoadCursor,0,IDC_ARROW
		mov	@stWndClass.hCursor,eax
		invoke	LoadIcon,hInstance,ICO_MAIN
		mov	@stWndClass.hIconSm,eax
		mov	@stWndClass.hIcon,eax
		push	hInstance
		pop	@stWndClass.hInstance
		mov	@stWndClass.cbSize,sizeof WNDCLASSEX
		mov	@stWndClass.style,CS_HREDRAW or CS_VREDRAW
		mov	@stWndClass.lpfnWndProc,offset _ProcWinMain
		mov	@stWndClass.hbrBackground,COLOR_WINDOW + 1
		mov	@stWndClass.lpszClassName,offset szClassName
		invoke	RegisterClassEx,addr @stWndClass
;********************************************************************
; 建立并显示窗口
;********************************************************************
		invoke	CreateWindowEx,WS_EX_CLIENTEDGE,offset szClassName,offset szCaptionMain,\
			WS_OVERLAPPEDWINDOW,\
			100,100,600,400,\
			NULL,hMenu,hInstance,NULL
		mov	hWinMain,eax
		invoke	ShowWindow,hWinMain,SW_SHOWNORMAL
		invoke	UpdateWindow,hWinMain
;********************************************************************
; 消息循环
;********************************************************************
		.while	TRUE
			invoke	GetMessage,addr @stMsg,NULL,0,0
			.break	.if eax	== 0
			invoke	TranslateAccelerator,hWinMain,@hAccelerator,addr @stMsg
			.if	eax == 0
				invoke	TranslateMessage,addr @stMsg
				invoke	DispatchMessage,addr @stMsg
			.endif
		.endw
		ret

_WinMain	endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
start:
		call	_WinMain
		invoke	ExitProcess,NULL
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
		end	start
