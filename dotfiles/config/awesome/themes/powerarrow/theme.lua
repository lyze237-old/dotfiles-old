--[[

     Powerarrow Awesome WM theme
     github.com/lcpz

--]]

local gears = require("gears")
local lain  = require("lain")
local awful = require("awful")
local wibox = require("wibox")

local os, math, string = os, math, string
local my_table = awful.util.table or gears.table -- 4.{0,1} compatibility

local theme                                     = {}
theme.dir                                       = os.getenv("HOME") .. "/.config/awesome/themes/powerarrow"
theme.wallpaper                                 = theme.dir .. "/wall.png"
theme.font                                      = "Ubuntu Mono Regular 12"

theme.colors = {}
theme.colors.bg1                                = "#1D2021"
theme.colors.bg2                                = "#3C3836"
theme.colors.bg3                                = "#504945"
theme.colors.fg1                                = "#EBDBB2"
theme.colors.fg2                                = "#A89984"
theme.colors.fg3                                = "#7C6F64"
theme.colors.pink                               = "#D3869B"
theme.colors.red                                = "#FB4934"
theme.colors.orange                             = "#FE8019"
theme.colors.yellow                             = "#FABD2F"
theme.colors.lime                               = "#B8BB26"
theme.colors.green                              = "#8EC07C"
theme.colors.blue                               = "#83A598"

theme.bg_normal                                 = theme.colors.bg1
theme.bg_focus                                  = theme.bg_normal
theme.bg_urgent                                 = theme.bg_normal
theme.bg_minimize                               = theme.bg_normal

theme.bg_systray                                = theme.colors.bg3
theme.bg_music                                  = theme.colors.bg2
theme.bg_clock                                  = theme.colors.bg1
theme.fg_clock                                  = theme.colors.blue
theme.bg_layout                                 = theme.colors.red

theme.fg_normal                                 = theme.colors.fg1
theme.fg_focus                                  = theme.colors.blue
theme.fg_urgent                                 = theme.colors.orange
theme.fg_minimize                               = theme.colors.fg3


theme.border_normal                             = theme.colors.bg1
theme.border_focus                              = theme.colors.orange
theme.border_marked                             = theme.colors.red

theme.bg_prompt                                 = theme.colors.red

theme.taglist_bg_empty                          = theme.colors.bg3
theme.taglist_bg_occupied                       = theme.colors.bg3
theme.taglist_bg_focus                          = theme.colors.bg1
theme.taglist_bg_urgent                         = theme.colors.bg3
theme.taglist_fg_empty                          = theme.colors.fg3
theme.taglist_fg_occupied                       = theme.colors.fg1
theme.taglist_fg_focus                          = theme.colors.red
theme.taglist_fg_urgent                         = theme.colors.orange

theme.titlebar_bg_normal                        = theme.border_normal
theme.titlebar_bg_focus                         = theme.border_focus
theme.titlebar_fg_normal                        = theme.colors.fg1
theme.titlebar_fg_focus                         = theme.colors.fg1

