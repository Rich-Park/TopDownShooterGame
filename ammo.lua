Ammo = Class{}

function Ammo:init()
    self.x = math.random(100, screenwidth - 100)
    self.y = math.random(100, screenheight - 100)
end

function Ammo:draw()
    love.graphics.draw(sprites.ammo, a.x, a.y, nil, 0.5)
end