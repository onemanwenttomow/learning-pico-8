pico-8 cartridge // http://www.pico-8.com
version 27
__lua__
function _init()
 cls() 
 mode="start"
 level="bxbxbxbxbx/xbxbxbxbxb/bxbxbxbxbx/xbxbxbxbxb/bxbxbxbxbx"
 debug=""
end

function _update60()
	if mode=="game" then
	 draw_game()
	elseif mode=="start" then
		draw_start()
	elseif mode=="gameover" then
		draw_gameover()
	end
end

function _draw()
	if mode=="game" then
	 update_game()
	elseif mode=="start" then
		update_start()
	elseif mode=="gameover" then
		update_gameover()
	end	
end

function update_game()

 local	buttpress=false
 local nextx, nexty, brickhit
	
	if btn(0) then
		--left
		pad_dx=-2.5	
		buttpress=true
		--pad_x-=5
		if sticky then
			ball_dx=-1
		end
	end
	
	if btn(1) then
		--right
		pad_dx=2.5
		buttpress=true
 	--pad_x+=5
 	if sticky then
 		ball_dx=1
 	end
	end
	
	if sticky and btnp(5) then
		sticky=false
	end
	
	if not(buttpress) then
		pad_dx = pad_dx/1.8
	end
	
	pad_x+=pad_dx
	pad_x=mid(0,pad_x, 127-pad_w)
	
	if sticky then
		ball_x=pad_x+flr(pad_w/2)
		ball_y=pad_y-ball_r-1
	else
		-- regular ball physics
		nextx = ball_x + ball_dx
		nexty = ball_y + ball_dy
	
		if nextx > 125 or nextx < 2 then
			--3 params
			-- somewhere between 0 and 127
			nextx=mid(0,nextx,127)
			ball_dx = -ball_dx
			sfx(0)
		end
		
		if nexty < (6 + ball_r*2) then
			nexty=mid(0,nexty,127)
			ball_dy = -ball_dy
			sfx(0)
		end
		
	
		-- check if ball hit pad
		if ball_box(nextx, nexty,pad_x, pad_y, pad_w, pad_h) then
			-- deal with collision
			-- find out in which direction to deflect
		 if	deflx_ball_box(ball_x,ball_y,ball_dx,ball_dy,pad_x,pad_y,pad_w,pad_h) then
		 	-- ball hit paddle on side
		 	ball_dx = -ball_dx
		 	if ball_x < pad_x+pad_w/2 then
		 		nextx=pad_x-ball_r
		 	else 
		 		nextx=pad_x+pad_w+ball_r
		 	end
		 else 
		 	-- ball hit paddle on top
		 	ball_dy = -ball_dy
		 	nexty=pad_y-ball_r
		 	if abs(pad_dx) > 2 then
		 		-- change angle
		 		if sign(pad_dx)==sign(ball_dx) then
		 				-- flatten angle
		 				setang(mid(0,ball_ang-1,2))
		 			else 
		 				--raise angle
		 				setang(mid(0,ball_ang+1,2))
		 			end
		 	end
		 end
		 sfx(1)
		 chain=1
		end
		
		-- check if ball hit brick
		brickhit=false
		for i=1,#brick_x do
			if brick_v[i] and ball_box(nextx, nexty,brick_x[i], brick_y[i], brick_w, brick_h) then
				-- deal with collision
				-- find out in which direction to deflect
		 	if not(brickhit) then
			 	if	deflx_ball_box(ball_x,ball_y,ball_dx,ball_dy,brick_x[i],brick_y[i],brick_w,brick_h) then
			 		ball_dx = -ball_dx
				 else 
			 		ball_dy = -ball_dy
				 end
		 	end
			 brickhit=true
			 sfx(2+chain)
			 brick_v[i]=false
			 points+=10*chain
			 chain+=1
			 chain = mid(1, chain, 7)
			end
		end
		
		
		ball_x=nextx
		ball_y=nexty
		
		if nexty > 127 then
			sfx(2)
			lives-=1
			if lives<0 then
				gameover()
			else
				serveball()
			end
		end
	end
end

function serveball()
	ball_x=pad_x+flr(pad_w/2)
	ball_y=pad_y-ball_r
	ball_dx=1
	ball_dy=-1
	ball_ang=1
	
	sticky=true
	chain=1
	
end

function setang(ang)
	ball_ang=ang
	if ang==2 then
		ball_dx=0.50*sign(ball_dx)
		ball_dy=1.30*sign(ball_dy)
	elseif ang==0 then
		ball_dx=1.30*sign(ball_dx)
		ball_dy=0.50*sign(ball_dy)
	else
		ball_dx=1*sign(ball_dx)
		ball_dy=1*sign(ball_dy)
	end
