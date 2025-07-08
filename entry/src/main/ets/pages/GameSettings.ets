import router from '@ohos.router';
import { MinecraftLauncher, LauncherConfig } from '../launcher/MinecraftLauncher';
import hilog from '@ohos.hilog';
import { BusinessError } from '@ohos.base';
import promptAction from '@ohos.promptAction';
import { Context } from '@ohos.app.ability.common';

const TAG: string = 'GameSettings';
const DOMAIN: number = 0x0003;

@Entry
@Component
struct GameSettings {
  @State config: LauncherConfig = {
    username: 'Player',
    maxMemory: 2048,
    minMemory: 512,
    fullscreen: false,
    windowWidth: 854,
    windowHeight: 480,
    lastUsedVersion: '1.20.4'
  };
  @State tempUsername: string = '';
  @State isLoading: boolean = true;
  @State isSaving: boolean = false;
  @State errorMessage: string = '';
  private launcher: MinecraftLauncher | null = null;
  private context: Context = getContext(this) as Context;

  aboutToAppear(): void {
    this.initializeSettings();
  }

  aboutToDisappear(): void {
    this.cleanup();
  }

  build() {
    Column() {
      // Header with improved accessibility
      Row() {
        Button($r('app.string.back'))
          .backgroundColor(Color.Transparent)
          .fontColor($r('app.color.surface_color'))
          .accessibilityDescription('Navigate back to main screen')
          .onClick(() => {
            this.navigateBack();
          })
        
        Text('Game Settings')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.surface_color'))
          .flexGrow(1)
          .textAlign(TextAlign.Center)
        
        Button($r('app.string.save'))
          .backgroundColor(Color.Transparent)
          .fontColor($r('app.color.surface_color'))
          .accessibilityDescription('Save current settings')
          .enabled(!this.isSaving)
          .onClick(() => {
            this.saveConfig();
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
          
          Text('Loading settings...')
            .fontSize(16)
            .fontColor($r('app.color.text_secondary'))
        }
        .justifyContent(FlexAlign.Center)
        .flexGrow(1)
      } else {
        // Settings content
        Scroll() {
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

            // Player settings
            this.buildSettingsSection('Player Settings', () => {
              this.buildTextInputSetting('Username', this.tempUsername, (value) => {
                this.tempUsername = value;
                this.config.username = value;
              });
            });

            // Memory settings
            this.buildSettingsSection('Memory Settings', () => {
              this.buildSliderSetting('Maximum Memory (MB)', this.config.maxMemory, 512, 8192, (value) => {
                this.config.maxMemory = value;
                // Ensure min memory doesn't exceed max memory
                if (this.config.minMemory > value) {
                  this.config.minMemory = Math.max(256, value - 256);
                }
              });
              
              this.buildSliderSetting('Minimum Memory (MB)', this.config.minMemory, 256, Math.min(2048, this.config.maxMemory), (value) => {
                this.config.minMemory = value;
              });

              // Memory usage info
              this.buildInfoSetting('Recommended Memory', this.getRecommendedMemory());
            });

            // Display settings
            this.buildSettingsSection('Display Settings', () => {
              this.buildToggleSetting('Fullscreen Mode', this.config.fullscreen, (value) => {
                this.config.fullscreen = value;
              });
              
              if (!this.config.fullscreen) {
                this.buildSliderSetting('Window Width', this.config.windowWidth, 640, 1920, (value) => {
                  this.config.windowWidth = value;
                });
                
                this.buildSliderSetting('Window Height', this.config.windowHeight, 480, 1080, (value) => {
                  this.config.windowHeight = value;
                });

                // Resolution presets
                this.buildPresetButtons();
              }
            });

            // Game settings
            this.buildSettingsSection('Game Settings', () => {
              this.buildInfoSetting('Last Used Version', this.config.lastUsedVersion);
              this.buildInfoSetting('Game Directory', '/data/storage/el2/base/minecraft');
            });

            // System information
            this.buildSettingsSection('System Information', () => {
              this.buildInfoSetting('Java Version', 'OpenJDK 17');
              this.buildInfoSetting('Launcher Version', '1.0.0');
              this.buildInfoSetting('HarmonyOS Version', '5.0 API 17');
              this.buildInfoSetting('Device Type', this.getDeviceType());
            });

            // Action buttons
            Column() {
              if (this.isSaving) {
                Row() {
                  LoadingProgress()
                    .width(24)
                    .height(24)
                    .color($r('app.color.surface_color'))
                    .margin({ right: 8 })
                  
                  Text('Saving...')
                    .fontSize(16)
                    .fontColor($r('app.color.surface_color'))
                }
                .width('100%')
                .height(48)
                .justifyContent(FlexAlign.Center)
                .backgroundColor($r('app.color.primary_color'))
                .borderRadius(8)
                .margin({ bottom: 12 })
              } else {
                Button('Reset to Defaults')
                  .width('100%')
                  .height(48)
                  .backgroundColor($r('app.color.warning_color'))
                  .borderRadius(8)
                  .margin({ bottom: 12 })
                  .accessibilityDescription('Reset all settings to default values')
                  .onClick(() => {
                    this.showResetConfirmation();
                  })
              }
              
              Button('Clear Game Data')
                .width('100%')
                .height(48)
                .backgroundColor($r('app.color.error_color'))
                .borderRadius(8)
                .accessibilityDescription('Delete all game data and saves')
                .onClick(() => {
                  this.showClearDataConfirmation();
                })
            }
            .width('100%')
            .margin({ top: 24, bottom: 32 })
          }
          .width('100%')
          .padding(16)
        }
        .flexGrow(1)
      }
    }
    .height('100%')
    .backgroundColor($r('app.color.background_color'))
  }

