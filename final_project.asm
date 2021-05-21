%include "simple_io.inc"
global asm_main

section .data
  mes1: db "incorrect number of command line arguments",0
  mes2: db "input string too long",0
  mes3: db "input string: ",0
  mes4: db "border array:",0
  plus: db "+++  ",0
  dot:     db "...  ",0
  space: db "     ",0
  border dq 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

section .text

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


  simple_display:
     enter 0,0
     saveregs
     
     mov     r15, [rbp+24]    ;;bordar array
        mov     r14, [rbp+32]    ;;length of string
     mov      rax, mes4
     call     print_string
     mov     rax, [r15]
     call     print_int     ;;print first index

     mov     r12, qword 1     ;;r12 is i
     add     r15, qword 8     ;;increase index by one

     FOR6:
          cmp      r12,r14
          je       simple_display_end
          mov      rax, ','
          call      print_char
          mov      rax, ' '
          call      print_char
          mov      rax,[r15]
          call      print_int
          add      r15, qword 8     ;;increase index by one
          inc      r12
          jmp      FOR6     

  simple_display_end:
     restoregs
     leave 
     ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


  maxbord:
        enter 0,0
        saveregs

        mov      r14, qword 0     ;;r14 is max = 0
        mov      r12, [rbp+32]    ;;r12 is L
        mov     r13, qword 1     ;;r13 is r
        mov     rbx, [rbp+24]    ;;rbx is string

   FOR4:
        cmp      r13, r12
        jge      FOR4_END

        mov      r15, qword 1        ;;r15 = isborder
        mov      r11, qword 0        ;;r11 is counter (i)

        FOR5:
                cmp      r11, r13
                jge      FOR5_END

                mov      r10, r11
                add      r10, rbx

                mov      r9, r12
                sub      r9, r13
                add      r9, r11
                mov      rax, qword 8
                mul      r9
                add      r9, rbx     ;;r9 holds string at (L-r+i)

                mov      al, byte [r9]
                mov      r8, qword 0
                mov      r8b, byte [r10]
                cmp      al, r8b
                je      CONTIN
                mov      r15, qword 0        
                jmp      FOR5_END       

              CONTIN:
                add      r11, 1
                jmp      FOR5

      FOR5_END:
        cmp      r15, qword 1
        jne      SKIP
        cmp      r14, r13
        jae      SKIP
        mov      r14, r13

      SKIP:
        add      r13, qword 1
        jmp      FOR4

 FOR4_END:
        mov      rax, r14 ;;return max

        restoregs
        leave
        ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  fancy_display:
     enter     0,0
     saveregs
     
     mov      rcx, [rbp+24]      ;;Bordar array
     mov      r13, [rbp+32]     ;;Length of string
     mov     r14, r13     ;;Level

  FOR2:
     mov      r12,rcx
     cmp      r14, qword 0
     je      fancy_display_END
     mov      rbx, qword 0     ;counter
     mov      r15, [r12]          ;;first digit of border array

     FOR3:
                inc      rbx          ;;counter +=1
                cmp      rbx, r13     ;;check if count > L
                jg      PRE_FOR2
                cmp      r14, qword 1
          jne      ELSE  
                cmp      r15, qword 0
                jg      PLUS
                jmp      DOT

        PLUS:
                mov      rax, plus
                call      print_string
                jmp      AFTER
        DOT:
                mov      rax,dot
                call      print_string
                jmp      AFTER
        SPACE:
                mov      rax,space
                call      print_string
                jmp      AFTER
        ELSE:
                cmp      r15, r14
                jl      SPACE
                jmp      PLUS
        AFTER:
                add      r12, qword 8
          mov      r15, [r12]
                jmp      FOR3
  PRE_FOR2:
     dec      r14
     call     print_nl
     jmp      FOR2

  fancy_display_END:
     restoregs
     leave
     ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  asm_main:
        enter   0,0
        saveregs

        cmp      rdi, qword 2
        jne      not2args
     
     mov      rbx, [rsi+8]
     
        mov      rcx,0          ;;initializing counter for string
        dec      rbx
  
            count:
                  inc      rcx
                  inc      rbx
                  cmp      byte [rbx],0
                  jnz      count
                  dec      rcx
               ;;rcx contains the string length

     cmp     rcx, qword 12
     jg     toolong
     
     mov      rax, mes3
     call     print_string
     mov      rax, [rsi+8]
     call      print_string
     call     print_nl


     cmp     rcx, 1
     je      IS_ONE          ;;checks specifically for if string is length 1 since 
                    ;;all 1 length input have the same output

     mov     r12, rcx     ;;L1
     dec      rcx          ;; L = L-1
     mov     r13, qword 0     ;;Counter/Index
     mov     r15, [rsi+8]     ;;String
     jmp      FOR1
     
  FOR1:
     push     qword r12
     push     qword r15
     sub     rsp,8
     call     maxbord
     add     rsp,24
     mov      rdx,rax
     mov      [border+r13*8], rdx
     mov     rax, [border+r13*8]
     dec     r12          ;;L1-1
     inc     r15          ;;String[i:]
     inc      r13
     cmp     r13, rcx
     jne     FOR1     
     jmp     NEXT

  NEXT:
     inc     rcx
     push     qword rcx
     push     qword border
     sub     rsp,8
     call     simple_display
     add     rsp,24
     call      print_nl
     push     qword rcx
     push      qword border
     sub      rsp,8
     call     fancy_display
     add     rsp,24
     jmp     END

  not2args:
        mov      rax,mes1
        call      print_string
     call     print_nl
        jmp      END

  toolong:
     mov      rax,mes2
     call      print_string
     call     print_nl
     jmp     END

  IS_ONE:
     mov      rax, mes4
     call     print_string
     mov      rax, '0'
     call      print_char
     call      print_nl
     mov      rax, dot
     call      print_string
     call      print_nl
     jmp      END

  END:
     restoregs
       leave
       ret