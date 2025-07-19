_directions = {
    pos_y = 0,
    pos_x = 1,
    neg_y = 2,
    neg_x = 3
}

_position = vector.new(0, 0, 0)
_orientation = _directions.pos_y

function set_orientation(orientation)
    value = _directions[orientation]
    if value == nil then
        return false
    end

    num_turns = (value - _orientation) % 4
    if num_turns == 3 then
        turtle.turnLeft()
    else
        for i = 1, num_turns do
            turtle.turnRight()
        end
    end

    _orientation = value
    return true
end