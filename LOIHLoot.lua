--[[	LOIHLoot
------------------------------------------------------------------------

This addon only tries to give you guesstimate on what loot method benefits your
raid the most. It doesn't take any unbalances in the composition or already
loot saved players into account. With out the real drop chances from Blizzard I
can't give you accurate answer what loot system is the best and even with
correct numbers you'd still have to beat the RNGesus.

------------------------------------------------------------------------

Following text is/has been correct for 6.0-6.1:

Personal loot gives as much loot as Group loot in the long run (calculated
using Binomial probability, assuming same drop chance for all loot methods
until confirmed otherwise by Blizzard). Napkin math supports the theory of,
unless you are min-maxing your raids progress and loot distribution (usually
dps > tanks > healers) or riging the raid composition in favor of you getting
the loot you want (30 person pug raid, and you are the only hunter in the raid
and hoping for weapon to drop), Personal loot is better loot method at the
start of the new raid tier or difficulty when everyone need loot from (almost)
all of the bosses.

This should be accurate while half or more of players in the raid need loot
from the boss and even beyond that point if the raid composition is heavily
unbalanced and stacked players who want same item(s). Unless you are in real
cutting edge raiding guild doing multiple mixed runs before Mythic raids open,
you should at least consider running few first weeks with Personal loot to
maximize the loot potential of your group.

N.B.: You running the raids for few weeks doesn't give you enough data to do
any real statistics with few dozen boss kills compared to hundreds of thousands
to millions of boss kills Blizzard records per week.

------------------------------------------------------------------------

For 6.2 Personal loot WILL yield more loot than Group loot:

- http://eu.battle.net/wow/en/blog/19162236?page=1#1
	"First, rather than treating loot chances independently for each player —
	sometimes yielding only one or even zero items for a group — we’ll use a
	system similar to Group Loot to determine how many items a boss will award
	based on eligible group size. As a result, groups will receive a much more
	predictable number of drops when they defeat a boss. In addition, set items
	will reliably drop in Personal Loot, just like they do in Group Loot today.
	The end result is that groups using Personal Loot will acquire their 2- and
	4-piece set bonuses at around the same time as groups using Group Loot
	acquire theirs.

	We’re also increasing the overall rate of reward for Personal Loot, giving
	players more items overall to offset the fact that Personal Loot rewards
	can’t be distributed among group members. We know that finding that one
	awesome specific trinket to round out your gear set can be difficult with
	Personal Loot, and this should help increase your odds."

- http://us.battle.net/wow/en/forum/topic/17346368401?page=1#20
	"- More items will drop on average for a raid using 6.2 Personal Loot than
	would have dropped using 6.0/6.1 Personal Loot.

	- More items will drop on average for a raid using 6.2 Personal Loot than
	would drop for that raid using any form of Group Loot (Master, Need/Greed,
	etc.)."

You should use Personal loot always unless you are min-maxing progress and loot
distribution, funneling loot to someone or your raid is almost fully geared.

------------------------------------------------------------------------
]]--

local ADDON_NAME, private = ...
LOIHLOOT_GLOBAL_PRIVATE = private
local L = private.L
local cfg, db, LOIHLootFrame

local _G = _G
--local EncounterJournalEncounterFrameInfoLootScrollFrame = _G.EncounterJournalEncounterFrameInfoLootScrollFrame -- Throws error if we try to local scope this before loading EJ
local Ambiguate = Ambiguate
local C_ChatInfo = C_ChatInfo
local C_LootJournal = C_LootJournal
local C_Timer = C_Timer
local ChatFrame3 = ChatFrame3
local CreateFrame = CreateFrame
local date = date
local DEBUG_CHAT_FRAME = DEBUG_CHAT_FRAME
local DEFAULT_CHAT_FRAME = DEFAULT_CHAT_FRAME
local EJ_GetEncounterInfo = EJ_GetEncounterInfo
local EJ_GetEncounterInfoByIndex = EJ_GetEncounterInfoByIndex
local EJ_GetInstanceInfo = EJ_GetInstanceInfo
local format = format
local GAME_VERSION_LABEL = GAME_VERSION_LABEL
local GameTooltip = GameTooltip
local GetAddOnMemoryUsage = GetAddOnMemoryUsage
local GetAddOnMetadata = GetAddOnMetadata
local GetClassInfo = GetClassInfo
local GetContainerItemLink = GetContainerItemLink
local GetContainerNumSlots = GetContainerNumSlots
local GetGuildInfo = GetGuildInfo
local GetInventoryItemLink = GetInventoryItemLink
local GetItemInfo = GetItemInfo
local GetLootMethod = GetLootMethod
local GetNumClasses = GetNumClasses
local GetNumGroupMembers = GetNumGroupMembers
local GetRaidDifficultyID = GetRaidDifficultyID
local gsub = gsub
local GuildControlGetRankFlags = GuildControlGetRankFlags
local GuildControlSetRank = GuildControlSetRank
local HideUIPanel = HideUIPanel
local HIGHLIGHT_FONT_COLOR_CODE = HIGHLIGHT_FONT_COLOR_CODE
local HybridScrollFrame_GetOffset = HybridScrollFrame_GetOffset
local HybridScrollFrame_Update = HybridScrollFrame_Update
local IsAddOnLoaded = IsAddOnLoaded
local IsInRaid = IsInRaid
local IsLoggedIn = IsLoggedIn
local LE_ITEM_QUALITY_EPIC = LE_ITEM_QUALITY_EPIC
local math = math
local NORMAL_FONT_COLOR_CODE = NORMAL_FONT_COLOR_CODE
local NUM_BAG_SLOTS = NUM_BAG_SLOTS
local pairs = pairs
local PLAYER_DIFFICULTY1 = PLAYER_DIFFICULTY1
local PLAYER_DIFFICULTY2 = PLAYER_DIFFICULTY2
local PLAYER_DIFFICULTY6 = PLAYER_DIFFICULTY6
local print = print
local ReloadUI = ReloadUI
local SetLootMethod = SetLootMethod
local ShowUIPanel = ShowUIPanel
local string = string
local strjoin = strjoin
local strmatch = strmatch
local strsplit = strsplit
local strsub = strsub
local table = table
local tinsert = tinsert
local ToggleFrame = ToggleFrame
local tonumber = tonumber
local tostring = tostring
local tostringall = tostringall
local type = type
local UnitClass = UnitClass
local UnitIsGroupLeader = UnitIsGroupLeader
local unpack = unpack
local UpdateAddOnMemoryUsage = UpdateAddOnMemoryUsage
local wipe = wipe


-- Private constants
private.version = GetAddOnMetadata(ADDON_NAME, "Version")
private.description = GetAddOnMetadata(ADDON_NAME, "Notes")
private.LIST_BUTTON_HEIGHT = 23		-- actually 25, but with a y-offset shrinking by 2

