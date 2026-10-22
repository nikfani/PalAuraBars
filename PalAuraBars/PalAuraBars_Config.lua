local PAB = PalAuraBars
local L = PAB.L

local cfg
local refreshers = {}

local function AddRefresher(fn)
	refreshers[#refreshers + 1] = fn
end

local function MakeSection(parent, text, x, y)
	local fs = parent:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	fs:SetPoint("TOPLEFT", parent, "TOPLEFT", x, y)
	fs:SetText(text)
	return 26
end

local function MakeCheckbox(parent, text, x, y, get, set)
	local name = "PalAuraBarsCfgCB" .. (#refreshers + 1)
	local cb = CreateFrame("CheckButton", name, parent, "UICheckButtonTemplate")
	cb:SetPoint("TOPLEFT", parent, "TOPLEFT", x, y)
	local lab = cb:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	lab:SetPoint("LEFT", cb, "LEFT", 26, 0)
	lab:SetJustifyH("LEFT")
	lab:SetText(text)
	cb:SetHitRectInsets(0, -(lab:GetStringWidth() + 8), 0, 0)
	cb:SetScript("OnClick", function(self)
		set(not not self:GetChecked())
		PAB:Refresh()
	end)
	cb.refresh = function()
		cb:SetChecked(get())
	end
	AddRefresher(cb.refresh)
	return 24
end

local function MakeSlider(parent, key, label, x, y, minv, maxv, step, get, set)
	local name = "PalAuraBarsCfgS_" .. key
	local s = CreateFrame("Slider", name, parent, "OptionsSliderTemplate")
	s:SetWidth(210)
	s:SetHeight(16)
	s:SetMinMaxValues(minv, maxv)
	s:SetValueStep(step)
	s:SetPoint("TOPLEFT", parent, "TOPLEFT", x, y - 14)
	local st = _G[name .. "Text"]
	if st then st:SetText(label) end
	local sLow = _G[name .. "Low"]
	if sLow then sLow:SetText(string.format("%g", minv)) end
	local sHigh = _G[name .. "High"]
	if sHigh then sHigh:SetText(string.format("%g", maxv)) end
	if not st then
		local lab = parent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
		lab:SetPoint("BOTTOMLEFT", s, "TOPLEFT", 0, 4)
		lab:SetText(label)
	end

	local val = parent:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	val:SetPoint("LEFT", s, "RIGHT", 10, 0)
	val:SetWidth(46)
	val:SetJustifyH("LEFT")
	local fmt = (step < 1) and "%.2f" or "%d"

	s:SetScript("OnValueChanged", function(self, value)
		local v = math.floor(value / step + 0.5) * step
		v = math.floor(v * 100 + 0.5) / 100
		if v ~= self._lock then
			self._lock = v
			self:SetValue(v)
		end
		val:SetText(string.format(fmt, v))
		if get() ~= v then
			set(v)
			PAB:Refresh()
		end
	end)
	s.refresh = function()
		local v = get()
		s._lock = v
		s:SetValue(v)
		val:SetText(string.format(fmt, v))
	end
	AddRefresher(s.refresh)
	return 48
end

local function MakeDropdown(parent, key, label, x, y, items, get, set)
	local lab = parent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	lab:SetPoint("TOPLEFT", parent, "TOPLEFT", x, y)
	lab:SetText(label)

	local name = "PalAuraBarsCfgDD_" .. key
	local dd = CreateFrame("Frame", name, parent, "UIDropDownMenuTemplate")
	dd:SetPoint("TOPLEFT", parent, "TOPLEFT", x - 16, y - 20)
	UIDropDownMenu_SetWidth(dd, 170)

	UIDropDownMenu_Initialize(dd, function(_, level)
		for _, item in ipairs(items) do
			local info = UIDropDownMenu_CreateInfo()
			info.text = item.text
			info.func = function()
				set(item.value)
				UIDropDownMenu_SetText(dd, item.text)
				CloseDropDownMenus()
				PAB:Refresh()
			end
			info.checked = (get() == item.value)
			UIDropDownMenu_AddButton(info, level)
		end
	end)

	dd.refresh = function()
		local cur = get()
		for _, item in ipairs(items) do
			if item.value == cur then
				UIDropDownMenu_SetText(dd, item.text)
				return
			end
		end
	end
	AddRefresher(dd.refresh)
	return 48
end

local function MakeButton(parent, text, x, y, width, onclick)
	local name = "PalAuraBarsCfgBtn" .. (#refreshers + 1)
	local b = CreateFrame("Button", name, parent, "UIPanelButtonTemplate")
	b:SetWidth(width or 110)
	b:SetHeight(22)
	b:SetPoint("TOPLEFT", parent, "TOPLEFT", x, y)
	b:SetText(text)
	b:SetScript("OnClick", onclick)
	return b
end

local NAMECOLOR_ITEMS = {
	{ text = L.colWhite, value = "WHITE" },
	{ text = L.colClass, value = "CLASS" },
	{ text = L.colAura,  value = "AURA" },
}

function PAB:CreateConfig()
	if cfg then return end
	local db = self.db

	local f = CreateFrame("Frame", "PalAuraBarsConfigFrame", UIParent)
	f:SetWidth(780)
	f:SetHeight(670)
	f:SetPoint("CENTER")
	f:SetFrameStrata("DIALOG")
	f:SetClampedToScreen(true)
	f:SetMovable(true)
	f:EnableMouse(true)
	f:RegisterForDrag("LeftButton")
	f:SetScript("OnDragStart", function(s) s:StartMoving() end)
	f:SetScript("OnDragStop", function(s) s:StopMovingOrSizing() end)
	f:SetBackdrop({
		bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
		edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
		tile = true, tileSize = 32, edgeSize = 32,
		insets = { left = 11, right = 12, top = 12, bottom = 11 },
	})
	cfg = f

	local title = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	title:SetPoint("TOP", f, "TOP", 0, -18)
	title:SetText("PalAuraBars")

	local hint = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	hint:SetPoint("BOTTOM", f, "BOTTOM", 0, 14)
	hint:SetText("/pa — окно настроек, /pa unlock — перемещение")

	local x1, x2 = 28, 412
	local y = -52

	y = y - MakeSection(f, L.secDisplay, x1, y)
	y = y - MakeCheckbox(f, L.enable, x1 + 8, y, function() return db.enabled end, function(v) db.enabled = v end)
	y = y - MakeCheckbox(f, L.groupOnly, x1 + 8, y, function() return db.groupOnly end, function(v) db.groupOnly = v end)
	y = y - MakeCheckbox(f, L.fontShadow, x1 + 8, y, function() return db.fontShadow end, function(v) db.fontShadow = v end)
	y = y - MakeDropdown(f, "namecolor", L.nameColor, x1 + 8, y, NAMECOLOR_ITEMS, function() return db.nameColor end, function(v) db.nameColor = v end)

	y = y - 8
	y = y - MakeSection(f, L.secSize, x1, y)
	y = y - MakeSlider(f, "width", L.width, x1 + 8, y, 60, 400, 1, function() return db.width end, function(v) db.width = v end)
	y = y - MakeSlider(f, "height", L.height, x1 + 8, y, 10, 40, 1, function() return db.height end, function(v) db.height = v end)
	y = y - MakeSlider(f, "scale", L.scale, x1 + 8, y, 0.5, 2, 0.05, function() return db.scale end, function(v) db.scale = v end)
	y = y - MakeSlider(f, "spacing", L.spacing, x1 + 8, y, 0, 10, 1, function() return db.spacing end, function(v) db.spacing = v end)
	y = y - MakeSlider(f, "iconsize", L.iconSize, x1 + 8, y, 0, 40, 1, function() return db.iconSize end, function(v) db.iconSize = v end)
	y = y - MakeSlider(f, "fontsize", L.fontSize, x1 + 8, y, 8, 24, 1, function() return db.fontSize end, function(v) db.fontSize = v end)

	local ry = -52
	ry = ry - MakeSection(f, L.secColor, x2, ry)
	ry = ry - MakeSlider(f, "red", L.red, x2 + 8, ry, 0, 1, 0.01, function() return db.barColor[1] end, function(v) db.barColor[1] = v end)
	ry = ry - MakeSlider(f, "green", L.green, x2 + 8, ry, 0, 1, 0.01, function() return db.barColor[2] end, function(v) db.barColor[2] = v end)
	ry = ry - MakeSlider(f, "blue", L.blue, x2 + 8, ry, 0, 1, 0.01, function() return db.barColor[3] end, function(v) db.barColor[3] = v end)
	ry = ry - MakeSlider(f, "alpha", L.alpha, x2 + 8, ry, 0, 1, 0.01, function() return db.barColor[4] end, function(v) db.barColor[4] = v end)

	local closeBtn = MakeButton(f, L.close, 0, 0, 120, function() f:Hide() end)
	closeBtn:ClearAllPoints()
	closeBtn:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -28, 16)

	self:RefreshConfigUI()
end

function PAB:RefreshConfigUI()
	for i = 1, #refreshers do
		refreshers[i]()
	end
end

function PAB:ToggleConfig()
	self:CreateConfig()
	if cfg:IsShown() then
		cfg:Hide()
	else
		cfg:Show()
		self:RefreshConfigUI()
	end
end
