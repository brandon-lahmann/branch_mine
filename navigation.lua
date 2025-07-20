_directions = {
    pos_y = 0,
    pos_x = 1,
    neg_y = 2,
    neg_x = 3
}

_position = vector.new(0, 0, 0)
_facing = _directions.pos_y
_destructive_mode = false

function _go_forward(n)
    local deltas = {
        [0] = {x = 0, y = 1},
        [1] = {x = 1, y = 0},
        [2] = {x = 0, y = -1},
        [3] = {x = -1, y = 0}
    }
    for i = 1, n do
        if _destructive_mode then turtle.dig() end
        if turtle.forward() then
            _position.x = _position.x + deltas[_facing].x
            _position.y = _position.y + deltas[_facing].y
        else
            return false
        end
    end
    return true
end

function _go_up(n)
    for i = 1, n do
        if _destructive_mode then turtle.digUp() end
        if turtle.up() then _position.z = _position.z + 1
        else return false
        end
    end
    return true
end

function _go_down(n)
    for i = 1, n do
        if _destructive_mode then turtle.digDown() end
        if turtle.down() then _position.z = _position.z - 1
        else return false
        end
    end
    return true
end

function set_orientation(orientation)
    local value = _directions[orientation]
    if value == nil then
        return false
    end

    local num_turns = (value - _facing) % 4
    if num_turns == 3 then
        turtle.turnLeft()
    else
        for i = 1, num_turns do
            turtle.turnRight()
        end
    end

    _facing = value
    return true
end

function set_destructive(destructive)
    _destructive_mode = destructive
end

function go_to(destination)
    delta = destination - _position

    if delta.x > 0 then
        if not set_orientation('pos_x') then return false end
        if not _go_forward(delta.x) then return false end
    end

    if delta.x < 0 then
        if not set_orientation('neg_x') then return false end
        if not _go_forward(-delta.x) then return false end
    end

    if delta.y > 0 then
        if not set_orientation('pos_y') then return false end
        if not _go_forward(delta.y) then return false end
    end

    if delta.y < 0 then
        if not set_orientation('neg_y') then return false end
        if not _go_forward(-delta.y) then return false end
    end

    if delta.z > 0 then
        if not _go_up(delta.z) then return false end
    end

    if delta.z < 0 then
        if not _go_down(-delta.z) then return false end
    end

    return true
end