--	Local variables
local _latestTier = 946			-- InstanceID of the raid tier you want to be open on start (usually the latest), leave empty for all tiers being collapsed on start.
local _lastSync = "never"		-- Timestamp of the last SyncRequest
local _raidCount = 0			-- Players in raid group
local _syncReplies = 0			-- SyncReplies from raid group
local _syncLock = false			-- Is Sync-button disabled?
local _isLUILoaded = false		-- Is Addon LUI loaded? Who replaces default textures by adding Interface\BUTTONS\ folder with replaced textures to addon?
local SyncTable = {}			-- Sync-data list
local _filteredList = {}		-- Filtered list
local _openHeaders = {}			-- Open headers
local TierSets = {				-- Tier-set setIDs
	-- Tier 19
	[1281] = "DEATHKNIGHT", -- Dreadwyrm Battleplate
	[1282] = "DEMONHUNTER", -- Vestment of Second Sight
	[1283] = "DRUID", -- Garb of the Astral Warden
	[1284] = "HUNTER", -- Eagletalon Battlegear
	[1285] = "MAGE", -- Regalia of Everburning Knowledge
	[1286] = "MONK", -- Vestments of Enveloped Dissonance
	[1287] = "PALADIN", -- Battleplate of the Highlord
	[1288] = "PRIEST", -- Vestments of the Purifier
	[1289] = "ROGUE", -- Doomblade Battlegear
	[1290] = "SHAMAN", -- Regalia of Shackled Elements
	[1291] = "WARLOCK", -- Legacy of Azj'Aqir
	[1292] = "WARRIOR", -- Warplate of the Obsidian Aspect

	-- Tier 20
	[1301] = "DEATHKNIGHT", -- Gravewarden Armaments
	[1302] = "DEMONHUNTER", -- Demonbane Armor
	[1303] = "DRUID", -- Stormheart Raiment
	[1304] = "HUNTER", -- Wildstalker Armor
	[1305] = "MAGE", -- Regalia of the Arcane Tempest
	[1306] = "MONK", -- Xuen's Battlegear
	[1307] = "PALADIN", -- Radiant Lightbringer Armor
	[1308] = "PRIEST", -- Vestments of Blind Absolution
	[1309] = "ROGUE", -- Fanged Slayer's Armor
	[1310] = "SHAMAN", -- Regalia of the Skybreaker
	[1311] = "WARLOCK", -- Diabolic Raiment
	[1312] = "WARRIOR", -- Titanic Onslaught Armor

	-- Tier 21
	[1330] = "DEATHKNIGHT", -- Dreadwake Armor
	[1329] = "DEMONHUNTER", -- Felreaper Vestments
	[1328] = "DRUID", -- Bearmantle Battlegear
	[1327] = "HUNTER", -- Serpentstalker Guise
	[1326] = "MAGE", -- Runebound Regalia
	[1325] = "MONK", -- Chi'Ji's Battlegear
	[1324] = "PALADIN", -- Light's Vanguard Battleplate
	[1323] = "PRIEST", -- Gilded Seraph's Raiment
	[1322] = "ROGUE", -- Regalia of the Dashing Scoundrel
	[1321] = "SHAMAN", -- Garb of Venerated Spirits
	[1320] = "WARLOCK", -- Grim Inquisitor's Regalia
	[1319] = "WARRIOR", -- Juggernaut Battlegear
}
local Raids = {					-- RaidIDs and BossIDs
	-- Legion
	[768] = { -- Emerald Nightmare
		1703, -- Nythendra
		1738, -- Il'gynoth, Heart of Corruption
		1744, -- Elerethe Renferal
		1667, -- Ursoc
		1704, -- Dragons of Nightmare
		1750, -- Cenarius
		1726, -- Xavius
	},

	[861] = { -- Trial of Valor
		1819, -- Odyn
		1830, -- Guarm
		1829, -- Helya
	},

	[786] = { -- The Nighthold
		1706, -- Skorpyron
		1725, -- Chronomatic Anomaly
		1731, -- Trilliax
		1751, -- Spellblade Aluriel
		1762, -- Tichondrius
		1713, -- Krosus
		1761, -- High Botanist Tel'arn
		1732, -- Star Augur Etraeus
		1743, -- Grand Magistrix Elisande
		1737, -- Gul'dan
	},

	[875] = { -- Tomb of Sargeras
		1862, -- Goroth
		1867, -- Demonic Inquisition
		1856, -- Harjatan
		1903, -- Sisters of the Moon
		1861, -- Mistress Sassz'ine
		1896, -- The Desolate Host
		1897, -- Maiden of Vigilance
		1873, -- Fallen Avatar
		1898, -- Kil'jaeden
	},

	[946] = { -- Antorus, the Burning Throne
		1992, -- Garothi Worldbreaker
		1987, -- Felhounds of Sargeras
		1997, -- Antoran High Command
		1985, -- Portal Keeper Hasabel
		2025, -- Eonar the Life-Binder
		2009, -- Imonar the Soulhunter
		2004, -- Kin'garoth
		1983, -- Varimathras
		1986, -- The Coven of Shivarra
		1984, -- Aggramar
		2031, -- Argus the Unmaker
	},

	--[[ WoD
		[477] = { -- Highmaul
			1128, -- Kargath Bladefist
			971, -- The Butcher
			1195, -- Tectus
			1196, -- Brackenspore
			1148, -- Twin Ogron
			1153, -- Ko'ragh
			1197, -- Imperator Mar'gok
		},
		[457] = { -- Blackrock Foundry
			1161, -- Gruul
			1202, -- Oregorger
			1154, -- The Blast Furnace
			1155, -- Hans'gar and Franzok
			1123, -- Flamebender Ka'graz
			1162, -- Kromog
			1122, -- Beastlord Darmac
			1147, -- Operator Thogar
			1203, -- The Iron Maidens
			959, -- Blackhand
		},
		[669] = { -- Hellfire Citadel
			1426, -- Hellfire Assault
			1425, -- Iron Reaver
			1392, -- Kormrok
			1432, -- Hellfire High Council
			1396, -- Kilrogg Deadeye
			1372, -- Gorefiend
			1433, -- Shadow-Lord Iskar
			1427, -- Socrethar the Eternal
			1391, -- Fel Lord Zakuun
			1447, -- Xhul'horac
			1394, -- Tyrant Velhari
			1395, -- Mannoroth
			1438, -- Archimonde
		},
	]]--
}
local itemLinks = {}			-- Store itemLinks for fewer function calls
local bossNames = {}			-- Store raid boss names here for fewer function calls
local defaults = {				-- This table defines the addon's default settings:
	debugmode = false,
	CommType = "RAID",
	lootTreshold = 50,			-- If at least this high percentage of players need loot, recommend Personal loot
	--maxTiersForEssence = 5,		-- Max number of Tier-items and/or Essences before Essences are taken off Wishlist
}

