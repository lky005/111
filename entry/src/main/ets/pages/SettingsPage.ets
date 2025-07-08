import router from '@ohos.router';
import hilog from '@ohos.hilog';
import { AppConstants } from '../common/constants/AppConstants';

@Entry
@Component
struct SettingsPage {
  @State javaMemory: number = AppConstants.DEFAULT_JAVA_MEMORY; // MB
  @State gameDirectory: string = AppConstants.DEFAULT_GAME_DIR;
  @State enableMods: boolean = true;
  @State renderDistance: number = AppConstants.DEFAULT_RENDER_DISTANCE;

  build() {
    Column() {
      // Header
      Row() {
        Button('← Back')
          .backgroundColor(Color.Transparent)
          .fontColor('#007DFF')
          .onClick(() => {
            router.back();
          })
        
        Blank()
        
        Text('Settings')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
      }
      .width('100%')
      .padding(20)
      .alignItems(VerticalAlign.Center)

      // Settings content
      Scroll() {
        Column({ space: 20 }) {
          // Java Settings Section
          this.SectionHeader('Java Settings')
          
          this.SettingRow('Java Memory (MB)') {
            Row() {
              Text(this.javaMemory.toString())
                .fontSize(16)
                .fontColor('#666666')
              
              Slider({
                value: this.javaMemory,
                min: AppConstants.MIN_JAVA_MEMORY,
                max: AppConstants.MAX_JAVA_MEMORY,
                step: 256
              })
                .width(150)
                .trackColor('#E6F7FF')
                .selectedColor('#007DFF')
                .onChange((value: number) => {
                  this.javaMemory = Math.round(value);
                })
            }
          }

          // Game Settings Section
          this.SectionHeader('Game Settings')
          
          this.SettingRow('Game Directory') {
            TextInput({ text: this.gameDirectory })
              .width(200)
              .fontSize(14)
              .onChange((value: string) => {
                this.gameDirectory = value;
              })
          }

          this.SettingRow('Enable Mods') {
            Toggle({ type: ToggleType.Switch, isOn: this.enableMods })
              .selectedColor('#007DFF')
              .onChange((isOn: boolean) => {
                this.enableMods = isOn;
              })
          }

          this.SettingRow('Render Distance') {
            Row() {
              Text(this.renderDistance.toString())
                .fontSize(16)
                .fontColor('#666666')
              
              Slider({
                value: this.renderDistance,
                min: AppConstants.MIN_RENDER_DISTANCE,
                max: AppConstants.MAX_RENDER_DISTANCE,
                step: 1
              })
                .width(150)
                .trackColor('#E6F7FF')
                .selectedColor('#007DFF')
                .onChange((value: number) => {
                  this.renderDistance = Math.round(value);
                })
            }
          }

          // Control Settings Section
          this.SectionHeader('Control Settings')
          
          Button('Configure Controls')
            .width('80%')
            .height(40)
            .backgroundColor('#722ED1')
            .onClick(() => {
              this.configureControls();
            })

          Button('Reset to Defaults')
            .width('80%')
            .height(40)
            .backgroundColor('#FF4D4F')
            .onClick(() => {
              this.resetSettings();
            })

          // About Section
          this.SectionHeader('About')
          
          Text('PojavLauncher for HarmonyOS Next')
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor('#007DFF')
          
          Text(`Version ${AppConstants.APP_VERSION} (API Level ${AppConstants.API_LEVEL})`)
            .fontSize(14)
            .fontColor('#666666')
          
          Text('Based on PojavLauncher open source project')
            .fontSize(12)
            .fontColor('#999999')
            .textAlign(TextAlign.Center)
            .margin({ top: 10 })
        }
        .width('100%')
        .padding(20)
      }
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F1F3F5')
  }

  @Builder SectionHeader(title: string) {
    Text(title)
      .fontSize(18)
      .fontWeight(FontWeight.Bold)
      .fontColor('#007DFF')
      .margin({ top: 20, bottom: 10 })
      .alignSelf(ItemAlign.Start)
  }

  @Builder SettingRow(label: string, @BuilderParam content: () => void) {
    Row() {
      Text(label)
        .fontSize(16)
        .layoutWeight(1)
      
      content()
    }
    .width('100%')
    .padding({ left: 10, right: 10, top: 15, bottom: 15 })
    .backgroundColor(Color.White)
    .borderRadius(8)
    .alignItems(VerticalAlign.Center)
  }

  private configureControls() {
    hilog.info(0x0000, 'PojavLauncher', 'Opening control configuration...');
    // TODO: Implement control configuration
  }

  private resetSettings() {
    hilog.info(0x0000, 'PojavLauncher', 'Resetting settings to defaults...');
    this.javaMemory = AppConstants.DEFAULT_JAVA_MEMORY;
    this.gameDirectory = AppConstants.DEFAULT_GAME_DIR;
    this.enableMods = true;
    this.renderDistance = AppConstants.DEFAULT_RENDER_DISTANCE;
  }
}