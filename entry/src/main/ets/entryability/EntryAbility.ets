import UIAbility from '@ohos.app.ability.UIAbility';
import hilog from '@ohos.hilog';
import window from '@ohos.window';
import Want from '@ohos.app.ability.Want';
import AbilityConstant from '@ohos.app.ability.AbilityConstant';
import abilityAccessCtrl, { Permissions } from '@ohos.abilityAccessCtrl';
import { BusinessError } from '@ohos.base';

const TAG: string = 'EntryAbility';
const DOMAIN: number = 0x0000;

export default class EntryAbility extends UIAbility {
  private windowStage: window.WindowStage | null = null;

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(DOMAIN, TAG, '%{public}s', 'Ability onCreate');
    
    // Initialize launcher configuration and check permissions
    this.initializeLauncher();
  }

  onDestroy(): void {
    hilog.info(DOMAIN, TAG, '%{public}s', 'Ability onDestroy');
    this.cleanup();
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    hilog.info(DOMAIN, TAG, '%{public}s', 'Ability onWindowStageCreate');
    
    this.windowStage = windowStage;
    
    // Configure window properties
    this.configureWindow(windowStage);
    
    windowStage.loadContent('pages/Index', (err, data) => {
      if (err.code) {
        hilog.error(DOMAIN, TAG, 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      hilog.info(DOMAIN, TAG, 'Succeeded in loading the content. Data: %{public}s', JSON.stringify(data) ?? '');
    });
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(DOMAIN, TAG, '%{public}s', 'Ability onWindowStageDestroy');
    this.windowStage = null;
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(DOMAIN, TAG, '%{public}s', 'Ability onForeground');
    
    // Check if permissions are still granted
    this.checkPermissions();
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(DOMAIN, TAG, '%{public}s', 'Ability onBackground');
  }

  private async initializeLauncher(): Promise<void> {
    try {
      hilog.info(DOMAIN, TAG, 'Initializing Minecraft Launcher...');
      
      // Request necessary permissions
      await this.requestPermissions();
      
      hilog.info(DOMAIN, TAG, 'Launcher initialized successfully');
    } catch (error) {
      const err = error as BusinessError;
      hilog.error(DOMAIN, TAG, 'Failed to initialize launcher: %{public}s', err.message);
    }
  }

  private async requestPermissions(): Promise<void> {
    const permissions: Array<Permissions> = [
      'ohos.permission.INTERNET',
      'ohos.permission.READ_WRITE_DOWNLOAD_DIRECTORY',
      'ohos.permission.READ_WRITE_DOCUMENTS_DIRECTORY',
      'ohos.permission.FILE_ACCESS_MANAGER'
    ];

    try {
      const atManager = abilityAccessCtrl.createAtManager();
      const grantResults = await atManager.requestPermissionsFromUser(this.context, permissions);
      
      for (let i = 0; i < grantResults.authResults.length; i++) {
        if (grantResults.authResults[i] === abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED) {
          hilog.info(DOMAIN, TAG, 'Permission granted: %{public}s', permissions[i]);
        } else {
          hilog.warn(DOMAIN, TAG, 'Permission denied: %{public}s', permissions[i]);
        }
      }
    } catch (error) {
      const err = error as BusinessError;
      hilog.error(DOMAIN, TAG, 'Request permissions failed: %{public}s', err.message);
      throw error;
    }
  }

  private async checkPermissions(): Promise<void> {
    try {
      const atManager = abilityAccessCtrl.createAtManager();
      const permissions: Array<Permissions> = [
        'ohos.permission.INTERNET',
        'ohos.permission.READ_WRITE_DOWNLOAD_DIRECTORY'
      ];

      for (const permission of permissions) {
        const result = await atManager.checkAccessToken(this.context.applicationInfo.accessTokenId, permission);
        if (result !== abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED) {
          hilog.warn(DOMAIN, TAG, 'Permission %{public}s is not granted', permission);
        }
      }
    } catch (error) {
      const err = error as BusinessError;
      hilog.error(DOMAIN, TAG, 'Check permissions failed: %{public}s', err.message);
    }
  }

  private configureWindow(windowStage: window.WindowStage): void {
    try {
      windowStage.getMainWindow((err, windowClass) => {
        if (err.code) {
          hilog.error(DOMAIN, TAG, 'Failed to obtain the main window. Cause: %{public}s', JSON.stringify(err));
          return;
        }
        
        // Set window properties
        windowClass.setWindowKeepScreenOn(true, (err) => {
          if (err.code) {
            hilog.error(DOMAIN, TAG, 'Failed to set keep screen on. Cause: %{public}s', JSON.stringify(err));
          } else {
            hilog.info(DOMAIN, TAG, 'Window keep screen on set successfully');
          }
        });

        // Set full screen mode for gaming
        const systemBarProperties: window.SystemBarProperties = {
          statusBarColor: '#2E7D32',
          navigationBarColor: '#2E7D32',
          statusBarContentColor: '#FFFFFF',
          navigationBarContentColor: '#FFFFFF'
        };
        
        windowClass.setWindowSystemBarProperties(systemBarProperties, (err) => {
          if (err.code) {
            hilog.error(DOMAIN, TAG, 'Failed to set system bar properties. Cause: %{public}s', JSON.stringify(err));
          } else {
            hilog.info(DOMAIN, TAG, 'System bar properties set successfully');
          }
        });
      });
    } catch (error) {
      const err = error as BusinessError;
      hilog.error(DOMAIN, TAG, 'Configure window failed: %{public}s', err.message);
    }
  }

  private cleanup(): void {
    try {
      hilog.info(DOMAIN, TAG, 'Cleaning up launcher resources...');
      
      // Clean up any background tasks or resources
      this.windowStage = null;
      
      hilog.info(DOMAIN, TAG, 'Cleanup completed successfully');
    } catch (error) {
      const err = error as BusinessError;
      hilog.error(DOMAIN, TAG, 'Cleanup failed: %{public}s', err.message);
    }
  }
}