local scantip = CreateFrame("GameTooltip", ADDON_NAME.."ScanningTooltip", nil, "GameTooltipTemplate")
scantip:SetOwner(UIParent, "ANCHOR_NONE")

------------------------------------------------------------------------
--	Local functions
------------------------------------------------------------------------

local function Debug(text, ...)
	if not cfg or not cfg.debugmode then return end

	if text then
		if text:match("%%[dfqsx%d%.]") then
			(DEBUG_CHAT_FRAME or ChatFrame3):AddMessage("|cffff9999"..ADDON_NAME..":|r " .. format(text, ...))
		else
			(DEBUG_CHAT_FRAME or ChatFrame3):AddMessage("|cffff9999"..ADDON_NAME..":|r " .. strjoin(" ", text, tostringall(...)))
		end
	end
end

local function Print(text, ...)
	if text then
		if text:match("%%[dfqs%d%.]") then
			DEFAULT_CHAT_FRAME:AddMessage("|cffffcc00".. ADDON_NAME ..":|r " .. format(text, ...))
		else
			DEFAULT_CHAT_FRAME:AddMessage("|cffffcc00".. ADDON_NAME ..":|r " .. strjoin(" ", text, tostringall(...)))
		end
	end
end

-- print_r
local function print_r ( t )
	local print_r_cache={}
	local function sub_print_r(t,indent)
		if (print_r_cache[tostring(t)]) then
			print(indent.."*"..tostring(t))
		else
			print_r_cache[tostring(t)]=true
			if (type(t)=="table") then
				for pos,val in pairs(t) do
					if (type(val)=="table") then
						print(indent.."["..pos.."] => "..tostring(t).." {")
						sub_print_r(val,indent..string.rep(" ",string.len(pos)+8))
						print(indent..string.rep(" ",string.len(pos)+6).."}")
						else
						print(indent.."["..pos.."] => "..tostring(val))
					end
				end
			else
				print(indent..tostring(t))
			end
		end
	end
	sub_print_r(t," ")
end

local function initDB(db, defaults) -- This function copies values from one table into another:
	if type(db) ~= "table" then db = {} end
	if type(defaults) ~= "table" then return db end
	for k, v in pairs(defaults) do
		if type(v) == "table" then
			db[k] = initDB(db[k], v)
		elseif type(v) ~= type(db[k]) then
			db[k] = v
		end
	end
	return db
end

local function _CheckLink(link) -- Return itemID and difficultyID from itemLink
	if not link then -- No link given
		return
	elseif itemLinks[link] and itemLinks[link].id ~= nil then -- Check if we have scanned this item already
		return itemLinks[link].id, itemLinks[link].difficulty
	end

	local _, itemID, _, _, _, _, _, _, _, _, _, _, difficultyID = strsplit(":", link)
	itemID = tonumber(itemID)
	difficultyID = tonumber(difficultyID)
	itemLinks[link] = { id = itemID, difficulty = difficultyID } -- Add to table for faster access later

	return itemID, difficultyID
end

local function _IsOfficer() -- Check if Player can speak on Officer chat
	local _, _, playerRank = GetGuildInfo("Player")
	GuildControlSetRank(playerRank + 1)
	local _, _, _, officerChat_Speak = GuildControlGetRankFlags()

	return officerChat_Speak == true
end

local function _TimeStamp() -- Generate timestamps
	local timeTable = date("*t")
	return string.format("%02d:%02d %d.%d.%d", timeTable.hour, timeTable.min, timeTable.day, timeTable.month, timeTable.year)
end

local function _WishlistOnEnter(self, ...) -- EJ Wishlist-buttons OnEnter-script
	local itemID, difficultyID = _CheckLink(self:GetParent().link)

	if db[itemID] and db[itemID].difficulty == difficultyID then -- Remove
		self.tooltipText = string.format("|cffffcc00"..ADDON_NAME.."|r\n%s", L.TOOLTIP_WISHLIST_REM)
	elseif db[itemID] and db[itemID].difficulty > difficultyID then -- Downgrade
		self.tooltipText = string.format("|cffffcc00"..ADDON_NAME.."|r\n%s", L.TOOLTIP_WISHLIST_HIGHER)
	elseif db[itemID] and db[itemID].difficulty < difficultyID then -- Upgrade
		self.tooltipText = string.format("|cffffcc00"..ADDON_NAME.."|r\n%s", L.TOOLTIP_WISHLIST_LOWER)
	else -- Add
		self.tooltipText = string.format("|cffffcc00"..ADDON_NAME.."|r\n%s", L.TOOLTIP_WISHLIST_ADD)
	end

	GameTooltip:SetOwner(self, "ANCHOR_NONE")
	GameTooltip:SetPoint("BOTTOM", self, "TOP", 0, 5)
	GameTooltip:SetText(self.tooltipText, 1, 1, 1)
end

local function _WishlistOnLeave(self, ...) -- EJ Wishlist-buttons OnLeave-script
	GameTooltip:Hide()
end

local function _WishlistOnClick(self, ...) -- EJ Wishlist-buttons OnClick-script
	Debug("Click:", self:GetParent().itemID, self:GetParent().link, self:GetParent().encounterID)

	local itemID, difficultyID = _CheckLink(self:GetParent().link)
	if not (itemID and difficultyID) then return end

	if db[itemID] and db[itemID].difficulty == difficultyID then -- Remove
		Debug("Remove:", itemID, difficultyID)

		db[itemID] = nil
	elseif db[itemID] and db[itemID].difficulty > difficultyID then -- Downgrade
		Debug("Downgrade:", itemID, db[itemID].difficulty, ">", difficultyID)

		db[itemID].difficulty = difficultyID		
	elseif db[itemID] and db[itemID].difficulty < difficultyID then -- Upgrade
		Debug("Upgrade:", itemID, db[itemID].difficulty, "<", difficultyID)

		db[itemID].difficulty = difficultyID
	else -- Add
		Debug("Add:", itemID, difficultyID)

		db[itemID] = { difficulty = difficultyID, encounter = self:GetParent().encounterID }
	end

	_WishlistOnEnter(self, ...)
end

