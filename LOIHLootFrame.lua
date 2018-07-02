local ADDON_NAME, private = ...
local L = private.L

local LOIHLootFrame = CreateFrame("Frame", "LOIHLootFrame", UIParent)
UIPanelWindows["LOIHLootFrame"] = { area = "left", pushable = 3, whileDead = 1, xoffset = -16, yoffset = 12 }
tinsert(UISpecialFrames, "LOIHLootFrame")
private.Frame = LOIHLootFrame

LOIHLootFrame:SetWidth(384)
LOIHLootFrame:SetHeight(512)
LOIHLootFrame:SetHitRectInsets(10, 34, 8, 72)
LOIHLootFrame:SetToplevel(true)
LOIHLootFrame:EnableMouse(true)
LOIHLootFrame:SetMovable(true)

LOIHLootFrame:SetScript("OnShow", function(self)
	LOIHLootFrame.TitleText:SetFormattedText("%s %s", ADDON_NAME, private.version)
	private.Frame_UpdateList()
	private.Frame_UpdateButtons()
end)

------------------------------------------------------------------------
--  BACKGROUND TEXTURES

local topLeftIcon = LOIHLootFrame:CreateTexture(nil, "BACKGROUND")
topLeftIcon:SetPoint("TOPLEFT", 7, -6)
topLeftIcon:SetWidth(60)
topLeftIcon:SetHeight(60)
SetPortraitToTexture(topLeftIcon, "Interface\\FriendsFrame\\FriendsFrameScrollIcon")
LOIHLootFrame.TopLeftIcon = topLeftIcon

local topLeft = LOIHLootFrame:CreateTexture(nil, "BORDER")
topLeft:SetPoint("TOPLEFT")
topLeft:SetWidth(256)
topLeft:SetHeight(256)
topLeft:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-General-TopLeft")
LOIHLootFrame.TopLeft = topLeft

local topRight = LOIHLootFrame:CreateTexture(nil, "BORDER")
topRight:SetPoint("TOPRIGHT")
topRight:SetWidth(128)
topRight:SetHeight(256)
topRight:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-General-TopRight")
LOIHLootFrame.BopRight = topRight

local bottomLeft = LOIHLootFrame:CreateTexture(nil, "BORDER")
bottomLeft:SetPoint("BOTTOMLEFT")
bottomLeft:SetWidth(256)
bottomLeft:SetHeight(256)
bottomLeft:SetTexture("Interface\\PaperDollInfoFrame\\SkillFrame-BotLeft")
LOIHLootFrame.BottomLeft = bottomLeft

local bottomRight = LOIHLootFrame:CreateTexture(nil, "BORDER")
bottomRight:SetPoint("BOTTOMRIGHT")
bottomRight:SetWidth(128)
bottomRight:SetHeight(256)
bottomRight:SetTexture("Interface\\PaperDollInfoFrame\\SkillFrame-BotRight")
LOIHLootFrame.BottomRight = bottomRight

local barLeft = LOIHLootFrame:CreateTexture(nil, "ARTWORK")
barLeft:SetPoint("TOPLEFT", 15, -314)
barLeft:SetWidth(256)
barLeft:SetHeight(16)
barLeft:SetTexture("Interface\\ClassTrainerFrame\\UI-ClassTrainer-HorizontalBar")
barLeft:SetTexCoord(0, 1, 0, 0.25)
LOIHLootFrame.BarLeft = barLeft

local barRight = LOIHLootFrame:CreateTexture(nil, "ARTWORK")
barRight:SetPoint("LEFT", barLeft, "RIGHT")
barRight:SetWidth(75)
barRight:SetHeight(16)
barRight:SetTexture("Interface\\ClassTrainerFrame\\UI-ClassTrainer-HorizontalBar")
barRight:SetTexCoord(0, 0.29296875, 0.25, 0.5)
LOIHLootFrame.BarRight = barRight

------------------------------------------------------------------------
--  TITLE TEXT

local title = LOIHLootFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
title:SetPoint("TOP", 0, -17)
LOIHLootFrame.TitleText = title

------------------------------------------------------------------------
--  DRAG REGION

local drag = CreateFrame("Frame", nil, LOIHLootFrame)
drag:SetPoint("TOP", 8, -10)
drag:SetWidth(256)
drag:SetHeight(28)
LOIHLootFrame.DragFrame = drag

