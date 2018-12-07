.386
.model flat,stdcall
option casemap:none

include	windows.inc

.data?

dwCount	dd	?

.code

;DLL的入口函数
DllMain	proc _hInstance,_dwReason,_dwReserved
		mov eax,TRUE
		ret
DllMain	endp

;dll的内部函数，对外为透明
_CheckCounter	proc
		mov	eax,dwCount
		cmp eax,0
		jge	@F
		xor eax,eax
		@@:
		cmp	eax,10
		jle	@F
		mov	eax,10
		@@:
		mov	dwCount,eax
		ret
_CheckCounter	endp

;DLL的导出函数
_IncCount	proc
		inc	dwCount
		invoke	_CheckCounter
		ret
_IncCount	endp

;导出函数二
_DecCount	 proc
	dec	dwCount
	invoke	_CheckCounter
	ret
_DecCount	 endp

;导出函数三

_Mod	 proc uses ecx edx _dwNumber1,_dwNumber2
		xor	edx,edx
		mov	eax,_dwNumber1
		mov	eax,_dwNumber2
		.if	eax
			div	ecx
			mov	eax,edx
		.endif
		ret

_Mod		endp
		end	DllMain








