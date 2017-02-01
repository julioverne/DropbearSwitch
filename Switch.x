#import "FSSwitchDataSource.h"
#import "FSSwitchPanel.h"
#import <notify.h>

#define DropBearDaemomPath "/Library/LaunchDaemons/dropbear.plist"

@interface dropbearSwitch : NSObject <FSSwitchDataSource>
@property(nonatomic,assign) BOOL enabled;
@end

dropbearSwitch *dropbearSwitchShared = nil;
static BOOL isDropBearEnabled()
{
	@autoreleasepool {
		NSDictionary *PrefsCheck = [[NSDictionary alloc] initWithContentsOfFile:@DropBearDaemomPath]?:@{};
		NSString* port = [PrefsCheck[@"ProgramArguments"]?:@[] lastObject];
		if(port && [port length]<=4) {
			return YES;
		}
		return NO;
	}
}
static void changedDropbearSwitch(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
	@autoreleasepool {
		if (dropbearSwitchShared != nil) {
			dropbearSwitchShared.enabled = isDropBearEnabled();
			[[FSSwitchPanel sharedPanel] stateDidChangeForSwitchIdentifier:@"com.julioverne.dropbearswitch"];
		}
	}
}

@implementation dropbearSwitch
@synthesize enabled;
-(id)init
{
	self = [super init];
	dropbearSwitchShared = self;
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, changedDropbearSwitch, CFSTR("com.julioverne.dropbearswitch"), NULL, CFNotificationSuspensionBehaviorCoalesce);
	self.enabled = isDropBearEnabled();
	return self;
}
- (FSSwitchState)stateForSwitchIdentifier:(NSString *)switchIdentifier
{
	return enabled?FSSwitchStateOn:FSSwitchStateOff;
}
- (void)applyState:(FSSwitchState)newState forSwitchIdentifier:(NSString *)switchIdentifier
{
	system("exec /usr/bin/toggleDropBearSwitch");
}
@end