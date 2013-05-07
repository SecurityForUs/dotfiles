layouts =
{
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    --awful.layout.suit.spiral.dwindle,
    --awful.layout.suit.max,
    --awful.layout.suit.max.fullscreen,
    --awful.layout.suit.magnifier
}
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    --tags[s] = awful.tag({ "Gödel ", "Fermat ", "Gauss ", "Riemann ", "Golbach ", "Fibonacci ", "Arquimedes " }, s,
    tags[s] = awful.tag({ "1 ", "2 ", "3 ", "4 ", "5 ", "6 ", "7" }, s,
    -- tags[s] = awful.tag({ "¹", "´", "²", "©", "ê", "º" }, s,
        { layouts[1], layouts[1], layouts[1],
              layouts[6], layouts[6], layouts[6], layouts[1]
               })
end
-- }}}