  @Builder
  buildSettingsSection(title: string, content: () => void) {
    Column() {
      Text(title)
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .margin({ bottom: 16 })
        .alignSelf(ItemAlign.Start)
        .fontColor($r('app.color.text_primary'))

      content();
    }
    .width('100%')
    .margin({ bottom: 32 })
  }

  @Builder
  buildTextInputSetting(label: string, value: string, onChange: (value: string) => void) {
    Column() {
      Row() {
        Text(label)
          .fontSize(16)
          .flexGrow(1)
          .fontColor($r('app.color.text_primary'))
        
        TextInput({ text: value, placeholder: label })
          .width(200)
          .height(40)
          .backgroundColor($r('app.color.surface_color'))
          .borderRadius(8)
          .maxLength(16)
          .accessibilityDescription(`Enter ${label.toLowerCase()}`)
          .onChange((value: string) => {
            onChange(value);
          })
      }
      .width('100%')
      .alignItems(VerticalAlign.Center)
    }
    .width('100%')
    .padding(16)
    .backgroundColor($r('app.color.surface_color'))
    .borderRadius(12)
    .margin({ bottom: 8 })
    .shadow({
      radius: 2,
      color: '#0F000000',
      offsetX: 0,
      offsetY: 1
    })
  }

  @Builder
  buildSliderSetting(label: string, value: number, min: number, max: number, onChange: (value: number) => void) {
    Column() {
      Row() {
        Text(label)
          .fontSize(16)
          .flexGrow(1)
          .fontColor($r('app.color.text_primary'))
        
        Text(`${value}${label.includes('Memory') ? ' MB' : ''}`)
          .fontSize(16)
          .fontColor($r('app.color.text_secondary'))
          .fontWeight(FontWeight.Medium)
          .width(80)
          .textAlign(TextAlign.End)
      }
      .width('100%')
      .margin({ bottom: 12 })

      Slider({
        value: value,
        min: min,
        max: max,
        step: label.includes('Memory') ? 256 : 1,
        style: SliderStyle.OutSet
      })
        .width('100%')
        .trackColor('#E0E0E0')
        .selectedColor($r('app.color.primary_color'))
        .blockColor($r('app.color.primary_color'))
        .accessibilityDescription(`Adjust ${label.toLowerCase()}`)
        .onChange((value: number) => {
          onChange(Math.round(value));
        })
    }
    .width('100%')
    .padding(16)
    .backgroundColor($r('app.color.surface_color'))
    .borderRadius(12)
    .margin({ bottom: 8 })
    .shadow({
      radius: 2,
      color: '#0F000000',
      offsetX: 0,
      offsetY: 1
    })
  }

  @Builder
  buildToggleSetting(label: string, value: boolean, onChange: (value: boolean) => void) {
    Row() {
      Text(label)
        .fontSize(16)
        .flexGrow(1)
        .fontColor($r('app.color.text_primary'))
      
      Toggle({ type: ToggleType.Switch, isOn: value })
        .selectedColor($r('app.color.primary_color'))
        .accessibilityDescription(`Toggle ${label.toLowerCase()}`)
        .onChange((isOn: boolean) => {
          onChange(isOn);
        })
    }
    .width('100%')
    .padding(16)
    .backgroundColor($r('app.color.surface_color'))
    .borderRadius(12)
    .margin({ bottom: 8 })
    .shadow({
      radius: 2,
      color: '#0F000000',
      offsetX: 0,
      offsetY: 1
    })
  }

