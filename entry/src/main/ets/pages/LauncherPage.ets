import router from '@ohos.router';
import hilog from '@ohos.hilog';
import { MinecraftLauncher, LaunchEvent, LaunchOptions } from '../utils/MinecraftLauncher';
import { LaunchEventType, AppConstants } from '../common/constants/AppConstants';

@Entry
@Component
struct LauncherPage {
  @State launchStatus: string = 'Initializing...';
  @State progressValue: number = 0;
  @State isLaunching: boolean = false;
  @State gameOutput: string = 'Game Output:\n\n[INFO] PojavLauncher initialized\n[INFO] Checking for Java runtime\n[INFO] Loading game assets\n[INFO] Ready to launch';
  private launcher: MinecraftLauncher = MinecraftLauncher.getInstance();

  aboutToAppear() {
    this.initializeMinecraft();
    this.setupLaunchCallback();
  }

  private setupLaunchCallback() {
    this.launcher.setLaunchCallback((event: LaunchEvent) => {
      this.handleLaunchEvent(event);
    });
  }

  private handleLaunchEvent(event: LaunchEvent) {
    switch (event.type) {
      case LaunchEventType.INITIALIZING:
        this.launchStatus = 'Initializing game environment...';
        this.progressValue = 10;
        break;
      case LaunchEventType.DOWNLOADING:
        this.launchStatus = event.message;
        this.progressValue = event.progress || 0;
        break;
      case LaunchEventType.LOADING_ASSETS:
        this.launchStatus = 'Loading game assets...';
        this.progressValue = 60;
        break;
      case LaunchEventType.STARTING_GAME:
        this.launchStatus = 'Starting Minecraft...';
        this.progressValue = 90;
        break;
      case LaunchEventType.COMPLETE:
        this.launchStatus = 'Minecraft is running';
        this.progressValue = 100;
        this.isLaunching = false;
        this.appendGameOutput('[INFO] Minecraft launched successfully!');
        break;
      case LaunchEventType.ERROR:
        this.launchStatus = 'Launch failed: ' + event.message;
        this.isLaunching = false;
        this.progressValue = 0;
        this.appendGameOutput('[ERROR] ' + event.message);
        break;
    }
  }

  private appendGameOutput(message: string) {
    this.gameOutput += '\n' + message;
  }

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
        
        Text('Minecraft Launcher')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
      }
      .width('100%')
      .padding(20)
      .alignItems(VerticalAlign.Center)

      // Main content
      Column({ space: 30 }) {
        // Minecraft logo placeholder
        Text('🎮')
          .fontSize(80)
        
        Text('Minecraft Java Edition')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .fontColor('#007DFF')

        // Launch status
        Text(this.launchStatus)
          .fontSize(16)
          .fontColor('#666666')
          .textAlign(TextAlign.Center)

        // Progress bar
        if (this.isLaunching) {
          Progress({
            value: this.progressValue,
            total: 100,
            type: ProgressType.Linear
          })
          .width('80%')
          .color('#007DFF')
          .backgroundColor('#E6F7FF')
        }

        // Launch controls
        Row({ space: 20 }) {
          Button('Launch Game')
            .width(120)
            .height(40)
            .backgroundColor(this.isLaunching ? '#CCCCCC' : '#52C41A')
            .enabled(!this.isLaunching)
            .onClick(() => {
              this.startMinecraft();
            })

          Button('Stop')
            .width(80)
            .height(40)
            .backgroundColor('#FF4D4F')
            .enabled(this.isLaunching)
            .onClick(() => {
              this.stopMinecraft();
            })
        }

        // Game output log
        ScrollArea() {
          Text(this.gameOutput)
            .fontSize(12)
            .fontFamily('monospace')
            .backgroundColor('#000000')
            .fontColor('#00FF00')
            .padding(15)
            .width('100%')
            .textAlign(TextAlign.Start)
        }
        .width('90%')
        .height(200)
        .backgroundColor('#000000')
        .border({ width: 1, color: '#CCCCCC' })
      }
      .width('100%')
      .padding(20)
      .justifyContent(FlexAlign.Start)
      .alignItems(HorizontalAlign.Center)
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F1F3F5')
  }

  private async initializeMinecraft() {
    hilog.info(0x0000, 'PojavLauncher', 'Initializing Minecraft environment...');
    this.launchStatus = 'Checking Java runtime...';
    
    try {
      const initialized = await this.launcher.initialize();
      if (initialized) {
        this.launchStatus = 'Ready to launch';
        this.appendGameOutput('[INFO] Launcher initialized successfully');
      } else {
        this.launchStatus = 'Initialization failed';
        this.appendGameOutput('[ERROR] Failed to initialize launcher');
      }
    } catch (error) {
      this.launchStatus = 'Initialization error';
      this.appendGameOutput('[ERROR] ' + error.toString());
    }
  }

  private async startMinecraft() {
    hilog.info(0x0000, 'PojavLauncher', 'Starting Minecraft...');
    this.isLaunching = true;
    this.launchStatus = 'Starting Minecraft Java Edition...';
    this.progressValue = 0;
    this.appendGameOutput('[INFO] Starting launch process...');

    const launchOptions: LaunchOptions = {
      version: '1.20.4',
      username: 'Player',
      memoryMb: AppConstants.DEFAULT_JAVA_MEMORY,
      gameDirectory: AppConstants.DEFAULT_GAME_DIR
    };

    try {
      const result = await this.launcher.launchMinecraft(launchOptions);
      if (!result.success) {
        this.launchStatus = 'Launch failed: ' + result.message;
        this.isLaunching = false;
        this.appendGameOutput('[ERROR] ' + result.message);
      }
    } catch (error) {
      this.launchStatus = 'Launch error: ' + error.toString();
      this.isLaunching = false;
      this.appendGameOutput('[ERROR] ' + error.toString());
    }
  }

  private stopMinecraft() {
    hilog.info(0x0000, 'PojavLauncher', 'Stopping Minecraft...');
    const stopped = this.launcher.stopMinecraft();
    if (stopped) {
      this.isLaunching = false;
      this.launchStatus = 'Minecraft stopped';
      this.progressValue = 0;
      this.appendGameOutput('[INFO] Minecraft stopped by user');
    } else {
      this.appendGameOutput('[ERROR] Failed to stop Minecraft');
    }
  }
}