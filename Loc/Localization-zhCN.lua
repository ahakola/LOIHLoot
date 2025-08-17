----------------------------------------------------------------------
--	Simplified Chinese Localization

if GetLocale() ~= "zhCN" then return end
local ADDON_NAME, private = ...

local L = private.L

L = L or {}
--@localization(locale="zhCN", format="lua_additive_table", handle-subnamespaces="concat")@