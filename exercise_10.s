; Programma in C

; int calcola(char *str, int a1, int num){
;         int i,s,c;
;	c=0;
;	s=0;
;	for(i=0;i<a1;i++)
;		if(str[i]<58){
;			s=s+str[i]-48;
;		 	c++;
;		} 
;	if(c==0)
;		return -1;
;	else return s/c; 
; }

; main() {
;	char STRINGA[32],*a0;
; 	int i,a1,num,valore; 
; 	for(i=0;i<4;i++){ 
; 		 printf("%d Inserisci una stringa con almeno 2 numeri\n",i);
;		 scanf("%s",STRINGA);
;		 a0= STRINGA;
;		 a1=strlen(STRINGA);
; 		if(a1>=2){
; 			printf("%d) Inserisci un numero ad una sola cifra\n",i);
; 			scanf("%d",&num);
;			valore=calcola(a0, a1,num);
; 			if(valore<0){
;				printf("%d Risultato = %d\n",i, valore);
;		 	} 
;		}
; 	}
; }

; -----------------------------------------------------------------------------------------------

; Traduzione in Assembly 

.data
; printf("%d Inserisci una stringa con almeno 2 numeri\n",i);
; printf("%d) Inserisci un numero ad una sola cifra\n",i);
; printf("%d Risultato = %d\n",i, valore)
p1sys5: .space 8
i: .space 8
valore: .space 8
msg1: .asciiz "Inserisci una stringa con almeno 2 numeri \n"
msg2: .asciz "Inserisci un numero ad una sola cifra \n"
msg3: .asciz "Risultato = %d \n"

; scanf("%s",STRINGA);
STRINGA: .space 8
p1sys3: .word 0
ind3: .space 8
dim3: .word 8

.code
;	char STRINGA[32],*a0;
; 	int i,a1,num,valore;

; 	for(i=0;i<4;i++){ 
          daddi $s0, $0, 0 ;index i=0
          for1:
		slti $t0, $s0, 4                ;if(i<4) $t0 = 1; else $t0 = 0
		beq $t0, $0, end_for1   ;if $t0 = 0 --> end_for

; 		 printf("%d Inserisci una stringa con almeno 2 numeri\n",i);
		sd $s0, i($0)
		daddi $t0, $0, msg1
		sd $t0, p1sys5($0)
		daddi r14, $0, p1sys5
		syscall 5

;		 scanf("%s",STRINGA);
;                       a0 = STRINGA
		daddi $a0, $0, STRINGA 

		sd $a0, ind3($0)
		daddi r14, $0, p1sys3
		syscall 3

;		a1=strlen(STRINGA);
		move $a1, r1 ;salvataggio del numero di caratteri con scanf in $s1

; 		if(a1>=2){
		if1:
			slti $t0, $a1, 2
			bne $t0, $0, increment_for1

; 			printf("%d) Inserisci un numero ad una sola cifra\n",i);
			sd $s1, i($0)

			daddi $t0, $0, msg2
			sd $t0, p1sys5($0)
			daddi r14, $0, p1sys5
			syscall 5

; 			scanf("%d",&num);
			jal input_unsigned
			move $a2, r1 ;salvataggio del numero di caratteri con scanf in $a2

;			valore=calcola(a0, a1,num);
			jal calcola
			move $s1, r1	

; 			if(valore<0){
			if2:
				slti $t0, $s1, 0
				bne $t0, $0, increment_for1

;				printf("%d Risultato = %d\n",i, valore);
				sd $s0,i($0)
				sd $s1, valore($0)

				daddi $t0, $0, msg3
				sd $t0, p1sys5($0)
				daddi r14, $0, p1sys5
				syscall 5
;		 	} 
;		}
		increment_for1: daddi $s0, $s0, 1 ;increment i++
		j for1
; 	}
        end_for1: syscall 0
; }

; int calcola(char *str, int a1, int num){
calcola: daddi $sp, $sp, -24 ; allocazione della memoria
               sd $s0, 0($sp)
               sd $s1, 8($sp)
               sd $s2, 16($sp)

; int i,s,c;
; c=0;
daddi $s0, $0, 0 ;

; s=0;
daddi $s1, $0, 0 ; 

;	for(i=0;i<a1;i++)
	daddi $s2, $0, 0 ; index i=0;	
	for2:
		slti $t0, $s2, $a1              ; if(i<a1) $t0 = 1; else $t0 = 0
		beq $t0, $0, end_for2    ; if $t0 = 0 --> end_for

;		if(str[i]<58){
		if3:	
;			s=s+str[i]-48;
			move $t0, $a0
			lbu $t1, 0($t0)
			slti $t2, $t1, 58
			beq $t2, $0, increment_for2

			daddi $t1, $t1, -48 ; s=s+str[i]-48;
			move $s1, $t1
			daddi $s0, $s0, 1 ; c++;
;		} 

		increment_for2: daddi $s2, $s2, 1 ;increment i++
		j for2
	end_for2: bne $s0, $0, else_if4
	
;	if(c==0)
	if4:
;		return -1;
		daddi r1, $0, -1
		j return

;	else return s/c; 
	else_if4: ddiv $s1, $a2
		    mflo r1
	return: ld $s0, 0($sp)
		 ld $s1, 8($sp)
	             ld $s2, 16($sp)
	             daddi $sp, $sp, 24 ; deallocazione della memoria
	             jr r31
; }

#include input_unsigned.s