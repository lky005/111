# PojavLauncher for HarmonyOS Next

A Minecraft Java Edition launcher adapted for HarmonyOS Next, based on the open-source PojavLauncher project.

## Features

- **HarmonyOS Next Native**: Built specifically for HarmonyOS Next with API level 17
- **Minecraft Java Edition Support**: Run full Minecraft Java Edition on HarmonyOS devices
- **Version Management**: Download and manage different Minecraft versions
- **Java Runtime**: Integrated Java runtime environment for HarmonyOS
- **Mod Support**: Load and manage Minecraft mods
- **Customizable Settings**: Memory allocation, render distance, and control configuration

## Requirements

- HarmonyOS Next 5.0.0 (API Level 17 or higher)
- At least 4GB RAM recommended
- 2GB+ available storage space

## Installation

1. Build the project using HarmonyOS DevEco Studio
2. Install the generated HAP file on your HarmonyOS Next device
3. Grant necessary permissions (storage, internet)
4. Launch the app and follow the setup wizard

## Architecture

The application is structured as follows:

- **EntryAbility**: Main application entry point
- **Pages**: UI components (Index, LauncherPage, SettingsPage)
- **Utils**: Core launcher logic
  - `MinecraftLauncher`: Main launcher functionality
  - `JavaRuntimeManager`: Java environment management
  - `MinecraftVersionManager`: Version handling

## Development

### Prerequisites

- HarmonyOS DevEco Studio 4.0+
- HarmonyOS Next SDK (API Level 17)
- Node.js 16+

### Building

```bash
# Install dependencies
npm install

# Build the project
hvigor build
```

### Testing

The application includes simulated Minecraft launching for development and testing purposes. In a production environment, this would interface with actual Java runtime and Minecraft game files.

## Acknowledgments

This project is based on [PojavLauncher](https://github.com/PojavLauncherTeam/PojavLauncher), an open-source Minecraft launcher for Android. Special thanks to the PojavLauncher team for their pioneering work in mobile Minecraft gaming.

## License

This project is licensed under the GPL-3.0 License, maintaining compatibility with the original PojavLauncher license.

## Contributing

Contributions are welcome! Please feel free to submit issues and pull requests to improve HarmonyOS Next compatibility and functionality.

## Disclaimer

Minecraft is a trademark of Mojang Studios. This project is not affiliated with or endorsed by Mojang Studios or Microsoft.