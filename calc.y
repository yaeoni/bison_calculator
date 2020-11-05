/* C and bison declaration */
/* 20180084 오예원 */

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

/* For additional operations (assignment2-2) : '^', '%' */
/* Modulo연산은 Integer형만 지원. -> 연산 시 int형으로 강제 캐스팅을 하였습니다! */
%left '*' '/' '%'
%right '^'
%token EMPTY

%%
/* grammar rule */

input   :                  
        | input line
        ;

        // For remembering last calculated value, assign present calculated value to postval.
line    : expr '\n'         { printf("Result value : %f\n", $$); postval = $$;} 
        | error '\n'        { printf("error here\n"); }
        ;    

expr    : expr '+' term     { $$ = $1 + $3; }
        | expr '-' term     { $$ = $1 - $3; }
        | term              { $$ = $1; printf("다시 입력해주세요4.\n"); }
        ;

term    : term '*' elem   { $$ = $1 * $3; }
        | term '/' elem   { $$ = $1 / $3; }
        | term '%' elem   { $$ = (int)$1 % (int)$3; } // modulo 연산 위해 int형으로 강제 캐스팅
        | elem            { $$ = $1; printf("다시 입력해주세요3. %f\n", $$); }
        ;

elem    : elem '^' factor   { $$ = pow($1, $3); }
        | factor            { $$ = $1; printf("다시 입력해주세요2.%f \n", $$); }
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
    //if(c == '+' || c == '-') return c;
    
    if(isdigit(c)){
        yylval = c - '0';
        while(isdigit(c=getchar()))
            yylval = 10*yylval + (c-'0');
        if(c>=0) ungetc(c, stdin);
        return NUMBER;
    }
    //if(c == '\n') return EMPTY;
    if (c == EOF)
        return 0;
    
    //if(c=='_') return c;

    return c;
}

void yyerror(const char *errmsg){
    fprintf(stderr, "%s\n", errmsg);
}

int main(){
    yyparse();
}