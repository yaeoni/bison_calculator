calculator with bison

$ bison calc.y
$ gcc -o a calc.tab.c
$ ./a

- Adding a special variable "_" which can remember last calculated value.
- Add '^' for power, '%' for modulo
- Allow '\n'(am empty line) as a legitimate expression.
