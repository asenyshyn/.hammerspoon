bindings = bindings .. "\nPress key to do action:\n-------------------------------------------------\n"
guide('Y', nil, "Yubikey")
hyperKey:bind({}, "Y", function()
    hs.eventtap.keyStrokes(hs.execute('PATH=$HOME/bin:/usr/local/bin:$PATH /Users/sam/bin/yubi/yubi_goog.py --yubi-no-sudo', false))
    hyperKey.triggered = true
end)

guide('L', nil, "Lock screen")
hyperKey:bind({}, "L", function()
    hs.caffeinate.startScreensaver()
    hyperKey.triggered = true
end)

-- Mouse Locate
guide('`', nil, "Mouse Locate")
hyperKey:bind({}, '`', function()
    mousecircle:show()
    hyperKey.triggered = true
end)

guide("⏎", nil, "Maximize current window")
hyperKey:bind({}, "return", function()
    local win = hs.window.frontmostWindow()
    win:setFullscreen(not win:isFullscreen())
    hyper.triggered = true
end)
