local initialize = require("init")
local Camera = require("engine/camera")



local offset = 32
local W, H = love.graphics.getDimensions()
-- gets dimensions of game window

local function resizeCamera( self, w, h )
	local scaleW, scaleH = w / self.w, h / self.h
	local scale = math.min( scaleW, scaleH )
	self.w, self.h = scale * self.w, scale * self.h
	self.aspectRatio = self.w / w
	self.offsetX, self.offsetY = self.w / 2, self.h / 2
	offset = offset * scale
end

local levelCam = Camera( W / 2 - 2 * offset, H - 2 * offset, { x = offset, y = offset, resizable = true, maintainAspectRatio = true,
	resizingFunction = function( self, w, h )
		resizeCamera( self, w, h )
		local W, H = love.graphics.getDimensions()
		self.x = offset
		self.y = offset
	end,
	getContainerDimensions = function()
		local W, H = love.graphics.getDimensions()
		return W / 2 - 2 * offset, H - 2 * offset
	end
} )

close = levelCam:addLayer( 'close', 2, { relativeScale = .5 } )
middle = levelCam:addLayer( 'middle', 1.5, { relativeScale = .5 } )
far = levelCam:addLayer( 'far', .5 )






function love.load()
  configExists = initialize.loadConfig()
end




function love.update(dt)
  levelCam:update()
  local moveSpeed = 300 / levelCam.scale
  if love.keyboard.isDown( 'q' ) then levelCam:rotate( math.pi * dt ) end
	if love.keyboard.isDown( 'e' ) then levelCam:rotate( -math.pi * dt ) end
	if love.keyboard.isDown( 'w' ) then levelCam:translate( 0, -moveSpeed * dt ) end
	if love.keyboard.isDown( 's' ) then levelCam:translate( 0, moveSpeed * dt ) end
	if love.keyboard.isDown( 'a' ) then levelCam:translate( -moveSpeed * dt, 0 ) end
	if love.keyboard.isDown( 'd' ) then levelCam:translate( moveSpeed * dt, 0 ) end
end

function love.keyreleased( key ) --press escape to quit
	if key == 'escape' then love.event.quit() end
end

function love.wheelmoved( dx, dy )
	levelCam:scaleToPoint( 1 + dy / 100 )
end



function love.draw()
  levelCam:push()
    levelCam:push('far')
      -- By default, translation is half camera width, half camera height
      -- So this draws a rectangle at the center of the screen.
      love.graphics.setColor( 255, 0, 0)
      love.graphics.rectangle( 'fill', -32, -32, 64, 64 )
  	levelCam:pop('far')
    levelCam:push('middle')
      love.graphics.setColor( 0, 255, 0)
      love.graphics.rectangle( 'fill', -32, -32, 64, 64 )
    levelCam:pop('middle')
    levelCam:push('close')
      love.graphics.setColor( 0, 0, 255)
      love.graphics.rectangle( 'fill', -32, -32, 64, 64 )
    levelCam:pop('close')
  levelCam:pop()

end
