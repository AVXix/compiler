/* A Bison parser, made by GNU Bison 2.7.  */

/* Bison interface for Yacc-like parsers in C
   
      Copyright (C) 1984, 1989-1990, 2000-2012 Free Software Foundation, Inc.
   
   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.
   
   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Enabling traces.  */
#ifndef YYDEBUG
# define YYDEBUG 1
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     CONTINUE = 258,
     RETURN = 259,
     DOUBLE = 260,
     SWITCH = 261,
     CASE = 262,
     DEFAULT = 263,
     PRINTF = 264,
     ADDOP = 265,
     MULOP = 266,
     RELOP = 267,
     ASSIGNOP = 268,
     LOGICOP = 269,
     INT = 270,
     FLOAT = 271,
     LPAREN = 272,
     RPAREN = 273,
     LCURL = 274,
     RCURL = 275,
     LTHIRD = 276,
     RTHIRD = 277,
     IF = 278,
     ELSE = 279,
     FOR = 280,
     WHILE = 281,
     DO = 282,
     BREAK = 283,
     CONST_INT = 284,
     CONST_FLOAT = 285,
     INCOP = 286,
     DECOP = 287,
     CHAR = 288,
     VOID = 289,
     NOT = 290,
     SEMICOLON = 291,
     COMMA = 292,
     COLON = 293,
     ID = 294,
     GOTO = 295,
     LOWER_THAN_ELSE = 296
   };
#endif
/* Tokens.  */
#define CONTINUE 258
#define RETURN 259
#define DOUBLE 260
#define SWITCH 261
#define CASE 262
#define DEFAULT 263
#define PRINTF 264
#define ADDOP 265
#define MULOP 266
#define RELOP 267
#define ASSIGNOP 268
#define LOGICOP 269
#define INT 270
#define FLOAT 271
#define LPAREN 272
#define RPAREN 273
#define LCURL 274
#define RCURL 275
#define LTHIRD 276
#define RTHIRD 277
#define IF 278
#define ELSE 279
#define FOR 280
#define WHILE 281
#define DO 282
#define BREAK 283
#define CONST_INT 284
#define CONST_FLOAT 285
#define INCOP 286
#define DECOP 287
#define CHAR 288
#define VOID 289
#define NOT 290
#define SEMICOLON 291
#define COMMA 292
#define COLON 293
#define ID 294
#define GOTO 295
#define LOWER_THAN_ELSE 296



#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef int YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif

extern YYSTYPE yylval;

#ifdef YYPARSE_PARAM
#if defined __STDC__ || defined __cplusplus
int yyparse (void *YYPARSE_PARAM);
#else
int yyparse ();
#endif
#else /* ! YYPARSE_PARAM */
#if defined __STDC__ || defined __cplusplus
int yyparse (void);
#else
int yyparse ();
#endif
#endif /* ! YYPARSE_PARAM */

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
