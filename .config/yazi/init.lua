require("bookmarks"):setup({
	save_last_directory = false,
	notify = {
		enable = false,
		timeout = 1,
		message = {
			new = "New bookmark '<key>' -> '<folder>'",
			delete = "Deleted bookmark in '<key>'",
			delete_all = "Deleted all bookmarks",
		},
	},
})

-- function Manager:render(area)
-- 	local chunks = self:layout(area)
--
--   local bar = function(c, x, y)
--   	x, y = math.max(0, x), math.max(0, y)
--   	return ui.Bar(ui.Rect { x = x, y = y, w = ya.clamp(0, area.w - x, 1), h = math.min(1, area.h) }, ui.Bar.TOP)
--   		:symbol(c)
--   end
--
-- 	return ya.flat {
-- 		-- Borders
--   	ui.Border(area, ui.Border.ALL):type(ui.Border.ROUNDED),
--   	ui.Bar(chunks[1], ui.Bar.RIGHT),
--   	ui.Bar(chunks[3], ui.Bar.LEFT),
--
--   	bar("┬", chunks[1].right - 1, chunks[1].y),
--   	bar("┴", chunks[1].right - 1, chunks[1].bottom - 1),
--   	bar("┬", chunks[2].right, chunks[2].y),
--   	bar("┴", chunks[2].right, chunks[1].bottom - 1),
--
--  		-- Parent
--   	Parent:render(chunks[1]:padding(ui.Padding.xy(1))),
--   	-- Current
--   	Current:render(chunks[2]:padding(ui.Padding.y(1))),
--   	-- Preview
--   	Preview:render(chunks[3]:padding(ui.Padding.xy(1))),
--  	}
--  end

-- require("full-border"):setup()

function Status:name()
	local h = cx.active.current.hovered
	if not h then
		return ui.Span("")
	end

	local linked = ""
	if h.link_to ~= nil then
		linked = " -> " .. tostring(h.link_to)
	end
	return ui.Span(" " .. h.name .. linked)
end

require("yatline"):setup({
	section_separator = { open = "", close = "" },
	part_separator = { open = "", close = "" },

	style_a = {
		fg = "#282828",
		bg_mode = {
			normal = "#a89984",
			select = "#d79921",
			un_set = "#d65d0e",
		},
	},
	style_b = { bg = "#665c54", fg = "#ebdbb2" },
	style_c = { bg = "#3c3836", fg = "#a89984" },

	permissions_t_fg = "green",
	permissions_r_fg = "yellow",
	permissions_w_fg = "red",
	permissions_x_fg = "cyan",
	permissions_s_fg = "darkgray",

	tab_width = 20,

	selected = { icon = "󰻭", fg = "yellow" },
	copied = { icon = "", fg = "green" },
	cut = { icon = "", fg = "red" },

	total = { icon = "󰮍", fg = "yellow" },
	succ = { icon = "", fg = "green" },
	fail = { icon = "", fg = "red" },
	found = { icon = "󰮕", fg = "blue" },
	processed = { icon = "󰐍", fg = "green" },

	header_line = {
		left = {
			section_a = {
				{ type = "line", custom = false, name = "tabs", params = { "left" } },
			},
			section_b = {},
			section_c = {},
		},
		right = {
			section_a = {
				{ type = "string", custom = false, name = "date", params = { "%A, %d %B %Y" } },
			},
			section_b = {
				{ type = "string", custom = false, name = "date", params = { "%X" } },
			},
			section_c = {},
		},
	},

	status_line = {
		left = {
			section_a = {
				{ type = "string", custom = false, name = "tab_mode" },
			},
			section_b = {
				{ type = "string", custom = false, name = "hovered_size" },
			},
			section_c = {
				{ type = "string", custom = false, name = "hovered_name" },
				{ type = "coloreds", custom = false, name = "count" },
			},
		},
		right = {
			section_a = {
				{ type = "string", custom = false, name = "cursor_position" },
			},
			section_b = {
				{ type = "string", custom = false, name = "cursor_percentage" },
			},
			section_c = {
				{ type = "string", custom = false, name = "hovered_file_extension", params = { true } },
				{ type = "coloreds", custom = false, name = "permissions" },
			},
		},
	},
})
