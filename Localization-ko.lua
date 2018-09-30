----------------------------------------------------------------------
--	Korean Localization

if GetLocale() ~= "koKR" then return end
local ADDON_NAME, private = ...

local L = private.L

L = L or {}
--@localization(locale="koKR", format="lua_additive_table", handle-subnamespaces="concat")@