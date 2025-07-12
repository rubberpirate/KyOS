# Complete Guide to Creating KyOS - Custom Arch Linux ISO

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
11. [VirtualBox Compatibility](#virtualbox-compatibility)
12. [Advanced Configurations](#advanced-configurations)
13. [KyOS Rebranding Process](#kyos-rebranding-process)
14. [Troubleshooting](#troubleshooting)
15. [Best Practices](#best-practices)

---

## Overview

This guide provides comprehensive documentation for creating KyOS - a custom Arch Linux ISO distribution based on the archiso framework. Originally forked from DTOS (Derek Taylor's Operating System), KyOS has been completely rebranded and optimized for modern use cases, including VirtualBox compatibility. The ISO includes custom branding, curated package selection, optimized configurations, and intelligent installation scripts.

### What You'll Learn
- Complete archiso project structure for KyOS
- Advanced package management (official repos + AUR + custom packages)
- Custom configuration deployment and user management
- Complete system rebranding from DTOS to KyOS
- VirtualBox compatibility and optimization
- Installation script development with TUI support
- Boot loader configuration for multiple boot methods
- System service management and customization
- Qtile window manager optimization for VMs

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
│   │   │   │   ├── kyos-install      # KyOS installer - Main TUI installer system
│   │   │   │   ├── kyos-welcome      # KyOS welcome app - KyOS-specific welcome application
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

---

## VirtualBox Compatibility

KyOS includes intelligent VirtualBox detection and optimization to ensure a smooth desktop experience in virtualized environments. The system automatically adjusts compositor settings, application startup, and visual effects based on the detected virtualization platform.

### Automatic Detection

The system uses `systemd-detect-virt` to identify VirtualBox and applies appropriate optimizations:

```bash
# Check if running in VirtualBox
if [ "$(systemd-detect-virt)" = "oracle" ]; then
    echo "VirtualBox detected - applying compatibility settings"
    # Apply VirtualBox-specific configurations
fi
```

### VirtualBox-Optimized Files

#### 1. Qtile Autostart Script (`~/.config/qtile/scripts/autostart.sh`)

**Features:**
- Skips picom compositor in VirtualBox (prevents transparency issues)
- Disables problematic applications (eww, volctl) that cause rendering problems
- Maintains essential applications (nm-applet, flameshot, blueman-applet)

```bash
#!/bin/bash

export PATH="/home/user/.local/bin:$PATH"

# Detect if running in VirtualBox
if [ "$(systemd-detect-virt)" = "oracle" ]; then
    echo "VirtualBox detected - using compatibility mode"
    # Skip picom in VirtualBox
else
    # Run picom on real hardware
    picom -b &
fi

# Essential applications that work in VirtualBox
nm-applet &
libinput-gestures-setup restart
flameshot &
blueman-applet &
plank &
dunst &

# Skip problematic applications in VirtualBox
if [ "$(systemd-detect-virt)" != "oracle" ]; then
    eww daemon &
    volctl &
    mkfifo /tmp/vol-icon && ~/.config/qtile/scripts/vol_icon.sh &
fi
```

#### 2. VirtualBox-Safe Picom Configuration (`~/.config/picom.conf`)

**Features:**
- Uses stable xrender backend
- Disables transparency and effects
- Prevents visual artifacts and black bars

```properties
# VirtualBox-compatible picom configuration
backend = "xrender";
vsync = false;

# Disable transparency and shadows
shadow = false;
fading = false;
inactive-opacity = 1.0;
active-opacity = 1.0;
frame-opacity = 1.0;
inactive-opacity-override = false;

# Disable blur and effects
blur-background = false;
corner-radius = 0;

# VirtualBox-friendly settings
mark-wmwin-focused = true;
mark-ovredir-focused = true;
detect-rounded-corners = false;
detect-client-opacity = false;
detect-transient = false;
detect-client-leader = false;
use-damage = false;

# Window type settings - disable all effects
wintypes:
{
  tooltip = { fade = false; shadow = false; opacity = 1.0; focus = true; };
  dock = { shadow = false; fade = false; opacity = 1.0; };
  dnd = { shadow = false; fade = false; opacity = 1.0; };
  popup_menu = { opacity = 1.0; fade = false; shadow = false; };
  dropdown_menu = { opacity = 1.0; fade = false; shadow = false; };
};
```

#### 3. Qtile Bar with VirtualBox Detection (`~/.config/qtile/core/bar.py`)

**Features:**
- Detects VirtualBox environment
- Forces solid backgrounds and full opacity
- Prevents transparency-related rendering issues

```python
import subprocess

def is_virtualbox():
    try:
        result = subprocess.run(['systemd-detect-virt'], capture_output=True, text=True)
        return result.stdout.strip() == 'oracle'
    except:
        return False

# Adjust settings for VirtualBox compatibility
if is_virtualbox():
    bg_color = color["bg"]
    opacity = 1.0
else:
    bg_color = color["bg"] 
    opacity = 0.8

def create_bar(extra_bar=False):
    return bar.Bar(
        [
            # ...bar widgets...
        ],
        30,
        margin=[4, 6, 2, 6],
        background=bg_color,
        opacity=opacity if not is_virtualbox() else 1.0,
    )
```

#### 4. VirtualBox Fix Script (`~/.config/qtile/scripts/vbox-fix.sh`)

**Features:**
- Manual fix utility for VirtualBox issues
- Kills problematic processes
- Restarts Qtile with proper settings

```bash
#!/bin/bash
# VirtualBox Qtile Fix Script

echo "Fixing Qtile for VirtualBox compatibility..."

# Kill compositor and problematic applications
pkill picom
pkill eww
pkill volctl
echo "Stopped problematic applications"

# Restart Qtile
qtile cmd-obj -o cmd -f restart
echo "Restarted Qtile"

# Provide terminal transparency fix instructions
if command -v alacritty &> /dev/null; then
    echo "To fix transparent terminal, edit ~/.config/alacritty/alacritty.yml"
    echo "Set: window.opacity: 1.0"
fi

echo "VirtualBox compatibility fixes applied!"
```

### Installation Integration

The KyOS installer automatically detects VirtualBox during installation and applies appropriate configurations:

```bash
# In kyosinstall script
if systemd-detect-virt | grep -q oracle; then
    echo "VirtualBox detected - installing VirtualBox-optimized configs"
    
    # Install VirtualBox guest additions
    arch_chroot "pacman -S --noconfirm virtualbox-guest-utils"
    arch_chroot "systemctl enable vboxservice"
    
    # Apply VirtualBox-specific configurations
    cp /usr/share/kyos/vbox-configs/* /mnt/home/$username/.config/
fi
```

### Common VirtualBox Issues and Solutions

#### Issue: Black Bars or Visual Artifacts
**Solution:** VirtualBox-optimized picom configuration automatically applied

#### Issue: Transparent Terminal Text Invisible
**Solution:** 
1. Edit terminal configuration (e.g., `~/.config/alacritty/alacritty.yml`)
2. Set `window.opacity: 1.0`
3. Restart terminal application

#### Issue: Desktop Effects Not Working
**Solution:** Effects are automatically disabled in VirtualBox for stability

#### Issue: Poor Performance
**Solution:** 
1. Ensure VirtualBox Guest Additions are installed
2. Allocate sufficient video memory (128MB recommended)
3. Enable 3D acceleration in VirtualBox settings

### Manual VirtualBox Optimization

For existing installations, copy these files to fix VirtualBox issues:

```bash
# Copy VirtualBox-optimized configurations
cp /path/to/kyos-files/autostart.sh ~/.config/qtile/scripts/
cp /path/to/kyos-files/picom.conf ~/.config/
cp /path/to/kyos-files/bar.py ~/.config/qtile/core/
cp /path/to/kyos-files/vbox-fix.sh ~/.config/qtile/scripts/

# Make fix script executable
chmod +x ~/.config/qtile/scripts/vbox-fix.sh

# Run the fix script
~/.config/qtile/scripts/vbox-fix.sh
```

### Testing VirtualBox Compatibility

**Recommended VirtualBox Settings:**
- RAM: 4GB minimum, 8GB recommended
- Video Memory: 128MB
- 3D Acceleration: Enabled
- 2D Video Acceleration: Enabled
- Storage: 40GB minimum

**Test Checklist:**
- [ ] Desktop loads without black bars
- [ ] Terminal text is visible
- [ ] Window decorations render properly
- [ ] Basic applications launch successfully
- [ ] Network connectivity works
- [ ] Audio functions properly
- [ ] File manager operates correctly

---
## KyOS Rebranding Process

This section documents the complete rebranding process from DTOS to KyOS, including all file changes, script updates, and configuration modifications.

### Overview of Changes

**Complete Rebranding:**
- All user-facing text changed from DTOS to KyOS
- Boot loader messages updated to KyOS
- Installation scripts renamed and updated
- Welcome applications rebranded
- Configuration paths updated
- Default credentials changed to KyOS defaults

**Package Management:**
- Removed all DTOS-specific packages
- Added user-specified packages from packages.txt
- Maintained compatibility with DTOS repositories where needed
- Optimized package conflicts (pipewire-jack vs jack2)

**VirtualBox Compatibility:**
- Added automatic VirtualBox detection
- Implemented VirtualBox-specific configurations
- Created compatibility fixes for common issues

### Rebranding Checklist

#### Core System Files
- [x] `/etc/os-release` - Updated OS name and branding
- [x] `/etc/motd` - Updated welcome message
- [x] `/etc/hostname` - Changed default hostname to kyos-pc
- [x] Boot loader configurations (GRUB, syslinux, systemd-boot)
- [x] Installation scripts renamed (dtosinstall → kyosinstall)

#### User Interface Elements
- [x] Welcome application branding
- [x] Installer prompts and messages
- [x] Desktop environment themes
- [x] Wallpapers and branding graphics
- [x] Application launcher entries

#### Configuration Paths
- [x] Config directory references
- [x] Script path updates
- [x] Theme and background paths
- [x] User profile templates

#### Package Lists
- [x] Removed DTOS packages from pkgs-base
- [x] Removed DTOS packages from pkgs-qtile
- [x] Added user-specified packages avoiding duplicates
- [x] Excluded Wayland-specific packages
- [x] Maintained essential system packages

#### Scripts and Executables
- [x] Renamed installation scripts
- [x] Updated script internal references
- [x] Changed default usernames and passwords
- [x] Updated variable names and functions

### File Mapping

#### Renamed Files
```
Old Location                                    New Location
/usr/local/bin/dtosinstall                 →   /usr/local/bin/kyos-install (unified TUI installer)
/usr/local/bin/dtosinstall-auto            →   /usr/local/bin/kyosinstall-auto (backend)
/usr/local/bin/dtosinstall-tui             →   /usr/local/bin/kyos-install (main installer)
/opt/dtos-welcome/                         →   /opt/kyos-welcome/
```

#### Updated Content Files
```
File                          Change
/etc/os-release              OS name and branding
/etc/motd                    Welcome message
/etc/hostname                Default hostname
/grub/grub.cfg              Boot menu entries
/syslinux/*.cfg             Boot menu entries
/efiboot/loader/entries/*.conf  Boot entries
airootfs/root/pkgs-*        Package lists
```

### Script Updates

#### Installation Scripts
### KyOS Installation System

KyOS now features a unified, professional installation system with the following components:

#### Main Installer: `kyos-install`
- **Unified TUI Interface**: Single command for all installation needs
- **Professional Design**: Modern gum-based interface with KyOS branding
- **Dual Modes**: Automated (quick) and Interactive (full control) installation modes
- **Integrated Features**: BlackArch tools and NVIDIA driver support built-in
- **VirtualBox Optimization**: Automatic detection and optimization for VMs
- **Help System**: Built-in help and documentation (`kyos-install --help`)

#### Backend System: `kyos-install-backend`
- **Installation Engine**: Handles the actual installation process
- **Configuration Integration**: Reads TUI configuration seamlessly
- **Error Recovery**: Robust error handling and package management
- **Repository Management**: Chaotic AUR and BlackArch integration

#### Command Usage:
```bash
# Main installer (recommended)
sudo kyos-install

# Show help documentation
kyos-install --help

# Show version information  
kyos-install --version

# Legacy compatibility (launches kyos-install)
sudo installer
```

#### Installation Process:
1. **Welcome Screen**: Professional KyOS branding and mode selection
2. **System Configuration**: Timezone, locale, keyboard layout
3. **User Setup**: Username, passwords, hostname
4. **Advanced Options**: BlackArch tools, NVIDIA drivers
5. **Disk Configuration**: Partitioning, encryption, filesystem choice
6. **Final Review**: Complete configuration summary
7. **Installation**: Automated installation with progress feedback
8. **Completion**: System ready for reboot

**kyosinstall-tui** (formerly dtosinstall-tui):
- Updated TUI interface branding
- Improved user input validation
- Added support for custom username/password/hostname
- Enhanced package installation error handling

**kyosinstall-auto** (formerly dtosinstall-auto):
- Automated installation with KyOS defaults
- VirtualBox optimization integration
- Improved post-installation configuration

### Package Management Changes

#### Removed Packages
All DTOS-specific packages were removed:
```
dtos-*                 # All DTOS branded packages
dtos-core-repo         # DTOS repository configuration
dtos-welcome           # DTOS welcome application
```

#### Added Packages
User-specified packages from packages.txt were added:
```
# Selected packages avoiding duplicates and Wayland conflicts
# See packages.txt for complete list
```

#### Conflict Resolution
**pipewire-jack vs jack2:**
- Removed conflicting audio packages
- Standardized on pipewire-jack
- Added explicit package removal in installer

**AUR Package Handling:**
- Improved chaotic-aur repository setup
- Added fallback mirrors for reliability
- Enhanced keyring management

### VirtualBox Integration

#### Automatic Detection
```bash
# Detect VirtualBox environment
if [ "$(systemd-detect-virt)" = "oracle" ]; then
    # Apply VirtualBox-specific configurations
fi
```

#### Optimized Configurations
- **Autostart Script**: Skips problematic applications in VirtualBox
- **Picom Config**: Uses stable backend with disabled effects
- **Qtile Bar**: Forces solid backgrounds and full opacity
- **Fix Script**: Manual utility for troubleshooting

### Testing and Validation

#### Installation Testing
- [x] Automated installation works correctly
- [x] TUI installation accepts user input
- [x] User credentials are set properly
- [x] Hostname configuration works
- [x] Package installation completes successfully

#### VirtualBox Testing
- [x] Desktop loads without visual artifacts
- [x] Terminal text is visible
- [x] Applications launch successfully
- [x] Network connectivity functions
- [x] Audio works properly

#### Compatibility Testing
- [x] Works on real hardware
- [x] Functions in VirtualBox
- [x] Compatible with different VM configurations
- [x] Handles various disk configurations

### Maintenance and Updates

#### Ongoing Tasks
- Monitor package conflicts
- Update VirtualBox compatibility as needed
- Maintain installer script functionality
- Update documentation and guides

#### Version Control
- All changes tracked in git
- Separate branches for major updates
- Tagged releases for stable versions

### Distribution Preparation

#### ISO Building
```bash
# Build KyOS ISO
cd /path/to/kyos-iso/releng
sudo mkarchiso -v -w /tmp/kyos-work -o /tmp/kyos-out .
```

#### Testing Checklist
- [ ] ISO boots successfully
- [ ] Live environment functions properly
- [ ] Installation completes without errors
- [ ] Installed system boots correctly
- [ ] VirtualBox compatibility works
- [ ] All KyOS branding appears correctly

---
## Conclusion

This comprehensive guide provides everything needed to create KyOS - a professional custom Arch Linux ISO distribution with complete rebranding, VirtualBox optimization, and modern package management. The modular approach allows for easy customization while maintaining compatibility with standard Arch tooling.

### Key Takeaways

1. **Complete Rebranding**: Successfully transformed DTOS into KyOS with comprehensive branding updates
2. **VirtualBox Compatibility**: Intelligent detection and optimization for virtualized environments
3. **Package Management**: Advanced conflict resolution and AUR integration
4. **Installation System**: Robust TUI and automated installers with user customization
5. **Maintenance**: Ongoing update process and compatibility testing

### KyOS Features

- **Intelligent Environment Detection**: Automatic VirtualBox optimization
- **User-Friendly Installation**: TUI installer with custom username/password/hostname support
- **Optimized Package Selection**: Curated package lists avoiding conflicts
- **Professional Branding**: Complete visual and textual rebranding
- **Robust Error Handling**: Advanced installation error recovery
- **Modern Desktop**: Qtile window manager optimized for both hardware and VMs

### Next Steps

1. **Development**: Set up KyOS development environment
2. **Customization**: Further customize based on specific requirements
3. **Testing**: Thorough testing in various environments
4. **Distribution**: Set up distribution infrastructure for KyOS releases
5. **Community**: Establish user support and feedback channels
6. **Updates**: Plan regular updates and security patches

### Support and Resources

- **Installation Issues**: Use the comprehensive troubleshooting guides
- **VirtualBox Problems**: Apply the VirtualBox compatibility fixes
- **Package Conflicts**: Follow the conflict resolution procedures
- **Customization**: Reference the rebranding process documentation

KyOS represents a modern, optimized Arch Linux distribution suitable for both newcomers and experienced users, with particular strength in virtualized environments.

---

*This guide documents the complete transformation from DTOS to KyOS, including all technical implementations, VirtualBox optimizations, and distribution processes. Last updated: June 2025*
