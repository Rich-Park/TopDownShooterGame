Class = require 'class'

require 'dependencies'

require 'player'
require 'zombie'
require 'bullet'
require 'bomb'
require 'ammo'

screenwidth = love.graphics.getWidth()
screenheight = love.graphics.getHeight()

function love.load()

    love.window.setTitle('TopDownShooter')

    math.randomseed(os.time())

    sprites = {} 
    sprites.background = love.graphics.newImage('sprites/background.png')
    
    sprites.bullet = love.graphics.newImage('sprites/bullet.png')
    sprites.player = love.graphics.newImage('sprites/player.png')
    sprites.zombie = love.graphics.newImage('sprites/zombie.png')
    sprites.bomb = love.graphics.newImage('sprites/bomb.png')
    sprites.explosion = love.graphics.newImage('sprites/explosion.png')
    sprites.medkit = love.graphics.newImage('sprites/medkit.png')
    sprites.ammo = love.graphics.newImage('sprites/ammo.png')

    sprites.ability1 = love.graphics.newImage('sprites/ability1.png')
    sprites.ability2 = love.graphics.newImage('sprites/ability2.png')
    sprites.ability3 = love.graphics.newImage('sprites/ability3.png')

    sounds = {
        ['bullet'] = love.audio.newSource('bullet1.wav', 'static'),
    }
    -- instanstiate player object
    player = Player(screenwidth / 2, screenheight / 2)

    -- table with zombie objects
    zombies = {}
    -- table with bullet objects
    bullets = {}
    -- table with bomb object
    bombs = {}

    gameState = 1
    -- maxTime = 10
    -- timer = maxTime
    score = 0

    -- zombiesKilled = 0

    bulletCount = 20
    bulletDelay = 0.2
    bulletTimer = 0
    bulletAvailable = true

    bombTimer = 4
    ability1timer = 3

    showAmmo = true
    ammo = {}

    -- medkitInUse = false
    -- medkitCount = 0

    bigFont = love.graphics.newFont(40)
    medFont = love.graphics.newFont(30)
    smallFont = love.graphics.newFont(18)
end

function love.update(dt)
    screenwidth = love.graphics.getWidth()
    screenheight = love.graphics.getHeight()
    -- player movement
    if gameState == 2 then
        player:update(dt)

        -- Collision between zombie and player

        -- move each zombie towards the player
        for i,z in pairs(zombies) do
            z:update(dt)
            
        end

        -- if player.injured then
        --     if not medkitInUse then
        --         medkitX = math.random(0 + 200, screenwidth - 200)
        --         medkitY = math.random(0 + 200, screenheight - 200)
        --         medkitInUse = true
        --     end
        --     if distanceBetween(medkitX, medkitY, player.x, player.y) < 30 then
        --         player.injured = false
        --         medkitInUse = false
        --     end
        -- end
            
        -- if player.injured then
        --     if medkitCount == 0 then
        --         medkitX = math.random(0, screenwidth)
        --         medkitY = math.random(0, screenheight)
        --         medkitCount = medkitCount + 1
        --     end
        --     if distanceBetween(medkitX, medkitY, player.x, player.y) < 50 then
        --         player.injured = false
        --         medkitCount = 0
        --     end
        -- end

        if not bulletAvailable then
            -- increases bulletTimer every frame
            bulletTimer = bulletTimer + dt
            -- if bulletTimer is greater than bulletDelay then you can shoot
            if bulletTimer > bulletDelay then
                bulletAvailable = true
                bulletTimer = 0
            end
        end


        -- move bullets in direction of the mouse when clicked
        for i,b in pairs(bullets) do
            b:update(dt)
        end
        
        
        
        if showAmmo then
            if #ammo == 0 then
                a = Ammo()
                table.insert(ammo, a)
            else           
                for i,a in pairs(ammo) do
                    if distanceBetween(a.x, a.y, player.x, player.y) < 40 then
                        bulletCount = 20
                        -- showAmmo = false
                        table.remove(ammo, 1)
                    end
                end
            end
        end
        
        


        -- spawn zombies
        
        -- countdown timer
        timer = timer - dt
        -- when timer hits 0, spawn a zombie, then decrease time in between spawns slightly, and 
        -- reset timer
        if timer <= 0 then
            spawnZombie()
            maxTime = 0.95 * maxTime
            if maxTime <= 0.75 then
                maxTime = 1
            end
            timer = maxTime
        end

        -- check if player has each abilities
        player:checkAbility()

        -- ability 1; freezes enemies for 3 seconds
        if player.usedAbility1 then
            -- ability 1 timer
            player:ability1(dt)
        end

        -- ability 2; drops a bomb that explodes after 3 seconds
        if player.usedAbility2 then
            -- ability 2 timer
            bomb:timer(dt)      
        end
        
        --[[ going through the loop backwards so that we don't cause problems when getting rid of elements
            in a table while going through a loop
            for i in however many elements are in the table, end at 1, i decrease by 1]]
        for i = #bullets, 1, -1 do
            local b = bullets[i]
            -- if bullet goes offscreen, remove it
            if b.x < 0 or b.y < 0 or b.x > screenwidth or b.y > screenheight then
                table.remove(bullets, i)
            end
        end
    
        -- Collision between zombie and bullet

        -- check if every zombie hits every bullet
        for i,z in pairs(zombies) do
            for j,b in pairs(bullets) do
                if distanceBetween(z.x, z.y, b.x, b.y) < 20 then
                    z.dead = true
                    b.dead = true
                end
            end
        end

        --again, going through backwards to not mess up table
            
        -- remove any zombies that are dead
        for i = #zombies, 1, -1 do
            local z = zombies[i]
            if z.dead then
                score = score + 1 -- fix when player hits zombie score goes up
                table.remove(zombies, i)
            end
        end

        -- remove any bullets that are dead
        for i = #bullets, 1, -1 do
            local b = bullets[i]
            if b.dead then
                table.remove(bullets, i)
            end
        end
    end
