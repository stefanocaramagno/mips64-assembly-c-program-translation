; Programma in C
; main(){
; 	chat NUM[16];
; 	int i, num, valore;
; 	for(i=0; i<4; i++){
; 		printf("Inserisci una stringa con almeno 4 caratteri\n");
; 		scanf("%s", NUM);
; 		valore = esegui(NUM, strlen(NUM));
; 		if(valore != -1)
; 			printf("Valore = %d \n", valore);
; 	}
; }


;  int esegui{char *s, int d){
; 	int i,t,c;
; 	t=0;
; 	c=0;
; 	for(i=0; i<d; i++){
; 		if(s[i)<58){
; 			t=t+s[i]-48;
; 			c++;
; 		}
; 	}
; 	if(c<4)
; 		return -1;
; 	else
; 		return t;
;  }

; -----------------------------------------------------------------------------------------------

; Traduzione in Assembly 

.data
; printf("Inserisci una stringa con almeno 4 caratteri\n");
; printf("Valore = %d \n", valore);
msg1: .asciiz "Inserisci una stringa con almeno 4 caratteri\n"
msg2: .asciiz "Valore = %d \n"
p1sys5: .space 8
valore: .space 8

; scanf("%s", NUM);
NUM: .word 16
p1sys3: .word 0
ind3: .space 8
dim3: .word 16

.code
; main(){
; 	chat NUM[16];
; 	int i, num, valore;
; 	for(i=0; i<4; i++){
	daddi $s0, $0, 0 ; index i=0
	for1: 
		slti $t0, $s0, 4
		beq $t0, $0, end_for1

; 		printf("Inserisci una stringa con almeno 4 caratteri\n");
		daddi $t0, $0, msg1
		sd $t0, p1sys5($0)
		daddi r14, $0, p1sys5
		syscall 5
		
; 		scanf("%s", NUM);
		daddi $t0, $0, NUM
		sd $t0, ind3($0)
		daddi r14, $0, p1sys3
		syscall 3
		move $s1, r1 ; a1 = strlen(NUM)

; 		valore = esegui(NUM, strlen(NUM));
		daddi $a0, $0, NUM ; a0 = NUM
		move $a1, r1 ; a1 = strlen(NUM)
		j esegui
		sd r1, valore($0)
		move $s1, r1 ; s1 = valore

; 		if(valore != -1)
		if1: 
			daddi $t0, $0, -1
			beq $s1, $t0, increment_for1

; 			printf("Valore = %d \n", valore);
			daddi $t0, $0, msg2
			sd $t0, p1sys5($0)
			daddi r14, $0, p1sys5
			syscall 5

		increment_for1: daddi $s0, $s0, 1 ; increment i++
		j for1
; 	}
	end_for1: syscall 0
; }


;  int esegui{char *s, int d){
esegui: daddi $sp, $sp, -32 ; allocazione della memoria
	 sd $s0, 0($sp)
	 sd $s1, 8($sp)
	 sd $s2, 16($sp)
	 sd $s3, 24($sp)

; 	int i,t,c;

; 	t=0;
	daddi $s0, $0, 0

; 	c=0;
	daddi $s1, $0, 0

; 	for(i=0; i<d; i++){
	daddi $s2, $0, 0 ; index i=0
	for2:
		slt $t0, $s2, $a1
		beq $t0, $0, if2

; 		if(s[i)<58){
		dadd $t0, $a0, $s2 ; s[i] = s+i
		lbu $t1, 0($t0) ; s[i] = s+i

		slti $t2, $t1, 58
		beq $t2, $0, increment_for2

; 			t=t+s[i]-48;
			daddi $t2, $0, 48
			dsub $t3, $t1, $t2
			dadd $s3, $s0, $t3

; 			c++;
			daddi $s1, $s1, 1
; 		}
		increment_for2: daddi $s2, $s2, 1 ; increment i++
		j for2
; 	}

; 	if(c<4)
	if2:
		daddi $t0, $0, 1
		slti $s1, $0, 4
		bne $s1, $t0, return_-1
		beq $s1, $0, return_t

; 		return -1
		return_-1: daddi $t0, $0, -1
			     move r1, $t0
; 	else 
; 		return t;
		return_t: move r1, $s3

	ld $s0, 0($sp)
	ld $s1, 8($sp)
	ld $s2, 16($sp)
	ld $s3, 24($sp)	
	daddi $sp, $sp, 32 ; deallocazione della memoria
	jr $ra

;  }

#include input_unsigned.s
