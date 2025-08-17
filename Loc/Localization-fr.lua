----------------------------------------------------------------------
--	French Localization

if GetLocale() ~= "frFR" then return end
local ADDON_NAME, private = ...

local L = private.L

L = L or {}
--@localization(locale="frFR", format="lua_additive_table", handle-subnamespaces="concat")@