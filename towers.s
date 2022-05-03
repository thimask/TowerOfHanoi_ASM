    .arch armv8-a
	 .text

    .global	print
print:
      stp    x29, x30, [sp, -16]! //Store FP, LR.
      add    x29, sp, 0
      mov    x3, x0
      mov    x2, x1
      ldr    w0, startstring
      mov    x1, x3
      bl     printf
      ldp    x29, x30, [sp], 16
      ret

startstring:
	.word	string0

    .global	towers
towers:
   /* Save calllee-saved registers to stack */
   stp x29, x30, [sp, -64]!
   add x29, sp, 0
   str x19, [x29, 16]
   str x20, [x29, 24]
   str x21, [x29, 32]
   str x22, [x29, 40]
   str x23, [x29, 48]


   /* Save a copy of all 3 incoming parameters to callee-saved registers */
   mov x19, x0
   mov x20, x1
   mov x21, x2

if:
   /* Compare numDisks with 2 or (numDisks - 2)*/
   cmp x0, #2
   /* Check if less than, else branch to else */
   bgt else  
   /* set print function's start to incoming start */
   mov x0, x1
   /* set print function's end to goal */
   mov x1, x2 
   /* call print function */
   bl print
   /* Set return register to 1 */
   mov x0, #1
   /* branch to endif */
   b endif 
else:
   /* Use a callee-saved varable for temp and set it to 6 */
   mov x22, #6
   /* Subract start from temp and store to itself */
   sub x22, x22, x1
   /* Subtract goal from temp and store to itself (temp = 6 - start - goal)*/
   sub x22, x22, x2
   /* subtract 1 from original numDisks and store it to numDisks parameter */
   sub x0, x19, #1

   /* Set end parameter as temp */
   mov x2, x22
   /* Call towers function */
   bl towers
   /* Save result to callee-saved register for total steps */
   mov x23, x0
   /* Set numDiscs parameter to 1 */
   mov x0, #1
   /* Set start parameter to original start */
   mov x1, x20
   /* Set goal parameter to original goal */
   mov x2, x21
   /* Call towers function */
   bl towers
   /* Add result to total steps so far */
   add x23, x23, x0
   
   /* Set numDisks parameter to original numDisks - 1 */
   sub x0, x19, #1
   /* set start parameter to temp */
   mov x1, x22
   /* set goal parameter to original goal */
   mov x2, x21
   /* Call towers function */
   bl towers
   /* Add result to total steps so far and save it to return register */
   add x0, x23, x0

endif:
   /* Restore Registers */
   ldr x19, [x29, 16]
   ldr x20, [x29, 24]
   ldr x21, [x29, 32]
   ldr x22, [x29,40]
   ldr x23, [x29,48]
   ldp x29, x30, [sp], 64
   ret
   /* Return from towers function */

// Function main is complete, no modifications needed
    .global	main
main:
      stp    x29, x30, [sp, -32]!
      add    x29, sp, 0
      ldr    w0, printdata 
      bl     printf
      ldr    w0, printdata + 4
      add    x1, x29, 28
      bl     scanf
      ldr    w0, [x29, 28] /* numDisks */
      mov    x1, #1 /* Start */
      mov    x2, #3 /* Goal */
      bl     towers
      mov    w4, w0
      ldr    w0, printdata + 8
      ldr    w1, [x29, 28]
      mov    w2, #1
      mov    w3, #3
      bl     printf
      mov    x0, #0
      ldp    x29, x30, [sp], 32
      ret
end:

printdata:
	.word	string1
	.word	string2
	.word	string3

string0:
	.asciz	"Move from peg %d to peg %d\n"
string1:
	.asciz	"Enter number of discs to be moved: "
string2:
	.asciz	"%d"
	.space	1
string3:
	.ascii	"\n%d discs moved from peg %d to peg %d in %d steps."
	.ascii	"\012\000"