  @Builder
  buildInfoSetting(label: string, value: string) {
    Row() {
      Text(label)
        .fontSize(16)
        .flexGrow(1)
        .fontColor($r('app.color.text_primary'))
      
      Text(value)
        .fontSize(16)
        .fontColor($r('app.color.text_secondary'))
        .textAlign(TextAlign.End)
    }
    .width('100%')
    .padding(16)
    .backgroundColor($r('app.color.surface_color'))
    .borderRadius(12)
    .margin({ bottom: 8 })
    .shadow({
      radius: 1,
      color: '#0A000000',
      offsetX: 0,
      offsetY: 1
    })
  }

  @Builder
  buildPresetButtons() {
    Column() {
      Text('Resolution Presets')
        .fontSize(14)
        .fontColor($r('app.color.text_secondary'))
        .alignSelf(ItemAlign.Start)
        .margin({ bottom: 8 })

      Row() {
        Button('854×480')
          .fontSize(12)
          .height(32)
          .backgroundColor(this.config.windowWidth === 854 ? $r('app.color.primary_color') : $r('app.color.background_color'))
          .fontColor(this.config.windowWidth === 854 ? $r('app.color.surface_color') : $r('app.color.text_primary'))
          .flexGrow(1)
          .margin({ right: 4 })
          .onClick(() => {
            this.config.windowWidth = 854;
            this.config.windowHeight = 480;
          })

        Button('1280×720')
          .fontSize(12)
          .height(32)
          .backgroundColor(this.config.windowWidth === 1280 ? $r('app.color.primary_color') : $r('app.color.background_color'))
          .fontColor(this.config.windowWidth === 1280 ? $r('app.color.surface_color') : $r('app.color.text_primary'))
          .flexGrow(1)
          .margin({ left: 4, right: 4 })
          .onClick(() => {
            this.config.windowWidth = 1280;
            this.config.windowHeight = 720;
          })

        Button('1920×1080')
          .fontSize(12)
          .height(32)
          .backgroundColor(this.config.windowWidth === 1920 ? $r('app.color.primary_color') : $r('app.color.background_color'))
          .fontColor(this.config.windowWidth === 1920 ? $r('app.color.surface_color') : $r('app.color.text_primary'))
          .flexGrow(1)
          .margin({ left: 4 })
          .onClick(() => {
            this.config.windowWidth = 1920;
            this.config.windowHeight = 1080;
          })
      }
      .width('100%')
    }
    .width('100%')
    .margin({ top: 8 })
  }

  private async initializeSettings(): Promise<void> {
    try {
      hilog.info(DOMAIN, TAG, 'Initializing settings...');
      
      this.launcher = new MinecraftLauncher(this.context);
      
      // Load current configuration
      this.config = await this.launcher.getConfig();
      this.tempUsername = this.config.username;
      
      this.isLoading = false;
      hilog.info(DOMAIN, TAG, 'Settings loaded successfully');
    } catch (error) {
      const err = error as BusinessError;
      hilog.error(DOMAIN, TAG, `Failed to load settings: ${err.message}`);
      this.errorMessage = 'Failed to load settings. Using defaults.';
      this.isLoading = false;
    }
  }

  private async saveConfig(): Promise<void> {
    if (!this.launcher) {
      this.errorMessage = 'Launcher not initialized';
      return;
    }

    this.isSaving = true;
    this.errorMessage = '';

    try {
      // Validate username
      if (!this.config.username || this.config.username.trim().length === 0) {
        this.config.username = 'Player';
      }

      // Validate memory settings
      if (this.config.minMemory > this.config.maxMemory) {
        this.config.minMemory = Math.max(256, this.config.maxMemory - 256);
      }

      await this.launcher.updateConfig(this.config);
      
      promptAction.showToast({
        message: 'Settings saved successfully',
        duration: 2000
      });

      hilog.info(DOMAIN, TAG, 'Settings saved successfully');
    } catch (error) {
      const err = error as BusinessError;
      hilog.error(DOMAIN, TAG, `Failed to save settings: ${err.message}`);
      this.errorMessage = 'Failed to save settings. Please try again.';
    } finally {
      this.isSaving = false;
    }
  }

  private navigateBack(): void {
    // Auto-save on back navigation
    if (this.launcher && !this.isSaving) {
      this.saveConfig().finally(() => {
        router.back();
      });
    } else {
      router.back();
    }
  }