local function _CreateButtons() -- Create small Wishlist-buttons to EJ's loot view
	Debug("Button Factory running")

	local button, indicator
	for i = 1, 8 do
		button = _G["EncounterJournalEncounterFrameInfoLootScrollFrameButton"..i]
		if button and not button.indicator then
			indicator = CreateFrame("Button", button:GetName().."LOIHLoot", button)
			indicator:SetSize(16, 16)
			indicator:SetNormalTexture("Interface\\BUTTONS\\UI-GuildButton-PublicNote-Disabled")
			indicator:SetHighlightTexture("Interface\\BUTTONS\\UI-GuildButton-PublicNote-Up")
			indicator:ClearAllPoints()
			indicator:SetPoint("TOPRIGHT", -5, -5)
			indicator:SetScript("OnClick", _WishlistOnClick)
			indicator:SetScript("OnEnter", _WishlistOnEnter)
			indicator:SetScript("OnLeave", _WishlistOnLeave)

			button.indicator = indicator
		end
	end
	_isLUILoaded = IsAddOnLoaded("LUI")
end

--[[local function _CheckEssence(essenceID, essenceDiff) -- Check if Player has already enough Tier-items
	local tokenCount = 0

	-- Check Backbags
	local bag, slot = 0, 0
	for bag = 0, NUM_BAG_SLOTS do
		for slot = 1, GetContainerNumSlots(bag) do
			local itemID, difficultyID = _CheckLink(GetContainerItemLink(bag, slot))

			if itemID == essenceID and essenceDiff <= difficultyID then -- Essence found
				Debug("Backbags: Essence", itemID)
				tokenCount = tokenCount + 1
			elseif TierItems[itemID] and essenceDiff <= difficultyID then -- Tier-item found
				Debug("Backbags: Tier", itemID)
				tokenCount = tokenCount + 1
			end
		end
	end

	-- Check Equiped
	for i = 1, 10 do -- Head (1), Shoulder (3), Chest (5), Legs (7), Hands (10)
		if i == 1 or i == 3 or i == 5 or i == 7 or i == 10 then
			local itemID, difficultyID = _CheckLink(GetInventoryItemLink("Player", i))

			if TierItems[itemID] and essenceDiff <= difficultyID then -- Tier-item found
				Debug("Equiped: Tier", itemID)
				tokenCount = tokenCount + 1
			end
		end
	end

	return tokenCount
end]]

local function _countTierItems() -- Count how many Tier-items is equipped
	local count = {}
	local setTable = {}
	local itemSets = C_LootJournal.GetFilteredItemSets()
	for i = 1, #itemSets do
		setTable[itemSets[i].setID] = itemSets[i].name
	end

	for i = 1, 15 do -- Skip the shirt (4), mainhand (16), offhand (17) and tabard (18)
		if i ~= 4 then
			local itemLink = GetInventoryItemLink("player", i)
			if itemLink then
				local _, _, _, _, _, _, _, _, itemEquipLoc, _, _, _, _, _, _, itemSetID = GetItemInfo(itemLink)
				if TierSets[itemSetID] == private.playerClass then -- Item is Tier item for player's class
					if not count[itemSetID] then
						count[itemSetID] = {}
					end
					if count[itemSetID][itemEquipLoc] then
						count[itemSetID][itemEquipLoc] = count[itemSetID][itemEquipLoc] + 1
					else
						count[itemSetID][itemEquipLoc] = 1
					end
				end
			end
		end
	end

	local bag, slot = 0, 0
	for bag = 0, NUM_BAG_SLOTS do
		for slot = 1, GetContainerNumSlots(bag) do
			local itemLink = GetContainerItemLink(bag, slot)
			if itemLink then
				local _, _, _, _, _, _, _, _, itemEquipLoc, _, _, _, _, _, _, itemSetID = GetItemInfo(itemLink)
				if TierSets[itemSetID] == private.playerClass then -- Item is Tier item for player's class
					if not count[itemSetID] then
						count[itemSetID] = {}
					end
					if count[itemSetID][itemEquipLoc] then
						count[itemSetID][itemEquipLoc] = count[itemSetID][itemEquipLoc] + 1
					else
						count[itemSetID][itemEquipLoc] = 1
					end
				end
			end
		end
	end

	Print("Tier-count:")
	for itemSetID, data in pairs(count) do
		local setCounter, uniqueCount = 0, 0
		for itemEquipLoc, itemCount in pairs(data) do
			setCounter = setCounter + itemCount
			uniqueCount = uniqueCount + 1
		end

		Print("[%d] %s - %d pc. (%d total)", itemSetID, setTable[itemSetID], uniqueCount, setCounter)
	end
	Print("#End")

	return true -- WIP
end

local _CheckGear, _CheckBags
do -- _CheckGear() - Checks equipment for items on wishlist
	local throttling

	local function DelayedCheck()
		for i = 1, 17 do -- Skip the shirt (4) and tabard (18)
			if i ~= 4 then
				local itemID, difficultyID = _CheckLink(GetInventoryItemLink("Player", i))

				if db[itemID] and db[itemID].difficulty <= difficultyID then -- Item found, remove from wishlist
					Debug("Remove by Equiped:", itemID, difficultyID)

					db[itemID] = nil
				--elseif db[TierItems[itemID]] and db[TierItems[itemID]].difficulty <= difficultyID then -- Tier-item found, remove from wishlist
				--	Debug("Remove Tier by Equiped:", TierItems[itemID], "->", itemID, difficultyID)

				--	db[TierItems[itemID]] = nil
				end
			end
		end

		throttling = nil
	end

	function _CheckGear()
		if not throttling then
			Debug("Check Gear")

			C_Timer.After(0.5, DelayedCheck)
			throttling = true
		end
	end
end

do -- _CheckBags() - Checks inventory for items on wishlist
	local throttling

	local function DelayedCheck()
		local bag, slot = 0, 0
		for bag = 0, NUM_BAG_SLOTS do
			for slot = 1, GetContainerNumSlots(bag) do
				local itemID, difficultyID = _CheckLink(GetContainerItemLink(bag, slot))

				--if Essences[itemID] then -- Essence found, check if we have enough tier already
				--	local essenceCount = _CheckEssence(itemID, difficultyID)

				--	if essenceCount >= cfg.maxTiersForEssence then
				--		Debug("Remove Essence by Bags:", itemID, difficultyID, essenceCount)

				--		db[itemID] = nil
				--	end
				--elseif db[itemID] and db[itemID].difficulty <= difficultyID then -- Item found, remove from wishlist
				if db[itemID] and db[itemID].difficulty <= difficultyID then -- Item found, remove from wishlist
					Debug("Remove by Bags:", itemID, difficultyID)

					db[itemID] = nil
				--elseif db[TierItems[itemID]] and db[TierItems[itemID]].difficulty <= difficultyID then -- Tier-item found, remove from wishlist
				--	Debug("Remove Tier by Bags:", TierItems[itemID], "->", itemID, difficultyID)

				--	db[TierItems[itemID]] = nil
				end
			end
		end

		throttling = nil
	end

	function _CheckBags()
		if not throttling then
			Debug("Check Bags")

			C_Timer.After(0.5, DelayedCheck)
			throttling = true
		end
	end
end

