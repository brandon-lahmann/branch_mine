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
    block, data = turtle.inspect()
    if block and not contains(black_list, data.name) then
        print(data.name .. ' detected ' .. navigation.facing)
        return navigation.facing
    end

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

    navigation.set_orientation('pos_x')
    block, data = turtle.inspect()
    if block and not contains(black_list, data.name) then
        print(data.name .. ' detected ' .. navigation.facing)
        return navigation.facing
    end

    navigation.set_orientation('neg_x')
    block, data = turtle.inspect()
    if block and not contains(black_list, data.name) then
        print(data.name .. ' detected ' .. navigation.facing)
        return navigation.facing
    end

    navigation.set_orientation('pos_y')
    return false
end


while true do
    direction = identify_valuable()
    print(direction)
end