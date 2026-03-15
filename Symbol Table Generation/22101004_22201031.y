%{
#include "symbol_table.h"

#define YYSTYPE symbol_info*

extern FILE *yyin;
int yyparse(void);
int yylex(void);
extern YYSTYPE yylval;

symbol_table *st;
bool enter_scope_done = false;

int lines = 1;
ofstream outlog;

void yyerror(char *s)
{
	outlog<<"At line "<<lines<<" "<<s<<endl<<endl;
}

%}

%token IF ELSE FOR WHILE DO BREAK INT CHAR FLOAT DOUBLE VOID RETURN SWITCH CASE DEFAULT CONTINUE PRINTLN ADDOP MULOP INCOP DECOP RELOP ASSIGNOP LOGICOP NOT LPAREN RPAREN LCURL RCURL LTHIRD RTHIRD COMMA SEMICOLON CONST_INT CONST_FLOAT ID

%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE

%%

start : program
	{
		outlog<<"At line no: "<<lines<<" start : program "<<endl<<endl;
		outlog<<"Symbol Table"<<endl<<endl;
		st->print_all_scopes(outlog);
	}
	;

program : program unit
	{
		outlog<<"At line no: "<<lines<<" program : program unit "<<endl<<endl;
		outlog<<$1->get_name()+"\n"+$2->get_name()<<endl<<endl;
		$$ = new symbol_info($1->get_name()+"\n"+$2->get_name(),"program");
	}
	| unit
	{
		outlog<<"At line no: "<<lines<<" program : unit "<<endl<<endl;
		outlog<<$1->get_name()<<endl<<endl;
		$$ = new symbol_info($1->get_name(),"program");
	}
	;

unit : var_declaration
	 {
		outlog<<"At line no: "<<lines<<" unit : var_declaration "<<endl<<endl;
		outlog<<$1->get_name()<<endl<<endl;
		$$ = new symbol_info($1->get_name(),"unit");
	 }
     | func_declaration
     {
		outlog<<"At line no: "<<lines<<" unit : func_declaration "<<endl<<endl;
		outlog<<$1->get_name()<<endl<<endl;
		$$ = new symbol_info($1->get_name(),"unit");
     }
     | func_definition
     {
		outlog<<"At line no: "<<lines<<" unit : func_definition "<<endl<<endl;
		outlog<<$1->get_name()<<endl<<endl;
		$$ = new symbol_info($1->get_name(),"unit");
	 }
     ;

func_declaration : type_specifier ID LPAREN parameter_list RPAREN SEMICOLON
		{
			outlog<<"At line no: "<<lines<<" func_declaration : type_specifier ID LPAREN parameter_list RPAREN SEMICOLON "<<endl<<endl;
			outlog<<$1->get_name()<<" "<<$2->get_name()<<"("<<$4->get_name()<<");"<<endl<<endl;
			$$ = new symbol_info($1->get_name()+" "+$2->get_name()+"("+$4->get_name()+");","func_decl");

            symbol_info* func = new symbol_info($2->get_name(), "ID");
            func->set_symbolType("Function Declaration");
            func->set_dataType($1->get_name());
            for(auto p : $4->decl_list) {
                func->add_parameter(p->get_dataType(), p->get_name());
            }
            st->insert(func);
		}
		| type_specifier ID LPAREN RPAREN SEMICOLON
		{
			outlog<<"At line no: "<<lines<<" func_declaration : type_specifier ID LPAREN RPAREN SEMICOLON "<<endl<<endl;
			outlog<<$1->get_name()<<" "<<$2->get_name()<<"();"<<endl<<endl;
			$$ = new symbol_info($1->get_name()+" "+$2->get_name()+"();","func_decl");

            symbol_info* func = new symbol_info($2->get_name(), "ID");
            func->set_symbolType("Function Declaration");
            func->set_dataType($1->get_name());
            st->insert(func);
		}
		;

