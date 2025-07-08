import router from '@ohos.router';
import { MinecraftLauncher, LauncherConfig, LaunchStats } from '../launcher/MinecraftLauncher';
import hilog from '@ohos.hilog';
import { BusinessError } from '@ohos.base';
import promptAction from '@ohos.promptAction';
import { Context } from '@ohos.app.ability.common';

const TAG: string = 'IndexPage';
const DOMAIN: number = 0x0002;

@Entry
@Component
struct Index {
  @State message: string = $r('app.string.minecraft_launcher');
  @State selectedVersion: string = '1.20.4';
  @State isLaunching: boolean = false;
  @State downloadProgress: number = 0;
  @State launchStats: LaunchStats = { totalLaunches: 0, lastLaunchTime: 0, favoriteVersion: '1.20.4' };
  @State errorMessage: string = '';
  @State isLoading: boolean = true;
  private launcher: MinecraftLauncher | null = null;
  private context: Context = getContext(this) as Context;

  aboutToAppear(): void {
    this.initializeLauncher();
  }

  aboutToDisappear(): void {
    this.cleanup();
  }

  build() {
    Column() {
      // Header with proper accessibility
      Row() {
        Text($r('app.string.minecraft_launcher'))
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.surface_color'))
          .accessibilityDescription('Minecraft Launcher Title')
        
        Blank()
        
        Button($r('app.string.settings'))
          .backgroundColor(Color.Transparent)
          .fontColor($r('app.color.surface_color'))
          .accessibilityDescription('Open Settings')
          .onClick(() => {
            this.navigateToSettings();
          })
      }
      .width('100%')
      .height(60)
      .padding({ left: 16, right: 16 })
      .backgroundColor($r('app.color.primary_dark'))

      if (this.isLoading) {
        // Loading state
        Column() {
          LoadingProgress()
            .width(60)
            .height(60)
            .color($r('app.color.primary_color'))
            .margin({ bottom: 16 })
          
          Text('Loading launcher...')
            .fontSize(16)
            .fontColor($r('app.color.text_secondary'))
        }
        .justifyContent(FlexAlign.Center)
        .flexGrow(1)
      } else {
        // Main content area
        Column() {
          // Error display
          if (this.errorMessage) {
            Row() {
              Text(this.errorMessage)
                .fontSize(14)
                .fontColor($r('app.color.error_color'))
                .flexGrow(1)
              
              Button('Dismiss')
                .backgroundColor(Color.Transparent)
                .fontColor($r('app.color.error_color'))
                .fontSize(12)
                .onClick(() => {
                  this.errorMessage = '';
                })
            }
            .width('100%')
            .padding(12)
            .backgroundColor('#FFEBEE')
            .borderRadius(8)
            .margin({ bottom: 16 })
          }

          // Statistics section
          if (this.launchStats.totalLaunches > 0) {
            Row() {
              Column() {
                Text(`${this.launchStats.totalLaunches}`)
                  .fontSize(20)
                  .fontWeight(FontWeight.Bold)
                  .fontColor($r('app.color.primary_color'))
                Text('Total Launches')
                  .fontSize(12)
                  .fontColor($r('app.color.text_secondary'))
              }
              .flexGrow(1)

              Column() {
                Text(this.launchStats.favoriteVersion)
                  .fontSize(16)
                  .fontWeight(FontWeight.Medium)
                  .fontColor($r('app.color.primary_color'))
                Text('Favorite Version')
                  .fontSize(12)
                  .fontColor($r('app.color.text_secondary'))
              }
              .flexGrow(1)
            }
            .width('100%')
            .padding(16)
            .backgroundColor($r('app.color.surface_color'))
            .borderRadius(12)
            .margin({ bottom: 24 })
            .shadow({
              radius: 4,
              color: '#1F000000',
              offsetX: 0,
              offsetY: 2
            })
          }

          // Version selector section
          Column() {
            Text($r('app.string.select_version'))
              .fontSize(18)
              .fontWeight(FontWeight.Medium)
              .margin({ bottom: 12 })
              .alignSelf(ItemAlign.Start)
              .fontColor($r('app.color.text_primary'))

            Row() {
              Column() {
                Text(`Minecraft ${this.selectedVersion}`)
                  .fontSize(16)
                  .fontColor($r('app.color.text_primary'))
                  .textAlign(TextAlign.Start)
                
                Text('Ready to launch')
                  .fontSize(12)
                  .fontColor($r('app.color.text_secondary'))
                  .textAlign(TextAlign.Start)
              }
              .flexGrow(1)
              .alignItems(HorizontalAlign.Start)
              
              Button($r('app.string.change'))
                .backgroundColor($r('app.color.primary_color'))
                .borderRadius(8)
                .padding({ left: 16, right: 16 })
                .accessibilityDescription('Change Minecraft version')
                .onClick(() => {
                  this.navigateToVersionManager();
                })
            }
            .width('100%')
            .padding(16)
            .backgroundColor($r('app.color.surface_color'))
            .borderRadius(12)
            .shadow({
              radius: 2,
              color: '#0F000000',
              offsetX: 0,
              offsetY: 1
            })
          }
          .width('100%')
          .margin({ bottom: 24 })

          // Launch button section
          Column() {
            if (this.isLaunching) {
              Column() {
                Text($r('app.string.launching_minecraft'))
                  .fontSize(16)
                  .margin({ bottom: 16 })
                  .fontColor($r('app.color.text_primary'))
                
                Progress({ value: this.downloadProgress, total: 100, type: ProgressType.Linear })
                  .width('100%')
                  .color($r('app.color.primary_color'))
                  .backgroundColor('#E8F5E8')
                  .margin({ bottom: 8 })
                
                Text(`${this.downloadProgress}%`)
                  .fontSize(14)
                  .fontColor($r('app.color.text_secondary'))
              }
              .width('100%')
              .padding(20)
              .backgroundColor($r('app.color.surface_color'))
              .borderRadius(12)
            } else {
              Button($r('app.string.launch_game'))
                .width('100%')
                .height(56)
                .fontSize(18)
                .fontWeight(FontWeight.Bold)
                .backgroundColor($r('app.color.primary_color'))
                .borderRadius(12)
                .accessibilityDescription('Launch Minecraft game')
                .stateEffect(true)
                .onClick(() => {
                  this.launchGame();
                })
                .shadow({
                  radius: 8,
                  color: '#3F4CAF50',
                  offsetX: 0,
                  offsetY: 4
                })
            }
          }
          .width('100%')
          .margin({ bottom: 24 })

          // Quick actions
          Row() {
            Button($r('app.string.profiles'))
              .flexGrow(1)
              .height(48)
              .backgroundColor($r('app.color.accent_color'))
              .borderRadius(8)
              .margin({ right: 8 })
              .accessibilityDescription('Manage game profiles')
              .onClick(() => {
                this.navigateToProfileManager();
              })
            
            Button($r('app.string.mods'))
              .flexGrow(1)
              .height(48)
              .backgroundColor($r('app.color.warning_color'))
              .borderRadius(8)
              .margin({ left: 8 })
              .accessibilityDescription('Manage mods')
              .onClick(() => {
                this.showModManagerComingSoon();
              })
          }
          .width('100%')
          .margin({ bottom: 24 })

          // Status area
          Column() {
            Text($r('app.string.status_ready'))
              .fontSize(14)
              .fontColor($r('app.color.text_secondary'))
              .margin({ bottom: 4 })
            
            Text('Java Version: OpenJDK 17')
              .fontSize(12)
              .fontColor($r('app.color.text_secondary'))
              .margin({ bottom: 2 })

            if (this.launchStats.lastLaunchTime > 0) {
              Text(`Last played: ${this.formatLastPlayTime(this.launchStats.lastLaunchTime)}`)
                .fontSize(12)
                .fontColor($r('app.color.text_secondary'))
            }
          }
          .alignItems(HorizontalAlign.Start)
          .width('100%')
        }
        .padding(16)
        .flexGrow(1)
      }
    }
    .height('100%')
    .backgroundColor($r('app.color.background_color'))
  }

