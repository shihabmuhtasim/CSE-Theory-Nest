%{

#include "symbol_table.h"
using namespace std;

#define YYSTYPE symbol_info*

extern FILE *yyin;
int yyparse(void);
int yylex(void);
extern YYSTYPE yylval;


// takes a string like a,b,c and like , then returns a vector of strings {a, b, c} 
vector<string> split(const string& str, char delim) {
    vector<string> tokens;// empty vector
    stringstream ss(str); //helps to read from string
    string token;// temp variable to store the token
    while (getline(ss, token, delim)) {// read from ss and store in token then stop when delim is found
        tokens.push_back(token); // add token to the vector
    }
    return tokens;
}


// Declare the symbol table here
symbol_table* sym_table;




int lines = 1;

ofstream outlog;

// you may declare other necessary variables here to store necessary info
// such as current variable type, variable list, function name, return type, function parameter types, parameters names etc.
string current_variable_type, current_function_name;
string current_type;
string array_size;
vector<string> current_parameter_types, current_parameter_names;



void yyerror(char *s)
{
	outlog<<"At line "<<lines<<" "<<s<<endl<<endl;

    // you may need to reinitialize variables if you find an error
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
		
		// Print your whole symbol table here
		sym_table->print_all_scopes(outlog);
		cout << endl;
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
     | func_definition
     {
		outlog<<"At line no: "<<lines<<" unit : func_definition "<<endl<<endl;
		outlog<<$1->get_name()<<endl<<endl;
		
		$$ = new symbol_info($1->get_name(),"unit");
	 }
     ;

// func_enter:
// 		{
// 			sym_table->enter_scope();
					

// 		}

func_definition : type_specifier ID  LPAREN parameter_list RPAREN  compound_statement
		{	
			// int x(int a, int b) { ... }
			outlog<<"At line no: "<<lines<<" func_definition : type_specifier ID LPAREN parameter_list RPAREN compound_statement "<<endl<<endl;
			outlog<<$1->get_name()<<" "<<$2->get_name()<<"("+$4->get_name()+")\n"<<$6->get_name()<<endl<<endl;
		//storing function name	
		outlog << "Inserting function: " << $2->get_name() << " with return type: " << $1->get_name()<< " in Scope: " << sym_table->getCurrentScopeID() << endl;
		symbol_info* func_info = new symbol_info($2->get_name(), $1->get_name(), "function", $4->get_param_types(), $4->get_param_names());
		sym_table->insert(func_info);


			$$ = new symbol_info($1->get_name()+" "+$2->get_name()+"("+$4->get_name()+")\n"+$6->get_name(),"func_def");	
			
			// The function definition is complete.
            // You can now insert necessary information about the function into the symbol table
            // However, note that the scope of the function and the scope of the compound statement are different.
			
			
			
		}
		| type_specifier ID  LPAREN RPAREN  compound_statement
		{
			
			outlog<<"At line no: "<<lines<<" func_definition : type_specifier ID LPAREN RPAREN compound_statement "<<endl<<endl;
			outlog<<$1->get_name()<<" "<<$2->get_name()<<"()\n"<<$5->get_name()<<endl<<endl;
			// Insert function into symbol table
			 outlog << "Inserting function: " << $2->get_name() << " with return type: " << $1->get_name()<< " in Scope: " << sym_table->getCurrentScopeID() << endl;
			symbol_info* func_info = new symbol_info($2->get_name(), $1->get_name(), "function", {}, {});
			sym_table->insert(func_info);
			$$ = new symbol_info($1->get_name()+" "+$2->get_name()+"()\n"+$5->get_name(),"func_def");	
			
			// The function definition is complete.
            // You can now insert necessary information about the function into the symbol table
            // However, note that the scope of the function and the scope of the compound statement are different.
			
			
			
		}
 		;

parameter_list : parameter_list COMMA type_specifier ID
{
    outlog << "At line no: " << lines << " parameter_list : parameter_list COMMA type_specifier ID " << endl << endl;
    outlog << $1->get_name() << ", " << $3->get_name() << " " << $4->get_name() << endl << endl;
    //print
	// outlog << "Inserting parameter: " << $4->get_name() 
    //    << " with return type: " << $3->get_name() 
    //    << " in Scope: " << sym_table->getCurrentScopeID() << endl << endl;
	
    // Insert the parameter into the current scope (function scope)
    symbol_info* param_info = new symbol_info($4->get_name(), "parameter");
    param_info->set_data_type("Variable");  // Store the symbol's data type as 'parameter'
    param_info->set_type($3->get_name());    // Set the actual type specifier (e.g., int, float)
    sym_table->insert(param_info);  // Insert the parameter into the symbol table
    
    // Build the parameter list
    $$ = new symbol_info($1->get_name() + ", " + $3->get_name() + " " + $4->get_name(), "param_list");
    
    // Store necessary information about the function parameters
	//first gets using the get functions and then sets to the current $$ pointer using the set functions
    $$->set_param_types($1->get_param_types());  // Copy previous types
    $$->set_param_names($1->get_param_names());  // Copy previous names
    $$->add_parameter($3->get_name(), $4->get_name());  // Add current parameter (type, name)

	// ex- int a, int b , here 1 st iteration int a is added using add then on second iteration int b is added using add while int a is copied using set
}
| parameter_list COMMA type_specifier
{

    outlog << "At line no: " << lines << " parameter_list : parameter_list COMMA type_specifier " << endl << endl;
    outlog << $1->get_name() << ", " << $3->get_name() << endl << endl;
    
	
	
    // Insert the parameter into the current scope
    symbol_info* param_info = new symbol_info($3->get_name(), "parameter");
    param_info->set_data_type("Variable");  // Store the symbol's data type as 'parameter'
    param_info->set_type($3->get_name());    // Set the actual type specifier (e.g., int, float)
    sym_table->insert(param_info);  // Insert the parameter into the symbol table
    
    // Build the parameter list
    $$ = new symbol_info($1->get_name() + ", " + $3->get_name(), "param_list");
    
    // Store necessary information about the function parameters
    $$->set_param_types($1->get_param_types());  // Copy previous types
    $$->set_param_names($1->get_param_names());  // Copy previous names
    $$->add_parameter($3->get_name(), "");  // Add current parameter (type only, no name)
}
| type_specifier ID
{
	
    outlog << "At line no: " << lines << " parameter_list : type_specifier ID " << endl << endl;
    outlog << $1->get_name() << " " << $2->get_name() << endl << endl;
    //print
	// outlog << "Inserting parameter: " << $2->get_name() 
    //    << " with return type: " << $1->get_name() 
    //    << " in Scope: " << sym_table->getCurrentScopeID() << endl;
    // Insert the parameter into the current scope
    symbol_info* param_info = new symbol_info($2->get_name(), "parameter");
    param_info->set_data_type("parameter");  // Store the symbol's data type as 'parameter'
    param_info->set_type($1->get_name());    // Set the actual type specifier (e.g., int, float)
    sym_table->insert(param_info);  // Insert the parameter into the symbol table
    
    // Build the parameter list
    $$ = new symbol_info($1->get_name() + " " + $2->get_name(), "param_list");
    
    // Store necessary information about the function parameters
    $$->add_parameter($1->get_name(), $2->get_name());  // Add current parameter (type, name)
}
| type_specifier
{
    outlog << "At line no: " << lines << " parameter_list : type_specifier " << endl << endl;
    outlog << $1->get_name() << endl << endl;
    
    
    
    // Build the parameter list
    $$ = new symbol_info($1->get_name(), "param_list");
    
    // Store necessary information about the function parameters
    $$->add_parameter($1->get_name(), "");  // Add current parameter (type only, no name)
}
;


enter_cmp_start : 
{
    // Enter a new scope at the beginning of a compound statement
    sym_table->enter_scope();
	
}
;

compound_statement : LCURL enter_cmp_start statements RCURL
			{ 
 		    	outlog<<"At line no: "<<lines<<" compound_statement : LCURL statements RCURL "<<endl<<endl;
				outlog<<"{\n"+$3->get_name()+"\n}"<<endl<<endl;

				$$ = new symbol_info("{\n"+$3->get_name()+"\n}","comp_stmnt");
				
 		    sym_table->print_all_scopes(outlog);
			sym_table->exit_scope();

			}
 		    | LCURL enter_cmp_start RCURL
 		    { 
 		    	outlog<<"At line no: "<<lines<<" compound_statement : LCURL RCURL "<<endl<<endl;
				outlog<<"{\n}"<<endl<<endl;
				$$ = new symbol_info("{\n}","comp_stmnt");
				
    				sym_table->exit_scope();

			
				sym_table->print_all_scopes(outlog);
			}

 		    ;
 	    
var_declaration : type_specifier declaration_list SEMICOLON
		 {
			outlog<<"At line no: "<<lines<<" var_declaration : type_specifier declaration_list SEMICOLON "<<endl<<endl;
			outlog<<$1->get_name()<<" "<<$2->get_name()<<";"<<endl<<endl;
			
			$$ = new symbol_info($1->get_name()+" "+$2->get_name()+";","var_dec");
			
			// Insert necessary information about the variables in the symbol table
			// Create the type information from the type_specifier
			 	current_type = $1->get_name();

    // Insert each variable in the declaration_list into the symbol table
    vector<string> variables = split($2->get_name(), ','); // Split the variable names into [var1, var2, ...]
    for (const string& var : variables) {// insert each variable into the symbol table
        symbol_info* var_info = new symbol_info(var,  current_type);
		var_info->set_data_type("Variable");
        sym_table->insert(var_info);
    }

		 }
 		 ;

type_specifier : INT
		{
			outlog<<"At line no: "<<lines<<" type_specifier : INT "<<endl<<endl;
			outlog<<"int"<<endl<<endl;
			
			$$ = new symbol_info("int","INT");
			current_type = "int";
			 
	    }
 		| FLOAT
 		{
			outlog<<"At line no: "<<lines<<" type_specifier : FLOAT "<<endl<<endl;
			outlog<<"float"<<endl<<endl;
			
			$$ = new symbol_info("float","FLOAT");
			current_type = "float";
			
	    }
 		| VOID
 		{
			outlog<<"At line no: "<<lines<<" type_specifier : VOID "<<endl<<endl;
			outlog<<"void"<<endl<<endl;
			
			$$ = new symbol_info("void","VOID");
			current_type = "void";
			 
	    }
 		;

declaration_list : declaration_list COMMA ID
		  {
 		  	outlog<<"At line no: "<<lines<<" declaration_list : declaration_list COMMA ID "<<endl<<endl;
 		  	outlog<<$1->get_name()+","<<$3->get_name()<<endl<<endl;

            // you may need to store the variable names to insert them in symbol table here or later
			
			symbol_info* new_symbol = new symbol_info($3->get_name(), current_type);
			new_symbol->set_data_type("Variable");
			sym_table->insert(new_symbol);
			$$ = new symbol_info($1->get_name() + "," + $3->get_name(), "declaration_list");
			
			
 		  }
 		  | declaration_list COMMA ID LTHIRD CONST_INT RTHIRD //array after some declaration
 		  {
 		  	outlog<<"At line no: "<<lines<<" declaration_list : declaration_list COMMA ID LTHIRD CONST_INT RTHIRD "<<endl<<endl;
 		  	outlog<<$1->get_name()+","<<$3->get_name()<<"["<<$5->get_name()<<"]"<<endl<<endl;

            // you may need to store the variable names to insert them in symbol table here or later
			
			
    		symbol_info* new_symbol = new symbol_info($3->get_name(), current_type);
			new_symbol->set_data_type("Arary");
            new_symbol->set_array_size(stoi($5->get_name()));  // stoi converts string to integer
            sym_table->insert(new_symbol);
            $$ = new symbol_info($1->get_name() + "," + $3->get_name() + "[" + $5->get_name() + "]", "declaration_list");

 		  }
 		  |ID
 		  {
 		  	outlog<<"At line no: "<<lines<<" declaration_list : ID "<<endl<<endl;
			outlog<<$1->get_name()<<endl<<endl;

            // you may need to store the variable names to insert them in symbol table here or later
		
			symbol_info* new_symbol = new symbol_info($1->get_name(), current_type);
			new_symbol->set_data_type("Variable");
			sym_table->insert(new_symbol);
    		$$ = new symbol_info($1->get_name(), "declaration_list");
 		  }
 		  | ID LTHIRD CONST_INT RTHIRD //array
 		  {
 		  	outlog<<"At line no: "<<lines<<" declaration_list : ID LTHIRD CONST_INT RTHIRD "<<endl<<endl;
			outlog<<$1->get_name()<<"["<<$3->get_name()<<"]"<<endl<<endl;

            // you may need to store the variable names to insert them in symbol table here or later
            symbol_info* new_symbol = new symbol_info($1->get_name(), current_type);
			new_symbol->set_data_type("Array");
            new_symbol->set_array_size(stoi($3->get_name()));  
            sym_table->insert(new_symbol);
    		$$ = new symbol_info($1->get_name() + "[" + $3->get_name() + "]", "declaration_list");
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
					
term :	unary_expression //term can be void because of un_expr->factor
     {
	    	outlog<<"At line no: "<<lines<<" term : unary_expression "<<endl<<endl;
			outlog<<$1->get_name()<<endl<<endl;
			
			$$ = new symbol_info($1->get_name(),"term");
			
	 }
     |  term MULOP unary_expression
     {
	    	outlog<<"At line no: "<<lines<<" term : term MULOP unary_expression "<<endl<<endl;
			outlog<<$1->get_name()<<$2->get_name()<<$3->get_name()<<endl<<endl;
			
			$$ = new symbol_info($1->get_name()+$2->get_name()+$3->get_name(),"term");
			
	 }
     ;

unary_expression : ADDOP unary_expression  // un_expr can be void because of factor
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
	outlog.open("21301610.txt", ios::trunc);
	
	if(yyin == NULL)
	{
		cout<<"Couldn't open file"<<endl;
		return 0;
	}
	// Enter the global or the first scope here
	sym_table = new symbol_table(10,outlog); // Assuming 10 buckets for the hash table
    
	
    yyparse();
	
	
	outlog<<endl<<"Total lines: "<<lines<<endl;
	
	outlog.close();
	
	fclose(yyin);

	// Clean up symbol table
    delete sym_table;
	
	return 0;
}