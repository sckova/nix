# My NixOS Configuration

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
user@host ~/Projects/nix (main)
> ls --tree --recurse --icons --ignore-glob=".git"
 .
├──  flake.lock
├──  flake.nix
├──  hardware
│   ├──  alien
│   │   └──  default.nix
│   ├──  default.nix
│   ├──  impermanence.nix
│   ├──  peach
│   │   ├──  default.nix
│   │   └──  firmware
│   │       └──  firmware.cpio
│   └──  skmbp
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
│       │   ├──  firefox
│       │   │   ├──  bookmarks.nix
│       │   │   ├──  default.nix
│       │   │   ├──  extensions
│       │   │   │   ├──  packages.nix
│       │   │   │   ├──  policies.nix
│       │   │   │   ├──  pwas.nix
│       │   │   │   └──  settings.nix
│       │   │   ├──  policies.nix
│       │   │   ├──  search.nix
│       │   │   ├──  settings.nix
│       │   │   └──  theme.nix
│       │   ├──  mpv.nix
│       │   └──  thunderbird.nix
│       ├──  default.nix
│       ├──  games
│       │   ├──  default.nix
│       │   ├──  minecraft.nix
│       │   └──  morrowind.nix
│       ├──  persistence.nix
│       ├──  services
│       │   ├──  default.nix
│       │   ├──  gtk.css
│       │   ├──  gtk.nix
│       │   ├──  qt.nix
│       │   ├──  spotify.nix
│       │   └──  synology.nix
│       ├──  terminal
│       │   ├──  btop.nix
│       │   ├──  default.nix
│       │   ├──  fastfetch.nix
│       │   ├──  fish.nix
│       │   ├──  ghostty.nix
│       │   ├──  git.nix
│       │   ├──  neovim
│       │   │   ├──  app.nix
│       │   │   ├──  colors.nix
│       │   │   ├──  default.nix
│       │   │   ├──  keybinds.nix
│       │   │   ├──  pedantix.nix
│       │   │   ├──  plugins
│       │   │   │   ├──  coding.nix
│       │   │   │   └──  lualine.nix
│       │   │   └──  settings.nix
│       │   ├──  ssh.nix
│       │   ├──  vscode.nix
│       │   └──  ytfp.nix
│       └──  tiling
│           ├──  default.nix
│           ├──  niri
│           │   ├──  binds.nix
│           │   ├──  default.nix
│           │   ├──  outputs.nix
│           │   ├──  rules.nix
│           │   └──  settings.nix
│           ├──  noctalia
│           │   ├──  colors.nix
│           │   ├──  default.nix
│           │   └──  settings.nix
│           ├──  paneru.nix
│           ├──  services.nix
│           ├──  swaylock.nix
│           ├──  vicinae.nix
│           └──  wallpaper.nix
├──  lib
│   ├──  default.nix
│   ├──  home-manager.nix
│   ├──  nix-settings.nix
│   ├──  options.nix
│   ├──  secrets
│   │   └──  secrets.yaml
│   ├──  sops-example.yaml
│   ├──  sops.nix
│   └──  users.nix
├──  LICENSE
├──  packages
│   ├──  bibata-cursor
│   │   └──  default.nix
│   ├──  mkxp-z
│   │   └──  default.nix
│   ├──  overlay.nix
│   ├──  spotify-webapp
│   │   └──  default.nix
│   └──  yabd
│       └──  default.nix
├── 󰂺 README.md
└──  system
    ├──  apps
    │   ├──  default.nix
    │   └──  obs.nix
    ├──  darwin.nix
    ├──  default.nix
    ├──  hosts
    │   ├──  alien
    │   │   ├──  default.nix
    │   │   └──  kernel.nix
    │   └──  peach
    │       └──  default.nix
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
