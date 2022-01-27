Player = Class{}

function Player:init(x, y)
    self.x = x
    self.y = y
    self.speed = 180
    self.injured = false

    self.hasAbility1 = false
    self.usedAbility1 = false
    self.ability1Count = 0

    self.hasAbility2 = false
    self.usedAbility2 = false
    self.ability2Count = 0
    
    self.hasAbility3 = false
    self.ability3Count = 0
end

function Player:update(dt)
    if player.injured then
        player.speed = 130
    else
        player.speed = 180
    end

    if love.keyboard.isDown('d') and player.x < screenwidth then
        player.x = player.x + player.speed * dt
    end

    if love.keyboard.isDown('a') and player.x > 0 then
        player.x = player.x - player.speed * dt
    end
    
    if love.keyboard.isDown('w') and player.y > 0 then
        player.y = player.y - player.speed * dt
    end
    
    if love.keyboard.isDown('s') and player.y < screenheight then
        player.y = player.y + player.speed * dt
    end
end

function Player:checkAbility()
    if score >= 5 then
        player.hasAbility1 = true
    end
    if score >= 15 then
        player.hasAbility2 = true
    end
    if score >= 25 then
        player.hasAbility3 = true
    end
end

function Player:draw()
    -- if injured, set color to red
    if player.injured then
        love.graphics.setColor(1, 0, 0)
    end

    -- draw the player object, facing the mouse
    love.graphics.draw(sprites.player, player.x, player.y, playerMouseAngle(), nil, nil, 
        sprites.player:getWidth() / 2, sprites.player:getHeight() / 2)

    love.graphics.setColor(1, 1, 1)
end

function Player:drawAbilityIcons()
    -- Ability 1
    if not player.hasAbility1 then
        love.graphics.setColor(80/255, 80/255, 80/255)
    end

    love.graphics.draw(sprites.ability1, screenwidth - 117, 10, nil, 0.5, 0.5)

    if player.ability1Count == 0 then
        love.graphics.print(3, screenwidth - 111, 40)
    elseif player.ability1Count == 1 then
        love.graphics.print(2, screenwidth - 111, 40)
    elseif player.ability1Count == 2 then
        love.graphics.print(1, screenwidth - 111, 40)
    else
        love.graphics.print(0, screenwidth - 111, 40)
    end

    love.graphics.setColor(1, 1, 1)
    
    -- Ability 2
    if not player.hasAbility2 then
        love.graphics.setColor(80/255, 80/255, 80/255)
    end
    
    love.graphics.draw(sprites.ability2, screenwidth - 80, 10, nil, 0.5, 0.5)
    
    if player.ability2Count == 0 then
        love.graphics.print(3, screenwidth - 74, 40)
    elseif player.ability2Count == 1 then
        love.graphics.print(2, screenwidth - 74, 40)
    elseif player.ability2Count == 2 then
        love.graphics.print(1, screenwidth - 74, 40)
    else
        love.graphics.print(0, screenwidth - 74, 40)
    end

    love.graphics.setColor(1, 1, 1)

    -- Ability 3
    if not player.hasAbility3 then
        love.graphics.setColor(80/255, 80/255, 80/255)
    end

    love.graphics.draw(sprites.ability3, screenwidth - 43, 10, nil, 0.5, 0.5)
    
    if player.ability3Count == 0 then
        love.graphics.print(3, screenwidth - 37, 40)
    elseif player.ability3Count == 1 then
        love.graphics.print(2, screenwidth - 37, 40)
    elseif player.ability3Count == 2 then
        love.graphics.print(1, screenwidth - 37, 40)
    else
        love.graphics.print(0, screenwidth - 37, 40)
    end
    
    love.graphics.setColor(1, 1, 1)

end

function Player:ability1(dt)
    for i,z in pairs(zombies) do
        z.speed = 0
    end
    ability1timer = ability1timer - dt
    if ability1timer <= 0 then
        player.usedAbility1 = false
        ability1timer = 3
        for i,z in pairs(zombies) do
            z.speed = 100
        end
    end
end

function Player:ability1Timer(dt)
    
end

function Player:ability3(bullet)
    local bullet = Bullet(player.x, player.y)
    prevBulletdirection = bullet.direction
    table.insert(bullets, bullet)
    for i = 1, 59 do
        local bullet = Bullet(player.x, player.y)
        bullet.direction = prevBulletdirection + math.pi / 30
        table.insert(bullets, bullet)
        prevBulletdirection = bullet.direction
    end
end