----------------------------------------------------------------------
--	Spannish Localization

if GetLocale() == "esMX" then return end
local ADDON_NAME, private = ...

local L = private.L

L = L or {}
--@localization(locale="esMX", format="lua_additive_table", handle-subnamespaces="concat")@