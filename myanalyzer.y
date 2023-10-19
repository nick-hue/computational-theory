%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>	
	#include "cgen.h"
	int step_value;
	extern int yylex(void);
	extern int atoi (const char *ptr);
	extern int line_num;
	char* deff = NULL;
	
	char *replaceSubstring(const char *str, const char *from, const char *to) {
		char *result;
		char *ins;
		char *tmp;
		size_t len_from;
		size_t len_to;
		size_t len_front;
		size_t count;

		if (!str || !from)
		    return NULL;

		len_from = strlen(from);
		if (len_from == 0)
		    return NULL; // replacing empty substring is undefined
		if (!to)
		    to = "";

		len_to = strlen(to);

		ins = (char *)str;
		for (count = 0; (tmp = strstr(ins, from)); ++count) {
		    ins = tmp + len_from;
		}

		tmp = result = (char *)malloc(strlen(str) + (len_to - len_from) * count + 1);

		if (!result)
		    return NULL;

		while (count--) {
		    ins = strstr(str, from);
		    len_front = ins - str;
		    tmp = strncpy(tmp, str, len_front) + len_front;
		    tmp = strcpy(tmp, to) + len_to;
		    str += len_front + len_from;
		}
		strcpy(tmp, str);
    return result;
}
%}

%union
{
	char* str;
};

%token <str> TK_IDENT
%token <str> TK_NUMBER 
%token <str> TK_POS_INTEGER
%token <str> TK_REAL 
%token <str> TK_STRING

%token KW_INT
%token KW_SCALAR
%token KW_STRING
%token KW_BOOLEAN
%token KW_TRUE
%token KW_FALSE
%token KW_CONST
%token KW_IF
%token KW_ELSE
%token KW_ENDIF
%token KW_FOR
%token KW_IN
%token KW_ENDFOR
%token KW_WHILE
%token KW_ENDWHILE
%token KW_BREAK
%token KW_CONTINUE
%token KW_NOT
%token KW_AND
%token KW_OR
%token KW_DEF
%token KW_ENDDEF
%token KW_ARROW_FUNCTION
%token KW_MAIN
%token KW_RETURN
%token KW_COMP
%token KW_ENDCOMP
%token KW_OF

%token KW_POW
%token KW_EQ
%token KW_NOTEQ
%token KW_LESSEQ
%token KW_GREATEREQ
%token KW_COLONEQ
%token KW_INCR
%token KW_DECR
%token KW_TIMES_INCR
%token KW_DIV_DECR
%token KW_MOD_DECR

%start program

%type <str> expr_data_type data data_type 
%type <str> boolean_value array_value
%type <str> expr //begin
%type <str> declaration_list declaration variable_declaration variable_assign_declaration single_variable_declaration multiple_variable_declaration
%type <str> const_variable_declaration const_variable_assign_declaration single_const_variable_declaration multiple_const_variable_declaration
%type <str> statement_list statement assign_statement break_statement continue_statement return_statement if_statement if_for_while_body while_statement for_statement function_statement function_parameter_list assign_operator
%type <str> function_list function function_argument_list single_argument_function multiple_argument_function function_body expr_function 
%type <str> comp_list comp comp_body comp_variable comp_variable_declaration_list comp_variable_declaration comp_variable_assign_declaration single_comp_variable_declaration multiple_comp_variable_declaration comp_func_list comp_func comp_value comp_values


%left KW_AND KW_OR
%left '<' '>' KW_LESSEQ KW_GREATEREQ KW_EQ KW_NOTEQ
%left '-' '+'
%left '*' '/' '%'
%right KW_POW
%right '=' KW_INCR KW_DECR KW_TIMES_INCR KW_DIV_DECR KW_MOD_DECR KW_COLONEQ

%right KW_NOT

%nonassoc '(' ')'

%precedence KW_IF
%precedence KW_ELSE

%%

