local y = 0
local x = 0
local z = 0

local facing = 0

local directions = {
    XPlus = 0,
    ZPlus = 1,
    XMinus = 2,
    ZMinus = 3
}

function dUp()
    turtle.digUp()
    turtle.up()
end

function dDown()
    turtle.digDown()
    turtle.down()
end

function dForward()
    turtle.dig()
    turtle.forward()
end

function turnRight()
    turtle.turnRight()
    facing = (facing + 1) % 4
end

function turnLeft()
    turtle.turnLeft()
    facing = (facing - 1) % 4
end

function face(direction)
    local turn = facing - direction
    if turn == 1 then
        turnLeft()
    end
    if turn == -1 then
        turnRight()
    end
    if math.abs(turn) == 2 then
        turnRight()
        turnRight()
    end
    if turn == 3 then
        turnRight()
    end
    if turn == -3 then
        turnLeft()
    end
end

function getFacing()
    return facing
end

function dXPlus(steps)
    face(directions.XPlus)
    steps = steps or 1
    for i = 1, steps, 1 do
        dForward()
        x = x + 1
    end
end

function dXMinus(steps)
    face(directions.XMinus)
    steps = steps or 1
    for i = 1, steps, 1 do
        dForward()
        x = x - 1
    end
end

function dZPlus(steps)
    face(directions.ZPlus)
    steps = steps or 1
    for i = 1, steps, 1 do
        dForward()
        z = z + 1
    end
end

function dZMinus(steps)
    face(directions.ZMinus)
    steps = steps or 1
    for i = 1, steps, 1 do
        dForward()
        z = z - 1
    end
end

function dYPlus(steps)
    steps = steps or 1
    for i = 1, steps, 1 do
        dUp()
        y = y + 1
    end
end

function dYMinus(steps)
    steps = steps or 1
    for i = 1, steps, 1 do
        dDown()
        y = y - 1
    end
end

function inspectYPlus()
    return turtle.inspectUp()
end

function inspectYMinus()
    return turtle.inspectDown()
end

function inspectXPlus()
    face(directions.XPlus)
    return turtle.inspect()
end

function inspectXMinus()
    face(directions.XMinus)
    return turtle.inspect()
end

function inspectZPlus()
    face(directions.ZPlus)
    return turtle.inspect()
end

function inspectZMinus()
    face(directions.ZMinus)
    return turtle.inspect()
end

function currentBlock()
    return { x = x, y = y, z = z }
end

-- tree code starts here

local n = tonumber(arg[1])
local m = tonumber(arg[2])

local f = 5

local alternate = true

dXPlus(f)

for i = 1, n, 1 do
    for i = 1, m, 1 do
        turtle.placeDown(1, 1)
        if i ~= m then
            if alternate then
                dXPlus(f)
            else
                dXMinus(f)
            end
        end
    end
    alternate = not alternate
    dZPlus(f)
end

dXMinus(currentBlock().x)
dZMinus(currentBlock().z)
face(directions.XPlus)