drag:SetScript("OnMouseDown", function(self, button)
	if button == "LeftButton" then
		LOIHLootFrame.isMoving = true
		LOIHLootFrame:StartMoving()
		CloseDropDownMenus()
	end
end)

drag:SetScript("OnMouseUp", function(self, button)
	if LOIHLootFrame.isMoving then
		LOIHLootFrame:StopMovingOrSizing()
		LOIHLootFrame:SetUserPlaced(false)
		LOIHLootFrame.isMoving = nil
	end
end)

drag:SetScript("OnHide", function(self)
	if LOIHLootFrame.isMoving then
		LOIHLootFrame:StopMovingOrSizing()
		LOIHLootFrame:SetUserPlaced(false)
		LOIHLootFrame.isMoving = nil
	end
end)

------------------------------------------------------------------------
--  CLOSE X BUTTON

local closeX = CreateFrame("Button", nil, LOIHLootFrame, "UIPanelCloseButton")
closeX:SetPoint("TOPRIGHT", -30, -8)
LOIHLootFrame.CloseButtonX = closeX

------------------------------------------------------------------------
--  MASTER LOOTER BUTTON

local master = CreateFrame("Button", "$parentMasterLooter", LOIHLootFrame, "UIPanelButtonTemplate")
master:SetPoint("BOTTOMRIGHT", -42, 80)
master:SetSize(107, 22)
master:SetNormalFontObject(GameFontNormalSmall)
master:SetHighlightFontObject(GameFontHighlightSmall)
master:SetDisabledFontObject(GameFontDisableSmall)
master:SetScript("OnClick", private.Frame_MasterButtonOnClick)
master:SetText(L.BUTTON_MASTER_LOOTER)
LOIHLootFrame.MasterButton = master

------------------------------------------------------------------------
--  NEED BEFORE GREED BUTTON

local need = CreateFrame("Button", "$parentNeedBeforeGreed", LOIHLootFrame, "UIPanelButtonTemplate")
need:SetPoint("BOTTOMRIGHT", master, "BOTTOMLEFT", -2, 0)
need:SetSize(107, 22)
need:SetNormalFontObject(GameFontNormalSmall)
need:SetHighlightFontObject(GameFontHighlightSmall)
need:SetDisabledFontObject(GameFontDisableSmall)
need:SetScript("OnClick", private.Frame_NeedButtonOnClick)
need:SetText(L.BUTTON_NEED_BEFORE_GREED)
LOIHLootFrame.NeedButton = need

------------------------------------------------------------------------
--  PERSONAL BUTTON

local personal = CreateFrame("Button", "$parentPersonal", LOIHLootFrame, "UIPanelButtonTemplate")
personal:SetPoint("BOTTOMLEFT", 17, 80)
personal:SetSize(107, 22)
personal:SetNormalFontObject(GameFontNormalSmall)
personal:SetHighlightFontObject(GameFontHighlightSmall)
personal:SetDisabledFontObject(GameFontDisableSmall)
personal:SetScript("OnClick", private.Frame_PersonalButtonOnClick)
personal:SetText(L.BUTTON_PERSONAL)
LOIHLootFrame.PersonalButton = personal

------------------------------------------------------------------------
--  SYNC BUTTON

local sync = CreateFrame("Button", "$parentSync", LOIHLootFrame, "UIPanelButtonTemplate")
sync:SetPoint("TOPRIGHT", -40, -49)
sync:SetWidth(60)
sync:SetHeight(22)
sync:SetNormalFontObject(GameFontNormalSmall)
sync:SetHighlightFontObject(GameFontHighlightSmall)
sync:SetDisabledFontObject(GameFontDisableSmall)
sync:SetScript("OnClick", private.Frame_SyncButtonOnClick)
sync:SetText(L.BUTTON_SYNC)
LOIHLootFrame.SyncButton = sync

------------------------------------------------------------------------
--  TAB BUTTONS

local function tab_OnShow(self)
	PanelTemplates_TabResize(self, 0)
	_G[self:GetName() .. "HighlightTexture"]:SetWidth(self:GetTextWidth() + 31)
end

local subtitleTab = CreateFrame("Button", "$parentSubTitleTab", LOIHLootFrame, "TabButtonTemplate")
subtitleTab:SetPoint("TOPLEFT", 70, -39)
subtitleTab:SetID(1)
subtitleTab:SetScript("OnShow", tab_OnShow)
subtitleTab:SetText(L.TAB_WISHLIST)
PanelTemplates_SelectTab(subtitleTab)
LOIHLootFrame.SubTitleTab= subtitleTab

