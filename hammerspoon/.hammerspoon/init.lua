---@diagnostic disable: undefined-global

local top_padding = 40

local center_tall = function()
	local win = hs.window.focusedWindow()
	local f = win:frame()
	local screen = win:screen()
	local max = screen:frame()

	f.w = 3 * max.w / 5
	f.h = max.h - top_padding
	win:setFrame(f)
	win:centerOnScreen()
	f = win:frame()
	f.y = f.y + 10
	win:setFrame(f)
end

local center = function()
	local win = hs.window.focusedWindow()
	local f = win:frame()
	local screen = win:screen()
	local max = screen:frame()

	f.w = 3 * max.w / 5
	f.h = max.h / 1.5
	win:setFrame(f)
	win:centerOnScreen()
end

hs.hotkey.bind({ "alt", "shift" }, "G", function()
	center_tall()
end)

hs.hotkey.bind({ "alt", "shift" }, "C", function()
	center()
end)

hs.hotkey.bind({ "alt", "ctrl", "shift" }, "R", function()
	hs.reload()
end)

-- Bind Command + ` (Backtick) to cycle windows of the same app
hs.hotkey.bind({ "alt", "shift" }, "N", function()
	local win = hs.window.focusedWindow()
	if not win then
		return
	end

	local app = win:application()
	local appWindows = app:allWindows()

	-- 1. Filter for standard, visible windows
	local validWindows = {}
	for _, w in ipairs(appWindows) do
		if w:isStandard() and w:isVisible() then
			table.insert(validWindows, w)
		end
	end

	if #validWindows < 2 then
		return
	end

	-- 2. SORT the windows by ID to ensure a stable loop order
	table.sort(validWindows, function(a, b)
		return a:id() < b:id()
	end)

	-- 3. Find current index in the sorted list
	local currentIndex = 0
	for i, w in ipairs(validWindows) do
		if w:id() == win:id() then
			currentIndex = i
			break
		end
	end

	-- 4. Calculate next index and focus
	local nextIndex = (currentIndex % #validWindows) + 1
	validWindows[nextIndex]:focus()
end)
hs.alert.show("Config loaded")
