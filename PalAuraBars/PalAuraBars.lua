local PAB = {}
_G.PalAuraBars = PAB

local L = {}
if GetLocale() == "ruRU" then
	L.loaded		= "Загружен. /pa — настройки."
	L.noAura		= "Без ауры"
	L.enable		= "Включить"
	L.groupOnly		= "Только в группе/рейде"
	L.nameColor		= "Цвет ников"
	L.colWhite		= "Белый"
	L.colClass		= "Классовый"
	L.colAura		= "По ауре"
	L.fontShadow	= "Тень шрифта"
	L.secDisplay	= "Отображение"
	L.secSize		= "Размер"
	L.secColor		= "Цвет полоски"
	L.width			= "Ширина"
	L.height		= "Высота"
	L.scale			= "Масштаб"
	L.spacing		= "Отступ"
	L.iconSize		= "Иконка (0 = авто)"
	L.fontSize		= "Размер шрифта"
	L.red			= "Красный"
	L.green			= "Зелёный"
	L.blue			= "Синий"
	L.alpha			= "Прозрачность"
	L.close			= "Закрыть"
	L.resetDone		= "Настройки сброшены."
	L.unlocked		= "Позиция разблокирована — тяните мышью."
	L.lockedMsg		= "Позиция закреплена."
else
	L.loaded		= "Loaded. Type /pa for options."
	L.noAura		= "No aura"
	L.enable		= "Enable"
	L.groupOnly		= "Only in group/raid"
	L.nameColor		= "Name color"
	L.colWhite		= "White"
	L.colClass		= "Class"
	L.colAura		= "By aura"
	L.fontShadow	= "Font shadow"
	L.secDisplay	= "Display"
	L.secSize		= "Size"
	L.secColor		= "Bar color"
	L.width			= "Width"
	L.height		= "Height"
	L.scale			= "Scale"
	L.spacing		= "Spacing"
	L.iconSize		= "Icon (0 = auto)"
	L.fontSize		= "Font size"
	L.red			= "Red"
	L.green			= "Green"
	L.blue			= "Blue"
	L.alpha			= "Alpha"
	L.close			= "Close"
	L.resetDone		= "Settings reset."
	L.unlocked		= "Position unlocked — drag with mouse."
	L.lockedMsg		= "Position locked."
end
PAB.L = L

local SPELL_DEFS = {
	devotion      = { type = "aura", order = 1, defaultIcon = "Interface\\Icons\\Spell_Holy_DevotionAura" },
	retribution   = { type = "aura", order = 2, defaultIcon = "Interface\\Icons\\Spell_Holy_Magnitude" },
	concentration = { type = "aura", order = 3, defaultIcon = "Interface\\Icons\\Spell_Holy_MindSooth" },
	shadow_res    = { type = "aura", order = 4, defaultIcon = "Interface\\Icons\\Spell_Frost_WizardMark" },
	frost_res     = { type = "aura", order = 5, defaultIcon = "Interface\\Icons\\Spell_Frost_FrostResistance" },
	fire_res      = { type = "aura", order = 6, defaultIcon = "Interface\\Icons\\Spell_Fire_SealOfFire" },
	crusader      = { type = "aura", order = 7, defaultIcon = "Interface\\Icons\\Spell_Holy_CrusaderAura" },
	-- печати отключены (пока не нужны):
	-- righteousness = { type = "seal", order = 10 },
	-- justice       = { type = "seal", order = 11 },
	-- light         = { type = "seal", order = 12 },
	-- wisdom        = { type = "seal", order = 13 },
	-- command       = { type = "seal", order = 14 },
	-- blood         = { type = "seal", order = 15 },
	-- martyr        = { type = "seal", order = 16 },
	-- vengeance     = { type = "seal", order = 17 },
	-- corruption    = { type = "seal", order = 18 },
}

