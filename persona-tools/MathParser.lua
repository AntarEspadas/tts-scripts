
MathParser = {}

function parsePlusSeparatedExpression(expression)
    -- lets say expression = 123 + 58 + 49
    if expression == "" then
        return nil
    end
    local numbersString = split(expression, '+') -- ["123", "58", "49"]
    -- convert string to number, you may also use parseInt for readability
    local numbers = map(numbersString, function (noStr) return parseMinusSeparatedExpression(noStr) end) -- [123, 58, 49]
    local initialValue = 0.0
    -- accumulate all values
    local result = reduce(numbers, function(acc, no) return acc + no end, initialValue)
    return result
end

function parseMultiplicationSeparatedExpression(expression)
    -- lets say expression = 123 * 58 * 49
    local numbersString = split(expression, '*') -- ["123", "58", "49"]
    -- convert string to number, you may also use parseInt for readability
    local numbers = map(numbersString, function (noStr) return parseDivisionSeparatedExpression(noStr) end) -- [123, 58, 49]
    local initialValue = 1.0
    -- accumulate all values
    local result = reduce(numbers, function(acc, no) return acc * no end, initialValue)
    return result
end

function parseDivisionSeparatedExpression(expression)
    -- lets say expression = 123 / 58 / 49
    local numbersString = split(expression, '/') -- ["123", "58", "49"]
    -- convert string to number, you may also use parseInt for readability
    local numbers = map(numbersString, function (noStr) return tonum(noStr) end) -- [123, 58, 49]
    local initialValue = numbers[1]
    -- accumulate all values
    local result = reduce(slice(numbers, 2), function(acc, no) return acc / no end, initialValue)
    return result
end

function parseMinusSeparatedExpression(expression)
    -- lets say expression = 123 - 58 - 49
    local numbersString = split(expression, '-') -- ["123", "58", "49"]
    -- convert string to number, you may also use parseInt for readability
    local numbers = map(numbersString, function (noStr) return parseMultiplicationSeparatedExpression(noStr) end) -- [123, 58, 49]
    local initialValue = numbers[1]
    -- accumulate all values
    local result = reduce(slice(numbers, 2), function(acc, no) return acc - no end, initialValue)
    return result
end

function parse(value)
    --call parsePlusSeparatedExpression in protected mode, return the result or nil if an error occurs
    local status, result = pcall(parsePlusSeparatedExpression, value)
    if status then
        return result
    else
        return nil
    end
end

function split (inputstr, sep)
    if sep == nil then
            sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
            table.insert(t, str)
    end
    return t
end

--table map function
function map(t, f)
    local out = {}
    for k, v in pairs(t) do
        out[k] = f(v)
    end
    return out
end

--table reduce function
function reduce(t, f, initialValue)
    local acc = initialValue
    for k, v in pairs(t) do
        acc = f(acc, v)
    end
    return acc
end

--table slice function
function slice(t, first, last, step)
    local sliced = {}
    local i = first or 1
    local j = last or #t
    local step = step or 1
    for i = i, j, step do
        sliced[#sliced+1] = t[i]
    end
    return sliced
end

function tonum(v)
    return tonumber(v) or error("not a number")
end

MathParser.parse = parse

return MathParser