-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")
-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
--local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
local brightness_widget = require("awesome-wm-widgets.brightness-widget.brightness")
local wifi_widget = require("code.awesome_widgets.wifi_util")
--local battery_widget = require("awesome-wm-widgets.battery-widget.battery")
local spotify_widget = require("awesome-wm-widgets.spotify-widget.spotify")
local spotify_shell = require("awesome-wm-widgets.spotify-shell.spotify-shell")
local batteryarc_widget = require("awesome-wm-widgets.batteryarc-widget.batteryarc")
local calendar_widget = require("awesome-wm-widgets.calendar-widget.calendar")
local volume_widget = require('awesome-wm-widgets.volume-widget.volume')
--local todo_widget = require("awesome-wm-widgets.todo-widget.todo")
local space_widget = wibox.widget {
    forced_width = 5,
    layout = wibox.layout.fixed.horizontal,
}
local space_widget1 = wibox.container.background(space_widget, "#FF0000")
require("awful.hotkeys_popup.keys")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({
        preset = naughty.config.presets.critical,
        title = "Oops, there were errors during startup!",
        text = awesome.startup_errors
    })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function(err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({
            preset = naughty.config.presets.critical,
            title = "Oops, an error happened!",
            text = tostring(err)
        })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "alacritty"
editor = os.getenv("EDITOR") or "nvim"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod1"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.floating,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier,
    awful.layout.suit.corner.nw,
    awful.layout.suit.corner.ne,
    awful.layout.suit.corner.sw,
    awful.layout.suit.corner.se,
}


-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
    { "Hotkeys",     function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
    { "Manual",      terminal .. " -e man awesome" },
    { "Edit config", editor_cmd .. " " .. awesome.conffile },
    { "Restart",     awesome.restart },
    { "Quit",        function() awesome.quit() end },
}
beautiful.menu_height = 20
beautiful.menu_width = 150
--beautiful.menu_fg_normal=""
--beautiful.menu_fg_focus="#4c4b49"
--beautiful.menu_bg_normal="#2b3339"
--beautiful.menu_bg_focus="#1e2327"



-- Basic layout for adding option in apps
--{ "", function() awful.util.spawn("") end},

local myapps = {
    { "Firefox",   function() awful.util.spawn("firefox") end },
    { "Chrome",    function() awful.util.spawn("google-chrome-stable") end },
    { "Tekken",    function() awful.util.spawn("wine /home/Arch/Games/Tekken_3.exe") end },
    { "lutris",    function() awful.util.spawn("lutris") end },
    { "VLC",       function() awful.util.spawn("vlc") end },
    { "wallpaper", function() awful.util.spawn("nitrogen") end },
    { "Spotify",   function() awful.util.spawn("spotify-launcher") end }
}
-- To add awesome icon add ", beautiful.awesome_icon" after myawesomemenu or myapps
local mymainmenu = awful.menu({
    items = { { "apps", myapps },
        { "awesome",       myawesomemenu },
        { "open terminal", terminal }
    }
})

local mylauncher = awful.widget.launcher({
    image = "/home/Arch/Downloads/message.png",
    menu = mymainmenu
})

