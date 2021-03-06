Your task is to design and write a 64 bit NASM program fproj.asm that behaves like the python program fproj.py -- do not forget to make sure that it is a UNIX text file by running dos2unix fproj.py after you transferred/downloaded it to moore).
The program computes the border array of the input string and displays it in a simple way (as an array of numbers), and in a fancy way (as a bar diagram), see the python program fproj.py
 
The program has to have the following subprograms:
maxbord that gets two parameters on stack, one is an address of a string and the other is the string's length. It computes the size of the maximal border of the string and returns the number via RAX register. The python code of maxbord in fproj.py shows the algorithm to compute the size of the maximal border of a string.
 
simple_display that gets two parameters on stack, one is an address of an array, and the other is the array's length. It displays the integer values stored in the array separated by commas. The python code of simple_display in fproj.py shows the algorithm to display an array.
 
fancy_display that gets two parameters on stack, one is an address of an array and the other is the array's length. It displays the integer values stored in the array in a form of a bar chart, execute the python program fproj.py to see how the graph should look like. The sample program fproj.py utilizes another subprogram display_line , however, it is up to you how to implement fancy_display .
 
What the program does:
The program gets the input string as the first command line argument. For instance, to compute the border array for abcdabcdab it should be executed as fproj abcdabcdab .
After checking the number of command lines arguments, it checks the length of the input string (it is argv[1]) by traversing the string and counting the number of its characters.
If the string is longer than 12, the program displays an error message and terminates, otherwise it stores the value in a variable or a register and continues.
Then it traverses the input string yet again and calls maxbord on the suffix (i.e. if at position i, it will invoke maxbord for the string argv[1][i..L-1] where L is the length of the string argv[1]). It stores the number returned by maxbord in the array.
Then calls simple_display to display the computed array.
Then it calls fancy_display to display the computed array.
After that, the program terminates.
 
fproj.py is a python 3 program and on moore must be executed by python3 fproj.py abcdabcdab
Experiment with different input strings:
python3 fproj.py aababaa
python3 fproj.py aaaa
python3 fproj.py abcdaddad
python3 fproj.py abcdddd
 
For a better understanding of what the program does:
 
A border of a string x[0..n???1] of length n is a substring x[0..k], 0 = k < n???1 so that x[0..k] = x[n???k..n???1], or, in the proper terminology, that is simultaneously a prefix and a suffix of the string. For illustration, ababbcd does not have a border, ababbca has a border a, the string abab has a border ab, while ababa has a border a, and also aba .
 
The border array bordar[0..n???1] of a string x[0..n???1] is an array of size n , where bordar[i] = size of the maximal border of the string x[i..n-1] . For example, for abcdabcdab, the maximal border for abcdabcdab is abcdab, and so bordar[0] = 6 . For bcdabcdab, the maximal border is bcdab , and so bordar[1] = 5 . For cdabcdab , the maximal border is cdab , and so bordar[2] = 4 . For dabcdab, the maximal border is dab,
and so bordar[3] = 3. For abcdab, the maximal border is ab, and so bordar[4] = 2. For bcdab, the maximal border is b, and so bordar[5] = 1. For cdab, there is no border, and so bordar[6] = 0. For dab, there is no border, and so bordar[7] = 0 . For ab, there is no border, and so bordar[8] = 0. For b, there is no border, and so bordar[9] = 0 . Thus, the border array of abcdabcdab is 6,5,4,3,2,1,0,0,0,0.
