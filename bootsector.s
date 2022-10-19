[ORG 0x7c00]
[BITS 16]

global boot

boot:
    jmp _start
    nop

    ; Here is a example BPB
    OEMname:           db    "mkfs.fat"  
    bytesPerSector:    dw    512
    sectPerCluster:    db    0
    reservedSectors:   dw    0
    numFAT:            db    0
    numRootDirEntries: dw    0
    numSectors:        dw    0
    mediaType:         db    0
    numFATsectors:     dw    0
    sectorsPerTrack:   dw    0
    numHeads:          dw    0
    numHiddenSectors:  dd    0
    numSectorsHuge:    dd    0
    driveNum:          db    0
    reserved:          db    0
    signature:         db    0
    volumeID:          dd    0
    volumeLabel:       db    "NO NAME    "
    fileSysType:       db    "FAT12   "

_start:
    cli
    xor ax, ax ; clear your segments
    mov es, ax
    mov ds, ax

    jmp 0x00:main ; clear code segment

main:
    sti
    mov bp , 0x8000 ; Set the base of the stack a little above where BIOS
    mov ss,  ax ; Setup Stack SS (AX=0) followed immediately by SP
    mov sp , bp 

    mov ah, 0x0e ; int 10/ ah = 0 eh -> scrolling teletype BIOS routine
    mov bx, message
    call print_string
    mov bx, bmessage
    call print_string
    mov bx, cmessage
    call print_string
    mov ah, 00h
    int 16h; Wait for keypress?
    mov ah, 0x0e
    mov bx, kmessage
    call print_string
    jmp $

print_string:
    mov al, [bx]
    inc bx
    cmp al, 0 
    jne print_char
    mov bx, 0
    ret
print_char: 
    int 0x10; Print AL register
    jmp print_string

message:
    db 0x0a,0x0d,"Enderbyte Programs",0x0a,0x0d,0
bmessage:
    db 0x0a,0x0d,"Booting...",0x0a,0x0d,0
cmessage:
    db 0x0a,0x0d,"Just kidding this does nothing ",0
kmessage:
    db "Or does it?",0

times 446 - ($ - $$) db 0x00 ; Padding to 512 bytes

; Partitions table for a MBR

partition_table_1:
    db 0x80 ; Status, 0x80 means active
    db 0x00 ; First Absolute Sector CHS
    db 0x00 ; 
    db 0x00 ;  
    db 0x00 ; Partition Type
    db 0x00 ; Last Absolute Sector CHS
    db 0x00 ; 
    db 0x00 ; 
    dd 0x00000001 ; First Absolute Sector LBA
    dd 0x00000200 ; Number of Sectors
    
partition_table_2:
    db 0x00 ; Status, 0x80 means active
    db 0x00 ; First Absolute Sector CHS
    db 0x00 ; 
    db 0x00 ;  
    db 0x00 ; Partition Type
    db 0x00 ; Last Absolute Sector CHS
    db 0x00 ; 
    db 0x00 ; 
    dd 0x00000000 ; First Absolute Sector LBA
    dd 0x00000000 ; Number of Sectors
    
partition_table_3:
    db 0x00 ; Status, 0x80 means active
    db 0x00 ; First Absolute Sector CHS
    db 0x00 ; 
    db 0x00 ;  
    db 0x00 ; Partition Type
    db 0x00 ; Last Absolute Sector CHS
    db 0x00 ; 
    db 0x00 ; 
    dd 0x00000000 ; First Absolute Sector LBA
    dd 0x00000000 ; Number of Sectors
    
partition_table_4:
    db 0x00 ; Status, 0x80 means active
    db 0x00 ; First Absolute Sector CHS
    db 0x00 ; 
    db 0x00 ;  
    db 0x00 ; Partition Type
    db 0x00 ; Last Absolute Sector CHS
    db 0x00 ; 
    db 0x00 ; 
    dd 0x00000000 ; First Absolute Sector LBA
    dd 0x00000000 ; Number of Sectors

dw 0xAA55 ; Boot signature required to boot