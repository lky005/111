# HarmonyOS NEXT Minecraft Launcher

A Minecraft Java Edition launcher for HarmonyOS NEXT, inspired by PojavLauncher's mobile design.

## Features

### Core Functionality
- ✅ Launch Minecraft Java Edition on HarmonyOS NEXT
- ✅ Version management (download and install different MC versions)
- ✅ Profile management (multiple game profiles)
- ✅ Settings configuration (memory, display, player settings)
- ✅ Modern mobile-first UI design

### UI Components
- **Main Launch Screen**: PojavLauncher-inspired interface with version selection and launch button
- **Version Manager**: Browse and download Minecraft versions
- **Profile Manager**: Create and manage multiple game profiles
- **Settings**: Configure launcher and game settings

### Technical Architecture
- **Frontend**: HarmonyOS NEXT ArkTS/ETS UI framework
- **Backend**: Java-based launcher logic similar to PojavLauncher
- **Permissions**: Internet, file storage access for game files
- **Multilingual**: Support for English and Chinese

## Project Structure

```
entry/
├── src/main/
│   ├── ets/                    # HarmonyOS UI layer (ArkTS/ETS)
│   │   ├── entryability/       # App entry point
│   │   ├── pages/              # UI pages
│   │   │   ├── Index.ets       # Main launcher screen
│   │   │   ├── GameSettings.ets # Settings page
│   │   │   ├── VersionManager.ets # Version management
│   │   │   └── ProfileManager.ets # Profile management
│   │   └── launcher/           # Launcher bridge
│   │       └── MinecraftLauncher.ets # ETS wrapper
│   ├── java/                   # Java launcher logic
│   │   └── com/mclaunch/launcher/
│   │       ├── MinecraftLauncher.java # Core launcher
│   │       ├── LauncherConfig.java    # Configuration
│   │       ├── VersionManifest.java   # Version handling
│   │       └── ProfileManager.java    # Profile management
│   └── resources/              # App resources
│       ├── base/               # Base resources
│       ├── en_US/              # English strings
│       └── zh_CN/              # Chinese strings
```

## Design Philosophy

This launcher follows PojavLauncher's proven mobile design principles:

1. **Mobile-First UI**: Touch-optimized interface with large buttons and clear navigation
2. **Simplified Workflow**: Easy version selection and one-tap launch
3. **Profile System**: Multiple game configurations for different play styles
4. **Modern Material Design**: Clean, intuitive interface with proper spacing and typography

## Key Features Inspired by PojavLauncher

### Main Screen
- Large, prominent launch button
- Version selector with quick access
- Status indicators and progress bars
- Quick access to profiles and mods

### Version Management
- Visual version list with release/snapshot indicators
- Download progress tracking
- Automatic dependency resolution
- Storage management

### Profile System
- Multiple game instances
- Per-profile settings and configurations
- Playtime tracking
- Profile-specific save data

### Settings
- Memory allocation controls
- Display settings (fullscreen, resolution)
- Player configuration
- Advanced launcher options

## Development Notes

### HarmonyOS NEXT Integration
- Uses HarmonyOS NEXT's native ArkTS/ETS framework
- Implements proper permission handling for file and network access
- Follows HarmonyOS design guidelines and patterns

### Java Backend
- Compatible with standard Minecraft launcher protocols
- Implements Mojang authentication (offline mode for now)
- Handles asset and library downloading
- Manages game launching with proper JVM arguments

### Future Enhancements
- [ ] Microsoft/Mojang account authentication
- [ ] Mod support and mod manager
- [ ] Texture pack management
- [ ] Multiplayer server browser
- [ ] Performance optimization tools
- [ ] Advanced debugging features

## Build and Installation

This is a HarmonyOS NEXT application that requires:
- HarmonyOS NEXT SDK 4.1.0 or later
- DevEco Studio for development
- HarmonyOS NEXT device or emulator for testing

## License

This project is inspired by PojavLauncher and follows similar open-source principles. 
All Minecraft-related assets and protocols remain property of Mojang Studios/Microsoft.