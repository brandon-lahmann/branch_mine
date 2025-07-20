os.loadAPI("navigation.lua")

black_list = {

}

function contains(array, value)
    for i = 1, #array do
        if array[i] == value then
            return true
        end
    end
    return false
end

function identify_valuable()
    block, data = turtle.inspectUp()
    if block and not contains(black_list, data.name) then
        print(data.name .. ' detected pos_z')
        return 'pos_z'
    end

    block, data = turtle.inspectDown()
    if block and not contains(black_list, data.name) then
        print(data.name .. ' detected neg_z')
        return 'neg_z'
    end

    for i = 1, 4 do
        block, data = turtle.inspect()
        if block and not contains(black_list, data.name) then
            print(data.name .. ' detected ' .. navigation.direction_map[navigation.facing])
            return navigation.direction_map[navigation.facing]
        end
        navigation.turn_right(1)
    end
end


while true do
    direction = identify_valuable()
    print(direction)
end