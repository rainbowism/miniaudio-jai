all:
	mkdir -p ../linux
	$(CC) -c -O2 -Os -fPIC miniaudio.c
	$(AR) rcs ../linux/miniaudio.a miniaudio.o
	#$(CC) -fPIC -shared -Wl,-soname=miniaudio.so -o ../linux/miniaudio.so miniaudio.o
	rm *.o
