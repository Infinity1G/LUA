local ui = _G["ui"] -- localizing globals cuz if i dont vscode gives me warnings and warnings are ugly
local ui_new_checkbox, ui_new_color_picker, ui_get, ui_set_callback = ui.new_checkbox, ui.new_color_picker, ui.get, ui.set_callback
local renderer = _G["renderer"]
local renderer_gradient, renderer_text, renderer_measure_text = renderer.gradient, renderer.text, renderer.measure_text
local client = _G["client"]
local client_set_event_callback, client_unset_event_callback, client_screen_size = client.set_event_callback, client.unset_event_callback, client.screen_size
local ipairs = ipairs

local override = ui_new_checkbox("VISUALS", "Other ESP", "Override indicator color")
local override_color = ui_new_color_picker("VISUALS", "Other ESP", "override_indicator_color", 0, 150, 255, 225)

local indicators = {}
local _, screen_height = client_screen_size()

local function on_paint()
    for i,v in ipairs(indicators) do
        local text_width, text_height = renderer_measure_text("d+", v[5])
        local y = screen_height - 348 - (text_height + 8) * (i - 1)

        renderer_gradient(10, y - 2, text_width / 2, text_height + 4, 0, 0, 0, 0, 0, 0, 0, 50, true)
        renderer_gradient(10 + text_width / 2, y - 2, text_width / 2, text_height + 4, 0, 0, 0, 50, 0, 0, 0, 0, true)
        renderer_text(20, y, v[1], v[2], v[3], v[4], "d+", 0, v[5])
    end

    indicators = {}
end

local function on_indicator(e)
    local r, g, b, a = ui_get(override_color)

    if e.text == "DT" and e.r == 255 and e.g == 0 and e.b == 50 and e.a == 255 then
        r, g, b = 255, 0, 50
    end

    indicators[#indicators + 1] = {r, g, b, a, e.text}
end

local function handle_callbacks()
    local event_callback = ui_get(override) and client_set_event_callback or client_unset_event_callback

    event_callback("paint", on_paint)
    event_callback("indicator", on_indicator)
end

handle_callbacks()
ui_set_callback(override, handle_callbacks)