theme.border_width                              = 2
theme.menu_height                               = 16
theme.menu_width                                = 140
theme.menu_submenu_icon                         = theme.dir .."/icons/submenu.png"
theme.awesome_icon                              = theme.dir .."/icons/awesome.png"
theme.taglist_squares_sel                       = theme.dir .."/icons/square_sel.png"
theme.taglist_squares_unsel                     = theme.dir .."/icons/square_unsel.png"
theme.layout_tile                               = theme.dir .."/icons/tile.png"
theme.layout_tileleft                           = theme.dir .."/icons/tileleft.png"
theme.layout_tilebottom                         = theme.dir .."/icons/tilebottom.png"
theme.layout_tiletop                            = theme.dir .."/icons/tiletop.png"
theme.layout_fairv                              = theme.dir .."/icons/fairv.png"
theme.layout_fairh                              = theme.dir .."/icons/fairh.png"
theme.layout_spiral                             = theme.dir .."/icons/spiral.png"
theme.layout_dwindle                            = theme.dir .."/icons/dwindle.png"
theme.layout_max                                = theme.dir .."/icons/max.png"
theme.layout_fullscreen                         = theme.dir .."/icons/fullscreen.png"
theme.layout_magnifier                          = theme.dir .."/icons/magnifier.png"
theme.layout_floating                           = theme.dir .."/icons/floating.png"
theme.widget_ac                                 = theme.dir .."/icons/ac.png"
theme.widget_battery                            = theme.dir .."/icons/battery.png"
theme.widget_battery_low                        = theme.dir .."/icons/battery_low.png"
theme.widget_battery_empty                      = theme.dir .."/icons/battery_empty.png"
theme.widget_mem                                = theme.dir .."/icons/mem.png"
theme.widget_cpu                                = theme.dir .."/icons/cpu.png"
theme.widget_temp                               = theme.dir .."/icons/temp.png"
theme.widget_net                                = theme.dir .."/icons/net.png"
theme.widget_hdd                                = theme.dir .."/icons/hdd.png"
theme.widget_music                              = theme.dir .."/icons/note.png"
theme.widget_music_on                           = theme.dir .."/icons/note_on.png"
theme.widget_music_pause                        = theme.dir .."/icons/pause.png"
theme.widget_music_stop                         = theme.dir .."/icons/stop.png"
theme.widget_vol                                = theme.dir .."/icons/vol.png"
theme.widget_vol_low                            = theme.dir .."/icons/vol_low.png"
theme.widget_vol_no                             = theme.dir .."/icons/vol_no.png"
theme.widget_vol_mute                           = theme.dir .."/icons/vol_mute.png"
theme.widget_mail                               = theme.dir .."/icons/mail.png"
theme.widget_mail_on                            = theme.dir .."/icons/mail_on.png"
theme.widget_task                               = theme.dir .."/icons/task.png"
theme.widget_scissors                           = theme.dir .."/icons/scissors.png"
theme.tasklist_plain_task_name                  = true
theme.tasklist_disable_icon                     = true
theme.useless_gap                               = 10
theme.titlebar_close_button_focus               = theme.dir .."/icons/titlebar/close_focus.png"
theme.titlebar_close_button_normal              = theme.dir .."/icons/titlebar/close_normal.png"
theme.titlebar_ontop_button_focus_active        = theme.dir .."/icons/titlebar/ontop_focus_active.png"
theme.titlebar_ontop_button_normal_active       = theme.dir .."/icons/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_inactive      = theme.dir .."/icons/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_inactive     = theme.dir .."/icons/titlebar/ontop_normal_inactive.png"
theme.titlebar_sticky_button_focus_active       = theme.dir .."/icons/titlebar/sticky_focus_active.png"
theme.titlebar_sticky_button_normal_active      = theme.dir .."/icons/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_inactive     = theme.dir .."/icons/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_inactive    = theme.dir .."/icons/titlebar/sticky_normal_inactive.png"
theme.titlebar_floating_button_focus_active     = theme.dir .."/icons/titlebar/floating_focus_active.png"
theme.titlebar_floating_button_normal_active    = theme.dir .."/icons/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_inactive   = theme.dir .."/icons/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_inactive  = theme.dir .."/icons/titlebar/floating_normal_inactive.png"
theme.titlebar_maximized_button_focus_active    = theme.dir .."/icons/titlebar/maximized_focus_active.png"
theme.titlebar_maximized_button_normal_active   = theme.dir .."/icons/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_inactive  = theme.dir .."/icons/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_inactive = theme.dir .."/icons/titlebar/maximized_normal_inactive.png"

local markup = lain.util.markup
local separators = lain.util.separators

-- Clock
local clock = awful.widget.watch(
    "date +'%a %d %b %R'", 60,
    function(widget, stdout)
        widget:set_markup(" " .. markup.font(theme.font, stdout))
    end
)

-- Calendar
theme.cal = lain.widget.calendar({
    attach_to = { clock },
	followtag = true,
    notification_preset = {
        font = "Ubuntu Mono Regular 10",
        fg   = theme.fg_normal,
        bg   = theme.bg_normal
    }
})

-- Mail IMAP check
local mailicon = wibox.widget.imagebox(theme.widget_mail)
local mail = awful.widget.watch(
    "bash -c \"~/.config/owl/scripts/unreadEmails.sh '' '' '0'\"", 60,
    function(widget, stdout)
        widget:set_markup(" " .. markup.font(theme.font, stdout))
    end
)


-- MPD
local mpdicon = wibox.widget.imagebox(theme.widget_music)
mpdicon:buttons(my_table.join(
    awful.button({ }, 1, function ()
        awful.spawn.with_shell("mpc prev")
        theme.mpd.update()
    end),
    awful.button({ }, 2, function ()
        awful.spawn.with_shell("mpc toggle")
        theme.mpd.update()
    end),
    awful.button({ }, 3, function ()
        awful.spawn.with_shell("mpc next")
        theme.mpd.update()
    end)))
