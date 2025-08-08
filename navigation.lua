local destructive_mode = false
local oriented = false
local position = vector.new(0, 0, 0)
local facing = 0
local direction_map = {
    pos_x = 0,
    pos_z = 1,
    neg_x = 2,
    neg_z = 3,
    east = 0,
    south = 1,
    west = 2,
    north = 3,
    [0] = 'pos_x',
    [1] = 'pos_z',
    [2] = 'neg_x',
    [3] = 'neg_z',
    [0] = 'east',
    [1] = 'south',
    [2] = 'west',
    [3] = 'north'
}

function get_distance(from, to)
    delta = from - to
    return math.abs(delta.x) + math.abs(delta.y) + math.abs(delta.z)
end

function set_destructive_mode(mode)
    destructive_mode = mode
end

function set_orientation(current_facing)
    if direction_map[current_facing] == nil then
        return false
    end
    facing = direction_map[current_facing]
    oriented = true
    return true
end

function go_forward(n)
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

function go_up(n)
    for i = 1, n do
        if destructive_mode then turtle.digUp() end
        if turtle.up() then position.z = position.z + 1
        else return false
        end
    end
    return true
end

function go_down(n)
    for i = 1, n do
        if destructive_mode then turtle.digDown() end
        if turtle.down() then position.z = position.z - 1
        else return false
        end
    end
    return true
end

function turn_left(n)
    for i = 1, n do
        turtle.turnLeft()
        facing = (facing - 1) % 4
    end
end

function turn_right(n)
    for i = 1, n do
        turtle.turnRight()
        facing = (facing + 1) % 4
    end
end

function turn_to(direction)
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

function go_to(destination)
    delta = destination - position

    if delta.x > 0 then
        if not turn_to('pos_x') then return false end
        if not go_forward(delta.x) then return false end
    end

    if delta.x < 0 then
        if not turn_to('neg_x') then return false end
        if not go_forward(-delta.x) then return false end
    end

    if delta.z > 0 then
        if not turn_to('pos_z') then return false end
        if not go_forward(delta.z) then return false end
    end

    if delta.z < 0 then
        if not turn_to('neg_z') then return false end
        if not go_forward(-delta.z) then return false end
    end

    if delta.y > 0 then
        if not go_up(delta.y) then return false end
    end

    if delta.y < 0 then
        if not go_down(-delta.y) then return false end
    end

    return true
end