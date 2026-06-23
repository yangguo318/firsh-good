import UIAbility from '@ohos.app.ability.UIAbility';
import hilog from '@ohos.hilog';
import window from '@ohos.window';
import Want from '@ohos.app.ability.Want';
import AbilityConstant from '@ohos.app.ability.AbilityConstant';

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(0x0000, 'WatchFace', 'EntryAbility onCreate');
  }

  onDestroy(): void {
    hilog.info(0x0000, 'WatchFace', 'EntryAbility onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    hilog.info(0x0000, 'WatchFace', 'EntryAbility onWindowStageCreate');
    windowStage.loadContent('pages/Index').then(() => {
      hilog.info(0x0000, 'WatchFace', 'Content loaded');
    }).catch((err: Error) => {
      hilog.error(0x0000, 'WatchFace', 'Load failed: %{public}s', JSON.stringify(err));
    });
  }

  onWindowStageDestroy(): void {
    hilog.info(0x0000, 'WatchFace', 'EntryAbility onWindowStageDestroy');
  }

  onForeground(): void {
    hilog.info(0x0000, 'WatchFace', 'EntryAbility onForeground');
  }

  onBackground(): void {
    hilog.info(0x0000, 'WatchFace', 'EntryAbility onBackground');
  }
};