-- Menubar configuration
--menubar.utils.terminal = terminal -- Set the terminal for applications that require it
--}}}

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- {{{ Wibar
-- Create a textclock widget
mytextclock = wibox.widget.textclock()
local cw = calendar_widget({
    theme = 'nord',
    placement = 'top_right',
    start_sunday = true,
    radius = 8,
    previous_month_button = 1,
    next_month_button = 3,
})
mytextclock:connect_signal("button::press",
    function(_, _, _, button)
        if button == 1 then cw.toggle() end
    end)

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
    awful.button({}, 1, function(t) t:view_only() end),
    awful.button({ modkey }, 1, function(t)
        if client.focus then
            client.focus:move_to_tag(t)
        end
    end),
    awful.button({}, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, function(t)
        if client.focus then
            client.focus:toggle_tag(t)
        end
    end),
    awful.button({}, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({}, 5, function(t) awful.tag.viewprev(t.screen) end)
)
local tasklist_buttons = gears.table.join(
    awful.button({}, 1, function(c)
        if c == client.focus then
            c.minimized = true
        else
            c:emit_signal(
                "request::activate",
                "tasklist",
                { raise = true }
            )
        end
    end),
    awful.button({}, 3, function()
        awful.menu.client_list({ theme = { width = 250 } })
    end),
    awful.button({}, 4, function()
        awful.client.focus.byidx(1)
    end),
    awful.button({}, 5, function()
        awful.client.focus.byidx(-1)
    end))

local function set_wallpaper(s)
    local wallpaper = "/home/Arch/wallpapers/0008.jpg"
    -- If wallpaper is a function, call it with the screen
    if type(wallpaper) == "function" then
        wallpaper = wallpaper(s)
    end
    gears.wallpaper.maximized(wallpaper, s, true)
end
--end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

--Updating env variable
awesome.connect_signal(
    'exit',
    function()
        awful.util.spawn('export awesome= ')
    end
)

awesome.connect_signal(
    'startup',
    function()
        awful.util.spawn('export awesome=yes')
    end
)
awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table.
    local tags = {
        names = { "A", "W", "E", "S", "O", "M", "E", "😎" },
--        layout = { awful.layout.layouts[1], awful.layout.layouts[1], awful.layout.layouts[1],
--            awful.layout.layouts[1], awful.layout.layouts[1], awful.layout.layouts[1],
--            awful.layout.layouts[1], awful.layout.layouts[1], awful.layout.layouts[1] }
    }

    -- Add tags to each screen
    -- Each screen has its own tag table.
    awful.tag(tags.names, s, awful.layout.layouts[1])

    s.systray = wibox.widget.systray()
    s.systray.visible = false
    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
        awful.button({}, 1, function() awful.layout.inc(1) end),
        awful.button({}, 3, function() awful.layout.inc(-1) end),
        awful.button({}, 4, function() awful.layout.inc(1) end),
        awful.button({}, 5, function() awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons,
    }
    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen          = s,
        filter          = awful.widget.tasklist.filter.currenttags,
        buttons         = tasklist_buttons,
        style           = {
            align = "center",
        },
        layout          = {
            spacing_widget = {
                {
                    widget = wibox.widget.separator
                },
                valign = 'center',
                halign = 'center',
                widget = wibox.container.place,
            },
            layout = wibox.layout.fixed.horizontal
        },
        widget_template = {
            {
                {
                    {
                        id = 'icon_role',
                        widget = wibox.widget.imagebox,
                    },
                    {
                        id = 'text_role',
                        widget = wibox.widget.textbox,
                        max_width = 50, -- Adjust this width as needed
                        ellipsize = "middle", -- Truncate text in the middle if it exceeds width
                    },
                    layout = wibox.layout.fixed.horizontal,
                },
                left = 10,
                right = 10,
                max_width = 50,
                widget = wibox.container.margin,
            },
            shape = gears.shape.rounded_rect,
            widget = wibox.container.background,
            max_width = 100,
        },

    }
    -- Create the wibox
    s.mywibox = awful.wibar({
        position = "top",
        height = 21.5,
        screen = s,
        fg = beautiful.fg_normal,
        opacity = 0.7, -- set the opacity to make it transparent
        visible = true,
        widget = wibox.container.background
    })
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            mylauncher,
            s.mytaglist,
            s.mypromptbox,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            spotify_widget({
                play_icon = '/home/Arch/wallpapers/spotify_green.svg',
                pause_icon = '/home/Arch/wallpapers/spotify_green.svg',
                dim_when_paused = true,
                dim_opacity = 0.5,
                max_length = -1,
                show_tooltip = true,
            }),
            space_widget,
            wibox.widget.systray(),
            brightness_widget {
                type = 'arc',
                program = 'light',
                base = 50,
                step = 10
            },
            space_widget,
            wifi_widget({
                mode='wifi'
            }),
            space_widget,
            batteryarc_widget({
                show_current_level = true,
            }),
            space_widget,
            volume_widget({
                widget_type = 'arc',
                card = 0
            }),
            space_widget,
            mytextclock,
        }
    }
