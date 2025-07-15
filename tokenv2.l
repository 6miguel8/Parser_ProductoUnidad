%{
#include <stdio.h> 
// Incluir la librería estándar para entrada/salida (printf, fprintf, fopen, etc.)

#include "tokenizer.tab.h" 
// Incluir el archivo de encabezado generado por Bison/Yacc.
// Aquí se definen los tokens y la unión YYSTYPE para yylval.

FILE *out_file; 
// Puntero para manejar un archivo de salida (opcional, no se usa en todas las reglas)

int line_number = 1; 
// Contador de línea, inicia en 1. Se incrementa cada vez que Flex detecta '\n'.

#define MAX_TOKENS 2048 
// Máximo número de tokens que se pueden almacenar.

#define MAX_VALUE_LEN 128 
// Longitud máxima de la cadena para guardar valores léxicos o nombres.

typedef struct {
    char type[32];               // Tipo de token (ejemplo: IF, IDENTIFIER)
    char value[MAX_VALUE_LEN];   // Valor léxico real (ejemplo: "if", "main", "x")
    int line;                    // Línea en la que aparece en el código fuente
} Token; 
// Estructura para representar un token léxico completo.

Token tokens[MAX_TOKENS]; 
// Arreglo global para guardar todos los tokens encontrados.

int token_count = 0; 
// Contador global para saber cuántos tokens se han guardado.

typedef struct {
    char name[MAX_VALUE_LEN];    // Nombre de la variable (ejemplo: "x")
    char value[MAX_VALUE_LEN];   // Valor asociado (opcional, ej. "10")
    char type[32];               // Tipo de variable (ejemplo: int, float)
    int line;                    // Línea donde se declaró o usó
} Variable; 
// Estructura para guardar información de variables (por ejemplo, en una tabla de símbolos).

Variable variables[MAX_TOKENS]; 
// Arreglo para guardar todas las variables encontradas.

int variable_count = 0; 
// Contador de cuántas variables se han guardado.

void add_token(const char* type, const char* value, int line) {
// Función auxiliar para agregar un token al arreglo de tokens.

    if (token_count < MAX_TOKENS) {
        strncpy(tokens[token_count].type, type, sizeof(tokens[token_count].type)-1);
        // Copia el tipo de token, ej. "IF"
        strncpy(tokens[token_count].value, value, sizeof(tokens[token_count].value)-1);
        // Copia el valor léxico, ej. "if"
        tokens[token_count].line = line; 
        // Guarda la línea
        token_count++; 
        // Incrementa el contador de tokens
    }
}

void add_variable(const char* name, const char* value, const char* type, int line) {
// Función auxiliar para registrar una variable. No se usa en las reglas del lexer,
// pero está lista para usarse en la etapa del parser o para expandir el lexer.

    if (variable_count < MAX_TOKENS) {
        strncpy(variables[variable_count].name, name, sizeof(variables[variable_count].name)-1);
        variables[variable_count].name[sizeof(variables[variable_count].name)-1] = '\0';
        strncpy(variables[variable_count].value, value, sizeof(variables[variable_count].value)-1);
        variables[variable_count].value[sizeof(variables[variable_count].value)-1] = '\0';
        strncpy(variables[variable_count].type, type, sizeof(variables[variable_count].type)-1);
        variables[variable_count].type[sizeof(variables[variable_count].type)-1] = '\0';
        variables[variable_count].line = line;
        variable_count++;
    }
}

void write_tokens() {
// Función para escribir todos los tokens registrados a un archivo de salida.
// El archivo se llama "tokens_output.txt".

    FILE *tokfile = fopen("tokens_output.txt", "w");
    if (!tokfile) return; // Si no se puede abrir, salir

    fprintf(tokfile, "%-15s %-20s %-12s\n", "Token", "Value", "Line Number");
    fprintf(tokfile, "-----------------------------------------------\n");
    for (int i = 0; i < token_count; ++i) {
        fprintf(tokfile, "%-15s %-20s %-12d\n",
            tokens[i].type, tokens[i].value, tokens[i].line);
    }

    fclose(tokfile);
}
%}
