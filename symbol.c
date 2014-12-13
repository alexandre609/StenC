#include "symbol.h"

void init_st()
{	
	length = 0;
	max_size = N;
	st = (Symbol *) malloc (N * sizeof (strSymbol));
	int i;
	for(i=0;i < N;i++)
	{
		st[i] = (Symbol) malloc (sizeof (strSymbol)) ;    // symbol eux meme sont des structures, il faut aussi les allouer
	}
	// next_quad = 0; 
	// id_temp = 0; 
}

void print_st()
{
	if (st != NULL)
	{
		int i;
		for(i=0;i < length;i++)
		{
			if(st[i]->type = 'i')
			{
				printf ("INDEX: %d   LABEL: %s   VALUE: %d \n" 
				, i, st[i]->label, st[i]->val.i);
			}
			else  // affichage des stencil
			{
				// printf ("INDEX: %d   LABEL: %s   VALUE: %d \n" 
				// , i, st[i]->label, st[i]->val->i);
			}
		}
	}
	else 
	{
		printf ("Empty symbol table\n") ;
	}
}

int get_index(char* label)
{
	int index = -1;
	int i;
	for(i=0; i < length; i++)
	{
		if(!strcmp(st[i]->label, label))
		{
			index = i;
			i = length;
		}
	}
	return index;
}

Symbol get_symbol(char* label)   // utilise get_index
{
	int index = get_index(label);
	return index == -1 ? NULL : st[index];
}

Symbol add_or_replace(char* label, value v, char t)
{
	int index = get_index(label);
	if(index != -1)
	{
		st[index]->val = v;
	}
	else
	{	
		index = length;
		if(length == max_size)
		{
			max_size += N;
			st = (Symbol*) realloc(st, max_size * sizeof(Symbol) );
		}
		length++;
		st[index]->label = strdup(label);
		st[index]->val = v;
		st[index]->type = t;
	}
	return st[index];
}

void free_st()
{
	int i;
	for(i=0;i < max_size;i++)
	{
		free(st[i]); 
	}
	free(st);
}

