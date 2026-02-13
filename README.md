# NixOS Configuration

This repository contains the personal **NixOS** and **Home Manager** configuration for **Sean Kovacs** (`sckova`). It utilizes **Nix Flakes** to manage reproducible system states across disparate hardware architectures, specifically targeting high-performance x86_64 gaming desktops and Apple Silicon laptops.

## 🖥️ Hosts

The configuration defines three distinct system profiles via `flake.nix`:

### 👽 `alien` (x86_64-linux)

The primary high-performance desktop and gaming workstation.

* **Kernel:** Uses the **CachyOS** kernel (`linux-cachyos-lts`) via `nix-cachyos-kernel` overlay for scheduler and performance optimizations.
* **Graphics:** Nvidia proprietary drivers (Stable) with Open kernel modules disabled.
#### Gaming Stack:
* **Steam**: Enabled with Gamescope session and Proton-GE.
* **Optimization**: `ananicy-cpp` enabled with specific rules for Gamescope (nice -20).
* **Streaming**: Sunshine game streaming service enabled and auto-started.
* **RGB**: OpenRGB and `ddcutil` for hardware lighting and display control.

* **Virtualization:** Podman (Docker compatible) and Hyper-V guest support enabled.
* **Hardware:** Specific monitor configuration defined in Niri settings (Dual 4K @ 144Hz + Portrait 1440p).

### 🍑 `peach` (aarch64-linux)

A configuration tailored for Apple Silicon hardware using **Asahi Linux**.

#### **System-specific setup**:
* GPU-accelerated desktop via Apple Silicon drivers.
* Touchpad configuration with natural scrolling.
* Specific notch handling and boot logo customization with plymouth & m1n1.
* Configures docker in a rootless setup.

* **Kernel**: Patched `linuxPackages_asahi` with Apple Mailbox and RTKit support.

### 💻 `vm-generic`

A generic template for virtual machines, supported on both `x86_64-linux` and `aarch64-linux`.

## 🎨 Desktop Environment

The system uses a highly customized Wayland environment centered around **Niri**.

### Window Manager: **Niri**

#### Type:
* Scrollable-tiling Wayland compositor.
#### Style:
* Tightly separated windows with 2px borders and 4px gaps.
* Animations and window rounding (8px radius).
#### **Input**:
* Focus follows mouse
* Adaptive acceleration
* Natural scrolling enabled
#### **Keybinds**:
* Super+Shift+? preserved for showing the custom keybinds.

### Shell & Widgets: **Noctalia**

* **Bar**: Custom top bar with workspaces, system monitor, media controls, and tray.
* **Notifications**: Integrated notification daemon with "Do Not Disturb" capabilities.
* **Control Center**: Quick access to network, bluetooth, and power profiles.
* **Launcher**: Fuzzel app launcher with clipboard history support.

### Theming: **Base16/24**

A centralized theme configuration module propagates and builds colors across the system's applications and toolkits.

#### Scheme:
* Can use any scheme declared in the [tinted-gallery](https://tinted-theming.github.io/tinted-gallery/).
#### Accent:
* Orange for peach
* Blue for alien
* Green for the VM
#### Cursor:
* Catppuccin Mocha Peach (Size 24).
#### Fonts:
* Sans: Noto Sans
* Serif: Noto Serif
* Mono: FiraMono Nerd Font

## 📦 Software Stack

### Terminal & Editors

#### **Terminal**: **Kitty**
* Fish shell integration
* Scrollback buffering
* Custom theme
* Wayland-specific integrations
#### **Shell**: **Fish**
* Customized prompt
* Modern alternatives to ls `eza`, cat `bat`, and gzip `pigz`.
* `btop` is used as a system monitor.
#### **Editor**: **Neovim** (via `nixvim`) configured with:
* LSP support (`nixd`, `qmlls`).
* `conform-nvim` for formatting (Prettier, Stylua, Black).
* `cmp` for autocompletion.
* `fzf-lua` for fuzzy finding.

### Applications

#### Browser: **Firefox** with extensive hardening
* Telemetry, Pocket, and AI features disabled.
* Custom userChrome theme.
* Vertical tabs enabled.
* Extensions managed via Nix (uBlock Origin, SponsorBlock, Bitwarden, etc.).
* PWA support via `firefoxpwa`.
* SearXNG metasearch engine set up and enabled as the default search engine and homepage.

#### Social
* **Vesktop**: Discord client.
* Dynamically generated base16 theme.
* Numerous plugins (MessageLogger, FakeNitro, etc.) enabled.
* **Fractal**: Matrix client.
* **Tuba**: Mastodon client.

#### Media
* **MPV** with `uosc` UI and `mpris` support.
* **Spotify**: Custom `riff` package (Rust-based client) and `spotify-webapp`.
* **Spicetify**: CLI Spotify client theming.
* **Strawberry**: Music client.
* **Audacity**, **Musescore**: Musical workstations.

### Services

* **Wallpaper**: Automated daily **Bing Wallpaper** downloader service.
* **Storage**: **Synology NAS** mounting via Rclone systemd service.
* **Network**: **Tailscale** mesh networking.

## 🛠️ Usage

### Rebuilding the System

To apply the configuration for a specific host:

```bash
# Rebuild NixOS configuration and switch
sudo nixos-rebuild switch --flake .#systemName

# Rebuild NixOS configuration for next boot
sudo nixos-rebuild boot --flake .#systemName --install-bootloader
```

### VM Testing

To build and run the generic VM:

```bash
nixos-rebuild build-vm --flake .#vm-generic
./result/bin/run-vm-generic-vm
```
