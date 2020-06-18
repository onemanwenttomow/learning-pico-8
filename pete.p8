pico-8 cartridge // http://www.pico-8.com
version 27
__lua__
function _init()
	player = {x=50, y=50}
	playerxd = 1
	playeryd = 1
	cls()
	rectfill(0,0,127,127,1)
	print("♥", player.x, player.y, 5)
end

function _update()
	move_hero()
	rectfill(0,0,127,127,1)
	sfx(0)
	print("♥", player.x, player.y, 5)
	
end

function move_hero()
  if btn(0) then
    player.x -= 1
  elseif btn(1) then
    player.x += 1
  elseif btn(2) then
    player.y -= 2
  elseif btn(3) then
    player.y += 2
  end
end

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000080800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000008000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
00090000324403253031520305202542025420244102a55024450275502345023450255502545025450235502355023550235502255020550205501e5501d5501c5501a550185101650013500105000f50001300
002000002453029520305202a5201f5201b5201c52023520295202a5202052023520255202752023520235202552026520275202a520275202152024520275202c52027520275202a5202a520255102451025510
