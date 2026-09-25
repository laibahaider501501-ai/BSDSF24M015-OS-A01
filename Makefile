CC = gcc
CFLAGS = -Wall -Wextra -Iinclude

TARGET = bin/client

OBJ = obj/main.o obj/mystrfunctions.o obj/myfilefunctions.o

PREFIX = /usr/local
BINDIR = $(PREFIX)/bin
MANDIR = $(PREFIX)/share/man/man3

all: $(TARGET)

$(TARGET): $(OBJ)
	$(CC) $(OBJ) -o $(TARGET)

obj/main.o: src/main.c
	$(CC) $(CFLAGS) -c src/main.c -o obj/main.o

obj/mystrfunctions.o: src/mystrfunctions.c
	$(CC) $(CFLAGS) -c src/mystrfunctions.c -o obj/mystrfunctions.o

obj/myfilefunctions.o: src/myfilefunctions.c
	$(CC) $(CFLAGS) -c src/myfilefunctions.c -o obj/myfilefunctions.o

install: all
	mkdir -p $(BINDIR)
	mkdir -p $(MANDIR)
	cp $(TARGET) $(BINDIR)/client
	cp man/man3/*.3 $(MANDIR)/

clean:
	rm -f $(OBJ) $(TARGET)