local function _GetBossName(bossID)
	if not bossID then -- No ID given
		return
	elseif bossNames[bossID] and bossNames[bossID] ~= nil then -- Check if we have scanned this boss already
		return bossNames[bossID]
	end

	bossNames[bossID] = EJ_GetEncounterInfo(bossID)

	return bossNames[bossID]
end

local function _SyncLine() -- Form the "Last sync"-line for textelement
	local difficultyName = L.UNKNOWN
	if private.difficultyID == 14 then 	-- Normal Raid
		difficultyName = PLAYER_DIFFICULTY1
	elseif private.difficultyID == 15 then -- Heroic Raid
		difficultyName = PLAYER_DIFFICULTY2
	elseif private.difficultyID == 16 then -- Mythic Raid
		difficultyName = PLAYER_DIFFICULTY6
	end

	if _raidCount == _syncReplies and _raidCount > 0 then
		return string.format(L.SYNC_LINE, difficultyName, _lastSync, _syncReplies, math.max(_raidCount, _syncReplies))
	else
		return string.format(L.SYNC_LINE, difficultyName, _lastSync, _syncReplies, math.max(_raidCount, _syncReplies))
	end
end

local function _SendSyncRequest(difficulty) -- Send SyncRequest to raid
	Debug("> Sending SyncRequest:", difficulty)
	if not difficulty then return end

	C_ChatInfo.SendAddonMessage(ADDON_NAME, "SyncRequest-"..difficulty, cfg.CommType)
end

local function _ProcessReply(sender, data) -- Process received SyncReplies
	Debug("Process SyncReply", sender, data)
	_syncReplies = _syncReplies + 1
	private.Frame_SetDescriptionText(string.format("%s\n\n%s", _SyncLine(), L.SENDING_SYNC))
	if data == "" then return end

	for _, encounter in pairs({ strsplit(":", data) }) do
		if encounter then
			encounter = tonumber(encounter)
			if not SyncTable[encounter] then
				SyncTable[encounter] = 1
			else
				SyncTable[encounter] = SyncTable[encounter] + 1
			end

			Debug("-", encounter, sender)
		end
	end

	if cfg.debugmode then  -- DEBUG
		for k, v in pairs(SyncTable) do
			if k then
				Debug("#", k, v)
			end
		end
	end

	private.FilterList()
	private.Frame_UpdateList()
end

local function _SyncReply(difficulty) -- Send SyncReply
	local function _contains(table, element)
		for _, v in pairs(table) do
			if v == element then
				return true
			end
		end
		return false
	end

	local function EnableButton()
		_syncLock = false
		private.Frame_UpdateButtons()
	end

	if not difficulty then return end
	Debug("> Sending SyncReply", difficulty)

	if not _syncLock then -- Locking Sync-button to prevent spam
		_syncLock = true
		LOIHLootFrame.SyncButton:Disable()
		C_Timer.After(15, EnableButton)
	end

	_lastSync = _TimeStamp()
	_syncReplies = 0
	_raidCount = GetNumGroupMembers()
	wipe(SyncTable)

	LOIHLootFrame.selectedID = nil -- Deselect previous selection since we are going to change the bottom text anyway
	private.Frame_SetDescriptionText(string.format("%s\n\n%s", _SyncLine(), L.SENDING_SYNC))
	private.FilterList()
	private.Frame_UpdateList()

	local data = {}

	for itemID, itemData in pairs(db) do
		if itemData and itemData.difficulty <= tonumber(difficulty) then
			Debug("+", itemData.encounter, itemData.difficulty)
			if not _contains(data, itemData.encounter) then
				tinsert(data, itemData.encounter)
			end
		end
	end

	local reply = strjoin(":", unpack(data))
	Debug("+++", reply, "(".._syncReplies.."/".._raidCount..")")
	C_ChatInfo.SendAddonMessage(ADDON_NAME, "SyncReply-"..(reply or ""), cfg.CommType)
end

local function _Reset() -- Reset Character's wishlist and SyncTable
	_syncReplies = 0
	_raidCount = 0
	wipe(SyncTable)
	wipe(db)
	db = initDB(db)

	_filteredList = {}
	private.FilterList()
	private.Frame_UpdateList()
	LOIHLootFrame.selectedID = nil -- Deselect previous selection since we are going to change the bottom text anyway
	private.Frame_SetDescriptionText(L.PRT_RESET_DONE)

	Print(L.PRT_RESET_DONE)
end

local function HookEJUpdate(self, ...) -- Hook EJ Update for wishlist-buttons
	local button
	for i = 1, 8 do
		button = _G["EncounterJournalEncounterFrameInfoLootScrollFrameButton"..i]

		if button.CanIMogItOverlay then
			button.indicator:SetPoint("TOPRIGHT", -15, -5)
		else
			button.indicator:SetPoint("TOPRIGHT", -5, -5)
		end

		if button.itemID then
			local _, difficultyID = _CheckLink(button.link) -- Update is spammy as hell when Loot-tab is open, but hopefully the itemLinks-table helps
			difficultyID = difficultyID or 0

			if db[button.itemID] and db[button.itemID].difficulty == difficultyID then
				if _isLUILoaded then
					button.indicator:SetNormalTexture("Interface\\PlayerFrame\\Deathknight-Energize-Blood")
					button.indicator:SetHighlightTexture("Interface\\PlayerFrame\\UI-PlayerFrame-Deathknight-Glow")
				else
					button.indicator:SetNormalTexture("Interface\\BUTTONS\\UI-PlusButton-Up")
					button.indicator:SetPushedTexture("Interface\\BUTTONS\\UI-PlusButton-Down")
					button.indicator:SetHighlightTexture("Interface\\BUTTONS\\UI-PlusButton-Up")
				end
			elseif db[button.itemID] and db[button.itemID].difficulty > difficultyID then
				if _isLUILoaded then
					button.indicator:SetNormalTexture("Interface\\PlayerFrame\\Deathknight-Energize-Unholy")
					button.indicator:SetHighlightTexture("Interface\\PlayerFrame\\UI-PlayerFrame-Deathknight-Glow")
				else
					button.indicator:SetNormalTexture("Interface\\BUTTONS\\UI-AttributeButton-Encourage-Up")
					button.indicator:SetPushedTexture("Interface\\BUTTONS\\UI-AttributeButton-Encourage-Down")
					button.indicator:SetHighlightTexture("Interface\\BUTTONS\\UI-AttributeButton-Encourage-Up")
				end
			elseif db[button.itemID] and db[button.itemID].difficulty < difficultyID then
				if _isLUILoaded then
					button.indicator:SetNormalTexture("Interface\\PlayerFrame\\Deathknight-Energize-Frost")
					button.indicator:SetHighlightTexture("Interface\\PlayerFrame\\UI-PlayerFrame-Deathknight-Glow")
				else
					button.indicator:SetNormalTexture("Interface\\BUTTONS\\UI-MinusButton-Up")
					button.indicator:SetPushedTexture("Interface\\BUTTONS\\UI-MinusButton-Down")
					button.indicator:SetHighlightTexture("Interface\\BUTTONS\\UI-MinusButton-Up")
				end
			else
				if _isLUILoaded then
					button.indicator:SetNormalTexture("Interface\\PlayerFrame\\Deathknight-Energize-White")
					button.indicator:SetHighlightTexture("Interface\\PlayerFrame\\UI-PlayerFrame-Deathknight-Glow")
				else
					button.indicator:SetNormalTexture("Interface\\BUTTONS\\UI-MinusButton-Disabled")
					button.indicator:SetPushedTexture("Interface\\BUTTONS\\UI-MinusButton-Down")
					button.indicator:SetHighlightTexture("Interface\\BUTTONS\\UI-MinusButton-Disabled")
				end
			end
		end
	end
