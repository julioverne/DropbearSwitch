#include <objc/runtime.h>
#include <dlfcn.h>
#include <sys/stat.h>
#import <notify.h>

#define DropBearDaemomPath "/Library/LaunchDaemons/dropbear.plist"

__attribute__((constructor)) int main(int argc, char **argv, char **envp)
{
	setuid(0);
    if ((chdir("/")) < 0) {
		exit(EXIT_FAILURE);
	}
	@autoreleasepool {
		NSMutableDictionary *PrefsCheck = [[NSMutableDictionary alloc] initWithContentsOfFile:@DropBearDaemomPath];
		if(!PrefsCheck) {
			exit(EXIT_FAILURE);
		}
		NSString* port = [PrefsCheck[@"ProgramArguments"]?:@[] lastObject];
		PrefsCheck[@"ProgramArguments"] = @[@"/usr/local/bin/dropbear",@"-F",@"-R",@"-p",(port&&[port length]<=4)?@"127.0.0.1:22":@"22"];
		[PrefsCheck writeToFile:@DropBearDaemomPath atomically:YES];
		chown(@DropBearDaemomPath.UTF8String, 0, 0);
		chmod(@DropBearDaemomPath.UTF8String, 0755);
		system("launchctl unload "DropBearDaemomPath);
		system("launchctl load "DropBearDaemomPath);
		notify_post("com.julioverne.dropbearswitch");
	}
	exit(0);
}