--- PLUGIN SETUP/CONFIG
--- Require plugin, giving a warning notification if a plugin is not found
--- @param plugin_name string
--- @return nil|any
local function require_plugin(plugin_name)
    local status_ok, plugin = pcall(require, plugin_name)

    if not status_ok then
        ya.notify({
            title = "Plugins",
            content = "Could not find plugin: " .. plugin_name,
            timeout = 5,
        })
        return nil
    end

    return plugin
end

local starship = require_plugin("starship")
if starship then
    starship:setup()
end

local bookmarks = require_plugin("bookmarks")
if bookmarks then
    bookmarks:setup({
        notify = {
            enable = true,
            timeout = 1,
            message = {
                new = " Created bookmark '<key>'",
                delete = "󰧌 Deleted bookmark '<key>'",
                delete_all = "󰧌 Deleted all bookmarks",
            },
        },
    })
end

-- OVERRIDE DEFAULT UI
-- Give some extra space for footer and header + cool columns
local old_build = Tab.build
Tab.build = function(self, ...)
    local bar = function(c, x, y)
        if x <= 0 or x == self._area.w - 1 then
            return ui.Bar(ui.Rect.default, ui.Bar.TOP)
        end

        return ui.Bar(
            ui.Rect({
                x = x,
                y = math.max(0, y),
                w = ya.clamp(0, self._area.w - x, 1),
                h = math.min(1, self._area.h),
            }),
            ui.Bar.TOP
        ):symbol(c)
    end

    local c = self._chunks
    self._chunks = {
        c[1]:padding(ui.Padding.y(1)),
        c[2]:padding(ui.Padding(c[1].w > 0 and 0 or 1, c[3].w > 0 and 0 or 1, 1, 1)),
        c[3]:padding(ui.Padding.y(1)),
    }

    local style = THEME.manager.border_style
    self._base = ya.list_merge(self._base or {}, {
        --[[ ui.Border(self._area, ui.Border.ALL):type(ui.Border.ROUNDED):style(style), ]]
        ui.Bar(self._chunks[1], ui.Bar.RIGHT):style(style),
        ui.Bar(self._chunks[3], ui.Bar.LEFT):style(style),

        bar("┬", c[1].right - 1, c[1].y),
        bar("┴", c[1].right - 1, c[1].bottom - 1),
        bar("┬", c[2].right, c[2].y),
        bar("┴", c[2].right, c[1].bottom - 1),
    })

    old_build(self, ...)
end
