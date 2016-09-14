-- LOVE2D game inspired by Ennuigi
loveterm = require "loveterm"
codes = require "extra/cp437"
palettes = require "extra/color"
palette = palettes.c64
-- First, variables. Make some here.
offsetx,offsety = 0,0 -- Offset of the view.
selectx,selecty = 0,0 -- Cursor position
linex,liney = -1,-1 -- drawing a line
rectx,recty = -1, -1 -- drawing a box
mode = 1 -- current mode
modes = {"type","special"}
mapScreen = nil -- the map we're looking at
bgcol,fgcol = {0,0,0},{255,255,255}
brush = 0 -- Color and character to paint

-- custom functions
function newMap(w,h)
  mapScreen = loveterm.create("tilesets/CGA8x8thick.png",w,h)
end

shiftMovement = {
	["up"] = function () offsety = offsety - 1 end,
	["down"] = function () offsety = offsety + 1 end,
	["left"] = function () offsetx = offsetx - 1 end,
	["right"] = function () offsetx = offsetx + 1 end
}

normMovement = {
	["up"] = function () selecty = selecty - 1 end,
	["down"] = function () selecty = selecty + 1 end,
	["left"] = function () selectx = selectx - 1 end,
	["right"] = function () selectx = selectx + 1 end
}
--callbacks

function love.load()
  -- Init LoveTerm
  newMap(32,32)
  mapScreen:rectangle('line',8,8,16,16)
  paletteScreen = loveterm.create("tilesets/CGA8x8thick.png",2,2)
  paletteScreen:setValue(0,0,0)
  -- Need to have repeat and textinput on.
  love.keyboard.setKeyRepeat(true)
  love.keyboard.setTextInput(true)
end

function love.update(dt)
  paletteScreen:setValue(brush,0,1)
  paletteScreen:setValue(brush+1,1,1)
  if brush-1 >= 1 then
    paletteScreen:setValue(brush-1,0,0)
  else
    paletteScreen:setValue(0,0,0)
  end
end

function love.keypressed(key,scan,rep)
  if key == 'escape' then -- quit
    love.event.quit()
  end
  if key == "up" or "down" or "left" or "right" then
    if love.keyboard.isDown("lshift") or love.keyboard.isDown("rshift") then
      if shiftMovement[key] ~= nil then
	shiftMovement[key]()
      end
    else     
      if normMovement[key] ~= nil then
	normMovement[key]()
      end
    end
  end
  if not rep then
    if key == "tab" then -- cycle mode 
      if mode < #modes then
	mode = mode +1
      else
	mode = 1
      end
    end 
    if key == "=" then
      if love.keyboard.isDown("lshift") or love.keyboard.isDown("rshift") then
	brush = brush + 8 
      else
	brush = brush + 1
      end
    end
    if key == "-" and brush >= 1 then
      if love.keyboard.isDown("lshift") or love.keyboard.isDown("rshift") then
	brush = brush - 8
      else
	brush = brush - 1
      end
    end
    if key == "return" then
      if love.keyboard.isDown("lshift") or love.keyboard.isDown("rshift") then
	if linex == -1 and liney == -1 then
	  linex, liney = selectx,selecty
	elseif linex ~= -1 and liney ~= -1 then
	  mapScreen:line(linex,liney,selectx,selecty,fgcol,bgcol,brush)
	  linex,liney = -1,-1
	end
      else	
	mapScreen:setValue(brush,selectx,selecty)
      end
    end
    if key == "space" then
      mapScreen:setValue(0,selectx,selecty)
    end
  end 
end

function love.mousepressed(x,y,btn,touch)
  if btn == 1 then
    selectx,selecty = math.floor(x/8),math.floor(y/8)
  end
end

function love.draw()
  mapScreen:draw(offsetx,offsety) -- The working file.
  love.graphics.setColor(palette.cyan) -- The cursor.
  love.graphics.rectangle('line',selectx*8,selecty*8,8,8)
  if linex ~= -1 and liney ~= -1 then -- The line cursor.
    love.graphics.setColor(palette.green)
    love.graphics.rectangle('line',linex*8,liney*8,8,8)
    love.graphics.line((linex*8)+4,(liney*8)+4,(selectx*8)+4,(selecty*8)+4)
  end
  love.graphics.setColor(255,255,255)
  paletteScreen:draw(0,love.graphics.getHeight()-16)
  love.graphics.setColor(palette.grey)
  love.graphics.rectangle('line',0,love.graphics.getHeight()-16,16,16)
  love.graphics.setColor(palette.lightgrey)
  love.graphics.rectangle('line',0,love.graphics.getHeight()-8,8,8)
  love.graphics.setColor(255,255,255)
end
