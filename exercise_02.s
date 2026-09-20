; Programma in C

; int elabora(char *a0, int a1){ 
; 	int i;
;	for(i=0;i<a1;i++)
;		if(a0[i]<48) 
; 			return -1;
;	return a1; 
; }

; main() {
; 	char STRINGA[16];
; 	int A[4], i, n; 
;	for(i=0;i<4;i++){ 
;		printf("Inserire una stringa\n");
;		scanf("%s",STRINGA); 
;		printf("Inserisci un numero minore di %d \n",strlen(STRINGA));
;		scanf("%d",&n)
;		A[i]=elabora(STRINGA,n);
;		printf("A[%d]=%d", i,A[i]); 
;          } 
; }

; -----------------------------------------------------------------------------------------------

; Traduzione in Assembly

.data
; printf("Inserire una stringa\n");
; printf("Inserisci un numero minore di %d \n",strlen(STRINGA));
; printf("A[%d]=%d", i,A[i]); 
msg1: .asciiz "Inserire una stringa\n"
msg2: .asciiz "Inserisci un numero minore di %d \n"
msg3: .asciiz "A[%d]=%d"
p1sys5: .space 8
i: .space 8
val: .space 8

;scanf("%s",STRINGA); 
STRINGA: .word 16
p1sys3: .word 0 
ind3: .space 8
dim3: .word 0

.code
; main() {
; 	char STRINGA[16];
; 	int A[4], i, n; 
;	for(i=0;i<4;i++){
	daddi $s0, $0, 0 ; index i=0
	for1:
		slti $t0, $s0, 4
		beq $t0, $0, end_for1

;		printf("Inserire una stringa\n");
		daddi $t0, $0, msg1
		sd $t0, p1sys5($0)
		daddi r14, $0, p1sys5
		syscall 5

;		scanf("%s",STRINGA);
		daddi $t0, $0, STRINGA
		sd $t0, ind3($0)
		daddi r14, $0, p1sys3
		syscall 3
		move $s1, r1

;		printf("Inserisci un numero minore di %d \n",strlen(STRINGA));
		sd $s1, i($0)
		daddi $t0, $0, msg2
		sd $t0, p1sys5($0)
		daddi r14, $0, p1sys5
		syscall 5	

;		scanf("%d",&n)
		jal input_unsigned
		move $s2, r1

;		A[i]=elabora(STRINGA,n);
		move $a0, $s1
		move $a1, $s2
		j elabora
		move $s3, r1
		
;		printf("A[%d]=%d", i,A[i]);
		sd $s3, val($0)
		daddi $t0, $0, msg3
		sd $t0, p1sys5($0)
		daddi r14, $0, p1sys5
		syscall 5

		increment_for1: daddi $s0, $s0, 1 ; increment i++
		j for1
;           }
	end_for1: syscall 0

; }

; int elabora(char *a0, int a1){ 
elabora: daddi $sp, $sp, -24
	  sd $s0, 0($sp)
	  sd $s1, 8($sp)
 	  sd $s2, 16($sp)

; 	int i;
;	for(i=0;i<a1;i++)
	daddi $s0, $0, 0 ; index i=0
	for2: 
		slt $t0, $s0, $a1
		beq $t0, $0, end_for2.2

;		if(a0[i]<48)
		if:
			dadd $t0, $a0, $s0 ; a0[i] = a0 + i
			lbu $t1, 0($t0)
			slti $t2, $t1, 48
			beq $t2, $0, end_for2.1

;			return -1;
			end_for2.1: daddi r1, $0, 1
	               		       ld $s0, 0($sp)
	 	                               ld $s1, 8($sp)
		                               daddi $sp, $sp, 16
		                               jr $ra

		increment_for2: daddi $s0, $s0, 1 ; increment i++
		j for2

;	return a1;
	end_for2.2: move r1, $a1
	                   ld $s0, 0($sp)
	 	       ld $s1, 8($sp)
		       ld $s1, 16($sp)
		       daddi $sp, $sp, 16
		       jr $ra
; }

#include input_unsigned.s
