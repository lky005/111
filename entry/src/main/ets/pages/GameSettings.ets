import router from '@ohos.router';
import { MinecraftLauncher, LauncherConfig } from '../launcher/MinecraftLauncher';

@Entry
@Component
struct GameSettings {
  @State config: LauncherConfig = {
    username: 'Player',
    maxMemory: 2048,
    minMemory: 512,
    fullscreen: false,
    windowWidth: 854,
    windowHeight: 480
  };
  @State tempUsername: string = '';
  @State tempMaxMemory: string = '';
  private launcher: MinecraftLauncher = new MinecraftLauncher();

  aboutToAppear() {
    this.loadConfig();
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
            this.buildInfoSetting('HarmonyOS Version', 'NEXT 4.1.0');
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