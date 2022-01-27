Bomb = Class{}

function Bomb:init(x, y)
    self.x = x
    self.y = y
    
end

function Bomb:draw()
    if bombTimer > 1 then
        love.graphics.draw(sprites.bomb, bomb.x, bomb.y, nil, 0.5, nil, 
                sprites.bomb:getWidth() / 2 - 10, sprites.bomb:getHeight() / 2)
        love.graphics.circle('line', bomb.x, bomb.y, 100)
    else
        love.graphics.draw(sprites.explosion, bomb.x, bomb.y, nil, nil, nil, 
            sprites.explosion:getWidth() / 2, sprites.explosion:getHeight() / 2)
    end
end

function Bomb:timer(dt)
    bombTimer = bombTimer - dt
    if bombTimer <= 1 then
        for i,z in pairs(zombies) do
            if distanceBetween(z.x, z.y, bomb.x, bomb.y) < 100 then
                z.dead = true
                score = score + 1
                table.remove(bombs, 1)
            end
        end
        
        if bombTimer <= 0 then
            player.usedAbility2 = false
            bombTimer = 4
        end
    end
end