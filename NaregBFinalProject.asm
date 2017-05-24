.MODEL  SMALL

.stack  100H            

.DATA              
          ID_NUM DB 40H ;the last two numbers of my id is 57 and I chose 64 as the closest perfect sqrt num. its hex is 40
          NUM DB ?    
          OP1 DB ? ;9 outputs for 9 logic gates operations
          OP2 DB ?
          OP3 DB ?
          OP4 DB ?
          OP5 DB ?
          OP6 DB ?
          OP7 DB ?
          OP8 DB ?
          RES DB ?

.CODE

MAIN:     MOV AX, @DATA     ; SET DSEG
          MOV DS, AX
          
          MOV AL,ID_NUM     ;COMPUTE SQUARE ROOT OF ID
          XOR BL,BL 
          MOV BL,01H 
          MOV CL,01H 
          
LOOP1:    SUB AL,BL 
          JZ LOOP2 
          INC CL 
          ADD BL,02H 
          JMP LOOP1 

LOOP2:    MOV NUM,CL 
          MOV DL,CL
          ADD DL,30H
          CMP DL,'9'
          JBE L
          ADD DL,7H
          L:JMP M
        
        M:MOV AL,NUM        ;NAND BIT 0 & BIT 1
          ADD AL, 30h       ;LEAVE PURE BINARY number of NUM IN AL
          SHR AL, 6         ;shift the bits 0 and 1 6 times to the right
          CALL NAND__GATE
          MOV OP1,AH        ;STORE THE OUTPUT
          ;MOV DL, OP1          
          ;ADD DL, 30H         
          ;MOV AH,2                
          ;INT 21H          ;print result
          MOV AL,NUM        
          ADD AL, 30h
          SHR AL, 4         ;shift the bit 2 4 times to the right
          MOV CL, OP1
          ADD AL, CL        ;add them so we would have OP1 as LSB and bit 2 exactly to its left
          Call AND__GATE    ;AND op1 and bit 2
          MOV OP2,AH
          
          MOV AL,NUM
          ADD AL, 30h
          SHR AL, 4        ;shift bit 3 4 times so that it would be the LSB
          Call NOT__GATE   ;NOT bit 3
          MOV OP3, AH
          
          MOV AL, OP3
          SHL AL, 1        ;MOVE NOT bit 3 one place the to left
          MOV CL, OP2       
          ADD AL, CL       
          Call OR__GATE    ;OR OP2 and NOT bit 3
          MOV OP4, AH  
          
          MOV Al, NUM
          ADD AL, 30h
          SHR AL, 2       ;shift bits 4 and 5 2 times to the right
          Call EOR__GATE  ;EOR them
          MOV OP5, AH
          
          MOV AL, NUM
          ADD AL, 30h
          Call NOR__GATE ;NOR bits 6 and 7
          MOV OP6, AH
          
          MOV AL, OP6
          CAll NOT__GATE ;NOT the output
          MOV OP7, AH
          
          MOV AL, OP4
          SHL AL, 1
          MOV CL, OP5
          ADD AL, CL
          CALL NAND__GATE  ;NAND OP5 and OP4
          MOV OP8, AH
          
          MOV AL, OP8
          SHL AL, 1
          MOV CL, OP7
          ADD AL, CL
          CALL NAND__GATE ;NAND the last operation's result with the NOT of NOR of bits 6 and 7
          MOV RES, AH

          MOV DL, RES          ; copy result into DL for DOS ASCII printout 
          ADD DL, 30H         ; comment out for subroutine
          MOV AH,2            ; print result
          INT 21H   
     
          MOV AH, 4CH     ;prompt return
          INT 21H
          
AND__GATE:
          MOV BL,AL           ;copy num into BL and CL
          MOV CL,AL          
          AND BL, 00000001B   ;Mask all bits except LSB
          AND CL, 00000010B   ;Mask all bits except the one left to the LSB
          SHR CL,1            
          AND BL,CL           ;AND the two numbers
          AND BL, 00000001B   ;Clear all bits except the lsb
          MOV AH, BL          
          RET
    
NAND__GATE:
          MOV BL,AL           
          MOV CL,AL           
          AND BL, 00000001B   
          AND CL, 00000010B  
          SHR CL,1            
          AND BL,CL           
          NOT BL             
          AND BL, 00000001B   
          MOV AH, BL         
          RET
    
NOR__GATE:
          MOV BL,AL           
          MOV CL,AL           
          AND BL, 00000001B  
          AND CL, 00000010B   
          SHR CL,1            
          OR  BL,CL          
          NOT BL              
          AND BL, 00000001B   
          MOV AH, BL          
          RET                 

NOT__GATE:
          MOV BL,AL           
          MOV CL,AL           
          AND BL, 00000001B   
          SHR CL,1            
          NOT BL              
          AND BL, 00000001B   
          MOV AH, BL          
          RET
    
EOR__GATE:
          MOV BL,AL           
          MOV CL,AL           
          AND BL, 00000001B   
          AND CL, 00000010B   
          SHR CL,1                             
          XOR BL,CL           
          AND BL, 00000001B   
          MOV AH, BL          
          RET
    
OR__GATE:
          MOV BL,AL          
          MOV CL,AL           
          AND BL, 00000001B   
          AND CL, 00000010B   
          SHR CL,1                             
          OR  BL,CL           
          AND BL, 00000001B   
          MOV AH, BL          
          RET                 

          END MAIN