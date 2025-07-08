# HarmonyOS NEXT Minecraft Launcher

A native Minecraft Java Edition launcher for HarmonyOS NEXT devices, inspired by PojavLauncher's proven mobile design principles.

## Features

### Core Functionality
- ✅ Launch Minecraft Java Edition on HarmonyOS NEXT devices
- ✅ Version management (download and install different MC versions)
- ✅ Profile management (multiple game configurations)
- ✅ Settings configuration (memory, display, player settings)
- ✅ Modern mobile-first UI with HarmonyOS NEXT design guidelines
- ✅ Data persistence using HarmonyOS Preferences API
- ✅ Comprehensive error handling and logging
- ✅ Internationalization support (English/Chinese)

### Technical Architecture
- **Frontend**: HarmonyOS NEXT ArkTS/ETS framework with Material Design
- **Backend**: Java-based launcher logic with enhanced error handling
- **Data Management**: HarmonyOS Preferences API for configuration persistence
- **Permissions**: Proper permission handling with user-friendly explanations
- **Logging**: Structured logging using HarmonyOS hilog API
- **Build System**: HarmonyOS DevEco Studio with Hvigor build tools

### UI Components
- **Main Launch Screen**: Touch-optimized interface with version selection and one-tap launch
- **Version Manager**: Visual version list with release/snapshot indicators and download progress
- **Profile Manager**: Multiple game instances with per-profile configurations
- **Settings**: Comprehensive configuration panel with validation and presets
- **Error Handling**: User-friendly error messages with recovery suggestions

## Project Structure

```
harmonyos-minecraft-launcher/
├── entry/                          # Main application module
│   ├── src/main/
│   │   ├── ets/                    # HarmonyOS UI layer (ArkTS/ETS)
│   │   │   ├── entryability/       # App entry point with lifecycle management
│   │   │   │   └── EntryAbility.ets
│   │   │   ├── pages/              # UI pages with modern design
│   │   │   │   ├── Index.ets       # Main launcher screen
│   │   │   │   ├── GameSettings.ets # Comprehensive settings page
│   │   │   │   ├── VersionManager.ets # Version management
│   │   │   │   └── ProfileManager.ets # Profile management
│   │   │   └── launcher/           # Launcher bridge with data persistence
│   │   │       └── MinecraftLauncher.ets # ETS wrapper with Preferences API
│   │   ├── java/                   # Java launcher logic
│   │   │   └── com/mclaunch/launcher/
│   │   │       ├── MinecraftLauncher.java # Core launcher with enhanced error handling
│   │   │       ├── LauncherConfig.java    # Configuration management
│   │   │       ├── AssetManager.java      # Asset and library management
│   │   │       ├── VersionManifest.java   # Version handling with caching
│   │   │       └── ProfileManager.java    # Profile management
│   │   ├── resources/              # App resources with i18n
│   │   │   ├── base/               # Base resources (colors, media)
│   │   │   ├── en_US/              # English strings
│   │   │   └── zh_CN/              # Chinese strings
│   │   └── module.json5            # HarmonyOS NEXT module configuration
│   ├── obfuscation-rules.txt       # ProGuard rules for release builds
│   ├── consumer-rules.txt          # Library consumer rules
│   └── package.json                # Node.js package configuration
├── hvigor/                         # Build system configuration
│   └── hvigor-config.json5         # HarmonyOS build configuration
├── build-profile.json5             # Build profiles and targets
├── oh-package.json5                # HarmonyOS package configuration
└── README.md                       # This file
```

## Design Philosophy

This launcher follows PojavLauncher's proven mobile design principles while adhering to HarmonyOS NEXT guidelines:

1. **Mobile-First UI**: Touch-optimized interface with large buttons and clear navigation
2. **HarmonyOS Design Language**: Follows official HarmonyOS NEXT design system
3. **Simplified Workflow**: Easy version selection and one-tap launch experience
4. **Profile System**: Multiple game configurations for different play styles
5. **Material Design**: Clean, intuitive interface with proper spacing and typography
6. **Accessibility**: Full accessibility support with proper descriptions and navigation
7. **Performance**: Optimized rendering and smooth animations

## Key Features Inspired by PojavLauncher

### Main Screen
- Large, prominent launch button with loading states
- Version selector with quick access and visual indicators
- Status indicators and progress bars with smooth animations
- Quick access to profiles and mods (coming soon)
- Launch statistics and usage analytics

### Version Management
- Visual version list with release/snapshot indicators
- Download progress tracking with detailed feedback
- Automatic dependency resolution and validation
- Storage management and cleanup utilities
- Offline mode with cached version data

### Profile System
- Multiple game instances with unique configurations
- Per-profile settings and memory allocation
- Playtime tracking and usage statistics
- Profile-specific save data management
- Import/export functionality (planned)

### Settings
- Memory allocation controls with validation
- Display settings (fullscreen, resolution presets)
- Player configuration with input validation
- Advanced launcher options and debugging
- System information and diagnostics

