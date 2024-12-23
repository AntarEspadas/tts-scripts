function first(t, fn)
    for i, v in ipairs(t) do
        if fn(v, i) then
            return v
        end
    end
end