/**
 * @file    quad.c
 * @brief   Implementer les methodes du fichier "quad.h".
 * @author  Isabelle Muller
 */


# include "../include/quad.h"


Quad Q_new (char o , Symbol a1 , Symbol a2 , Symbol r)
{
	Quad result = (Quad) malloc (sizeof(quad)) ; // Allouer la memoire.
	result -> label = nextQuad ; // Numero du quad.
	result -> operation = o ;
	result -> argument1 = a1 ;
	result -> argument2 = a2 ;
	result -> result = r ;
	result -> next = NULL ; // Pas de suivant.
	nextQuad ++ ; // On ajoute un quad.
	return result ;
}

Quad Q_add (Quad quad1 , Quad quad2)
{
	if (quad1 != NULL) // Si quad1 existe.
	{
		Quad q = quad1 ;
		while (q -> next != NULL) // Parcourir quad1.
		{
			q = q -> next ; // Deplacer le pointeur.
		}
		q -> next = quad2 ; // Ajouter quad2 a quad1.
		return quad1 ; // quad2 est a la suite de quad1.
	}
	return quad2 ; // Car quad1 n'existe pas.
}

QuadList Q_newList (Quad q)
{
	QuadList result = (QuadList) malloc (sizeof (quadList)) ; // Resultat.
	
	result -> q = q ; // Mettre le quad dans la liste.
	result -> next = NULL ; // Pour l'instant il n'y a rien.
	
	return result ; // Retourner la nouvelle liste.
}

QuadList Q_concat (QuadList list1 , QuadList list2)
{
	if (list1 != NULL) // Si list1 existe.
	{
		QuadList l = list1 ; // Pour parcourir list1.
		while (l -> next != NULL) // Parcourir list1.
		{
			l = l -> next ; // Deplacer le pointeur.
		}
		l -> next = list2 ; // Ajouter list2 a list1.
		return list1 ; // list2 est a la suite de list1.
	}
	return list2 ; // list1 est vide.
}

void Q_complete (SymbolTable table , QuadList list , int label)
{
	QuadList listT = list ; // Pointeur pour se deplacer.
	while (listT != NULL)
	{
		listT = listT -> next ; // Deplacer le pointeur.
		if ((listT -> q -> operation == '<') || (listT -> q -> operation == '>') ||
			(listT -> q -> operation == '!') || (listT -> q -> operation == 'e') ||
			(listT -> q -> operation == 'g') || (listT -> q -> operation == 'G') ||
			(listT -> q -> operation == 'l')) // Si c'est une operation booleenne.
		{
			if (listT -> q -> result == NULL) // S'il n'y a pas encore de resultat.
			{
				char * id ;
				asprintf (& id , "temporarySymbol_%d" , idTemporary) ; // Creer le nom d'un symbole temporaire.
				idTemporary ++ ; // Un symbole temporaire de plus est cree.
				listT -> q -> result = S_newSymbol (table , label , id , 'g') ; // Creer un symbole temporaire de portee globale.
			}
		}
	}
}

void Q_printQuad (Quad q0)
{
	Quad q = q0 ;
	while (q != NULL) // Tant que l'on a pas fini de parcourir les quads.
	{
		printf ("%d : (%c" , q -> label , q -> operation) ; // Afficher le label et l'operation.
		printf (" , ") ;
		if (q -> argument1 != NULL)
		{
			printf ("%s" , q -> argument1 -> identifier) ; // Afficher l'id.
		}
		printf (" , ") ;
		if (q -> argument2 != NULL)
		{
			printf ("%s" , q -> argument2 -> identifier) ; // Afficher l'id.
		}
		printf (" , ") ;
		if (q -> result != NULL)
		{
			printf ("%s" , q -> result -> identifier) ; // Afficher l'id.
		}
		printf (")\n") ;
		q = q -> next ;
	}
	printf("\n") ;
}

void Q_printList (QuadList q0)
{
	QuadList q1 = q0 ; // Pointeur temporaire pour parcourir la liste des quads.
	while (q1 != NULL) // Parcourur la liste de quads.
	{
		Q_printQuad (q1 -> q) ;
		q1 = q1 -> next ; // Deplacer le pointeur.
	}
}

void Q_delete (QuadList q)
{
	if (q != NULL) // Si la liste des quads n'est pas vide.
	{
		free (q -> q) ; // Liberer le pointeur.
	}
	free (q) ;
}
