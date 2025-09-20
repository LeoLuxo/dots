<h1 align="center">
	<img src="./.github/assets/nixos-logo.png" width="100px"/>
	<br>
	liliOS
	<br>
	<div align="center">
		<a = href="https://nixos.org">
			<img src="https://img.shields.io/badge/NixOS-25.05-blue.svg?style=for-the-badge&labelColor=1E1E2E&logo=NixOS&logoColor=C6A0F6&color=A5ADCB">
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

## WARNING
This config is currently ongoing a major rewrite. It still works (the rewrite is done continuously as to not make it overwhelmingly complicated), but the codebase is a mess. Inspect/use at your own risk!

## License
Essentially **Public Domain**!

For all I care, use this code for whatever, whenever, wherever.
I'd be honored if these dotfiles were useful to anyone!





```

dots2 on  restructure [✘+] 
❯ nxr
[sudo] password for lili: 
Running as superuser
Files changed:

Running pre-rebuild actions...
Updating wallpaper flake
NixOS Rebuilding...
> Building NixOS configuration
these 26 derivations will be built:
  /nix/store/q9g5nh4p3c9w894008030wmfcbck75da-system-path.drv
  /nix/store/wz1g4c5gjxcln02gasfvzr35awbvdq2y-dbus-1.drv
  /nix/store/4ikqkxq3gg1331iw68bmww9g0ivmlp1b-X-Restart-Triggers-dbus.drv
  /nix/store/v4kmc5w4riqr9zrm87w41wcm8wbdf40n-unit-dbus.service.drv
  /nix/store/1b9i5r3q9zh4n2dysgsi7kjxd9bpjfdz-user-units.drv
  /nix/store/hn84p3iy5pyj15kn7wi5lnrz819xvmdc-set-environment.drv
  /nix/store/4ryq5hy6pp84zq6p7rfw12z1ridwgrmx-etc-fish-nixos-env-preinit.fish.drv
  /nix/store/6x5l6z271f4kzvirhkr9phbvv866gq0s-etc-pam-environment.drv
  /nix/store/89bcjg8g563sjdj1mm5bx9392lm4bs2s-man-paths.drv
  /nix/store/xbjhw4mrdkmyzwxk65v1jkqyrnjnw6n5-man-cache.drv
  /nix/store/d5hz4j6bbb1zp2y9rh1p3x1d99wfc09d-etc-man_db.conf.drv
  /nix/store/fb2fq3nvwmw0fmcr7pp3sly6lcswypks-system_fish-completions.drv
  /nix/store/25b6scv5cfpjkhff48frx0chc9si9djd-X-Restart-Triggers-polkit.drv
  /nix/store/2dzd08ykciidb6g7zj0na914f5a3diyi-unit-polkit.service.drv
  /nix/store/aw87djswdcklrsc7r92zk9rwysch3d4f-unit-dbus.service.drv
  /nix/store/bkyp13mbz2grfzmcjcr9j59r4whkfr8w-unit-accounts-daemon.service.drv
  /nix/store/6jhbqp4mk2izxp0wdy38nvl0kwrb15z3-hm_vencord.json.drv
  /nix/store/6kqcnhdfcf5kwl2vlzbq644a56a7xs3i-hm_vesktop.json.drv
  /nix/store/b4gsa6hlizab282h96wgd82z2vj9l352-hm_settings.cfg.drv
  /nix/store/ijyzld6dvjwks4rvgbhw0bi85axjghhd-home-manager-files.drv
  /nix/store/jrh2vgc2nf1mmsk5r39dmyjv4wvrxlh1-home-manager-generation.drv
  /nix/store/h9fl5ns67fs2wvr647wp0d33qnr730vp-unit-home-manager-lili.service.drv
  /nix/store/p5cqv7kx4hjc71bl1zhymikqyi1m32vr-system-units.drv
  /nix/store/q5pzm1iq5g2z014s28qw90lx2w64hh6w-etc-profile.drv
  /nix/store/0syvqk4h740k8gayhsv8vplb0d2p22rp-etc.drv
  /nix/store/jiqzxxp6h1p0gg0pc5rycj4cb7r5lhdf-nixos-system-coffee-25.05.20250705.29e2900.drv
system-path> building '/nix/store/q9g5nh4p3c9w894008030wmfcbck75da-system-path.drv'
system_fish-completions> building '/nix/store/fb2fq3nvwmw0fmcr7pp3sly6lcswypks-system_fish-completions.drv'
man-paths> building '/nix/store/89bcjg8g563sjdj1mm5bx9392lm4bs2s-man-paths.drv'
hm_settings.cfg> building '/nix/store/b4gsa6hlizab282h96wgd82z2vj9l352-hm_settings.cfg.drv'
hm_vencord.json> building '/nix/store/6jhbqp4mk2izxp0wdy38nvl0kwrb15z3-hm_vencord.json.drv'
hm_vesktop.json> building '/nix/store/6kqcnhdfcf5kwl2vlzbq644a56a7xs3i-hm_vesktop.json.drv'
system_fish-completions> created 454 symlinks in user environment
home-manager-files> building '/nix/store/ijyzld6dvjwks4rvgbhw0bi85axjghhd-home-manager-files.drv'
man-paths> created 5813 symlinks in user environment
man-cache> building '/nix/store/xbjhw4mrdkmyzwxk65v1jkqyrnjnw6n5-man-cache.drv'
home-manager-generation> building '/nix/store/jrh2vgc2nf1mmsk5r39dmyjv4wvrxlh1-home-manager-generation.drv'
unit-home-manager-lili.service> building '/nix/store/h9fl5ns67fs2wvr647wp0d33qnr730vp-unit-home-manager-lili.service.drv'
system-path> created 16934 symlinks in user environment
system-path> gtk-update-icon-cache: Cache file created successfully.
X-Restart-Triggers-polkit> building '/nix/store/25b6scv5cfpjkhff48frx0chc9si9djd-X-Restart-Triggers-polkit.drv'
dbus> building '/nix/store/wz1g4c5gjxcln02gasfvzr35awbvdq2y-dbus-1.drv'
etc-pam-environment> building '/nix/store/6x5l6z271f4kzvirhkr9phbvv866gq0s-etc-pam-environment.drv'
set-environment> building '/nix/store/hn84p3iy5pyj15kn7wi5lnrz819xvmdc-set-environment.drv'
unit-accounts-daemon.service> building '/nix/store/bkyp13mbz2grfzmcjcr9j59r4whkfr8w-unit-accounts-daemon.service.drv'
X-Restart-Triggers-dbus> building '/nix/store/4ikqkxq3gg1331iw68bmww9g0ivmlp1b-X-Restart-Triggers-dbus.drv'
etc-fish-nixos-env-preinit.fish> building '/nix/store/4ryq5hy6pp84zq6p7rfw12z1ridwgrmx-etc-fish-nixos-env-preinit.fish.drv'
etc-profile> building '/nix/store/q5pzm1iq5g2z014s28qw90lx2w64hh6w-etc-profile.drv'
unit-polkit.service> building '/nix/store/2dzd08ykciidb6g7zj0na914f5a3diyi-unit-polkit.service.drv'
unit-dbus.service> building '/nix/store/aw87djswdcklrsc7r92zk9rwysch3d4f-unit-dbus.service.drv'
unit-dbus.service> building '/nix/store/v4kmc5w4riqr9zrm87w41wcm8wbdf40n-unit-dbus.service.drv'
system-units> building '/nix/store/p5cqv7kx4hjc71bl1zhymikqyi1m32vr-system-units.drv'
user-units> building '/nix/store/1b9i5r3q9zh4n2dysgsi7kjxd9bpjfdz-user-units.drv'
etc-man_db.conf> building '/nix/store/d5hz4j6bbb1zp2y9rh1p3x1d99wfc09d-etc-man_db.conf.drv'
etc> building '/nix/store/0syvqk4h740k8gayhsv8vplb0d2p22rp-etc.drv'
nixos-system-coffee-25.05.20250705.29e> building '/nix/store/jiqzxxp6h1p0gg0pc5rycj4cb7r5lhdf-nixos-system-coffee-25.05.20250705.29e2900.drv'
┏━ Dependency Graph:
┃       ┌─ ✔ unit-dbus.service 
┃    ┌─ ✔ user-units 
┃    │           ┌─ ⏵ hm_vesktop.json ⏱ 17s
┃    │           ├─ ⏵ hm_vencord.json ⏱ 17s
┃    │           ├─ ⏵ hm_settings.cfg ⏱ 17s
┃    │        ┌─ ✔ home-manager-files 
┃    │     ┌─ ✔ home-manager-generation 
┃    │  ┌─ ✔ unit-home-manager-lili.service 
┃    │  ├─ ✔ unit-polkit.service 
┃    │  ├─ ✔ unit-dbus.service 
┃    ├─ ✔ system-units 
┃    │  ┌─ ✔ man-cache ⏱ 16s
┃    ├─ ✔ etc-man_db.conf 
┃ ┌─ ✔ etc 
┃ ✔ nixos-system-coffee-25.05.20250705.29e2900 
┣━━━ Builds          
┗━ ∑ ⏵ 3 │ ✔ 23 │ ⏸ 0 │ Finished at 21:05:54 after 42s
> Comparing changes
<<< /run/current-system
>>> /tmp/nh-osWwQyG4/result
Version changes:
[C*]  #01  agenix                                                0.15.0 -> 0.15.0, 0.15.0-fish-completions
[C.]  #02  atkinson-hyperlegible-next                            2.001-unstable-2025-02-21 -> 2.001-unstable-2025-02-21, 2.001-unstable-2025-02-21-fish-completions
[C-]  #03  bitwarden-desktop                                     2025.6.0 -> 2025.6.0, 2025.6.0-fish-completions
[C-]  #04  boot-windows-desktop-icon                             0.0.0 -> 0.0.0, 0.0.0-fish-completions
[D.]  #05  catppuccin-cursors                                    2.0.0-fish-completions, 2.0.0-frappeDark -> 0, 0-fish-completions
[C-]  #06  comma-with-db                                         1.9.0 -> 1.9.0, 1.9.0-fish-completions
[C-]  #07  commit                                                4.3 -> 4.3, 4.3-fish-completions
[C-]  #08  direnv                                                2.36.0 x2 -> 2.36.0, 2.36.0-fish-completions
[C-]  #09  eyedropper                                            2.1.0 -> 2.1.0, 2.1.0-fish-completions
[C-]  #10  file                                                  5.45 x2, 5.45-man -> 5.45 x2, 5.45-fish-completions, 5.45-man
[C-]  #11  firefox                                               140.0.2 -> 140.0.2, 140.0.2-fish-completions
[C-]  #12  gnome-shell-extension-appindicator-support            60 -> 60, 60-fish-completions
[C-]  #13  gnome-shell-extension-bluetooth-quick-connect         53 -> 53, 53-fish-completions
[C-]  #14  gnome-shell-extension-blur-my-shell                   68 -> 68, 68-fish-completions
[C-]  #15  gnome-shell-extension-burn-my-windows                 46 -> 46, 46-fish-completions
[C-]  #16  gnome-shell-extension-clipboard-indicator             68 -> 68, 68-fish-completions
[C-]  #17  gnome-shell-extension-gsconnect                       62 -> 62, 62-fish-completions
[C*]  #18  gnome-shell-extension-just-perfection                 34 -> 34, 34-fish-completions
[C-]  #19  gnome-shell-extension-media-controls                  38 -> 38, 38-fish-completions
[C-]  #20  gnome-shell-extension-removable-drive-menu            67 -> 67, 67-fish-completions
[C-]  #21  gnome-shell-extension-rounded-window-corners-reborn   12 -> 12, 12-fish-completions
[C-]  #22  gnome-shell-extension-system-monitor                  9 -> 9, 9-fish-completions
[C-]  #23  gnome-shell-extension-touchpad-gesture-customization  6 -> 6, 6-fish-completions
[C-]  #24  guitarix                                              0.46.0 -> 0.46.0, 0.46.0-fish-completions
[C-]  #25  hieroglyphic                                          1.1.0 -> 1.1.0, 1.1.0-fish-completions
[C-]  #26  impression                                            3.4.0 -> 3.4.0, 3.4.0-fish-completions
[C-]  #27  joystickwake                                          0.4.2 -> 0.4.2, 0.4.2-fish-completions
[C.]  #28  keep                                                  <none> -> <none> x2
[C.]  #29  libgee                                                0.20.8, 0.20.8-dev -> 0.20.8
[C.]  #30  libuv                                                 1.51.0 x2, 1.51.0-dev -> 1.51.0 x2
[C-]  #31  melonDS                                               1.0rc-unstable-2025-04-09 -> 1.0rc-unstable-2025-04-09, 1.0rc-unstable-2025-04-09-fish-completions
[C.]  #32  nerd-fonts-atkynson-mono                              3.4.0+2.001 -> 3.4.0+2.001, 3.4.0+2.001-fish-completions
[C.]  #33  nerd-fonts-fantasque-sans-mono                        3.4.0+1.8.0 -> 3.4.0+1.8.0, 3.4.0+1.8.0-fish-completions
[C.]  #34  nerd-fonts-fira-code                                  3.4.0+6.2 -> 3.4.0+6.2, 3.4.0+6.2-fish-completions
[C.]  #35  nerd-fonts-jetbrains-mono                             3.4.0+2.304 -> 3.4.0+2.304, 3.4.0+2.304-fish-completions
[C.]  #36  nerd-fonts-mononoki                                   3.4.0+1.6 -> 3.4.0+1.6, 3.4.0+1.6-fish-completions
[C-]  #37  nh                                                    4.1.2 -> 4.1.2, 4.1.2-fish-completions
[C.]  #38  nix.conf                                              <none> -> <none> x2
[C-]  #39  obsidian                                              1.8.10 -> 1.8.10, 1.8.10-fish-completions
[C*]  #40  perl                                                  5.40.0 x2, 5.40.0-env x3, 5.40.0-man -> 5.40.0 x2, 5.40.0-env x4, 5.40.0-man
[C.]  #41  python3.12-dbus-python                                1.4.0, 1.4.0-dev -> 1.4.0
[C.]  #42  qtmultimedia                                          5.15.17, 5.15.17-bin, 6.9.1 -> 6.9.1
[C-]  #43  r2modman                                              3.1.58 -> 3.1.58, 3.1.58-fish-completions
[C-]  #44  rustic                                                0.9.5 -> 0.9.5, 0.9.5-fish-completions
[C-]  #45  ryubing                                               1.2.86 -> 1.2.86, 1.2.86-fish-completions
[C-]  #46  snes9x                                                1.63 -> 1.63, 1.63-fish-completions
[C-]  #47  snes9x-gtk                                            1.63 -> 1.63, 1.63-fish-completions
[C-]  #48  steam-rom-manager                                     2.5.29, 2.5.29-bwrap, 2.5.29-extracted, 2.5.29-fhsenv-profile, 2.5.29-fhsenv-rootfs, 2.5.29-init -> 2.5.29, 2.5.29-bwrap, 2.5.29-extracted, 2.5.29-fhsenv-profile, 2.5.29-fhsenv-rootfs, 2.5.29-fish-completions, 2.5.29-init
[C-]  #49  switcheroo                                            2.2.0 -> 2.2.0, 2.2.0-fish-completions
[C.]  #50  syncthing                                             1.29.5 -> 1.29.5, 1.29.5-fish-completions
[C-]  #51  syncthing-desktop-icon                                0.0.0 -> 0.0.0, 0.0.0-fish-completions
[C-]  #52  textpieces                                            4.2.0 -> 4.2.0, 4.2.0-fish-completions
[C-]  #53  upscaler                                              1.5.2 -> 1.5.2, 1.5.2-fish-completions
[C-]  #54  vesktop                                               1.5.8 -> 1.5.8, 1.5.8-fish-completions
[C-]  #55  video-trimmer                                         25.03 -> 25.03, 25.03-fish-completions
[C-]  #56  warp                                                  0.9.2 -> 0.9.2, 0.9.2-fish-completions
[C-]  #57  yuzu-EA                                               4176, 4176-bwrap, 4176-extracted, 4176-fhsenv-profile, 4176-fhsenv-rootfs, 4176-init -> 4176, 4176-bwrap, 4176-extracted, 4176-fhsenv-profile, 4176-fhsenv-rootfs, 4176-fish-completions, 4176-init
Selection state changes:
[C-]  #01  _qq-internals                       <none>
[C-]  #02  automusic                           <none>
[C-]  #03  beet                                <none>
[C-]  #04  boot-windows                        <none>
[C-]  #05  celluloid                           0.29, 0.29_fish-completions
[C-]  #06  cheat                               <none>
[C-]  #07  extract                             <none>
[C-]  #08  keybind-instant-screenshot          <none>
[C-]  #09  keybind-open-backup-terminal        <none>
[C-]  #10  keybind-open-code-editor            <none>
[C-]  #11  keybind-open-communication          <none>
[C-]  #12  keybind-open-notes                  <none>
[C-]  #13  keybind-open-terminal               <none>
[C-]  #14  keybind-open-web-browser            <none>
[C-]  #15  keybind-toggle-audio-to-headphones  <none>
[C-]  #16  keybind-toggle-audio-to-speakers    <none>
[C-]  #17  nix-init                            0.3.2, 0.3.2_fish-completions
[C-]  #18  nurl                                0.3.13, 0.3.13_fish-completions
[C-]  #19  nx-cleanup                          <none>
[C-]  #20  nx-rebuild                          <none>
[C-]  #21  prismlauncher                       <none>, 9.4
[C-]  #22  q                                   <none>
[C-]  #23  restic                              0.18.0, 0.18.0_fish-completions
[C-]  #24  size                                <none>
[C-]  #25  snip                                <none>
[C-]  #26  sshpass                             1.10, 1.10_fish-completions
[C-]  #27  steam                               <none>
[C-]  #28  wl-clipboard                        2.2.1, 2.2.1_fish-completions
[C-]  #29  zoxide                              0.9.7, 0.9.7_fish-completions
Added packages:
[A.]  #01  _qq-internals-fish-completions                        <none>
[A.]  #02  agenix-home-manager-mount-secrets                     <none>
[A.]  #03  agenix.service                                        <none>
[A.]  #04  automusic-fish-completions                            <none>
[A.]  #05  beet-fish-completions                                 <none>
[A.]  #06  beetsConfig.yaml                                      <none>
[A.]  #07  boot-windows-fish-completions                         <none>
[A.]  #08  catppuccin-fish                                       0-unstable-2025-03-01
[A.]  #09  catppuccin-glamour                                    0-unstable-2025-05-02
[A.]  #10  cheat-fish-completions                                <none>
[A+]  #11  command-not-found                                     <none>
[A.]  #12  dconf-diff                                            <none>
[A.]  #13  dconf-diff-fish-completions                           <none>
[A.]  #14  dconf-diff-no-deps                                    <none>
[A.]  #15  direnv-config                                         <none>
[A.]  #16  dots-todo                                             <none>
[A.]  #17  dots-todo-fish-completions                            <none>
[A.]  #18  dots-todo-no-deps                                     <none>
[A.]  #19  edit-dots                                             <none>
[A.]  #20  edit-dots-fish-completions                            <none>
[A.]  #21  edit-dots-no-deps                                     <none>
[A.]  #22  extract-fish-completions                              <none>
[A.]  #23  hm_.nxpost_rebuild.sh                                 <none>
[A.]  #24  hm_.nxpre_rebuild.sh                                  <none>
[A.]  #25  hm_.vscodeextensions.extensionsimmutable.json         <none>
[A.]  #26  hm_direnvdirenvrc                                     <none>
[A.]  #27  hm_settings.cfg                                       <none>
[A.]  #28  hm_vencord.json                                       <none>
[A.]  #29  hm_vesktop.json                                       <none>
[A.]  #30  kdeconnect.service                                    <none>
[A.]  #31  keybind-instant-screenshot-fish-completions           <none>
[A.]  #32  keybind-open-backup-terminal-fish-completions         <none>
[A.]  #33  keybind-open-code-editor-fish-completions             <none>
[A.]  #34  keybind-open-communication-fish-completions           <none>
[A.]  #35  keybind-open-dots-todo                                <none>
[A.]  #36  keybind-open-dots-todo-fish-completions               <none>
[A.]  #37  keybind-open-edit-dots                                <none>
[A.]  #38  keybind-open-edit-dots-fish-completions               <none>
[A.]  #39  keybind-open-notes-fish-completions                   <none>
[A.]  #40  keybind-open-terminal-fish-completions                <none>
[A.]  #41  keybind-open-web-browser-fish-completions             <none>
[A.]  #42  keybind-toggle-audio-to-headphones-fish-completions   <none>
[A.]  #43  keybind-toggle-audio-to-speakers-fish-completions     <none>
[A.]  #44  mozilla-native-messaging-hosts                        <none>
[A.]  #45  nx-cleanup-fish-completions                           <none>
[A.]  #46  nx-rebuild-fish-completions                           <none>
[A.]  #47  perl5.40.0-DBD-SQLite                                 1.74
[A.]  #48  perl5.40.0-DBI                                        1.644
[A.]  #49  perl5.40.0-String-ShellQuote                          1.04
[A.]  #50  prismlauncher-fish-completions                        <none>
[A.]  #51  q-fish-completions                                    <none>
[A.]  #52  restic-autobackup-emu-failed.service                  <none>
[A.]  #53  restic-autobackup-emu.service                         <none>
[A.]  #54  restic-autobackup-emu.timer                           <none>
[A.]  #55  restic-autobackup-home-failed.service                 <none>
[A.]  #56  restic-autobackup-home.service                        <none>
[A.]  #57  restic-autobackup-home.timer                          <none>
[A.]  #58  restic-autobackup-important-docs-failed.service       <none>
[A.]  #59  restic-autobackup-important-docs.service              <none>
[A.]  #60  restic-autobackup-important-docs.timer                <none>
[A.]  #61  restic-autobackup-minecraft-instances-failed.service  <none>
[A.]  #62  restic-autobackup-minecraft-instances.service         <none>
[A.]  #63  restic-autobackup-minecraft-instances.timer           <none>
[A.]  #64  restic-autobackup-music-failed.service                <none>
[A.]  #65  restic-autobackup-music.service                       <none>
[A.]  #66  restic-autobackup-music.timer                         <none>
[A.]  #67  restic-autobackup-obsidian-failed.service             <none>
[A.]  #68  restic-autobackup-obsidian.service                    <none>
[A.]  #69  restic-autobackup-obsidian.timer                      <none>
[A.]  #70  restic-autobackup-share-failed.service                <none>
[A.]  #71  restic-autobackup-share.service                       <none>
[A.]  #72  restic-autobackup-share.timer                         <none>
[A.]  #73  restic-autobackup-uni-courses-failed.service          <none>
[A.]  #74  restic-autobackup-uni-courses.service                 <none>
[A.]  #75  restic-autobackup-uni-courses.timer                   <none>
[A.]  #76  restic-checks-failed.service                          <none>
[A.]  #77  restic-checks.service                                 <none>
[A.]  #78  restic-checks.timer                                   <none>
[A.]  #79  restic-ludusavi-failed.service                        <none>
[A.]  #80  restic-ludusavi.service                               <none>
[A.]  #81  restic-ludusavi.timer                                 <none>
[A.]  #82  restic-replication-failed.service                     <none>
[A.]  #83  restic-replication.service                            <none>
[A.]  #84  restic-replication.timer                              <none>
[A.]  #85  size-fish-completions                                 <none>
[A.]  #86  snip-fish-completions                                 <none>
[A.]  #87  starship-config                                       <none>
[A.]  #88  steam-fish-completions                                <none>
[A.]  #89  syncthing-init.service                                <none>
[A.]  #90  syncthing.service                                     <none>
[A.]  #91  vscode-extension-catppuccin-catppuccin-vsc-icons      1.24.0
[A.]  #92  vscode-extension-catppuccin-vscode                    <none>
[A.]  #93  vscode-user-settings                                  <none>
[A.]  #94  wallutils-static.service                              <none>
Removed packages:
[R.]  #001  10-catppuccin-forgejo-theme.conf                                <none>
[R.]  #002  10-catppuccin-gitea-theme.conf                                  <none>
[R.]  #003  X-Restart-Triggers-wallutils-static                             <none>
[R.]  #004  catppuccin-gtk                                                  1.0.3, 1.0.3-fish-completions
[R.]  #005  clutter                                                         1.26.4
[R.]  #006  clutter-gtk                                                     1.8.4
[R.]  #007  cogl                                                            1.22.8
[R.]  #008  config.yaml                                                     <none>
[R.]  #009  devs                                                            2DPZ3IR-YH4YGS3-SGEZMRY-PMJNDZ4-3PBAE4D-V3IT5CA-4R4KVB5-MFH2WAL-conf-pre-secrets.json
[R.]  #010  devs-BH4QRX3-AXCRBBK                                            32KWW2A-33XYEMB-CKDONYH-4KLE4QA-NXE5LIX-QB4Q5AN-conf-pre-secrets.json
[R.]  #011  devs-DS5FS25-BYJYFF2-TKBNJ4S                                    6RHZTEK-F4QS4EM-BNOPAPU-ULRHUA7-ORVTNA7-conf-pre-secrets.json
[R.]  #012  direnv.toml                                                     <none>
[R.]  #013  dirs                                                            0nx82-l39nu-conf-pre-secrets.json, 3lrkm-4t7wl-conf-pre-secrets.json, 88xc3-tg0v3-conf-pre-secrets.json
[R.]  #014  dirs-ddre2-cukd9-conf-pre-secrets.json                          <none>
[R.]  #015  dirs-gnaop                                                      121mq-conf-pre-secrets.json
[R.]  #016  dirs-oguzw-svsqp-conf-pre-secrets.json                          <none>
[R.]  #017  dirs-p2ror-eujtw-conf-pre-secrets.json                          <none>
[R.]  #018  dirs-vs5o5-tw8yg-conf-pre-secrets.json                          <none>
[R.]  #019  dirs-ythpr-clgdt-conf-pre-secrets.json                          <none>
[R.]  #020  dirs-zzaui-egygo-conf-pre-secrets.json                          <none>
[R-]  #021  edit-secret                                                     <none>
[R.]  #022  edit-secret-no-deps                                             <none>
[R.]  #023  etc-direnv-direnvrc                                             <none>
[R.]  #024  etc-direnv-lib-zz-user.sh                                       <none>
[R.]  #025  firefox-policies.json                                           <none>
[R-]  #026  gamescope                                                       <none>, 3.16.9
[R-]  #027  gnome-shell-extension-ddterm                                    61
[R-]  #028  gnome-twenty-forty-eight                                        3.38.2, 3.38.2_fish-completions
[R.]  #029  gstreamer-vaapi                                                 1.26.0
[R.]  #030  hm_gtk3.0settings.ini                                           <none>
[R.]  #031  hm_gtk4.0settings.ini                                           <none>
[R.]  #032  hm_homelili.gtkrc2.0                                            <none>
[R-]  #033  joycond-cemuhook-unstable                                       2023-08-09
[R-]  #034  joycond-unstable                                                2021-07-30
[R-]  #035  keybind-open-nx-code                                            <none>
[R-]  #036  keybind-open-nx-todo                                            <none>
[R.]  #037  libXres                                                         1.2.2
[R.]  #038  libdiscid                                                       0.6.4
[R.]  #039  libgnome-games-support                                          1.8.2
[R.]  #040  luajit                                                          2.1.1741730670
[R.]  #041  nodejs                                                          22.16.0
[R-]  #042  nx-code                                                         <none>
[R.]  #043  nx-code-no-deps                                                 <none>
[R-]  #044  nx-dconf-diff                                                   <none>
[R.]  #045  nx-dconf-diff-no-deps                                           <none>
[R-]  #046  nx-template                                                     <none>
[R.]  #047  nx-template-no-deps                                             <none>
[R-]  #048  nx-todo                                                         <none>
[R.]  #049  nx-todo-no-deps                                                 <none>
[R-]  #050  picard                                                          2.13.3
[R.]  #051  python3.12-discid                                               1.2.0
[R.]  #052  python3.12-evdev                                                1.9.2
[R.]  #053  python3.12-fasteners                                            0.19
[R.]  #054  python3.12-pyjwt                                                2.10.1
[R.]  #055  python3.12-pyqt5                                                5.15.10, 5.15.10-dev
[R.]  #056  python3.12-pyqt5-sip                                            12.17.0
[R.]  #057  qtwebchannel                                                    5.15.17
[R.]  #058  seatd                                                           0.9.1
[R-]  #059  slsk-batchdl                                                    2.4.6
[R-]  #060  steam-gamescope                                                 <none>
[R-]  #061  steam-run                                                       <none> x2
[R.]  #062  steam-run-bwrap                                                 <none>
[R.]  #063  steam-run-fhsenv-profile                                        <none>
[R.]  #064  steam-run-fhsenv-rootfs                                         <none>
[R.]  #065  steam-run-init                                                  <none>
[R.]  #066  steam.desktop                                                   <none>
[R-]  #067  teams-for-linux                                                 2.0.12
[R.]  #068  unit-joycond.service                                            <none>
[R.]  #069  unit-restic-autobackup-emu-failed.service                       <none>
[R.]  #070  unit-restic-autobackup-emu.service                              <none>
[R.]  #071  unit-restic-autobackup-emu.timer                                <none>
[R.]  #072  unit-restic-autobackup-home-failed.service                      <none>
[R.]  #073  unit-restic-autobackup-home.service                             <none>
[R.]  #074  unit-restic-autobackup-home.timer                               <none>
[R.]  #075  unit-restic-autobackup-important-docs-failed.service            <none>
[R.]  #076  unit-restic-autobackup-important-docs.service                   <none>
[R.]  #077  unit-restic-autobackup-important-docs.timer                     <none>
[R.]  #078  unit-restic-autobackup-minecraft-instances-failed.service       <none>
[R.]  #079  unit-restic-autobackup-minecraft-instances.service              <none>
[R.]  #080  unit-restic-autobackup-minecraft-instances.timer                <none>
[R.]  #081  unit-restic-autobackup-music-failed.service                     <none>
[R.]  #082  unit-restic-autobackup-music.service                            <none>
[R.]  #083  unit-restic-autobackup-music.timer                              <none>
[R.]  #084  unit-restic-autobackup-obsidian-failed.service                  <none>
[R.]  #085  unit-restic-autobackup-obsidian.service                         <none>
[R.]  #086  unit-restic-autobackup-obsidian.timer                           <none>
[R.]  #087  unit-restic-autobackup-share-failed.service                     <none>
[R.]  #088  unit-restic-autobackup-share.service                            <none>
[R.]  #089  unit-restic-autobackup-share.timer                              <none>
[R.]  #090  unit-restic-autobackup-uni-courses-failed.service               <none>
[R.]  #091  unit-restic-autobackup-uni-courses.service                      <none>
[R.]  #092  unit-restic-autobackup-uni-courses.timer                        <none>
[R.]  #093  unit-restic-checks-failed.service                               <none>
[R.]  #094  unit-restic-checks.service                                      <none>
[R.]  #095  unit-restic-checks.timer                                        <none>
[R.]  #096  unit-restic-ludusavi-failed.service                             <none>
[R.]  #097  unit-restic-ludusavi.service                                    <none>
[R.]  #098  unit-restic-ludusavi.timer                                      <none>
[R.]  #099  unit-restic-replication-failed.service                          <none>
[R.]  #100  unit-restic-replication.service                                 <none>
[R.]  #101  unit-restic-replication.timer                                   <none>
[R.]  #102  unit-script-restic-autobackup-emu-failed-start                  <none>
[R.]  #103  unit-script-restic-autobackup-home-failed-start                 <none>
[R.]  #104  unit-script-restic-autobackup-important-docs-failed-start       <none>
[R.]  #105  unit-script-restic-autobackup-minecraft-instances-failed-start  <none>
[R.]  #106  unit-script-restic-autobackup-music-failed-start                <none>
[R.]  #107  unit-script-restic-autobackup-obsidian-failed-start             <none>
[R.]  #108  unit-script-restic-autobackup-share-failed-start                <none>
[R.]  #109  unit-script-restic-autobackup-uni-courses-failed-start          <none>
[R.]  #110  unit-script-restic-checks-failed-start                          <none>
[R.]  #111  unit-script-restic-checks-start                                 <none>
[R.]  #112  unit-script-restic-ludusavi-failed-start                        <none>
[R.]  #113  unit-script-restic-replication-failed-start                     <none>
[R.]  #114  unit-script-restic-replication-start                            <none>
[R.]  #115  unit-script-syncthing-init-post-start                           <none>
[R.]  #116  unit-syncthing-init.service                                     <none> x2
[R.]  #117  unit-syncthing.service                                          <none>
[R.]  #118  unit-wallutils-static.service                                   <none>
[R.]  #119  xwininfo                                                        1.1.6
[R-]  #120  youtube-music                                                   3.9.0
Closure size: 2706 -> 2718 (258 paths added, 246 paths removed, delta +12, disk usage +27.1MiB).
> Activating configuration
stopping the following units: accounts-daemon.service, joycond.service, syncthing-init.service, syncthing.service, systemd-modules-load.service
NOT restarting the following changed units: display-manager.service
activating the configuration...
removing obsolete symlink ‘/etc/firefox/policies/policies.json’...
removing obsolete symlink ‘/etc/direnv/direnvrc’...
removing obsolete symlink ‘/etc/direnv/direnv.toml’...
removing obsolete symlink ‘/etc/direnv/lib/zz-user.sh’...
removing obsolete symlink ‘/etc/tmpfiles.d/10-catppuccin-forgejo-theme.conf’...
removing obsolete symlink ‘/etc/tmpfiles.d/10-catppuccin-gitea-theme.conf’...
reloading user units for lili...
restarting sysinit-reactivation.target
reloading the following units: dbus.service, firewall.service
restarting the following units: polkit.service, systemd-udevd.service
starting the following units: accounts-daemon.service, systemd-modules-load.service
the following new units were started: NetworkManager-dispatcher.service, sysinit-reactivation.target, systemd-ask-password-console.path, systemd-tmpfiles-resetup.service
warning: the following units failed: home-manager-lili.service
> Adding configuration to bootloader
Running post-rebuild actions...
Dumping dconf
Reloading static wallpaper
Failed to restart wallutils-static.service: Unit wallutils-static.service not found.


```