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

function get_position()
    return vector.new(position.x, position.y, position.z)
end

function go_forward(n)
    local deltas = {
        [0] = {x = 1, z = 0},
        [1] = {x = 0, z = 1},
        [2] = {x = -1, z = 0},
        [3] = {x = 0, z = -1}
    }
    for i = 1, n do
        if destructive_mode then turtle.dig() end
        if turtle.forward() then
            position.x = position.x + deltas[facing].x
            position.z = position.z + deltas[facing].z
        else
            return false
        end
    end
    return true
end

function go_up(n)
    for i = 1, n do
        if destructive_mode then turtle.digUp() end
        if turtle.up() then position.y = position.y + 1
        else return false
        end
    end
    return true
end

function go_down(n)
    for i = 1, n do
        if destructive_mode then turtle.digDown() end
        if turtle.down() then position.y = position.y - 1
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

function go_to(destination, num_attempts)
    if num_attempts == nil then
        num_attempts = 1
    elseif num_attempts == 0 then
        return false
    end

    delta = destination - position

    if delta.x > 0 then
        if not turn_to('pos_x') then go_to(destination, num_attempts - 1) end
        if not go_forward(delta.x) then go_to(destination, num_attempts - 1) end
    end

    if delta.x < 0 then
        if not turn_to('neg_x') then go_to(destination, num_attempts - 1) end
        if not go_forward(-delta.x) then go_to(destination, num_attempts - 1) end
    end

    if delta.z > 0 then
        if not turn_to('pos_z') then go_to(destination, num_attempts - 1) end
        if not go_forward(delta.z) then go_to(destination, num_attempts - 1) end
    end

    if delta.z < 0 then
        if not turn_to('neg_z') then go_to(destination, num_attempts - 1) end
        if not go_forward(-delta.z) then go_to(destination, num_attempts - 1) end
    end

    if delta.y > 0 then
        if not go_up(delta.y) then go_to(destination, num_attempts - 1) end
    end

    if delta.y < 0 then
        if not go_down(-delta.y) then go_to(destination, num_attempts - 1) end
    end

    return true
end