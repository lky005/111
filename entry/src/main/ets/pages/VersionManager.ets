import router from '@ohos.router';
import { MinecraftLauncher } from '../launcher/MinecraftLauncher';

@Entry
@Component
struct VersionManager {
  @State versions: string[] = [];
  @State selectedVersion: string = '1.20.4';
  @State isLoading: boolean = true;
  @State downloadingVersion: string = '';
  @State downloadProgress: number = 0;
  private launcher: MinecraftLauncher = new MinecraftLauncher();

  aboutToAppear() {
    this.loadVersions();
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
        
        Text('Version Manager')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)
          .flexGrow(1)
          .textAlign(TextAlign.Center)
        
        Button('Refresh')
          .backgroundColor(Color.Transparent)
          .fontColor(Color.White)
          .onClick(() => {
            this.loadVersions();
          })
      }
      .width('100%')
      .height(60)
      .padding({ left: 16, right: 16 })
      .backgroundColor('#2E7D32')

      // Content
      Column() {
        if (this.isLoading) {
          Column() {
            LoadingProgress()
              .width(50)
              .height(50)
              .margin({ bottom: 16 })
            
            Text('Loading versions...')
              .fontSize(16)
              .fontColor('#666')
          }
          .justifyContent(FlexAlign.Center)
          .height('100%')
        } else {
          // Version categories
          Column() {
            Text('Available Versions')
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .margin({ bottom: 16 })
              .alignSelf(ItemAlign.Start)

            // Release versions
            this.buildVersionCategory('Release', this.versions.filter(v => !v.includes('pre') && !v.includes('rc')))
            
            // Pre-release versions (if any)
            this.buildVersionCategory('Pre-release', this.versions.filter(v => v.includes('pre') || v.includes('rc')))
          }
          .width('100%')
        }
      }
      .padding(16)
      .flexGrow(1)
    }
    .height('100%')
    .backgroundColor('#FAFAFA')
  }

  @Builder
  buildVersionCategory(title: string, versions: string[]) {
    if (versions.length > 0) {
      Column() {
        Text(title)
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .margin({ bottom: 8 })
          .alignSelf(ItemAlign.Start)
          .fontColor('#333')

        ForEach(versions, (version: string) => {
          this.buildVersionItem(version);
        }, (version: string) => version)
      }
      .width('100%')
      .margin({ bottom: 24 })
    }
  }

  @Builder
  buildVersionItem(version: string) {
    Row() {
      Column() {
        Text(`Minecraft ${version}`)
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .alignSelf(ItemAlign.Start)
        
        Text(this.getVersionType(version))
          .fontSize(12)
          .fontColor('#666')
          .alignSelf(ItemAlign.Start)
      }
      .flexGrow(1)
      .alignItems(HorizontalAlign.Start)

      if (this.downloadingVersion === version) {
        Column() {
          Progress({ value: this.downloadProgress, total: 100, type: ProgressType.Ring })
            .width(24)
            .height(24)
            .color('#4CAF50')
          
          Text(`${this.downloadProgress}%`)
            .fontSize(10)
            .fontColor('#666')
        }
      } else if (this.isVersionInstalled(version)) {
        Button(this.selectedVersion === version ? 'Selected' : 'Select')
          .backgroundColor(this.selectedVersion === version ? '#4CAF50' : '#2196F3')
          .fontSize(14)
          .onClick(() => {
            this.selectVersion(version);
          })
      } else {
        Button('Download')
          .backgroundColor('#FF9800')
          .fontSize(14)
          .onClick(() => {
            this.downloadVersion(version);
          })
      }
    }
    .width('100%')
    .padding(12)
    .backgroundColor(Color.White)
    .borderRadius(8)
    .margin({ bottom: 8 })
    .shadow({
      radius: 2,
      color: '#E0E0E0',
      offsetX: 0,
      offsetY: 1
    })
  }

  private async loadVersions() {
    this.isLoading = true;
    try {
      // Simulate loading delay
      await new Promise(resolve => setTimeout(resolve, 1000));
      this.versions = this.launcher.getAvailableVersions();
    } catch (error) {
      console.error('Failed to load versions:', error);
    } finally {
      this.isLoading = false;
    }
  }

  private getVersionType(version: string): string {
    if (version.includes('pre')) return 'Pre-release';
    if (version.includes('rc')) return 'Release Candidate';
    return 'Release';
  }

  private isVersionInstalled(version: string): boolean {
    // TODO: Check actual installation status
    return ['1.20.4', '1.19.4'].includes(version);
  }

  private selectVersion(version: string) {
    this.selectedVersion = version;
    // TODO: Save selection and pass back to main page
    router.back();
  }

  private async downloadVersion(version: string) {
    this.downloadingVersion = version;
    this.downloadProgress = 0;

    try {
      await this.launcher.downloadVersion(version, (progress) => {
        this.downloadProgress = progress;
      });
      
      // Download completed
      this.downloadingVersion = '';
      this.downloadProgress = 0;
    } catch (error) {
      console.error('Download failed:', error);
      this.downloadingVersion = '';
      this.downloadProgress = 0;
    }
  }
}