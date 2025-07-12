#!/bin/bash
# KyOS Setup Verification Script
# This script verifies that all KyOS components are properly configured

echo "=== KyOS Setup Verification ==="
echo "Checking configuration files and setup..."

# Check installer scripts exist and are executable
echo
echo "Checking installer scripts:"
for script in kyosinstall kyosinstall-auto kyos-install-backend install-sddm-theme; do
    if [ -f "airootfs/usr/local/bin/$script" ] && [ -x "airootfs/usr/local/bin/$script" ]; then
        echo "✓ $script exists and is executable"
    else
        echo "✗ $script missing or not executable"
    fi
done

# Check SDDM configuration
echo
echo "Checking SDDM configuration:"
if grep -q "DefaultSession=qtile" airootfs/etc/sddm.conf.installer-only 2>/dev/null; then
    echo "✓ SDDM config sets qtile as default session (installer-only)"
elif grep -q "DefaultSession=qtile" airootfs/etc/sddm.conf 2>/dev/null; then
    echo "✓ SDDM config sets qtile as default session"
else
    echo "✗ SDDM config issue"
fi

if grep -q "Current=sddm-astronaut-theme" airootfs/etc/sddm.conf.d.installer-only/kde_settings.conf 2>/dev/null; then
    echo "✓ SDDM theme configuration is correct (installer-only)"
elif grep -q "Current=sddm-astronaut-theme" airootfs/etc/sddm.conf.d/kde_settings.conf 2>/dev/null; then
    echo "✓ SDDM theme configuration is correct"
else
    echo "✗ SDDM theme configuration issue"
fi

# Check session files
echo
echo "Checking session files:"
if [ -f "airootfs/usr/share/xsessions/qtile.desktop" ]; then
    echo "✓ Qtile X11 session file exists"
else
    echo "⚠ Qtile X11 session file missing (packages will provide)"
fi

if [ -f "airootfs/usr/share/wayland-sessions/zzz-qtile-wayland.desktop" ]; then
    echo "✓ Qtile Wayland session file exists (with zzz prefix for deprioritization)"
else
    echo "⚠ Qtile Wayland session file missing (packages will provide)"
fi

# Check live environment setup
echo
echo "Checking live environment:"
if grep -q "autologin live" airootfs/etc/systemd/system/getty@tty1.service.d/autologin.conf 2>/dev/null; then
    echo "✓ Live user auto-login configured"
else
    echo "✗ Live user auto-login not configured"
fi

if [ -f "airootfs/home/live/.bash_profile" ]; then
    echo "✓ Live user profile exists"
else
    echo "✗ Live user profile missing"
fi

if [ -d "airootfs/etc/systemd/system/graphical.target.wants" ]; then
    if ls airootfs/etc/systemd/system/graphical.target.wants/ | grep -q display-manager; then
        echo "⚠ SDDM still enabled in graphical target (should be removed for live environment)"
    else
        echo "✓ No display manager in graphical target (live environment uses direct login)"
    fi
else
    echo "✓ No graphical target wants directory (clean live environment)"
fi

# Check SDDM theme assets
echo
echo "Checking SDDM theme assets:"
if [ -d "airootfs/usr/local/share/kyos-assets/sddm-astronaut-theme" ]; then
    echo "✓ SDDM astronaut theme assets exist"
    if [ -f "airootfs/usr/local/share/kyos-assets/sddm-astronaut-theme/Main.qml" ]; then
        echo "✓ Main.qml theme file exists"
    else
        echo "✗ Main.qml theme file missing"
    fi
else
    echo "✗ SDDM theme assets missing"
fi

# Check KyOS branding assets
echo
echo "Checking KyOS branding:"
if [ -f "airootfs/usr/local/share/kyos-assets/kyos.png" ]; then
    echo "✓ KyOS logo exists"
else
    echo "✗ KyOS logo missing"
fi

