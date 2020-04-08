.MODEL SMALL
.STACK 100H
.DATA 
ARR DB 4,3,2,2,1,3,5,3,7,8,23,3
N DB 12                 ;NUMBER OF TERMS IN THE ARRAY 
M_O DB 0H
MEAN DB ?
MEDIAN DB ?
MODE DB ?
.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX
    MOV BL, N            ; BL IS USED TO STORE THE NUMBER OF TERMS IN THE ARRAY
    DEC BL
    XOR BH,BH
    MOV SI, 00H
LO:
    MOV AL, [ARR+SI]
    PUSH SI 
    CMP SI, BX
    JE ADDITION 
CHECK:
    ADD SI, 1
    CMP AL, [ARR+SI]
    JNG GREATER
NEXT:
    CMP SI, BX
    JNE CHECK
    POP SI
    MOV [ARR+SI], AL
    ADD SI, 1
    JMP LO    
GREATER:
    XCHG AL, [ARR+SI]
    JMP NEXT              ;THE NUMBERS ARE ARRANGED IN DESCENDING ORDER
ADDITION:
    MOV AX,0H
    MOV SI, BX
    INC SI
ADD1:
    DEC SI
    ADD AL, [ARR+SI]
    CMP SI, 00H
    JNE ADD1
    DIV N
    MOV MEAN, AL          ;MEAN IS FOUND
MDAN:
    XOR AX,AX
    MOV AL, N
    MOV DL,2H
    DIV DL
    CMP AH,0H
    JE EVEN
    CBW
    MOV SI, AX
    MOV CL, [ARR+SI]
    MOV MEDIAN, CL       ;MEDIAN IS FOUND IF NUMBR OF TERMS IS ODD
    JMP MODDE
EVEN:
    CBW
    MOV SI,AX
    XOR AX,AX
    ADD AL, [ARR+SI]
    INC SI
    ADD AL, [ARR+SI]
    DIV DL
    MOV MEDIAN, AL       ;MEDIAN IS FOUND IN CASE NUMBER OF TERMS IS EVEN
    JMP MODDE
MODDE:
    XOR CX,CX
    MOV CL, N
    DEC CL
    XOR BX,BX            ;DX AND BX REGISTER IS CLEARED, BL WILL KEEP THE COUNT
    XOR DX,DX            ;AND DL WILL KEEP THE NUMBER THAT IS BEING COUNTED
    XOR AX,AX            ;AX WILL KEEP THE SI VALUE OF THE NUMBER WHICH OCCURED MOST
    MOV SI,CX            ;M_O VARIABLE IS USED TO STORE THE OCCURENCE NUMBER OF
                         ; MOST OCCURED ELEMENT
COUNT:
    CMP [ARR+SI], DL
    JE EQL
UNEQL:
    MOV BL, 1H
    MOV DL, [ARR+SI]
    CMP M_O, BL
    JL CHANGE_SI
    CMP SI, 0H
    JE EXIT
    DEC SI
    JMP COUNT
    
EQL:
    INC BL   
    CMP M_O, BL
    JL CHANGE_SI
    DEC SI
    JMP COUNT
CHANGE_SI:
    MOV M_O, BL
    MOV AX,SI
    DEC SI
    JMP COUNT
    
    EXIT:
    MOV SI, AX
    MOV AL, [ARR+SI] 
    MOV MODE, AL
    MOV AH,4CH
    INT 21H
END MAIN