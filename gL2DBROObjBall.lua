BALL = class('BALL')

function BALL:initialize(world,x,y)
    self.cCurrent = 0;
    self.XStart = x
    self.YStart = y
    self.width = 10
    self.height = 10
    
    self.ball_speed_x = 150
    self.ball_speed_y = 150
    
    self.Collider = Collider:addRectangle(x,y,self.width,self.height)
end

function BALL:gDraw()
    love.graphics.setColor(255,255,255)
    self.Collider:draw('fill')
end

function BALL:gUpdate(dt,array)
    self.Collider:move(self.ball_speed_x * dt,self.ball_speed_y * dt)
end

function BALL:goUp()
    self.ball_speed_y = -math.abs(self.ball_speed_y)
end

function BALL:goDown()
   self.ball_speed_y = math.abs(self.ball_speed_y)
end

function BALL:goRight()
    self.ball_speed_x = math.abs(self.ball_speed_x)
end

function BALL:goLeft()
    self.ball_speed_x = -math.abs(self.ball_speed_x)
end

function BALL:SetSpeed(x,y)
    self.ball_speed_x = x
    self.ball_speed_y = y
end