#import <substrate.h>
#import <Foundation/Foundation.h>
#import "OCShowAlertView.h"
#import "OCLogWriteToFile.h"

@interface YTEngineController:NSObject
@end


%hook YTEngineController

- (void)skipAd:(int)arg1{
    %orig;
}

- (_Bool)skipCurrentAd:(id)arg1{
    return %orig;
}
%end


@interface XAdEnginePreAdModule:UIView
// - (void)writeToFile:(NSString *)fileName arr:(NSArray *)arr;
@end

%hook XAdEnginePreAdModule

- (void)getADInfo:(NSMutableArray *)arg1{
	[OCLogWriteToFile writeToFileWithFileName:@"XAdEnginePreAdModule" obj:arg1];
	[arg1 removeAllObjects];
    %orig;
}

%end




