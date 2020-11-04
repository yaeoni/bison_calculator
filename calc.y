/* C and bison declaration */

%{
    #include <stdio.h>
    #include <math.h>
    #include <ctype.h>

    #define YYSTYPE double

    int yylex(void);
    void yyerror(const char *);
    YYSTYPE yylval;

    /* For a special value requested in assignment2-1. Remember last calculated value, initial value is 0. */
    YYSTYPE postval = 0;
%}

%token NUMBER
%left '+' '-'
%left '*' '/'

%%
/* grammar rule */

input   :
        | input line
        ;

        // For remembering last calculated value, assign present calculated value to postval.
line    : expr '\n'         { printf("Result value : %f\n", $$); postval = $$;} 
        | error '\n'        { printf("error here\n");  }
        ;    

expr    : expr '+' term     { $$ = $1 + $3; }
        | expr '-' term     { $$ = $1 - $3; }
        | term              { $$ = $1; }
        ;

term    : term '*' factor   { $$ = $1 * $3; }
        | term '/' factor   { $$ = $1 / $3; }
        | factor            { $$ = $1; }
        ;

factor  : '(' expr ')'      { $$ = $2; }
        | NUMBER            { $$ = $1; }
        | '-' NUMBER        { $$ = -$2; }
        | '_'               { $$ = postval; }
        ;

%%
/* Additional C Code */

int yylex(void){
    int c = getchar();
    if (c < 0) return 0;
    if(c == '+' || c == '-') return c;
    
    if(isdigit(c)){
        yylval = c - '0';
        while(isdigit(c=getchar()))
            yylval = 10*yylval + (c-'0');
        if(c>=0) ungetc(c, stdin);
        return NUMBER;
    }
    if (c == EOF)
        return 0;
    if(c=='_') return c;

    return c;
}

void yyerror(const char *errmsg){
    fprintf(stderr, "%s\n", errmsg);
}

int main(){
    yyparse();
}