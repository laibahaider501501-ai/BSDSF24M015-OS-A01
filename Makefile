CC = gcc
CFLAGS = -Wall -Wextra -Iinclude

OBJDIR = obj
LIBDIR = lib
BINDIR = bin

LIB = $(LIBDIR)/libmyutils.a
TARGET = $(BINDIR)/client_static

LIB_OBJS = $(OBJDIR)/mystrfunctions.o $(OBJDIR)/myfilefunctions.o
MAIN_OBJ = $(OBJDIR)/main.o

all: $(TARGET)

$(TARGET): $(MAIN_OBJ) $(LIB)
	$(CC) $(MAIN_OBJ) -L$(LIBDIR) -lmyutils -o $(TARGET)

$(LIB): $(LIB_OBJS)
	ar rcs $(LIB) $(LIB_OBJS)

$(OBJDIR)/mystrfunctions.o: src/mystrfunctions.c include/mystrfunctions.h
	$(CC) $(CFLAGS) -c src/mystrfunctions.c -o $(OBJDIR)/mystrfunctions.o

$(OBJDIR)/myfilefunctions.o: src/myfilefunctions.c include/myfilefunctions.h
	$(CC) $(CFLAGS) -c src/myfilefunctions.c -o $(OBJDIR)/myfilefunctions.o

$(OBJDIR)/main.o: src/main.c include/mystrfunctions.h include/myfilefunctions.h
	$(CC) $(CFLAGS) -c src/main.c -o $(OBJDIR)/main.o

clean:
	rm -f $(OBJDIR)/*.o $(LIB) $(TARGET)
