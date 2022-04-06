
Data = {
    songLists = {

    },
    latestId = -1
}

DoubleClicks = {

}

Body = ""
Title = ""

DoneEditingCallback = nil

function onLoad(data)
    Data = JSON.decode(data) or Data
    self.UI.hide("done-button")
    self.UI.hide("song-input")
    loadButtons(Data)
end

function loadButtons(data)
    local xml = self.UI.getXmlTable()
    local mainTable = getById(xml[1], "main-table").children[1]
    for k, v in pairs(data.songLists) do
        table.insert(mainTable.children, createRow(k, v.title))
    end
    self.UI.setXmlTable(xml)
end

function onSave()
    return JSON.encode(Data)
end

function getSongList(callback, previousDescription, previousTitle)

    local body = previousDescription or ""
    local title = previousTitle or ""
    Body = body
    Title = title

    self.UI.setAttribute("body", "text", body)
    self.UI.setAttribute("title", "text", title)

    self.UI.show("song-input")
    self.UI.show("done-button")
    self.UI.hide("add-button")

    DoneEditingCallback = function ()
        self.UI.hide("song-input")
        self.UI.hide("done-button")
        self.UI.show("add-button")


        body = Body or ""
        title = Title or ""
        local songs = split(body, "\n")
        songs = filter(songs, function(song) return song ~= "" and song:sub(1, 1) ~= "#" end)


        callback({
            songs = songs,
            description = body,
            title = title
        })
    end
end

function bodyEndEdit(_, value, id)
    Body = value
end

function titleEndEdit(_, value, id)
    Title = value
end

function add()
    getSongList(function (songLIst)
        if songLIst == nil then
            return
        end
        local id = Data.latestId + 1
        Data.latestId = id
        id = tostring(id)
        Data.songLists[id] = songLIst
        addButtons(id, songLIst.title)
    end)
end

function done()
    DoneEditingCallback()
end

function finishAdding()
end

function on_play()
    WebRequest.get("http://localhost:2334?play=" .. url)
end

function edit(_, _, id)
    id = id:sub(5)
    getSongList(function (songLIst)
        if songLIst == nil or Data.songLists[id] == nil then
            return
        end
        Data.songLists[id] = songLIst
        editButton(id, songLIst.title)
    end, Data.songLists[id].description, Data.songLists[id].title)
end

function editButton(id, title)
    local xml = self.UI.getXmlTable()
    local mainTable = getById(xml[1], "main-table").children[1]
    local row = getById(mainTable, id)
    row.children[1].children[1].children[1].value = title
    self.UI.setXmlTable(xml)
end

function delete(_, _, id)
    id = id:sub(7)
    if not DoubleClicks[id] then
        DoubleClicks[id] = true
        Wait.time(function ()
            DoubleClicks[id] = nil
        end, 0.5)
        return
    end
    Data.songLists[id] = nil
    deleteButton(id)
end

function play(_, _, id)
    id = id:sub(5)
    local songs = Data.songLists[id].songs
    local song = songs[math.random(#songs)]
    local json = JSON.encode(songs)
    local url, password = table.unpack(split(self.getGMNotes(), "\n"))
    local headers = {
        ["Authorization"] = password
    }
    WebRequest.custom(url .. "/play?list=" .. json, "GET", true, "_", headers, function (response)
        if response.text ~= "success" then
            print(response.text)
        end
    end)
end

function deleteButton(id)
    local xml = self.UI.getXmlTable()
    local mainTable = getById(xml[1], "main-table").children[1]
    local index = getIndexById(mainTable, id)
    table.remove(mainTable.children, index)
    self.UI.setXmlTable(xml)
end

function addButtons(id, title)
    local xml = self.UI.getXmlTable()
    local root = xml[1]
    local mainTable = getById(root, "main-table").children[1]
    table.insert(mainTable.children, createRow(id, title))
    self.UI.setXmlTable(xml)
end

function getById(parent, id)
    for i, v in ipairs(parent.children) do
        if v.attributes.id == id then
            return v
        end
    end
end

function getIndexById(parent, id)
    for i, v in ipairs(parent.children) do
        if v.attributes.id == id then
            return i
        end
    end
end

function getBytag(parent, tag)
    local result = {}
    for i, v in ipairs(parent.children) do
        if v.tag == tag then
            table.insert(result, v)
        end
    end
    return result
end

function split(str, sep)
    local result = {}
    local regex = ("([^%s]+)"):format(sep)
    for each in str:gmatch(regex) do
        table.insert(result, each)
    end
    return result
end

function filter(t, f)
    local result = {}
    for i, v in ipairs(t) do
        if f(v) then
            table.insert(result, v)
        end
    end
    return result
end






















function createRow(id, title)

    local row =
    {
        tag = "Row",
        attributes = {
            id = id,
        },
        children = {
            {
                tag = "Cell",
                children = {
                    {
                        tag = "Button",
                        attributes = {
                            id = "play" .. id,
                            onClick = "play",
                        },
                        children = {
                            {
                                tag = "Text",
                                value = title
                            }
                        }
                    }
                }
            },
            {
                tag = "Cell",
                children = {
                    {
                        tag = "Button",
                        attributes = {
                            id = "edit" .. id,
                            onClick = "edit"
                        },
                        children = {
                            {
                                tag = "Text",
                                value = "Edit"
                            }
                        }
                    }
                }
            },
            {
                tag = "Cell",
                children = {
                
                    {
                        tag = "Button",
                        attributes = {
                            id = "delete" .. id,
                            onClick = "delete"
                        },
                        children = {
                            {
                                tag = "Text",
                                value = "X"
                            }
                        }
                    }
                    
                
                }
            }
        }
    }
    return row
end

function setXml(obj)
    local xml = '<Panel color="#00000000" width="1700" height="900" scale="-0.125 -0.35 0.125" position="0 0 -22" verticalOverflow="Overflow">'
        .. '<InputField id="title" color="#222222" textColor="White" pivot="0.5 0.5" placeholder="Title" textAlignment="MiddleCenter" resizeTextForBestFit="true" resizeTextMaxSize="1000" rotation="0 0 90" position="-770 0 0" width="850" height="100" />'
        .. '<InputField id="description" color="#222222" placeholder="Enter the YouTube URLs for the songs here, one per line, then hit \'Done\' in the main card. Lines starting with \'#\' will be ignored" textColor="White" fontSize="35" width="850" height="1500" lineType="MultiLineNewLine" position="65 0 0" rotation="0 0 90"/>'
        .. '</Panel>' 
    obj.UI.setXml(xml)
    -- obj.UI.setXmlTable({
    --     tag = "Panel",
    --     attributes = {
    --         color = "Red"
    --     }
    -- })
end
