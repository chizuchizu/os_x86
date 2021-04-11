mov ax, 0x07c0    ; 0x07c0 を ax に動かす
mov ds, ax        ; ax を dx に動かす

mov ah, 0x0       ; 0x0 を ah に動かす
mov al, 0x3       ; 0x3 を al に動かす
int 0x10          ; 上記を 0x10 (ビデオサービスを管理するBIOS)に int命令で割り込み 

mov si, msg       ; msg を si へ動かす。ソースインデックスに msg を格納
mov ah, 0x0E      ; 0x0E を ah へ動かす。画面の文字列を 0x10 へ割り込み可能に

; ループ開始
print_character_loop:    
lodsb             ; lodsb命令 si から al に1byteロードする  

or al, al         ; al(0x3)と(0x3)をor演算。文字列が0になり終わると、プロセッサはオペランドの位置にジャンプ 
jz hang

int 0x10          ; 文字列を画面にプリントする

jmp print_character_loop    ; ループの先頭に戻り、文字列が終わりでなければ次の文字をプリントする。
; ループここまで

msg:
db 'Hello, World!', 13, 10, 0    ; db => これらの値をmsg:アドレスに格納するよう命じる

hang:
jmp hang

times 510-($-$$) db 0

db 0x55
db 0xAA

