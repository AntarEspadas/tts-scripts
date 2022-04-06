require "persona-tools.sheet"

function loadImage(_, value, id)
    Global.UI.setCustomAssets({{
        name = self.guid,
        url = value
    }})

    -- self.UI.setAttribute(id, "image", "")

    -- Wait.time(function () self.UI.setAttribute(id, "image", self.guid) end, 2, 0)
end