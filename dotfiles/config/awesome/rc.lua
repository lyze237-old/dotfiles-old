--[[

     Awesome WM configuration template
     github.com/lcpz

--]]

-- {{{ Required libraries
local awesome, client, mouse, screen, tag = awesome, client, mouse, screen, tag
local ipairs, string, os, table, tostring, tonumber, type = ipairs, string, os, table, tostring, tonumber, type

local gears         = require("gears")
local awful         = require("awful")
                      require("awful.autofocus")
local wibox         = require("wibox")
local beautiful     = require("beautiful")
local naughty       = require("naughty")
local lain          = require("lain")
--local menubar       = require("menubar")
local freedesktop   = require("freedesktop")
local hotkeys_popup = require("awful.hotkeys_popup").widget
local my_table      = awful.util.table or gears.table -- 4.{0,1} compatibility
-- }}}

-- {{{ Error handling
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions

local themes = {
    "blackburn",       -- 1
    "copland",         -- 2
    "dremora",         -- 3
    "holo",            -- 4
    "multicolor",      -- 5
    "powerarrow",      -- 6
    "powerarrow-dark", -- 7
    "rainbow",         -- 8
    "steamburn",       -- 9
    "vertex",          -- 10
}

awful.util.terminal = terminal
awful.layout.layouts = {
    awful.layout.suit.fair, -- 1
    awful.layout.suit.tile, -- 2
    awful.layout.suit.tile.bottom, -- 3
    awful.layout.suit.floating, -- 4
    awful.layout.suit.max, -- 5
    awful.layout.suit.magnifier -- 6
}

-- Tags
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

local chosen_theme = themes[6]
local modkey       = "Mod4"
local altkey       = "Mod1"
local terminal     = "termite"
local editor       = os.getenv("EDITOR") or "vim"
local browser      = "firefox"
local scrlocker    = os.getenv("HOME") .. "/.config/owl/scripts/lock/lock.sh"

awful.util.taglist_buttons = my_table.join(
                    awful.button({ }, 1, function(t) t:view_only() end),
                    awful.button({ modkey }, 1, function(t)
                                              if client.focus then
                                                  client.focus:move_to_tag(t)
                                              end
                                          end),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, function(t)
                                              if client.focus then
                                                  client.focus:toggle_tag(t)
                                              end
                                          end),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
                )
awful.util.tasklist_buttons = my_table.join(
                     awful.button({ }, 1, function (c)
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
                     awful.button({ }, 3, function()
                         local instance = nil

                         return function ()
                             if instance and instance.wibox.visible then
                                 instance:hide()
                                 instance = nil
                             else
                                 instance = awful.menu.clients({ theme = { width = 250 } })
                             end
                        end
                     end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                          end))


local theme_path = string.format("%s/.config/awesome/themes/%s/theme.lua", os.getenv("HOME"), chosen_theme)
beautiful.init(theme_path)
-- }}}

-- {{{ Menu
local myawesomemenu = {
    { "hotkeys", function() return false, hotkeys_popup.show_help end },
    { "manual", terminal .. " -e 'man awesome'" },
    { "edit config", string.format("%s -e '%s %s'", terminal, editor, awesome.conffile) },
    { "restart", awesome.restart },
    { "quit", function() awesome.quit() end }
}
local mypowermenu = {
    { "Shutdown", "systemctl poweroff" },
    { "Reboot", "systemctl reboot" },
    { "Lock Screen", scrlocker }
}
awful.util.mymainmenu = awful.menu({
    items = {
        { "Awesome", myawesomemenu },
        { "Power", mypowermenu },
        { "Open Terminal", terminal }
    }
})
-- }}}

-- {{{ Screen
-- Create a wibox for each screen and add it
awful.screen.connect_for_each_screen(function(s) beautiful.at_screen_connect(s) end)
-- }}}

