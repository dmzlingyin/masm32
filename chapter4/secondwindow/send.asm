			.386
			.model flat,stdcall
			option casemap:none



;************************************************************************************************
include	windows.inc
include	gdi32.inc
includelib	gdi32.lib
include	user32.inc
includelib	user32.lib
include	kernel32.inc
includelib	kernel32.lib
;************************************************************************************************

			.data
hWnd		dd	?
szBuffer		db	256 dup (?)

			.const
szCaption		db	'SendMessage',0
szStart		db	'press ok to start sendmessge,param:%08x',0
szReturn		db	'sendmessage returned',0
szDestClass		db	'MyClass',0
szText		db	'text send to  other windows',0
szNotFound	db	'Receive message window not found',0

;*****************************************************************************************

			.code

start:	 
			invoke	FindWindow,addr szDestClass,NULL
			.if		eax
					mov	hWnd,eax
					invoke	wsprintf,addr szBuffer,addr szStart,addr szText
					invoke	MessageBox,NULL,offset szBuffer,offset szCaption,MB_OK
					invoke	SendMessage,hWnd,WM_SETTEXT,0,addr szText
					invoke	MessageBox,NULL,offset szReturn,offset szCaption,MB_OK


			.else
					invoke	MessageBox,NULL,offset szNotFound,szCaption,MB_OK
			.endif

			invoke	ExitProcess,NULL

			end start