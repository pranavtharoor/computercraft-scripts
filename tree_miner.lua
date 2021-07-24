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

local f = 4

local inspected = {}

function blockToString(block)
    return block.x .. ", " .. block.y .. ", " .. block.z
end

function shouldMine(block)
    return block == "minecraft:oak_log" or block == "minecraft:oak_leaves"
end

function nextBlockPos(pos, direction)
    if direction == directions.XPlus then pos.x = pos.x + 1 end
    if direction == directions.XMinus then pos.x = pos.x - 1 end
    if direction == directions.ZPlus then pos.z = pos.z + 1 end
    if direction == directions.ZMinus then pos.z = pos.z - 1 end
    if direction == directions.YPlus then pos.y = pos.y + 1 end
    if direction == directions.YMinus then pos.y = pos.y - 1 end
    return pos
end

function manhattanDist(block1, block2)
    return math.abs(block1.x - block2.x) + math.abs(block1.y - block2.y) + math.abs(block1.z - block2.z)
end

function shouldInspect(direction, start)
    local pos = currentBlock()
    pos = nextBlockPos(pos, direction)
    if manhattanDist(pos, start) > 2 then return false end
    return inspected[blockToString(pos)] == nil
end

function markInspected(direction)
    inspected[blockToString(nextBlockPos(currentBlock(), direction))] = true
end

function clearNearbyBranches(trunk)
    if shouldInspect(directions.XPlus, trunk) then
        local success, data = inspectXPlus()
        markInspected(directions.XPlus)
        if success and shouldMine(data.name) then
            dXPlus()
            clearNearbyBranches(trunk)
            dXMinus()
        end
    end

    if shouldInspect(directions.ZPlus, trunk) then
        local success, data = inspectZPlus()
        markInspected(directions.ZPlus)
        if success and shouldMine(data.name) then
            dZPlus()
            clearNearbyBranches(trunk)
            dZMinus()
        end
    end

    if shouldInspect(directions.XMinus, trunk) then
        local success, data = inspectXMinus()
        markInspected(directions.XMinus)
        if success and shouldMine(data.name) then
            dXMinus()
            clearNearbyBranches(trunk)
            dXPlus()
        end
    end

    if shouldInspect(directions.ZMinus, trunk) then
        local success, data = inspectZMinus()
        markInspected(directions.ZMinus)
        if success and shouldMine(data.name) then
            dZMinus()
            clearNearbyBranches(trunk)
            dZPlus()
        end
    end
end

function mineTree()
    local success, data = inspectYPlus()
    if success and data.name == "minecraft:oak_log" then
        dYPlus()
        mineTree()
        dYMinus()
    end
    if currentBlock().y > 0 then clearNearbyBranches(currentBlock()) end
end

for i = 1, n, 1 do
    for i = 1, f, 1 do
        dXPlus()
        mineTree()
    end
end
