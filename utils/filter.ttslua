--table filter function
function filter(t, fn)
    local ret = {}
    for i, v in ipairs(t) do
        if fn(v, i) then
            --add v to ret
            table.insert(ret, v)
        end
    end
    return ret
end

return filter