program:declaration_list statement_list function_list comp_list {

 	// Successful parse! Check for syntax errors and generate output. 
  
  if (yyerror_count == 0) {
    puts(c_prologue); // puts the kappalib library
    printf("//HERE1\n");
    puts("#include <math.h>\n#include <stdio.h>"); 
    printf("/* program */ \n\n");
    printf("%s\n", $1);
    printf("%s\n", $2);
    printf("%s\n", $3);
    printf("%s\n", $4);
	printf("\n\n");
  }
  
}
| comp_list function_list  {

 	// Successful parse! Check for syntax errors and generate output. 
  
  if (yyerror_count == 0) {
    puts(c_prologue); // puts the kappalib library
    printf("//HERE1test\n");
    puts("#include <math.h>\n#include <stdio.h>"); 
    printf("/* program */ \n\n");
    printf("%s\n", $1);
    printf("%s\n", $2);
	printf("\n\n");
  }
  
}
| statement_list {

 	// Successful parse! Check for syntax errors and generate output. 
  
  if (yyerror_count == 0) {
    printf("HERE2");
    puts(c_prologue); // puts the kappalib library
    puts("#include <math.h>\n#include <stdio.h>"); 
    printf("/* program */ \n\n");
    printf("%s\n", $1);
    printf("\n\n");
  }
}

| declaration_list function_list{

 	// Successful parse! Check for syntax errors and generate output. 
  
  if (yyerror_count == 0) {
    printf("//HERE3\n");
    puts(c_prologue); // puts the kappalib library
    puts("#include <math.h>\n#include <stdio.h>"); 
    printf("/* program */ \n\n");
    printf("%s\n", $1);
    printf("%s\n", $2);
    printf("\n\n");
  }
}
| function_list{

 	// Successful parse! Check for syntax errors and generate output. 
  
  if (yyerror_count == 0) {
    printf("//HERE4\n");
    puts(c_prologue); // puts the kappalib library
    puts("#include <math.h>\n#include <stdio.h>"); 
    printf("/* program */ \n\n");
    printf("%s\n", $1);
    printf("\n\n");
  }
}
| declaration_list{

 	// Successful parse! Check for syntax errors and generate output. 
  
  if (yyerror_count == 0) {
    printf("//HERE5\n");
    puts(c_prologue); // puts the kappalib library
    puts("#include <math.h>\n#include <stdio.h>"); 
    printf("/* program */ \n\n");
    printf("%s\n", $1);
    printf("\n\n");
  }
} 
| comp_list {

 	// Successful parse! Check for syntax errors and generate output. 
  
  if (yyerror_count == 0) {
    printf("//HERE6\n");
    puts(c_prologue); // puts the kappalib library
    puts("#include <math.h>\n#include <stdio.h>"); 
    printf("/* program */ \n\n");
    printf("%s\n", $1);
    printf("\n\n");
  }
}
| comp_list declaration_list function_list{

 	// Successful parse! Check for syntax errors and generate output. 
  
  if (yyerror_count == 0) {
    puts(c_prologue); // puts the kappalib library
    printf("//HERE7\n");
    puts("#include <math.h>\n#include <stdio.h>"); 
    printf("/* program */ \n\n");
    printf("%s\n", $1);
    printf("%s\n", $2);
    printf("%s\n", $3);
	printf("\n\n");
  }
}

| function_list comp_list declaration_list {

 	// Successful parse! Check for syntax errors and generate output. 
  
  if (yyerror_count == 0) {
    puts(c_prologue); // puts the kappalib library
    printf("//HERE7\n");
    puts("#include <math.h>\n#include <stdio.h>"); 
    printf("/* program */ \n\n");
    printf("%s\n", $1);
    printf("%s\n", $2);
    printf("%s\n", $3);
	printf("\n\n");
  }
}
;


// ---- FUNCTIONS ----

function_list:
	function_list function 		{ $$ = template("%s\n\n%s", $1, $2); }
	| function
	; 

function:
	KW_DEF KW_MAIN '(' ')' ':' function_body KW_ENDDEF ';' {$$ = template("int main () {\n%s\n}", $6); }
	| KW_DEF TK_IDENT '(' function_argument_list ')' KW_ARROW_FUNCTION data_type ':' function_body KW_ENDDEF ';' { $$ = template("%s %s(%s) {\n%s\n}", $7, $2, $4, $9); }
	| KW_DEF TK_IDENT '(' function_argument_list ')' ':' function_body KW_ENDDEF ';' { $$ = template("void %s(%s) {\n%s\n}", $2, $4, $7); }
	//| KW_DEF TK_IDENT '(' ')' ':' KW_ENDDEF ';' { $$ = template("void %s() {\n}", $2); }
	;
	
function_argument_list:
	function_argument_list multiple_argument_function 	{ $$ = template("%s %s", $1, $2); }
	| single_argument_function							{ $$ = template("%s", $1);  }
	;
	
