#import <Flipswitch/Flipswitch.h>
#import <notify.h>

#define DropBearDaemomPath "/Library/LaunchDaemons/dropbear.plist"

@interface NSUserDefaults ()
- (id)objectForKey:(NSString *)key inDomain:(NSString *)domain;
- (void)setObject:(id)value forKey:(NSString *)key inDomain:(NSString *)domain;
@end
@interface dropbearSwitch : NSObject <FSSwitchDataSource>
@property(nonatomic,assign) BOOL enabled;
@end

static __strong dropbearSwitch *dropbearSwitchShared = nil;
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
			[[NSUserDefaults standardUserDefaults] setObject:@(dropbearSwitchShared.enabled) forKey:@"enabled" inDomain:@"com.julioverne.dropbearswitch"];
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
	enabled = isDropBearEnabled();
	@autoreleasepool {
		if(enabled != [[[NSUserDefaults standardUserDefaults] objectForKey:@"enabled" inDomain:@"com.julioverne.dropbearswitch"]?:@NO boolValue]) {
			[self applyState:enabled forSwitchIdentifier:nil];
		}
	}
	return self;
}
- (FSSwitchState)stateForSwitchIdentifier:(NSString *)switchIdentifier
{
	return enabled?FSSwitchStateOn:FSSwitchStateOff;
}
- (void)applyState:(FSSwitchState)newState forSwitchIdentifier:(NSString *)switchIdentifier
{
	system("exec /usr/bin/toogleDropBearSwitch");
}
@end