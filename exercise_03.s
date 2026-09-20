; Programma in C

; #include <stdio.h>
; #include <string.h>
; int elabora(char *st, int num){ 
; 	int s0,s1;
; 	s0=0;
; 	for(s1=0;s1<num;s1++)
; 		s0=s0+st[s1]-48;
;  	return s0;
; }

; main() {
; 	char STR[16];
;  	int val,i,a; 
;  
;  	for(i=0;i<3;i++) {
; 		printf("Inserisci una stringa contenente solo numeri\n");
;  		scanf("%s",STR);
; 		printf("Inserisci un numero minore di %d\n",strlen(STR));
; 		scanf("%d",&a);
;  		if(a<strlen(STR)) {
;			val= elabora(STR,a);
;  			printf(" Val = %d \n",val); 
;		 }
; 	 } 
; }

; -----------------------------------------------------------------------------------------------

; Traduzione in Assembly 

.data
; printf("Inserisci una stringa contenente solo numeri\n");
; printf("Inserisci un numero minore di %d\n",strlen(STR));
; printf(" Val = %d \n",val);
msg1: .asciiz "Inserisci una stringa contenente solo numeri\n"
msg2: .asciiz "Inserisci un numero minore di %d\n"
msg3: .asciiz " Val = %d \n"

p1sys5: .space 8
val: .space 8

; scanf("%s",STR);
STR: .space 16

p1sys3: .word 0
ind3: .space 8
dim3: .word 16

.code
; 	char STR[16];
;  	int val,i,a; 
;  	for(i=0; i<3; i++) {
	daddi $s0, $0, 0 ;index i=0
	for1:
		slti $t0, $s0, 3                 ;if(i<3) $t0 = 1; else $t0 = 0
		beq $t0, $0, end_for1    ;if $t0 = 0 --> end_for

; 		printf("Inserisci una stringa contenente solo numeri\n");
		daddi $t1, $0, msg1
		sd $t1, p1sys5($0)
		daddi r14, $0, p1sys5
		syscall 5	

;  		scanf("%s",STR);
		daddi $t1, $0, STR 
		sd $t1, ind3($0)
		daddi r14, $0, p1sys3
		syscall 3
		move $s1, r1 ;salvataggio del numero di caratteri con scanf in $s1		

; 		printf("Inserisci un numero minore di %d\n",strlen(STR));
		sd $s1, val($0)
		daddi $t1, $0, msg2
		sd $t1, p1sys5($0)
		daddi r14, $0, p1sys5
		syscall 5	
	
; 		scanf("%d",&a);
		jal input_unsigned
		move $s2, r1 ;salvataggio del numero letto con scanf in $s2

;  		if(a<strlen(STR)) {
		if: 
			slt $t1, $s2, $s1
			beq $t1, $0, increment_for1
			
;			val= elabora(STR,a);
			daddi $a0, $0, STR ; $a0 = STR
			move $a1, $s2        ; $a1 = a
			jal elabora 

;  			printf(" Val = %d \n",val); 
			sd r1, val($0)
			daddi $t1, $0, msg3
			sd $t1, p1sys5($0)
			daddi r14, $0, p1sys5
			syscall 5
;		 }
		increment_for1: daddi $s0, $s0, 1 ;increment i++
		j for1
; 	 } 
	end_for1: syscall 0
; }

; int elabora(char *st, int num){ 
elabora: daddi $sp, $sp, -16 ; allocazione della memoria
	   sd $s0, 0($sp)
	   sd $s1, 8($sp)

; 	int s0,s1;
; 	s0=0;
	daddi $s0, $0, 0

; 	for(s1=0; s1<num; s1++)
	daddi $s1, $0, 0 ;index s1=0
	for2:
		slti $t0, $s0, 3                 ;if(s1<num) $t0 = 1; else $t0 = 0
		beq $t0, $0, end_for2    ;if $t0 = 0 --> end_for
		
; 		s0=s0+st[s1]-48;
		dadd $t1, $a0, $s1 ;st[s1]= st+s1 = $a0+$s1
		lbu $t2, 0($t1)         ; $t2 = st[s1]
		daddi $t2, $t2, -48
		dadd $s0, $s0, $t2 ;  s0=s0+st[s1]-48;	

	increment_for2: daddi $s1, $s1, 1 ;increment s1++
	j for2

;  	return s0;
	end_for2: move r1 , $s0
	    	     ld $s0, 0($sp)
	                 ld $s1, 8($sp)
	                 daddi $sp, $sp, 16 ;deallocazione della memoria
	                 jr $ra
; }

#include input_unsigned.s
