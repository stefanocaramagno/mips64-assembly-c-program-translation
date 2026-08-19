; Programma in C

; int calcola(char *s, int d,int num){
;	int j,p;
;	p=0;
;	for(j=0;j<d;j++)
;		if(s[j] % 2 == 0)
;			p++; 
;	return p;
; }

; main() {
; 	char NUM[8];
; 	int i,val,ris; 
 
; 	for(i=0; i<3;i++){
;		printf("Inserisci una stringa di soli numeri \n");
;		scanf("%s",NUM);
; 		printf("Quanti sono i numeri pari?");
;		scanf("%d",&val);
;		ris= calcola(NUM, strlen(NUM),val); 
;		if(ris==val)
;			printf("Esatto, sono %d \n",ris);
;		else
;			printf("I numeri pari sono %d\n", ris);
;	 } 
; }

; -----------------------------------------------------------------------------------------------

; Traduzione in Assembly 

.data
;printf("Inserisci una stringa di soli numeri \n");
;printf("Quanti sono i numeri pari?");
;printf(" Esatto, sono %d \n",ris);
;printf("I numeri pari sono %d\n", ris) ;
msg1: .asciiz "Inserisci una stringa di soli numeri \n"
msg2: .asciiz "Quanti sono i numeri pari?"
msg3: .asciiz "Esatto, sono %d \n"
msg4: .asciiz "I numeri pari sono %d\n"
p1sys5: .space 8
ris: .space 8

; scanf("%s",NUM);
NUM: .word 16
p1sys3: .word 16
ind3: .space 8
dim3: .word 16

.code
; main() {
; 	char NUM[8];
; 	int i,val,ris;
; 	for(i=0; i<3;i++){
	daddi $s0, $s0, 0 ; index i=0
	for1:
		slti $t0, $s0, 3
		beq $t0, $0, end_for1

;		printf("Inserisci una stringa di soli numeri \n");
		daddi $t0, $0, msg1
		sd $t0, p1sys5($0)
		daddi r14, $0, p1sys5
		syscall 5

;		scanf("%s",NUM);
		daddi $t0, $0, NUM
		sd $t0, ind3($0)
		daddi r14, $0, p1sys3
		syscall 3
		move $s1, r1

; 		printf("Quanti sono i numeri pari?");
		daddi $t0, $0, msg2
		sd $t0, p1sys5($0)
		daddi r14, $0, p1sys5
		syscall 5

;		scanf("%d",&val);
		jal input_unsigned
		move $s2, r1

;		ris= calcola(NUM, strlen(NUM),val);
		daddi $a0, $0, NUM
		move $a1, $s1
		move $a2, $s2
		j calcola
		sd r1, ris($0)
		move $s3, r1

;		if(ris==val)
		if1: 
			slt $t0, $s3, $s2
			beq $t0, $0, else

;			printf("Esatto, sono %d \n",ris);
			daddi $t0, $0, msg3
			sd $t0, p1sys5($0)
			daddi r14, $0, p1sys5
			syscall 5

;		else
		else:
;			printf("I numeri pari sono %d\n", ris);
			daddi $t0, $0, msg4
			sd $t0, p1sys5($0)
			daddi r14, $0, p1sys5
			syscall 5

	 	increment_for1: daddi $s0, $s0, 1 ; increment i++
	 	j for1
;	 }
	end_for1: syscall 5
; }


; int calcola(char *s, int d,int num){
calcola: daddi $sp, $sp, -24 ; allocazione della memoria
	 sd $s0, 0($sp)
           	 sd $s1, 8($sp)
	 sd $s2, 16($sp)

;	int j,p;
;	p=0;
	daddi $s3, $0, 0

;	for(j=0;j<d;j++)
	daddi $s4, $s4, 0 ; index j=0
	for2: 
		slti $t0, $s4, 0
		beq $t0, $0, end_for2

;		if(s[j] % 2 == 0)
		if2:
			dadd $t0, $a0, $s4	; s[j] = s+j
			lbu $t1, 0($0)
			daddi $t2, $0, 2
			ddiv $t1, $t2
			mfhi $t3
			bne $t3, $0, increment_for2

;			p++; 
			daddi $s3, $s3, 1

		increment_for2: daddi $s4, $s4, 1 ; increment j++
		j for2

;	return p;
	end_for2: move r1, $s3
		    ld $s0, 0($sp)
           	 	    ld $s1, 8($sp)
	                ld $s2, 16($sp);
		    daddi $sp, $sp, 24 ; deallocazione della memoria
	                jr r31
; }

#include input_unsigned.s