func_definition : type_specifier ID LPAREN parameter_list RPAREN 
        {
            symbol_info* func = new symbol_info($2->get_name(), "ID");
            func->set_symbolType("Function Definition");
            func->set_dataType($1->get_name());
            for(auto p : $4->decl_list) {
                func->add_parameter(p->get_dataType(), p->get_name());
            }
            st->insert(func);
            st->enter_scope(outlog);
            enter_scope_done = true;
            for(auto p : $4->decl_list) {
                if(p->get_name() != "") st->insert(p);
            }
        }
        compound_statement
		{	
			outlog<<"At line no: "<<lines<<" func_definition : type_specifier ID LPAREN parameter_list RPAREN compound_statement "<<endl<<endl;
			outlog<<$1->get_name()<<" "<<$2->get_name()<<"("+$4->get_name()+")\n"<<$7->get_name()<<endl<<endl;
			$$ = new symbol_info($1->get_name()+" "+$2->get_name()+"("+$4->get_name()+")\n"+$7->get_name(),"func_def");	
		}
		| type_specifier ID LPAREN RPAREN 
        {
            symbol_info* func = new symbol_info($2->get_name(), "ID");
            func->set_symbolType("Function Definition");
            func->set_dataType($1->get_name());
            st->insert(func);
            st->enter_scope(outlog);
            enter_scope_done = true;
        }
        compound_statement
		{
			outlog<<"At line no: "<<lines<<" func_definition : type_specifier ID LPAREN RPAREN compound_statement "<<endl<<endl;
			outlog<<$1->get_name()<<" "<<$2->get_name()<<"()\n"<<$6->get_name()<<endl<<endl;
			$$ = new symbol_info($1->get_name()+" "+$2->get_name()+"()\n"+$6->get_name(),"func_def");	
		}
 		;

parameter_list : parameter_list COMMA type_specifier ID
		{
			outlog<<"At line no: "<<lines<<" parameter_list : parameter_list COMMA type_specifier ID "<<endl<<endl;
			outlog<<$1->get_name()<<","<<$3->get_name()<<" "<<$4->get_name()<<endl<<endl;
			$$ = new symbol_info($1->get_name()+","+$3->get_name()+" "+$4->get_name(),"param_list");
            
            $$->decl_list = $1->decl_list;
            symbol_info* p = new symbol_info($4->get_name(), "ID");
            p->set_symbolType("Variable");
            p->set_dataType($3->get_name());
            $$->decl_list.push_back(p);
		}
		| parameter_list COMMA type_specifier
		{
			outlog<<"At line no: "<<lines<<" parameter_list : parameter_list COMMA type_specifier "<<endl<<endl;
			outlog<<$1->get_name()<<","<<$3->get_name()<<endl<<endl;
			$$ = new symbol_info($1->get_name()+","+$3->get_name(),"param_list");

            $$->decl_list = $1->decl_list;
            symbol_info* p = new symbol_info("", "ID");
            p->set_symbolType("Variable");
            p->set_dataType($3->get_name());
            $$->decl_list.push_back(p);
		}
 		| type_specifier ID
 		{
			outlog<<"At line no: "<<lines<<" parameter_list : type_specifier ID "<<endl<<endl;
			outlog<<$1->get_name()<<" "<<$2->get_name()<<endl<<endl;
			$$ = new symbol_info($1->get_name()+" "+$2->get_name(),"param_list");

            symbol_info* p = new symbol_info($2->get_name(), "ID");
            p->set_symbolType("Variable");
            p->set_dataType($1->get_name());
            $$->decl_list.push_back(p);
		}
		| type_specifier
		{
			outlog<<"At line no: "<<lines<<" parameter_list : type_specifier "<<endl<<endl;
			outlog<<$1->get_name()<<endl<<endl;
			$$ = new symbol_info($1->get_name(),"param_list");

            symbol_info* p = new symbol_info("", "ID");
            p->set_symbolType("Variable");
            p->set_dataType($1->get_name());
            $$->decl_list.push_back(p);
		}
 		;

compound_statement : LCURL 
            {
                if(!enter_scope_done) st->enter_scope(outlog);
                enter_scope_done = false;
            }
            statements RCURL
			{ 
 		    	outlog<<"At line no: "<<lines<<" compound_statement : LCURL statements RCURL "<<endl<<endl;
				outlog<<"{\n"+$3->get_name()+"\n}"<<endl<<endl;
				$$ = new symbol_info("{\n"+$3->get_name()+"\n}","comp_stmnt");
                st->exit_scope(outlog);
 		    }
 		    | LCURL
            {
                if(!enter_scope_done) st->enter_scope(outlog);
                enter_scope_done = false;
            }
            RCURL
 		    { 
 		    	outlog<<"At line no: "<<lines<<" compound_statement : LCURL RCURL "<<endl<<endl;
				outlog<<"{\n}"<<endl<<endl;
				$$ = new symbol_info("{\n}","comp_stmnt");
                st->exit_scope(outlog);
 		    }
 		    ;

