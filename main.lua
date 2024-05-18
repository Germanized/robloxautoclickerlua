local widget = require("widget")

local screenWidth, screenHeight = widget.systemInfo("screenSize")

local menuWidth = 200
local menuHeight = 100
local padding = 15

local circleRadius = 20

local menuBackgroundColor = { 0.1, 0.1, 0.1, 0 } -- { red, green, blue, alpha } (initially transparent)

local textColor = { 1, 1, 1, 1 }

local switchWidth = 50
local switchHeight = 20

local menu = widget.newView(screenWidth / 2 - menuWidth / 2, screenHeight / 2 - menuHeight / 2, menuWidth, menuHeight, { backgroundColor = menuBackgroundColor })

function drawRoundedRect(x, y, width, height, radius)
  widget.setClipping(true)
  widget.renderQuad(x, y, radius, radius, menuBackgroundColor)
  widget.renderQuad(x + width - radius, y, radius, radius, menuBackgroundColor)
  widget.renderQuad(x, y + height - radius, radius, radius, menuBackgroundColor)
  widget.renderQuad(x + width - radius, y + height - radius, radius, radius, menuBackgroundColor)
  widget.renderQuad(x + radius, y, width - 2 * radius, radius, menuBackgroundColor)
  widget.renderQuad(x + radius, y + height - radius, width - 2 * radius, radius, menuBackgroundColor)
  widget.renderQuad(x, y + radius, radius, height - 2 * radius, menuBackgroundColor)
  widget.renderQuad(x + width - radius, y + radius, radius, height - 2 * radius, menuBackgroundColor)
  widget.setClipping(false)
end

local menuAlpha = 0
function drawMenuBackground()
  drawRoundedRect(0, 0, menuWidth, menuHeight, 10)
  menuAlpha = math.min(menuAlpha + 0.01, 1) -- Gradually increase alpha to 1 (opaque)
  menu.backgroundColor = { menuBackgroundColor[1], menuBackgroundColor[2], menuBackgroundColor[3], menuAlpha }
end

local menuLabel = widget.newText(padding, padding, menuWidth - 2 * padding, 20, "Auto Clicker", { textColor = textColor, horizontalAlignment = "center" })
menu:addChild(menuLabel)

local circle = widget.newCircle(circleRadius, circleRadius, circleRadius, { backgroundColor = { 1, 0.5, 0, 1 } })
menu:addChild(circle)

local switchButton = widget.newButton(menuWidth - switchWidth - padding, menuHeight / 2 - switchHeight / 2, switchWidth, switchHeight, { backgroundColor = { 0.5, 0.5, 0.5, 1 } })
menu:addChild(switchButton)

local switchLabel = widget.newText(switchWidth / 2 - 10, switchHeight / 2 - 5, 40, 15, "Off", { textColor = textColor, horizontalAlignment = "center" })
switchButton:addChild(switchLabel)

local isSwitchOn = false

local isDragging = false
local dragOffsetX = 0
local dragOffsetY = 0

function updateCirclePosition(x, y)
  circle.x = x - dragOffsetX + circleRadius
  circle.y = y - dragOffsetY + circleRadius
end

function onMouseEvent(event)
  if event.phase == "began" then
    if event.target == menu then
      isDragging = true
      local x, y = widget.getMousePosition()
      dragOffsetX, dragOffsetY = x - menu.x, y - menu.y
    end
  elseif event.phase == "ended" then
    isDragging = false
  end

  if event.phase == "moved" and isDragging then
    local x, y = widget.getMousePosition
