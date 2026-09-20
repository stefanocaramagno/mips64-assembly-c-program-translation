; Programma in C

 ; int processa(char *st, int d){ 	
 ;	int j,valore;			
 ;	valore=0;
 ;          for(j=0;j<d;j++)
 ;		if(st[j]<58)
 ;			valore = valore+1;
 ; 		else valore= (valore+1)*2;
 ; 
 ;	return valore;
 ; }

 ; main() {
 ; 	char STR[16];
 ; 	int i,num,ris; 
 
 ; 	for(i=0;i<4;i++){
 ;		do{
 ;			printf("Inserisci una stringa con almeno 4 caratteri\n");
 ; 			scanf("%s",STR);
 ; 			if(strlen(STR)<4)
 ; 				printf("Stringa troppo corta\n"); 
 ;		 } while (strlen(STR)<4);
 
 ; 		ris= processa(STR,strlen(STR));
 ; 		if(ris==strlen(STR)) {
 ;			printf("Inserisci un numero a una cifra");
 ; 			scanf("%d",&num);
 ; 			ris+=num;
 ;		} 
 ; 		printf(" Valore= %d \n",ris); 
 ;	 }
 ; }

; -----------------------------------------------------------------------------------------------

; Traduzione in Assembly 

.data
; printf("Inserisci una stringa con almeno 4 caratteri\n")
; printf("Stringa troppo corta\n"); 
; printf("Inserisci un numero a una cifra");
; printf("Valore= %d \n",ris); 
msg1: .asciiz "Inserisci una stringa con almeno 4 caratteri\n"
msg2: .asciiz "Stringa troppo corta\n"
msg3: .asciiz "Inserisci un numero a una cifra"
msg4: .asciiz "Valore= %d \n"

p1sys5: .space 8
ris: .space 8

; scanf("%s",STR)
STR: .word 16
p1sys3: .word 0
ind3: .space 8
dim3: .word 16

.code
 ; main() {
 ; 	char STR[16];
 ; 	int i,num,ris; 
 ; 	for(i=0;i<4;i++){
	daddi $s0, $0, 0 ; index i=0
	for1:
		slti $t0, $s0, 4
		beq $t0, $0, end_for1

 ;		do{
		do:
 ;			printf("Inserisci una stringa con almeno 4 caratteri\n");
			daddi $t1, $0, msg1
			sd $t1, p1sys5($0)
			daddi r14, $0, p1sys5
			syscall 5

 ; 			scanf("%s",STR);
			daddi $t1, $0, STR
			sd $t1, ind3($0)
			daddi r14, $0, p1sys3
			syscall 3
			move $s1, r1

 ; 			if(strlen(STR)<4)
			if1: 
				daddi $t1, $0, 4
				slt $t2, $s1, $t1
				beq $t2, $0, processa
				
 ; 				printf("Stringa troppo corta\n"); 
				daddi $t1, $0, msg2
				sd $t1, p1sys5($0)
				daddi r14, $0, p1sys5
				syscall 5

 ;		 } while (strlen(STR)<4);
 		j do

 ; 		ris= processa(STR,strlen(STR));
		daddi $a0, $0, STR
		move $a1, $s1
		j processa
		sd r1, ris($0)
		move $s2, r1

 ; 		if(ris==strlen(STR)) {
		if2: 
			beq $s1, $s2, vero
			vero:
 ;				printf("Inserisci un numero a una cifra");
				daddi $t1, $0, msg3
				sd $t1, p1sys5($0)
				daddi r14, $0, p1sys5
				syscall 5

 ; 				scanf("%d",&num);
				jal input_unsigned
				move $s3, r1

 ; 				ris+=num;
				dadd $s1, $s1, $s3
 ;		} 

 ; 		printf(" Valore= %d \n",ris); 
		sd $t2, ris($0)
		daddi $t1, $0, msg4
		sd $t1, p1sys5($0)
		daddi r14, $0, p1sys5
		syscall 5

		increment_for1: daddi $s0, $0, 1 ;increment i++
		j for1;
 ;	 }
	end_for1: syscall 0
 ; }

 ; int processa(char *st, int d){ 	
processa: daddi $sp, $sp, -16 ; allocazione della memoria
 	    sd $s0, 0($sp)
	    sd $s1, 8($sp)

 ;	int j,valore;			
 ;	valore=0;
	daddi $s2, $0, 0

 ;          for(j=0;j<d;j++)
	daddi $s3, $0, 0 ; index j=0
	for2:
		slti $t0, $s0, $a1
		beq $t0, 0, end_for2

 ;		if(st[j]<58)
		if3: 
			dadd $t1, $a0, $s3
			lbu $t2, 0($t1)
			slti $t3, $t2, 58
			beq $t3, $0, else

 ;			valore = valore+1;
			daddi $s2, $s2, 1
		
 ; 		else valore= (valore+1)*2;
		else:
			daddi $s2, $s2, 1
  			dsll $s2, $s2, 1

		increment_for2: daddi $s2, $s2, 1 ; index j++
		j for2

 ;	return valore;
	end_for2: move r1, $s2
	                ld $s0, 0($sp)
		    ld $s1, 8($sp)
		    daddi $sp, $sp, 16 ; deallocazione della memoria
		    jr $ra
 ; }

#include input_unsigned.s