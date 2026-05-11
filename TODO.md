
# Todo

- bring back nx-edit-secrets

- add nx-refresh-hardware which re-generates hardwareConfiguration and copies it into the repo

- this as alternativve for ddterm? [nix-dots/packages/standard/quake-mode.nix at 07ebd162d19581e487df9f9f1bee45ad73c2fa8d · percygt/nix-dots · GitHub](https://github.com/percygt/nix-dots/blob/07ebd162d19581e487df9f9f1bee45ad73c2fa8d/packages/standard/quake-mode.nix)

## Important / files / backups / safety
- fix goddamn linux kernel rebuilding on pancake

- change username?

## Major projects
- separate home-manager from nixos
- set up the VPS with nixos
- put nixos on strobery

- make a nix build cache on my "home server" or VPS
	- and add a command to pre-build all of the hosts
	- make sure I can pre-build on my desktop and it will cache it all on the vps? :thinking:
	- might not be necessary, can just remote build using --target-host: [https://nixos.wiki/wiki/Nixos-rebuild](https://nixos.wiki/wiki/Nixos-rebuild)
- set up navidrome
- minecraft server

- convert QMK config to Rust
	- [blog post](https://about.houqp.me/posts/rusty-c/) from houqp
		- [github](https://github.com/houqp/qmk_firmware/tree/dfe20d75ad93cd7c025c2038d0e7a5838a04c69f/rust)
		- so it seems that he builds the rust into an object file (.o) and then passes it along into the normal qmk building cycle
		- that should be doable with some flake magic

## Other
- do this https://github.com/colemickens/nixcfg/blob/72cabd1433f809d16ff7537cecff8f1f70ebbb0a/mixins/ssh.nix#L40
	- I have since forgotten why I added this item lmao
- make a list of devices with ips and hostname and syncthing id etc
- [dysk](https://github.com/Canop/dysk)
- make sound when changing audio out
- replace ddterm?
	- kitty? Alacritty?
	- https://github.com/noctuid/tdrop
- setup nicer shortcuts in ddterm
- rename `uniCourses` to `uni`
- rework importantDocs <-> work structure
- nixosHardwarePatcher
- separate homeModules from nixosModules
- make it so different hosts can have different nixpkgs versions? so I don't have to rebuild the kernel on my laptop -.-
	- or instead pin the kernel
- make it so rices don't crash if the synced file isn't defined (ie. app not installed in nix config)
- make vscode theming declarative somehow
- make obsidian theming declarative somehow
- smartctl
- move `fonts.nix` into rices
	- and make sure rices can define which fonts are used by who
		- vscode
		- obsidian
- gnome stuff
	- [ ] https://www.reddit.com/r/unixporn/s/LEPTpxHkmv
	- [ ] https://extensions.gnome.org/extension/5338/aylurs-widgets/
	- [ ] https://extensions.gnome.org/extension/6580/open-bar/
	- [ ] https://extensions.gnome.org/extension/3724/net-speed-simplified/
	- [x] https://apps.gnome.org/en-GB/Eyedropper/
	- [ ] https://apps.gnome.org/en-GB/Tangram/
	- [x] https://github.com/TheEvilSkeleton/Upscaler
	- [ ] https://extensions.gnome.org/extension/5362/wireguard-vpn-extension/
- fix small cursor in vscode and steam
- hellwal
- [kando](https://kando.menu/)
- [eza](https://github.com/eza-community/eza) for q
- make dconfdiff nicer (with nushell)
	- arg to only display changed stuff
	- arg to pass it through dconf2nix and change the output to be correct
- fix up the rest of my stuff on github with flakes
- vscode fix integrated console
	- ctrl-c
	- sudo
- steam stuff
	- fix cursor?
	- adwaita theming
- fix plymouth on desktop
- disable middle click paste (more)
- fix deepl desktop
- fix/download local copy of catpuccin gtk
- firefox
	- extensions
	- settings
- try zen browser?
- show week numbers in gnome calendar
- xremap
	- https://github.com/xremap/xremap
	- https://www.reddit.com/r/NixOS/comments/18xnha4/can_someone_who_has_setup_xremap_show_me_their/
- fix location services + weather
- stylix
	- https://github.com/danth/stylix
	- doesn't work for some reason
- rofi
	- wayland fork?
	- or wofi?
	- or fuzzel?
	- https://www.reddit.com/r/linuxquestions/comments/11a0xtz/using_clipman_with_fuzzelunsupported_tool_error/
	- [cliphist](https://github.com/sentriz/cliphist?tab=readme-ov-file)
	- [bitwarden integration](https://github.com/mattydebie/bitwarden-rofi)
		- [fork](https://github.com/pltanton/bitwarden-dmenu)
- nushell
- wireguard

----

## Wallpapers
- https://github.com/kurealnum/dotfiles/tree/main/wallpapers

## Ricing
- https://github.com/neeeeow/Bluecurve
- https://www.reddit.com/r/unixporn/s/27t0qYAybA
- https://www.reddit.com/r/unixporn/s/x0d0dSespF
- https://www.reddit.com/r/unixporn/s/2DAdY2Pugd
- https://www.reddit.com/r/unixporn/s/LmN3uaxMSQ
- https://www.reddit.com/r/unixporn/s/ogvh9MTxTF
- https://www.reddit.com/r/unixporn/s/chss2KHptu
- https://github.com/refact0r/system24

____

## Done
- setup my backups
	[x] add a new restic repo to /stuff/
	[x] add a new restic repo to /backup/
	[x] backup shit to /stuff/ and regularly do [policy-forgets](https://restic.readthedocs.io/en/stable/060_forget.html#removing-snapshots-according-to-a-policy)
	[x] and copy over to the repo in /backup/ periodically
	[x] add phone camera to syncthing and back that up too
	- copy over old backups to new repo
		- [x] minecraft server
		- [x] minecraft instances
		- [x] obsidian
		- [x] important docs
		- [x] uni courses
		- [x] photos
	- setup auto backups
		- [x] stuff folders
		- [x] ludusavi
		- [x] bitwarden (not auto, use command `bitwarden-backup`)
		- [x] photos
- make secrets sudo-protected and move it secrets instead of nx
- email client
- start building up the presets
- ~~flakelight~~ replaced by re-structuring myself
	- flakelight-rust
		- fork to make sure crane reads rust-toolchain.toml
	- make flakelight-typst
	- rework templates to use flakelight
- [x] clean up mkSyncedPath
	- [x] sync .config/monitors.xml
	- [ ] sync ~/.config/guitarix/banks/
- in `q`, automatically ask for sudo if needed
- ~~use treefmt to format everything~~ nix fmt with flakelight
- fix ollama / local llm
	- ~~AI in vscode~~ copilot
- turn everything into nixos modules
	- rework the find-files function
	- should have namespace input depending on where the module is in the hierarchy
	- and define config and options relative to that
	- also make most of the functions like mkGlobalKeybind etc into modules+options
- fix phone syncthing
- change everything to camelCase instead of PascalCase
- fix hibernation issue on desktop
- fix boot-windows
- `qq` command that auto cd's into the last q'ed directory
- fix syncthing versioning
- make my repo look like [this](https://github.com/maotseantonio/NixOS-Hyprland)
- clean up the ,, and please command definitions
- setup project templates/flakes
	- rust
	- coq
		- iris
	- python
	- typst
	- pandoc
- fix typst flake date
- [nix-init](https://github.com/nix-community/nix-init)
- [nurl](https://github.com/nix-community/nurl)
- [gnome bluetooth quick connect](https://extensions.gnome.org/extension/1401/bluetooth-quick-connect/)
- disable unused gnome apps
- additional default gnome apps
- a way to see assigned gnome shortcuts
- ~~wezterm~~ am happy with ddterm, don't need
- ~~goldwarden~~ meh
- youtube music
- ohmyposh
- burn my windows
- somehow prevent discord from changing mic volume
	- pavucontrol seems to do it for reason
- remove plop sound on volume osd
	- disabled system sounds altogether
- ~~fix night light~~
	- for night light to work, a color profile for the screen has to be setup
	- in gnome settings, color tab
	- which is managed via `colormgr` (no idea how to do it declaratively)
	- by default when installing NixOS this should be automatically setup
- [disable gnome poweroff confirmation](https://askubuntu.com/questions/1272300/how-to-disable-shutdown-confirmation-on-ubuntu-20-04)
- remap keyboard
	- danish letters
	- screenshot
	- mute/deafen discord
- fix blur my shell on main screen ([kinda](https://github.com/aunetx/blur-my-shell/issues/68))
- [nh](https://github.com/viperML/nh?tab=readme-ov-file)
- [comma](https://github.com/nix-community/comma)
- disable git dirty tree message
- ~~coq + iris~~ use flake
- simple utilities
	- fuck command
		- `alias fuck = sudo !!`
	- alias q so that it cats files
	- extract command
		- https://www.reddit.com/r/linux/comments/1g8cyrd/comment/lt0nwsp/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
	- `alias size = du --human-readable --summarize`
	- cheat command
		- https://www.reddit.com/r/linux/comments/1g8cyrd/comment/lsxl5sc/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
- add desktop shortcut for syncthing
- debug why my scripts so slow
- dynamic wallpapers
	- static wallpapers
- constant dconf log
- ~~shortcut to disable phone plugin~~ use the quick setting
- ~~setup lutris properly~~ using steamrommanager instead
	- setup [gamescope](https://nixos.wiki/wiki/Steam) where needed
	- alternatives:
		- [cartridges](https://apps.gnome.org/Cartridges/)
		- [es-de](https://es-de.org/)
- setup guitar/music equipment
	- musnix
	- guitarix
		- get a bunch of plugins
	- reaper, other daw?
	- pipewire config
	- reduce delay
- remove all of extraLibs
- rename `roms` to `emu`