end

function love.draw()

    love.graphics.draw(sprites.background, 0, 0)
    
    if gameState == 1 then
        printMainMenu()

    elseif gameState == 2 then
        -- draw ability icons and their counts
        player:drawAbilityIcons()
        
        love.graphics.setFont(medFont)
        love.graphics.printf('Score: ' .. score, 0, 0, screenwidth, 'left')
        
        -- if player.injured then
        --     love.graphics.draw(sprites.medkit, medkitX, medkitY, nil, 0.2)
        -- end
        
    
        -- draw the player
        player:draw()

        -- draw each zombie object, facing the player object
        for i, z in pairs(zombies) do
            love.graphics.draw(sprites.zombie, z.x, z.y, zombiePlayerAngle(z), nil, nil, sprites.zombie:getWidth()/2, sprites.zombie:getHeight()/2)
        end

        -- draw each bullet object
        for i, b in pairs(bullets) do
            love.graphics.draw(sprites.bullet, b.x, b.y, nil, 0.5, 0.5, sprites.bullet:getWidth()/2, sprites.bullet:getHeight()/2)
        end

        love.graphics.printf(bulletCount .. '/20', screenwidth - 95, screenheight - 40, screenwidth)


        -- if player used ability 2, draw bomb
        if player.usedAbility2 then
            bomb:draw()
        end
        
        if showAmmo then
            a:draw()
        end
        
    else
        printEndScreen()
    end

end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end

    if gameState == 2 then
        -- use ability 1 only if ability 1 is not in use
        if not player.usedAbility1 and key == 'space' and player.hasAbility1 then
            if player.ability1Count < 3 then
                player.ability1Count = player.ability1Count + 1
                player.usedAbility1 = true
                -- player:ability1()
            end
        -- use ability 2
        elseif not player.usedAbility2 and key == 'f' and player.hasAbility2 then
            if player.ability2Count < 3 then
                player.ability2Count = player.ability2Count + 1
                player.usedAbility2 = true
                bomb = Bomb(player.x, player.y) 
                table.insert(bombs, bomb)
            end
        end
    -- endscreen

    elseif gameState == 3 then
        -- play again
        if key == 'p' then
            gameState = 2
            maxTime = 3
            timer = maxTime
            score = 0
            bulletCount = 20
            -- medkitCount = 0
            -- medkitInUse = false
            player.ability1Count = 0
            player.hasAbility1 = false
            player.usedAbility1 = false
            player.ability2Count = 0
            player.hasAbility2 = false
            player.usedAbility2 = false
            player.ability3Count = 0
            player.hasAbility3 = false
        -- go back to main menu
        elseif key == 'm' then
            gameState = 1
        end
    end
end

function love.mousepressed(x, y, button)
    if button == 1 and gameState == 1 then
        gameState = 2
        maxTime = 3
        timer = maxTime
        score = 0
        -- medkitCount = 0
        player.ability1Count = 0
        player.hasAbility1 = false
        player.ability2Count = 0
        player.hasAbility2 = false
        player.ability3Count = 0
        player.hasAbility3 = false
    end

    if gameState == 2 then
        if button == 1 and bulletCount > 0 and bulletAvailable then
            spawnBullet()
            sounds['bullet']:play()
            bulletCount = bulletCount - 1
            bulletAvailable = false
        elseif button == 2 and player.hasAbility3 then
            player.ability3Count = player.ability3Count + 1
            if player.ability3Count <= 3 then
                player:ability3(bullet)
            end
        end
    end
end

function playerMouseAngle()
    -- get the radian angle between the player and the mouse
    return math.atan2(player.y - love.mouse.getY(), player.x - love.mouse.getX()) + math.pi
end

function zombiePlayerAngle(enemy)
    -- get the radian angle between the enemy and the player
    return math.atan2(player.y - enemy.y, player.x - enemy.x)
end

function spawnZombie()
    -- instanstiate zombie objects with random positions and add to the zombies table
    local zombie = Zombie()
    zombie:create()
    table.insert(zombies, zombie)
end

function spawnBullet()
    -- instanstiate bullet objects at player object's position and add to the bullets table
    local bullet = Bullet(player.x, player.y)
    table.insert(bullets, bullet)
end

function setAmmo()
    ammoX = math.random(50, screenwidth - 50)
    ammoY = math.random(50, screenheight - 50)
    table.insert(ammo, {ammoX, ammoY})
end