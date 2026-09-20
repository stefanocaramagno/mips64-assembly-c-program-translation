; Programma in C

; int processa(char *num, int d){ 
; 	int i,somma;
; 	somma=0;
; 	for(i=0;i<d;i++)
; 		somma=somma+ num[i]-48;
; 	return somma;
; }
; main() {
; 	char NUMERO[16];
; 	int i,val; 
; 	for(i=0;i<4;i++) {
; 		printf("Inserisci una stringa con soli numeri\n");
;  		scanf("%s",NUMERO);
;		if(strlen(NUMERO)<2)
; 			val=NUMERO[0]-48;
; 		else val=processa(NUMERO,strlen(NUMERO)); 
;	 		printf(" Valore= %d \n",val); 
;	 } 
; }

; -----------------------------------------------------------------------------------------------

; Traduzione in Assembly

; .DATA
.data
; printf("Inserisci una stringa con soli numeri\n");
; printf(" Valore= %d \n",val);
msg2: .asciiz "Valore = %d\n"
msg1: .asciiz "Inserisci una stringa con soli numeri \n"
p1sys5: .space 8
val: .space 8

; scanf("%s",NUMERO);
NUMERO: .space 16
p1sys3: .word 0
ind: .space 8
dim: .word 16

; .CODE
.code
; main() {
; 	char NUMERO[16];
; 	int i,val; 
;	for(i=0;i<4;i++) {
	daddi $s0, $0, 0 ; index i=0
	for1: slti $t0, $0, 4
	       beq $t0, $0, end_for1

; 	       printf("Inserisci una stringa con soli numeri\n");
	       daddi $t0, $0, msg1
	       sd $t0, p1sys5($0)
	       daddi r14, $0, p1sys5
                   syscall 5

;  	        scanf("%s",NUMERO);
	        daddi $t0, $0, NUMERO
	        sd $t0, ind($0)
	        daddi r14, $0, p1sys3
	        syscall 3
	        move $s1, r1 

;	        if(strlen(NUMERO)<2)
	        slti $t1, $s1, 2
                    beq $t1, $0, falso

; 	        		val=NUMERO[0]-48;
			vero: lbu $t2, NUMERO($0)
			         daddi $t2, $t2, -48;
		                     j stampa_val

; 	         else val=processa(NUMERO,strlen(NUMERO)); 
	         falso: daddi $a0, $0, NUMERO
		         move $a1, $s1
		         jal processa
		         move $t2, r1

;	 	         printf(" Valore= %d \n",val); 
		         stampa_val: sd $t2, val($0)
				      daddi $t0, $0, msg2
			                   sd $t0, p1sys5($0)
				       daddi r14, $0, p1sys5
				       syscall 5

	          increment_for1: daddi $s0, $s0, 1 
	j for1
	end_for1: syscall 0
;         } 

; int processa(char *num, int d){ 
  processa: daddi $sp, $sp, -16 ; allocazione della memoria
	         sd $s0, 0($sp)
                   sd $s1, 8($sp)

;	int i,somma;
; 	somma=0;
	daddi $s0, $0, 0

;          for(i=0;i<d;i++)
	daddi $s1, $0, 0 
	for2: 	slti $t0, $s1, $a1
	beq $t0, $0, end_for2

; 		somma=somma+ num [i]- 48
		dadd $t1, $a0, $s1 
		lbu $t2, 0($t1)
		dadd $s0, $s0, $t2
		daddi $s0, $s0, -48

	increment_for2:  daddi $s1, $s1, 1 
	j for2

	;return somma
	end_for2:   move r1, $s0
		      ld $s0, 0($sp)
		      ld $s1, 8($sp)
		      daddi $sp, $sp, 16 ; deallocazione della memoria
	                  jr $ra
; }

#include input_unsigned.s