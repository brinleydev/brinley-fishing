## [FREE] FISHING SYSTEM INSPIRED NOPIXEL 4.0

## 👀 Preview

https://youtu.be/mOkFBrrMW7A

# README

# NPC Dialog Cfg, if you change the bait or rod itm make sure to change them here as well!!!
```lua
{
        name = "Fer' Sherman",
        private = false, 
        text = "This lake's a beauty, isn't she? I spent most of my time out here fishing, it's a great way to relax and pass the time. I've got some spare equipment for sale if you want to give it a try.", 
        domain = "Fishing", 
        ped = "cs_old_man2", 
        scenario = "", 
        police = true, 
        coords = vector4(1303.9150, 4229.0024, 32.9087, 40.4492), 
        options = { 
            {
                label = "Buy Equipment", 
                requiredrep = 0, --required rep to even open the shop
                type = "shop", 
                items = {
                    {
                        name = "fishingrod",
                        description = "Tools",
                        requiredrep = 0,
                        price = 150
                    },
                    {
                        name = "fishbait",
                        description = "Tools",
                        requiredrep = 0,
                        price = 20
                    },
                
                },
                event = "", -- Event triggered
                args = {}
            },
            {
                label = "Sell Fish",
                requiredrep = 0,
                type = "server",
                event = "brinley-fishing:sellFishes",
                args = {} 
            },
            {
                label = "View Leaderboard",
                requiredrep = 0,
                type = "client",
                event = "brinley-fishing:showLeaderboard",
                args = {} 
            },
            {
                label = "Leave conversation",
                requiredrep = 0,
                type = "none",
                event = "",
                args = {} 
            },
        }
    },

```
# Items
```lua


    sturgeon                     = { name = 'sturgeon', label = 'Sturgeon', weight = 2500, type = 'item', image = 'sturgeon.png', unique = true, useable = true, shouldClose = true, combinable = nil, description = 'Sturgeon' },
    whitefish                     = { name = 'whitefish', label = 'Whitefish', weight = 2500, type = 'item', image = 'whitefish.png', unique = true, useable = true, shouldClose = true, combinable = nil, description = 'Whitefish' },
    codfish               = { name = 'codfish', label = 'Codfish', weight = 2500, type = 'item', image = 'codfish.png', unique = true, useable = true, shouldClose = true, combinable = nil, description = 'Cod' },
    mackerel               = { name = 'mackerel', label = 'Mackerel', weight = 2500, type = 'item', image = 'mackerel.png', unique = true, useable = true, shouldClose = true, combinable = nil, description = 'Mackerel' },
    alewife               = { name = 'alewife', label = 'Alewife', weight = 2500, type = 'item', image = 'alewife.png', unique = true, useable = true, shouldClose = true, combinable = nil, description = 'A normal fish Tatses pretty good!' },
    carp               = { name = 'carp', label = 'Carp', weight = 2500, type = 'item', image = 'carp.png', unique = true, useable = true, shouldClose = true, combinable = nil, description = 'A normal fish Tatses pretty good!' },
    catfish               = { name = 'catfish', label = 'Catfish', weight = 2500, type = 'item', image = 'catfish.png', unique = true, useable = true, shouldClose = true, combinable = nil, description = 'A normal fish Tatses pretty good!' },
    whitesucker               = { name = 'whitesucker', label = 'Whitesucker', weight = 2500, type = 'item', image = 'whitesucker.png', unique = true, useable = true, shouldClose = true, combinable = nil, description = 'A normal fish Tatses pretty good!' }, 
    redhorse               = { name = 'redhorse', label = 'Redhorse', weight = 2500, type = 'item', image = 'redhorse.png', unique = true, useable = true, shouldClose = true, combinable = nil, description = 'A normal fish Tatses pretty good!' },
    salmon               = { name = 'salmon', label = 'Salmon', weight = 2500, type = 'item', image = 'salmon.png', unique = true, useable = true, shouldClose = true, combinable = nil, description = 'A normal fish Tatses pretty good!' },
    herring               = { name = 'herring', label = 'Herring', weight = 2500, type = 'item', image = 'herring.png', unique = true, useable = true, shouldClose = true, combinable = nil, description = 'A normal fish Tatses pretty good!' },
    bass               = { name = 'bass', label = 'Bass', weight = 2500, type = 'item', image = 'bass.png', unique = true, useable = true, shouldClose = true, combinable = nil, description = 'A normal fish Tatses pretty good!' },

    fishingtin               = { name = 'fishingtin', label = 'Fishing Tin', weight = 2500, type = 'item', image = 'fishingtin.png', unique = true, useable = true, shouldClose = true, combinable = nil, description = 'Fishing Tin' },
    fishbait                       = {name = 'fishbait',                     label = 'Bait Container',                 weight = 400,         type = 'item',         image = 'fishbait.png',             unique = false,    useable = true,        shouldClose = true,       combinable = nil,   description = 'Fishing bait'}, 
    fishingrod                       = {name = 'fishingrod',                 label = 'Weak Rod',                 weight = 750,         type = 'item',         image = 'fishingrod.png',             unique = false,    useable = true,        shouldClose = true,       combinable = nil,   description = 'A fishing rod for adventures with friends!!'},  

```



## 💻 Discord:
- [DISCORD](https://discord.gg/rMKqYrpn8G)

