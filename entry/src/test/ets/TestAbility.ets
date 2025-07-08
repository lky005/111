import hilog from '@ohos.hilog';
import TestRunner from '@ohos.application.testRunner';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';

var abilityDelegator = undefined;
var abilityDelegatorArguments = undefined;

export default class TestAbility extends TestRunner {
  onPrepare() {
    hilog.info(0x0000, 'TestRunner', 'TestAbility onPrepare');
  }

  onRun() {
    hilog.info(0x0000, 'TestRunner', 'TestAbility onRun start');
    abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
    abilityDelegatorArguments = AbilityDelegatorRegistry.getArguments();
    hilog.info(0x0000, 'TestRunner', 'start run testcase!!!');
    Hypium.hypiumTest(abilityDelegator, abilityDelegatorArguments, testsuite);
  }
};

function testsuite() {
  import PojavLauncherTest from './PojavLauncherTest';
  PojavLauncherTest();
}