--table map function
function map(t, fn)
    local ret = {}
    for i, v in ipairs(t) do
        table.insert(ret, fn(v, i))
    end
    return ret
end

return map