theme.mpd = lain.widget.mpd({
    settings = function()
        if mpd_now.state == "play" then
            artist = " " .. string.sub(mpd_now.artist, 0, 20) .. " "
            title  = string.sub(mpd_now.title, 0, 30)  .. " "
            mpdicon:set_image(theme.widget_music_on)
            widget:set_markup(markup.font(theme.font, markup("#FF8466", artist) .. " " .. title))
        elseif mpd_now.state == "pause" then
            widget:set_markup(markup.font(theme.font, " mpd paused "))
            mpdicon:set_image(theme.widget_music_pause)
        else
            widget:set_text("")
            mpdicon:set_image(theme.widget_music)
        end
    end
})

-- MEM
local memicon = wibox.widget.imagebox(theme.widget_mem)
local mem = lain.widget.mem({
    settings = function()
        widget:set_markup(markup.font(theme.font, " " .. string.format("%6.2f", mem_now.used) .. "MB "))
    end
})

-- CPU
local cpuicon = wibox.widget.imagebox(theme.widget_cpu)
local cpu = lain.widget.cpu({
    settings = function()
        widget:set_markup(markup.font(theme.font, " " .. string.format("%02d", cpu_now.usage) .. "% "))
    end
})

-- Coretemp (lain, average)
local temp = lain.widget.temp({
    settings = function()
        widget:set_markup(markup.font(theme.font, " " .. string.format("%5.2f", coretemp_now) .. "°C "))
    end
})
local tempicon = wibox.widget.imagebox(theme.widget_temp)

-- Net
local neticon = wibox.widget.imagebox(theme.widget_net)
local net = lain.widget.net({
    settings = function()
        widget:set_markup(markup.fontfg(theme.font, "#FEFEFE", " " .. net_now.received .. " ↓↑ " .. net_now.sent .. " "))
    end
})
	
function theme.at_screen_connect(s)
	awful.spawn.with_shell(os.getenv("HOME") .. "/.config/owl/wallpaper/applyWallpaper.sh")

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(my_table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, awful.util.taglist_buttons)

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.focused, awful.util.tasklist_buttons)

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s, height = 22, bg = theme.bg_normal, fg = theme.fg_normal })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            s.mytaglist,
            s.mypromptbox,
            spr,
            separators.arrow_right("#504945", theme.bg_normal)
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            separators.arrow_left(theme.bg_normal, "#343434"),
            wibox.container.background(wibox.container.margin(wibox.widget { mailicon, mail, layout = wibox.layout.align.horizontal }, 4, 7), "#343434"),
            separators.arrow_left("#343434", theme.bg_normal),
            wibox.container.background(wibox.container.margin(wibox.widget { mpdicon, theme.mpd.widget, layout = wibox.layout.align.horizontal }, 3, 6), theme.bg_focus),
            separators.arrow_left(theme.bg_normal, "#777E76"),
            wibox.container.background(wibox.container.margin(wibox.widget { memicon, mem.widget, layout = wibox.layout.align.horizontal }, 2, 3), "#777E76"),
            separators.arrow_left("#777E76", "#4B696D"),
            wibox.container.background(wibox.container.margin(wibox.widget { cpuicon, cpu.widget, layout = wibox.layout.align.horizontal }, 3, 4), "#4B696D"),
            separators.arrow_left("#4B696D", "#4B3B51"),
            wibox.container.background(wibox.container.margin(wibox.widget { tempicon, temp.widget, layout = wibox.layout.align.horizontal }, 4, 4), "#4B3B51"),
            separators.arrow_left("#4B3B51", "#C0C0A2"),
            wibox.container.background(wibox.container.margin(wibox.widget { nil, neticon, net.widget, layout = wibox.layout.align.horizontal }, 3, 3), "#C0C0A2"),
            separators.arrow_left("#C0C0A2", "#777E76"),
            wibox.container.background(wibox.container.margin(clock, 4, 8), "#777E76"),
            separators.arrow_left("#777E76", "#D65D0E"),
            --]]
            wibox.container.background(wibox.container.margin(s.mylayoutbox, 3, 3), "#D65D0E"),
        },
    }
end

return theme
