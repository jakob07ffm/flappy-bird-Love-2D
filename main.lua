
local push = require 'push'


WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288


local BIRD_WIDTH = 38
local BIRD_HEIGHT = 24


local PIPE_WIDTH = 70
local PIPE_HEIGHT = 288
local PIPE_SPEED = 60


local PIPE_GAP = 90


local background = love.graphics.newImage('background.png')
local bird = love.graphics.newImage('bird.png')
local pipe = love.graphics.newImage('pipe.png')

local birdX = VIRTUAL_WIDTH / 2 - BIRD_WIDTH / 2
local birdY = VIRTUAL_HEIGHT / 2 - BIRD_HEIGHT / 2
local birdDY = 0


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
end

function love.keypressed(key)
    if key == 'space' then
        birdDY = -5
    end
end

function love.update(dt)
    birdDY = birdDY + 20 * dt
    birdY = birdY + birdDY

    spawnTimer = spawnTimer + dt
    if spawnTimer > 2 then
        table.insert(pipes, { x = VIRTUAL_WIDTH, y = math.random(PIPE_GAP, VIRTUAL_HEIGHT - PIPE_GAP) })
        spawnTimer = 0
    end

    for i = #pipes, 1, -1 do
        pipes[i].x = pipes[i].x - PIPE_SPEED * dt

        if pipes[i].x + PIPE_WIDTH < 0 then
            table.remove(pipes, i)
        end
    end
end

function love.draw()
    push:start()

    love.graphics.draw(background, 0, 0)

    love.graphics.draw(bird, birdX, birdY)

    for _, pipe in pairs(pipes) do
        love.graphics.draw(pipe, pipe.x, pipe.y)
        love.graphics.draw(pipe, pipe.x, pipe.y - PIPE_HEIGHT - PIPE_GAP)
    end

    push:finish()
end