## Development Notes

### HarmonyOS NEXT Integration
- Uses HarmonyOS NEXT's native ArkTS/ETS framework
- Implements proper permission handling with user explanations
- Follows HarmonyOS design guidelines and accessibility standards
- Uses HarmonyOS Preferences API for data persistence
- Implements proper lifecycle management and resource cleanup
- Enhanced error handling with hilog integration

### Java Backend
- Compatible with standard Minecraft launcher protocols
- Implements Mojang authentication (offline mode supported)
- Handles asset and library downloading with resume capability
- Manages game launching with proper JVM arguments
- Enhanced HTTP handling with timeouts and retry logic
- Comprehensive logging and error reporting

### Build System
- HarmonyOS DevEco Studio integration
- Hvigor build system with optimization
- ProGuard obfuscation for release builds
- Multi-language resource compilation
- Automated testing and quality checks

### Data Management
- HarmonyOS Preferences API for configuration storage
- Automatic backup and restoration of settings
- Version-specific profile management
- Launch statistics and analytics
- Offline capability with local caching

## System Requirements

### Development Environment
- **HarmonyOS NEXT SDK**: 4.1.0(11) or later
- **DevEco Studio**: Latest version with ArkTS support
- **Java Development Kit**: OpenJDK 17 or later
- **Node.js**: 16.x or later (for build tools)

### Target Devices
- **HarmonyOS Version**: NEXT 4.1.0 or later
- **Device Types**: Phone, Tablet, 2-in-1 devices
- **RAM**: Minimum 4GB, Recommended 6GB or more
- **Storage**: 2GB free space for Minecraft installations
- **Network**: Internet connection for downloading game files

### Permissions Required
- **Internet Access**: Download Minecraft versions and assets
- **File Storage**: Store game files and user data
- **File Management**: Manage Minecraft installations and saves

## Build and Installation

### Prerequisites
1. Install HarmonyOS NEXT SDK 4.1.0+ through DevEco Studio
2. Configure signing certificates for your development environment
3. Ensure target device has Developer Mode enabled

### Building from Source
```bash
# Clone the repository
git clone https://github.com/your-username/harmonyos-minecraft-launcher.git
cd harmonyos-minecraft-launcher

# Build the project (requires DevEco Studio)
hvigorw assembleHap

# Install on connected device
hvigorw installHapDebug
```

### Development Setup
1. Open the project in DevEco Studio
2. Sync project dependencies
3. Configure signing profile
4. Connect HarmonyOS device or start emulator
5. Run the application

## Future Enhancements

### Planned Features
- [ ] Microsoft/Mojang account authentication
- [ ] Mod support and mod manager integration
- [ ] Texture pack management and preview
- [ ] Multiplayer server browser
- [ ] Performance optimization tools
- [ ] Advanced debugging and diagnostic features
- [ ] Cloud save synchronization
- [ ] Custom control schemes for touch devices

### Technical Improvements
- [ ] Enhanced caching and offline capabilities
- [ ] Background download management
- [ ] Improved memory management
- [ ] Multi-threading optimization
- [ ] Advanced error recovery
- [ ] Automated update system

## Contributing

### Development Guidelines
1. Follow HarmonyOS NEXT coding standards
2. Use proper TypeScript/ArkTS typing
3. Implement comprehensive error handling
4. Add internationalization for new strings
5. Include accessibility descriptions
6. Write unit tests for critical functionality

### Code Style
- Use consistent indentation (2 spaces)
- Follow HarmonyOS naming conventions
- Add comprehensive documentation
- Use structured logging with hilog
- Implement proper resource cleanup

## Troubleshooting

### Common Issues
1. **Permission Denied**: Ensure all required permissions are granted in device settings
2. **Network Errors**: Check internet connection and firewall settings
3. **Launch Failures**: Verify Java installation and memory allocation
4. **Storage Issues**: Check available space and file permissions

### Debug Information
- Enable developer options on target device
- Use DevEco Studio debugger for step-through debugging
- Check hilog output for detailed error messages
- Monitor memory usage and performance metrics

## License

This project is inspired by PojavLauncher and follows similar open-source principles. 
All Minecraft-related assets and protocols remain property of Mojang Studios/Microsoft.

### Third-Party Acknowledgments
- **PojavLauncher**: Original inspiration and design concepts
- **Mojang Studios**: Minecraft game and launcher protocols
- **HarmonyOS Team**: Development framework and design guidelines

## Support

For issues, suggestions, or contributions:
- Create an issue on GitHub
- Follow HarmonyOS development guidelines
- Test on actual HarmonyOS NEXT devices
- Provide detailed reproduction steps for bugs

---

**Note**: This launcher is designed specifically for HarmonyOS NEXT and may not be compatible with other platforms. Ensure you have proper licensing for Minecraft Java Edition before use.