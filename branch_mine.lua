os.loadAPI("navigation.lua")

black_list = {
    'tuff',
    'stone',
    'slate',
    'gravel',
    'sand',
    'dirt'
}

-- Todo: Dump items on black list
-- Todo: Return home if low on fuel
-- Todo: Return home if inventory is full
-- Todo: Auto refuel (unless full)
-- Todo: Command line arg to limit branch mine length

function in_back_list(value)
    for i = 1, #black_list do
        if string.find(string.lower(value), black_list[i]) then
            return true
        end
    end
    return false
end

function identify_valuable()
    local block, data = turtle.inspectUp()
    if block and not in_back_list(data.name) then
        print(data.name .. ' detected pos_z')
        return 'pos_z'
    end

    local block, data = turtle.inspectDown()
    if block and not in_back_list(data.name) then
        print(data.name .. ' detected neg_z')
        return 'neg_z'
    end

    for i = 1, 4 do
        local block, data = turtle.inspect()
        if block and not in_back_list(data.name) then
            print(data.name .. ' detected ' .. navigation.direction_map[navigation.facing])
            return navigation.direction_map[navigation.facing]
        end
        navigation.turn_right(1)
    end
end


backtrack_map = {}
while true do
    -- Check to see if there's any valuables around us
    local direction = identify_valuable()

    -- If there are, dig them and move forward
    if direction then
        table.insert(backtrack_map, direction)
        if direction == 'pos_z' then
            turtle.digUp()
            navigation.go_up(1)
        elseif direction == 'neg_z' then
            turtle.digDown()
            navigation.go_down(1)
        else
            navigation.set_facing(direction)
            turtle.dig()
            navigation.go_forward(1)
        end

    -- If there aren't, start backtracking
    elseif #backtrack_map ~= 0 then
        local direction = table.remove(backtrack_map)
        if direction == 'pos_z' then
            navigation.go_down(1)
        elseif direction == 'neg_z' then
            navigation.go_up(1)
        elseif direction == 'pos_y' then
            navigation.set_facing('neg_y')
            navigation.go_forward(1)
        elseif direction == 'neg_y' then
            navigation.set_facing('pos_y')
            navigation.go_forward(1)
        elseif direction == 'pos_x' then
            navigation.set_facing('neg_x')
            navigation.go_forward(1)
        elseif direction == 'neg_x' then
            navigation.set_facing('pos_x')
            navigation.go_forward(1)
        end

    -- If we're done backtracking, reset orientation and move forward
    else
        navigation.set_facing('pos_y')
        turtle.digUp()
        turtle.dig()
        navigation.go_forward(1)
    end
end