var_declaration : type_specifier declaration_list SEMICOLON
		 {
			outlog<<"At line no: "<<lines<<" var_declaration : type_specifier declaration_list SEMICOLON "<<endl<<endl;
			outlog<<$1->get_name()<<" "<<$2->get_name()<<";"<<endl<<endl;
			$$ = new symbol_info($1->get_name()+" "+$2->get_name()+";","var_dec");
			
            for(auto sym : $2->decl_list) {
                sym->set_dataType($1->get_name());
                st->insert(sym);
            }
		 }
 		 ;

type_specifier : INT
		{
			outlog<<"At line no: "<<lines<<" type_specifier : INT "<<endl<<endl;
			outlog<<"int"<<endl<<endl;
			$$ = new symbol_info("int","type");
	    }
 		| FLOAT
 		{
			outlog<<"At line no: "<<lines<<" type_specifier : FLOAT "<<endl<<endl;
			outlog<<"float"<<endl<<endl;
			$$ = new symbol_info("float","type");
	    }
 		| VOID
 		{
			outlog<<"At line no: "<<lines<<" type_specifier : VOID "<<endl<<endl;
			outlog<<"void"<<endl<<endl;
			$$ = new symbol_info("void","type");
	    }
 		;

declaration_list : declaration_list COMMA ID
		  {
 		  	outlog<<"At line no: "<<lines<<" declaration_list : declaration_list COMMA ID "<<endl<<endl;
 		  	outlog<<$1->get_name()+","<<$3->get_name()<<endl<<endl;
			
            $$ = new symbol_info($1->get_name()+","+$3->get_name(),"decl_list");
            $$->decl_list = $1->decl_list;
            symbol_info* var = new symbol_info($3->get_name(), "ID");
            var->set_symbolType("Variable");
            $$->decl_list.push_back(var);
 		  }
 		  | declaration_list COMMA ID LTHIRD CONST_INT RTHIRD 
 		  {
 		  	outlog<<"At line no: "<<lines<<" declaration_list : declaration_list COMMA ID LTHIRD CONST_INT RTHIRD "<<endl<<endl;
			outlog<<$1->get_name()+","<<$3->get_name()<<"["<<$5->get_name()<<"]"<<endl<<endl;

            $$ = new symbol_info($1->get_name()+","+$3->get_name()+"["+$5->get_name()+"]","decl_list");
            $$->decl_list = $1->decl_list;
            symbol_info* arr = new symbol_info($3->get_name(), "ID");
            arr->set_symbolType("Array");
            arr->set_arraySize(stoi($5->get_name()));
            $$->decl_list.push_back(arr);
 		  }
 		  | ID
 		  {
 		  	outlog<<"At line no: "<<lines<<" declaration_list : ID "<<endl<<endl;
			outlog<<$1->get_name()<<endl<<endl;

            $$ = new symbol_info($1->get_name(), "decl_list");
            symbol_info* var = new symbol_info($1->get_name(), "ID");
            var->set_symbolType("Variable");
            $$->decl_list.push_back(var);
 		  }
 		  | ID LTHIRD CONST_INT RTHIRD 
 		  {
 		  	outlog<<"At line no: "<<lines<<" declaration_list : ID LTHIRD CONST_INT RTHIRD "<<endl<<endl;
			outlog<<$1->get_name()<<"["<<$3->get_name()<<"]"<<endl<<endl;

            $$ = new symbol_info($1->get_name()+"["+$3->get_name()+"]", "decl_list");
            symbol_info* arr = new symbol_info($1->get_name(), "ID");
            arr->set_symbolType("Array");
            arr->set_arraySize(stoi($3->get_name()));
            $$->decl_list.push_back(arr);
 		  }
 		  ;

statements : statement
	   {
	    	outlog<<"At line no: "<<lines<<" statements : statement "<<endl<<endl;
			outlog<<$1->get_name()<<endl<<endl;
			$$ = new symbol_info($1->get_name(),"stmnts");
	   }
	   | statements statement
	   {
	    	outlog<<"At line no: "<<lines<<" statements : statements statement "<<endl<<endl;
			outlog<<$1->get_name()<<"\n"<<$2->get_name()<<endl<<endl;
			$$ = new symbol_info($1->get_name()+"\n"+$2->get_name(),"stmnts");
	   }
	   ;
	   
