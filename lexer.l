%option noyywrap

%{
#include <stdio.h>
#include <string.h>

//yylex recongnizes tokens from the input stream and send them to the parser
#define YY_DECL int yylex()

//Definitions Section
//declares variables to keep track of 
//the number of words, chars, lines errors
//that appear in our samplecode
int words = 0;
int chars = 0;
int lines = 0;
int errors = 0;
%}

%{

 //The below code is the rules section for our lexical analyzer
 // These are all regular expressions
 // *: means we have zero or more occurences of the ID
 // +: means we have one or more occurences of a NUMBER
 // []: means we have only zero or one occurence.

%}

keywords	do|if|for|case|else|break|while|continue|default|return
letter      [a-zA-Z]
digit       [0-9]
ID          {letter}({letter}|{digit})*
delim       [ \t\n]
NUMBER      {digit}+(\.{digit}+)?(E[+\-]?(digit)+)?
ws          {delim}+
BinOp		\+|-|=|\*|==|!=|<|<=|>|>=|&&|\/|\|\|

%%
"/*"    				{
							int c;
							while((c = input()) != 0) {
								if(c == '*') {
									if((c = input()) == '/')
										break;
									else
										unput(c);
								}
							}
						}

%{
 //This is the rules section as well
 // All the below code really does is just recongize where all of the
 // different keywords IDS TYPES Numbers and Symbols are and prints the
 //number to the screen.
 
%}


"int"	{words++; chars += strlen(yytext); 
		 printf("%s : TYPE\n", yytext);
		}

"char"	{words++; chars += strlen(yytext);
		 printf("%s : TYPE\n", yytext);
		}
		
"write"	{words++; 
		 chars += strlen(yytext);
		 printf("%s : KEYWORD\n", yytext);
		}

{keywords} {words++; 
		 chars += strlen(yytext);
		 printf("%s : KEYWORD\n", yytext);
		}
		
{ID}	{words++; chars += strlen(yytext);
		 printf("%s : IDENTIFIER\n",yytext);
		}
			
{NUMBER}	{words++; chars += strlen(yytext);
			  printf("%s : NUMBER\n",yytext);
			}

"{" {chars++; 
	printf("%6s : LEFTCURLYBRACE\n",yytext);}

"}" 	{chars++; 
		printf("%6s : RIGHTCURLYBRACE\n",yytext);}
			
";"		{chars++;
		 printf("%s : SEMICOLON \n", yytext);
		}

","		{chars++; 
		printf("%s: Comma \n", yytext);}
		
"="		{chars++;
		 printf("%s : EQ\n", yytext);
		}

"(" 	{chars++; 
		printf("%6s : LEFTPARENTHESES\n",yytext);}

")" 	{chars++; 
		printf("%6s : RIGHTPARENTHESES\n",yytext);}

"[" 	{chars++; 
		printf("%6s : LEFTBRACKET\n",yytext);}

"]" 	{chars++; 
		printf("%6s : RIGHTBRACKET\n",yytext);}


{BinOp} {chars++;
		 printf("%s : Operator\n", yytext);
		}

"!"		{chars++;
		 printf("%s : Unary Operator\n", yytext);
		}

[\n]	{lines++; chars=0;}
[ \t]	{chars++;}
.		{chars++;
		 errors++;
         printf("%s : Unrecognized symbol at line %d char %d\n", yytext,lines,chars);
		}
%%

//Code Section
int main(int argc, char**argv)
{
	#ifdef YYDEBUG
		yydebug = 1;
	#endif

	printf("Compiler started. \n\n");

    //this opens up our test program to run the lexer through
	if (argc > 1){
	  if(!(yyin = fopen(argv[1], "r")))
          {
		perror(argv[1]);
		return(1);
	  }
	}
	yylex();
    
     //prints our total numbers of all of the declared variables from the top
	 printf("Lines: %8d\nWords: %8d\nChars: %8d\nErrors: %7d\n", lines, words, chars, errors);
	 
	 //Certifies sourse code is correct
	 if(errors == 0) {
		printf("The Source code is correct. \n");
	 }
}