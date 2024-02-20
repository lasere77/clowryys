CXX = nasm
EXEC = clowryys.exe

build: assembledSource linkingObject
start: assembledSource linkingObject run clean

assembledSource: src/Main.asm
	$(CXX) -f elf64 src/*.asm -o Main.o 

linkingObject: Main.o
	ld Main.o -o ./bin/$(EXEC)

run: bin/$(EXEC)
	./bin/$(EXEC)

clean:
	rm *.o