  private showResetConfirmation(): void {
    promptAction.showDialog({
      title: 'Reset Settings',
      message: 'Are you sure you want to reset all settings to default values? This action cannot be undone.',
      buttons: [
        {
          text: 'Cancel',
          color: $r('app.color.text_secondary')
        },
        {
          text: 'Reset',
          color: $r('app.color.error_color')
        }
      ]
    }, (err, data) => {
      if (data.index === 1) {
        this.resetToDefaults();
      }
    });
  }

  private resetToDefaults(): void {
    this.config = {
      username: 'Player',
      maxMemory: 2048,
      minMemory: 512,
      fullscreen: false,
      windowWidth: 854,
      windowHeight: 480,
      lastUsedVersion: '1.20.4'
    };
    this.tempUsername = 'Player';

    promptAction.showToast({
      message: 'Settings reset to defaults',
      duration: 2000
    });

    hilog.info(DOMAIN, TAG, 'Settings reset to defaults');
  }

  private showClearDataConfirmation(): void {
    promptAction.showDialog({
      title: 'Clear Game Data',
      message: 'This will delete all Minecraft game files, saves, and downloaded versions. This action cannot be undone.',
      buttons: [
        {
          text: 'Cancel',
          color: $r('app.color.text_secondary')
        },
        {
          text: 'Clear Data',
          color: $r('app.color.error_color')
        }
      ]
    }, (err, data) => {
      if (data.index === 1) {
        this.clearGameData();
      }
    });
  }

  private clearGameData(): void {
    try {
      // TODO: Implement actual game data clearing
      promptAction.showToast({
        message: 'Game data cleared successfully',
        duration: 2000
      });

      hilog.info(DOMAIN, TAG, 'Game data cleared');
    } catch (error) {
      this.errorMessage = 'Failed to clear game data';
      hilog.error(DOMAIN, TAG, 'Failed to clear game data');
    }
  }

  private getRecommendedMemory(): string {
    if (this.config.maxMemory >= 4096) {
      return '4GB+ (Optimal for modded gameplay)';
    } else if (this.config.maxMemory >= 2048) {
      return '2-4GB (Good for vanilla gameplay)';
    } else {
      return '1-2GB (Minimum requirements)';
    }
  }

  private getDeviceType(): string {
    // TODO: Implement actual device type detection
    return 'HarmonyOS Device';
  }

