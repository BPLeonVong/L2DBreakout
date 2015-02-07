class = require 'middleclass'
--to do fix up code, paddle collision
GAME = class('GAME')
function GAME:initialize()
    self.gObjPaddle = PADDLE:new(world,350,500)
    self.gObjBall   = BALL:new(world,350,400)
    self.gObjBrick  = self:generateLevel()

    self.borderTop     = Collider:addRectangle(0,0, 800,50)
    self.borderRight     = Collider:addRectangle(737.5,0, 800,600)
    self.borderBottom     = Collider:addRectangle(0,550, 800,600)
    self.borderLeft     = Collider:addRectangle(0,0, 62.5,600)
    
    self.LeftWall = love.graphics.newImage('gL2DBROGLWall.png')
    self.RightWall = love.graphics.newImage('gL2DBROGLWall.png')
    self.UpWall = love.graphics.newImage('gL2DBROGUpWall.png')
    
    self.txtScore = 0
    self.txtLives = 5
    
end

function GAME:gDraw()
    love.graphics.setBackgroundColor(0,0,0)
    love.graphics.draw(self.LeftWall,0, 0)
    love.graphics.draw(self.RightWall,737.5,0)
    love.graphics.draw(self.UpWall,0, 0)
    
    
    for k, a in pairs (self.gObjBrick) do
        a:gDraw()
    end
    
    self.gObjPaddle:gDraw()
    self.gObjBall:gDraw()
    
    love.graphics.setColor(255,255,255)
    love.graphics.print("Score: "..self.txtScore ,200,10)
    love.graphics.print("Lives: "..self.txtLives ,500,10)
    
end

function GAME:gUpdate(dt)

    if love.keyboard.isDown(" ") then
        self.gObjBall:goUp()
    end 
    
    if self.txtLives <= 0 then
        self:restart()
    end
    
    if table.getn(self.gObjBrick) == 0 and self.txtLives >= 0 then
        self:nextLevel()
    end
    
    self.gObjBall:gUpdate(dt,self.gObjBrick)
    
    if love.keyboard.isDown('right') and self.gObjPaddle.xPos < 730-self.gObjPaddle.width then
        self.gObjPaddle.xPos = self.gObjPaddle.xPos + 10
        self.gObjPaddle.Collider:move(10,0)
    elseif self.gObjPaddle.xPos >  730-self.gObjPaddle.width then
        self.gObjPaddle.xPos =  730-self.gObjPaddle.width
    end
  
    if love.keyboard.isDown('left') and self.gObjPaddle.xPos > 70 then
        self.gObjPaddle.xPos = self.gObjPaddle.xPos - 10
        self.gObjPaddle.Collider:move(-10,0)
    elseif self.gObjPaddle.xPos < 70 then
        self.gObjPaddle.xPos = 70
    end   
end

function GAME:onCollide(dt,shapea,shapeb)
    local other
    if shapea == self.gObjBall.Collider then
        other = shapeb
    elseif shapeb == self.gObjBall.Collider then
        other = shapea
    else
        return
    end
    

    if other == self.gObjPaddle.Collider then
        self.gObjBall:goUp()
        local paddleCenterX, paddleCenterY = self.gObjPaddle.Collider:center()
        local ballCenterx , ballCentery = self.gObjBall.Collider:center() 
        if paddleCenterX >= ballCenterx then
            self.gObjBall:goLeft()
        else
            self.gObjBall:goRight()
        end 
        return
    elseif other == self.borderRight then
        self.gObjBall:goLeft()
        return
    elseif other == self.borderTop then
        self.gObjBall:goDown()
        return
    elseif other == self.borderLeft then
        self.gObjBall:goRight()
        return
    elseif other == self.borderBottom then
        self.txtLives = self.txtLives - 1
        self.gObjBall.ball_speed_x = 150
        self.gObjBall.ball_speed_y = 150
        self.gObjBall.Collider:moveTo(self.gObjBall.XStart,self.gObjBall.YStart)
        return
   end
   
    for a, brick in ipairs (self.gObjBrick) do
        if brick.Collider == other then
            self.txtScore = self.txtScore + 10
            local ballCenterx , ballCentery = self.gObjBall.Collider:center() 
            NormX = ballCenterx - brick.xPos
            NormY = ballCentery - brick.yPos
            tempAngle = 0
            if(ballCentery <= brick.yPos + brick.height/2) then
                if(ballCenterx > brick.xPos + brick.width/2) then
                    tempAngle = -112.5
                else
                    tempAngle = -157.5
                end
            elseif(ballCentery >= brick.yPos + brick.height/2) then
                if(ballCenterx > brick.xPos + brick.width/2) then
                    tempAngle = 112.5
                else
                    tempAngle = 157.5
                end
            end
            if(ballCenterx < brick.xPos) then
            tempAngle = 180
            end
            ballToBrick = self:Normalize2({NormX,NormY})
            angle = math.deg(math.acos(self:Dot(ballToBrick,{0,1})))+tempAngle
            brick:Destroy()
            table.remove(self.gObjBrick,a)
            collectgarbage("collect")
            
            if angle <= 45 or angle >= 315 then
                self.gObjBall:goUp()
            elseif angle <= 135 and angle >= 45 then
                self.gObjBall:goRight()
            elseif angle <= 225 and angle >= 135 then
                self.gObjBall:goDown()
            elseif angle <= 315 and angle >= 225 then
                self.gObjBall:goLeft()
            end
            return
        end
    end
end

function GAME:generateLevel()
    local a = {}
    local bColor = 1
    for j = 0, 8 do
        for i=0, 14 do
            table.insert(a,BRICK:new(world,62.5+i*45,100+j*15,bColor))
            collectgarbage("collect")
        end
        if bColor >= 5 then
            bColor = 1
        end 
        bColor = bColor + 1
    end
    return a
end

function GAME:restart()
    for a, brick in ipairs (self.gObjBrick) do
       brick:Destroy()
    end
    self.gObjBrick = nil
       collectgarbage("collect")
    self.txtLives = 5
    self.txtScore = 0
    self.gObjBrick  = self:generateLevel()
end

function GAME:nextLevel()
    self.gObjBrick  = self:generateLevel()
    self.txtLives = self.txtLives + 1
end

function GAME:Normalize2(vector)
    length = math.sqrt(vector[1]*vector[1]+vector[2]*vector[2])
    solution = {vector[1]/length,vector[2]/length}
    return solution
end

function GAME:Dot(vectorA, vectorB)
    return vectorA[1]*vectorB[1] + vectorA[2] * vectorB[2]
end