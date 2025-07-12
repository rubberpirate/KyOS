# KyOS SDDM Default Session Fix - X11 Priority

## Issue
SDDM was defaulting to "Qtile (Wayland)" instead of "Qtile" (X11) on first boot, causing users to see a non-functional desktop environment.

## Root Cause
- SDDM was detecting both X11 and Wayland Qtile sessions
- Without explicit configuration, SDDM was prioritizing Wayland over X11
- Default session configuration wasn't sufficient to override session detection order

## Solutions Implemented

### 1. **Enhanced SDDM Configuration**
**Files Modified:**
- `/etc/sddm.conf` - Global SDDM configuration
- `/etc/sddm.conf.d/kde_settings.conf` - Specific SDDM settings

**Changes:**
- Added `DisplayServer=x11` to force X11 as preferred display server
- Set `DefaultSession=qtile` to explicitly specify default session
- Configured separate session directories for X11 and Wayland
- Added X11 server parameters for proper initialization

### 2. **Custom Session Desktop Files**
**Created:**
- `/usr/share/xsessions/qtile.desktop` - X11 Qtile session
- `/usr/share/wayland-sessions/zzz-qtile-wayland.desktop` - Wayland Qtile session

**Strategy:**
- X11 session named simply "Qtile" for clarity
- Wayland session named "Qtile (Wayland)" to distinguish
- Wayland session file prefixed with "zzz-" to load last alphabetically
- Different execution commands (`qtile start` vs `qtile start -b wayland`)

### 3. **Session Ordering Priority**
**Approach:**
- X11 session loads first due to alphabetical ordering
- Wayland session available but deprioritized
- SDDM configuration explicitly prefers X11
- Default session setting reinforces X11 choice

## Configuration Details

### **Main SDDM Config** (`/etc/sddm.conf`)
```ini
[General]
DisplayServer=x11
DefaultSession=qtile

[X11]
MinimumVT=1
ServerPath=/usr/bin/X
ServerArguments=-nolisten tcp
```

### **Extended SDDM Config** (`/etc/sddm.conf.d/kde_settings.conf`)
```ini
[Autologin]
Session=qtile

[General]
DefaultSession=qtile
DisplayServer=x11

[X11]
SessionDir=/usr/share/xsessions

[Wayland]
SessionDir=/usr/share/wayland-sessions
```

### **X11 Session** (`/usr/share/xsessions/qtile.desktop`)
```ini
[Desktop Entry]
Name=Qtile
Comment=Qtile Window Manager (X11)
Exec=qtile start
```

### **Wayland Session** (`/usr/share/wayland-sessions/zzz-qtile-wayland.desktop`)
```ini
[Desktop Entry]
Name=Qtile (Wayland)
Comment=Qtile Window Manager (Wayland)
Exec=qtile start -b wayland
```

## Expected Results

### **SDDM Session Dropdown:**
1. **Qtile** (X11) - Default and recommended
2. **Qtile (Wayland)** - Available but not default

### **User Experience:**
- First boot automatically selects working X11 session
- Users see functional Qtile desktop immediately
- Wayland option still available for advanced users
- No manual session selection required

## Verification
To test the fix:
1. Boot KyOS live environment
2. Check SDDM login screen session dropdown
3. Verify "Qtile" (not "Qtile (Wayland)") is selected by default
4. Login should result in functional X11 Qtile desktop

## Fallback Options
If issues persist:
- Manual session selection still available in SDDM
- Both X11 and Wayland sessions properly configured
- Session preference stored per-user after manual selection
- System logs available for troubleshooting session startup

This comprehensive fix ensures that KyOS users get a working desktop environment on first boot while maintaining flexibility for advanced users who want Wayland support.