end)
--}}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
    awful.button({}, 3, function() mymainmenu:toggle() end),
    awful.button({}, 4, awful.tag.viewnext),
    awful.button({}, 5, awful.tag.viewprev)
))
-- }}}
awful.screen.focused().mywibox.visible = true
-- {{{ Key bindings
globalkeys = gears.table.join(

    awful.key({ modkey, }, "a", hotkeys_popup.show_help,
        { description = "show help", group = "awesome" }),
    awful.key({ "Mod4", }, "s", function() awful.util.spawn("spotify-launcher") end,
        { description = "show help", group = "music" }),
    awful.key({ modkey, }, "d", function() spotify_shell.launch() end, { description = "spotify shell", group = "music" }),
    awful.key({ modkey }, "0", function()
            awful.util.spawn("scrot /home/Arch/screenshots/%d-%m-%Y--%H-%M-%S.png")
            naughty.notify({ text = "Taking a screenshot" })
        end,
        { description = "take a screenshot", group = "screenshot" }),
    awful.key({ modkey, "Control" }, "0", function()
            awful.util.spawn("scrot -s -d 1 /home/Arch/screenshots/%d-%m-%Y--%H-%M-%S.png")
            naughty.notify({ text = "Saving snippet" })
        end,
        { description = "take a screenshot", group = "screenshot" }),
    awful.key({ modkey, }, "/", function() awful.util.spawn("sp play", false) end),
    awful.key({ modkey, }, ".", function() awful.util.spawn("sp next", false) end),
    awful.key({ modkey, }, ",", function() awful.util.spawn("sp prev", false) end),
    awful.key({ modkey }, "=", function() awful.spawn.with_shell("feh --bg-fill --random ~/wallpapers") end,
        { description = "Change Wallpaper", group = "awesome" }),
    awful.key({ modkey, }, "Tab", awful.tag.history.restore,
        { description = "go back", group = "tag" }),

    awful.key({ "Mod1", }, "j",
        function() awful.client.focus.byidx(1) end,
        { description = "focur next client", group = "client" }
    ),
    awful.key({ "Mod1", }, "k",
        function() awful.client.focus.byidx(-1) end,
        { description = "focur previous client", group = "client" }
    ),
    --awful.key({ "Mod1",           }, "Left",
    --    function ()  awful.client.focus.bydirection("left")  end,
    --    {description = "focur left client", group = "client"}
    --),
    --awful.key({ "Mod1",           }, "Right",
    --    function () awful.client.focus.bydirection("right") end,
    --    {description = "focur right client", group = "client"}
    --),
    awful.key({ modkey, }, "h",
        function() awful.client.focus.bydirection("left") end,
        { description = "focur left client", group = "client" }
    ),
    awful.key({ modkey, }, "l",
        function() awful.client.focus.bydirection("right") end,
        { description = "focur right client", group = "client" }
    ),
    --awful.key({ "Mod1",           }, "Up",
    --    function () awful.client.focus.bydirection("up")   end,
    --    {description = "focur up client", group = "client"}
    --),
    --awful.key({ "Mod1",           }, "Down",
    --    function () awful.client.focus.bydirection("down") end,
    --    {description = "focur down client", group = "client"}
    --),

    -- Layout manipulation (height & width)
    awful.key({ modkey, "Shift" }, "l", function() awful.tag.incmwfact(0.05) end,
        { description = "increase master width factor", group = "layout" }),
    awful.key({ modkey, "Shift" }, "h", function() awful.tag.incmwfact(-0.05) end,
        { description = "decrease master width factor", group = "layout" }),
    awful.key({ "Mod1", "Shift" }, "o", function() awful.client.incwfact(0.05) end,
        { description = "let's see", group = "client" }),
    awful.key({ "Mod1", "Shift" }, ";", function() awful.client.incwfact(-0.05) end,
        { description = "let's see", group = "client" }),
    -- Layout manipulation (tile shifting)
    awful.key({ modkey, "Shift" }, "j", function() awful.client.swap.byidx(1) end,
        { description = "swap with next client by index", group = "client" }),
    awful.key({ modkey, "Shift" }, "k", function() awful.client.swap.byidx(-1) end,
        { description = "swap with previous client by index", group = "client" }),
    awful.key({ modkey, }, "o", function () awful.screen.focus_relative( 1) end,
            {description = "focus the next screen", group = "screen"}),
    --awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
    --        {description = "focus the previous screen", group = "screen"}),
    --awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
    --        {description = "jump to urgent client", group = "client"}),

    awful.key({ modkey, }, "Tab",
        function()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        { description = "go back", group = "client" }),

    -- Standard program
    awful.key({ modkey, }, "Return", function() awful.spawn(terminal) end,
        { description = "open a terminal", group = "launcher" }),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
        { description = "reload awesome", group = "awesome" }),
    awful.key({ modkey, "Shift" }, "q", awesome.quit,
        { description = "quit awesome", group = "awesome" }),
    awful.key({ modkey, }, "[", function() awful.spawn.with_shell("pactl -- set-sink-volume 0 +5%") end,
        { description = "Increse volume", group = "Volume" }),
    awful.key({ modkey, }, "]", function() awful.spawn.with_shell("pactl -- set-sink-volume 0 -5%") end,
        { description = "Decrease volume", group = "Volume" }),
    awful.key({ modkey, }, "g", function() awful.util.spawn("google-chrome-stable") end,
        { description = "web browser", group = "applications" }),
    awful.key({ modkey,"Control" }, "c", function() awful.util.spawn("firefox -kiosk -url https://chat.openai.com") end,
        { description = "Chatgpt in firefox", group = "applications" }),

    --awful.key({ modkey, "Control"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
    --          {description = "increase the number of master clients", group = "layout"}),
    --awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
    --         {description = "decrease the number of master clients", group = "layout"}),

    --awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
    --        {description = "increase the number of columns", group = "layout"}),
    --    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
    --            {description = "decrease the number of columns", group = "layout"}),

    -- layouts
    awful.key({ modkey, "Shift" }, "Right", function() awful.layout.inc(1) end,
        { description = "select next", group = "layout" }),
    awful.key({ modkey, "Shift" }, "Left", function() awful.layout.inc(-1) end,
        { description = "select previous", group = "layout" }),

    awful.key({ modkey, "Control" }, "n",
        function()
            local c = awful.client.restore()
            -- Focus restored client
            if c then
                c:emit_signal(
                    "request::activate", "key.unminimize", { raise = true }
                )
            end
        end,
        { description = "restore minimized", group = "client" }),

    awful.key({ modkey }, "b", function()
        awful.screen.focused().mywibox.visible = not awful.screen.focused().mywibox.visible
    end, { description = "Toggle top-bar visibility", group = "custom" }),
    awful.key({ "Mod4", }, "space", function() awful.util.spawn("dmenu_run") end,
        { description = "run prompt", group = "launcher" })
)

