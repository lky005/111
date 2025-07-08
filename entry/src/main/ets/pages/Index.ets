import router from '@ohos.router';
import { MinecraftLauncher } from '../launcher/MinecraftLauncher';

@Entry
@Component
struct Index {
  @State message: string = 'Minecraft Launcher';
  @State selectedVersion: string = '1.20.4';
  @State isLaunching: boolean = false;
  @State downloadProgress: number = 0;
  private launcher: MinecraftLauncher = new MinecraftLauncher();

  build() {
    Column() {
      // Header
      Row() {
        Text('MC Launcher')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)
        
        Blank()
        
        Button('Settings')
          .backgroundColor(Color.Transparent)
          .fontColor(Color.White)
          .onClick(() => {
            router.pushUrl({ url: 'pages/GameSettings' });
          })
      }
      .width('100%')
      .height(60)
      .padding({ left: 16, right: 16 })
      .backgroundColor('#2E7D32')

      // Main content area
      Column() {
        // Version selector section
        Column() {
          Text('Select Version')
            .fontSize(18)
            .fontWeight(FontWeight.Medium)
            .margin({ bottom: 12 })
            .alignSelf(ItemAlign.Start)

          Row() {
            Text(`Minecraft ${this.selectedVersion}`)
              .fontSize(16)
              .flexGrow(1)
              .textAlign(TextAlign.Start)
            
            Button('Change')
              .backgroundColor('#4CAF50')
              .onClick(() => {
                router.pushUrl({ url: 'pages/VersionManager' });
              })
          }
          .width('100%')
          .padding(12)
          .backgroundColor('#F5F5F5')
          .borderRadius(8)
        }
        .width('100%')
        .margin({ bottom: 24 })

        // Launch button section
        Column() {
          if (this.isLaunching) {
            Column() {
              Text('Launching Minecraft...')
                .fontSize(16)
                .margin({ bottom: 8 })
              
              Progress({ value: this.downloadProgress, total: 100, type: ProgressType.Linear })
                .width('100%')
                .color('#4CAF50')
                .margin({ bottom: 8 })
              
              Text(`${this.downloadProgress}%`)
                .fontSize(14)
                .fontColor('#666')
            }
            .width('100%')
          } else {
            Button('Launch Game')
              .width('100%')
              .height(56)
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .backgroundColor('#4CAF50')
              .borderRadius(12)
              .onClick(() => {
                this.launchGame();
              })
          }
        }
        .width('100%')
        .margin({ bottom: 24 })

        // Quick actions
        Row() {
          Button('Profiles')
            .flexGrow(1)
            .backgroundColor('#2196F3')
            .margin({ right: 8 })
            .onClick(() => {
              router.pushUrl({ url: 'pages/ProfileManager' });
            })
          
          Button('Mods')
            .flexGrow(1)
            .backgroundColor('#FF9800')
            .margin({ left: 8 })
            .onClick(() => {
              // TODO: Implement mod manager
            })
        }
        .width('100%')
        .margin({ bottom: 24 })

        // Status area
        Column() {
          Text('Status: Ready')
            .fontSize(14)
            .fontColor('#666')
            .margin({ bottom: 4 })
          
          Text('Java Version: OpenJDK 17')
            .fontSize(12)
            .fontColor('#999')
        }
        .alignItems(HorizontalAlign.Start)
        .width('100%')
      }
      .padding(16)
      .flexGrow(1)
    }
    .height('100%')
    .backgroundColor('#FAFAFA')
  }

  private async launchGame() {
    this.isLaunching = true;
    this.downloadProgress = 0;

    try {
      // Simulate download progress
      for (let i = 0; i <= 100; i += 10) {
        this.downloadProgress = i;
        await new Promise(resolve => setTimeout(resolve, 200));
      }

      // Launch the game
      await this.launcher.launchMinecraft(this.selectedVersion);
      
      // Reset state
      this.isLaunching = false;
      this.downloadProgress = 0;
    } catch (error) {
      console.error('Launch failed:', error);
      this.isLaunching = false;
      this.downloadProgress = 0;
    }
  }
}