  private async initializeLauncher(): Promise<void> {
    try {
      hilog.info(DOMAIN, TAG, 'Initializing launcher...');
      
      this.launcher = new MinecraftLauncher(this.context);
      
      // Load launcher configuration
      const config = await this.launcher.getConfig();
      this.selectedVersion = config.lastUsedVersion;
      
      // Load launch statistics
      this.launchStats = await this.launcher.getLaunchStats();
      
      this.isLoading = false;
      hilog.info(DOMAIN, TAG, 'Launcher initialized successfully');
    } catch (error) {
      const err = error as BusinessError;
      hilog.error(DOMAIN, TAG, 'Failed to initialize launcher: %{public}s', err.message);
      this.errorMessage = 'Failed to initialize launcher. Please try restarting the app.';
      this.isLoading = false;
    }
  }

  private async launchGame(): Promise<void> {
    if (!this.launcher) {
      this.errorMessage = 'Launcher not initialized';
      return;
    }

    this.isLaunching = true;
    this.downloadProgress = 0;
    this.errorMessage = '';

    try {
      hilog.info(DOMAIN, TAG, `Starting launch process for version ${this.selectedVersion}`);

      // Check if version needs to be downloaded
      if (!this.launcher.isVersionInstalled(this.selectedVersion)) {
        hilog.info(DOMAIN, TAG, 'Version not installed, downloading...');
        
        const downloadSuccess = await this.launcher.downloadVersion(this.selectedVersion, (progress) => {
          this.downloadProgress = progress;
        });

        if (!downloadSuccess) {
          throw new Error('Failed to download game files');
        }
      } else {
        // Simulate quick preparation
        for (let i = 0; i <= 100; i += 20) {
          this.downloadProgress = i;
          await new Promise(resolve => setTimeout(resolve, 100));
        }
      }

      // Launch the game
      await this.launcher.launchMinecraft(this.selectedVersion);
      
      // Update statistics
      this.launchStats = await this.launcher.getLaunchStats();
      
      // Show success message
      promptAction.showToast({
        message: 'Minecraft launched successfully!',
        duration: 2000
      });
      
      // Reset state
      this.isLaunching = false;
      this.downloadProgress = 0;
      
      hilog.info(DOMAIN, TAG, 'Launch completed successfully');
    } catch (error) {
      const err = error as BusinessError | Error;
      hilog.error(DOMAIN, TAG, `Launch failed: ${err.message}`);
      
      this.errorMessage = `Launch failed: ${err.message}`;
      this.isLaunching = false;
      this.downloadProgress = 0;
      
      promptAction.showToast({
        message: 'Failed to launch Minecraft',
        duration: 2000
      });
    }
  }

