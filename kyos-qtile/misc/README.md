# KyOS Miscellaneous Files

This directory contains all miscellaneous files, documentation, scripts, and configurations that are not part of the core ISO build process but are related to the KyOS project.

## Directory Structure

```
misc/
├── docs/           # Project documentation, whitepapers, and README files
├── scripts/        # Utility scripts, test scripts, and build helpers
├── configs/        # Configuration templates and package lists
└── kyos.png        # KyOS logo file
```

## Contents

### docs/
Contains all project-level documentation including:
- **README files**: Project documentation and setup guides
- **Whitepapers**: Technical documentation and development notes
- **Development logs**: Progress tracking and implementation notes
- **LaTeX files**: Source files for technical documentation

### scripts/
Contains utility and development scripts including:
- **buildiso.sh**: ISO building script
- **test-launcher.sh**: Testing utilities
- **verify-kyos-setup.sh**: System verification scripts
- **compile-whitepaper.sh**: Documentation compilation scripts
- **strap.sh**: Legacy installation script

### configs/
Contains configuration templates and package lists:
- **packages.txt**: Package list templates
- **packages2.txt**: Additional package configurations

## Usage

These files are primarily for development, testing, and documentation purposes. They are not included in the final ISO build but provide important context and tools for the KyOS development process.

## Organization

All files in this directory have been moved here to keep the main project structure clean and focused on the ISO build process. The core ISO build files remain in their original locations:

- `/releng/` - Core ISO build configuration
- `/website/` - KyOS website and documentation
- `/output/` - Build output directory

---

**Note**: This directory structure helps maintain a clean separation between production ISO build files and development/documentation materials.