clientkeys = gears.table.join(
    awful.key({ modkey, "Control" }, "f",
        function(c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        { description = "toggle fullscreen", group = "client" }),
    awful.key({ "Mod4" }, "x", function(c) c:kill() end,
        { description = "close", group = "client" }),
    awful.key({ modkey }, "x", function(c) c:kill() end,
        { description = "close", group = "client" }),
    awful.key({ modkey, "Control" }, "z", awful.client.floating.toggle,
        { description = "toggle floating", group = "client" }),
    awful.key({ modkey, "Control" }, "Return", function(c) c:swap(awful.client.getmaster()) end,
        { description = "move to master", group = "client" }),
    awful.key({ modkey, "Control" }, "o", function(c) c:move_to_screen() end,
        { description = "move to screen", group = "client" }),
    awful.key({ modkey, }, "t", function(c) c.ontop = not c.ontop end,
        { description = "toggle keep on top", group = "client" }),
    awful.key({ modkey, }, "n",
        function(c)
            c.minimized = true
        end,
        { description = "minimize", group = "client" }),
    awful.key({ modkey, }, "m",
        function(c)
            c.maximized = not c.maximized
            c:raise()
        end,
        { description = "(un)maximize", group = "client" }),
    awful.key({ modkey, "Control" }, "m",
        function(c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end,
        { description = "(un)maximize vertically", group = "client" }),
    awful.key({ modkey, "Shift" }, "m",
        function(c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end,
        { description = "(un)maximize horizontally", group = "client" })
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
            function()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    tag:view_only()
                end
            end,
            { description = "view tag #" .. i, group = "tag" }),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
            function()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    awful.tag.viewtoggle(tag)
                end
            end,
            { description = "toggle tag #" .. i, group = "tag" }),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
            function()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:move_to_tag(tag)
                    end
                end
            end,
            { description = "move focused client to tag #" .. i, group = "tag" }),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
            function()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:toggle_tag(tag)
                    end
                end
            end,
            { description = "toggle focused client on tag #" .. i, group = "tag" })
    )