  private navigateToSettings(): void {
    try {
      router.pushUrl({ url: 'pages/GameSettings' });
    } catch (error) {
      hilog.error(DOMAIN, TAG, 'Navigation to settings failed');
      this.errorMessage = 'Failed to open settings';
    }
  }

  private navigateToVersionManager(): void {
    try {
      router.pushUrl({ url: 'pages/VersionManager' });
    } catch (error) {
      hilog.error(DOMAIN, TAG, 'Navigation to version manager failed');
      this.errorMessage = 'Failed to open version manager';
    }
  }

  private navigateToProfileManager(): void {
    try {
      router.pushUrl({ url: 'pages/ProfileManager' });
    } catch (error) {
      hilog.error(DOMAIN, TAG, 'Navigation to profile manager failed');
      this.errorMessage = 'Failed to open profile manager';
    }
  }

  private showModManagerComingSoon(): void {
    promptAction.showDialog({
      title: 'Coming Soon',
      message: 'Mod manager feature will be available in a future update.',
      buttons: [
        {
          text: 'OK',
          color: '#4CAF50'
        }
      ]
    });
  }

  private formatLastPlayTime(timestamp: number): string {
    const now = Date.now();
    const diff = now - timestamp;
    const hours = Math.floor(diff / (1000 * 60 * 60));
    
    if (hours < 1) {
      return 'Less than an hour ago';
    } else if (hours < 24) {
      return `${hours} hour${hours > 1 ? 's' : ''} ago`;
    } else {
      const days = Math.floor(hours / 24);
      return `${days} day${days > 1 ? 's' : ''} ago`;
    }
  }

  private cleanup(): void {
    try {
      hilog.info(DOMAIN, TAG, 'Cleaning up Index page resources');
      // Clean up any ongoing operations
      this.launcher = null;
    } catch (error) {
      hilog.error(DOMAIN, TAG, 'Cleanup failed');
    }
  }
}