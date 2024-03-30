CXX = nasm
EXEC = clowryys.exe

build: assembledSource linkingObject
start: assembledSource linkingObject run clean
gdb: assembledSource linkingObject debug clean

assembledSource: src/Main.asm
	$(CXX) -f elf64 src/Main.asm -o Main.o 

linkingObject: Main.o
	ld Main.o -o ./bin/$(EXEC)

debug: bin/$(EXEC)
	gdb ./bin/$(EXEC)

run: bin/$(EXEC)
	./bin/$(EXEC) ./Prog/ProgExample.cly

clean:
	rm *.o