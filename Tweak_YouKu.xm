#import <substrate.h>
#import <Foundation/Foundation.h>
#import "OCShowAlertView.h"

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
@end

%hook XAdEnginePreAdModule

- (void)getADInfo:(NSMutableArray *)arg1{
	[arg1 removeAllObjects];
    %orig;
}

%end




