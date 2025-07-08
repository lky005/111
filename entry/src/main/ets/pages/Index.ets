import router from '@ohos.router';
import hilog from '@ohos.hilog';

@Entry
@Component
struct Index {
  @State message: string = 'PojavLauncher for HarmonyOS';
  @State isLoading: boolean = false;

  build() {
    Row() {
      Column() {
        // Logo and title
        Text(this.message)
          .fontSize(28)
          .fontWeight(FontWeight.Bold)
          .fontColor('#007DFF')
          .margin({ bottom: 30 })

        // Version info
        Text('HarmonyOS Next Edition')
          .fontSize(16)
          .fontColor('#666666')
          .margin({ bottom: 40 })

        // Main buttons
        Column({ space: 20 }) {
          Button($r('app.string.launch_minecraft'))
            .width('80%')
            .height(50)
            .fontSize(18)
            .backgroundColor('#007DFF')
            .onClick(() => {
              this.launchMinecraft();
            })

          Button($r('app.string.version_select'))
            .width('80%')
            .height(50)
            .fontSize(18)
            .backgroundColor('#52C41A')
            .onClick(() => {
              this.openVersionSelect();
            })

          Button($r('app.string.settings'))
            .width('80%')
            .height(50)
            .fontSize(18)
            .backgroundColor('#722ED1')
            .onClick(() => {
              this.openSettings();
            })
        }
        .width('100%')
        .alignItems(HorizontalAlign.Center)

        // Loading indicator
        if (this.isLoading) {
          LoadingProgress()
            .width(50)
            .height(50)
            .margin({ top: 30 })
            .color('#007DFF')
        }

        // Status text
        Text('Ready to launch Minecraft Java Edition')
          .fontSize(14)
          .fontColor('#999999')
          .margin({ top: 30 })
      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
      .padding(20)
    }
    .height('100%')
    .backgroundColor('#F1F3F5')
  }

  private launchMinecraft() {
    hilog.info(0x0000, 'PojavLauncher', 'Launching Minecraft...');
    this.isLoading = true;
    
    // Navigate to launcher page
    router.pushUrl({
      url: 'pages/LauncherPage'
    }).catch((err) => {
      hilog.error(0x0000, 'PojavLauncher', 'Failed to navigate: %{public}s', JSON.stringify(err));
      this.isLoading = false;
    });
  }

  private openVersionSelect() {
    hilog.info(0x0000, 'PojavLauncher', 'Opening version selection...');
    // TODO: Implement version selection logic
  }

  private openSettings() {
    hilog.info(0x0000, 'PojavLauncher', 'Opening settings...');
    router.pushUrl({
      url: 'pages/SettingsPage'
    }).catch((err) => {
      hilog.error(0x0000, 'PojavLauncher', 'Failed to navigate: %{public}s', JSON.stringify(err));
    });
  }
}