end

------------------------------------------------------------------------
--	Initialization functions
------------------------------------------------------------------------

function private:ADDON_LOADED(addon)
	if addon == ADDON_NAME then
		if IsAddOnLoaded("Blizzard_EncounterJournal") then
			LOIHLootFrame:UnregisterEvent("ADDON_LOADED")

			Debug("Blizzard_EncounterJournal pre-loaded")

			_CreateButtons()

			EncounterJournalEncounterFrameInfoLootScrollFrame:HookScript("OnUpdate", HookEJUpdate)
		end

		LOIHLootDB = initDB(LOIHLootDB, defaults)
		LOIHLootCharDB = initDB(LOIHLootCharDB)
		cfg = LOIHLootDB
		db = LOIHLootCharDB

		if IsLoggedIn() then
			private:PLAYER_LOGIN()
		end
	elseif addon == "Blizzard_EncounterJournal" then
		Debug("Blizzard_EncounterJournal loaded")

		if IsAddOnLoaded(ADDON_NAME) then
			LOIHLootFrame:UnregisterEvent("ADDON_LOADED")

			Debug("Blizzard_EncounterJournal post-loaded")
		end

		_CreateButtons()

		EncounterJournalEncounterFrameInfoLootScrollFrame:HookScript("OnUpdate", HookEJUpdate)
	else return end
end

function private:PLAYER_LOGIN()
	LOIHLootFrame:UnregisterEvent("PLAYER_LOGIN")

	local _, playerClass = UnitClass("player")
	private.playerClass = playerClass

	-- Clean up list on login.
	_CheckGear()
	_CheckBags()

	-- Register prefix and  events
	C_ChatInfo.RegisterAddonMessagePrefix(ADDON_NAME)
	LOIHLootFrame:RegisterEvent("CHAT_MSG_ADDON")
	LOIHLootFrame:RegisterEvent("ITEM_PUSH")
	LOIHLootFrame:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
	LOIHLootFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
end

function private:CHAT_MSG_ADDON(prefix, message, channel, sender)
	if channel ~= cfg.CommType or prefix ~= ADDON_NAME then return end

	sender = Ambiguate(sender, "none")

	local command, data = strsplit("-", message)
	if command == "SyncRequest" then
		Debug("< Received SyncRequest:", data)
		_SyncReply(data)
	elseif command == "SyncReply" then
		Debug("< Received SyncReply:", sender, data)
		_ProcessReply(sender, data)
	end
end

function private:ITEM_PUSH()
	-- Fired when an item is pushed onto the "inventory-stack". For instance when you manufacture something with your trade skills or picks something up.
	if IsInRaid() then
		_CheckBags()
	end
end

function private:PLAYER_EQUIPMENT_CHANGED()
	-- This event is fired when the players gear changes.
	if IsInRaid() then
		_CheckGear()
	end
end

function private:GROUP_ROSTER_UPDATE()
	if IsInRaid then -- In Raid so catch all loot method changes.
		LOIHLootFrame:RegisterEvent("PARTY_LOOT_METHOD_CHANGED")
	else -- Not in Raid (anymore), no need to catch loot method changes.
		LOIHLootFrame:UnregisterEvent("PARTY_LOOT_METHOD_CHANGED")
	end
end

function private:PARTY_LOOT_METHOD_CHANGED()
	-- Just to update the highlight locks on the loot method -buttons
	private.Frame_UpdateButtons()
end

------------------------------------------------------------------------
--	LOIHLootFrame UI functions
------------------------------------------------------------------------

function private.Frame_SetDescriptionText(text) -- Set text to bottom element
	LOIHLootFrame.TextScrollFrame:Show()
	LOIHLootFrame.TextBox:SetText(text)
	LOIHLootFrame.TextScrollFrame.ScrollBar:SetValue(0)
	LOIHLootFrame.TextScrollFrame:UpdateScrollChildRect()
end

function private.Frame_UpdateButtons() -- Update button states and highlight locks
	if IsInRaid() and (_IsOfficer or UnitIsGroupLeader("Player")) and not _syncLock then
		LOIHLootFrame.SyncButton:Enable()
	else
		LOIHLootFrame.SyncButton:Disable()
	end

	if IsInRaid() and UnitIsGroupLeader("Player") then
		LOIHLootFrame.MasterButton:Enable()
		LOIHLootFrame.NeedButton:Enable()
		LOIHLootFrame.PersonalButton:Enable()
	else
		LOIHLootFrame.MasterButton:Disable()
		LOIHLootFrame.NeedButton:Disable()
		LOIHLootFrame.PersonalButton:Disable()
	end

	local lootmethod = GetLootMethod()

	if lootmethod then
		if lootmethod == "master" then
			LOIHLootFrame.MasterButton:LockHighlight()
		else
			LOIHLootFrame.MasterButton:UnlockHighlight()
		end

		if lootmethod == "needbeforegreed" then
			LOIHLootFrame.NeedButton:LockHighlight()
		else
			LOIHLootFrame.NeedButton:UnlockHighlight()
		end

		if lootmethod == "personalloot" then
			LOIHLootFrame.PersonalButton:LockHighlight()
		else
			LOIHLootFrame.PersonalButton:UnlockHighlight()
		end
	end
end

function private.FilterList() -- Filter list items
	Debug("FilterList")

	wipe(_filteredList)
	local skipping

	for instanceID, bossIDs in pairs(Raids) do
		local instanceName = EJ_GetInstanceInfo(instanceID)
		skipping = not _openHeaders[instanceName]
		table.insert(_filteredList, instanceName)

		if not skipping then
			for _, encounterID in pairs(bossIDs) do
				table.insert(_filteredList, encounterID)
			end
		end
	end
end

