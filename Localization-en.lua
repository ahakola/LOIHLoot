----------------------------------------------------------------------
--	English Localization

local ADDON_NAME, private = ...

local L = {}
private.L = L

L.TOOLTIP_WISHLIST_REM = "Remove from wishlist."
L.TOOLTIP_WISHLIST_ADD = "Add to wishlist."
L.TOOLTIP_WISHLIST_HIGHER = "Downgrade to this difficulty.\nAlready on wishlist from higher difficulty."
L.TOOLTIP_WISHLIST_LOWER = "Upgrade to this difficulty.\nAlready on wishlist from lower difficulty."

L.PRT_RESET_DONE = "Character wishlist reseted."
L.PRT_DEBUG_TRUE = "%s debugging is ON." -- ADDON_NAME
L.PRT_DEBUG_FALSE = "%s debugging is OFF." -- ADDON_NAME
L.PRT_STATUS = "%s is using %.0fkB of memory." -- ADDON_NAME, GetAddOnMemoryUsage
L.PRT_UNKOWN_DIFFICULTY = "ERROR - Unknown raid difficulty! Not sending SyncRequest"

L.SYNC_LINE = "Last sync (%s): %s (%d/%d in raid replied)" -- difficultyName, _lastSync, _syncReplies, _raidCount
L.LONG_SYNC_LINE = "%s\n\n%s: %d%% (%d/%d)\nRecommended loot method: %s." -- L.SYNC_LINE, bossName, percent, count, _syncReplies, recommend
L.SENDING_SYNC = "Sending sync request...\nDisabling Sync-button for 15 seconds."
L.UNKNOWN = "Unknown"
L.SHORT_PERSONAL = "P" -- Short for Personal
L.SHORT_GROUP_LOOT = "G" -- Short for Group Loot

L.BUTTON_MASTER_LOOTER = strmatch(LOOT_MASTER_LOOTER, ": ([%a%s]+)")
L.BUTTON_NEED_BEFORE_GREED = strmatch(LOOT_NEED_BEFORE_GREED, ": ([%a%s]+)")
L.BUTTON_PERSONAL = strmatch(LOOT_PERSONAL_LOOT, ": ([%a%s]+)")
L.BUTTON_GROUP_LOOT = strmatch(LOOT_GROUP_LOOT, ": ([%a%s]+)")
L.BUTTON_SYNC = "Sync"
L.TAB_WISHLIST = "Wishlist"

-- private.SLASH_COMMAND
L.CMD_LIST = "/loihloot ( %s | %s | %s | %s | %s )"
L.CMD_SHOW = "show"
L.CMD_HIDE = "hide"
L.CMD_RESET = "reset"
L.CMD_STATUS = "status"
L.CMD_HELP = "help"
L.CMD_DEBUGON = "debugon"
L.CMD_DEBUGOFF = "debugoff"
L.CMD_DUMP = "bossdump"

L.HELP_TEXT = {
	"Use /loihloot or /lloot with the following commands:",
	"   " .. L.CMD_SHOW    .. " - show LOIHLoot window",
	"   " .. L.CMD_HIDE    .. " - hide LOIHLoot window",
	"   " .. L.CMD_RESET    .. " - reset current character's wishlist",
	"   " .. L.CMD_STATUS  .. " - report the status of LOIHLoot",
	"   " .. L.CMD_HELP .. " - show this help message",
	"Use the slash command without any additional commands to toggle the LOIHLoot window.",
}
L.REMINDER = "Remember to fill your character's wishlist at Encounter Journal (Check the Loot-tab for wishlist-buttons)."