local NAME_TO_KEY = {
	["Аура самоотверженности"] = "devotion",
	["Аура воздаяния"] = "retribution",
	["Аура возмездия"] = "retribution",
	["Аура сосредоточенности"] = "concentration",
	["Аура концентрации"] = "concentration",
	["Аура сопротивления тьме"] = "shadow_res",
	["Аура сопротивления магии льда"] = "frost_res",
	["Аура сопротивления магии огня"] = "fire_res",
	["Аура воина Света"] = "crusader",
	["Крестоносный поход"] = "crusader",
	["Devotion Aura"] = "devotion",
	["Retribution Aura"] = "retribution",
	["Concentration Aura"] = "concentration",
	["Shadow Resistance Aura"] = "shadow_res",
	["Frost Resistance Aura"] = "frost_res",
	["Fire Resistance Aura"] = "fire_res",
	["Crusader Aura"] = "crusader",

	-- печати отключены:
	-- ["Печать праведности"] = "righteousness",
	-- ["Печать справедливости"] = "justice",
	-- ["Печать света"] = "light",
	-- ["Печать мудрости"] = "wisdom",
	-- ["Печать повеления"] = "command",
	-- ["Печать крови"] = "blood",
	-- ["Печать мученика"] = "martyr",
	-- ["Печать мести"] = "vengeance",
	-- ["Печать порчи"] = "corruption",
	-- ["Seal of Righteousness"] = "righteousness",
	-- ["Seal of Justice"] = "justice",
	-- ["Seal of Light"] = "light",
	-- ["Seal of Wisdom"] = "wisdom",
	-- ["Seal of Command"] = "command",
	-- ["Seal of Blood"] = "blood",
	-- ["Seal of the Martyr"] = "martyr",
	-- ["Seal of Vengeance"] = "vengeance",
	-- ["Seal of Corruption"] = "corruption",
}

local SPELL_ID_TO_KEY = {
	[465] = "devotion", [643] = "devotion", [10290] = "devotion", [10291] = "devotion",
	[10292] = "devotion", [10293] = "devotion", [1032] = "devotion", [27149] = "devotion",
	[48941] = "devotion", [48942] = "devotion",

	[7294] = "retribution", [8990] = "retribution", [10298] = "retribution", [10299] = "retribution",
	[10300] = "retribution", [10301] = "retribution", [27150] = "retribution", [54043] = "retribution",

	[19746] = "concentration",

	[19876] = "shadow_res", [19895] = "shadow_res", [19898] = "shadow_res",
	[27151] = "shadow_res", [48943] = "shadow_res",

	[19888] = "frost_res", [19897] = "frost_res", [19900] = "frost_res",
	[27152] = "frost_res", [48945] = "frost_res",

	[19891] = "fire_res", [19899] = "fire_res", [19903] = "fire_res",
	[27153] = "fire_res", [48947] = "fire_res",

	[32223] = "crusader",
}

local FALLBACK_RULES = {
	{ key = "devotion",      ru = { "самоотверж" },         en = "devotion" },
	{ key = "retribution",   ru = { "воздаян", "возмезд" }, en = "retribution" },
	{ key = "concentration", ru = { "сосредоточен", "концентрац" }, en = "concentration" },
	{ key = "shadow_res",    ru = { "тьм" },                en = "shadow" },
	{ key = "frost_res",     ru = { "льд", "ледя" },        en = "frost" },
	{ key = "fire_res",      ru = { "огн" },                en = "fire" },
	{ key = "crusader",      ru = { "воина света", "крестоносн" }, en = "crusader" },
	-- печати отключены:
	-- { key = "righteousness", ru = { "праведн" },            en = "righteousness" },
	-- { key = "justice",       ru = { "справедл" },           en = "justice" },
	-- { key = "light",         ru = { "свет" },               en = "of light" },
	-- { key = "wisdom",        ru = { "мудрост" },            en = "wisdom" },
	-- { key = "command",       ru = { "повелен" },            en = "command" },
	-- { key = "blood",         ru = { "кров" },               en = "blood" },
	-- { key = "martyr",        ru = { "мученик" },            en = "martyr" },
	-- { key = "vengeance",     ru = { "мест" },               en = "vengeance" },
	-- { key = "corruption",    ru = { "порч" },               en = "corruption" },
}

