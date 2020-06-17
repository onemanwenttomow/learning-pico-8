pico-8 cartridge // http://www.pico-8.com
version 27
__lua__
name="pete"
petespeed = 1
x=0
y=40

function _init()
	
	print("🐱♥♥♥♥", 90,120, 14)
end

function _update()
	x += petespeed
	if x>127 
	then	petespeed = -1
	end
	
	if x<0 
	then	petespeed = 1
	end

end

function _draw()
 cls()
 print("웃", x, y, 8)
end

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000