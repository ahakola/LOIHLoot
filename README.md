![Release](https://github.com/ahakola/LOIHLoot/actions/workflows/release.yml/badge.svg)

# LOIHLoot

Gives players option to create Wishlists from raid drops. For guild officers addon also gives option to synchronize data from all raid members to give them idea what bosses should be focused lootwise for maximum chance of getting upgrades.

---

### Usage
#### Average raider: Filling your wishlist

Remember to fill your character's wishlist at Encounter Journal (Check the Loot-tab for wishlist-buttons). Wishlist-buttons:

* Left checkbox is for Mainspec items.
* Right checkbox is for Offspec items.
* Same item can't be on both Mainspec and Offspec wishlists.
* For vanity items (like mounts and pets) there will be only one box.

Different wishlist-button textures and their meaning:

* Empty box: Item isn't on Wishlist and can be added to Wishlist with a click.
* Yellow checkmark: Item is on Wishlist from this difficulty and can be removed from Wishlist with a click.
* Green arrow: Item is on Wishlist from lower difficulty and can be upgraded to this difficulty with a click.
* Red arrow: Item is on Wishlist from higher difficulty and can be downgraded to this difficulty with a click.

Even though at current version you can see Wishlist-buttons on all EncounterJournal Loot-tabs, only raids are supported by the Sync at the moment.

LOIHLoot should automaticly upgrade to higher difficulty or remove items from your wishlist when you receive them.

**NB:** Sync sends the wishlist data of **items that are EQUAL or LOWER to the CURRENT raid difficulty** (If you are in Heroic raid, your Normal and Heroic items from wishlist gets passed on, but your Mythic items doesn't), so **you should add items to you wishlist at the lowest difficulty level you mostly raid or the items benefit you** if you are raiding on multiple different difficulties at the same time.

#### Leaders: LOIHLoot window

Average raider doesn't have to pay any attention to the LOIHLoot window is (s)he so desires, the window is tool for mostly leaders and it is avalable to normal users to give the system some transparency. Normal users should only worry about filling their wishlists.

Use `/loihloot` or `/lloot` with the following commands:

* `show` - show LOIHLoot window
* `hide` - hide LOIHLoot window
* `reset` - reset current character's wishlist
* `status` - report the status of LOIHLoot
* `savenames` - enable/disable saving player names per boss for LOIHLoot window
* `help` - show this help message ingame

Use the slash command without any additional commands to toggle the LOIHLoot window.

When in raid, the Sync-button becomes avalable for guild officers. When pressing the Sync-button it disables the button for 15 seconds to prevent spam, but everyone in raid should get the same data from one button press.

**NB:** Sync-data includes data of **difficulties EQUAL or LOWER to the CURRENT raid difficulty** (If you are in Heroic raid, data for Normal and Heroic will be shown, but Mythic won't), so **you should resync after difficulty changes** if you are raiding on multiple different difficulties at the same raid or synced before you set the actual difficulty you are going to raid at.

---

### Known issues:

* Open a ticket if you find any

---

### Ran into problem or want to help?

Please drop in your:

* bug reports at https://wow.curseforge.com/projects/loihloot/issues/
* translations at https://wow.curseforge.com/projects/loihloot/localization/
* ideas at my inbox either at Curse.com or Curseforge.com or at the comment section

Your Curse-account can be used to login at Curseforge.

---

### Personal loot vs Group Loot
##### For 8.0 Personal loot is the ONLY loot method for groups
> Said by Ion Hazzikostas (aka "Watcher") in BfA Q&A

### Translations

- German (deDE) by pas06
- Korean (koKR) by netaras
- Traditional Chinese (zhTW) by RainbowUI
