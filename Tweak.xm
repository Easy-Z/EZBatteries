#import <notify.h>
#import "JBBulletinManager.h"

@class UNSRemoteNotificationServer;

@interface UIStatusBarWindow : UIWindow
-(void)check; //from %new
@end

@interface BCBatteryDeviceController {
    NSArray *_sortedDevices;
}

+ (id)sharedInstance;
@end

@interface BCBatteryDevice {
    long long _percentCharge;
    NSString *_name;
}
@end

static NSString *notifMsg = @"";
static NSString *deviceName;
static long long deviceCharge;
static BOOL alert;

static void loadPrefs() {
  CFStringRef APPID = CFSTR("com.easy-z.ezbatteriesprefs");
  NSArray *keyList = [(NSArray *)CFPreferencesCopyKeyList((CFStringRef)APPID, kCFPreferencesCurrentUser, kCFPreferencesAnyHost) autorelease];
	NSDictionary *prefs = (NSDictionary *)CFPreferencesCopyMultiple((CFArrayRef)keyList, (CFStringRef)APPID, kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
  alert = [[prefs valueForKey:@"alert"] boolValue];
}

%hook UIStatusBarWindow
- (instancetype)initWithFrame:(CGRect)frame {
    self = %orig;

    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(check)];
    tapRecognizer.numberOfTapsRequired = 2;

    [self addGestureRecognizer:tapRecognizer];

    return self;
}

%new
-(void)check{
  notify_post("com.easy-z.ezbatteries");
}

%end


%ctor {
  if ([NSBundle.mainBundle.bundleIdentifier isEqual:@"com.apple.springboard"]) { //check if its springboard
    int regToken; // The registration token
    notify_register_dispatch("com.easy-z.ezbatteries", &regToken, dispatch_get_main_queue(), ^(int token) {  //Request notification delivery to a dispatch queue
    BCBatteryDeviceController *bcb = [%c(BCBatteryDeviceController) sharedInstance];
    NSArray *devices = MSHookIvar<NSArray *>(bcb, "_sortedDevices");
    loadPrefs();
    UIAlertController *confirmationAlertController;

    if (alert) {
      confirmationAlertController = [UIAlertController
      alertControllerWithTitle:@"Percentages"
      message:@""
      preferredStyle:UIAlertControllerStyleAlert];
    }

    for (BCBatteryDevice *device in devices) {
      deviceName = MSHookIvar<NSString *>(device, "_name");
      deviceCharge = MSHookIvar<long long>(device, "_percentCharge");
      notifMsg = [notifMsg stringByAppendingString:[NSString stringWithFormat:@"%@ : %lld%%\n", deviceName, deviceCharge]];
      }

      //Removes the last \n to remove gap
      notifMsg = [notifMsg substringToIndex:[notifMsg length]-1];

      //shows the alert if it is checked in prefs
      if (alert) {
        confirmationAlertController.title = @"Percentages";
        UIAlertAction *confirmCancel = [UIAlertAction
        actionWithTitle:@"Dismiss"
        style:UIAlertActionStyleDefault
        handler:^(UIAlertAction * action)
        {
          //Do nothing
        }];

        [confirmationAlertController addAction:confirmCancel];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:confirmationAlertController animated:YES completion:NULL];
        confirmationAlertController.message =  [confirmationAlertController.message stringByAppendingString:notifMsg];
      } else { // creates notif instead
        UIImage *img = [UIImage imageWithContentsOfFile:@"/Library/EZBatteries/icon.png"];
        [[objc_getClass("JBBulletinManager") sharedInstance] showBulletinWithTitle:@"Percentages" message:notifMsg overrideBundleImage:img];
      }
      notifMsg = @"";
    });
  }
}
