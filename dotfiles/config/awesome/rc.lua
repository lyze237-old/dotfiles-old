-- Imports {{{
local os = { getenv = os.getenv }
local gears = require("gears")
local awful = require("awful")
local common = require("awful.widget.common")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local lain = require("lain")
local hotkeys_popup = require("awful.hotkeys_popup").widget
-- }}}

-- Load Debian menu entries
require("awful.autofocus")
--require("debian.menu")

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
    awesome.connect_signal("debug::error", 
        function(err)
            -- Make sure we don't go into an endless error loop
            if in_error then return end
            in_error = true

            naughty.notify({
                preset = naughty.config.presets.critical,
                title = "Oops, an error happened!",
                text = tostring(err) 
            })
            in_error = false
        end
    )
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
--beautiful.init(awful.util.get_themes_dir() .. "default/theme.lua")
beautiful.init(os.getenv("HOME") .. "/.config/awesome/themes/gruvbox-dark-hard/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "termite"
editor = os.getenv("EDITOR") or "editor"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"
altkey = "Mod1"
-- }}}

-- Layout {{{ 
awful.layout.layouts = {
    awful.layout.suit.fair, --1
    awful.layout.suit.tile, --2
    awful.layout.suit.tile.bottom, --3
    awful.layout.suit.floating, --4
    awful.layout.suit.max, --5
    awful.layout.suit.magnifier --6
}
lain.layout.termfair.center.nmaster = 3
lain.layout.termfair.center.ncol = 1
-- }}}

-- {{{ Helper functions
local function client_menu_toggle_fn()
    local instance = nil

    return function()
        if instance and instance.wibox.visible then
            instance:hide()
            instance = nil
        else
            instance = awful.menu.clients({ 
                theme = { 
                    width = 250 
                } 
            })
        end
    end
end
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
    { "hotkeys", function() return false, hotkeys_popup.show_help end },
    { "manual", terminal .. " -e man awesome" },
    { "edit config", editor_cmd .. " " .. awesome.conffile },
    { "restart", awesome.restart },
    { "quit", function() awesome.quit() end }
}

mysettingsmenu = {
    { "appearance", "lxappearance" },
    { "display settings", "arandr" },
    { "edit profile", "mugshot" }
}

mypowermenu = {
    { "shutdown", "systemctl poweroff" },
    { "reboot", "systemctl reboot" },
    { "lock screen", os.getenv("HOME") .. "/.config/owl/scripts/lock/lock.sh" }
}

mymainmenu = awful.menu({
    items = {
        { "awesome", myawesomemenu },
       -- { "apps", debian.menu.Debian_menu.Debian },
        { "settings", mysettingsmenu },
        { "power", mypowermenu },
        { "open terminal", terminal }
    }
})

mylauncher = awful.widget.launcher({ 
    mage = beautiful.awesome_icon,
    menu = mymainmenu 
})
-- }}}

