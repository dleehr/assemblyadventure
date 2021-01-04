FirstSprite.smc: SpriteDemo.o memmap.cfg
	ld65 -C memmap.cfg -o FirstSprite.smc SpriteDemo.o

SpriteDemo.o: SpriteDemo.s Sprites.vra SpriteColors.pal
	ca65 --cpu 65816 -s -o SpriteDemo.o SpriteDemo.s

.PHONY: clean

clean:
	rm -f SpriteDemo.o FirstSprite.smc
