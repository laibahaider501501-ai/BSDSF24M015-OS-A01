PICFLAGS = -fPIC

SHARED_LIB = lib/libmyutils.so
DYNAMIC_TARGET = bin/client_dynamic

$(SHARED_LIB): obj/mystrfunctions.o obj/myfilefunctions.o
	gcc -shared -o $(SHARED_LIB) obj/mystrfunctions.o obj/myfilefunctions.o

obj/mystrfunctions.o: src/mystrfunctions.c
	gcc $(CFLAGS) $(PICFLAGS) -c src/mystrfunctions.c -o obj/mystrfunctions.o

obj/myfilefunctions.o: src/myfilefunctions.c
	gcc $(CFLAGS) $(PICFLAGS) -c src/myfilefunctions.c -o obj/myfilefunctions.o

$(DYNAMIC_TARGET): src/main.c $(SHARED_LIB)
	gcc $(CFLAGS) src/main.c -Llib -lmyutils -o $(DYNAMIC_TARGET)
