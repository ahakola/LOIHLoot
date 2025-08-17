----------------------------------------------------------------------
--	Spannish Localization

if GetLocale() == "esES" then return end
local ADDON_NAME, private = ...

local L = private.L

L = L or {}
--@localization(locale="esES", format="lua_additive_table", handle-subnamespaces="concat")@