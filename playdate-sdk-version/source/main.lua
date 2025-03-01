import "CoreLibs/graphics"
import "CoreLibs/sprites"

local pd = playdate
local gfx = pd.graphics

-- Player
local playerStartX = 40
local playerStartY = 120
local playerSpeed = 3
local playerImage = gfx.image.new("images/capybara")
local playerSprite = gfx.sprite.new(playerImage)
playerSprite:setCollideRect(0, 0, 64, 48)
playerSprite:moveTo(playerStartX, playerStartY)
playerSprite:add()

-- Obstacle
local obstacleSpeed = 3
local obstacleImage = gfx.image.new("images/rock")
local obstacleSprite = gfx.sprite.new(obstacleImage)
obstacleSprite.collisionResponse = gfx.sprite.kCollisionTypeOverlap
obstacleSprite:setCollideRect(0, 0, 48, 48)
obstacleSprite:moveTo(450, 240)
obstacleSprite:add() 

-- Game State
local gameState = "stopped"
local score = 0

function pd.update()
    gfx.sprite.update()

    if gameState == "stopped" then
        gfx.drawTextAligned("Press A to Start", 200, 40, kTextAlignment.center)
        if pd.buttonJustPressed(pd.kButtonA) then
            gameState = "active"
            score = 0
            obstacleSpeed = 3
            playerSprite:moveTo(playerStartX, playerStartY)
            obstacleSprite:moveTo(450, math.random(40, 200))
        end
    elseif gameState == "active" then
        local crankPosition = pd.getCrankPosition()
        if crankPosition <= 90 or crankPosition >= 270 then
            playerSprite:moveBy(0, -playerSpeed)
        else 
            playerSprite:moveBy(0, playerSpeed)
        end

        local actualX, actualY, collisions, length = obstacleSprite:moveWithCollisions(obstacleSprite.x - obstacleSpeed, obstacleSprite.y)
        if obstacleSprite.x < 0 then
            obstacleSprite:moveTo(450, math.random(40, 200))
            score += 1
            obstacleSpeed += 0.2
        end

        if length > 0 or playerSprite.y > 270 or playerSprite.y < -30 then
            gameState = "stopped"
        end
    end
    
    gfx.drawTextAligned("Score: " .. score, 390, 10, kTextAlignment.right)
end
