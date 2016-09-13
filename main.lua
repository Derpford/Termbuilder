-- LOVE2D game inspired by Ennuigi
loveterm = require "loveterm"
codes = require "extra/cp437"
palettes = require "extra/color"
palette = palettes.c64
-- First, variables. Make some here.

-- custom functions
 
-- callbacks

function love.load()
  -- Init LoveTerm
  mapScreen = loveterm.create("tilesets/CGA8x8thick.png",math.floor(love.graphics.getWidth()/8),math.floor(love.graphics.getHeight()/8))
end

function love.update(dt)
 if textBoxQ[1] ~= nil then
    updateTextQ(textBoxQ[1],textBoxQ,1,dt)
  end
end

function love.keypressed(key,scan,rep)
  if key == 'q' then
    love.event.quit()
  end
  if not rep then
    for i in ipairs(textBoxes) do
      keypressTextbox(textBoxes[i],textBoxes,i,key)
    end
  end 
end

function love.draw()
  for i in ipairs(textBoxes) do
    drawTextbox(textBoxes[i])
  end
end
