BRICK = class('BRICK')

function BRICK:initialize(world,x,y,color)
    self.xPos = x
    self.yPos = y
    self.width = 45
    self.height = 15
    self.bColor = color
    self.Collider = Collider:addRectangle(x,y,self.width,self.height)
    Collider:addToGroup("BRICKS",self.Collider)
    if self.bColor == 1 then
        self.drawnBrick = love.graphics.newImage('gL2DBROGBlueBlock.png')
    elseif self.bColor == 2 then
        self.drawnBrick = love.graphics.newImage('gL2DBROGGreenBlock.png')
    elseif self.bColor == 3 then
        self.drawnBrick = love.graphics.newImage('gL2DBROGOrangeBlock.png')
    elseif self.bColor == 4 then
        self.drawnBrick = love.graphics.newImage('gL2DBROGPurpleBlock.png') 
    else
        self.drawnBrick = love.graphics.newImage('gL2DBROGTealBlock.png') 
    end
end

function BRICK:gDraw()
    love.graphics.draw(self.drawnBrick,self.xPos, self.yPos)
end

function BRICK:Destroy()
    --Collider:setGhost(self.Collider)
    Collider:removeFromGroup("BRICKS",self.Collider)
    Collider:remove(self.Collider)
    self.xPos = nil
    self.yPos = nil
    self.width = nil
    self.height = nil
    self.bColor = nil
    self.drawnBrick = nil
    self = nil
end