local function MatchList(list, s)
	if type(list) == "table" then
		for _, p in ipairs(list) do
			if s:find(p, 1, true) then return true end
		end
	else
		return s:find(list, 1, true)
	end
	return false
end

local function ClassifyAuraName(name)
	local lname = string.lower(name)
	local isAura = lname:find("aura$") or name:find("^[Аа]ура%s")
	if not isAura then return nil end
	for _, rule in ipairs(FALLBACK_RULES) do
		if MatchList(rule.ru, name) or (rule.en and lname:find(rule.en, 1, true)) then
			return rule.key
		end
	end
	return nil
end

local AURA_COLORS = {
	devotion      = { 0.85, 0.85, 0.85 },
	retribution   = { 1.00, 0.35, 0.35 },
	concentration = { 0.50, 0.70, 1.00 },
	shadow_res    = { 0.65, 0.45, 0.85 },
	frost_res     = { 0.40, 0.80, 1.00 },
	fire_res      = { 1.00, 0.55, 0.25 },
	crusader      = { 1.00, 0.90, 0.40 },
}
-- цвет печатей (отключён вместе с печатями):
-- local SEAL_COLOR = { 1.00, 0.84, 0.00 }

function PAB:GetDefaults()
	return {
		version       = 2,
		enabled       = true,
		category      = "AURAS",
		groupOnly     = false,
		showWithout   = true,
		showIcon      = true,
		nameColor     = "WHITE",
		fontShadow    = true,
		width         = 230,
		height        = 20,
		scale         = 1.0,
		spacing       = 2,
		iconSize      = 0,
		texture       = "Interface\\Buttons\\WHITE8X8",
		barColor      = { 0.10, 0.10, 0.10, 0.70 },
		font          = "Fonts\\FRIZQT__.TTF",
		fontSize      = 12,
		fontOutline   = "OUTLINE",
		point         = "CENTER",
		relPoint      = "CENTER",
		x             = 0,
		y             = 0,
		strata        = "MEDIUM",
		locked        = true,
		customSpells  = "",
	}
end

local function Print(msg)
	DEFAULT_CHAT_FRAME:AddMessage("|cffFF7D0APalAuraBars|r: " .. tostring(msg))
end
PAB.Print = Print

local function SetSafeFont(fs, path, size, outline)
	local ok = pcall(function() fs:SetFont(path, size, outline) end)
	if not ok then
		pcall(function() fs:SetFont("Fonts\\FRIZQT__.TTF", size, outline) end)
	end
end