-- {{{ Wibar

mykeyboardlayout = awful.widget.keyboardlayout()
-- Create a wibox for each screen and add it
local taglist_buttons = awful.util.table.join(
    awful.button({ }, 1, function(t) t:view_only() end),
    awful.button({ modkey }, 1, 
        function(t)
            if client.focus then
                client.focus:move_to_tag(t)
            end
        end),
    awful.button({ }, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, 
        function(t)
            if client.focus then
                client.focus:toggle_tag(t)
            end
        end),
    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
)

local tasklist_buttons = awful.util.table.join(
    awful.button({ }, 1, 
        function(c)
            if c == client.focus then
                c.minimized = true
            else
                -- Without this, the following
                -- :isvisible() makes no sense
                c.minimized = false
                if not c:isvisible() and c.first_tag then
                    c.first_tag:view_only()
                end
                -- This will also un-minimize
                -- the client, if needed
                client.focus = c
                c:raise()
            end
        end),
    awful.button({ }, 3, client_menu_toggle_fn()),
    awful.button({ }, 4, 
        function()
            awful.client.focus.byidx(1)
        end),
    awful.button({ }, 5, 
    function()
        awful.client.focus.byidx(-1)
    end))



 
--##############################################################
--# TOP BAR
--##############################################################


-- Create a textclock widget
mytextclock = wibox.widget.textclock("<span color=\"" .. beautiful.fg_clock .. "\">%a %b %d, %H:%M</span>")
mymusic = awful.widget.watch('bash -c "mpc | head -1 | cut -c-64"', 5)

layouts = awful.layout.layouts
awful.tag({ "", "", "3", "4", "5", "6", "7", "8", "9" }, 2, 
    {layouts[3], layouts[5], layouts[1], layouts[1], layouts[1], layouts[1], layouts[1], layouts[1], layouts[1]}
)
awful.tag({ "", "", "", "4", "5", "", "", "", "" }, 1, 
    {layouts[1], layouts[1], layouts[1], layouts[1], layouts[1], layouts[6], layouts[4], 
layouts[5], layouts[1]}
)
awful.tag({ "", "", "3", "4", "5", "6", "7", "8", "9" }, 3,
    {layouts[2], layouts[5], layouts[1], layouts[1], layouts[1], layouts[1], layouts[1], layouts[1], layouts[1]}
)
chatTag = awful.tag.find_by_name(nil, "")
chatTag.master_width_factor = 0.70

local separators = lain.util.separators
separators.height = 0
separators.width  = 9

awful.screen.connect_for_each_screen(
    function(s)
        -- Create a promptbox for each screen
        s.mypromptbox = awful.widget.prompt()
        -- Create an imagebox widget which will contains an icon indicating which layout we're using.
        -- We need one layoutbox per screen.
        s.mylayoutbox = awful.widget.layoutbox(s)
        s.mylayoutbox:buttons(awful.util.table.join(
            awful.button({ }, 1, function() awful.layout.inc(1) end),
            awful.button({ }, 3, function() awful.layout.inc(-1) end),
            awful.button({ }, 4, function() awful.layout.inc(1) end),
            awful.button({ }, 5, function() awful.layout.inc(-1) end)
        ))
        -- Create a taglist widget
        s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist_buttons, {}, 
            function(w, buttons, label, data, objects)
                common.list_update(w, buttons, label, data, objects)
                for i = 1, #objects do
                    local o = objects[i]
                    local p = data[o]

                    p.tbm.left  = 7
                    p.tbm.right = 7

                    if o.selected then
                        p.bgb.shape = function(cr)
                            gears.shape.partially_rounded_rect(cr, 32, 22)
                        end
                    end
                end
            end)

        -- Create a tasklist widget
        s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, tasklist_buttons)

        -- Create the wibox
        s.mywibox = awful.wibar({ position = "top", screen = s, height = 22 })

        -- Add widgets to the wibox
        s.mywibox:setup {
            layout = wibox.layout.align.horizontal,
            { -- Left widgets
                layout = wibox.layout.fixed.horizontal,
                wibox.container.background(wibox.container.margin(mylauncher, 2, 2), beautiful.bg_prompt),
                --separators.arrow_right(beautiful.bg_prompt, beautiful.taglist_bg_occupied),
                wibox.container.background(s.mytaglist, beautiful.taglist_bg_occupied),
                separators.arrow_right(beautiful.taglist_bg_occupied, "alpha"),
                wibox.container.margin(s.mypromptbox, 5, 0),
            },
            s.mytasklist, -- Middle widget
            { -- Right widgets
                layout = wibox.layout.fixed.horizontal,
                mykeyboardlayout,

            separators.arrow_left("alpha", beautiful.bg_systray),
                wibox.container.background(wibox.container.margin(mymusic, 5, 5), beautiful.bg_systray),

                separators.arrow_left(beautiful.bg_systray, beautiful.bg_music),
                wibox.container.background(wibox.container.margin(mytextclock, 5, 5), beautiful.bg_music),

                separators.arrow_left(beautiful.bg_music, beautiful.bg_layout),
                wibox.container.background(wibox.container.margin(s.mylayoutbox, 3, 3), beautiful.bg_layout),
            },
        }
    end
)
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function() mymainmenu:toggle() end)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(

    -- Volume Keys
    awful.key({}, "XF86AudioLowerVolume", function() awful.util.spawn("pactl set-sink-volume @DEFAULT_SINK@ -5%", false) end,
        {description = "Lower Volume", group = "Music"}),
    awful.key({}, "XF86AudioRaiseVolume", function() awful.util.spawn("pactl set-sink-volume @DEFAULT_SINK@ +5%", false) end,
        {description = "Raise Volume", group = "Music"}),
    awful.key({}, "XF86AudioMute", function() awful.util.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle", false) end,
        {description = "Mute Volume", group = "Music"}),
    -- Media Keys
    awful.key({}, "XF86AudioPlay", function() awful.util.spawn("mpc toggle", false) end,
        {description = "Play/Pause", group = "Music"}),
    awful.key({}, "XF86AudioNext", function() awful.util.spawn("mpc next", false) end,
        {description = "Next", group = "Music"}),
    awful.key({}, "XF86AudioPrev", function() awful.util.spawn("mpc prev", false) end,
        {description = "Previous", group = "Music"}),

    -- sink
    awful.key({ }, "Pause", function() 	awful.spawn(os.getenv("HOME") .. "/.config/owl/scripts/defaultSink.py") end,
        {description = "Switches pavu sink", group = "launcher"}),

    -- flameshot
    awful.key({}, "Print", function() 
	awful.spawn.with_shell("maim -b 5 | xclip -selection clipboard -t image/png", false) 
        naughty.notify({
            title = "Screenshot",
            text = "Copied to clipboard"
        })
    end,
        {description = "Screenshot", group = "launcher"}),

    awful.key({modkey}, "Print", function() 
	awful.spawn.with_shell("maim -s -b 5 | xclip -selection clipboard -t image/png", 
false) 
        naughty.notify({
            title = "Screenshot",
            text = "Copied to clipboard" 
        })
    end,
        {description = "Selection screenshot", group = "launcher"}),

    -- xdg
    awful.key({ modkey }, "Pause", function() awful.spawn("~/.config/owl/scripts/clipboardXdgOpen.sh") end, 
        {description = "runs xdg-open with clipboard", group = "launcher"}),

    -- help
    awful.key({ modkey }, "s", hotkeys_popup.show_help,
        {description="show help", group="awesome"}),

    -- tag switch
    awful.key({ modkey }, "Left", awful.tag.viewprev,
        {description = "view previous", group = "tag"}),

    awful.key({ modkey }, "Right", awful.tag.viewnext,
        {description = "view next", group = "tag"}),


    -- movement
    awful.key({ modkey }, "h", function() awful.client.focus.global_bydirection("left") end,
        {description = "focus left window", group = "client"}),

    awful.key({ modkey }, "j", function() awful.client.focus.global_bydirection("down") end,
        {description = "focus down window", group = "client"}),

    awful.key({ modkey }, "k", function() awful.client.focus.global_bydirection("up") end,
        {description = "focus up window", group = "client"}),
        
    awful.key({ modkey }, "l", function() awful.client.focus.global_bydirection("right") end,
        {description = "focus right window", group = "client"}),
        
    -- swap
    awful.key({ modkey, "Shift" }, "h", function() awful.client.swap.global_bydirection("left") end,
        {description = "focus left window", group = "client"}),

    awful.key({ modkey, "Shift" }, "j", function() awful.client.swap.global_bydirection("down") end,
        {description = "focus down window", group = "client"}),

    awful.key({ modkey, "Shift" }, "k", function() awful.client.swap.global_bydirection("up") end,
        {description = "focus up window", group = "client"}),
        
    awful.key({ modkey, "Shift" }, "l", function() awful.client.swap.global_bydirection("right") end,
        {description = "focus right window", group = "client"}),
        

    -- Layout manipulation
    awful.key({ modkey, "Shift" }, "j", function() awful.client.swap.byidx(1) end,
        {description = "swap with next client by index", group = "client"}),

    awful.key({ modkey, "Shift" }, "k", function() awful.client.swap.byidx( -1) end,
        {description = "swap with previous client by index", group = "client"}),


    awful.key({ modkey, "Control" }, "j", function() awful.screen.focus_relative(1) end,
        {description = "focus the next screen", group = "screen"}),

    awful.key({ modkey, "Control" }, "k", function() awful.screen.focus_relative(-1) end,
        {description = "focus the previous screen", group = "screen"}),


    awful.key({ modkey }, "u", awful.client.urgent.jumpto,
        {description = "jump to urgent client", group = "client"}),

    awful.key({ altkey }, "Tab",
        function()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),

    -- awesome stuff

    awful.key({ modkey, "Shift" }, "r", awesome.restart,
        {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey }, "w", function() mymainmenu:show() end,
        {description = "show main menu", group = "awesome"}),


    -- # move master window

    awful.key({ modkey }, "[", function() awful.tag.incmwfact( 0.05) end,
        {description = "increase master width factor", group = "layout"}),

    awful.key({ modkey }, "]", function() awful.tag.incmwfact(-0.05) end,
        {description = "decrease master width factor", group = "layout"}),

    awful.key({ modkey, "Shift" }, "[", function() awful.tag.incnmaster( 1, nil, true) end,
        {description = "increase the number of master clients", group = "layout"}),

    awful.key({ modkey, "Shift" }, "]", function() awful.tag.incnmaster(-1, nil, true) end,
        {description = "decrease the number of master clients", group = "layout"}),

    awful.key({ modkey, "Control" }, "[", function() awful.tag.incncol( 1, nil, true) end,
        {description = "increase the number of columns", group = "layout"}),

    awful.key({ modkey, "Control" }, "]", function() awful.tag.incncol(-1, nil, true) end,
        {description = "decrease the number of columns", group = "layout"}),


    -- # switch layout

    awful.key({ modkey }, "space", function() awful.layout.inc(1) end,
        {description = "select next", group = "layout"}),

    awful.key({ modkey, "Shift" }, "space", function() awful.layout.inc(-1) end,
        {description = "select previous", group = "layout"}),


    -- # Launcher

    awful.key({ modkey }, "Return", function() awful.spawn(terminal) end,
        {description = "open a terminal", group = "launcher"}),

    awful.key({ modkey }, "r", function() awful.spawn("rofi -show run -modi run,drun,window") end,
        {description = "rofi run", group = "launcher"}),

    -- awful.key({ modkey }, "d", function() awful.spawn("rofi -show drun -modi run,drun,window") end,
      --  {description = "rofi drun", group = "launcher"}),

    awful.key({ modkey }, "a", function() awful.spawn("rofi -show window -modi run,drun,window") end,
        {description = "rofi window", group = "launcher"}),

    awful.key({ modkey }, "e", function() awful.spawn("exo-open --launch FileManager") end,
        {description = "file manager", group = "launcher"}),

    awful.key({ modkey }, "p", function() awful.spawn("arandr") end,
        {description = "display settings", group = "launcher"})

--    awful.key({ altkey, "Control" }, "l", function() awful.spawn(os.getenv("HOME") .. "/.config/owl/scripts/lock/lock.sh") end,
--        {description = "lock screen", group = "launcher"})

)







