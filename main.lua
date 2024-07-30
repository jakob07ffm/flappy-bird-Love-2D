local push = require 'push'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720
VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

local BIRD_WIDTH = 38
local BIRD_HEIGHT = 24
local birdX = VIRTUAL_WIDTH / 2 - BIRD_WIDTH / 2
local birdY = VIRTUAL_HEIGHT / 2 - BIRD_HEIGHT / 2
local birdDY = 0


local PIPE_WIDTH = 70
local PIPE_HEIGHT = 288
local PIPE_SPEED = 60
local PIPE_GAP = 90


local pipes = {}
local spawnTimer = 0
local score = 0


function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle('Flappy Bird')

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })

    math.randomseed(os.time())

    smallFont = love.graphics.newFont(8)
    largeFont = love.graphics.newFont(16)
    love.graphics.setFont(smallFont)
end


function love.keypressed(key)
    if key == 'space' then
        birdDY = -5
    elseif key == 'r' then
        resetGame()
    end
end

function love.update(dt)
    birdDY = birdDY + 20 * dt
    birdY = birdY + birdDY

    if birdY + BIRD_HEIGHT > VIRTUAL_HEIGHT or birdY < 0 then
        resetGame()
    end

    spawnTimer = spawnTimer + dt
    if spawnTimer > 2 then
        local pipeY = math.random(PIPE_GAP, VIRTUAL_HEIGHT - PIPE_GAP)
        table.insert(pipes, { x = VIRTUAL_WIDTH, y = pipeY })
        spawnTimer = 0
    end

    for i = #pipes, 1, -1 do
        pipes[i].x = pipes[i].x - PIPE_SPEED * dt

        if pipes[i].x + PIPE_WIDTH < 0 then
            table.remove(pipes, i)
            score = score + 1
        end

        if pipes[i].x < birdX + BIRD_WIDTH and birdX < pipes[i].x + PIPE_WIDTH then
            if birdY < pipes[i].y - PIPE_GAP or birdY + BIRD_HEIGHT > pipes[i].y then
                resetGame()
            end
        end
    end
end

function love.draw()
    push:start()


    love.graphics.clear(0.5, 0.8, 1)  -- Sky blue background


    love.graphics.setColor(1, 1, 0)  -- Yellow bird
    love.graphics.rectangle('fill', birdX, birdY, BIRD_WIDTH, BIRD_HEIGHT)


    love.graphics.setColor(0.4, 0.8, 0.4)  -- Green pipes
    for _, pipe in pairs(pipes) do
        love.graphics.rectangle('fill', pipe.x, pipe.y, PIPE_WIDTH, VIRTUAL_HEIGHT - pipe.y)
        love.graphics.rectangle('fill', pipe.x, 0, PIPE_WIDTH, pipe.y - PIPE_GAP)
    end


    love.graphics.setFont(largeFont)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print('Score: ' .. tostring(score), 10, 10)


    if birdY + BIRD_HEIGHT > VIRTUAL_HEIGHT or birdY < 0 then
        love.graphics.setFont(largeFont)
        love.graphics.printf('Game Over! Press R to Restart', 0, VIRTUAL_HEIGHT / 2 - 14, VIRTUAL_WIDTH, 'center')
    end

    push:finish()
end


function resetGame()
    birdY = VIRTUAL_HEIGHT / 2 - BIRD_HEIGHT / 2
    birdDY = 0
    pipes = {}
    spawnTimer = 0
    score = 0
end