function PAB:RebuildCustom()
	if not self.db then return end
	if self._customKeys then
		for _, ckey in ipairs(self._customKeys) do
			SPELL_DEFS[ckey] = nil
			for name, key in pairs(NAME_TO_KEY) do
				if key == ckey then NAME_TO_KEY[name] = nil end
			end
		end
	end
	self._customKeys = {}
	local order = 600
	for idstr in tostring(self.db.customSpells or ""):gmatch("%d+") do
		local id = tonumber(idstr)
		if id then
			local name, _, icon = GetSpellInfo(id)
			if name then
				local ckey = "custom:" .. id
				SPELL_DEFS[ckey] = { type = "custom", order = order, id = id, defaultIcon = icon }
				NAME_TO_KEY[name] = ckey
				self._customKeys[#self._customKeys + 1] = ckey
				order = order + 1
			end
		end
	end
end

function PAB:InitDB()
	local defaults = self:GetDefaults()
	local db = PalAuraBarsDB
	if type(db) ~= "table" then db = {} end
	if type(db.barColor) ~= "table" then db.barColor = defaults.barColor end
	if db.version ~= defaults.version then
		local pt, rp, px, py = db.point, db.relPoint, db.x, db.y
		for k in pairs(db) do
			if k ~= "barColor" then db[k] = nil end
		end
		for k, v in pairs(defaults) do
			if k ~= "barColor" then db[k] = v end
		end
		db.point = pt or defaults.point
		db.relPoint = rp or defaults.relPoint
		db.x = px or defaults.x
		db.y = py or defaults.y
		db.version = defaults.version
	end
	for k, v in pairs(defaults) do
		if db[k] == nil and k ~= "barColor" then db[k] = v end
	end
	if db.category == "SEALS" then db.category = "AURAS" end
	PalAuraBarsDB = db
	self.db = db
	self:RebuildCustom()
end

function PAB:MatchCategory(def)
	if def.type == "custom" then return true end
	local cat = self.db.category
	if cat == "BOTH" then return def.type == "aura" or def.type == "seal" end
	if cat == "SEALS" then return def.type == "seal" end
	return def.type == "aura"
end

function PAB:HasGroup()
	return GetNumRaidMembers() > 0 or GetNumPartyMembers() > 0
end

function PAB:GetPaladinUnits()
	local units = {}
	if GetNumRaidMembers() > 0 then
		for i = 1, GetNumRaidMembers() do
			local unit = "raid" .. i
			local _, class = UnitClass(unit)
			if class == "PALADIN" and UnitIsConnected(unit) then
				units[#units + 1] = unit
			end
		end
	else
		local _, pclass = UnitClass("player")
		if pclass == "PALADIN" then
			units[#units + 1] = "player"
		end
		for i = 1, GetNumPartyMembers() do
			local unit = "party" .. i
			local _, class = UnitClass(unit)
			if class == "PALADIN" and UnitIsConnected(unit) then
				units[#units + 1] = unit
			end
		end
	end
	return units
end

function PAB:ScanUnit(unit, ownOnly)
	local found = {}
	for i = 1, 40 do
		-- 3.3.5a: name, rank, icon, count, duration, debuffType,
		-- expirationTime(7), unitCaster(8), steal(9), consolidate(10), spellId(11)
		local name, _, icon, _, _, _, _, caster, _, _, spellId = UnitBuff(unit, i)
		if not name then break end
		local own = true
		if ownOnly then
			own = caster and (caster == unit or (UnitIsUnit and UnitIsUnit(caster, unit)) or UnitName(caster) == UnitName(unit))
		end
		if own then
			if not icon then
				local _, _, i2 = GetSpellInfo(name)
				icon = i2
			end
			local key = (spellId and SPELL_ID_TO_KEY[spellId]) or NAME_TO_KEY[name] or ClassifyAuraName(name)
			if key then
				local def = SPELL_DEFS[key]
				if def and self:MatchCategory(def) then
					found[#found + 1] = { key = key, def = def, icon = icon, name = name }
				end
			end
		end
	end
	return found
end

local function GetNameColor(db, key, def)
	if db.nameColor == "CLASS" then
		local c = (RAID_CLASS_COLORS and RAID_CLASS_COLORS.PALADIN) or { r = 1, g = 0.5, b = 0.75 }
		return c.r, c.g, c.b
	elseif db.nameColor == "AURA" then
		local c = AURA_COLORS[key]
		-- печати отключены:
		-- if not c and def.type == "seal" then c = SEAL_COLOR end
		if c then return c[1], c[2], c[3] end
		return 1, 1, 1
	end
	return 1, 1, 1
end

function PAB:Collect()
	local db = self.db
	local groups, orderList = {}, {}
	local noAura = {}

	local function GetGroup(key, def, displayName)
		local g = groups[key]
		if not g then
			g = { key = key, def = def, names = {}, displayName = displayName or key }
			groups[key] = g
			orderList[#orderList + 1] = g
		end
		return g
	end

	local units = self:GetPaladinUnits()
	for _, unit in ipairs(units) do
		local unitName = UnitName(unit)
		local found = self:ScanUnit(unit, true)
		if #found == 0 then
			if db.showWithout then
				noAura[#noAura + 1] = unitName
			end
		else
			for _, f in ipairs(found) do
				local g = GetGroup(f.key, f.def, f.name)
				g.names[#g.names + 1] = unitName
				if not g.icon then g.icon = f.icon or (f.def.defaultIcon or nil) end
			end
		end
	end

	table.sort(orderList, function(a, b)
		if #a.names ~= #b.names then return #a.names > #b.names end
		local oa = a.def.order or 999
		local ob = b.def.order or 999
		if oa ~= ob then return oa < ob end
		return a.displayName < b.displayName
	end)

	if #noAura > 0 then
		orderList[#orderList + 1] = {
			key = "__none",
			def = { type = "none", order = 9999 },
			names = noAura,
			displayName = L.noAura,
			icon = nil,
		}
	end

	return orderList
end

function PAB:CreateMain()
	if self.main then return end
	local main = CreateFrame("Frame", "PalAuraBarsFrame", UIParent)
	main:SetClampedToScreen(true)
	main:SetMovable(true)
	main:EnableMouse(false)
	main:RegisterForDrag("LeftButton")
	main:SetScript("OnDragStart", function(f)
		if not PAB.db.locked then f:StartMoving() end
	end)
	main:SetScript("OnDragStop", function(f)
		f:StopMovingOrSizing()
		local point, _, relPoint, x, y = f:GetPoint()
		PAB.db.point = point or "CENTER"
		PAB.db.relPoint = relPoint or "CENTER"
		PAB.db.x = x or 0
		PAB.db.y = y or 0
	end)
	self.main = main
	self.rows = {}
end

function PAB:AcquireRow(index)
	local row = self.rows[index]
	if not row then
		row = CreateFrame("Frame", "PalAuraBarsRow" .. index, self.main)
		row:EnableMouse(true)
		row.bar = row:CreateTexture(nil, "BORDER")
		row.bar:SetAllPoints(row)
		row.icon = row:CreateTexture(nil, "ARTWORK")
		row.name = row:CreateFontString(nil, "OVERLAY")
		row:SetScript("OnEnter", function(f)
			if not f.group then return end
			GameTooltip:SetOwner(f, "ANCHOR_RIGHT")
			GameTooltip:AddLine(f.group.displayName, 1, 1, 1)
			GameTooltip:AddLine(table.concat(f.group.names, ", "), 1, 0.84, 0)
			GameTooltip:Show()
		end)
		row:SetScript("OnLeave", function() GameTooltip:Hide() end)
		self.rows[index] = row
	end
	return row
end

function PAB:ApplyFrameSettings()
	local db = self.db
	local main = self.main
	main:SetScale(db.scale)
	main:SetFrameStrata(db.strata or "MEDIUM")
	if db.locked then
		main:EnableMouse(false)
	else
		main:EnableMouse(true)
	end
	main:ClearAllPoints()
	main:SetPoint(db.point or "CENTER", UIParent, db.relPoint or "CENTER", db.x or 0, db.y or 0)
end

function PAB:Rebuild()
	local db = self.db
	local main = self.main
	if not main then return end

	if not db.enabled or (db.groupOnly and not self:HasGroup()) then
		main:Hide()
		return
	end

	local list = self:Collect()
	if #list == 0 then
		main:Hide()
		return
	end

	local h = db.height
	local spacing = db.spacing
	local w = db.width
	local iconSize = db.iconSize
	if not iconSize or iconSize <= 0 then iconSize = h end
	local showIcon = true
	local fontPath = db.font
	local fontSize = db.fontSize
	local fontOutline = db.fontOutline
	if fontOutline == "NONE" or fontOutline == "" then fontOutline = nil end

	main:SetWidth(w)
	main:SetHeight(#list * (h + spacing) - spacing)
	main:Show()

	for i, group in ipairs(list) do
		local row = self:AcquireRow(i)
		row.group = group
		row:SetHeight(h)
		row:SetWidth(w)
		row:EnableMouse(db.locked)
		row:ClearAllPoints()
		if i == 1 then
			row:SetPoint("TOPLEFT", main, "TOPLEFT", 0, 0)
		else
			row:SetPoint("TOPLEFT", self.rows[i - 1], "BOTTOMLEFT", 0, -spacing)
		end
		row:Show()

		row.bar:SetTexture(db.texture or "Interface\\Buttons\\WHITE8X8")
		local bc = db.barColor
		row.bar:SetVertexColor(bc[1], bc[2], bc[3], bc[4])

		local textOffset = 4
		if showIcon and group.icon then
			row.icon:Show()
			row.icon:SetWidth(iconSize)
			row.icon:SetHeight(iconSize)
			row.icon:ClearAllPoints()
			row.icon:SetPoint("LEFT", row, "LEFT", 2, 0)
			row.icon:SetTexture(group.icon)
			row.icon:SetVertexColor(1, 1, 1, 1)
			textOffset = iconSize + 6
		else
			row.icon:Hide()
		end

		local namesText = table.concat(group.names, ", ")
		SetSafeFont(row.name, fontPath, fontSize, fontOutline)
		if db.fontShadow then
			row.name:SetShadowColor(0, 0, 0, 1)
			row.name:SetShadowOffset(1, -1)
		else
			row.name:SetShadowColor(0, 0, 0, 0)
		end
		row.name:SetJustifyH("LEFT")
		row.name:SetJustifyV("MIDDLE")
		row.name:ClearAllPoints()
		row.name:SetPoint("LEFT", row, "LEFT", textOffset, 0)
		row.name:SetPoint("RIGHT", row, "RIGHT", -4, 0)
		row.name:SetText(namesText)
		local r, g, b = GetNameColor(db, group.key, group.def)
		row.name:SetTextColor(r, g, b, 1)
	end

	for i = #list + 1, #self.rows do
		self.rows[i]:Hide()
		self.rows[i].group = nil
	end
end

function PAB:Refresh()
	if not self.db then return end
	self:ApplyFrameSettings()
	self.dirty = false
	self:Rebuild()
end

function PAB:MarkDirty()
	self.dirty = true
end

function PAB:ResetDB()
	local defaults = self:GetDefaults()
	local db = PalAuraBarsDB
	if type(db) ~= "table" then
		db = {}
		PalAuraBarsDB = db
	end
	for k in pairs(db) do
		db[k] = nil
	end
	for k, v in pairs(defaults) do
		db[k] = v
	end
	self.db = db
	self:RebuildCustom()
end

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
eventFrame:RegisterEvent("PARTY_MEMBERS_CHANGED")
eventFrame:RegisterEvent("RAID_ROSTER_UPDATE")
eventFrame:RegisterEvent("UNIT_AURA")

local elapsedTotal = 0
eventFrame:SetScript("OnUpdate", function(_, el)
	if not PAB.dirty then return end
	elapsedTotal = elapsedTotal + el
	if elapsedTotal < 0.25 then return end
	elapsedTotal = 0
	PAB.dirty = false
	PAB:Rebuild()
end)

eventFrame:SetScript("OnEvent", function(_, event, arg1)
	if event == "ADDON_LOADED" then
		if arg1 ~= "PalAuraBars" then return end
		PAB:InitDB()
		PAB:CreateMain()
		PAB:Refresh()
		Print(L.loaded)
		return
	end
	if not PAB.db then return end
	if event == "UNIT_AURA" then
		PAB:MarkDirty()
		return
	end
	PAB:MarkDirty()
end)

SLASH_PALAURAS1 = "/pa"
SlashCmdList["PALAURAS"] = function(msg)
	msg = tostring(msg or ""):gsub("^%s+", ""):gsub("%s+$", ""):lower()
	if not PAB.db then return end
	if msg == "lock" then
		PAB.db.locked = true
		PAB:Refresh()
		Print(L.lockedMsg)
	elseif msg == "unlock" then
		PAB.db.locked = false
		PAB:Refresh()
		Print(L.unlocked)
	elseif msg == "reset" then
		PAB:ResetDB()
		PAB:Refresh()
		if PAB.RefreshConfigUI then PAB:RefreshConfigUI() end
		Print(L.resetDone)
	else
		PAB:ToggleConfig()
	end
end
