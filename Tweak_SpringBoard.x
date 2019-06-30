#import <substrate.h>
#import <Foundation/Foundation.h>

@interface SBScreenshotManager:NSObject
- (void)saveScreenshots;
@end

@interface SpringBoard
- (void)hookMethod;
@property(readonly, nonatomic) SBScreenshotManager *screenshotManager;
@end

%hook SpringBoard

- (id)init
{
	NSLog(@"SpringBoard init");
    return %orig;
}

- (void)applicationDidFinishLaunching:(id)application{
	%orig;
}


%new
- (void)hookMethod{
	NSLog(@"sharedBoard");
}

- (void)_menuButtonDown:(id)down{
	NSLog(@"You've pressed home button.");
	%log((NSString *)@"iOSRE",(NSString *)@"Debug");
	[self hookMethod];

	SBScreenshotManager * screenshotManager = [self screenshotManager];
	[screenshotManager saveScreenshots];
	%orig;
}


%end


%hook SBScreenFlash

- (void)flashColor:(id)arg1 withCompletion:(id)arg2{
	NSLog(@"iOSRE:flashColor: %s,%@,",object_getClassName(arg1),arg1);
	CGFloat red = (arc4random() % 256) / 255.0;
    CGFloat green = (arc4random() % 256) / 255.0;
    CGFloat blue = (arc4random() % 256) / 255.0;

    UIColor *c = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    %orig(c, arg2);
	
}
 

%end

//SpringBoard
%hook SBScreenshotManager

- (void)saveScreenshots{
	NSLog(@":iOSRE:saveScreenshots:is called");
	%orig;
}

- (void)saveScreenshotsWithCompletion:(id)arg1{
	NSLog(@"iOSRE:saveScreenshotsWithCompletion:is called %@",arg1);
	%orig;
}

%end

%hook SBLockScreenDateViewController

- (void)setCustomSubtitleText:(id)arg1 withColor:(id)arg2
{
	%orig(@"wupeng iphone 5c",arg2);
}

%end

