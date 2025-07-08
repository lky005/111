import router from '@ohos.router';

interface GameProfile {
  id: string;
  name: string;
  version: string;
  lastPlayed: string;
  playtime: number;
  icon: string;
}

@Entry
@Component
struct ProfileManager {
  @State profiles: GameProfile[] = [];
  @State selectedProfile: string = '';
  @State isCreatingProfile: boolean = false;
  @State newProfileName: string = '';
  @State newProfileVersion: string = '1.20.4';

  aboutToAppear() {
    this.loadProfiles();
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
        
        Text('Profile Manager')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)
          .flexGrow(1)
          .textAlign(TextAlign.Center)
        
        Button('+ New')
          .backgroundColor(Color.Transparent)
          .fontColor(Color.White)
          .onClick(() => {
            this.isCreatingProfile = true;
          })
      }
      .width('100%')
      .height(60)
      .padding({ left: 16, right: 16 })
      .backgroundColor('#2E7D32')

      // Content
      if (this.isCreatingProfile) {
        this.buildCreateProfileDialog();
      } else {
        this.buildProfileList();
      }
    }
    .height('100%')
    .backgroundColor('#FAFAFA')
  }

  @Builder
  buildProfileList() {
    Column() {
      if (this.profiles.length === 0) {
        Column() {
          Image($r('app.media.icon'))
            .width(80)
            .height(80)
            .margin({ bottom: 16 })
            .opacity(0.5)
          
          Text('No profiles yet')
            .fontSize(18)
            .fontColor('#666')
            .margin({ bottom: 8 })
          
          Text('Create your first profile to get started')
            .fontSize(14)
            .fontColor('#999')
            .margin({ bottom: 24 })
          
          Button('Create Profile')
            .backgroundColor('#4CAF50')
            .onClick(() => {
              this.isCreatingProfile = true;
            })
        }
        .justifyContent(FlexAlign.Center)
        .height('100%')
      } else {
        Scroll() {
          Column() {
            ForEach(this.profiles, (profile: GameProfile) => {
              this.buildProfileCard(profile);
            }, (profile: GameProfile) => profile.id)
          }
          .width('100%')
          .padding(16)
        }
        .flexGrow(1)
      }
    }
    .width('100%')
    .flexGrow(1)
  }

  @Builder
  buildProfileCard(profile: GameProfile) {
    Row() {
      // Profile icon
      Image($r('app.media.icon'))
        .width(60)
        .height(60)
        .borderRadius(8)
        .margin({ right: 16 })

      // Profile info
      Column() {
        Text(profile.name)
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .alignSelf(ItemAlign.Start)
          .margin({ bottom: 4 })
        
        Text(`Minecraft ${profile.version}`)
          .fontSize(14)
          .fontColor('#666')
          .alignSelf(ItemAlign.Start)
          .margin({ bottom: 2 })
        
        Text(`Last played: ${profile.lastPlayed}`)
          .fontSize(12)
          .fontColor('#999')
          .alignSelf(ItemAlign.Start)
          .margin({ bottom: 2 })
        
        Text(`Playtime: ${this.formatPlaytime(profile.playtime)}`)
          .fontSize(12)
          .fontColor('#999')
          .alignSelf(ItemAlign.Start)
      }
      .flexGrow(1)
      .alignItems(HorizontalAlign.Start)

      // Actions
      Column() {
        Button(this.selectedProfile === profile.id ? 'Selected' : 'Select')
          .fontSize(12)
          .backgroundColor(this.selectedProfile === profile.id ? '#4CAF50' : '#2196F3')
          .margin({ bottom: 8 })
          .onClick(() => {
            this.selectProfile(profile.id);
          })
        
        Button('Edit')
          .fontSize(12)
          .backgroundColor('#FF9800')
          .margin({ bottom: 8 })
          .onClick(() => {
            this.editProfile(profile.id);
          })
        
        Button('Delete')
          .fontSize(12)
          .backgroundColor('#F44336')
          .onClick(() => {
            this.deleteProfile(profile.id);
          })
      }
    }
    .width('100%')
    .padding(16)
    .backgroundColor(Color.White)
    .borderRadius(12)
    .margin({ bottom: 12 })
    .shadow({
      radius: 4,
      color: '#E0E0E0',
      offsetX: 0,
      offsetY: 2
    })
  }

  @Builder
  buildCreateProfileDialog() {
    Column() {
      // Dialog content
      Column() {
        Text('Create New Profile')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .margin({ bottom: 24 })

        // Profile name input
        Column() {
          Text('Profile Name')
            .fontSize(16)
            .alignSelf(ItemAlign.Start)
            .margin({ bottom: 8 })
          
          TextInput({ placeholder: 'Enter profile name' })
            .width('100%')
            .height(40)
            .backgroundColor('#F5F5F5')
            .borderRadius(4)
            .onChange((value: string) => {
              this.newProfileName = value;
            })
        }
        .width('100%')
        .margin({ bottom: 20 })

        // Version selector
        Column() {
          Text('Minecraft Version')
            .fontSize(16)
            .alignSelf(ItemAlign.Start)
            .margin({ bottom: 8 })
          
          Select([
            { value: '1.20.4' },
            { value: '1.20.3' },
            { value: '1.20.2' },
            { value: '1.19.4' },
            { value: '1.19.3' },
            { value: '1.18.2' }
          ])
            .selected(0)
            .value('1.20.4')
            .font({ size: 16, weight: 400 })
            .onSelect((index: number, value: string) => {
              this.newProfileVersion = value;
            })
        }
        .width('100%')
        .margin({ bottom: 24 })

        // Action buttons
        Row() {
          Button('Cancel')
            .flexGrow(1)
            .backgroundColor('#9E9E9E')
            .margin({ right: 8 })
            .onClick(() => {
              this.cancelCreateProfile();
            })
          
          Button('Create')
            .flexGrow(1)
            .backgroundColor('#4CAF50')
            .margin({ left: 8 })
            .onClick(() => {
              this.createProfile();
            })
        }
        .width('100%')
      }
      .width('80%')
      .padding(24)
      .backgroundColor(Color.White)
      .borderRadius(12)
      .shadow({
        radius: 8,
        color: '#000000',
        offsetX: 0,
        offsetY: 4
      })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .backgroundColor('rgba(0, 0, 0, 0.5)')
  }

  private loadProfiles() {
    // Mock profile data
    this.profiles = [
      {
        id: '1',
        name: 'Survival World',
        version: '1.20.4',
        lastPlayed: '2024-01-15',
        playtime: 3600, // seconds
        icon: 'grass_block'
      },
      {
        id: '2',
        name: 'Creative Build',
        version: '1.20.3',
        lastPlayed: '2024-01-10',
        playtime: 7200,
        icon: 'diamond_block'
      }
    ];
    
    if (this.profiles.length > 0) {
      this.selectedProfile = this.profiles[0].id;
    }
  }

  private selectProfile(profileId: string) {
    this.selectedProfile = profileId;
    // TODO: Save selection
  }

  private editProfile(profileId: string) {
    // TODO: Implement profile editing
    console.log('Editing profile:', profileId);
  }

  private deleteProfile(profileId: string) {
    this.profiles = this.profiles.filter(p => p.id !== profileId);
    if (this.selectedProfile === profileId && this.profiles.length > 0) {
      this.selectedProfile = this.profiles[0].id;
    }
  }

  private createProfile() {
    if (this.newProfileName.trim() === '') {
      return;
    }

    const newProfile: GameProfile = {
      id: Date.now().toString(),
      name: this.newProfileName,
      version: this.newProfileVersion,
      lastPlayed: 'Never',
      playtime: 0,
      icon: 'grass_block'
    };

    this.profiles.push(newProfile);
    this.selectedProfile = newProfile.id;
    this.cancelCreateProfile();
  }

  private cancelCreateProfile() {
    this.isCreatingProfile = false;
    this.newProfileName = '';
    this.newProfileVersion = '1.20.4';
  }

  private formatPlaytime(seconds: number): string {
    const hours = Math.floor(seconds / 3600);
    const minutes = Math.floor((seconds % 3600) / 60);
    
    if (hours > 0) {
      return `${hours}h ${minutes}m`;
    } else if (minutes > 0) {
      return `${minutes}m`;
    } else {
      return `${seconds}s`;
    }
  }
}