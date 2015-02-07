HC = require "HardonCollider"
require 'middleclass'
require 'gL2DBROStateGame'
require 'gL2DBROObjPaddle'
require 'gL2DBROObjBrick'
require 'gL2DBROObjBall'

function on_collide(dt, shape_a, shape_b)
    MCGame:onCollide(dt,shape_a,shape_b)
end

function love.load()
    Collider = HC(100, on_collide)
    GameStart = false;
end

function love.update(dt)
    Collider:update(dt)
    if GameStart then
        world:update(dt)
        MCGame:gUpdate(dt)
    end
end

function love.draw()
    if GameStart then
        MCGame:gDraw()
    else
        love.graphics.setColor(255,255,255)
        love.graphics.print("Breakout",350,250)
        love.graphics.print("Press Return/Enter To Enter",350,300)
        love.graphics.print("or ESC to quit",350,330)
    end
end

function love.keypressed(key)
    if love.keyboard.isDown("escape") then
        Collider:clear()
        love.event.quit()
    end
    if not GameStart and love.keyboard.isDown("return") then
       world = love.physics.newWorld(0,0)
       MCGame = GAME:new()
       GameStart = true
    end 
end