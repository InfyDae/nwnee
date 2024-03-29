# Neverwinter Nights: Enhanced Edition
Scripts meant for use in NWN:EE. I started on this path thanks to Aschent: lead admin of the persistent world [The Dragon's Neck (TDN)](https://www.dragonsneck.com/).

## Systems

### [Subdual PvP](/Systems/Subdual_PvP)

Allows PCs and DMs to subdue PCs instead of killing them. If a subdued PC is attacked enough times, they will die as normal.

Subdued PCs can be healed to remove the effect or they can wait for it to finish.

### [Troll Regeneration](/Systems/Troll_Regeneration_Prevent_Death/_mod_ondamage.nss)

Prevents death to an object unless the appropriate damage type is included in the killing blow. For example: for trolls, acid or fire.

Uses a NWNX module level event that fires on damage dealt. Caution should be used when adding events like this since they will fire often.

### [Colorize Emote Text](/Systems/Colorize_Emote_Text)

Colorizes emotes by looking for the presence of asterisks in PC chat.

### [Resurrect on Death](/Systems/Resurrect_on_Death)

Allows an object to come back to life on death if it passes a Fortitude save based on the damage of the killing blow.

### [Item Name & Description Changers](/Systems/Item_Name_Description_Changers)

Allows a PC to change the name or description of a targeted item. Limited to their own inventory.

### [Spot Looters](/Systems/Spot_Looters/tdn_evt_ondist.nss)

Gives nearby PCs a chance to spot a character whenever they loot something from a container.

### [Disease on Trigger](/Systems/Disease_on_Trigger)

Meant to apply a disease at a fixed interval so long as the PC is within the boundaries of the trigger. For example: a temple dedicated to Talona might affect invading enemies with this.

## Items

### [Ghost Oil](/Items/GhostOil_RemoveInvisibility.nss)

Meant for a throwable that:

- Removes invisibility from creatures in an AoE
- Prevents invisibility from re-ocurring Ghost Oil vulnerable sources

[/Items/GhostOil_VulnerableInvisibilityApply.nss](/Items/GhostOil_VulnerableInvisibilityApply.nss)

### [Spicedust](/Items/Spicedust_Fear_AoE.nss)

Meant for a throwable that:

- Causes a Fear effect in an AoE
