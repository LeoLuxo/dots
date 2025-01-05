<h1 align="center">
	<img src="./.github/assets/nixos-logo.png" width="100px"/>
	<br>
	liliOS
	<br>
	<div align="center">
		<a = href="https://nixos.org">
			<img src="https://img.shields.io/badge/NixOS-unstable-blue.svg?style=for-the-badge&labelColor=1E1E2E&logo=NixOS&logoColor=C6A0F6&color=A5ADCB">
		</a>
		<a href="https://github.com/leoluxo/dots/">
			<img src="https://img.shields.io/github/repo-size/leoluxo/dots?color=A5ADCB&labelColor=1E1E2E&style=for-the-badge&logo=github&logoColor=C6A0F6">
		</a>
		<a>
			<img src="https://img.shields.io/static/v1.svg?style=for-the-badge&label=License&message=CC0&colorA=1E1E2E&colorB=A5ADCB&logo=unlicense&logoColor=C6A0F6&"/>
		</a>
	</div>
</h1>

My NixOS config!

This configuration uses a monolithic flake, and is modular. Uses both Home-Manager and NixOS modules.
It's not made to support multiple users per host however.

## Cool features
- **Multi-host**: Individual hosts (i.e. devices) are defined in `hosts.nix` and `hosts/`.
- **Synced config files**: The perfect middle-ground between declarative configuration and convenience. On rebuild, external config files are synced to this repo in `config/`, overrides are applied, and the merged configuration is synced back. Like this, no need to go all in with a declarative nix config or an application-modified config.
- **Easy ricing**: The config is set up in such a way that anything appearance-related is separated from the rest of the config. Like this it's easy to [rice](https://www.reddit.com/r/unixporn) away to my heart's content, without touching or breaking my regular application config. And when needed, it's easy to switch back to a nice-looking and working rice.
- **Project templates**: You can check out my project/coding templates in `templates/`.

## How can I use this config on my computer?
I have no idea how this config would work as-is on any other computer, and I can't provide generic instructions on how to install or use it.
However, I'm sure a bunch of individual modules, utility functions or other from this code could be useful for others!

## License
Essentially **Public Domain**!

For all I care, use this code for whatever, whenever, wherever.
Frankly I'd be honored if these dotfiles were useful to anyone.
