function distanceBetween(x1, y1, x2, y2)
    return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
end

function printMainMenu()
    love.graphics.setFont(bigFont)
    love.graphics.printf('Rules', 0, 10, screenwidth, 'center')

    -- love.graphics.setColor(0, 0, 1)
    love.graphics.setFont(medFont)
    love.graphics.printf('Movement and Shooting', 0, 70, screenwidth, 'center')

    love.graphics.setFont(smallFont)
    love.graphics.printf('1. Use mouse to aim and click to shoot', 0, 120, screenwidth, 'center')
    love.graphics.printf('2. "a" to move left, "d" to move right', 0, 150, screenwidth, 'center')
    love.graphics.printf('3. "w" to move up, "s" to move down', 0, 180, screenwidth, 'center')

    -- love.graphics.setColor(1, 0, 1)
    love.graphics.setFont(medFont)
    love.graphics.printf('Abilities', 0, 220, screenwidth, 'center')

    love.graphics.setFont(smallFont)
    love.graphics.printf('4. Press "space" to freeze all enemies onscreen for 3 seconds!', 0, 270, 
        screenwidth, 'center')
    love.graphics.printf('5. Press "f" to drop a bomb at your position that explodes after a few seconds', 
        0, 300, screenwidth, 'center')
    love.graphics.printf('6. Right-click or press "r" to unleash a whirlwind of bullets that obliterates all enemies', 
        0, 330, screenwidth, 'center')

    -- love.graphics.setColor(1, 0, 0)
    love.graphics.setFont(medFont)
    love.graphics.printf('Injured', 0, 370, screenwidth, 'center')

    love.graphics.setFont(smallFont)
    love.graphics.printf('7. First time you get hit, you will become injured', 0, 420, screenwidth, 'center')
    love.graphics.printf('8. While injured, you will become red and have a faster movement speed', 
        0, 450, screenwidth, 'center')

    love.graphics.setFont(bigFont)
    love.graphics.printf('Click anywhere to begin!', 0, screenheight - 110, screenwidth, 'center')

    love.graphics.draw(sprites.ability1, screenwidth - 117, 10, nil, 0.5, 0.5)
    love.graphics.draw(sprites.ability2, screenwidth - 80, 10, nil, 0.5, 0.5)
    love.graphics.draw(sprites.ability3, screenwidth - 43, 10, nil, 0.5, 0.5)
end

function printEndScreen()
    love.graphics.setFont(bigFont)
    love.graphics.printf('Game Over', 0, 170, screenwidth, 'center')

    love.graphics.setFont(medFont)
    love.graphics.printf('The zombies successfully ate you', 0, 230, screenwidth, 'center')

    love.graphics.printf('Press "p" to play again', 0, 290, screenwidth, 'center')
    love.graphics.printf('Or press "m" to go back to main menu!', 0, 330, screenwidth, 'center')
end