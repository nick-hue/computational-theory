%{  
  #include <stdio.h>
  #include <stdlib.h>
  #include <string.h>
  #include "cgen.h"
  #include "myanalyzer.tab.h"
  
  int lineNum = 1;
%}


ID      [a-zA-Z_][0-9a-zA-Z_]*
DIGIT   [0-9]
NUMBER  [+-]?{DIGIT}{DIGIT}*
DECIMAL ([+-]?"."{NUMBER})|([+-]?{NUMBER}("."{NUMBER}?)?)
REAL    {DECIMAL}([eE][+-]?{NUMBER})?
STRING	\"[^'\n]*\"

%%

integer		return KW_INT;
scalar 		return KW_SCALAR;
str			return KW_STRING;
boolean		return KW_BOOLEAN;
True		return KW_TRUE;
False		return KW_FALSE;
const		return KW_CONST;
if          return KW_IF;
else	    return KW_ELSE;
endif	    return KW_ENDIF;	
for 		return KW_FOR;
in			return KW_IN;
endfor		return KW_ENDFOR;
while		return KW_WHILE;
endwhile	return KW_ENDWHILE;
break		return KW_BREAK;
continue	return KW_CONTINUE;
not			return KW_NOT;
and 		return KW_AND;
or 			return KW_OR;
def			return KW_DEF;
enddef		return KW_ENDDEF;
main		return KW_MAIN;
return		return KW_RETURN;
comp		return KW_COMP;
endcomp		return KW_ENDCOMP;
of			return KW_OF;


{ID}        	{ yylval.str = strdup(yytext); /*printf("Identifier : ");*/ return TK_IDENT; }
{NUMBER}    	{ yylval.str = strdup(yytext); return TK_NUMBER; }
{REAL}      	{ yylval.str = strdup(yytext); return TK_REAL; }
{STRING}		{ yylval.str = strdup(yytext); return TK_STRING; }

"+="		/*printf("Increment operator : ");*/ return KW_INCR;
"-="		/*printf("Decrement operator : ");*/ return KW_DECR;
"*="		/*printf("Times Increment operator :");*/ return KW_TIMES_INCR;
"/="		/*printf("Divide Decrement operator : ");*/ return KW_DIV_DECR;
"%="		/*printf("Mod Decrement operator ");*/ return KW_MOD_DECR;

";"			/*printf("Semicolon : ");*/ return ';';
"("			/*printf("Left Parenthesis : ");*/ return '(';
")"			/*printf("Right Parenthesis :");*/ return ')';
","			/*printf("Comma :");*/ return ',';
"["			/*printf("Left Bracket : ");*/ return '[';
"]"			/*printf("Right Bracket : ");*/ return ']';
":"			/*printf("Colon :");*/ return ':';
"."			/*printf("Dot : ");*/ return '.';
"#"			/*printf("Hashtag : ");*/ return '#';

"+"         /*printf("Plus operator :");*/ return '+';
"-"         /*printf("Minus operator :");*/ return '-';
"*"         /*printf("Times operator :");*/ return '*';
"/"         /*printf("Divide operator : ");*/ return '/';
"%"			/*printf("Mod operator :");*/ return '%';
"**"		/*printf("Power operator :");*/ return KW_POW;

"=="		/*printf("Equality operator :");*/ return KW_EQ;
"!="		/*printf("Inequality operator :");*/ return KW_NOTEQ;
"<"			/*printf("Less operator :");*/ return '<';
"<="		/*printf("Less Equal operator :");*/ return KW_LESSEQ;
">"			/*printf("Greater operator :");*/ return '>';
">="		/*printf("Greater Equal operator :");*/ return KW_GREATEREQ;
":="		/*printf("Colon Equal operator :");*/ return KW_COLONEQ;
"="			/*printf("Assign operator :");*/ return '=';
"->"		/*printf("Function arrow :");*/ return KW_ARROW_FUNCTION;

"--"[^\n]*  printf("//Line %d: line comment: %s\n", lineNum, yytext);/* eat line comments */

[ \r\t]+		/* eat whitespace */
\n 					 ++lineNum;

<<EOF>> 	return EOF;
.           { printf("Line %d Lexical Error: Unrecognized literal %s\n", lineNum, yytext); }
%%


