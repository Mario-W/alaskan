for i=1, 100 do
    if i%2 == 0 then
        goto continue
    else
        print('doing normal things')
        print(i)
    end

    ::continue::
    print('continue loop')
end