-- {{{ Mouse bindings
root.buttons(my_table.join(
    awful.button({ }, 3, function () awful.util.mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = my_table.join(
    -- Take a screenshot
    -- https://github.com/lcpz/dots/blob/master/bin/screenshot
    awful.key({ }, "Print", function() awful.spawn.with_shell(os.getenv("HOME") .. "/.config/owl/scripts/screenshot.sh full") end,
        {description = "take a fullscreen screenshot", group = "hotkeys"}),

    awful.key({ "Control" }, "Print", function() awful.spawn.with_shell(os.getenv("HOME") .. "/.config/owl/scripts/screenshot.sh region") end,
        {description = "take a region screenshot", group = "hotkeys"}),

    -- Hotkeys
    awful.key({ modkey }, "s",      hotkeys_popup.show_help,
              {description = "show help", group="awesome"}),
    -- Tag browsing
    awful.key({ modkey }, "Left",   awful.tag.viewprev,
        {description = "view previous", group = "tag"}),
    awful.key({ modkey }, "Right",  awful.tag.viewnext,
        {description = "view next", group = "tag"}),

    -- By direction client focus
    awful.key({ modkey }, "j",
        function()
            awful.client.focus.global_bydirection("down")
            if client.focus then client.focus:raise() end
        end,
        {description = "focus down", group = "client"}),
    awful.key({ modkey }, "k",
        function()
            awful.client.focus.global_bydirection("up")
            if client.focus then client.focus:raise() end
        end,
        {description = "focus up", group = "client"}),
    awful.key({ modkey }, "h",
        function()
            awful.client.focus.global_bydirection("left")
            if client.focus then client.focus:raise() end
        end,
        {description = "focus left", group = "client"}),
    awful.key({ modkey }, "l",
        function()
            awful.client.focus.global_bydirection("right")
            if client.focus then client.focus:raise() end
        end,
        {description = "focus right", group = "client"}),

    -- Layout manipulation
    awful.key({ modkey, "Shift" }, "h", function() awful.client.swap.global_bydirection("left") end,
        {description = "focus left window", group = "client"}),
    awful.key({ modkey, "Shift" }, "j", function() awful.client.swap.global_bydirection("down") end,
        {description = "focus down window", group = "client"}),
    awful.key({ modkey, "Shift" }, "k", function() awful.client.swap.global_bydirection("up") end,
        {description = "focus up window", group = "client"}),
    awful.key({ modkey, "Shift" }, "l", function() awful.client.swap.global_bydirection("right") end,
        {description = "focus right window", group = "client"}),
		
    awful.key({ modkey }, "space", function () awful.layout.inc(1) end,
		{description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift" }, "space", function () awful.layout.inc(-1) end,
		{description = "select previous", group = "layout"}),

    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),


    -- Standard program
    awful.key({ modkey }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, "Shift" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),

	-- Pulseaudio Volume Keys
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

    -- Sink
    awful.key({ }, "Pause", function() 	awful.spawn(os.getenv("HOME") .. "/.config/owl/scripts/defaultSink.py") end,
        {description = "Switches pavu sink", group = "launcher"}),

    -- User programs
    awful.key({ modkey }, "r", function() awful.spawn("rofi -show run -modi run,drun,window") end,
        {description = "rofi run", group = "launcher"}),

    awful.key({ modkey }, "d", function() awful.spawn("rofi -show drun -modi run,drun,window") end,
        {description = "rofi drun", group = "launcher"}),

    awful.key({ modkey }, "a", function() awful.spawn("rofi -show window -modi run,drun,window") end,
        {description = "rofi window", group = "launcher"}),

    awful.key({ modkey }, "e", function() awful.spawn("exo-open --launch FileManager") end,
        {description = "file manager", group = "launcher"}),

    awful.key({ modkey }, "p", function() awful.spawn("arandr") end,
        {description = "display settings", group = "launcher"})
)

clientkeys = my_table.join(
    awful.key({ modkey }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey, "Shift" }, "q", function (c) c:kill() end,
              {description = "close", group = "client"}),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle,
              {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    awful.key({ modkey }, "t", function (c) c.ontop = not c.ontop end,
              {description = "toggle keep on top", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    -- Hack to only show tags 1 and 9 in the shortcut window (mod+s)
    local descr_view, descr_toggle, descr_move, descr_toggle_focus
    if i == 1 or i == 9 then
        descr_view = {description = "view tag #", group = "tag"}
        descr_toggle = {description = "toggle tag #", group = "tag"}
        descr_move = {description = "move focused client to tag #", group = "tag"}
        descr_toggle_focus = {description = "toggle focused client on tag #", group = "tag"}
    end
    globalkeys = my_table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  descr_view),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  descr_toggle),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  descr_move),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  descr_toggle_focus)
    )
end

clientbuttons = my_table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
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
            placement = awful.placement.under_mouse+awful.placement.no_offscreen,
            size_hints_honor = false 
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
                "PlayOnLinux"
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

    -- middle screen mutt 
    {
        rule = {
            name= "mutt"
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
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup and
      not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- Custom
    if beautiful.titlebar_fun then
        beautiful.titlebar_fun(c)
        return
    end

    -- Default
    -- buttons for the titlebar
    local buttons = my_table.join(
        awful.button({ }, 1, function()
            client.focus = c
            c:raise()
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            client.focus = c
            c:raise()
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c, {size = 16}) : setup {
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
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
        and awful.client.focus.filter(c) then
        client.focus = c
    end
	
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
