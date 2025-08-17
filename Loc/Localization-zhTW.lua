----------------------------------------------------------------------
--	Traditional Chinese Localization

if GetLocale() ~= "zhTW" then return end
local ADDON_NAME, private = ...

local L = private.L

L = L or {}
--@localization(locale="zhTW", format="lua_additive_table", handle-subnamespaces="concat")@