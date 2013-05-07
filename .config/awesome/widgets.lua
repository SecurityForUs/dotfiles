-- {{{ Wibox

-- {{{ Calendar
-- calwidget =blingbling.calendar.new({type = "imagebox", image = beautiful.calendar_icon})
 --you can set blingbling.calendar.new({type = "textbox", text = "calendar"}) if you prefer a textbox
-- calwidget:set_cell_padding(4)
-- calwidget:set_columns_lines_titles_text_color(beautiful.text_font_color_2)
-- calwidget:set_title_text_color(beautiful.bg_focus)
-- }}}

-- {{{ Memory
memswidget = blingbling.progress_graph({
	height = 18,
	width = 18,
	rounded_size = 0.3,
	show_text = true,
	label = "$percent"
})
vicious.register(memswidget, vicious.widgets.mem, "$1", 13)
-- }}}

-- {{{ Battery Level
batwidget = blingbling.value_text_box({
	height = 18,
	width = 40,
	v_margin = 1,
	text_background_color = "#00000099",
	values_text_color = {
					{"#88aa00ff", 0.25},
					{"#d4aa00ff", 0.5},
					{"#d45500ff", 1}
				},
	text_color = beautiful.textbox_widget_as_label_font_color,
	rounded_size = 0.4,
	font_size = 8,
	background_color = "#00000044",
	label = "Battery: $percent%"
})
vicious.register(batwidget, vicious.widgets.bat, "$2", 61, "BAT1")
-- }}}

-- {{{ Kernel Info

sysicon = wibox.widget.imagebox()
sysicon:set_image(beautiful.widget_sys)
syswidget = wibox.widget.textbox()
vicious.register( syswidget, vicious.widgets.os, "<span color=\"#87af5f\">$2</span>")

-- {{{ Temp

tempicon = wibox.widget.imagebox()
tempicon:set_image(beautiful.widget_temp)
tempwidget = blingbling.line_graph({
	height = 18,
	width = 100,
	show_text = true,
	label = "CPU-0: $percent °C",
	rounded_size = 0.3,
	graph_bckground_color = "#00000033"
})
vicious.register(tempwidget, vicious.widgets.thermal, "$1", 9, { "coretemp.0", "core"} )

-- {{{ Weather

weatherwidget = blingbling.value_text_box({
	height = 18,
	width = 40,
	v_margin = 2,
	values_text_color = {
				{"#88aa00ff", 0}
			},
	rounded_size = 0.4,
	background_color = "#00000044",
	label = "Weather: $percent"
})
vicious.register(weatherwidget, vicious.widgets.weather, "${tempf}", 120, "KDTW")

-- }}}

-- {{{ Cpu
 
cpuwidget = blingbling.line_graph({
	height = 18,
	width = 100,
	show_text = true,
	label = "Load: $percent%",
	rounded_size = 0.3,
	graph_bckground_color = "#00000033"
})
vicious.register(cpuwidget, vicious.widgets.cpu, '$1', 2)

-- }}}

-- {{{ Hard Drives

fswidget = blingbling.value_text_box({
	height = 18,
	width = 40,
	v_margin = 1,
	text_background_color = "#00000099",
	values_text_color = {
					{"#88aa00ff", 0},
					{"#d4aa00ff", 0.75},
					{"#d45500ff", 0.77}
				},
	text_color = beautiful.textbox_widget_as_label_font_color,
	rounded_size = 0.4,
	font_size = 8,
	background_color = "#00000044",
	label = "Used [/]: $percent%"
})
vicious.register(fswidget, vicious.widgets.fs, "${/ used_p}", 60)

-- }}}

-- {{{ Net
netwidget = wibox.widget.textbox()
vicious.register(netwidget, vicious.widgets.net, function(widget, args)
	local interface = ""
	if args["{wlp3s0 carrier}"] == 1 then
		interface = "wlp3s0"
	elseif args["{enp2s0 carrier}"] == 1 then
		interface = "enp2s0"
	else
		return ""
	end

	return interface..": ^ - "..args["{"..interface.." down_kb}"].."kbps v - "..args["{"..interface.." up_kb}"].."kbps"
	end, 1)

-- }}}

-- {{{ Spacers

rbracket = wibox.widget.textbox()
rbracket:set_text(']')
lbracket = wibox.widget.textbox()
lbracket:set_text('[')
line = wibox.widget.textbox()
line:set_text('|')
space = wibox.widget.textbox()
space:set_text(' ')


-- Create a textclock widget
mytextclock = awful.widget.textclock()

-- Create a wibox for each screen and add it
mywibox = {}
bottomwibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })
    bottomwibox[s] = awful.wibox({ position = "bottom", screen = s })

    -- Top widget stuff
    local top_layout = wibox.layout.fixed.horizontal()
    top_layout:add(mytaglist[s])
    top_layout:add(mypromptbox[s])
    top_layout:add(mylauncher)
    top_layout:fill_space(true)
    if s == 1 then top_layout:add(wibox.widget.systray()) end

    -- Bottom widget stuff
    local bottom_layout = wibox.layout.fixed.horizontal()
    local bottom_right_layout = wibox.layout.fixed.horizontal()

    bottom_layout:add(batwidget)
    bottom_layout:add(space)
    bottom_layout:add(line)
    bottom_layout:add(space)
    bottom_layout:add(weatherwidget)
    bottom_layout:add(space)
    bottom_layout:add(line)
    bottom_layout:add(space)
    bottom_layout:add(memswidget)
    bottom_layout:add(space)
    bottom_layout:add(line)
    bottom_layout:add(space)
    bottom_layout:add(netwidget)
    bottom_layout:add(space)
    bottom_layout:add(line)
    bottom_layout:add(space)
    bottom_layout:add(fswidget)
    bottom_layout:add(space)
    bottom_layout:add(line)
    bottom_layout:add(space)
    bottom_layout:add(cpuwidget)
    bottom_layout:add(space)
    bottom_layout:add(line)
    bottom_layout:add(space)
    bottom_layout:add(tempwidget)
    bottom_layout:add(space)
    bottom_layout:add(line)
    bottom_layout:add(space)
    bottom_right_layout:add(syswidget)
    bottom_right_layout:add(space)
    bottom_right_layout:add(line)
    bottom_right_layout:add(space)
    bottom_right_layout:add(mytextclock)
--    bottom_right_layout:add(calwidget)
    bottom_right_layout:fill_space(true)

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    local blayout = wibox.layout.align.horizontal()

    layout:set_left(top_layout)
    layout:set_middle(mytasklist[s])
    layout:set_right(mylayoutbox[s])

--    bottomlayout:set_left(right_layout)

    blayout:set_left(bottom_layout)
    blayout:set_right(bottom_right_layout)

    mywibox[s]:set_widget(layout)
    bottomwibox[s]:set_widget(blayout)
end
-- }}}
