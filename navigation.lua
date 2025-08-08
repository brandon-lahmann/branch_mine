-- navigation.lua

local navigation = {}
navigation.destructive_mode = false

local position = vector.new(0, 0, 0)
local facing = 0
local direction_map = {
    pos_y = 0,
    pos_x = 1,
    neg_y = 2,
    neg_x = 3,
    [0] = 'pos_y',
    [1] = 'pos_x',
    [2] = 'neg_y',
    [3] = 'neg_x'
}

function get_distance(from, to)
    delta = from - to
    return math.abs(delta.x) + math.abs(delta.y) + math.abs(delta.z)
end

function navigation.go_forward(n)
    local deltas = {
        [0] = {x = 0, y = 1},
        [1] = {x = 1, y = 0},
        [2] = {x = 0, y = -1},
        [3] = {x = -1, y = 0}
    }
    for i = 1, n do
        if destructive_mode then turtle.dig() end
        if turtle.forward() then
            position.x = position.x + deltas[facing].x
            position.y = position.y + deltas[facing].y
        else
            return false
        end
    end
    return true
end

function navigation.go_up(n)
    for i = 1, n do
        if destructive_mode then turtle.digUp() end
        if turtle.up() then position.z = position.z + 1
        else return false
        end
    end
    return true
end

function navigation.go_down(n)
    for i = 1, n do
        if destructive_mode then turtle.digDown() end
        if turtle.down() then position.z = position.z - 1
        else return false
        end
    end
    return true
end

function navigation.turn_left(n)
    for i = 1, n do
        turtle.turnLeft()
        facing = (facing - 1) % 4
    end
end

function navigation.turn_right(n)
    for i = 1, n do
        turtle.turnRight()
        facing = (facing + 1) % 4
    end
end

function navigation.set_facing(direction)
    local value
    if type(direction) == "number" then
        value = direction
    elseif type(direction) == "string" then
        value = direction_map[direction]
        if value == nil then
            return false
        end
    else
        return false
    end

    local num_turns = (value - facing) % 4
    if num_turns == 3 then
        turn_left(1)
    else
        turn_right(num_turns)
    end

    return true
end

function navigation.go_to(destination)
    delta = destination - position

    if delta.x > 0 then
        if not set_facing('pos_x') then return false end
        if not go_forward(delta.x) then return false end
    end

    if delta.x < 0 then
        if not set_facing('neg_x') then return false end
        if not go_forward(-delta.x) then return false end
    end

    if delta.y > 0 then
        if not set_facing('pos_y') then return false end
        if not go_forward(delta.y) then return false end
    end

    if delta.y < 0 then
        if not set_facing('neg_y') then return false end
        if not go_forward(-delta.y) then return false end
    end

    if delta.z > 0 then
        if not go_up(delta.z) then return false end
    end

    if delta.z < 0 then
        if not go_down(-delta.z) then return false end
    end

    return true
end