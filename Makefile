nihil.smc: nihil.o memmap.cfg
	ld65 -C memmap.cfg -o nihil.smc nihil.o

nihil.o: nihil.s
	ca65 --cpu 65816 -s -o nihil.o nihil.s

.PHONY: clean

clean:
	rm -f nihil.o nihil.smc