single_argument_function:
	TK_IDENT ':' data_type				{ $$ = template("%s %s", $3,$1); }
	| TK_IDENT '[' ']' ':' data_type	{ $$ = template("%s *%s", $5,$1);}
	| %empty							{ $$ = ""; }
	;
	
multiple_argument_function:
	',' TK_IDENT ':' data_type			{ $$ = template(",%s %s", $4,$2); }
	| ',' TK_IDENT '[' ']' ':' data_type	{ $$ = template(",%s *%s", $6,$2); }
	;
	
function_body:
	function_body declaration 	{ $$ = template("%s\n%s", $1, $2); }
	| function_body statement	{ $$ = template("%s\n%s", $1, $2); }
	| %empty					{ $$ = ""; }
	;

// ---- DATA TYPES ---- 

data:
	expr			{ $$ = template("%s", $1); }
	| TK_STRING		{ $$ = template("%s", $1); }
	;
	
data_type:
	KW_INT 			{ $$ = "int"; }
	| KW_SCALAR	 	{ $$ = "double"; }
	| KW_STRING 	{ $$ = "char*"; }
	| KW_BOOLEAN	{ $$ = "int"; }
	| TK_IDENT		{ $$ = template("%s", $1); }
	;

boolean_value:
 	KW_TRUE 		{ $$ = "1"; }
	| KW_FALSE 		{ $$ = "0"; }
	;
	
array_value:
	TK_IDENT '[' expr ']'				{ $$ = template("%s[%s]", $1, $3); }
	| TK_IDENT '[' ']'					{ $$ = template("%s*", $1); }
	| comp_variable '[' ']' 			{ $$ = template("self->%s[]", $1); }
	| comp_variable '[' expr ']' 		{ $$ = template("self->%s[%s]", $1, $3); }
	;

expr_data_type:
	TK_IDENT				{ $$ = template("%s", $1); }
	| TK_NUMBER				{ $$ = template("%s", $1); }
	| TK_REAL 				{ $$ = template("%s", $1); }
	| array_value			{ $$ = template("%s", $1); }
	| boolean_value 		{ $$ = template("%s", $1); }
	| comp_variable			{ $$ = template("%s", $1); } 
	//| TK_STRING			{ $$ = template("%s", $1); }
	;
	
expr:
	expr_data_type
	| '(' expr ')'			{ $$ = template("%s", $2); }
	| expr '+' expr 		{ $$ = template("%s + %s", $1, $3); }
	| expr '-' expr 		{ $$ = template("%s - %s", $1, $3); }
	| expr '*' expr 		{ $$ = template("%s * %s", $1, $3); }
	| expr '/' expr 		{ $$ = template("%s / %s", $1, $3); }
	| expr '%' expr 		{ $$ = template("%s %% %s", $1, $3); }
	| expr KW_POW expr 		{ $$ = template("pow(%s, %s)", $1, $3); } 	
	| expr KW_EQ expr		{ $$ = template("%s == %s", $1, $3); }
	| expr KW_NOTEQ	expr	{ $$ = template("%s != %s", $1, $3); }
	| expr '<' expr			{ $$ = template("%s < %s", $1, $3); }
	| expr KW_LESSEQ expr	{ $$ = template("%s <= %s", $1, $3); }
	| expr '>' expr 		{ $$ = template("%s > %s", $1, $3); }
	| expr KW_GREATEREQ expr{ $$ = template("%s >= %s", $1, $3); }
	| expr KW_AND expr 		{ $$ = template("%s && %s", $1, $3); }
	| expr KW_OR expr		{ $$ = template("%s || %s", $1, $3); }
	| KW_NOT				{ $$ = template("!"); }
	| KW_BREAK				{ $$ = template("break"); }
	| KW_CONTINUE			{ $$ = template("continue"); }
	| expr_function			{ $$ = template("%s", $1); } 
	| comp_values			{ $$ = template("%s", $1); } 
	;

declaration_list:
	declaration_list declaration 	{ $$ = template("%s\n%s", $1, $2); }
	| declaration					{ $$ = template("%s", $1);  }
	;
	
declaration: 
	variable_declaration  			{ $$ = template("%s",$1); }
	| const_variable_declaration 	{ $$ = template("%s",$1); }
	;	
	
// ---- VARIABLE DECLARATION ----

variable_declaration:
	variable_assign_declaration ';' { $$ = template("%s;",$1); }
	;
	
variable_assign_declaration:
	single_variable_declaration multiple_variable_declaration ':' data_type{ {$$ = template("%s %s %s",$4,$1,$2);} } 
	| single_variable_declaration ':' data_type { $$ = template("%s %s", $3, $1); }
	;
	
