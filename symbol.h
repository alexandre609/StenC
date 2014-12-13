#ifndef __SYMBOL_H__
#define __SYMBOL_H__

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#define N 1024

typedef union
{
	int i;
	// struct
	// {

	// }stencil
	
}value;

typedef struct strSymbol
{
	char type;
	char *label;
	value val;
}*Symbol,strSymbol;



Symbol* st;  //Symbol table
int length;  //longueur courante du tableau
int max_size;//longueur max actuelle du tableau.


void init_st();
void print_st();
int get_index(char* label);
Symbol get_symbol(char* label);   // utilise get_index
Symbol add_or_replace(char *label, value val);
void free_st();

#endif
