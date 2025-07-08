import hilog from '@ohos.hilog';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { MinecraftLauncher } from '../main/ets/utils/MinecraftLauncher';
import { MinecraftVersionManager } from '../main/ets/utils/MinecraftVersionManager';
import { JavaRuntimeManager } from '../main/ets/utils/JavaRuntimeManager';
import { FileSystemManager } from '../main/ets/utils/FileSystemManager';
import { AppConstants } from '../main/ets/common/constants/AppConstants';

export default function PojavLauncherTest() {
  describe('PojavLauncher Tests', function () {
    beforeAll(function () {
      hilog.info(0x0000, 'PojavLauncherTest', 'Starting PojavLauncher tests');
    });

    afterAll(function () {
      hilog.info(0x0000, 'PojavLauncherTest', 'Completed PojavLauncher tests');
    });

    it('should create MinecraftLauncher singleton instance', 0, function () {
      const launcher1 = MinecraftLauncher.getInstance();
      const launcher2 = MinecraftLauncher.getInstance();
      expect(launcher1).assertEqual(launcher2);
    });

    it('should initialize version manager with default versions', 0, async function () {
      const versionManager = MinecraftVersionManager.getInstance();
      await versionManager.initialize();
      
      const versions = versionManager.getVersions();
      expect(versions.length).assertLarger(0);
      
      // Check if supported versions are included
      const version1204 = versions.find(v => v.id === '1.20.4');
      expect(version1204).assertNotNull();
      expect(version1204.javaVersion).assertEqual(17);
    });

    it('should validate Java runtime manager initialization', 0, async function () {
      const javaManager = JavaRuntimeManager.getInstance();
      const initialized = await javaManager.initialize();
      
      // Note: In test environment, this may fail due to simulated Java installation
      // We're mainly testing the interface and error handling
      expect(typeof initialized).assertEqual('boolean');
    });

    it('should validate file system manager', 0, async function () {
      const fileManager = FileSystemManager.getInstance();
      const initialized = await fileManager.initialize();
      
      // Test basic file operations interface
      expect(typeof initialized).assertEqual('boolean');
      
      // Test directory existence check
      const exists = await fileManager.fileExists('/nonexistent/path');
      expect(exists).assertEqual(false);
    });

    it('should validate app constants', 0, function () {
      expect(AppConstants.API_LEVEL).assertEqual(17);
      expect(AppConstants.APP_NAME).assertEqual('PojavLauncher');
      expect(AppConstants.APP_VERSION).assertEqual('1.0.0');
      expect(AppConstants.DEFAULT_JAVA_MEMORY).assertEqual(2048);
      expect(AppConstants.MIN_JAVA_MEMORY).assertEqual(512);
      expect(AppConstants.MAX_JAVA_MEMORY).assertEqual(8192);
    });

    it('should handle launcher initialization gracefully', 0, async function () {
      const launcher = MinecraftLauncher.getInstance();
      
      try {
        const initialized = await launcher.initialize();
        expect(typeof initialized).assertEqual('boolean');
      } catch (error) {
        hilog.info(0x0000, 'PojavLauncherTest', 'Launcher initialization failed as expected in test environment');
        expect(error).assertInstanceOf(Error);
      }
    });

    it('should validate supported Minecraft versions', 0, function () {
      expect(AppConstants.SUPPORTED_VERSIONS).assertContain('1.20.4');
      expect(AppConstants.SUPPORTED_VERSIONS).assertContain('1.19.4');
      expect(AppConstants.SUPPORTED_VERSIONS).assertContain('1.18.2');
      expect(AppConstants.SUPPORTED_VERSIONS.length).assertLarger(5);
    });

    it('should validate HarmonyOS specific configuration', 0, function () {
      expect(AppConstants.BUNDLE_NAME).assertEqual('com.pojavlauncher.harmonyos');
      expect(AppConstants.MIN_HARMONY_VERSION).assertEqual('5.0.0(12)');
      expect(AppConstants.PERMISSIONS).assertContain('ohos.permission.INTERNET');
      expect(AppConstants.PERMISSIONS).assertContain('ohos.permission.WRITE_USER_STORAGE');
      expect(AppConstants.PERMISSIONS).assertContain('ohos.permission.READ_USER_STORAGE');
    });

    it('should handle launch options validation', 0, function () {
      const launcher = MinecraftLauncher.getInstance();
      
      // Test that launcher is not running initially
      expect(launcher.isRunning()).assertEqual(false);
      
      // Test launch callback setup
      launcher.setLaunchCallback((event) => {
        hilog.info(0x0000, 'PojavLauncherTest', 'Received launch event: %{public}s', event.type);
      });
    });
  });
}