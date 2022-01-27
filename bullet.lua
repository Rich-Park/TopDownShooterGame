Bullet = Class{}

function Bullet:init(x, y)
    self.x = x
    self.y = y
    self.speed = 400
    self.direction = playerMouseAngle()
    self.dead = false
end

function Bullet:update(dt)
    self.x = self.x + (math.cos(self.direction) * self.speed * dt)
    self.y = self.y + (math.sin(self.direction) * self.speed * dt)
end