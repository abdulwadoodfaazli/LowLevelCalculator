#
# Usage: ./calculator <op> <arg1> <arg2>
#

# Make `main` accessible outside of this module
.global main

# Start of the code section
.text

# int main(int argc, char argv[][])
main:
  # Function prologue
  enter $0, $0

  # Variable mappings:
  # op -> %r12
  # arg1 -> %r13
  # arg2 -> %r14
  movq 8(%rsi), %r12  # op = argv[1]
  movq 16(%rsi), %r13 # arg1 = argv[2]
  movq 24(%rsi), %r14 # arg2 = argv[3]


  # Converting 1st operand to a long int from a string
  # moving to %rdi as argument to atol() function
  movq %r13, %rdi
  call atol
  # output of atol() function is in %rax, so moving it back to the register we were using earlier
  movq %rax, %r13

  # Converting 2nd operand to a long int from a string
  # moving to %rdi as argument to atol() function
  movq %r14, %rdi
  call atol
  # output of atol() function is in %rax, so moving it back to the register we were using earlier
  movq %rax, %r14

  # Copying the first char of operator into an 8-bit register i.e., op_char = op[0]
  mov 0(%r12), %r12b
  
  # comparing ascii value of + with %r12b
  cmp $43, %r12b
  je add

  # comparing ascii value of - with %r12b
  cmp $45, %r12b
  je subtract

  # comparing ascii value of * with %r12b
  cmp $42, %r12b
  je multiply
 
  # comparing ascii value of / with %r12b
  cmp $47, %r12b
  je divide

  # if we haven't jumped to any label yet, that means we don't have a valid operator, so we deal with this case
  jmp unknown_error

  # for dealing with addition
  add:
    add %r14, %r13
    # preparing our data to be displayed
    mov $format, %rdi
    mov %r13, %rsi
    jmp final_print

  # for dealing with subtraction
  subtract:
    sub %r14, %r13
    # preparing our data to be displayed
    mov $format, %rdi
    mov %r13, %rsi
    jmp final_print

  # for dealing with multiplication
  multiply:
    imul %r14, %r13
    # preparing our data to be displayed
    mov $format, %rdi
    mov %r13, %rsi
    jmp final_print

  # for dealing with division
  divide:
    # first checking if division is by 0 or not and dealing with it correspondingly
    cmp $0, %r14
    je zero_error

    # since idiv uses rax register, moving our value to it
    mov %r13, %rax
    # sign-extension of rax into rdx
    cqo
    idiv %r14
    # preparing our data to be displayed
    mov $format, %rdi
    mov %rax, %rsi
    jmp final_print
  
  # for dealing with the case when a valid operation hasn't been provided
  unknown_error:
    mov $unknown_op_error, %rdi
    jmp final_print

  # for dealing with division by zero
  zero_error:
    mov $div_by_zero_error, %rdi
    jmp final_print

  # printing out the result at the end
  final_print:
    # to return 1 from the main function (as specified)
    mov $1, %rax
    mov $0, %al
    call printf

  # Function epilogue
  leave
  ret

# Start of the data section
.data

format: 
  .asciz "%ld\n"

unknown_op_error:
  .asciz "Unknown Operation\n"

div_by_zero_error:
  .asciz "Division by zero not possible\n"