# Check that problematic SDDM files were removed
echo
echo "Checking for file conflicts:"
sddm_conflicts=0
for dir in faces flags themes; do
    if [ -d "airootfs/usr/share/sddm/$dir" ]; then
        echo "⚠ SDDM $dir directory exists (potential package conflict)"
        sddm_conflicts=$((sddm_conflicts + 1))
    else
        echo "✓ SDDM $dir directory not present (no conflict)"
    fi
done

if [ $sddm_conflicts -eq 0 ]; then
    echo "✓ No SDDM file conflicts detected"
else
    echo "⚠ $sddm_conflicts potential SDDM file conflicts detected"
fi

# Check packages files
echo
echo "Checking package lists:"
for pkgfile in packages.x86_64 bootstrap_packages.x86_64; do
    if [ -f "$pkgfile" ]; then
        echo "✓ $pkgfile exists"
    else
        echo "✗ $pkgfile missing"
    fi
done

# Check launcher script functionality
echo
echo "Checking kyosinstall launcher script:"
launcher_script="airootfs/usr/local/bin/kyosinstall"
if [ -f "$launcher_script" ]; then
    echo "✓ kyosinstall launcher script exists"
    
    if [ -x "$launcher_script" ]; then
        echo "✓ kyosinstall is executable"
    else
        echo "✗ kyosinstall is not executable"
    fi
    
    # Test help functionality
    if bash -n "$launcher_script" 2>/dev/null; then
        echo "✓ kyosinstall syntax is valid"
    else
        echo "✗ kyosinstall has syntax errors"
    fi
    
    # Check if it references the correct installer scripts
    if grep -q "kyosinstall-auto" "$launcher_script" && grep -q "kyos-install" "$launcher_script"; then
        echo "✓ kyosinstall references correct installer scripts"
    else
        echo "✗ kyosinstall missing references to installer scripts"
    fi
    
    # Check for proper privilege escalation handling
    if grep -q "escalate_privileges" "$launcher_script" && grep -q "check_root" "$launcher_script"; then
        echo "✓ kyosinstall includes privilege escalation handling"
    else
        echo "✗ kyosinstall missing privilege escalation handling"
    fi
else
    echo "✗ kyosinstall launcher script missing"
fi

# Check dual boot functionality
echo
echo "Checking dual boot partitioning features:"
tui_installer="airootfs/usr/local/bin/kyos-install"
if [ -f "$tui_installer" ]; then
    if grep -q "PartitioningModeSelection" "$tui_installer"; then
        echo "✓ Partitioning mode selection implemented"
    else
        echo "✗ Partitioning mode selection missing"
    fi
    
    if grep -q "DualBootSetup" "$tui_installer"; then
        echo "✓ Dual boot setup function exists"
    else
        echo "✗ Dual boot setup function missing"
    fi
    
    if grep -q "ManualPartitioning" "$tui_installer"; then
        echo "✓ Manual partitioning function exists"
    else
        echo "✗ Manual partitioning function missing"
    fi
    
    if grep -q "CheckUnallocatedSpace" "$tui_installer"; then
        echo "✓ Unallocated space detection implemented"
    else
        echo "✗ Unallocated space detection missing"
    fi
    
    if grep -q "partitioning_mode=" "$tui_installer"; then
        echo "✓ Partitioning mode variables defined"
    else
        echo "✗ Partitioning mode variables missing"
    fi
else
    echo "✗ TUI installer script missing"
fi

# Check whitepaper
echo
echo "Checking documentation:"
if [ -f "KyOS-Technical-Whitepaper.tex" ]; then
    echo "✓ KyOS Technical Whitepaper exists"
else
    echo "✗ KyOS Technical Whitepaper missing"
fi

echo
echo "=== Verification Complete ==="
echo "If all items show ✓, KyOS is properly configured."
echo "Items marked with ⚠ are warnings that should be reviewed."
echo "Items marked with ✗ are errors that need to be fixed."