--##############################################################
--# KEY BINDINGS - CLIENT
--##############################################################

clientkeys = awful.util.table.join(
    awful.key({ modkey }, "f",
    function(c)
        c.fullscreen = not c.fullscreen
        c:raise()
    end,
    {description = "toggle fullscreen", group = "client"}),

    awful.key({ modkey, "Shift" }, "q",      function(c) c:kill() end,
        {description = "close", group = "client"}),

    awful.key({ modkey, "Shift" }, "f",  awful.client.floating.toggle,
        {description = "toggle floating", group = "client"}),

    awful.key({ modkey }, "t",  function(c) c.ontop = not c.ontop end,
        {description = "toggle keep on top", group = "client"}),

    awful.key({ modkey }, "o", function(c) c:move_to_screen() end,
        {description = "move to next screen", group = "client"}),

    awful.key({ modkey, "Shift" }, "o", function(c) c:move_to_screen(c.screen.index - 1) end,
        {description = "move to previous screen", group = "client"}),


    -- MINIMIZE / MAXIMIZE

    awful.key({ modkey }, "m",
        function(c)
            c.maximized = not c.maximized
            c:raise()
        end,
        {description = "toggle maximize", group = "client"}),

    awful.key({ modkey }, "Up",
        function(c)
            c.maximized = not c.maximized
            c:raise()
        end,
        {description = "toggle maximize", group = "client"}),

    awful.key({ modkey }, "Down", function(c) c.minimized = true end,
        {description = "minimize", group = "client"}),
        
    awful.key({ modkey}, "n", function(c) c.minimized = true end,
        {description = "minimize", group = "client"})

)







