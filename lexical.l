%{
#include "y.tab.h"
#include <stdio.h>

int num_lignes = 1;  // Variable pour compter les lignes
%}

%%

"DEBUT"         return mc_DEBUT;
"FIN"           return mc_FIN;
"EXECUTION"     return mc_EXECUTION;
"NUM"           return mc_NUM;
"REAL"          return mc_REAL;
"TEXT"          return mc_TEXT;
"FIXE"          return mc_FIXE;
"SI"            return mc_SI;
"ALORS"         return mc_ALORS;
"SINON"         return mc_SINON;
"TANTQUE"       return mc_TANTQUE;
"FAIRE"         return mc_FAIRE;
"lire"          return mc_LIRE;
"affiche"       return mc_AFFICHE;

[0-9]+          return CST_NUM;
[0-9]+\.[0-9]+  return CST_REAL;
\"[^\"]*\"      return CST_TEXT;

[A-Z][a-zA-Z0-9_]{0,9} return IDF;  // Identificateur


"--"[^#]*"##"                 { printf("Commentaire ligne : %s\n", yytext); }
"{-"[^-]*"-}"                 { printf("Commentaire multi-lignes : %s\n", yytext); }

"+"             return PLUS;
"-"             return MOINS;
"*"             return FOIS;
"/"             return DIV;

"<="            return INF_EGAL;
">="            return SUP_EGAL;
"="             return EGAL;
"!="            return DIFF;

"{"             return OUVRE_ACCOLADE;
"}"             return FERME_ACCOLADE;
";"             return POINT_VIRGULE;

[ \t]+          /* Ignorer les espaces et tabulations */

\n              { num_lignes++; }  // Incrémente le numéro de ligne chaque fois qu'une nouvelle ligne est rencontrée

.               {
                   printf("Erreur lexicale : caractère non reconnu '%s'\n", yytext);
                   return -1; // Retourne un code d'erreur pour caractères non reconnus
                }

%%

int main() {
    yylex();  // Appel au lexer pour traiter le code source
    printf("Nombre total de lignes : %d\n", num_lignes);  // Affiche le nombre total de lignes lues
    return 0;
}