statement : var_declaration
	  {
	    	outlog<<"At line no: "<<lines<<" statement : var_declaration "<<endl<<endl;
			outlog<<$1->get_name()<<endl<<endl;
			$$ = new symbol_info($1->get_name(),"stmnt");
	  }
	  | func_definition
	  {
	  		outlog<<"At line no: "<<lines<<" statement : func_definition "<<endl<<endl;
			outlog<<$1->get_name()<<endl<<endl;
            $$ = new symbol_info($1->get_name(),"stmnt");
	  }
	  | expression_statement
	  {
	    	outlog<<"At line no: "<<lines<<" statement : expression_statement "<<endl<<endl;
			outlog<<$1->get_name()<<endl<<endl;
			$$ = new symbol_info($1->get_name(),"stmnt");
	  }
	  | compound_statement
	  {
	    	outlog<<"At line no: "<<lines<<" statement : compound_statement "<<endl<<endl;
			outlog<<$1->get_name()<<endl<<endl;
			$$ = new symbol_info($1->get_name(),"stmnt");
	  }
	  | FOR LPAREN expression_statement expression_statement expression RPAREN statement
	  {
	    	outlog<<"At line no: "<<lines<<" statement : FOR LPAREN expression_statement expression_statement expression RPAREN statement "<<endl<<endl;
			outlog<<"for("<<$3->get_name()<<$4->get_name()<<$5->get_name()<<")\n"<<$7->get_name()<<endl<<endl;
			$$ = new symbol_info("for("+$3->get_name()+$4->get_name()+$5->get_name()+")\n"+$7->get_name(),"stmnt");
	  }
	  | IF LPAREN expression RPAREN statement %prec LOWER_THAN_ELSE
	  {
	    	outlog<<"At line no: "<<lines<<" statement : IF LPAREN expression RPAREN statement "<<endl<<endl;
			outlog<<"if("<<$3->get_name()<<")\n"<<$5->get_name()<<endl<<endl;
			$$ = new symbol_info("if("+$3->get_name()+")\n"+$5->get_name(),"stmnt");
	  }
	  | IF LPAREN expression RPAREN statement ELSE statement
	  {
	    	outlog<<"At line no: "<<lines<<" statement : IF LPAREN expression RPAREN statement ELSE statement "<<endl<<endl;
			outlog<<"if("<<$3->get_name()<<")\n"<<$5->get_name()<<"\nelse\n"<<$7->get_name()<<endl<<endl;
			$$ = new symbol_info("if("+$3->get_name()+")\n"+$5->get_name()+"\nelse\n"+$7->get_name(),"stmnt");
	  }
	  | WHILE LPAREN expression RPAREN statement
	  {
	    	outlog<<"At line no: "<<lines<<" statement : WHILE LPAREN expression RPAREN statement "<<endl<<endl;
			outlog<<"while("<<$3->get_name()<<")\n"<<$5->get_name()<<endl<<endl;
			$$ = new symbol_info("while("+$3->get_name()+")\n"+$5->get_name(),"stmnt");
	  }
	  | PRINTLN LPAREN ID RPAREN SEMICOLON
	  {
	    	outlog<<"At line no: "<<lines<<" statement : PRINTLN LPAREN ID RPAREN SEMICOLON "<<endl<<endl;
			outlog<<"printf("<<$3->get_name()<<");"<<endl<<endl; 
			$$ = new symbol_info("printf("+$3->get_name()+");","stmnt");
	  }
	  | RETURN expression SEMICOLON
	  {
	    	outlog<<"At line no: "<<lines<<" statement : RETURN expression SEMICOLON "<<endl<<endl;
			outlog<<"return "<<$2->get_name()<<";"<<endl<<endl;
			$$ = new symbol_info("return "+$2->get_name()+";","stmnt");
	  }
	  ;
	  
expression_statement : SEMICOLON
			{
				outlog<<"At line no: "<<lines<<" expression_statement : SEMICOLON "<<endl<<endl;
				outlog<<";"<<endl<<endl;
				$$ = new symbol_info(";","expr_stmt");
	        }			
			| expression SEMICOLON 
			{
				outlog<<"At line no: "<<lines<<" expression_statement : expression SEMICOLON "<<endl<<endl;
				outlog<<$1->get_name()<<";"<<endl<<endl;
				$$ = new symbol_info($1->get_name()+";","expr_stmt");
	        }
			;
	  
