----------------------------------------------------------------------
--	German Localization

if GetLocale() ~= "deDE" then return end
local ADDON_NAME, private = ...

local L = private.L

L = L or {}
--@localization(locale="deDE", format="lua_additive_table", handle-subnamespaces="concat")@