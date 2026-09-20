; Programma in C

; int elabora(char *s, int d, int n){ 
;	int i,t,val;
;	t=0;
;	for(i=0;i<d;i++){ ;
;	val=n%10; 
;	if(val<s[i]-48)
;		t++; 
;	} 
;	return t;
;}

; main() {
; 	char STRINGA[8];
;	int i,ris; 
;	long num; 
 
;	i=0;
;	do{
;		printf("Inserisci una stringa con al massimo 8 caratteri\n"); 
;		scanf("%s",STRINGA);
 
;		printf("Inserisci un numero con %d cifre\n",strlen(STRINGA));
; 		scanf("%d",&num);
;		ris= elabora(STRINGA,strlen(STRINGA),num); 
;		printf(" Risultato= %d \n",ris); 
;		i++; 
;	} while (ris!=0&& i<3); 
; }

; -----------------------------------------------------------------------------------------------

; Traduzione in Assembly

.data
; printf("Inserisci una stringa con al massimo 8 caratteri\n"); 
; printf("Inserisci un numero con %d cifre\n",strlen(STRINGA));
; printf(" Risultato= %d \n",ris); 
msg1: .asciiz "Inserisci una stringa con al massimo 8 caratteri\n"
msg2: .asciiz "Inserisci un numero con %d cifre\n"
msg3: .asciiz " Risultato= %d \n"
p1sys5: .space 8
val: .space 8
ris: .space 8

; scanf("%s",STRINGA);
STRINGA: .word 8
p1sys3: .word 0
ind3: .space 8
dim3: .word 8

.code

; main() {
; 	char STRINGA[8];
;	int i,ris;
;	long num; 
 
;	i=0;
	daddi $s0, $0, 0 ; index i=0

;	do{
	do: 
		slti $t0, $s0, 3
		beq $t1, $0, end_do_while
		beq $s3, $0, end_do_while

;		printf("Inserisci una stringa con al massimo 8 caratteri\n");
		daddi $t0, $0, msg1
		sd $t0, msg1($0)
		daddi r14, $0, p1sys5
		syscall 5

;		scanf("%s",STRINGA);
		daddi $t0, $0, STRINGA
		sd $t0, ind3($0)
		daddi r14, $0, p1sys3
		syscall 3
		move $t0, r1 ; s1 = strlen(STRINGA)
		sd $s1, val($0)
 
;		printf("Inserisci un numero con %d cifre\n",strlen(STRINGA));
		daddi $t0, $0, msg2
		sd $t0, msg2($0)
		daddi r14, $0, p1sys5
		syscall 5

; 		scanf("%d",&num);
		jal input_unsigned
		move $s2, r1

;		ris= elabora(STRINGA,strlen(STRINGA),num); 
		daddi $a0, $0, STRINGA ;a0 = STRINGA
		move $a1, $s1 ; a1 = s2 = strlen(STRINGA)
		move $a2, $s2 ; a2 = s1 = num
		j elabora
		sd r1, ris($0)
		move $s3, r1 ; s3 = ris

;		printf(" Risultato= %d \n",ris); 
		daddi $t0, $0, msg3
		sd $t0, msg3($0)
		daddi r14, $0, p1sys5
		syscall 5

;		i++; 
		increment_while: daddi $s0, $s0, 1
		j do

;	} while (ris!=0 && i<3); 
	end_do_while: syscall 0
; }

; int elabora(char *s, int d, int n){ 
elabora: daddi $sp, $sp, -24 ; allocazione della memoria
	  sd $s0, 0($sp)
	  sd $s1, 8($sp)
	  sd $s2, 16($sp)

;	int i,t,val;
;	t=0;
	daddi $s0, $0, 0

;	for(i=0;i<d;i++){ 
	daddi $s1, $0, 0 ; index i=0
	for:
		slt $t0, $s0, $a1
		beq $t0, $0, end_for

;		val=n%10; 
		daddi $t0, $0, 10
		ddiv $a2, $t0
		mflo $t5

;		if(val<s[i]-48)
		dadd $t0, $a0, $s1 ; s[i] = s+i
		lbu $t1, 0($t0) ; s[i] = s+i
		daddi $t2, $0, 48 ; t2 = 48
		dsub $t3, $t0, $t1 ; s[i]-48
		slt $t4, $t5, $t3 ; val<s[i]-48 ?
		beq $t0, $0, increment_for

;			t++; 
			daddi $s0, $s0, 1
	
		increment_for: daddi $s1, $s1, 1 ; increment i++
		j for
;	} 

;	return t;
	end_for: move r1, $s0
	  	  ld $s0, 0($sp)
	              ld $s1, 8($sp)
	              ld $s2, 16($sp)
		  daddi $sp, $sp, 24 ; deallocazione della memoria
		  jr $ra
; }

#include input_unsigned.s
