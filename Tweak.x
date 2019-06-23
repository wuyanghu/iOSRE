
#import <substrate.h>

returnType (*old_symbol)(args);
returnType new_symbol(args){

}

void InitializeMSHookFunction(void){
	MSImageRef image = MSGetImageByName("/Applications/iOSRETargetApp.app/iOSRETargetApp");
	void * symbol = MSFindSymbol(image,"symbol");
	if (symbol){
		MSHookFunction((void *)symbol,(void *)&new_symbol,(void**)&old_symbol);
	}else{
		NSLog(@"Symbol not found!");
	}
}

void (*old_ZN8CPPClass11CPPFunctionEPKc)(void *,const char *);

void new_ZN8CPPClass11CPPFunctionEPKc(void * hiddenThis,const char * arg0)
{
	if (strcmp(arg0,"This is a short C function") == 0)
	{
		old_ZN8CPPClass11CPPFunctionEPKc(hiddenThis,"This is a hijacked2 short C function from new_ZN8CPPClass11CPPFunctionEPKc!");
	}else{
		old_ZN8CPPClass11CPPFunctionEPKc(hiddenThis,"This is a hijacked2 C++ function");
	}
}

void (*old_CFunction)(const char *);

void new_CFunction(const char * arg0){
	old_CFunction("This is a hijacked2 C function");
}

void (*old_shortCFunction)(const char *);

void new_shortCFunction(const char * arg0){
	old_CFunction("This is a hijacked2 short C function from new_shortCFunction");
}

%ctor
{
	@autoreleasepool
	{
		MSImageRef image = MSGetImageByName("/Applications/iOSRETargetApp.app/iOSRETargetApp");
		void * __ZN8CPPClass11CPPFunctionEPKc = MSFindSymbol(image,"__ZN8CPPClass11CPPFunctionEPKc");
		if (__ZN8CPPClass11CPPFunctionEPKc)
		{
			NSLog(@"iOSRE:Found CPPFunction!");
		}
		MSHookFunction((void *)__ZN8CPPClass11CPPFunctionEPKc,(void *)&new_ZN8CPPClass11CPPFunctionEPKc,(void **)&old_ZN8CPPClass11CPPFunctionEPKc);

		void * _CFunction = MSFindSymbol(image,"_CFunction");
		if (_CFunction)
		{
			NSLog(@"iOSRE: Found CFunction!");
			/* code */
		}
		MSHookFunction((void*)_CFunction,(void *)&new_CFunction,(void**)&old_CFunction);

		void * _ShortCFunction = MSFindSymbol(image,"_ShortCFunction");
		if (_ShortCFunction)
		{
			NSLog(@"iOSRE:Found ShortCFunction");
		}

		MSHookFunction((void *)_ShortCFunction,(void *)&new_shortCFunction,(void **)&old_shortCFunction);
	}
}

%hook SpringBoard

- (void)_menuButtonDown:(id)down
{
	NSLog(@"You've pressed home button.");
	%log((NSString *)@"iOSRE",(NSString *)@"Debug");
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
