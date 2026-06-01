# My NixOS Configuration

![Screenshot of the desktop](./src/screenshot.png)

<pre><code>systems = {
  # a MacBook Pro M2 running Asahi NixOS
  <a href="https://ovips.us.to/git/sckova/nix/src/branch/main/home/hosts/peach/default.nix">peach</a> = {
    system = "<a href="https://github.com/nix-community/nixos-apple-silicon">aarch64-linux</a>";
    users = [ "<a href="https://ovips.us.to/git/sckova/nix/src/branch/main/home/sckova/default.nix">sckova</a>" ];
  };
  # a desktop PC
  <a href="https://ovips.us.to/git/sckova/nix/src/branch/main/home/hosts/alien/default.nix">alien</a> = {
    system = "x86_64-linux";
    users = [
      "<a href="https://ovips.us.to/git/sckova/nix/src/branch/main/home/sckova/default.nix">sckova</a>"
      "<a href="https://ovips.us.to/git/sckova/nix/src/branch/main/home/ckovacs/default.nix">ckovacs</a>"
    ];
  };
  # the very same MBP running macOS with nix-darwin
  <a href="https://ovips.us.to/git/sckova/nix/src/branch/main/home/hosts/skmbp/default.nix">skmbp</a> = {
    system = "<a href="https://github.com/nix-darwin/nix-darwin">aarch64-darwin</a>";
    users = [ "<a href="https://ovips.us.to/git/sckova/nix/src/branch/main/home/sckova/default.nix">sckova</a>" ];
  };
}</code></pre>

```shell
user@host ~/nix (main)
> ls --tree --recurse --icons --ignore-glob=".git"
 .
├──  flake.lock
├──  flake.nix
├──  hardware
│   ├──  alien
│   │   └──  default.nix
│   ├──  default.nix
│   └──  peach
│       └──  default.nix
├── 󱂵 home
│   ├──  ckovacs
│   │   └──  default.nix
│   ├──  default.nix
│   ├──  hosts
│   │   ├──  alien
│   │   │   └──  default.nix
│   │   ├──  peach
│   │   │   └──  default.nix
│   │   └──  skmbp
│   │       └──  default.nix
│   └──  sckova
│       ├──  apps
│       │   ├──  default.nix
│       │   ├──  firefox.nix
│       │   ├──  firefox_css
│       │   │   ├──  theme
│       │   │   │   ├──  hide.css
│       │   │   │   └──  theme.css
│       │   │   ├──  userChrome.css
│       │   │   └──  userContent.css
│       │   └──  mpv.nix
│       ├──  default.nix
│       ├──  games
│       │   ├──  default.nix
│       │   ├──  minecraft.nix
│       │   └──  morrowind.nix
│       ├──  services
│       │   ├──  default.nix
│       │   ├──  gtk.nix
│       │   ├──  qt.nix
│       │   └──  synology.nix
│       ├──  terminal
│       │   ├──  btop.nix
│       │   ├──  default.nix
│       │   ├──  fastfetch.nix
│       │   ├──  fish.nix
│       │   ├──  ghostty.nix
│       │   ├──  git.nix
│       │   ├──  neovim.nix
│       │   ├──  ssh.nix
│       │   └──  ytfp.nix
│       └──  tiling
│           ├──  aerospace.nix
│           ├──  default.nix
│           ├──  niri.nix
│           ├──  noctalia.nix
│           └──  wallpaper.nix
├──  lib
│   ├──  nix-settings.nix
│   ├──  options.nix
│   ├──  secrets
│   │   └──  secrets.yaml
│   ├──  sops-example.yaml
│   ├──  sops.nix
│   └──  users.nix
├──  packages
│   ├──  bibata-cursor
│   │   └──  default.nix
│   ├──  overlay.nix
│   └──  spotify-webapp
│       └──  default.nix
├── 󰂺 README.md
├── 󰣞 src
│   └──  screenshot.png
└──  system
    ├──  apps
    │   ├──  default.nix
    │   └──  obs.nix
    ├──  darwin.nix
    ├──  default.nix
    ├──  hosts
    │   ├──  alien
    │   │   └──  default.nix
    │   └──  peach
    │       ├──  apple-rainbow.png
    │       ├──  default.nix
    │       └──  firmware
    │           ├──  all_firmware.tar.gz
    │           └──  kernelcache.release.mac14j
    ├──  networking
    │   ├──  default.nix
    │   └──  tailscale.nix
    └──  services
        ├──  default.nix
        ├──  kde.nix
        ├──  searxng.nix
        ├──  tiling.nix
        └──  widevine.nix
```
