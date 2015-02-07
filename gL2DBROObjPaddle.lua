PADDLE = class('PADDLE')

function PADDLE:initialize(world,x,y)
    self.xPos = x
    self.yPos = y
    self.width = 60
    self.height = 10

    self.Collider = Collider:addRectangle(x,y,self.width,self.height)
end

function PADDLE:gDraw()
    love.graphics.setColor(255,255,255)
    self.Collider:draw('fill')
end