------------------------------------------------------------------------
--  LIST FRAME

local listFrame = CreateFrame("Frame", "$parentListFrame", LOIHLootFrame)
listFrame:SetPoint("TOPLEFT", 20, -74)
listFrame:SetWidth(320)
listFrame:SetHeight(240)
LOIHLootFrame.ListFrame = listFrame

------------------------------------------------------------------------
--  LIST SCROLLBAR

local scrollFrame = CreateFrame("ScrollFrame", "$parentScrollFrame", listFrame, "HybridScrollFrameTemplate")
scrollFrame:SetPoint("TOPLEFT", 0, -2)
scrollFrame:SetWidth(296)
scrollFrame:SetHeight(240)
scrollFrame.stepSize = private.LIST_BUTTON_HEIGHT*4
scrollFrame.update = private.Frame_UpdateList
LOIHLootFrame.ScrollFrame = scrollFrame

local scrollBar = CreateFrame("Slider", "$parentScrollBar", scrollFrame, "HybridScrollBarTemplate")
scrollBar:SetPoint("TOPLEFT", scrollFrame, "TOPRIGHT", 4, -13)
scrollBar:SetPoint("BOTTOMLEFT", scrollFrame, "BOTTOMRIGHT", 4, 13)
scrollBar.doNotHide = true
LOIHLootFrame.ScrollBar = scrollBar

------------------------------------------------------------------------
--  LIST BUTTONS

HybridScrollFrame_CreateButtons(scrollFrame, "WishlistTemplate", 2, 0, "TOPLEFT", "TOPLEFT", 0, 2, "TOP", "BOTTOM")

------------------------------------------------------------------------
--  DESCRIPTION FRAME

local description = CreateFrame("Frame", nil, LOIHLootFrame)
description:SetPoint("TOPLEFT", 25, -330)
description:SetWidth(317)
description:SetHeight(76)
LOIHLootFrame.DescriptionFrame = description

------------------------------------------------------------------------
--  TEXT SCROLL FRAME (for non-editable text)

local textScroll = CreateFrame("ScrollFrame", "LOIHLootTextScrollFrame", description)
textScroll:SetPoint("TOPLEFT")
textScroll:SetWidth(306)
textScroll:SetHeight(76)
textScroll:Hide()
textScroll.scrollBarHideable = true
LOIHLootFrame.TextScrollFrame = textScroll

textScroll:SetScript("OnMouseWheel", ScrollFrameTemplate_OnMouseWheel)
textScroll:SetScript("OnVerticalScroll", private.Frame_OnVerticalScroll)
textScroll:SetScript("OnScrollRangeChanged", function(self, xOffset, yOffset)
	-- Scroll range will only change when we put new text into the
	-- textbox, so when this happens we also set the scrollbar
	-- position to zero to show the top of the text always.
	ScrollFrame_OnScrollRangeChanged(self, yOffset)
	LOIHLootFrameTextScrollFrameScrollBar:SetValue(0)
end)

local textBar = CreateFrame("Slider", "$parentScrollBar", textScroll, "UIPanelScrollBarTemplate")
textBar:SetPoint("TOPLEFT", textScroll, "TOPRIGHT", -4, -14)
textBar:SetPoint("BOTTOMLEFT", textScroll, "BOTTOMRIGHT", -4, 14)
LOIHLootFrame.TextScrollFrame.ScrollBar = textBar

ScrollFrame_OnLoad(textScroll)
ScrollFrame_OnScrollRangeChanged(textScroll, 0)

local textChild = CreateFrame("Frame", "$parentScrollChild", textScroll)
textChild:SetPoint("TOPLEFT")
textChild:SetWidth(296)
textChild:SetHeight(76)
textChild:EnableMouse(true)
textScroll:SetScrollChild(textChild)
LOIHLootFrame.TextScrollChild = textChild

local textBox = textChild:CreateFontString(nil, "OVERLAY", "GameFontNormal")
textBox:SetPoint("TOPLEFT", 10, -2)
textBox:SetWidth(286)
textBox:SetHeight(0)
textBox:SetJustifyH("LEFT")
textBox:SetIndentedWordWrap(false)
LOIHLootFrame.TextBox = textBox

------------------------------------------------------------------------
--	Addon

LOIHLootFrame:SetScript("OnEvent", private.OnEvent)

private.OnLoad(LOIHLootFrame)