variable : ID 	
      {
	    outlog<<"At line no: "<<lines<<" variable : ID "<<endl<<endl;
		outlog<<$1->get_name()<<endl<<endl;
		$$ = new symbol_info($1->get_name(),"varbl");
	 }	
	 | ID LTHIRD expression RTHIRD 
	 {
	 	outlog<<"At line no: "<<lines<<" variable : ID LTHIRD expression RTHIRD "<<endl<<endl;
		outlog<<$1->get_name()<<"["<<$3->get_name()<<"]"<<endl<<endl;
		$$ = new symbol_info($1->get_name()+"["+$3->get_name()+"]","varbl");
	 }
	 ;
	 
expression : logic_expression
	   {
	    	outlog<<"At line no: "<<lines<<" expression : logic_expression "<<endl<<endl;
			outlog<<$1->get_name()<<endl<<endl;
			$$ = new symbol_info($1->get_name(),"expr");
	   }
	   | variable ASSIGNOP logic_expression 	
	   {
	    	outlog<<"At line no: "<<lines<<" expression : variable ASSIGNOP logic_expression "<<endl<<endl;
			outlog<<$1->get_name()<<"="<<$3->get_name()<<endl<<endl;
			$$ = new symbol_info($1->get_name()+"="+$3->get_name(),"expr");
	   }
	   ;
			
logic_expression : rel_expression
	     {
	    	outlog<<"At line no: "<<lines<<" logic_expression : rel_expression "<<endl<<endl;
			outlog<<$1->get_name()<<endl<<endl;
			$$ = new symbol_info($1->get_name(),"lgc_expr");
	     }	
		 | rel_expression LOGICOP rel_expression 
		 {
	    	outlog<<"At line no: "<<lines<<" logic_expression : rel_expression LOGICOP rel_expression "<<endl<<endl;
			outlog<<$1->get_name()<<$2->get_name()<<$3->get_name()<<endl<<endl;
			$$ = new symbol_info($1->get_name()+$2->get_name()+$3->get_name(),"lgc_expr");
	     }	
		 ;
			
rel_expression	: simple_expression
		{
	    	outlog<<"At line no: "<<lines<<" rel_expression : simple_expression "<<endl<<endl;
			outlog<<$1->get_name()<<endl<<endl;
			$$ = new symbol_info($1->get_name(),"rel_expr");
	    }
		| simple_expression RELOP simple_expression
		{
	    	outlog<<"At line no: "<<lines<<" rel_expression : simple_expression RELOP simple_expression "<<endl<<endl;
			outlog<<$1->get_name()<<$2->get_name()<<$3->get_name()<<endl<<endl;
			$$ = new symbol_info($1->get_name()+$2->get_name()+$3->get_name(),"rel_expr");
	    }
		;
				
simple_expression : term
          {
	    	outlog<<"At line no: "<<lines<<" simple_expression : term "<<endl<<endl;
			outlog<<$1->get_name()<<endl<<endl;
			$$ = new symbol_info($1->get_name(),"simp_expr");
	      }
		  | simple_expression ADDOP term 
		  {
	    	outlog<<"At line no: "<<lines<<" simple_expression : simple_expression ADDOP term "<<endl<<endl;
			outlog<<$1->get_name()<<$2->get_name()<<$3->get_name()<<endl<<endl;
			$$ = new symbol_info($1->get_name()+$2->get_name()+$3->get_name(),"simp_expr");
	      }
		  ;
					
term :	unary_expression
     {
	    	outlog<<"At line no: "<<lines<<" term : unary_expression "<<endl<<endl;
			outlog<<$1->get_name()<<endl<<endl;
			$$ = new symbol_info($1->get_name(),"term");
	 }
     | term MULOP unary_expression
     {
	    	outlog<<"At line no: "<<lines<<" term : term MULOP unary_expression "<<endl<<endl;
			outlog<<$1->get_name()<<$2->get_name()<<$3->get_name()<<endl<<endl;
			$$ = new symbol_info($1->get_name()+$2->get_name()+$3->get_name(),"term");
	 }
     ;