single_variable_declaration:
	TK_IDENT '=' data			{ $$ = template("%s = %s", $1, $3); }
	| TK_IDENT 					{ $$ = template("%s", $1); }
	| array_value 				{ $$ = template("%s", $1); }
	| array_value '=' expr 		{ $$ = template("%s = %s", $1, $3); }
	;
	
multiple_variable_declaration:
	multiple_variable_declaration ',' TK_IDENT '=' data { $$ = template("%s, %s = %s",$1, $3, $5);}
	| multiple_variable_declaration ',' TK_IDENT { $$ = template("%s, %s ",$1,$3);}
	| multiple_variable_declaration ',' array_value '=' expr {{$$ = template("%s, %s = %s",$1,$3, $5);}} 
	| multiple_variable_declaration ',' array_value { $$ = template("%s, %s",$1,$3);}
	| ',' TK_IDENT '=' expr 						{ $$ = template(", %s = %s",$2,$4);}
	| ',' TK_IDENT 									{ $$ = template(", %s ",$2);}
	| ',' array_value '=' expr						{ $$ = template(", %s = %s",$2,$4);} 
	| ',' array_value								{ $$ = template(", %s ",$2);}
	;
			
// ---- CONST VARIABLE DECLARATION ----

const_variable_declaration:
	KW_CONST const_variable_assign_declaration ';' { $$ = template("const %s;",$2); }
	;	
	
const_variable_assign_declaration:
	single_const_variable_declaration multiple_const_variable_declaration ':' data_type { {$$ = template("%s %s %s",$4,$1,$2);} } 
	| single_const_variable_declaration ':' data_type { $$ = template("%s %s",$3,$1);}
	;
	
single_const_variable_declaration:
	TK_IDENT '=' data { $$ = template("%s = %s",$1,$3);}
	;
	
multiple_const_variable_declaration:
	multiple_const_variable_declaration ',' TK_IDENT '=' data { $$ = template("%s, %s = %s",$1,$3,$5);}
	| ',' TK_IDENT '=' data { $$ = template(", %s = %s",$2,$4);}
	;
	
// ---- STATEMENTS ----

statement_list:
	statement_list statement 		{ $$ = template("%s\n%s", $1, $2); } 
	| statement  					{ $$ = template("%s", $1); }	
	;

statement:
	assign_statement			{ $$ = $1; }
	| break_statement			{ $$ = $1; }
	| continue_statement		{ $$ = $1; }
	| return_statement			{ $$ = $1; }
	| if_statement				{ $$ = $1; }
	| while_statement			{ $$ = $1; }
	| for_statement				{ $$ = $1; }
	| function_statement 		{ $$ = $1; }
	;

assign_statement:
	TK_IDENT '=' expr ';'								{ $$ = template("%s = %s;", $1, $3); }
	| TK_IDENT '=' '-' expr ';'							{ $$ = template("%s = -%s;", $1, $4); }
	| TK_IDENT '.' comp_variable '=' expr ';'			{ $$ = template("%s.%s = %s;", $1, $3, $5); }
	| TK_IDENT '.' comp_variable '=' '-' expr ';'		{ $$ = template("%s.%s = -%s;", $1, $3, $6); }
	| array_value '=' expr ';' 							{ $$ = template("%s = %s;", $1, $3); }
	| comp_variable '=' expr ';'						{ $$ = template("self->%s = %s;", $1, $3); }
	| comp_variable '=' '-' expr ';'					{ $$ = template("self->%s = -self->%s;", $1, $4); }
	| TK_IDENT assign_operator expr ';' 				{ $$ = template("%s %s %s;", $1, $2, $3); }
	| comp_variable assign_operator expr ';' 			{ $$ = template("self->%s %s %s;", $1, $2, $3); }
	| TK_IDENT KW_COLONEQ '[' expr KW_FOR TK_IDENT ':' TK_NUMBER ']' ':' data_type ';' { $$ = template("%s* %s = (%s*)malloc(%s * sizeof(%s));\nfor (int %s=0; %s < %s; ++%s){\n%s[%s] = %s;\n}", $11, $1, $11, $8, $11, $6, $6, $8, $6, $1, $6, $4); }
	| TK_IDENT KW_COLONEQ '[' expr KW_FOR TK_IDENT ':' data_type KW_IN TK_IDENT KW_OF TK_NUMBER ']' ':' data_type ';' { 
	char* res = (char *)malloc(strlen($10));
	sprintf(res, "%s[%s_i]", $10, $10);
	char* final_char = replaceSubstring($4, $6, res);
	free(res);
	$$ = template("%s* %s = (%s*)malloc(%s * sizeof(%s));\nfor (int %s_i=0; %s_i < %s; ++%s_i){\n%s[%s_i] = %s;\n}", $15, $1, $15, $12, $15, $10, $10, $12, $10, $1, $10, final_char); }
	;
	
