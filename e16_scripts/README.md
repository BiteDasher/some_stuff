# E16 scripts
Okay, so, I wrote these scripts for myself and I need to use them for several use cases:
1. Keyboard shortcuts
2. Startup scripts

For shortcuts, install `e16keyedit`, next create new keybind. \
Check out the sources for more information on how they work. For now, examples: \
`volume-ctl.sh volume + 5` : will increase the volume by 5% \
`volume-ctl.sh volume + 5 notify` : the same thing, but it will also send a notification \
`player-ctl.sh play-pause notify` : you get it...

To start `gnome-keyring-daemon` at E16 startup: \
Create `~/.e16/{Init,Start,Stop}` directories and then, put `keyring.sh` to `~/.e16/Init`

To start notification daemon, install `dunst` and move `notifications.sh` to `~/.e16/Start`