function private.Frame_UpdateList(self, ...) -- Update list
	Debug("Update", ...)

	local scrollFrame = LOIHLootFrame.ScrollFrame
	local offset = HybridScrollFrame_GetOffset(scrollFrame)
	local buttons = scrollFrame.buttons

	for i = 1, #buttons do
		local index = i + offset
		local button = buttons[i]
		button:Hide()
		if index <= #_filteredList then
			button:SetID(index)
			if type(_filteredList[index]) == "string" then
				button.header.text:SetText(_filteredList[index])
				if _openHeaders[_filteredList[index]] then
					button.header.expandIcon:SetTexCoord(0.5625, 1, 0, 0.4375) -- minus sign
				else
					button.header.expandIcon:SetTexCoord(0, 0.4375, 0, 0.4375) -- plus sign
				end
				button.detail:Hide()
				button.header:Show()
			else
				local count = SyncTable[_filteredList[index]] or 0
				local percent = _syncReplies > 0 and math.floor(count/_syncReplies*100+0.5) or 0
				local recommend = percent >= cfg.lootTreshold and L.SHORT_PERSONAL or L.SHORT_GROUP_LOOT
				button.detail.text:SetText(_GetBossName(_filteredList[index]))
				button.detail.count:SetText(string.format("%d%% (%d/%d)", percent, count, _syncReplies))
				button.detail.recommend:SetText(recommend)
				button.header:Hide()
				button.detail:Show()

				if LOIHLootFrame.selectedID == _filteredList[index] then
					button.detail:LockHighlight()
				else
					button.detail:UnlockHighlight()
				end
			end
			button:Show()
		end
	end

	HybridScrollFrame_Update(scrollFrame, private.LIST_BUTTON_HEIGHT*#_filteredList, private.LIST_BUTTON_HEIGHT)
end

function private.HeaderOnClick(self) -- Click Header on list
	Debug("HeaderOnClick", self:GetID(), _filteredList[self:GetID()])

	_openHeaders[_filteredList[self:GetID()]] = not _openHeaders[_filteredList[self:GetID()]]
	private.FilterList()
	private.Frame_UpdateList()
end	

function private.ButtonOnClick(self) -- Click Boss' name on list
	Debug("ButtonOnClick", self:GetID(), _filteredList[self:GetID()])

	local index = _filteredList[self:GetID()]
	if LOIHLootFrame.selectedID ~= index then
		Debug("- selected ID changed:", index)

		local bossName = self.detail.text:GetText() or L.UNKNOWN
		local count = SyncTable[index] or 0
		local percent = _syncReplies > 0 and math.floor(count/_syncReplies*100+0.5) or 0
		local recommend = percent >= cfg.lootTreshold and L.BUTTON_PERSONAL or L.BUTTON_GROUP_LOOT

		private.Frame_SetDescriptionText(string.format(L.LONG_SYNC_LINE, _SyncLine(), bossName, percent, count, _syncReplies, recommend))

		LOIHLootFrame.selectedID = index
		private.Frame_UpdateList()
	end
end

function private.Frame_MasterButtonOnClick(self) -- Set Loot Method to Master Looter
	SetLootMethod("master", "Player")
end

function private.Frame_NeedButtonOnClick(self) -- Set Loot Method to Need Before Greed
	SetLootMethod("needbeforegreed")
end

function private.Frame_PersonalButtonOnClick(self) -- Set Loot Method Personal Loot
	SetLootMethod("personalloot")
end

function private.Frame_SyncButtonOnClick(self) -- Send SyncRequest
	local function EnableButton()
		_syncLock = false
		private.Frame_UpdateButtons()
	end

	private.Frame_SetDescriptionText("%s\n\n%s", _SyncLine(), L.SENDING_SYNC)
	_syncLock = true
	LOIHLootFrame.SyncButton:Disable()
	C_Timer.After(15, EnableButton)

	private.difficultyID = GetRaidDifficultyID()
	_raidCount = GetNumGroupMembers()

	if private.difficultyID == 14 then 	-- Normal Raid
		_SendSyncRequest(3)
	elseif private.difficultyID == 15 then -- Heroic Raid
		_SendSyncRequest(5)
	elseif private.difficultyID == 16 then -- Mythic Raid
		_SendSyncRequest(6)
	else
		Print(L.PRT_UNKOWN_DIFFICULTY)
	end
end

function private.Frame_OnVerticalScroll(self, arg1)
	-- Under some circumstances, when the OnVerticalScroll handler calls the
	-- scrollbar:SetValue function, the scrollbar calls back into the
	-- OnVerticalScroll handler itself, although in this nexted call arg1 is
	-- set to nil and does not call itself further.  As a result though, the
	-- default implementation of the OnVerticalScroll handler in
	-- UIPanelTemplates.lua will sometimes enable the scroll arrow buttons
	-- when it shouldn't.  This code below works around this by getting the
	-- current scrollbar value after passing it arg1 (so arg1 is thereafter
	-- ignored).  It also accommodates rounding errors in the min/max
	-- positions for robustness.  Note that for some reason we cannot use
	-- greater and less than comparisons in the script in the XML file itself,
	-- which is why this is in its own function here.
	local scrollbar = self.ScrollBar
	scrollbar:SetValue(arg1)
	local min, max = scrollbar:GetMinMaxValues()
	local scroll = scrollbar:GetValue()
	if scroll < (min + 0.1) then
		scrollbar.ScrollUpButton:Disable()
	else
		scrollbar.ScrollUpButton:Enable()
	end
	if scroll > (max - 0.1) then
		scrollbar.ScrollDownButton:Disable()
	else
		scrollbar.ScrollDownButton:Enable()
	end
end

------------------------------------------------------------------------
--	OnEvent handler
------------------------------------------------------------------------

function private.OnEvent(self, event, ...)
	return private[event] and private[event](private, ...)
end

------------------------------------------------------------------------
--	OnLoad function
------------------------------------------------------------------------

function private.OnLoad(self)
	-- Record our frame pointer for later
	LOIHLootFrame = self

	-- Register for player events
	LOIHLootFrame:RegisterEvent("ADDON_LOADED")
	LOIHLootFrame:RegisterEvent("PLAYER_LOGIN")

	-- Make sure the newest raid tier is open
	if _latestTier then
		_openHeaders[EJ_GetInstanceInfo(_latestTier)] = true
	end

	-- Fill HybridScrollFrame
	private.FilterList()
end

------------------------------------------------------------------------
--	Slash command function
------------------------------------------------------------------------

SLASH_LOIHLOOT1 = "/loihloot"
SLASH_LOIHLOOT2 = "/lloot"
SLASH_LOIHLOOT3 = private.SLASH_COMMAND

local SlashHandlers = {
	[L.CMD_SHOW] = function()
		ShowUIPanel(LOIHLootFrame)
	end,
	[L.CMD_HIDE] = function()
		HideUIPanel(LOIHLootFrame)
	end,
	[L.CMD_RESET] = function(params)
		if params == "all" then
			wipe(db)
			wipe(cfg)
			db = initDB(db)
			cfg = initDB(cfg, defaults)
			ReloadUI()
		else
			_Reset()
		end
	end,
	[L.CMD_STATUS] = function()
		UpdateAddOnMemoryUsage()
		Print(L.PRT_STATUS, ADDON_NAME, GetAddOnMemoryUsage(ADDON_NAME) + 0.5)
	end,
	[L.CMD_DEBUGON] = function()
		cfg.debugmode = true
		Print(L.PRT_DEBUG_TRUE, ADDON_NAME)
	end,
	[L.CMD_DEBUGOFF] = function()
		cfg.debugmode = false
		Print(L.PRT_DEBUG_FALSE, ADDON_NAME)
	end,
	[L.CMD_DUMP] = function(params) -- 'bossdump' as default, this is hidden command
		if not params or params == "" then
			Print("InstanceID? Try 'EJ_GetInstanceInfo()'")
			return
		end

		Print("Open EJ if you get empty \"table\"!")
		Print("["..params.."]", "=", "{", "-- "..EJ_GetInstanceInfo(tonumber(params)))
		local index = 1

		repeat
			local name, _, encounterID = EJ_GetEncounterInfoByIndex(index, tonumber(params))
			if name then
				Print("   ", encounterID..",", "-- "..name)
				index = index + 1
			end
		until not name

		Print("},")
	end,
	["ct"] = function()
		_countTierItems()
	end,
	["tiers"] = function() -- Extract setIDs of Tier-sets
		local _getClass = function(itemID)
			local classResult
			scantip:SetHyperlink("item:"..itemID)
			for i = 2, scantip:NumLines() do -- Line 1 is always the name so you can skip it.
				local text = _G[ADDON_NAME.."ScanningTooltipTextLeft"..i]:GetText()
				if text and text ~= "" then
					classResult = strmatch(text, gsub("Classes: %s", "%%s", "(.+)"))
					if classResult and classResult ~= "" and classResult ~= nil then
						--Print("%d - %s", i, classResult)

						break
					end
				end
			end

			return classResult and classResult or "UNKNOWN"
		end

		local classTable = {}
		for c = 1, GetNumClasses() do
			local classDisplayName, classTag, classID = GetClassInfo(c)
			classTable[classDisplayName] = classTag
		end

		local tiers = {}
		local itemSets = C_LootJournal.GetFilteredItemSets()
		local tierCount = 0

		--print_r(itemSets)
		--Print("itemSets:", #itemSets)
		for i = 1, #itemSets do
			local setName = itemSets[i].name
			local setID = itemSets[i].setID
			local itemLevel = itemSets[i].itemLevel
			local items = C_LootJournal.GetItemSetItems(itemSets[i].setID)

			--Print("items:", #items)
			for j = 1, #items do
				local itemID = items[j].itemID

				if itemID and itemID > 0 then
					local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, iconFileDataID, itemSellPrice, itemClassID, itemSubClassID, bindType, expacID, itemSetID, isCraftingReagent = GetItemInfo(itemID)
					if itemRarity == LE_ITEM_QUALITY_EPIC and itemLevel >= 875 and not tiers[setID] and not TierSets[setID] then
						local class = classTable[_getClass(itemID)] or "UNKNOWN"
						tiers[setID] = { setName, class }
						tierCount = tierCount + 1
					end
				end
			end
		end

		Print("---")
		for setID, data in pairs(tiers) do
			Print("   ", "["..setID.."]", "=", "\""..data[2].."\",", "-- "..data[1])
		end
		Print("---", tierCount, tierCount == GetNumClasses() and "OK!" or "Error?")
	end,
}

SlashCmdList["LOIHLOOT"] = function(text)
	if not text or text == "" then
		return ToggleFrame(LOIHLootFrame)
	end

	local command, params = strsplit(" ", text, 2)
	if SlashHandlers[command] then
		SlashHandlers[command](params)
	else
		Print(ADDON_NAME.." "..private.version)
		Print(L.CMD_LIST, L.CMD_SHOW, L.CMD_HIDE, L.CMD_RESET, L.CMD_STATUS, L.CMD_HELP)
		for i = 1, #L.HELP_TEXT do
			Print(L.HELP_TEXT[i])
		end
	end
end

------------------------------------------------------------------------
--	Blizzard options panel functions
------------------------------------------------------------------------

do
	local Options = CreateFrame("Frame", "privateOptions", InterfaceOptionsFramePanelContainer)
	Options.name = ADDON_NAME
	private.OptionsPanel = Options
	InterfaceOptions_AddCategory(Options)

	Options:Hide()
	Options:SetScript("OnShow", function(self)
		local Title = self:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
		Title:SetPoint("TOPLEFT", 16, -16)
		Title:SetText(ADDON_NAME)

		local Version = self:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
		Version:SetPoint("BOTTOMLEFT", Title, "BOTTOMRIGHT", 16, 0)
		Version:SetPoint("RIGHT", -24, 0)
		Version:SetJustifyH("RIGHT")
		Version:SetText(GAME_VERSION_LABEL .. ": " .. HIGHLIGHT_FONT_COLOR_CODE .. private.version)

		local SubText = self:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		SubText:SetPoint("TOPLEFT", Title, "BOTTOMLEFT", 0, -8)
		SubText:SetPoint("TOPRIGHT", Version, "BOTTOMRIGHT", 0, -8)
		SubText:SetJustifyH("LEFT")
		SubText:SetText(private.description)

		local helpText = ""
		local slash = private.SLASH_COMMAND or "/loihloot"
		for i = 1, #L.HELP_TEXT do
			local command, description = strmatch(L.HELP_TEXT[i], "%- (%S+) %- (.+)")
			if command and description then
				helpText = format("%s\n\n%s%s %s|r\n%s", helpText, NORMAL_FONT_COLOR_CODE, slash, command, description)
			else
				helpText = helpText .. "\n\n" .. gsub(L.HELP_TEXT[i], " /([^%s,]+)", NORMAL_FONT_COLOR_CODE .. " /%1|r")
			end
		end
		helpText = helpText .. "\n\n\n" .. L.REMINDER
		helpText = strsub(helpText, 3)

		local HelpText = self:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
		HelpText:SetPoint("TOPLEFT", SubText, "BOTTOMLEFT", 0, -24)
		HelpText:SetPoint("BOTTOMRIGHT", -24, 16)
		HelpText:SetJustifyH("LEFT")
		HelpText:SetJustifyV("TOP")
		HelpText:SetText(helpText)

		self:SetScript("OnShow", nil)
	end)
end

-- EOF
