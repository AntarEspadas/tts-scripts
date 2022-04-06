require "persona-tools.mathParser"


Data = {
    toggles = {},
    data = {}
}

function onLoad(data)
    Data = JSON.decode(data) or {}
    Data.toggles = Data.toggles or {}
    Data.data = Data.data or {}
    loadData(Data.data)
    loadToggles(Data.toggles)
    self.UI.setAttribute("portrait", "image", self.guid)
end

function onSave()
    return JSON.encode(Data)
end


function loadData(data)
    --iterate over the data table
    for k, v in pairs(data) do
        self.UI.setAttribute(k, "text", v)
    end
end

function loadToggles(toggles)
    for k, v in pairs(toggles) do
        self.UI.setAttribute(k, "isOn", v)
    end
end


function saveValue(_, value, id)
    Data.data[id] = value
end

function saveToggle(_, value, id)
    Data.toggles[id] = value
end

function evaluateValue(_, value, id)
    result = MathParser.parse(value)
    if result ~= nil then
        self.UI.setAttribute(id, "text", result)
    end

    saveValue(_, result or value, id)
end