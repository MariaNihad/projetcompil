%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "y.tab.h"
#include "lex.yy.h"

// Déclarations de fonctions
void verifierDeclaration(char *nom);
void verifierDoubleDeclaration(char *nom);
void verifierType(int type1, int type2);
%}

%union {
    int entier;
    float reel;
    char* str;
    int type;
}

%token <str> IDF
%token <entier> CST_NUM
%token <reel> CST_REAL
%token <str> CST_TEXT
%token mc_DEBUT mc_FIN mc_EXECUTION mc_NUM mc_REAL mc_TEXT mc_FIXE
%token mc_SI mc_ALORS mc_SINON mc_TANTQUE mc_FAIRE mc_AFFICHE mc_LIRE
%token AFFECT /* Pour "<-" */
%token PLUS MOINS FOIS DIV /* Pour "+", "-", "*", "/" */
%token EGAL DIFF /* Pour "=", "!=" */
%token INF INF_EGAL SUP SUP_EGAL /* Pour "<", "<=", ">", ">=" */
%token OUVRE_ACCOLADE FERME_ACCOLADE POINT_VIRGULE

%start programme

%%

programme:
    mc_DEBUT declarations mc_EXECUTION OUVRE_ACCOLADE instructions FERME_ACCOLADE mc_FIN
    {
        printf("Programme syntaxiquement correct\n");
    }
;

declarations:
    | declarations declaration
;

declaration:
    type ':' IDF POINT_VIRGULE {
        verifierDeclaration($3);
    }
    | mc_FIXE type ':' IDF '=' CST_NUM POINT_VIRGULE {
        verifierDeclaration($4);
        verifierConstanteModifiable($4);
    }
;

type: mc_NUM | mc_REAL | mc_TEXT;

instructions:
    | instructions instruction
;

instruction:
    IDF AFFECT expression POINT_VIRGULE { verifierDeclaration($1); }
    | mc_AFFICHE '(' expression ')' POINT_VIRGULE
    | mc_LIRE '(' IDF ')' POINT_VIRGULE { verifierDeclaration($3); }
    | mc_SI '(' condition ')' mc_ALORS OUVRE_ACCOLADE instructions FERME_ACCOLADE mc_SINON OUVRE_ACCOLADE instructions FERME_ACCOLADE
    | mc_TANTQUE '(' condition ')' mc_FAIRE OUVRE_ACCOLADE instructions FERME_ACCOLADE
;

expression:
    CST_NUM { $$ = $1; }
    | CST_REAL { $$ = $1; }
    | IDF { $$ = rechercher($1); }
    | expression PLUS expression {
        if ($1 == $3) {
            $$ = $1 + $3;
        } else {
            printf("Erreur de type : Addition entre types incompatibles\n");
            $$ = 0;
        }
    }
    | expression MOINS expression {
        if ($1 == $3) {
            $$ = $1 - $3;
        } else {
            printf("Erreur de type : Soustraction entre types incompatibles\n");
            $$ = 0;
        }
    }
    | expression FOIS expression {
        if ($1 == $3) {
            $$ = $1 * $3;
        } else {
            printf("Erreur de type : Multiplication entre types incompatibles\n");
            $$ = 0;
        }
    }
    | expression DIV expression {
        if ($3 == 0) {
            printf("Erreur : Division par zéro\n");
            $$ = 0;
        } else if ($1 == $3) {
            $$ = $1 / $3;
        } else {
            printf("Erreur de type : Division entre types incompatibles\n");
            $$ = 0;
        }
    }
;

condition:
    expression EGAL expression
    | expression DIFF expression
    | expression INF expression
    | expression SUP expression
    | expression INF_EGAL expression
    | expression SUP_EGAL expression
;

%%

void verifierDeclaration(char *nom) {
    if (rechercher(nom) == -1) {
        printf("Erreur sémantique : Variable '%s' non déclarée\n", nom);
    }
}

void verifierDoubleDeclaration(char *nom) {
    if (rechercher(nom) != -1) {
        printf("Erreur sémantique : Variable '%s' déjà déclarée\n", nom);
    }
}

void verifierType(int type1, int type2) {
    if (type1 != type2) {
        printf("Erreur de type : Incompatibilité entre types\n");
    }
}

void verifierDivisionZero(int denominateur) {
    if (denominateur == 0) {
        printf("Erreur : Division par zéro\n");
    }
}

void verifierConstanteModifiable(char *nom) {
    // Implémentation nécessaire
}

int rechercher(char *nom) {
    // Recherche d'une variable dans la table des symboles
    return -1;  // Exemple de retour
}