assign_operator:
	KW_INCR		 			{ $$ = template("+="); }
	| KW_DECR				{ $$ = template("-="); }
	| KW_TIMES_INCR			{ $$ = template("*="); }
	| KW_DIV_DECR			{ $$ = template("/="); }
	| KW_MOD_DECR			{ $$ = template("%="); }
	;
	
break_statement:
	KW_BREAK ';' 				{ $$ = "break; "; }
	;
	
continue_statement:
	KW_CONTINUE ';'				{ $$ = "continue; "; }
	;
	
return_statement:
	KW_RETURN ';'				{ $$ = "return;"; }
	| KW_RETURN expr ';' 		{ $$ = template("return %s;", $2); }
	;

if_statement:
	KW_IF '(' expr ')' ':' if_for_while_body KW_ENDIF ';' { $$ = template("if (%s) {\n%s\n}",$3,$6); }
	| KW_IF '(' expr ')' ':' if_for_while_body KW_ELSE ':' if_for_while_body KW_ENDIF ';'{ $$ = template("if (%s) {\n%s\n} else {\n%s\n}",$3,$6,$9); }
	;

if_for_while_body:
	if_for_while_body declaration 		{ $$ = template("%s\n%s", $1, $2); }
	| if_for_while_body statement		{ $$ = template("%s\n%s", $1, $2); }
	| %empty							{ $$ = ""; }
	;
	
while_statement:
	KW_WHILE '(' expr ')' ':' if_for_while_body KW_ENDWHILE ';'	{ $$ = template("while(%s) {\n%s\n} ",$3,$6); }
	;
	
for_statement:	
	KW_FOR TK_IDENT KW_IN '[' expr ':' expr ']' ':' if_for_while_body KW_ENDFOR ';' { $$ = template("for (int %s = %s; %s < %s; %s++) {\n%s\n}", $2, $5, $2, $7, $2, $10); }
	| KW_FOR TK_IDENT KW_IN '[' expr ':' expr ':' expr ']' ':' if_for_while_body KW_ENDFOR ';' { step_value = atoi($9);
	if (step_value > 0) {
		$$ = template("for (int %s = %s; %s < %s; %s+=%s) {\n%s\n}", $2, $5, $2, $7, $2, $9, $12); 
	} else if (step_value == -1) { 
	$$ = template("for (int %s = %s; %s < %s; %s--) {\n%s\n}", $2, $5, $2, $7, $2, $12); 
	} else { $$ = template("for (int %s = %s; %s < %s; %s-=%s) {\n%s\n}", $2, $5, $2, $7, $2, $9+1, $12); }}
	;

function_statement:
	TK_IDENT '(' function_parameter_list ')' ';' { $$ = template("%s(%s);", $1, $3); }
	| TK_IDENT '.' expr_function ';' 			 { $$ = template("%s.%s;?", $1, $3); } 
	| comp_variable '.' expr_function ';' 		 { $$ = template("%s.%s;?", $1, $3); } 
	| array_value '.' expr_function ';' 		 { $$ = template("%s.%s;?", $1, $3); } 
	;

expr_function:
	TK_IDENT '(' function_parameter_list ')' 	{ $$ = template("%s(%s)", $1, $3); }
	| TK_IDENT '.' expr_function	 			{ $$ = template("%s.%s", $1, $3); } 
	;

function_parameter_list:
	function_parameter_list ',' expr 		{ $$ = template("%s,%s", $1, $3); }
	| expr									{ $$ = template("%s", $1);  }
	| '-' expr								{ $$ = template("-%s", $2);  }
	| TK_IDENT '.' comp_variable			{ $$ = template("%s.%s", $1,$3); }
	| TK_STRING								{ $$ = template("%s", $1);  }
	| %empty								{ $$ = ""; }
	;
	
// ---- COMP ----

comp_list:
	comp_list comp							{ $$ = template("%s\n%s", $1, $2); }
	| comp
	;
	
