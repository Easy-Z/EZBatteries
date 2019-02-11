#include "EZBRootListController.h"
#import <CepheiPrefs/HBRootListController.h>
#import <CepheiPrefs/HBAppearanceSettings.h>
#import <Cephei/HBPreferences.h>
#include <spawn.h>
#include <signal.h>


@implementation EZBRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"Root" target:self] retain];
	}

	return _specifiers;
}

- (IBAction)respring {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Respring"
                                                    message:@"Are You Sure You Want To Respring?"
                                                    delegate:self
                                                    cancelButtonTitle:@"Yes"
                                                    otherButtonTitles:@"No", nil];
	[alert show];
}

- (void)alertView:(UIAlertView *)alert clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0)
	{
		pid_t pid;
		int status;
		const char* args[] = {"killall", "SpringBoard", NULL};
		posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char*
		const*)args, NULL);
		waitpid(pid, &status, WEXITED);
	}
}


@end
