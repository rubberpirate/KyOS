#!/bin/bash

# KyOS Launcher Test Script
# Tests the kyosinstall launcher script functionality

test_dir="/tmp/kyos-launcher-test"
launcher_script="/home/rubberpirate/dtos-iso/dtos-qtile/releng/airootfs/usr/local/bin/kyosinstall"

echo "=== Testing KyOS Launcher Script ==="
echo

# Test 1: Script exists and is executable
echo "Test 1: Script existence and permissions"
if [ -f "$launcher_script" ]; then
    echo "✓ Launcher script exists"
else
    echo "✗ Launcher script missing"
    exit 1
fi

if [ -x "$launcher_script" ]; then
    echo "✓ Launcher script is executable"
else
    echo "✗ Launcher script is not executable"
    exit 1
fi

# Test 2: Syntax check
echo
echo "Test 2: Syntax validation"
if bash -n "$launcher_script" 2>/dev/null; then
    echo "✓ Script syntax is valid"
else
    echo "✗ Script has syntax errors"
    exit 1
fi

# Test 3: Help option
echo
echo "Test 3: Help functionality"
help_output=$("$launcher_script" --help 2>&1)
if echo "$help_output" | grep -q "Dragon Arch Installer"; then
    echo "✓ Help output contains correct branding"
else
    echo "✗ Help output missing branding"
fi

if echo "$help_output" | grep -q "Usage:"; then
    echo "✓ Help shows usage information"
else
    echo "✗ Help missing usage information"
fi

# Test 4: Version option
echo
echo "Test 4: Version functionality"
version_output=$("$launcher_script" --version 2>&1)
if echo "$version_output" | grep -q "Version: 2.0.0"; then
    echo "✓ Version output correct"
else
    echo "✗ Version output incorrect"
fi

# Test 5: Invalid option handling
echo
echo "Test 5: Invalid option handling"
invalid_output=$("$launcher_script" --invalid-option 2>&1)
if echo "$invalid_output" | grep -q "Unknown option"; then
    echo "✓ Invalid options are handled correctly"
else
    echo "✗ Invalid options not handled properly"
fi

# Test 6: Required script references
echo
echo "Test 6: Required script references"
if grep -q "/usr/local/bin/kyosinstall-auto" "$launcher_script"; then
    echo "✓ References kyosinstall-auto"
else
    echo "✗ Missing reference to kyosinstall-auto"
fi

if grep -q "/usr/local/bin/kyos-install" "$launcher_script"; then
    echo "✓ References kyos-install (TUI)"
else
    echo "✗ Missing reference to kyos-install"
fi

# Test 7: Privilege escalation handling
echo
echo "Test 7: Privilege escalation code"
if grep -q "escalate_privileges" "$launcher_script"; then
    echo "✓ Contains privilege escalation function"
else
    echo "✗ Missing privilege escalation function"
fi

if grep -q "check_root" "$launcher_script"; then
    echo "✓ Contains root check function"
else
    echo "✗ Missing root check function"
fi

if grep -q "sudo\|doas" "$launcher_script"; then
    echo "✓ Uses sudo/doas for privilege escalation"
else
    echo "✗ Missing sudo/doas usage"
fi

# Test 8: Mode selection
echo
echo "Test 8: Mode selection functionality"
if grep -q "select_mode" "$launcher_script"; then
    echo "✓ Contains mode selection function"
else
    echo "✗ Missing mode selection function"
fi

if grep -q "\-\-auto.*\-\-tui" "$launcher_script"; then
    echo "✓ Supports both auto and TUI modes"
else
    echo "✗ Missing auto/TUI mode support"
fi

echo
echo "=== Test Summary ==="
echo "All launcher script tests completed."
echo "If all items show ✓, the launcher is working correctly."
echo
echo "=== Usage Test ==="
echo "To test the launcher manually:"
echo "  ./kyosinstall --help     # Show help"
echo "  ./kyosinstall --version  # Show version"
echo "  ./kyosinstall --auto     # Test auto mode (requires root)"
echo "  ./kyosinstall --tui      # Test TUI mode (requires root)"
echo "  ./kyosinstall            # Test interactive mode selection"