comp:
	KW_COMP TK_IDENT ':' comp_body KW_ENDCOMP ';'	{  $$ = template("#define SELF struct %s *self \ntypedef struct %s {\n%s\n} %s ;\n\n%s\n#undef SELF\n", $2, $2, $4, $2, deff); }	
	;
	
comp_body:
	comp_variable_declaration_list comp_func_list	{ $$ = template("%s\n%s",$1,$2); }
	| comp_variable_declaration_list				{ $$ = template("%s",$1); }
	| comp_func_list								{ $$ = template("%s",$1); }
	;

comp_variable_declaration_list:
	comp_variable_declaration_list comp_variable_declaration { $$ = template("%s\n%s", $1, $2); }
	| comp_variable_declaration
	;	

comp_variable_declaration:
	comp_variable_assign_declaration ';'	{ $$ = template("%s;", $1); }
	;	
	
comp_variable_assign_declaration:
	single_comp_variable_declaration multiple_comp_variable_declaration ':' data_type { {$$ = template("%s %s %s",$4,$1,$2);} } 
	| single_comp_variable_declaration ':' data_type { $$ = template("%s %s",$3,$1);}
	;
	
single_comp_variable_declaration:
	comp_variable									{ $$ = template("%s", $1); }
	| array_value 									{ $$ = template("%s", $1); }
	;
	
multiple_comp_variable_declaration:
	multiple_const_variable_declaration ',' '#' TK_IDENT	{ $$ = template("%s, %s",$1,$4);}
	| ',' comp_variable 									{ $$ = template(", %s",$2);}
	| ',' '#' array_value 									{ $$ = template("%s", $3); }
	;

comp_func_list:
	comp_func_list comp_func								{ $$ = template("%s\n%s", $1, $2); }
	| comp_func
	;
	
comp_func:
	KW_DEF TK_IDENT '(' function_argument_list ')' KW_ARROW_FUNCTION data_type ':' function_body KW_ENDDEF  ';' {
		int alloc_size = strlen($2)+strlen($4)+strlen($7)+strlen($9)+20;
		size_t newLength = (deff ? strlen(deff) : 0) + alloc_size + 1;
    	char *newDest = (char *)realloc(deff, newLength);
		char* src = (char *)malloc(alloc_size * sizeof(char));
		if (strlen($4) == 0) {
			sprintf(src, "%s %s(SELF){%s\n}\n", $7, $2, $9);
			$$ = template("%s (*%s) (SELF);", $7, $2); 
		} else {
			sprintf(src, "%s %s(SELF,%s){%s\n}\n", $7, $2, $4, $9);
			$$ = template("%s (*%s) (SELF, %s);", $7, $2,$4); 
		}
    	
		if (deff == NULL)
		{
		    strcpy(newDest, src);
		}
		else
		{
		    strcat(newDest, src);
		}
		deff = newDest;

		}
		
		
	| KW_DEF TK_IDENT '(' function_argument_list ')' ':' function_body KW_ENDDEF ';' 	{ 
		int alloc_size = strlen($2)+strlen($4)+strlen($7)+20;
		size_t newLength = (deff ? strlen(deff) : 0) + alloc_size + 1;
    	char *newDest = (char *)realloc(deff, newLength);
		char* src = (char *)malloc(alloc_size * sizeof(char));
		if (strlen($4) == 0)  { 
			sprintf(src, "void %s(SELF){%s\n}\n",$2,$7);
			$$ = template("void (*%s) (SELF);", $2); 
		} else {
			sprintf(src, "void %s(SELF, %s){%s\n}\n",$2,$4,$7);
			$$ = template("void (*%s) (SELF, %s);", $2,$4);
		} 

		if (deff == NULL)
		{
		    strcpy(newDest, src);
		}
		else
		{
		    strcat(newDest, src);
		}
		deff = newDest;
		}
	;
	
comp_variable:
	'#' TK_IDENT 			{ $$ = $2; } 
	;
	
comp_value: 
	array_value '.' comp_variable  { $$ = template("self->%s.%s", $1, $3); } 
	;
			
comp_values:	
	comp_value '.' comp_variable   { $$ = template("%s.%s", $1, $3); } 
	| comp_value
	;

// ----------------
%%

int main () {
  if ( yyparse() == 0 )
    printf("// Your program is syntactically correct!\n");
  else
  	printf("// Your program is not syntactically correct!\n");
}
	