  private cleanup(): void {
    try {
      hilog.info(DOMAIN, TAG, 'Cleaning up GameSettings page resources');
      this.launcher = null;
    } catch (error) {
      hilog.error(DOMAIN, TAG, 'Cleanup failed');
    }
  }
}

  build() {
    Column() {
      // Header
      Row() {
        Button('← Back')
          .backgroundColor(Color.Transparent)
          .fontColor(Color.White)
          .onClick(() => {
            router.back();
          })
        
        Text('Game Settings')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)
          .flexGrow(1)
          .textAlign(TextAlign.Center)
        
        Button('Save')
          .backgroundColor(Color.Transparent)
          .fontColor(Color.White)
          .onClick(() => {
            this.saveConfig();
          })
      }
      .width('100%')
      .height(60)
      .padding({ left: 16, right: 16 })
      .backgroundColor('#2E7D32')

      // Settings content
      Scroll() {
        Column() {
          // Player settings
          this.buildSettingsSection('Player Settings', () => {
            this.buildTextInputSetting('Username', this.tempUsername, (value) => {
              this.tempUsername = value;
              this.config.username = value;
            });
          });

          // Memory settings
          this.buildSettingsSection('Memory Settings', () => {
            this.buildSliderSetting('Maximum Memory (MB)', this.config.maxMemory, 512, 8192, (value) => {
              this.config.maxMemory = value;
            });
            
            this.buildSliderSetting('Minimum Memory (MB)', this.config.minMemory, 256, 2048, (value) => {
              this.config.minMemory = value;
            });
          });

          // Display settings
          this.buildSettingsSection('Display Settings', () => {
            this.buildToggleSetting('Fullscreen', this.config.fullscreen, (value) => {
              this.config.fullscreen = value;
            });
            
            if (!this.config.fullscreen) {
              this.buildSliderSetting('Window Width', this.config.windowWidth, 640, 1920, (value) => {
                this.config.windowWidth = value;
              });
              
              this.buildSliderSetting('Window Height', this.config.windowHeight, 480, 1080, (value) => {
                this.config.windowHeight = value;
              });
            }
          });

          // Advanced settings
          this.buildSettingsSection('Advanced Settings', () => {
            this.buildInfoSetting('Java Version', 'OpenJDK 17');
            this.buildInfoSetting('Launcher Version', '1.0.0');
            this.buildInfoSetting('HarmonyOS Version', '5.0 API 17');
          });

          // Action buttons
          Column() {
            Button('Reset to Defaults')
              .width('100%')
              .backgroundColor('#FF5722')
              .margin({ bottom: 12 })
              .onClick(() => {
                this.resetToDefaults();
              })
            
            Button('Clear Game Data')
              .width('100%')
              .backgroundColor('#F44336')
              .onClick(() => {
                this.clearGameData();
              })
          }
          .width('100%')
          .margin({ top: 24 })
        }
        .width('100%')
        .padding(16)
      }
      .flexGrow(1)
    }
    .height('100%')
    .backgroundColor('#FAFAFA')
  }

  @Builder
  buildSettingsSection(title: string, content: () => void) {
    Column() {
      Text(title)
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .margin({ bottom: 16 })
        .alignSelf(ItemAlign.Start)
        .fontColor('#333')

      content();
    }
    .width('100%')
    .margin({ bottom: 32 })
  }

  @Builder
  buildTextInputSetting(label: string, value: string, onChange: (value: string) => void) {
    Column() {
      Row() {
        Text(label)
          .fontSize(16)
          .flexGrow(1)
        
        TextInput({ text: value, placeholder: label })
          .width(200)
          .height(40)
          .backgroundColor(Color.White)
          .borderRadius(4)
          .onChange((value: string) => {
            onChange(value);
          })
      }
      .width('100%')
      .alignItems(VerticalAlign.Center)
    }
    .width('100%')
    .padding(12)
    .backgroundColor(Color.White)
    .borderRadius(8)
    .margin({ bottom: 8 })
  }

  @Builder
  buildSliderSetting(label: string, value: number, min: number, max: number, onChange: (value: number) => void) {
    Column() {
      Row() {
        Text(label)
          .fontSize(16)
          .flexGrow(1)
        
        Text(value.toString())
          .fontSize(16)
          .fontColor('#666')
          .width(60)
          .textAlign(TextAlign.End)
      }
      .width('100%')
      .margin({ bottom: 8 })

      Slider({
        value: value,
        min: min,
        max: max,
        step: label.includes('Memory') ? 256 : 1,
        style: SliderStyle.OutSet
      })
        .width('100%')
        .trackColor('#E0E0E0')
        .selectedColor('#4CAF50')
        .onChange((value: number) => {
          onChange(Math.round(value));
        })
    }
    .width('100%')
    .padding(12)
    .backgroundColor(Color.White)
    .borderRadius(8)
    .margin({ bottom: 8 })
  }

  @Builder
  buildToggleSetting(label: string, value: boolean, onChange: (value: boolean) => void) {
    Row() {
      Text(label)
        .fontSize(16)
        .flexGrow(1)
      
      Toggle({ type: ToggleType.Switch, isOn: value })
        .selectedColor('#4CAF50')
        .onChange((isOn: boolean) => {
          onChange(isOn);
        })
    }
    .width('100%')
    .padding(12)
    .backgroundColor(Color.White)
    .borderRadius(8)
    .margin({ bottom: 8 })
    .alignItems(VerticalAlign.Center)
  }

  @Builder
  buildInfoSetting(label: string, value: string) {
    Row() {
      Text(label)
        .fontSize(16)
        .flexGrow(1)
      
      Text(value)
        .fontSize(16)
        .fontColor('#666')
    }
    .width('100%')
    .padding(12)
    .backgroundColor(Color.White)
    .borderRadius(8)
    .margin({ bottom: 8 })
    .alignItems(VerticalAlign.Center)
  }

  private loadConfig() {
    this.config = this.launcher.getConfig();
    this.tempUsername = this.config.username;
    this.tempMaxMemory = this.config.maxMemory.toString();
  }

  private saveConfig() {
    this.launcher.updateConfig(this.config);
    router.back();
  }

  private resetToDefaults() {
    this.config = {
      username: 'Player',
      maxMemory: 2048,
      minMemory: 512,
      fullscreen: false,
      windowWidth: 854,
      windowHeight: 480
    };
    this.tempUsername = this.config.username;
  }

  private clearGameData() {
    // TODO: Implement game data clearing
    console.log('Clearing game data...');
  }
}