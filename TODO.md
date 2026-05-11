
# Todo



## Important / files / backups / safety
- fix goddamn linux kernel rebuilding on pancake

- change username?

- bring back nx-edit-secrets

## Major projects
- separate home-manager from nixos?
	- maybe take inspo from https://github.com/totoroot/dotfiles

- ~~put nixos on strobery~~
	- I abandon this forsaken rasppie :angy:

- convert QMK config to Rust?
	- [blog post](https://about.houqp.me/posts/rusty-c/) from houqp
		- [github](https://github.com/houqp/qmk_firmware/tree/dfe20d75ad93cd7c025c2038d0e7a5838a04c69f/rust)
		- so it seems that he builds the rust into an object file (.o) and then passes it along into the normal qmk building cycle
		- that should be doable with some flake magic

- add nx-refresh-hardware which re-generates hardwareConfiguration and copies it into the repo

- Rework README.md
	- Take inspiration from https://github.com/totoroot/dotfiles
	
- Get familiar with `nix treefmt` and `pre-commit` and integrate it into my templates

### VPS with NixOS
- set up navidrome

- set up CalDav+CarDav
	- Baikal?

- set up mail client
	- roundcube?
	- [ ] clean up the mess thunderbird left behind
	
- auto-build CV pipeline for fun

- personal website
	- transfer all the old tumblr stuff

- make a nix build cache on my "home server" or VPS
	- and add a command to pre-build all of the hosts
	- make sure I can pre-build on my desktop and it will cache it all on the vps? :thinking:
	- might not be necessary, can just remote build using --target-host: [https://nixos.wiki/wiki/Nixos-rebuild](https://nixos.wiki/wiki/Nixos-rebuild)
	
- run `calorieBot` on there



## Other
- this as alternativve for ddterm? [nix-dots/packages/standard/quake-mode.nix at 07ebd162d19581e487df9f9f1bee45ad73c2fa8d · percygt/nix-dots · GitHub](https://github.com/percygt/nix-dots/blob/07ebd162d19581e487df9f9f1bee45ad73c2fa8d/packages/standard/quake-mode.nix)
- do this https://github.com/colemickens/nixcfg/blob/72cabd1433f809d16ff7537cecff8f1f70ebbb0a/mixins/ssh.nix#L40
	- I have since forgotten why I added this item lmao

- [dysk](https://github.com/Canop/dysk)
- make sound when changing audio out
- replace ddterm?
	- kitty? Alacritty?
	- https://github.com/noctuid/tdrop
- setup nicer shortcuts in ddterm
- nixosHardwarePatcher
- separate homeModules from nixosModules
- make it so different hosts can have different nixpkgs versions? so I don't have to rebuild the kernel on my laptop -.-
	- or instead pin the kernel
- smartctl
- gnome stuff
	- [ ] https://www.reddit.com/r/unixporn/s/LEPTpxHkmv
	- [ ] https://extensions.gnome.org/extension/5338/aylurs-widgets/
	- [ ] https://extensions.gnome.org/extension/6580/open-bar/
	- [ ] https://extensions.gnome.org/extension/3724/net-speed-simplified/
	- [x] https://apps.gnome.org/en-GB/Eyedropper/
	- [ ] https://apps.gnome.org/en-GB/Tangram/
	- [x] https://github.com/TheEvilSkeleton/Upscaler
	- [ ] https://extensions.gnome.org/extension/5362/wireguard-vpn-extension/
- hellwal
- [kando](https://kando.menu/)
- [eza](https://github.com/eza-community/eza) for q
- make dconfdiff nicer (with nushell)
	- arg to only display changed stuff
	- arg to pass it through dconf2nix and change the output to be correct
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
- xremap
	- https://github.com/xremap/xremap
	- https://www.reddit.com/r/NixOS/comments/18xnha4/can_someone_who_has_setup_xremap_show_me_their/
- fix location services + weather
- stylix
	- https://github.com/danth/stylix
	- doesn't work for some reason
	- **CAREFUL** is super trigger-happy to replace a bunch of config files, so **NEVER** enable it on everything
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

## Cool wallpapers
- https://github.com/kurealnum/dotfiles/tree/main/wallpapers
