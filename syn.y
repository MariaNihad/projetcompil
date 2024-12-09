%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Déclarations pour les routines sémantiques
void verifierDeclaration(char *nom);
void verifierConstante(char *nom);
void verifierType(char *nom1, char *nom2);
void afficherTableSymboles();
%}

%union {
    int entier;
    float reel;
    char* str;
}

/* Déclaration des tokens */
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
    { printf("Programme syntaxiquement correct\n"); }
;

declarations:
    /* vide */
    | declarations declaration
;

declaration:
    mc_NUM ':' IDF POINT_VIRGULE { verifierDeclaration($3); }
    | mc_REAL ':' IDF POINT_VIRGULE { verifierDeclaration($3); }
    | mc_TEXT ':' IDF POINT_VIRGULE { verifierDeclaration($3); }
    | mc_FIXE mc_NUM ':' IDF '=' CST_NUM POINT_VIRGULE { verifierDeclaration($4); verifierConstante($4); }
;

instructions:
    /* vide */
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
    CST_NUM
    | CST_REAL
    | IDF { verifierDeclaration($1); }
    | expression PLUS expression
    | expression MOINS expression
    | expression FOIS expression
    | expression DIV expression { if ($3 == 0) printf("Erreur : Division par zéro\n"); }
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

/* Vérifications sémantiques */
void verifierDeclaration(char *nom) {
    if (rechercher(nom) == -1) {
        printf("Erreur sémantique : Variable '%s' non déclarée\n", nom);
    }
}

void verifierConstante(char *nom) {
    printf("Vérifier si constante peut être modifiée : %s\n", nom);
}

void afficherTableSymboles() {
    printf("\nTable des symboles :\n");
    for (int i = 0; i < compteur; i++) {
        printf("%s -> %s\n", table[i].NomEntite, table[i].CodeEntite);
    }
}