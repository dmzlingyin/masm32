.386
.model flat,stdcall
option casemap:none

include	windows.inc

.data?

dwCount	dd	?

.code

;DLL����ں���
DllMain	proc _hInstance,_dwReason,_dwReserved
		mov eax,TRUE
		ret
DllMain	endp

;dll���ڲ�����������Ϊ͸��
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

;DLL�ĵ�������
_IncCount	proc
		inc	dwCount
		invoke	_CheckCounter
		ret
_IncCount	endp

;����������
_DecCount	 proc
	dec	dwCount
	invoke	_CheckCounter
	ret
_DecCount	 endp

;����������

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