unary_expression : ADDOP unary_expression 
		 {
	    	outlog<<"At line no: "<<lines<<" unary_expression : ADDOP unary_expression "<<endl<<endl;
			outlog<<$1->get_name()<<$2->get_name()<<endl<<endl;
			$$ = new symbol_info($1->get_name()+$2->get_name(),"un_expr");
	     }
		 | NOT unary_expression 
		 {
	    	outlog<<"At line no: "<<lines<<" unary_expression : NOT unary_expression "<<endl<<endl;
			outlog<<"!"<<$2->get_name()<<endl<<endl;
			$$ = new symbol_info("!"+$2->get_name(),"un_expr");
	     }
		 | factor 
		 {
	    	outlog<<"At line no: "<<lines<<" unary_expression : factor "<<endl<<endl;
			outlog<<$1->get_name()<<endl<<endl;
			$$ = new symbol_info($1->get_name(),"un_expr");
	     }
		 ;
	
factor	: variable
    {
	    outlog<<"At line no: "<<lines<<" factor : variable "<<endl<<endl;
		outlog<<$1->get_name()<<endl<<endl;
		$$ = new symbol_info($1->get_name(),"fctr");
	}
	| ID LPAREN argument_list RPAREN
	{
	    outlog<<"At line no: "<<lines<<" factor : ID LPAREN argument_list RPAREN "<<endl<<endl;
		outlog<<$1->get_name()<<"("<<$3->get_name()<<")"<<endl<<endl;
		$$ = new symbol_info($1->get_name()+"("+$3->get_name()+")","fctr");
	}
	| LPAREN expression RPAREN
	{
	   	outlog<<"At line no: "<<lines<<" factor : LPAREN expression RPAREN "<<endl<<endl;
		outlog<<"("<<$2->get_name()<<")"<<endl<<endl;
		$$ = new symbol_info("("+$2->get_name()+")","fctr");
	}
	| CONST_INT 
	{
	    outlog<<"At line no: "<<lines<<" factor : CONST_INT "<<endl<<endl;
		outlog<<$1->get_name()<<endl<<endl;
		$$ = new symbol_info($1->get_name(),"fctr");
	}
	| CONST_FLOAT
	{
	    outlog<<"At line no: "<<lines<<" factor : CONST_FLOAT "<<endl<<endl;
		outlog<<$1->get_name()<<endl<<endl;
		$$ = new symbol_info($1->get_name(),"fctr");
	}
	| variable INCOP 
	{
	    outlog<<"At line no: "<<lines<<" factor : variable INCOP "<<endl<<endl;
		outlog<<$1->get_name()<<"++"<<endl<<endl;
		$$ = new symbol_info($1->get_name()+"++","fctr");
	}
	| variable DECOP
	{
	    outlog<<"At line no: "<<lines<<" factor : variable DECOP "<<endl<<endl;
		outlog<<$1->get_name()<<"--"<<endl<<endl;
		$$ = new symbol_info($1->get_name()+"--","fctr");
	}
	;
	
argument_list : arguments
			  {
					outlog<<"At line no: "<<lines<<" argument_list : arguments "<<endl<<endl;
					outlog<<$1->get_name()<<endl<<endl;
					$$ = new symbol_info($1->get_name(),"arg_list");
			  }
			  |
			  {
					outlog<<"At line no: "<<lines<<" argument_list :  "<<endl<<endl;
					outlog<<""<<endl<<endl;
					$$ = new symbol_info("","arg_list");
			  }
			  ;
	
arguments : arguments COMMA logic_expression
		  {
				outlog<<"At line no: "<<lines<<" arguments : arguments COMMA logic_expression "<<endl<<endl;
				outlog<<$1->get_name()<<","<<$3->get_name()<<endl<<endl;
				$$ = new symbol_info($1->get_name()+","+$3->get_name(),"arg");
		  }
	      | logic_expression
	      {
				outlog<<"At line no: "<<lines<<" arguments : logic_expression "<<endl<<endl;
				outlog<<$1->get_name()<<endl<<endl;
				$$ = new symbol_info($1->get_name(),"arg");
		  }
	      ;
 
%%

int main(int argc, char *argv[])
{
	if(argc != 2) 
	{
		cout<<"Please input file name"<<endl;
		return 0;
	}
	yyin = fopen(argv[1], "r");
	outlog.open("22101004_22201031_log.txt", ios::trunc); 
	
	if(yyin == NULL)
	{
		cout<<"Couldn't open file"<<endl;
		return 0;
	}

    st = new symbol_table(10); 
    st->enter_scope(outlog);

	yyparse();
	
	outlog<<endl<<"Total lines: "<<lines<<endl;
	
	outlog.close();
	fclose(yyin);
	
	return 0;
}
