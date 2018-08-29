;------------------------------------------------------------------------------------------------
;asmlearning
;example chapter4->FirstWindow
;date:2018-08-28
;author:dmzlingyin
;ml /c /coff FirstWindow.asm
;link /subsystem:windows FirstWindow.obj
;------------------------------------------------------------------------------------------------
			.386
			.model	flat,stdcall
			option	casemap:none

;************************************************************************************************
include	windows.inc
include	gdi32.inc
includelib	gdi32.lib
include	user32.inc
includelib	user32.lib
include	kernel32.inc
includelib	kernel32.lib
;************************************************************************************************
			.data?

hInstance	dd	?
hWinMain	dd	?
szBuffer	dd	1024	dup	(?)

			.const
szClassName	db	'MyClass',0
szCaptionMain	db	'Receive Message',0
szText		db	'win32 assembly',0
szReceive		db	'Receive WM_SETTEXT message',0dh,0ah
			db	'param:%08x',0dh,0ah
			db	'test:"%s"',0dh,0ah,0

;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

			.code

;************************************************************************************************
;窗口过程
;************************************************************************************************
_ProcWinMain	proc uses ebx edi esi hWnd,uMsg,wParam,lParam
		local	@stPs:PAINTSTRUCT
		local	@stRect:RECT
		local	@hDc
		
		mov	eax,uMsg

		.if	eax == WM_PAINT	
			invoke	BeginPaint,hWnd,addr @stPs
			mov		@hDc,eax

			invoke	GetClientRect,hWnd,addr @stRect
			invoke	DrawText,@hDc,addr szText,-1,addr @stRect,DT_SINGLELINE or DT_CENTER or DT_VCENTER
			invoke	EndPaint,hWnd,addr @stPs

		.elseif	eax == WM_CLOSE
			invoke	DestroyWindow,hWinMain
			invoke	PostQuitMessage,NULL

		.elseif	eax == WM_SETTEXT
			invoke	wsprintf,addr szBuffer,addr szReceive,lParam,lParam
			invoke	MessageBox,hWnd,offset szBuffer,addr szCaptionMain,MB_OK
		.else
			invoke	DefWindowProc,hWnd,uMsg,wParam,lParam
			ret
		.endif
		xor eax,eax
		ret




_ProcWinMain	endp


_WinMain	proc


		local	@stWndClass:WNDCLASSEX
		local	@stMsg:MSG

		invoke	GetModuleHandle,NULL
		mov		hInstance,eax	;存储模块句柄
		invoke	RtlZeroMemory,addr @stWndClass,sizeof @stWndClass


;************************************************************************************************
;注册窗口类
;************************************************************************************************

		invoke	LoadCursor,0,IDC_ARROW
		mov		@stWndClass.hCursor,eax
		push		hInstance
		pop		@stWndClass.hInstance
		mov		@stWndClass.cbSize,sizeof WNDCLASSEX
		mov		@stWndClass.style,CS_HREDRAW OR CS_VREDRAW
		mov		@stWndClass.lpfnWndProc,offset	_ProcWinMain
		mov		@stWndClass.hbrBackground,COLOR_WINDOW+1
		mov		@stWndClass.lpszClassName,offset szClassName
		invoke	RegisterClassEx,addr @stWndClass

;************************************************************************************************
;创建窗口 显示窗口
;************************************************************************************************

		invoke	CreateWindowEx,WS_EX_CLIENTEDGE,offset szClassName,offset szCaptionMain,WS_OVERLAPPEDWINDOW,100,100,600,400,NULL,NULL,hInstance,NULL
				

		mov		hWinMain,eax	;获取窗口句柄
		invoke	ShowWindow,hWinMain,SW_SHOWNORMAL
		invoke	UpdateWindow,hWinMain

;************************************************************************************************
;消息循环
;************************************************************************************************
		.while TRUE
			invoke	GetMessage,addr @stMsg,NULL,0,0
			.break	.if eax == 0
			invoke	TranslateMessage,addr @stMsg
			invoke	DispatchMessage,addr @stMsg

		.endw
		ret
_WinMain	endp



;程序开始
start:		
		call		_WinMain
		invoke	ExitProcess,NULL
		end start