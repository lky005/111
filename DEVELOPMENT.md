# Development Guide

## Quick Start

### Prerequisites
- HarmonyOS DevEco Studio 4.0+
- HarmonyOS Next SDK (API Level 17)
- Node.js 16+
- At least 8GB RAM for development
- HarmonyOS Next device or emulator

### Setup
1. Clone the repository
2. Open in DevEco Studio
3. Install dependencies: `npm install`
4. Build the project: `./build.sh` or use DevEco Studio

### Architecture Overview

```
entry/
├── src/main/ets/
│   ├── entryability/          # Application entry point
│   ├── pages/                 # UI pages
│   │   ├── Index.ets         # Main page
│   │   ├── LauncherPage.ets  # Launch interface
│   │   └── SettingsPage.ets  # Settings
│   ├── utils/                 # Core utilities
│   │   ├── MinecraftLauncher.ets
│   │   ├── JavaRuntimeManager.ets
│   │   ├── MinecraftVersionManager.ets
│   │   └── FileSystemManager.ets
│   ├── workers/               # Background workers
│   │   └── MinecraftWorker.ets
│   └── common/
│       └── constants/
│           └── AppConstants.ets
```

## Key Components

### MinecraftLauncher
The main launcher class that orchestrates the entire launch process:
- Initializes Java runtime
- Downloads and manages Minecraft versions
- Handles file system operations
- Provides launch events and progress tracking

### JavaRuntimeManager
Manages Java runtime environment for HarmonyOS Next:
- Downloads and installs Java runtime
- Validates Java installation
- Provides Java version information

### MinecraftVersionManager
Handles Minecraft version management:
- Downloads version manifests
- Manages version installations
- Provides version information

### FileSystemManager
Provides file system operations optimized for HarmonyOS Next:
- Directory management
- File operations with proper permissions
- Storage space validation

## HarmonyOS Next Specific Features

### API Level 17 Compatibility
- Uses HarmonyOS Next APIs compatible with API level 17
- Optimized for HarmonyOS Next runtime environment
- Proper permission handling for storage and network access

### Worker Threads
Background operations use HarmonyOS Next worker threads:
- Download operations
- Java installation
- Launch process management

### File System Integration
Proper integration with HarmonyOS Next file system:
- Uses appropriate storage paths
- Handles permissions correctly
- Validates storage space

## Testing

Run tests using:
```bash
hvigor test
```

Tests cover:
- Launcher initialization
- Version management
- Java runtime validation
- File system operations
- App constants validation

## Building

### Debug Build
```bash
hvigor assembleHap
```

### Release Build
```bash
hvigor assembleHap --mode release
```

### Using Build Script
```bash
./build.sh
```

## Debugging

### Enable Debug Logging
Set log level in DevEco Studio or modify hilog statements in code.

### Common Issues
1. **Java Runtime Not Found**: Check if Java runtime is properly installed
2. **Storage Permission**: Ensure storage permissions are granted
3. **Network Issues**: Check internet connectivity for downloads
4. **Memory Issues**: Adjust Java memory settings in SettingsPage

## Contributing

1. Follow ArkTS coding standards
2. Use proper TypeScript types
3. Add appropriate hilog statements for debugging
4. Update tests when adding new features
5. Ensure HarmonyOS Next API level 17 compatibility

## Performance Optimization

### Memory Management
- Use appropriate Java heap sizes
- Monitor memory usage during launch
- Clean up resources properly

### File Operations
- Use async operations for file I/O
- Batch file operations when possible
- Validate file paths before operations

### UI Responsiveness
- Use worker threads for heavy operations
- Update UI with progress information
- Handle errors gracefully with user feedback