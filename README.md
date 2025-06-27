# Complete Guide to Creating Custom Arch Linux ISO

## Table of Contents
1. [Overview](#overview)
2. [Prerequisites](#prerequisites)
3. [Directory Structure](#directory-structure)
4. [Core Configuration Files](#core-configuration-files)
5. [Package Management](#package-management)
6. [System Configuration](#system-configuration)
7. [Custom Scripts and Applications](#custom-scripts-and-applications)
8. [Boot Configuration](#boot-configuration)
9. [Branding and Customization](#branding-and-customization)
10. [Building the ISO](#building-the-iso)
11. [Advanced Configurations](#advanced-configurations)
12. [Troubleshooting](#troubleshooting)
13. [Best Practices](#best-practices)

---

## Overview

This guide provides comprehensive documentation for creating a custom Arch Linux ISO distribution based on the archiso framework, using the DTOS (Derek Taylor's Operating System) structure as a reference. The ISO will include custom branding, package selection, configurations, and installation scripts.

### What You'll Learn
- Complete archiso project structure
- Package management strategies (official repos + AUR)
- Custom configuration deployment
- Branding and personalization
- Installation script development
- Boot loader configuration
- System service management

---

## Prerequisites

### Required Tools
```bash
# Install archiso and dependencies
sudo pacman -S archiso git base-devel

# Optional but recommended
sudo pacman -S arch-install-scripts squashfs-tools
```

### Knowledge Requirements
- Basic Linux system administration
- Understanding of Arch Linux package management
- Shell scripting basics
- Git version control (for managing your project)

---

## Directory Structure

### Complete Project Layout
```
your-custom-iso/
├── profiledef.sh                    # Main ISO configuration file - defines ISO metadata, build options, and file permissions
├── packages.x86_64                  # Live environment packages - packages installed in the live ISO for basic functionality
├── bootstrap_packages.x86_64        # Bootstrap packages for build - minimal packages needed during ISO creation process
├── pacman.conf                      # Pacman configuration with repositories - defines package sources and signing requirements
├── airootfs/                        # Root filesystem overlay - files copied directly to live system root
│   ├── etc/                         # System configuration files - global system settings and configurations
│   │   ├── os-release               # Operating system identification - defines distro name, version, URLs for system info
│   │   ├── motd                     # Message of the day - welcome text displayed on terminal login
│   │   ├── hostname                 # Default hostname - sets the default system hostname for live environment
│   │   ├── locale.conf              # System locale - defines language, character encoding, and regional settings
│   │   ├── bash.bashrc              # Global bash configuration - system-wide bash shell settings and aliases
│   │   ├── doas.conf                # Privilege escalation config - defines sudo-like permissions for doas command
│   │   ├── pacman.conf              # Target system pacman config - package manager settings for installed system
│   │   ├── group                    # System groups - defines system user groups and their GIDs
│   │   ├── passwd                   # System users - defines system user accounts and their UIDs
│   │   ├── shadow                   # Password hashes - stores encrypted passwords for system security
│   │   ├── gshadow                  # Group passwords - stores encrypted group passwords for group access
│   │   ├── localtime                # System timezone - symlink to timezone data for system clock
│   │   ├── resolv.conf              # DNS resolver config - defines DNS servers for network name resolution
│   │   ├── default/                 # Default configurations - system-wide default settings
│   │   │   └── grub                 # GRUB defaults - default boot loader settings and kernel parameters
│   │   ├── skel/                    # Default user home directory - template for new user home directories
│   │   │   ├── .config/             # User application configs - per-user application configuration directory
│   │   │   │   ├── qtile/           # Window manager config - Qtile window manager configuration files
│   │   │   │   │   ├── config.py    # Main Qtile config - defines keybindings, layouts, and window manager behavior
│   │   │   │   │   ├── autostart.sh # Qtile autostart script - applications launched when Qtile starts
│   │   │   │   │   └── settings/     # Qtile settings modules - organized configuration modules for themes, keybinds, etc.
│   │   │   │   ├── alacritty/       # Terminal emulator config - Alacritty terminal appearance and behavior settings
│   │   │   │   │   └── alacritty.yml # Alacritty configuration - colors, fonts, and terminal behavior
│   │   │   │   ├── rofi/            # Application launcher config - Rofi launcher themes and behavior
│   │   │   │   │   ├── config.rasi  # Rofi configuration - launcher behavior and appearance
│   │   │   │   │   └── themes/      # Rofi themes - custom color schemes and layouts for launcher
│   │   │   │   ├── dunst/           # Notification daemon config - system notification appearance and behavior
│   │   │   │   ├── picom/           # Compositor config - window transparency and effects settings
│   │   │   │   ├── gtk-3.0/         # GTK3 theme config - GTK application theming and appearance
│   │   │   │   ├── fontconfig/      # Font configuration - custom font settings and rendering preferences
│   │   │   │   └── autostart/       # Auto-start applications - programs launched automatically on desktop start
│   │   │   │       └── *.desktop    # Desktop entries - application autostart definitions
│   │   │   └── .local/              # User local data - user-specific data and applications
│   │   │       ├── bin/             # User executables - user-specific executable scripts and programs
│   │   │       └── share/           # User shared data - user-specific shared files and data
│   │   │           ├── applications/ # User desktop entries - custom application launchers
│   │   │           └── fonts/       # User fonts - user-installed fonts for personal use
│   │   ├── systemd/                 # Systemd configuration - system service and boot management
│   │   │   ├── system/              # System services - system-wide service definitions and configurations
│   │   │   │   ├── *.service        # Service files - individual service definitions (daemons, one-shot tasks)
│   │   │   │   ├── *.timer          # Timer services - scheduled tasks and cron-like functionality
│   │   │   │   ├── *.target         # Target services - service grouping and system states
│   │   │   │   ├── *.target.wants/  # Service dependencies - services required by specific targets
│   │   │   │   ├── multi-user.target.wants/ # Multi-user services - services for multi-user system state
│   │   │   │   ├── graphical.target.wants/  # Graphical services - services for graphical desktop environment
│   │   │   │   └── *@.service.d/    # Service overrides - modifications to existing service definitions
│   │   │   ├── network/             # Network configuration - systemd-networkd network interface settings
│   │   │   │   ├── *.network        # Network interface configs - DHCP, static IP, and interface settings
│   │   │   │   └── *.link           # Link configuration - hardware interface naming and properties
│   │   │   ├── resolved.conf.d/     # DNS resolver config - systemd-resolved DNS and domain settings
│   │   │   ├── journald.conf.d/     # Journal configuration - system logging behavior and retention
│   │   │   └── logind.conf.d/       # Login manager config - user session and power management
│   │   ├── pacman.d/                # Pacman configuration - package manager settings and hooks
│   │   │   ├── hooks/               # Pacman hooks - scripts triggered during package operations
│   │   │   │   ├── *.hook           # Hook definitions - automated tasks during package install/remove
│   │   │   │   ├── update-desktop-database.hook # Desktop database updates - refresh application menus
│   │   │   │   └── uncomment-mirrors.hook # Mirror management - automatically enable package mirrors
│   │   │   ├── chaotic-mirrorlist   # AUR mirror list - pre-compiled AUR package repository mirrors
│   │   │   └── mirrorlist           # Official mirrors - Arch Linux package repository mirrors
│   │   ├── ssh/                     # SSH configuration - secure shell server and client settings
│   │   │   ├── sshd_config          # SSH daemon config - server behavior, security, and access control
│   │   │   └── sshd_config.d/       # SSH config overrides - modular SSH server configuration
│   │   │       └── 10-archiso.conf  # Archiso SSH settings - live environment SSH configuration
│   │   ├── sudoers.d/               # Sudo configuration - privilege escalation rules and permissions
│   │   │   └── g_wheel              # Wheel group sudo - allows wheel group members to use sudo
│   │   ├── mkinitcpio.conf.d/       # Initial ramdisk config - boot-time kernel module and filesystem settings
│   │   │   └── archiso.conf         # Archiso initramfs config - live environment boot configuration
│   │   ├── mkinitcpio.d/            # Kernel presets - predefined kernel configurations for different scenarios
│   │   │   └── linux.preset         # Linux kernel preset - default kernel build settings
│   │   ├── modprobe.d/              # Kernel module config - kernel module loading and parameter settings
│   │   │   ├── blacklist.conf       # Module blacklist - prevents loading of problematic modules
│   │   │   └── broadcom-wl.conf     # Broadcom WiFi config - specific WiFi driver configuration
│   │   ├── sddm.conf.d/             # Display manager config - login screen and session management
│   │   │   └── kde_settings.conf    # SDDM settings - display manager theme and behavior
│   │   └── xdg/                     # XDG base directories - desktop environment integration settings
│   │       ├── autostart/           # System autostart - applications launched for all users
│   │       └── user-dirs.defaults   # Default user directories - standard folder structure for user homes
│   ├── usr/                         # User programs and data - system programs and shared data
│   │   ├── local/                   # Local installations - locally compiled or custom software
│   │   │   ├── bin/                 # Custom executables - custom scripts and programs for system
│   │   │   │   ├── your-installer   # Main installation script - primary system installer program
│   │   │   │   ├── choose-mirror    # Mirror selection utility - tool for selecting package repository mirrors
│   │   │   │   ├── welcome-app      # Welcome application - first-run application for new users
│   │   │   │   ├── dtosinstall      # DTOS installer - DTOS-specific installation script
│   │   │   │   ├── dtos-welcome     # DTOS welcome app - DTOS-specific welcome application
│   │   │   │   ├── Installation_guide # Installation guide - interactive installation documentation
│   │   │   │   ├── livecd-sound     # Live CD audio setup - configures audio for live environment
│   │   │   │   └── custom-tools     # Other custom utilities - additional system utilities and tools
│   │   │   └── share/               # Shared data files - shared resources for local programs
│   │   │       ├── applications/    # Desktop entries - application launchers and menu entries
│   │   │       ├── backgrounds/     # Wallpapers - custom wallpaper images for desktop
│   │   │       ├── icons/           # Custom icons - icon themes and individual icon files
│   │   │       ├── themes/          # Desktop themes - complete theme packages for desktop environment
│   │   │       └── fonts/           # Custom fonts - additional font files for system
│   │   └── share/                   # System shared data - system-wide shared resources
│   │       ├── backgrounds/         # System wallpapers - default wallpaper images
│   │       ├── grub/                # GRUB themes - boot loader themes and graphics
│   │       │   └── themes/          # GRUB theme files - custom boot loader appearance
│   │       ├── plymouth/            # Boot splash themes - boot animation and splash screens
│   │       └── pixmaps/             # System icons - system-wide icon files and graphics
│   ├── opt/                         # Optional applications - third-party software and large applications
│   │   ├── your-welcome/            # Welcome application files - complete welcome application package
│   │   │   ├── your-welcome/        # Welcome app source - source code and resources for welcome app
│   │   │   │   ├── main.py          # Welcome app main - primary application entry point
│   │   │   │   ├── ui/              # User interface - GUI components and layouts
│   │   │   │   ├── resources/       # App resources - images, icons, and data files
│   │   │   │   └── config/          # App configuration - application-specific settings
│   │   │   └── install.sh           # Welcome app installer - installation script for welcome application
│   │   └── custom-apps/             # Custom applications - other custom software packages
│   └── root/                        # Root user home and configs - root user settings and package lists
│       ├── .automated_script.sh     # Automated installation script - handles unattended installations
│       ├── .gnupg/                  # GPG configuration - GPG keys and encryption settings for root
│       ├── .bashrc                  # Root bash config - bash shell settings for root user
│       ├── .xinitrc                 # X11 initialization - X Window System startup script
│       ├── pkgs-base                # Base package list - essential system packages for installation
│       ├── pkgs-desktop             # Desktop environment packages - GUI components and window manager
│       ├── pkgs-btrfs               # Btrfs-specific packages - filesystem utilities for Btrfs support
│       ├── pkgs-applications        # Application packages - user applications and productivity software
│       └── pkgs-aur                 # AUR package list - Arch User Repository packages
├── efiboot/                         # UEFI boot configuration - UEFI firmware boot settings and entries
│   └── loader/                      # Systemd-boot configuration - UEFI boot loader configuration
│       ├── loader.conf              # Boot loader settings - timeout, default entry, and boot options
│       └── entries/                 # Boot entries - individual boot menu entries
│           ├── 01-*.conf            # Primary boot entry - main system boot configuration
│           ├── 02-*.conf            # Accessibility boot entry - boot with accessibility features enabled
│           └── 03-*.conf            # Memory test entry - boot into memory testing utility
├── grub/                            # GRUB boot configuration - GRUB boot loader for BIOS and UEFI
│   ├── grub.cfg                     # GRUB menu configuration - boot menu entries and kernel parameters
│   └── loopback.cfg                 # Loopback boot support - enables booting from ISO files
└── syslinux/                        # BIOS boot configuration - legacy BIOS boot loader configuration
    ├── syslinux.cfg                 # Main syslinux config - primary BIOS boot configuration
    ├── archiso_*.cfg                # Boot menu entries - specific boot menu configurations
    │   ├── archiso_head.cfg         # Menu header - boot menu title and graphics
    │   ├── archiso_pxe.cfg          # PXE boot config - network boot configuration
    │   ├── archiso_sys.cfg          # System boot config - standard system boot entries
    │   └── archiso_tail.cfg         # Menu footer - boot menu closing and options
    └── splash.png                   # Boot splash image - graphical boot screen background
```

## File Use Cases and Purposes

### Core Configuration Files

#### **profiledef.sh**
- **Purpose**: Defines the entire ISO build configuration
- **Use Case**: Sets ISO metadata (name, version, publisher), build modes, compression settings, and file permissions
- **When to Edit**: Always customize this first with your branding and build preferences
- **Key Settings**: `iso_name`, `iso_publisher`, `iso_application`, `file_permissions`

#### **packages.x86_64**
- **Purpose**: Packages installed in the live environment
- **Use Case**: Essential packages for the ISO to function (networking, hardware support, installation tools)
- **When to Edit**: Add packages needed for live environment functionality, but keep minimal for size
- **Examples**: `base`, `linux-firmware`, `networkmanager`, `arch-install-scripts`

#### **bootstrap_packages.x86_64**
- **Purpose**: Minimal packages needed during ISO build process
- **Use Case**: Packages required by mkarchiso to create the ISO
- **When to Edit**: Rarely changed unless you need specific build tools
- **Default**: `arch-install-scripts`, `base`

#### **pacman.conf**
- **Purpose**: Package manager configuration for both build and live environment
- **Use Case**: Defines repositories, signing requirements, and package sources
- **When to Edit**: Add custom repositories, AUR sources, or modify package verification
- **Key Sections**: `[chaotic-aur]`, `[your-custom-repo]`, signature levels

### System Configuration Files (airootfs/etc/)

#### **os-release**
- **Purpose**: Operating system identification and branding
- **Use Case**: Defines distro name, version, URLs shown in system info
- **When to Edit**: Essential for branding - change `NAME`, `ID`, `HOME_URL`, etc.
- **Impact**: Affects system info commands, desktop environment about dialogs

#### **motd (Message of the Day)**
- **Purpose**: Welcome message displayed on terminal login
- **Use Case**: Provides instructions and information to live environment users
- **When to Edit**: Customize with your installation instructions and support info
- **Best Practice**: Include installation command, documentation links, network setup help

#### **hostname**
- **Purpose**: Default system hostname for live environment
- **Use Case**: Sets the computer name shown in network and terminal
- **When to Edit**: Change from default to match your distro branding
- **Example**: `yourcustomlinux` instead of `archiso`

#### **locale.conf**
- **Purpose**: System language and regional settings
- **Use Case**: Defines default language, character encoding, date/time formats
- **When to Edit**: Set default locale for your target audience
- **Common Values**: `LANG=en_US.UTF-8` for US English, `LANG=de_DE.UTF-8` for German

#### **bash.bashrc**
- **Purpose**: Global bash shell configuration for all users
- **Use Case**: System-wide shell settings, aliases, and environment variables
- **When to Edit**: Add custom aliases, modify PATH, set environment variables
- **Examples**: Custom aliases like `ll='ls -la'`, custom PATH additions

#### **doas.conf**
- **Purpose**: Privilege escalation configuration (alternative to sudo)
- **Use Case**: Defines which users can run commands as root
- **When to Edit**: Modify privilege rules or switch to sudo configuration
- **DTOS Example**: `permit persist setenv {PATH=...} :wheel` (allows wheel group users)

#### **group & passwd**
- **Purpose**: System user and group definitions
- **Use Case**: Defines system accounts and their IDs
- **When to Edit**: Add system users or modify group memberships
- **Security Note**: Contains sensitive system account information

#### **shadow & gshadow**
- **Purpose**: Encrypted password storage
- **Use Case**: Stores password hashes and group passwords securely
- **When to Edit**: Set default passwords for live environment users
- **Security**: Permissions must be 400 (read-only for root)

### User Configuration Templates (airootfs/etc/skel/)

#### **.config/qtile/config.py**
- **Purpose**: Qtile window manager configuration template
- **Use Case**: Default Qtile setup for new users (keybindings, layouts, themes)
- **When to Edit**: Customize window manager behavior, add custom keybindings
- **Key Elements**: Key bindings, layouts, bar configuration, autostart applications

#### **.config/alacritty/alacritty.yml**
- **Purpose**: Terminal emulator configuration template
- **Use Case**: Default terminal appearance and behavior
- **When to Edit**: Customize fonts, colors, window settings
- **Popular Changes**: Font family, color scheme, window padding, opacity

#### **.config/rofi/config.rasi**
- **Purpose**: Application launcher configuration
- **Use Case**: Defines launcher appearance and behavior
- **When to Edit**: Customize launcher theme, fonts, behavior
- **Customization**: Themes, fonts, window positioning, keyboard shortcuts

### System Services (airootfs/etc/systemd/system/)

#### **choose-mirror.service**
- **Purpose**: Automatic mirror selection service
- **Use Case**: Helps users select fastest package repository mirrors
- **When to Edit**: Modify mirror selection logic or add custom mirrors
- **Activation**: Triggered by `mirror` kernel parameter

#### **display-manager.service**
- **Purpose**: Symlink to display manager (login screen)
- **Use Case**: Defines which display manager to use (sddm, gdm, lightdm)
- **When to Edit**: Change display manager or modify startup behavior
- **DTOS Example**: Links to `sddm.service`

#### **pacman-init.service**
- **Purpose**: Initializes package manager keyring
- **Use Case**: Sets up GPG keys for package verification
- **When to Edit**: Modify keyring initialization or add custom keys
- **Critical**: Must complete before package installation

### Network Configuration (airootfs/etc/systemd/network/)

#### **20-ethernet.network**
- **Purpose**: Ethernet interface configuration
- **Use Case**: Automatic DHCP configuration for wired connections
- **When to Edit**: Modify network settings or add static IP configurations
- **Default**: DHCP enabled with privacy extensions

#### **20-wlan.network**
- **Purpose**: Wireless interface configuration
- **Use Case**: Basic wireless network setup
- **When to Edit**: Add wireless-specific settings or security configurations
- **Note**: Requires additional tools like `iwd` or `wpa_supplicant`

### Package Management (airootfs/etc/pacman.d/)

#### **hooks/uncomment-mirrors.hook**
- **Purpose**: Automatically enables package repository mirrors
- **Use Case**: Ensures package mirrors are available after installation
- **When to Edit**: Modify mirror management or add custom mirror logic
- **Trigger**: Runs during package operations

#### **hooks/waypaper.hook**
- **Purpose**: Updates wallpaper database after package changes
- **Use Case**: Ensures wallpaper applications see new wallpapers
- **When to Edit**: Add similar hooks for other applications
- **Pattern**: Update application databases after package installation

#### **chaotic-mirrorlist**
- **Purpose**: Mirror list for Chaotic AUR repository
- **Use Case**: Provides pre-compiled AUR packages
- **When to Edit**: Add or modify AUR package sources
- **Alternative**: Replace with custom repository mirrors

### Installation Scripts (airootfs/usr/local/bin/)

#### **dtosinstall**
- **Purpose**: Main system installation script
- **Use Case**: Guides users through system installation process
- **When to Edit**: Customize installation options, add features, modify UI
- **Key Features**: Disk partitioning, package installation, user creation, bootloader setup

#### **choose-mirror**
- **Purpose**: Repository mirror selection utility
- **Use Case**: Helps users select fastest package mirrors
- **When to Edit**: Add custom mirrors or modify selection logic
- **Integration**: Used by installation scripts and services

#### **dtos-welcome**
- **Purpose**: Welcome application for new users
- **Use Case**: Provides information and quick actions for live environment
- **When to Edit**: Customize welcome message, add custom actions
- **UI**: Can be GUI or terminal-based

#### **Installation_guide**
- **Purpose**: Interactive installation documentation
- **Use Case**: Provides step-by-step installation help
- **When to Edit**: Update with your specific installation procedures
- **Format**: Usually opens documentation in browser or terminal

### Package Lists (airootfs/root/)

#### **pkgs-base**
- **Purpose**: Essential system packages for installation
- **Use Case**: Packages installed on every system (bootloader, kernel, basic tools)
- **When to Edit**: Add/remove essential system packages
- **Examples**: `base-devel`, `grub`, `networkmanager`, `yay`

#### **pkgs-qtile**
- **Purpose**: Desktop environment packages
- **Use Case**: Packages for complete desktop experience
- **When to Edit**: Customize desktop environment, add/remove applications
- **Examples**: `qtile`, `alacritty`, `rofi`, `firefox`

#### **pkgs-btrfs**
- **Purpose**: Btrfs filesystem-specific packages
- **Use Case**: Additional tools for Btrfs filesystem support
- **When to Edit**: Modify filesystem support packages
- **Examples**: `btrfs-progs`, `snapper`, `grub-btrfs`

#### **pkgs-applications**
- **Purpose**: User applications and productivity software
- **Use Case**: Software that users typically want installed
- **When to Edit**: Customize default application selection
- **Examples**: `firefox`, `libreoffice`, `gimp`, `code`

### Boot Configuration

#### **efiboot/loader/loader.conf**
- **Purpose**: UEFI boot loader configuration
- **Use Case**: Defines boot timeout, default entry, and boot behavior
- **When to Edit**: Customize boot experience for UEFI systems
- **Settings**: `timeout`, `default`, `editor` (enable/disable boot parameter editing)

#### **efiboot/loader/entries/*.conf**
- **Purpose**: Individual boot menu entries
- **Use Case**: Defines specific boot options (normal, accessibility, memtest)
- **When to Edit**: Customize boot options, kernel parameters, or entry names
- **Parameters**: `title`, `linux`, `initrd`, `options`

#### **grub/grub.cfg**
- **Purpose**: GRUB boot loader configuration
- **Use Case**: Defines boot menu for BIOS and UEFI systems
- **When to Edit**: Customize boot menu appearance and options
- **Features**: Multiple boot entries, kernel parameters, theme support

#### **syslinux/syslinux.cfg**
- **Purpose**: BIOS boot loader configuration
- **Use Case**: Legacy BIOS boot support
- **When to Edit**: Customize BIOS boot experience
- **Elements**: Boot menu, splash screen, timeout settings

### Custom Applications (airootfs/opt/)

#### **dtos-welcome/**
- **Purpose**: Complete welcome application package
- **Use Case**: Provides rich welcome experience with GUI and features
- **When to Edit**: Develop custom welcome application for your distro
- **Structure**: Source code, resources, configuration files

### Optional Files Based on DTOS Structure

#### **airootfs/etc/sddm.conf.d/kde_settings.conf**
- **Purpose**: SDDM display manager configuration
- **Use Case**: Customizes login screen appearance and behavior
- **When to Edit**: Change login screen theme, user selection, session options
- **Settings**: Theme, avatar display, session selection

#### **airootfs/etc/xdg/reflector/reflector.conf**
- **Purpose**: Reflector mirror ranking configuration
- **Use Case**: Automatic mirror selection and ranking
- **When to Edit**: Modify mirror selection criteria or update frequency
- **Parameters**: Country selection, protocol preferences, mirror count

This comprehensive file breakdown helps you understand exactly what each file does and when you need to modify it for your custom ISO.

---

---

## Core Configuration Files

### 1. profiledef.sh - ISO Definition
```bash
#!/usr/bin/env bash
# shellcheck disable=SC2034

# Basic ISO Information
iso_name="yourcustomlinux"                                    # ISO filename prefix
iso_label="YOURCUSTOM_$(date --date="@${SOURCE_DATE_EPOCH:-$(date +%s)}" +%Y%m)"
iso_publisher="Your Name <your@email.com>"                   # Publisher information
iso_application="Your Custom Linux Live/Install DVD"         # ISO description
iso_version="$(date --date="@${SOURCE_DATE_EPOCH:-$(date +%s)}" +%Y.%m.%d)"
install_dir="arch"                                           # Installation directory name

# Build Configuration
buildmodes=('iso')                                           # Build modes (iso, netboot)
bootmodes=(                                                  # Supported boot modes
    'bios.syslinux.mbr'         # BIOS MBR boot
    'bios.syslinux.eltorito'    # BIOS CD/DVD boot
    'uefi-ia32.systemd-boot.esp'    # UEFI 32-bit
    'uefi-x64.systemd-boot.esp'     # UEFI 64-bit
    'uefi-ia32.systemd-boot.eltorito'   # UEFI 32-bit CD/DVD
    'uefi-x64.systemd-boot.eltorito'   # UEFI 64-bit CD/DVD
)

# System Configuration
arch="x86_64"                                               # Target architecture
pacman_conf="pacman.conf"                                   # Pacman config file
airootfs_image_type="squashfs"                             # Filesystem image type

# Compression Settings
airootfs_image_tool_options=(                              # SquashFS compression options
    '-comp' 'xz'                # Compression algorithm
    '-Xbcj' 'x86'               # BCJ filter for x86
    '-b' '1M'                   # Block size
    '-Xdict-size' '1M'          # Dictionary size
)
bootstrap_tarball_compression=(                            # Bootstrap compression
    'zstd' '-c' '-T0'          # Zstandard compression
    '--auto-threads=logical'    # Use all logical cores
    '--long' '-19'              # Maximum compression
)

# File Permissions
file_permissions=(
    ["/etc/doas.conf"]="0:0:400"                          # Privilege escalation config
    ["/etc/shadow"]="0:0:400"                             # Password hashes
    ["/etc/gshadow"]="0:0:0400"                           # Group passwords
    ["/root"]="0:0:750"                                   # Root home directory
    ["/root/.automated_script.sh"]="0:0:755"              # Automated script
    ["/root/.gnupg"]="0:0:700"                            # GPG directory
    ["/usr/local/bin/choose-mirror"]="0:0:755"            # Mirror chooser
    ["/usr/local/bin/your-installer"]="0:0:755"           # Installation script
    ["/usr/local/bin/welcome-app"]="0:0:755"              # Welcome application
)
```

### 2. bootstrap_packages.x86_64 - Build Dependencies
```
# Minimal packages needed for building the ISO
arch-install-scripts
base
```

### 3. pacman.conf - Package Manager Configuration
```ini
#
# Pacman Configuration for Custom ISO
#

[options]
# General Options
HoldPkg      = pacman glibc
Architecture = auto

# Repositories - Official Arch Linux
[core]
Include = /etc/pacman.d/mirrorlist

[extra]
Include = /etc/pacman.d/mirrorlist

[multilib]
Include = /etc/pacman.d/mirrorlist

# Custom Repositories
[your-custom-repo]
SigLevel = Optional TrustAll
Server = https://your-server.com/repo/$arch

# Chaotic AUR - Pre-compiled AUR packages
[chaotic-aur]
Include = /etc/pacman.d/chaotic-mirrorlist
```

---

## Package Management

### Package Organization Strategy

#### 1. Live Environment Packages (packages.x86_64)
Essential packages for the live environment:
```
# Base System
base
linux
linux-firmware
linux-headers

# Hardware Support
amd-ucode
intel-ucode
broadcom-wl
sof-firmware

# Network Tools
dhcpcd
iwd
wpa_supplicant
networkmanager

# Installation Tools
arch-install-scripts
archinstall
gptfdisk
parted

# File Systems
btrfs-progs
dosfstools
e2fsprogs
exfatprogs
f2fs-tools
jfsutils
ntfs-3g
xfsprogs

# System Tools
sudo
nano
vim
git
curl
wget

# Your Essential Additions
chaotic-aur/chaotic-keyring
chaotic-aur/chaotic-mirrorlist
```

#### 2. Installation Package Lists

**airootfs/root/pkgs-base (Essential System)**
```
# Base Development
base-devel
git

# Boot and System
grub
efibootmgr
os-prober
mkinitcpio

# Network
networkmanager
dhcpcd

# File System
btrfs-progs
dosfstools
e2fsprogs

# System Management
systemd
polkit
dbus

# Essential Tools
bash-completion
man-db
man-pages
nano
vim
neovim

# Package Management
pacman-contrib
reflector
yay  # AUR helper

# Security
sudo
doas
```

**airootfs/root/pkgs-desktop (Desktop Environment)**
```
# Window Manager
qtile
python-psutil
python-click
python-xcffib
python-cairocffi

# Display Server
xorg-server
xorg-xinit
xorg-xrandr
xorg-xsetroot

# Terminal
alacritty
xterm

# Application Launcher
rofi
dmenu

# File Manager
pcmanfm-gtk3
gvfs

# Audio
pulseaudio
pavucontrol
alsa-utils

# Fonts
ttf-dejavu
ttf-liberation
noto-fonts
ttf-font-awesome

# Themes
arc-gtk-theme
papirus-icon-theme

# Display Manager
sddm
```

**airootfs/root/pkgs-applications (Applications)**
```
# Web Browser
firefox
chromium

# Text Editor
code
gedit

# Media
vlc
mpv
gimp
shotwell

# Office
libreoffice-fresh

# Development
python
nodejs
npm

# System Monitoring
htop
neofetch
```

**airootfs/root/pkgs-aur (AUR Packages)**
```
# AUR packages (installed via chaotic-aur or custom repo)
qtile-extras
brave-bin
visual-studio-code-bin
yay
yay-bin
```

### AUR Package Handling Strategies

#### Option 1: Chaotic AUR (Recommended)
```bash
# Add to pacman.conf
[chaotic-aur]
Include = /etc/pacman.d/chaotic-mirrorlist

# Add packages to regular package lists
# They install like normal packages
```

#### Option 2: Custom Repository
```bash
# Build AUR packages and host them
mkdir -p /path/to/your/repo
cd /path/to/your/repo

# Build packages
git clone https://aur.archlinux.org/qtile-extras.git
cd qtile-extras
makepkg -si

# Create repository database
repo-add your-repo.db.tar.xz *.pkg.tar.xz

# Upload to your server
rsync -av . your-server:/path/to/repo/
```

#### Option 3: Post-Installation Build
```bash
# In your installer script
arch-chroot /mnt bash -c "
    # Install AUR helper
    sudo -u $username bash -c '
        cd /tmp
        git clone https://aur.archlinux.org/yay.git
        cd yay
        makepkg -si --noconfirm
        yay -S qtile-extras --noconfirm
    '
"
```

---

## System Configuration

### 1. OS Identification (airootfs/etc/os-release)
```ini
NAME="Your Custom Linux"
PRETTY_NAME="Your Custom Linux"
ID=yourcustomlinux
ID_LIKE=arch
BUILD_ID=rolling
ANSI_COLOR="0;36"
HOME_URL="https://yourwebsite.com/"
DOCUMENTATION_URL="https://wiki.yourwebsite.com/"
SUPPORT_URL="https://forum.yourwebsite.com/"
BUG_REPORT_URL="https://github.com/yourusername/issues"
PRIVACY_POLICY_URL="https://yourwebsite.com/privacy"
LOGO=yourcustomlinux
```

### 2. Welcome Message (airootfs/etc/motd)
```
Welcome to Your Custom Linux Live Environment!

To install Your Custom Linux, run: your-installer
For help, type: Installation_guide

Network Configuration:
- Ethernet: Should work automatically
- Wi-Fi: Use 'iwctl' utility
- Mobile: Use 'mmcli' utility

Documentation: https://wiki.yourwebsite.com
Support: https://forum.yourwebsite.com

Enjoy your custom Linux experience!
```

### 3. System Defaults

**Hostname (airootfs/etc/hostname)**
```
yourcustomlinux
```

**Locale (airootfs/etc/locale.conf)**
```
LANG=en_US.UTF-8
LC_ADDRESS=en_US.UTF-8
LC_IDENTIFICATION=en_US.UTF-8
LC_MEASUREMENT=en_US.UTF-8
LC_MONETARY=en_US.UTF-8
LC_NAME=en_US.UTF-8
LC_NUMERIC=en_US.UTF-8
LC_PAPER=en_US.UTF-8
LC_TELEPHONE=en_US.UTF-8
LC_TIME=en_US.UTF-8
```

### 4. User Configuration Template (airootfs/etc/skel/)

**Qtile Configuration (.config/qtile/config.py)**
```python
# Your Custom Qtile Configuration
from libqtile import bar, layout, widget
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy

# Mod key
mod = "mod4"  # Super/Windows key

# Key bindings
keys = [
    # Window management
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    
    # Launch applications
    Key([mod], "Return", lazy.spawn("alacritty"), desc="Launch terminal"),
    Key([mod], "d", lazy.spawn("rofi -show drun"), desc="Launch rofi"),
    
    # System
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload config"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
]

# Groups (workspaces)
groups = [Group(i) for i in "123456789"]

# Layouts
layouts = [
    layout.MonadTall(margin=8, border_focus="#ff6c6b", border_normal="#1e2029"),
    layout.Max(),
]

# Widgets
widget_defaults = dict(
    font="sans",
    fontsize=12,
    padding=3,
)

# Screens
screens = [
    Screen(
        top=bar.Bar(
            [
                widget.GroupBox(),
                widget.Prompt(),
                widget.WindowName(),
                widget.Spacer(),
                widget.Clock(format="%Y-%m-%d %a %I:%M %p"),
                widget.QuickExit(),
            ],
            24,
            background="#1e2029",
        ),
    ),
]

# Your custom configuration continues...
```

**Terminal Configuration (.config/alacritty/alacritty.yml)**
```yaml
# Your Custom Alacritty Configuration
window:
  padding:
    x: 10
    y: 10

font:
  normal:
    family: "JetBrains Mono"
    style: Regular
  size: 12.0

colors:
  primary:
    background: '#1e2029'
    foreground: '#abb2bf'
  
  normal:
    black:   '#1e2029'
    red:     '#e06c75'
    green:   '#98c379'
    yellow:  '#e5c07b'
    blue:    '#61afef'
    magenta: '#c678dd'
    cyan:    '#56b6c2'
    white:   '#abb2bf'

shell:
  program: /bin/bash
  args:
    - --login
```

### 5. System Services Configuration

**Custom Service (airootfs/etc/systemd/system/your-welcome.service)**
```ini
[Unit]
Description=Your Custom Welcome Application
After=graphical-session.target

[Service]
Type=simple
ExecStart=/usr/local/bin/welcome-app
User=root
Environment=DISPLAY=:0

[Install]
WantedBy=multi-user.target
```

**Service Enablement (airootfs/etc/systemd/system/multi-user.target.wants/)**
```bash
# Create symlinks to enable services
ln -sf ../your-welcome.service your-welcome.service
ln -sf ../NetworkManager.service NetworkManager.service
```

---

## Custom Scripts and Applications

### 1. Main Installer Script (airootfs/usr/local/bin/your-installer)
```bash
#!/usr/bin/env bash

# Your Custom Linux Installer
# Based on DTOS installer structure

set -e

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
RESET='\033[0m'

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${RESET} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${RESET} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${RESET} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${RESET} $1"
}

# Menu function
menu() {
    local title="$1"
    local prompt="$2"
    
    echo -e "\n${BOLD}$title${RESET}"
    echo "===================="
    
    local i=1
    for option in "${my_array[@]}"; do
        echo "$i) $option"
        ((i++))
    done
    
    echo
    read -p "$prompt" choice_num
    
    if [[ $choice_num =~ ^[0-9]+$ ]] && [ $choice_num -ge 1 ] && [ $choice_num -le ${#my_array[@]} ]; then
        choice="${my_array[$((choice_num-1))]}"
        choice="${choice// \[recommended\]/}"
    else
        log_error "Invalid selection. Please try again."
        menu "$title" "$prompt"
    fi
}

# System detection
detect_system() {
    log_info "Detecting system configuration..."
    
    # Detect virtualization
    if systemd-detect-virt -q; then
        virt_type=$(systemd-detect-virt)
        log_info "Detected virtualization: $virt_type"
    fi
    
    # Detect UEFI/BIOS
    if [ -d /sys/firmware/efi ]; then
        firmware_type="UEFI"
        log_info "UEFI firmware detected"
    else
        firmware_type="BIOS"
        log_info "BIOS firmware detected"
    fi
}

# Disk selection
select_disk() {
    log_info "Available disks:"
    lsblk -d -o NAME,SIZE,MODEL | grep -E '^[sv]d[a-z]|^nvme'
    
    echo
    read -p "Enter the disk to install to (e.g., sda, nvme0n1): " disk
    
    if [ ! -b "/dev/$disk" ]; then
        log_error "Invalid disk selection"
        select_disk
        return
    fi
    
    disk="/dev/$disk"
    log_info "Selected disk: $disk"
}

# Filesystem selection
select_filesystem() {
    my_array=("ext4 [recommended]" "btrfs" "xfs")
    menu "Select Filesystem" "Choose filesystem type: "
    fs_type="$choice"
    log_info "Selected filesystem: $fs_type"
}

# User configuration
configure_user() {
    read -p "Enter username: " username
    
    while true; do
        read -s -p "Enter password for $username: " userpass1
        echo
        read -s -p "Confirm password: " userpass2
        echo
        
        if [[ "$userpass1" == "$userpass2" ]]; then
            userpass="$userpass1"
            log_success "Password set for $username"
            break
        else
            log_error "Passwords do not match. Please try again."
        fi
    done
}

# Desktop selection
select_desktop() {
    my_array=("full [recommended]" "minimal" "none")
    menu "Desktop Installation" "Choose desktop installation type: "
    desktop_type="$choice"
    log_info "Desktop type: $desktop_type"
}

# Hostname configuration
configure_hostname() {
    read -p "Enter hostname [yourcustomlinux]: " hostname
    hostname="${hostname:-yourcustomlinux}"
    log_info "Hostname: $hostname"
}

# Installation summary
show_summary() {
    log_info "Installation Summary:"
    echo "===================="
    echo "Disk: $disk"
    echo "Filesystem: $fs_type"
    echo "Username: $username"
    echo "Hostname: $hostname"
    echo "Desktop: $desktop_type"
    echo "Firmware: $firmware_type"
    echo "===================="
    
    read -p "Proceed with installation? (y/N): " confirm
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        log_info "Installation cancelled."
        exit 0
    fi
}

# Disk partitioning
partition_disk() {
    log_info "Partitioning disk: $disk"
    
    # Wipe disk
    wipefs -af "$disk"
    sgdisk -Z "$disk"
    
    if [ "$firmware_type" = "UEFI" ]; then
        # UEFI partitioning
        sgdisk -n 1:0:+512M -t 1:ef00 -c 1:"EFI System" "$disk"
        sgdisk -n 2:0:0 -t 2:8300 -c 2:"Linux filesystem" "$disk"
        
        # Format partitions
        mkfs.fat -F32 "${disk}1"
        
        if [ "$fs_type" = "btrfs" ]; then
            mkfs.btrfs -f "${disk}2"
        elif [ "$fs_type" = "xfs" ]; then
            mkfs.xfs -f "${disk}2"
        else
            mkfs.ext4 -F "${disk}2"
        fi
        
        # Mount partitions
        mount "${disk}2" /mnt
        mkdir -p /mnt/boot/efi
        mount "${disk}1" /mnt/boot/efi
        
    else
        # BIOS partitioning
        sgdisk -n 1:0:+1M -t 1:ef02 -c 1:"BIOS boot" "$disk"
        sgdisk -n 2:0:0 -t 2:8300 -c 2:"Linux filesystem" "$disk"
        
        # Format partition
        if [ "$fs_type" = "btrfs" ]; then
            mkfs.btrfs -f "${disk}2"
        elif [ "$fs_type" = "xfs" ]; then
            mkfs.xfs -f "${disk}2"
        else
            mkfs.ext4 -F "${disk}2"
        fi
        
        # Mount partition
        mount "${disk}2" /mnt
    fi
    
    log_success "Disk partitioned and mounted"
}

# Package installation
install_packages() {
    log_info "Installing base system..."
    
    # Install base system
    pacstrap -K /mnt base base-devel linux linux-headers linux-firmware
    pacstrap /mnt - < /root/pkgs-base
    
    # Install filesystem-specific packages
    if [ "$fs_type" = "btrfs" ]; then
        log_info "Installing Btrfs packages..."
        pacstrap /mnt btrfs-progs
    fi
    
    # Install desktop packages
    case "$desktop_type" in
        "full")
            log_info "Installing full desktop environment..."
            pacstrap /mnt - < /root/pkgs-desktop
            pacstrap /mnt - < /root/pkgs-applications
            ;;
        "minimal")
            log_info "Installing minimal desktop..."
            pacstrap /mnt - < /root/pkgs-desktop
            ;;
        "none")
            log_info "Skipping desktop installation..."
            ;;
    esac
    
    log_success "Package installation completed"
}

# System configuration
configure_system() {
    log_info "Configuring system..."
    
    # Generate fstab
    genfstab -U /mnt >> /mnt/etc/fstab
    
    # Configure chroot environment
    arch-chroot /mnt bash -c "
        # Timezone
        ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime
        hwclock --systohc
        
        # Locale
        sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
        locale-gen
        echo 'LANG=en_US.UTF-8' > /etc/locale.conf
        
        # Hostname
        echo '$hostname' > /etc/hostname
        cat > /etc/hosts << EOF
127.0.0.1   localhost
::1         localhost
127.0.1.1   $hostname.localdomain   $hostname
EOF
        
        # Root password
        echo 'root:root' | chpasswd
        
        # User creation
        useradd -m -G wheel,audio,video,optical,storage -s /bin/bash $username
        echo '$username:$userpass' | chpasswd
        
        # Sudo configuration
        sed -i 's/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers
        
        # Enable services
        systemctl enable NetworkManager
        systemctl enable sddm
        
        # Install and configure bootloader
        if [ '$firmware_type' = 'UEFI' ]; then
            grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id='Your Custom Linux'
        else
            grub-install --target=i386-pc $disk
        fi
        
        grub-mkconfig -o /boot/grub/grub.cfg
    "
    
    log_success "System configuration completed"
}

# Post-installation tasks
post_install() {
    log_info "Running post-installation tasks..."
    
    # Install AUR packages if desktop was installed
    if [ "$desktop_type" != "none" ]; then
        arch-chroot /mnt sudo -u $username bash -c "
            cd /tmp
            git clone https://aur.archlinux.org/yay.git
            cd yay
            makepkg -si --noconfirm
            
            # Install AUR packages
            yay -S qtile-extras --noconfirm
        "
    fi
    
    # Copy custom configurations
    cp -r /etc/skel/. /mnt/home/$username/
    chown -R $username:$username /mnt/home/$username
    
    log_success "Post-installation completed"
}

# Main installation function
main() {
    echo -e "${BOLD}Your Custom Linux Installer${RESET}"
    echo "================================"
    
    detect_system
    select_disk
    select_filesystem
    configure_user
    select_desktop
    configure_hostname
    show_summary
    
    partition_disk
    install_packages
    configure_system
    post_install
    
    log_success "Installation completed successfully!"
    log_info "You can now reboot into your new system."
    
    read -p "Reboot now? (y/N): " reboot_confirm
    if [[ "$reboot_confirm" =~ ^[Yy]$ ]]; then
        umount -R /mnt
        reboot
    fi
}

# Run main function
main "$@"
```

### 2. Welcome Application (airootfs/usr/local/bin/welcome-app)
```bash
#!/usr/bin/env bash

# Your Custom Linux Welcome Application

# Check if GUI is available
if [ -n "$DISPLAY" ]; then
    # GUI version using yad (if available)
    if command -v yad &> /dev/null; then
        yad --title="Welcome to Your Custom Linux" \
            --text="<big><b>Welcome to Your Custom Linux</b></big>\n\nChoose an option below:" \
            --button="Install System:0" \
            --button="Open Documentation:1" \
            --button="Live Session:2" \
            --width=400 \
            --height=200
        
        case $? in
            0) your-installer ;;
            1) firefox https://wiki.yourwebsite.com ;;
            2) ;;
        esac
    else
        # Fallback terminal version
        show_terminal_welcome
    fi
else
    # Terminal version
    show_terminal_welcome
fi

show_terminal_welcome() {
    clear
    cat << "EOF"
    
    ╔══════════════════════════════════════════════════════════════╗
    ║                                                              ║
    ║           Welcome to Your Custom Linux Live Environment     ║
    ║                                                              ║
    ╠══════════════════════════════════════════════════════════════╣
    ║                                                              ║
    ║  1) Install Your Custom Linux                                ║
    ║  2) Open Installation Guide                                  ║
    ║  3) Configure Network                                        ║
    ║  4) Open Terminal                                            ║
    ║  5) Exit                                                     ║
    ║                                                              ║
    ╚══════════════════════════════════════════════════════════════╝
    
EOF

    read -p "Choose an option [1-5]: " choice
    
    case $choice in
        1) your-installer ;;
        2) Installation_guide ;;
        3) nmtui ;;
        4) bash ;;
        5) exit 0 ;;
        *) echo "Invalid option"; show_terminal_welcome ;;
    esac
}
```

### 3. Mirror Selection Utility (airootfs/usr/local/bin/choose-mirror)
```bash
#!/usr/bin/env bash

# Mirror selection utility

MIRRORLIST="/etc/pacman.d/mirrorlist"

log_info() {
    echo -e "\033[0;34m[INFO]\033[0m $1"
}

log_success() {
    echo -e "\033[0;32m[SUCCESS]\033[0m $1"
}

# Check for internet connectivity
check_internet() {
    if ping -c 1 archlinux.org &> /dev/null; then
        return 0
    else
        return 1
    fi
}

# Update mirrors using reflector
update_mirrors() {
    log_info "Updating mirror list..."
    
    if ! check_internet; then
        echo "No internet connection. Cannot update mirrors."
        return 1
    fi
    
    # Backup current mirrorlist
    cp "$MIRRORLIST" "${MIRRORLIST}.backup"
    
    # Update with reflector
    reflector --verbose \
              --latest 20 \
              --protocol https \
              --sort rate \
              --save "$MIRRORLIST"
    
    log_success "Mirror list updated successfully"
}

# Manual mirror selection
manual_selection() {
    echo "Available countries:"
    reflector --list-countries
    
    read -p "Enter country code (e.g., US, DE, JP): " country
    
    log_info "Fetching mirrors for $country..."
    
    reflector --verbose \
              --country "$country" \
              --latest 10 \
              --protocol https \
              --sort rate \
              --save "$MIRRORLIST"
    
    log_success "Mirrors updated for $country"
}

# Main menu
main() {
    echo "Mirror Selection Utility"
    echo "======================="
    echo "1) Auto-select fastest mirrors"
    echo "2) Select mirrors by country"
    echo "3) Show current mirrors"
    echo "4) Exit"
    
    read -p "Choose option [1-4]: " choice
    
    case $choice in
        1) update_mirrors ;;
        2) manual_selection ;;
        3) cat "$MIRRORLIST" ;;
        4) exit 0 ;;
        *) echo "Invalid option"; main ;;
    esac
}

main "$@"
```

---

## Boot Configuration

### 1. UEFI Boot Configuration (efiboot/loader/loader.conf)
```ini
timeout 15
default 01-yourcustomlinux-x86_64-linux.conf
beep on
console-mode auto
editor no
```

### 2. UEFI Boot Entry (efiboot/loader/entries/01-yourcustomlinux-x86_64-linux.conf)
```ini
title    Your Custom Linux install medium (x86_64, UEFI)
sort-key 01
linux    /%INSTALL_DIR%/boot/x86_64/vmlinuz-linux
initrd   /%INSTALL_DIR%/boot/x86_64/initramfs-linux.img
options  archisobasedir=%INSTALL_DIR% archisosearchuuid=%ARCHISO_UUID% cow_spacesize=1G
```

### 3. Accessibility Boot Entry (efiboot/loader/entries/02-yourcustomlinux-x86_64-speech-linux.conf)
```ini
title    Your Custom Linux install medium (x86_64, UEFI) with speech
sort-key 02
linux    /%INSTALL_DIR%/boot/x86_64/vmlinuz-linux
initrd   /%INSTALL_DIR%/boot/x86_64/initramfs-linux.img
options  archisobasedir=%INSTALL_DIR% archisosearchuuid=%ARCHISO_UUID% accessibility=on cow_spacesize=1G
```

### 4. GRUB Configuration (grub/grub.cfg)
```bash
# GRUB Configuration for Your Custom Linux

# Load necessary modules
insmod part_gpt
insmod part_msdos
insmod fat
insmod iso9660
insmod ntfs
insmod ntfscomp
insmod exfat
insmod udf

# Set default menu entry
set default="0"
set timeout="15"

# Load configuration variables
if [ -e "/EFI/boot/grubenv" ]; then
    load_env
fi

# Main menu entry
menuentry "Your Custom Linux Live (x86_64)" --class arch --class gnu-linux --class gnu --class os --id 'yourcustomlinux' {
    set gfxpayload=keep
    search --no-floppy --set=root --label %ARCHISO_LABEL%
    linux /%INSTALL_DIR%/boot/x86_64/vmlinuz-linux archisobasedir=%INSTALL_DIR% archisosearchuuid=%ARCHISO_UUID% cow_spacesize=1G
    initrd /%INSTALL_DIR%/boot/x86_64/initramfs-linux.img
}

# Accessibility menu entry
menuentry "Your Custom Linux Live (x86_64) with Speech" --class arch --class gnu-linux --class gnu --class os --id 'yourcustomlinux-accessibility' {
    set gfxpayload=keep
    search --no-floppy --set=root --label %ARCHISO_LABEL%
    linux /%INSTALL_DIR%/boot/x86_64/vmlinuz-linux archisobasedir=%INSTALL_DIR% archisosearchuuid=%ARCHISO_UUID% accessibility=on cow_spacesize=1G
    initrd /%INSTALL_DIR%/boot/x86_64/initramfs-linux.img
}

# Memory test
if [ "${grub_platform}" == "efi" ]; then
    if [ "${grub_cpu}" == "x86_64" ]; then
        menuentry "Memory Test (memtest86+)" --class memtest86 --class memtest --class gnu --class tool {
            set gfxpayload=800x600,1024x768
            search --no-floppy --set=root --label %ARCHISO_LABEL%
            linux /%INSTALL_DIR%/boot/memtest86+/memtest.efi
        }
    fi
fi
```

### 5. BIOS Boot Configuration (syslinux/syslinux.cfg)
```ini
DEFAULT select
PROMPT 0
TIMEOUT 150
UI vesamenu.c32

MENU TITLE Your Custom Linux Live
MENU BACKGROUND splash.png

LABEL select
MENU LABEL Boot Your Custom Linux (x86_64)
LINUX /%INSTALL_DIR%/boot/x86_64/vmlinuz-linux
INITRD /%INSTALL_DIR%/boot/x86_64/initramfs-linux.img
APPEND archisobasedir=%INSTALL_DIR% archisosearchuuid=%ARCHISO_UUID% cow_spacesize=1G

LABEL select-accessibility
MENU LABEL Boot Your Custom Linux (x86_64) with Speech
LINUX /%INSTALL_DIR%/boot/x86_64/vmlinuz-linux
INITRD /%INSTALL_DIR%/boot/x86_64/initramfs-linux.img
APPEND archisobasedir=%INSTALL_DIR% archisosearchuuid=%ARCHISO_UUID% accessibility=on cow_spacesize=1G

LABEL memtest
MENU LABEL Memory Test
LINUX /%INSTALL_DIR%/boot/memtest86+/memtest.bin
```

---

## Branding and Customization

### 1. Visual Identity

**Boot Splash (syslinux/splash.png)**
- Create a 640x480 PNG image
- Use your brand colors and logo
- Keep text minimal and readable

**Desktop Wallpapers (airootfs/usr/share/backgrounds/)**
```bash
# Organize wallpapers by category
wallpapers/
├── default.jpg          # Default wallpaper
├── nature/             # Nature themed
├── abstract/           # Abstract designs
└── brand/              # Branded wallpapers
```

### 2. Application Branding

**Desktop Entries (airootfs/usr/share/applications/)**
```ini
# your-installer.desktop
[Desktop Entry]
Name=Your Custom Linux Installer
Comment=Install Your Custom Linux to your computer
Exec=your-installer
Icon=installer
Terminal=false
Type=Application
Categories=System;
```

**Custom Icons (airootfs/usr/share/icons/)**
```bash
icons/
├── hicolor/
│   ├── 16x16/apps/
│   ├── 32x32/apps/
│   ├── 48x48/apps/
│   └── scalable/apps/
└── your-theme/
    └── apps/
```

### 3. Theme Configuration

**GTK Theme (airootfs/etc/skel/.config/gtk-3.0/settings.ini)**
```ini
[Settings]
gtk-theme-name=Your-Custom-Theme
gtk-icon-theme-name=Your-Custom-Icons
gtk-font-name=Sans 10
gtk-cursor-theme-name=Your-Custom-Cursors
gtk-cursor-theme-size=24
gtk-toolbar-style=GTK_TOOLBAR_BOTH
gtk-toolbar-icon-size=GTK_ICON_SIZE_LARGE_TOOLBAR
gtk-button-images=1
gtk-menu-images=1
gtk-enable-event-sounds=1
gtk-enable-input-feedback-sounds=1
```

**Qt Theme (airootfs/etc/skel/.config/qt5ct/qt5ct.conf)**
```ini
[Appearance]
color_scheme_path=/usr/share/qt5ct/colors/your-custom.conf
custom_palette=true
icon_theme=Your-Custom-Icons
standard_dialogs=default
style=Fusion

[Fonts]
fixed=@Variant(\0\0\0@\0\0\0\x12\0M\0o\0n\0o\0s\0p\0\x61\0\x63\0\x65@$\0\0\0\0\0\0\xff\xff\xff\xff\x5\x1\0\x32\x10)
general=@Variant(\0\0\0@\0\0\0\x12\0S\0\x61\0n\0s@$\0\0\0\0\0\0\xff\xff\xff\xff\x5\x1\0\x32\x10)
```

---

## Building the ISO

### 1. Build Script (build.sh)
```bash
#!/usr/bin/env bash

# Your Custom Linux ISO Build Script

set -e

# Configuration
ISO_NAME="yourcustomlinux"
BUILD_DIR="/tmp/archiso-build-$(date +%s)"
OUTPUT_DIR="./out"
WORK_DIR="$BUILD_DIR/work"
PROFILE_DIR="$(pwd)"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RESET='\033[0m'

log_info() {
    echo -e "${BLUE}[INFO]${RESET} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${RESET} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${RESET} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${RESET} $1"
}

# Pre-build checks
pre_build_checks() {
    log_info "Running pre-build checks..."
    
    # Check if running as root
    if [ "$EUID" -ne 0 ]; then
        log_error "This script must be run as root (use sudo)"
        exit 1
    fi
    
    # Check required tools
    local required_tools=("mkarchiso" "pacman" "git")
    for tool in "${required_tools[@]}"; do
        if ! command -v "$tool" &> /dev/null; then
            log_error "Required tool not found: $tool"
            exit 1
        fi
    done
    
    # Check profile directory
    if [ ! -f "$PROFILE_DIR/profiledef.sh" ]; then
        log_error "profiledef.sh not found in current directory"
        exit 1
    fi
    
    log_success "Pre-build checks passed"
}

# Clean previous builds
clean_build() {
    log_info "Cleaning previous build artifacts..."
    
    if [ -d "$BUILD_DIR" ]; then
        rm -rf "$BUILD_DIR"
    fi
    
    mkdir -p "$BUILD_DIR"
    mkdir -p "$OUTPUT_DIR"
    
    log_success "Build directory cleaned"
}

# Build ISO
build_iso() {
    log_info "Building ISO image..."
    log_info "Profile: $PROFILE_DIR"
    log_info "Work directory: $WORK_DIR"
    log_info "Output directory: $OUTPUT_DIR"
    
    # Build with mkarchiso
    mkarchiso -v -w "$WORK_DIR" -o "$OUTPUT_DIR" "$PROFILE_DIR"
    
    if [ $? -eq 0 ]; then
        log_success "ISO build completed successfully"
        
        # Find the generated ISO
        local iso_file=$(find "$OUTPUT_DIR" -name "*.iso" -type f | head -n 1)
        if [ -n "$iso_file" ]; then
            local iso_size=$(du -h "$iso_file" | cut -f1)
            log_success "Generated ISO: $iso_file ($iso_size)"
        fi
    else
        log_error "ISO build failed"
        exit 1
    fi
}

# Post-build tasks
post_build() {
    log_info "Running post-build tasks..."
    
    # Calculate checksums
    cd "$OUTPUT_DIR"
    for iso in *.iso; do
        if [ -f "$iso" ]; then
            log_info "Calculating checksums for $iso..."
            sha256sum "$iso" > "${iso}.sha256"
            md5sum "$iso" > "${iso}.md5"
        fi
    done
    
    log_success "Post-build tasks completed"
}

# Main function
main() {
    echo "Your Custom Linux ISO Builder"
    echo "============================="
    
    pre_build_checks
    clean_build
    build_iso
    post_build
    
    log_success "Build process completed!"
    log_info "ISO files are available in: $OUTPUT_DIR"
}

# Handle script arguments
case "${1:-}" in
    "clean")
        log_info "Cleaning build directories..."
        rm -rf /tmp/archiso-build-* ./out
        log_success "Clean completed"
        ;;
    "check")
        pre_build_checks
        log_success "All checks passed"
        ;;
    *)
        main
        ;;
esac
```

### 2. Build Process
```bash
# Make build script executable
chmod +x build.sh

# Run build
sudo ./build.sh

# Clean build (if needed)
sudo ./build.sh clean

# Check prerequisites only
sudo ./build.sh check
```

### 3. Testing the ISO

**Virtual Machine Testing**
```bash
# Using QEMU
qemu-system-x86_64 -enable-kvm -m 2048 -cdrom out/yourcustomlinux-*.iso

# Using VirtualBox
VBoxManage createvm --name "Test-YourCustomLinux" --register
VBoxManage modifyvm "Test-YourCustomLinux" --memory 2048 --vram 128
VBoxManage createhd --filename "Test-YourCustomLinux.vdi" --size 20480
VBoxManage storagectl "Test-YourCustomLinux" --name "SATA" --add sata
VBoxManage storageattach "Test-YourCustomLinux" --storagectl "SATA" --port 0 --device 0 --type hdd --medium "Test-YourCustomLinux.vdi"
VBoxManage storageattach "Test-YourCustomLinux" --storagectl "SATA" --port 1 --device 0 --type dvddrive --medium out/yourcustomlinux-*.iso
```

**Physical Hardware Testing**
```bash
# Write to USB drive (replace /dev/sdX with your USB device)
sudo dd if=out/yourcustomlinux-*.iso of=/dev/sdX bs=4M status=progress oflag=sync

# Or use more user-friendly tools
sudo cp out/yourcustomlinux-*.iso /dev/sdX
sync
```

---

## Advanced Configurations

### 1. Custom Kernel Parameters

**Default Kernel Parameters (profiledef.sh)**
```bash
# Add custom kernel parameters
airootfs_image_tool_options+=(
    '-comp' 'zstd'  # Use Zstandard compression for better performance
    '-Xcompression-level' '22'  # Maximum compression
)

# Custom boot parameters in boot configs
# For example, in efiboot entry:
# options archisobasedir=%INSTALL_DIR% archisosearchuuid=%ARCHISO_UUID% quiet splash
```

### 2. Network Configuration

**Automatic Network Setup (airootfs/etc/systemd/network/20-ethernet.network)**
```ini
[Match]
Name=en*
Name=eth*

[Network]
DHCP=yes
IPv6PrivacyExtensions=yes

[DHCP]
RouteMetric=10
UseMTU=true
```

**Wireless Configuration (airootfs/etc/systemd/network/20-wireless.network)**
```ini
[Match]
Name=wl*

[Network]
DHCP=yes
IPv6PrivacyExtensions=yes

[DHCP]
RouteMetric=20
UseMTU=true
```

### 3. Security Configurations

**Firewall Setup (airootfs/etc/systemd/system/firewall-setup.service)**
```ini
[Unit]
Description=Setup Basic Firewall Rules
After=network.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/setup-firewall
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
```

**Firewall Script (airootfs/usr/local/bin/setup-firewall)**
```bash
#!/usr/bin/env bash

# Basic firewall setup
iptables -F
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

# Allow loopback
iptables -A INPUT -i lo -j ACCEPT

# Allow established connections
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# Allow SSH (if needed)
# iptables -A INPUT -p tcp --dport 22 -j ACCEPT

# Save rules
iptables-save > /etc/iptables/iptables.rules
```

### 4. Automated Configuration

**First Boot Setup (airootfs/etc/systemd/system/first-boot-setup.service)**
```ini
[Unit]
Description=First Boot Configuration
After=multi-user.target
ConditionPathExists=!/var/lib/first-boot-done

[Service]
Type=oneshot
ExecStart=/usr/local/bin/first-boot-setup
ExecStartPost=/usr/bin/touch /var/lib/first-boot-done

[Install]
WantedBy=multi-user.target
```

**First Boot Script (airootfs/usr/local/bin/first-boot-setup)**
```bash
#!/usr/bin/env bash

# First boot configuration script

# Update system clock
timedatectl set-ntp true

# Update package databases
pacman -Sy --noconfirm

# Generate SSH host keys
ssh-keygen -A

# Set up locale if not already configured
if [ ! -f /etc/locale.gen.backup ]; then
    cp /etc/locale.gen /etc/locale.gen.backup
    sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
    locale-gen
fi

# Create default user if in live environment
if [ "$(whoami)" = "root" ] && [ ! -d /home/liveuser ]; then
    useradd -m -G wheel,audio,video,optical,storage -s /bin/bash liveuser
    echo "liveuser:liveuser" | chpasswd
fi

# Start display manager
systemctl enable sddm
systemctl start sddm
```

### 5. Package Hooks

**Custom Pacman Hook (airootfs/etc/pacman.d/hooks/update-desktop-database.hook)**
```ini
[Trigger]
Operation = Install
Operation = Upgrade
Operation = Remove
Type = Path
Target = usr/share/applications/*.desktop

[Action]
Description = Updating desktop file database...
When = PostTransaction
Exec = /usr/bin/update-desktop-database
```

**Wallpaper Update Hook (airootfs/etc/pacman.d/hooks/update-wallpapers.hook)**
```ini
[Trigger]
Operation = Install
Operation = Upgrade
Type = Package
Target = your-wallpaper-package

[Action]
Description = Updating wallpaper cache...
When = PostTransaction
Exec = /usr/local/bin/update-wallpaper-cache
```

---

## Troubleshooting

### Common Build Issues

#### 1. Package Not Found
```bash
# Error: package 'some-package' was not found
# Solution: Check package name and repository availability

# Verify package exists
pacman -Ss package-name

# Check if repository is enabled
grep -A 5 "\[repository-name\]" pacman.conf
```

#### 2. Permission Errors
```bash
# Error: Permission denied
# Solution: Ensure correct permissions in profiledef.sh

file_permissions=(
    ["/path/to/file"]="owner:group:permissions"
)
```

#### 3. Boot Issues
```bash
# Error: Boot loop or kernel panic
# Solution: Check kernel parameters and initramfs

# Verify boot configuration
cat efiboot/loader/entries/*.conf
cat grub/grub.cfg

# Check for missing firmware
pacman -Ql linux-firmware | grep -i "your-hardware"
```

#### 4. Service Failures
```bash
# Error: Service failed to start
# Solution: Check service dependencies and configuration

# Debug systemd service
systemctl status service-name
journalctl -u service-name

# Check service file syntax
systemd-analyze verify /path/to/service.service
```

### Debug Mode Building

**Enable Verbose Building**
```bash
# Build with maximum verbosity
sudo mkarchiso -v -v -w /tmp/archiso-work -o ./out ./

# Keep work directory for inspection
sudo mkarchiso -v -w /tmp/archiso-work -o ./out ./ --keep-work
```

**Inspect Build Process**
```bash
# Check work directory contents
ls -la /tmp/archiso-work/

# Examine airootfs
ls -la /tmp/archiso-work/airootfs/

# Check package installation logs
less /tmp/archiso-work/pacstrap.log
```

### Testing Strategies

#### 1. Component Testing
```bash
# Test individual components
sudo systemd-nspawn -D /tmp/archiso-work/airootfs/ /bin/bash

# Test service files
sudo systemd-analyze verify airootfs/etc/systemd/system/*.service

# Test scripts
sudo bash -n airootfs/usr/local/bin/your-script
```

#### 2. Live Environment Testing
```bash
# Boot with different parameters
# Add to kernel command line:
# systemd.log_level=debug systemd.log_target=console
```

#### 3. Installation Testing
```bash
# Test installation in VM with different configurations
# - UEFI vs BIOS
# - Different filesystems
# - Various disk sizes
# - Different hardware configurations (simulated)
```

---

## Best Practices

### 1. Project Organization

**Version Control**
```bash
# Initialize git repository
git init
git add .
git commit -m "Initial custom ISO setup"

# Create tags for releases
git tag -a v1.0.0 -m "Version 1.0.0 release"

# Use branches for different variants
git checkout -b minimal-variant
git checkout -b gaming-variant
```

**Documentation**
```bash
# Create comprehensive documentation
docs/
├── README.md           # Quick start guide
├── BUILDING.md         # Build instructions
├── CONFIGURATION.md    # Configuration details
├── TROUBLESHOOTING.md  # Common issues
└── CHANGELOG.md        # Version history
```

### 2. Security Considerations

**Package Verification**
```bash
# Always verify package signatures
SigLevel = Required DatabaseOptional

# Use trusted repositories only
# Avoid third-party repositories without verification
```

**File Permissions**
```bash
# Set appropriate permissions in profiledef.sh
file_permissions=(
    ["/etc/shadow"]="0:0:400"        # Shadow file
    ["/etc/gshadow"]="0:0:400"       # Group shadow
    ["/root"]="0:0:750"              # Root home
    ["/home/*"]="1000:1000:755"      # User homes
)
```

**Service Security**
```bash
# Use systemd security features
[Service]
NoNewPrivileges=yes
PrivateTmp=yes
ProtectSystem=strict
ProtectHome=yes
```

### 3. Performance Optimization

**Compression Settings**
```bash
# Optimize for size vs speed trade-off
airootfs_image_tool_options=(
    '-comp' 'zstd'              # Fast compression/decompression
    '-Xcompression-level' '15'   # Good balance
)

# For maximum compression (slower build)
airootfs_image_tool_options=(
    '-comp' 'xz'
    '-Xbcj' 'x86'
    '-Xdict-size' '100%'
)
```

**Package Selection**
```bash
# Include only necessary packages in live environment
# Move optional packages to post-install lists
# Use package groups efficiently
```

### 4. Maintenance

**Regular Updates**
```bash
# Update base packages regularly
# Monitor security advisories
# Test updates in isolated environment
```

**User Feedback**
```bash
# Implement feedback collection
# Monitor installation success rates
# Track common user issues
```

**Automated Testing**
```bash
# Set up CI/CD pipeline for testing
# Automated VM testing
# Regression testing for each build
```

### 5. Distribution Strategy

**Release Management**
```bash
# Use semantic versioning
# Provide checksums and signatures
# Maintain multiple download mirrors
```

**Support Infrastructure**
```bash
# Set up documentation website
# Create user support forums
# Provide installation tutorials
```

---

## Conclusion

This comprehensive guide provides everything needed to create a professional custom Arch Linux ISO distribution. The modular approach allows for easy customization while maintaining compatibility with standard Arch tooling.

### Key Takeaways

1. **Structure**: Follow the archiso framework structure for compatibility
2. **Packages**: Use a combination of official repos, Chaotic AUR, and custom repositories
3. **Configuration**: Organize configurations logically in the airootfs overlay
4. **Testing**: Thoroughly test in various environments before release
5. **Maintenance**: Plan for ongoing updates and user support

### Next Steps

1. Set up your development environment
2. Create your initial profile based on this guide
3. Customize branding and package selection
4. Build and test your first ISO
5. Iterate based on testing feedback
6. Set up distribution infrastructure

Remember to always test thoroughly and consider your users' needs when making configuration decisions. A well-crafted custom ISO can provide an excellent user experience while maintaining the flexibility and power of Arch Linux.