--##############################################################
--# KEY BINDINGS - TAGS
--##############################################################

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = awful.util.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
            function()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    tag:view_only()
                end
            end,
            {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
            function()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    awful.tag.viewtoggle(tag)
                end
            end,
            {description = "toggle tag #" .. i, group = "tag"}),
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
            {description = "move focused client to tag #"..i, group = "tag"}),
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
        {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end







--##############################################################
--# CLIENT BUTTONS
--##############################################################

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function(c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
        except_any = { 
            class = {
                "albert"
            } 
        },
        properties = { 
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = clientkeys,
            buttons = clientbuttons,
            screen = awful.screen.preferred,
            placement = awful.placement.under_mouse+awful.placement.no_offscreen
        }
    },

    -- Floating clients.
    { 
        rule_any = {
            instance = {
                "DTA",  -- Firefox addon DownThemAll.
                "copyq",  -- Includes session name in class.
            },
            class = {
                "Arandr",
                "Gpick",
                "Peek",
                "Kruler",
                "MessageWin",  -- kalarm.
                "Sxiv",
                "Wpa_gui",
                "pinentry",
                "veromix",
                "xtightvncviewer",
                "flameshot",
                "stalonetray"
            },
            name = {
                "Event Tester",  -- xev.
            },
            role = {
                "AlarmWindow",  -- Thunderbird's calendar.
                "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
            }
        }, 
        properties = { 
            floating = true
        }
    },

    -- Add titlebars to normal clients and dialogs
    { 
        rule = {
            type = "normal" 
        },
        properties = { 
            titlebars_enabled = false
        }
    },
    { 
        rule = {
            type = "dialog" 
        },
        properties = { 
            titlebars_enabled = true
        }
    },

    -- left screen default rules
    { 
        rule_any = { 
            name = { 
                "ncmpcpp", 
                "htop", 
                "pulsemixer" 
            }  
        }, 
        properties = { 
            screen = 2, 
            tag = "" 
        } 
    },
    { 
        rule = { 
            class = "mpv"
        }, 
        properties = { 
        }, 
        callback = function(c) 
	    filepath = os.getenv("HOME") .. "/.cache/requireFullscreen"
	    file = io.open(filepath, "r")
	    print("Reading file: " .. filepath)
	    if not file then return nil end
	    print("After file" .. file:read("*all"))
	    file:close()
	    awful.spawn.with_shell("rm " .. filepath)
            c.fullscreen = true
	    c.screen = 2
	    c.tag = ""
            tag = awful.tag.find_by_name(nil, "")
            if tag.selected == false then
            awful.tag.viewtoggle(screen[2].selected_tag)
            awful.tag.viewtoggle(tag) 
            end
        end 
    },

    -- missuse rule detection to copy nextcloud pw into clipboard
    {
        rule = {
            class = "Nextcloud",
	    name = "Enter Password"
        },
        properties = {
        },
        callback = function(c)
	     awful.spawn.with_shell("cat " .. os.getenv("HOME") .. "/nextcloud.txt | xargs echo -n | xclip -selection clipboard")
        end
    }, 

    -- middle screen unity 
    { 
        rule = { 
                class ="Unity"
        }, 
        properties = { 
            screen = 1, 
            tag = "5" 
        } 
    },



    -- middle screen default rulesf
    { 
        rule = { 
                class ="Steam"
        }, 
        properties = { 
            screen = 1, 
            tag = "" 
        } 
    },

    -- middle screen awesome edit
    {
        rule_any = {
            name = {
                "dotfiles",
                "shell",
                "awesome-rc.lua"
            }
        },
        properties = {
            screen = 1,
            tag = ""
        }
    },


    -- middle screen rtv
    {
        rule = {
            name = "rtv"
        },
        properties = {
            screen = 1,
            tag = ""
        }
    },

    -- middle screen thunderbird
    {
        rule = {
            class = "Thunderbird"
        },
        properties = {
            screen = 1,
            tag = ""
        }
    },

    -- middle screen obs
    {
         rule = {
             name = "obs"
         },
         properties = {
             screen = 1,
             tag = ""
         }
     },

    -- right screen default rules
    { 
        rule_any = { 
            class = {
                "discord",
                "Corebird",
                "Telegram"
            }
        }, 
        properties = { 
            screen = 3, 
            tag = "" 
        } 
    },

    -- right screen weechat
   {
        rule = {
            name = "weechat"
        },
        properties = {
            screen = 3,
            tag = ""
        }
   }

}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", 
    function(c)
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- if not awesome.startup then awful.client.setslave(c) end

        if awesome.startup and
        not c.size_hints.user_position
        and not c.size_hints.program_position then
            -- Prevent clients from being unreachable after screen count changes.
            awful.placement.no_offscreen(c)
        end
    end
)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", 
    function(c)
        -- buttons for the titlebar
        local buttons = awful.util.table.join(
            awful.button({ }, 1, 
                function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.move(c)
                end
            ),
            awful.button({ }, 3, 
                function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.resize(c)
                end
            )
        )

        awful.titlebar(c) : setup {
            { -- Left
                awful.titlebar.widget.iconwidget(c),
                buttons = buttons,
                layout  = wibox.layout.fixed.horizontal
            },
            { -- Middle
                { -- Title
                    align  = "center",
                    widget = awful.titlebar.widget.titlewidget(c)
                },
                buttons = buttons,
                layout  = wibox.layout.flex.horizontal
            },
            { -- Right
                awful.titlebar.widget.floatingbutton(c),
                awful.titlebar.widget.stickybutton(c),
                awful.titlebar.widget.ontopbutton(c),
                awful.titlebar.widget.minimizebutton(c),
                awful.titlebar.widget.maximizedbutton(c),
                awful.titlebar.widget.closebutton(c),
                layout = wibox.layout.fixed.horizontal()
            },
            layout = wibox.layout.align.horizontal
        }
    end
)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", 
    function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end
)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

awful.spawn.with_shell("~/.config/owl/wallpaper/applyWallpaper.sh")
