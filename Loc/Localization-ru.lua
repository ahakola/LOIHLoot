----------------------------------------------------------------------
--	Russian Localization

if GetLocale() ~= "ruRU" then return end
local ADDON_NAME, private = ...

local L = private.L

L = L or {}
--@localization(locale="ruRU", format="lua_additive_table", handle-subnamespaces="concat")@