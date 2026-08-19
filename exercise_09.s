; Programma in C

; int calcola(char *s, int d){
;	int i,t;
;	t=0;
;	for(i=0; i<d; i++)
;		t=t+s[i]%16;
;	return t;

; main() {
;	char SNUM[32];
;	int i,cont,valore; 

;	for(i=0;i<4) {
;		printf("Inserisci una stringa (numeri) con almeno 2 caratteri\n"); 
;		scanf("%s",SNUM);
;		if(strlen(SNUM)<2){
;			printf("Pochi caratteri. Vuoi continuare?\n (1=si,0=no)");
;			scanf("%d",&cont);
;			if(cont==0)
;				i=4; // fine esecuzione
;		}
;		else { 
;			valore=calcola(SNUM,strlen(SNUM));
;			printf(" Valore= %d \n",valore); 
;			i++;
; 		}
;	 }
; }

; -----------------------------------------------------------------------------------------------

; Traduzione in Assembly 

.data
; printf("Inserisci una stringa (numeri) con almeno 2 caratteri\n"); 
; printf("Pochi caratteri. Vuoi continuare?\n (1=si,0=no)");
; printf(" Valore= %d \n",valore); 
msg1: .asciiz "Inserisci una stringa (numeri) con almeno 2 caratteri\n"
msg2: .asciiz "Pochi caratteri. Vuoi continuare?\n (1=si,0=no)"
msg3: .asciiz " Valore= %d \n"
p1sys5: .space 8
valore: .space 8

; scanf("%s",SNUM);
SNUM: .word 32
p1sys3: .word 0
ind3: .space 8
dim3: .word 32

.code
; main() {
;	char SNUM[32];
;	int i,cont,valore;
 
;	for(i=0;i<4) {
	daddi $s0, $0, 0 ; index i=0
	for1: 
		slti $t0, $0, 4
		beq $t0, $0, end_for1

;		printf("Inserisci una stringa (numeri) con almeno 2 caratteri\n");
		daddi $t0, $0, msg1
		sd $t0, p1sys5($0)
		daddi r14, $0, p1sys5
		syscall 5

;		scanf("%s",SNUM);
		daddi $t0, $0, SNUM
		sd $t0, ind3($0)
		daddi r14, $0, p1sys3
		syscall 3
		move $s1, r1

;		if(strlen(SNUM)<2){
		if1: 
			slti $t0, $s1, 2
			beq $t0, $0, else

;			printf("Pochi caratteri. Vuoi continuare?\n (1=si,0=no)");
			daddi $t0, $0, msg2
			sd $t0, p1sys5($0)
			daddi r14, $0, p1sys5
			syscall 5

;			scanf("%d",&cont);
			jal input_unsigned
			move $s2, r1

;			if(cont==0)
			if2: 
				slti $t0, $s2, 0
				beq $t0, $0, for1

;				i=4; // fine esecuzione
				daddi $s0, $0, 4
				end_for1: syscall 0
;		}
;		else {
		else:
;			valore=calcola(SNUM,strlen(SNUM));
			daddi $a0, $0, SNUM
			move $a1, $s1
			j calcola
			sd r1, valore($0)

;			printf(" Valore= %d \n",valore);
			daddi $t0, $0, msg3
			sd $t0, p1sys5($0)
			daddi r14, $0, p1sys5
			syscall 5

;			i++;
			increment_for1: daddi $s0, $s0, 1 ; increment i++
; 		}
		j for1
;	 }
	end_for1: syscall 0
; }

; int calcola(char *s, int d){
calcola: daddi $sp, $sp, -24 ; allocazione della memoria
	 sd $s0, 0($sp)
	 sd $s1, 8($sp)
	 sd $s2, 16($sp)

;	int i,t;
;	t=0;
	daddi $s0, $0, 0

;	for(i=0; i<d; i++)
	daddi $s1, $0, 0 ; index i=0
	for2: 
		slt $t0, $0, $a1
		beq $t0, $0, end_for2

;		t=t+s[i]%16;
		dadd $t1, $a0, $s0 ; s[i] = s + i
		lbu $s2, 0($t1)
		daddi $t0, $0, 16
		ddiv $s2,  $t0
		mfhi $t1
		dadd $s3, $t1, $s0

		increment_for2:  daddi $s1, $0, 1 ; increment i++
		j for2

;	return t;
	end_for2: move r1, $s3
		    ld $s1, 0($sp)
		    ld $s2, 8($sp)
		    ld $s3, 16($sp)
		    daddi $sp, $sp, 24 ; deallocazione della memoria
		    jr $ra

#include input_unsigned.s
