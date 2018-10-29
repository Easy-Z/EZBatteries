#import <libactivator/libactivator.h>
#import <notify.h>

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

static NSString *deviceName;
static long long deviceCharge;

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
  notify_post("com.idevicehacked.ezbatteries");
}

%end



////using activator in your tweak- create object comforming to LAListener protocol
@interface EZBatteriesActivator :NSObject<LAListener>
@end

@implementation EZBatteriesActivator
///Register our listener names
+(void)load {
LAActivator *activator= [%c(LAActivator) sharedInstance];

if ([activator isRunningInsideSpringBoard]) {

[activator registerListener:[self new] forName:@"com.ezbatteries.show"];

[activator registerListener:[self new] forName:@"com.ezbatteries.hide"];

[activator registerListener:[self new] forName:@"com.ezbatteries.toggle"];
}
}

///React to our listener being triggered
- (void)activator:(LAActivator *)activator receiveEvent:(LAEvent *)event forListenerName:(NSString *)listenerName{

if ([listenerName isEqualToString:@"com.ezbatteries.show"]){

///show battery info (needs adding)
} else if ([listenerName isEqualToString:@"com.ezbatteries.hide"]){

///hide battery info (needs adding)
} else if ([listenerName isEqualToString:@"com.ezbatteries.toggle"]){
///toggle battery info (needs adding)
}
}
@end


%ctor
{
  if ([NSBundle.mainBundle.bundleIdentifier isEqual:@"com.apple.springboard"]) { //check if its springboard
    int regToken; // The registration token
    notify_register_dispatch("com.idevicehacked.ezbatteries", &regToken, dispatch_get_main_queue(), ^(int token) {  //Request notification delivery to a dispatch queue
    BCBatteryDeviceController *bcb = [%c(BCBatteryDeviceController) sharedInstance];
    NSArray *devices = MSHookIvar<NSArray *>(bcb, "_sortedDevices");

    UIAlertController *confirmationAlertController = [UIAlertController
                                    alertControllerWithTitle:@"ShowMe"
                                    message:@""
                                    preferredStyle:UIAlertControllerStyleAlert];

    for (BCBatteryDevice *device in devices) {
      deviceName = MSHookIvar<NSString *>(device, "_name");
      deviceCharge = MSHookIvar<long long>(device, "_percentCharge");

        confirmationAlertController.message =  [confirmationAlertController.message stringByAppendingString:[NSString stringWithFormat:@"%@ : %lld%%\n", deviceName, deviceCharge]];;
        }
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
  });
    }
  }
