/**
 * Application Constants
 */
export class AppConstants {
  // Application Info
  static readonly APP_NAME = 'PojavLauncher';
  static readonly APP_VERSION = '1.0.0';
  static readonly APP_BUILD = 'HarmonyOS-Next';
  
  // API Configuration
  static readonly API_LEVEL = 17;
  static readonly MIN_HARMONY_VERSION = '5.0.0(12)';
  
  // Minecraft Configuration
  static readonly DEFAULT_JAVA_MEMORY = 2048; // MB
  static readonly MIN_JAVA_MEMORY = 512; // MB
  static readonly MAX_JAVA_MEMORY = 8192; // MB
  static readonly DEFAULT_RENDER_DISTANCE = 8;
  static readonly MIN_RENDER_DISTANCE = 2;
  static readonly MAX_RENDER_DISTANCE = 32;
  
  // Paths
  static readonly DEFAULT_GAME_DIR = '/storage/emulated/0/minecraft';
  static readonly JAVA_DIR = '/storage/emulated/0/pojavlauncher/java';
  static readonly MODS_DIR = '/storage/emulated/0/minecraft/mods';
  static readonly VERSIONS_DIR = '/storage/emulated/0/minecraft/versions';
  static readonly ASSETS_DIR = '/storage/emulated/0/minecraft/assets';
  static readonly LIBRARIES_DIR = '/storage/emulated/0/minecraft/libraries';
  
  // Network
  static readonly MOJANG_API_BASE = 'https://piston-meta.mojang.com';
  static readonly MINECRAFT_RESOURCES = 'https://resources.download.minecraft.net';
  static readonly FORGE_MAVEN = 'https://maven.minecraftforge.net';
  
  // Java Configuration
  static readonly REQUIRED_JAVA_VERSION = 17;
  static readonly JAVA_DOWNLOAD_URL = 'https://github.com/PojavLauncherTeam/PojavLauncher/releases/download/v3.4.2/jre17-harmonyos.tar.gz';
  
  // Supported Minecraft Versions
  static readonly SUPPORTED_VERSIONS = [
    '1.20.4',
    '1.20.2',
    '1.20.1',
    '1.19.4',
    '1.19.2',
    '1.18.2',
    '1.17.1',
    '1.16.5'
  ];
  
  // HarmonyOS Specific
  static readonly BUNDLE_NAME = 'com.pojavlauncher.harmonyos';
  static readonly PERMISSIONS = [
    'ohos.permission.INTERNET',
    'ohos.permission.WRITE_USER_STORAGE',
    'ohos.permission.READ_USER_STORAGE',
    'ohos.permission.MEDIA_LOCATION',
    'ohos.permission.READ_MEDIA'
  ];
}

/**
 * Launch Event Types
 */
export enum LaunchEventType {
  INITIALIZING = 'initializing',
  DOWNLOADING = 'downloading',
  INSTALLING = 'installing',
  LOADING_ASSETS = 'loading_assets',
  STARTING_GAME = 'starting_game',
  RUNNING = 'running',
  ERROR = 'error',
  COMPLETE = 'complete'
}

/**
 * Minecraft Version Types
 */
export enum VersionType {
  RELEASE = 'release',
  SNAPSHOT = 'snapshot',
  OLD_BETA = 'old_beta',
  OLD_ALPHA = 'old_alpha'
}

/**
 * Error Codes
 */
export enum ErrorCode {
  JAVA_NOT_FOUND = 'JAVA_NOT_FOUND',
  VERSION_NOT_FOUND = 'VERSION_NOT_FOUND',
  DOWNLOAD_FAILED = 'DOWNLOAD_FAILED',
  LAUNCH_FAILED = 'LAUNCH_FAILED',
  PERMISSION_DENIED = 'PERMISSION_DENIED',
  INSUFFICIENT_MEMORY = 'INSUFFICIENT_MEMORY',
  NETWORK_ERROR = 'NETWORK_ERROR',
  FILE_SYSTEM_ERROR = 'FILE_SYSTEM_ERROR'
}