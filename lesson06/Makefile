collatz.smc: collatz.o memmap.cfg
	ld65 -C memmap.cfg -o collatz.smc collatz.o

collatz.o: snes_collatz.s
	ca65 --cpu 65816 -s -o collatz.o snes_collatz.s

.PHONY: clean

clean:
	rm -f collatz.o collatz.smc
