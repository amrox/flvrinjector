# Makefile for yamdi

CC=gcc
CFLAGS=-O2 -Wall

yamdi: yamdi.c
	$(CC) $(CFLAGS) yamdi.c -o yamdi

universal: yamdi.c
	$(CC) $(CFLAGS) -arch ppc yamdi.c -o yamdi-ppc
	$(CC) $(CFLAGS) -arch i386 yamdi.c -o yamdi-i386
	lipo -create -arch i386 yamdi-i386 -arch ppc yamdi-ppc -output yamdi

clean: yamdi
	rm -f yamdi

install: yamdi
	install $(INSTALL_FLAGS) -m 4755 -o root yamdi $(DESTDIR)/usr/bin
