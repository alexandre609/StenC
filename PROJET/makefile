LEX = flex
YACC = yacc -d -v
CC = gcc -Wall -g
LIBS = -lfl -ly
vpath main bin
vpath %.h  include
vpath %.o  obj
vpath %.c  src
vpath %.l  src
vpath %.y  src
BIN     = ./bin/
INCLUDE = ./include/
OBJ     = ./obj/
SRC     = ./src/


exec : y.tab.o lex.yy.o quad.o symbolTable.o
	$(CC) -o exec $(OBJ)y.tab.o $(OBJ)lex.yy.o $(OBJ)quad.o $(OBJ)symbol.o $(LIBS)
	mv $@ $(BIN)
	
	
quad.o : $(SRC)quad.c
	$(CC) -c $<
	mv $@ $(OBJ)
symbol.o : $(SRC)symbol.c
	$(CC) -c $<
	mv $@ $(OBJ)
y.tab.o : y.tab.c
	$(CC) -c $<
	mv $@ $(OBJ)
lex.yy.o : lex.yy.c
	$(CC) -c $<
	mv $@ $(OBJ)
y.tab.c y.tab.h : expr.y 
	$(YACC) $<
	mv y.output $(OBJ)
lex.yy.c : expr.l
	$(LEX) $<
	

archive :
	tar -zcvf projet_compilation_florentin_brunnemer.tar.gz *

clean :
	mv lex.yy.c $(BIN)
	mv y.tab.c $(BIN)
	mv y.tab.h $(BIN)
	rm -f $(BIN)* $(OBJ)*

gdb :
	gdb -q $(BIN)exec

geany :
	geany $(INCLUDE)* $(SRC)* &

run :
	$(BIN)./exec test.c

valgrind :
	valgrind --tool=memcheck --leak-check=full --track-origins=yes --show-reachable=yes -v $(BIN)main
