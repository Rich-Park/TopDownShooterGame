Zombie = Class{}

function Zombie:init()
    self.x = 0
    self.y = 0
    self.speed = 130
    self.dead = false
end

function Zombie:create()
    local side = math.random(1, 4)
    -- spawn on left side of screen
    if side == 1 then
        self.x = -30
        self.y = math.random(0, screenheight)
    -- spawn on right side of screen
    elseif side == 2 then
        self.x = screenwidth + 30
        self.y = math.random(0, screenheight)
    -- spawn on top of screen
    elseif side == 3 then
        self.x = math.random(0, screenwidth)
        self.y = -30
    -- spawn on bottom of screen
    else
        self.x = math.random(0, screenwidth)
        self.y = screenheight + 30
    end
end

function Zombie:update(dt)
    -- move each zombie towards the player
    
    self.x = self.x + (math.cos(zombiePlayerAngle(self)) * self.speed * dt)
    self.y = self.y + (math.sin(zombiePlayerAngle(self)) * self.speed * dt)
    
    -- if the zombie and player collide
    if distanceBetween(self.x, self.y, player.x, player.y) < 30 then
        -- if not injured, become injured
        if not player.injured then
            player.injured = true
            self.dead = true
            
        -- if injured, remove all zombies
        else
            for i,z in pairs(zombies) do
                zombies[i] = nil
                player.x = love.graphics.getWidth() / 2
                player.y = love.graphics.getHeight() / 2
                player.speed = 180
                player.injured = false
                gameState = 3
            end
        end
    end 

end