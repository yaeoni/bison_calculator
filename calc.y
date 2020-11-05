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

/* For additional operations (assignment2-2) : '^', '%', '**'(='p') */
/* Modulo연산은 Integer형만 지원. -> 연산 시 int형으로 강제 캐스팅을 하였습니다! */
%left '*' '/' '%'
%right '^' 
%right 'p' // 'p' = '**' 연산자 위한 숫자 정의

%%
/* grammar rule */

input   :                  
        | input line        
        ;
       
line    : expr '\n'         { printf("결과값 : %f\n", $$); postval = $$;}  // For remembering last calculated value, assign present calculated value to postval.
        | error '\n'        
        | '\n'              { printf("어떠한 입력도 하지 않으셨습니다. 입력을 해주세용~\n"); } // '\n'을 legitimate하게 만들기 위한 rule 추가 (assignment2-3)
        ;    

expr    : expr '+' term     { $$ = $1 + $3; }
        | expr '-' term     { $$ = $1 - $3; }
        | term              { $$ = $1; }
        ;

term    : term '*' elem   { $$ = $1 * $3; }
        | term '/' elem   { $$ = $1 / $3; }
        | term '%' elem   { $$ = (int)$1 % (int)$3; } // modulo 연산 위해 int형으로 강제 캐스팅
        | elem            { $$ = $1; }
        ;

// '^' 연산을 위한 non terminal 기호 추가
elem    : elem '^' factor   { $$ = pow($1, $3); }
        | elem 'p' factor  { $$ = pow($1, $3); } // 'p' == '**'를 위해서 만든 임의의 연산기호
        | factor            { $$ = $1;  }
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
    
    if(isdigit(c)){
        yylval = c - '0';
        while(isdigit(c=getchar()))
            yylval = 10*yylval + (c-'0');
        if(c>=0) ungetc(c, stdin);
        return NUMBER;
    }else if( c == '*'){
        if((c = getchar()) == '*'){
            return 'p';
        }else{
            ungetc(c, stdin);
        }

    }
    return c;
}

void yyerror(const char *errmsg){
    fprintf(stderr, "%s\n", errmsg);
}

int main(){
    printf("계산식을 입력해주세요.\n");
    yyparse();
}