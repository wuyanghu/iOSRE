%hook SpringBoard

- (void)applicationDidFinishLaunching:(id)application{
	%orig;
	UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"可以修改系统、软件启动项，这是一个恐怖的事情。" message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)_menuButtonDown:(id)down{
	NSLog(@"You've pressed home button.");
	%log((NSString *)@"iOSRE",(NSString *)@"Debug");
	// UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"听说你按下了home键？" message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
 //    [alert show];
	%orig;
}

%end


%hook SBLockScreenDateViewController

- (void)setCustomSubtitleText:(id)arg1 withColor:(id)arg2
{
	%orig(@"iOS 9.3.2 App Reverse Engineering",arg2);
}

%end
/* How to Hook with Logos
Hooks are written with syntax similar to that of an Objective-C @implementation.
You don't need to #include <substrate.h>, it will be done automatically, as will
the generation of a class list and an automatic constructor.

%hook ClassName

// Hooking a class method
+ (id)sharedInstance {
	return %orig;
}

// Hooking an instance method with an argument.
- (void)messageName:(int)argument {
	%log; // Write a message about this call, including its class, name and arguments, to the system log.

	%orig; // Call through to the original function with its original arguments.
	%orig(nil); // Call through to the original function with a custom argument.

	// If you use %orig(), you MUST supply all arguments (except for self and _cmd, the automatically generated ones.)
}

// Hooking an instance method with no arguments.
- (id)noArguments {
	%log;
	id awesome = %orig;
	[awesome doSomethingElse];

	return awesome;
}

// Always make sure you clean up after yourself; Not doing so could have grave consequences!
%end
*/