end

function sign(n) 
	if n<0 then
		return -1
	elseif n>0 then
		return 1
	else
		return 0
	end
end

function update_start()
	if btn(5) then
		startgame()
	end
end

function update_gameover()
	if btn(5) then
		startgame()
	end
end

function draw_start()
	cls()
	print("pico hero breakout", 30, 40, 7)
	print("press ❎ to start", 32, 80, 11)
end

function draw_gameover()
	--cls()
	rectfill(0,60,128,78,0)
	print("game over",46,62,7)
	print("press ❎ to restart",26,72,6)
end

function draw_game()
	local i
	
	cls(1)
	circfill(ball_x, ball_y, ball_r,10)
	if sticky then
		-- serve preview
		line(ball_x+ball_dx*4,ball_y+ball_dy*4,ball_x+ball_dx*7,ball_y+ball_dy*7,11)
	end
	
	rectfill(pad_x, pad_y, pad_x + pad_w, pad_y + pad_h, pad_c)	

	--draw bricks
	for i=1,#brick_x do
		if brick_v[i] then	
 		rectfill(brick_x[i], brick_y[i], brick_x[i] + brick_w, brick_y[i] + brick_h,14)	
		end
	end
	
	if debug!="" then
		print("debug:"..debug,1,1,0)
	else
		
		rectfill(0,0,127,6,4)
		print("lives:"..lives,1,1,0)
		print("score:"..points,35,1,0)
	end
end

function startgame()
	mode="game"
	 
	ball_r=2

	pad_x=52
	pad_y=120
	pad_dx=0	
	pad_w=24
	pad_h=3
	pad_c=7
		
	brick_w=10
	brick_h=4
	buildbricks(level)

	lives=3
	points=0
	
	sticky=true
	chain=1 --combo chain
	
	serveball()
end

function buildbricks(lvl) 
	local i,j,o, char,last
	brick_x={}
	brick_y={}
	brick_v={}
	
	j=0
	for i=1,#lvl do
		j+=1
		char=sub(lvl,i,i)
		
		if char=="b" then
			last="b"
			add(brick_x,4+((j-1)%11)*(brick_w+2))
			add(brick_y,20+flr((j-1)/11)*(brick_h+2))
			add(brick_v,true)
		elseif char=="x" then
			last="x"
		elseif char=="/" then		
			j=(flr((j-1)/11)+1)*11
		elseif char>="1" and char <="9" then
			debug=char
			for o=1,char+0 do
				if last=="b" then 
					add(brick_x,5+((j-1)%8)*(brick_w+5))
					add(brick_y,20+flr((j-1)/8)*(brick_h+3))
					add(brick_v,true)
				elseif last=="x" then
					--nothing
				end
				j+=1
			end
			j-=1
		end	 
	end
end

function gameover() 
	mode="gameover"
end

function ball_box(bx,by,box_x, box_y, box_w, box_h)
 -- checks for collision of ball with rectangle
 if by-ball_r > box_y + box_h then return false end
 if by+ball_r < box_y then	return false end
 if bx-ball_r > box_x + box_w then	return false end
 if bx+ball_r < box_x then	return false end
	return true
end

function deflx_ball_box(bx,by,bdx,bdy,tx,ty,tw,th)
 local slp = bdy / bdx
 local cx, cy
 if bdx == 0 then
  return false
 elseif bdy == 0 then
  return true
 elseif slp > 0 and bdx > 0 then
  cx = tx - bx
  cy = ty - by
  return cx > 0 and cy/cx < slp
 elseif slp < 0 and bdx > 0 then
  cx = tx - bx
  cy = ty + th - by
  return cx > 0 and cy/cx >= slp
 elseif slp > 0 and bdx < 0 then
  cx = tx + tw - bx
  cy = ty + th - by
  return cx < 0 and cy/cx <= slp
 else
  cx = tx + tw - bx
  cy = ty - by
  return cx < 0 and cy/cx >= slp
 end
end




__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
00010000203501f3401d3301b3101a3002330022300213001d3001d3002330023700227003c7001b100003000030000300003001a3001a3000030001300023000430005300053000530005300053000330001300
00010000160601504013030130202c3002c3001c50023500295002a5002050023500255002750023500235002550026500275002a500275002150024500275002c50027500275002a5002a500255002450025500
00040000214501f4501d4501b4501745015450104500d4500a4500745005450024500045006050030500000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000300002b0302c0302e0202e0502e000300000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000300002c0302d0302f020300502e000300000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000300002e0302f03031020320502e000300000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000300002e0303003032020340502e000300000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00030000300303203034020370502e000300000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00030000330303403035020370502e000300000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