end

clientbuttons = gears.table.join(
    awful.button({}, 1, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
    end),
    awful.button({ modkey }, 1, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    {
        rule = {},
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = clientkeys,
            buttons = clientbuttons,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap + awful.placement.no_offscreen
        }
    },

    -- Floating clients.
    {
        rule_any = {
            instance = {
                "DTA", -- Firefox addon DownThemAll.
                "copyq", -- Includes session name in class.
                "pinentry",
            },
            class = {
                "Arandr",
                "Blueman-manager",
                "Gpick",
                "Kruler",
                "MessageWin", -- kalarm.
                "Sxiv",
                "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
                "Wpa_gui",
                "veromix",
                "xtightvncviewer" },

            -- Note that the name property shown in xprop might be set slightly after creation of the client
            -- and the name shown there might not match defined rules here.
            name = {
                "Event Tester", -- xev.
            },
            role = {
                "AlarmWindow", -- Thunderbird's calendar.
                "ConfigManager", -- Thunderbird's about:config.
                "pop-up",  -- e.g. Google Chrome's (detached) Developer Tools.
            }
        },
        properties = { floating = true }
    },

    -- Add titlebars to normal clients and dialogs
    {
        rule_any = { type = { "normal", "dialog" } },
        properties = { titlebars_enabled = false }
    },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
        and not c.size_hints.user_position
        and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({}, 1, function()
            c:emit_signal("request::activate", "titlebar", { raise = true })
            awful.mouse.client.move(c)
        end),
        awful.button({}, 3, function()
            c:emit_signal("request::activate", "titlebar", { raise = true })
            awful.mouse.client.resize(c)
        end)
    )

    local myTitlebar = awful.titlebar(c,
        { size = 16 },
        { opacity = 0.6 }
    )


    myTitlebar:setup {

        {  -- Left
            --awful.titlebar.widget.iconwidget(c),
            --buttons = buttons,
            layout = wibox.layout.fixed.horizontal
        },
        {      -- Middle
            {  -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        {  -- Right
            --awful.titlebar.widget.floatingbutton (c),
            --awful.titlebar.widget.maximizedbutton(c),
            --awful.titlebar.widget.stickybutton   (c),
            --awful.titlebar.widget.ontopbutton    (c),
            --awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", { raise = false })
end)
client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

--GAPS
beautiful.useless_gap = 3

-- Autostart Application
--awful.spawn.with_shell("kdeconnectd")
--awful.spawn.with_shell("volctl")
--awful.spawn.with_shell("nm-applet")
--awful.spawn.with_shell("blueman-applet")
awful.spawn.with_shell("picom")
--awful.spawn.with1_shell("/home/Arch/.screenlayout/dual_screen.sh")
