; Programma in C
; int elabora(char *a0, int a1){ 
; 	int i,conta;
;	conta=0;
;	for(i=0;i<a1;i++)
;		if(a0[i]<57) 
; 			conta++;
; 	return conta; 
; }

; int main() {
;	char STR[16];
; 	int i,val, num; 
 
;	for(i=0;i<3;i++) {
;		printf("Inserisci una stringa con almeno 4 caratteri\n");
; 		scanf("%s",STR);
;		if(strlen(STR)>=4)
;			val= elabora(STR,strlen(STR));
; 		else {
;			printf("Inserisci un numero ");
;			scanf("%d",&val);
; 		}
; 		printf(" Val = %d \n",val); 
; 	} 
; }

; -----------------------------------------------------------------------------------------------

; Traduzione in Assembly 

.data
; printf("Inserisci una stringa con almeno 4 caratteri\n");
; printf("Inserisci un numero ");
; printf(" Val = %d \n",val); 
; printf(" Val = %d \n",val);
msg1: .asciiz "Inserisci una stringa con almeno 4 caratteri\n"
msg2: .asciiz "Inserisci un numero"
msg3: .asciiz "Val = %d \n"

p1sys5: .space 8
val: .space 8

; scanf("%s",STR);
STR: .space 16
p1sys3: .word 0
ind3: .space 8
dim3: .word 16

.code
; int main() {
;	char STR[16];
; 	int i,val, num; 
;	for(i=0;i<3;i++) {
	daddi $s0, $0, 0 ; index i=0
	for1:
		slti $t0, $s0, 3                      ;if(i<3) $t0 = 1; else $t0 = 0 
		beq $t0, $0, end_for1        ;if $t0 = 0 --> end_for  

;		printf("Inserisci una stringa con almeno 4 caratteri\n");
		daddi $t1, $0, msg1
		sd $t1, p1sys5($0)
		daddi r14, $0, p1sys5
		syscall 5

; 		scanf("%s",STR);
		daddi $t1, $0, STR
		sd $t1, ind3($0)
		daddi r14, $0, p1sys3
		syscall 3
		move $s1, r1

;		if(strlen(STR)>=4)
		if: 
			daddi $t2, $0, 4
			slt $t1, $t2, $s1
			bne $t1, $0, else

;			val= elabora(STR, strlen(STR));
			daddi $a0, $0, STR ; a0 = STR
			move $a1, $s1        ; a1 = strlen(STR)
			j elabora
			sd r1, val($0)
			move $s1, r1

; 		else {
		else:
;			printf("Inserisci un numero ");
			daddi $t1, $0, msg2
			sd $t1, p1sys5($0)
			daddi r14, $0, p1sys5
			syscall 5

;			scanf("%d",&val);
			jal input_unsigned
			move $s1, r1
; 		}

; 		printf(" Val = %d \n",val); 
		daddi $t1, $0, msg3
		sd $t1, p1sys5($0)
		daddi r14, $0, p1sys5
		syscall 5

		increment_for1: daddi $s0, $s0, 1 ; increment i++
		j for1
; 	} 
	end_for1: syscall 0
; }

; int elabora(char *a0, int a1){ 
elabora: daddi $sp, $sp, -16 ; allocazione della memoria
	  sd $s0, 0($sp)
	  sd $s1, 8($sp)

; 	int i,conta;
;	conta=0;
	daddi $s2, $0, 0

;	for(i=0;i<a1;i++)
	daddi $s3, $0, 0 ; index i=0
	for2:
		slti $t0, $s0, $a1            ;if(i<a1) $t0 = 1; else $t0 = 0
		beq $t0, $0, end_for2   ;if $t0 = 0 --> end_for

;		if(a0[i]<57) 
		if2: 
			; a0[i]=a0+i
			dadd $t1, $a0, $s3
			lbu $t2, 0($t1)

			slti $t0, $t2, 57 ; $to=1 se a0[i]<57
			beq $t0, $0, increment_for2

; 			conta++;
			daddi $s2, $s2, 1 

	increment_for2: daddi $s3, $s3, 1 ; increment i++
	j for2

; 	return conta; 
	end_for2: move r1, $s2 
		    ld $s0, 0($0)
		    ld $s1, 8($0)
                            daddi $sp, $sp, 16 ; deallocazione della memoria
	                jr $ra
; }

#include input_unsigned.s
