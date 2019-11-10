#import <substrate.h>
#import <Foundation/Foundation.h>
#import "OCShowAlertView.h"
#import "OCLogWriteToFile.h"
#import <WebKit/WebKit.h>

%hook AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
	
	 NSString *customUserAgent = @"Mozilla/5.0 (iPhone; CPU OS 12_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 wxwork/2.8.12 MicroMessenger/7.0.1 Language/zh";
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"UserAgent": customUserAgent}];

	return %orig;
}

%end


%hook WKWebView

// - (void)setCustomUserAgent{
// 	 NSString *customUserAgent = @"Mozilla/5.0 (iPhone; CPU OS 12_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 wxwork/2.8.12 MicroMessenger/7.0.1 Language/zh";
// 	 self.customUserAgent = customUserAgent;
// 	 %orig;
// }

- (NSString *)customUserAgent{
	 NSString *customUserAgent = @"Mozilla/5.0 (iPhone; CPU OS 12_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 wxwork/2.8.12 MicroMessenger/7.0.1 Language/zh";
	 %orig;
	return customUserAgent;
}

%end