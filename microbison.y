%{
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
extern char *yytext;
extern int yyleng;
extern int yylex(void);
extern void yyerror(char*);

typedef struct {
    char nombre[32+1];
    } RegTS; 

void guardarIdentificador(RegTS [],int*);
void ordenadorDeListas(RegTS [],int);
int busquedaBinaria(RegTS [], int, char*);

RegTS TS[1000];
int espaciosOcupado = 0;
int resultado = 0;

%}
%union{
 char* cadena;
 int num;
}
%token INICIO FIN LEER ESCRIBIR MAS RESTA ASIGNACION PARENTESISIZQUIERDO PARENTESISDERECHO COMA PUNTOCOMA FDT
%token <cadena> ID
%token <num> CONSTANTE
%%
objetivo:programa FDT {printf("Terminado\n");}
;
programa:INICIO listasentencias FIN
;
listasentencias:sentencia
|listasentencias sentencia
;
sentencia:identificador ASIGNACION expresion PUNTOCOMA
|LEER PARENTESISIZQUIERDO listaidentificadores PARENTESISDERECHO PUNTOCOMA
|ESCRIBIR PARENTESISIZQUIERDO listaexpresiones PARENTESISDERECHO PUNTOCOMA
;
listaidentificadores:identificador
|listaidentificadores COMA identificador
;
listaexpresiones:expresion
|listaexpresiones COMA expresion
;
expresion:primaria
|expresion operadoraditivo primaria
;
primaria:identificador
|CONSTANTE
|PARENTESISIZQUIERDO expresion PARENTESISDERECHO
;
operadoraditivo:MAS
|RESTA
;
identificador:ID {if(yyleng>32)yyerror("ERROR LEXICO\n");guardarIdentificador(TS,&espaciosOcupado);}
;
%%
int main(){
yyparse();
}

void guardarIdentificador(RegTS TS[1000], int *espaciosOcupado){
    printf ("MESSI123 %d\n",*espaciosOcupado);
    if(*espaciosOcupado == 0){
        strncpy(TS[*espaciosOcupado].nombre, yytext, 32);
        (*espaciosOcupado)++;
        printf ("MESSI %d\n",*espaciosOcupado);
    }else{
    if((*espaciosOcupado)!=1){
        ordenadorDeListas(TS,*espaciosOcupado);}
    
    resultado = busquedaBinaria(TS,*espaciosOcupado,yytext);

    if(resultado == -1){
        strncpy(TS[*espaciosOcupado].nombre, yytext, 32);
        (*espaciosOcupado)++;
    } else{
        yyerror("ERROR SEMANTICO POR COINCIDENCIA DE NOMBRES DE IDENTIFICADORES\n");
    }}
}

void ordenadorDeListas(RegTS TS[1000],int espaciosOcupado){
    char temp[32+1];
    for (int i = 0; i < espaciosOcupado - 1; i++) {
        for (int j = 0; j < espaciosOcupado - i - 1; j++) {
            if (strcmp(TS[j].nombre, TS[j + 1].nombre) > 0) {
                strcpy(temp, TS[j].nombre);
                strcpy(TS[j].nombre, TS[j + 1].nombre);
                strcpy(TS[j + 1].nombre, temp);
            }
        }
    }
}

int busquedaBinaria(RegTS TS[1000],int espaciosOcupado,char* clave) {
    int inicio = 0;
    int fin = espaciosOcupado - 1;

    while (inicio <= fin) {
        int medio = inicio + (fin - inicio) / 2;

        int comparacion = strcmp(TS[medio].nombre, clave);

        if (comparacion == 0) {
            return medio;  // Encontró la clave
        } else if (comparacion < 0) {
            inicio = medio + 1;  // Buscar en la mitad derecha
        } else {
            fin = medio - 1;  // Buscar en la mitad izquierda
        }
    }

    return -1;
}