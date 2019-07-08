#import <substrate.h>
#import <Foundation/Foundation.h>
#import "OCShowAlertView.h"
#import "NSObject+LogWriteToFile.h"

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

@interface OPPlayerAPI:NSObject
@end

%hook OPPlayerAPI
- (void)playWithVideo:(id)arg1{
    [arg1 writeToFileWithClass];
    %orig;
}

%end

@interface XAdEnginePreAdModule:UIView
@end

%hook XAdEnginePreAdModule

- (void)getADInfo:(id)arg1{
    @try {
        if(arg1){
            [arg1 writeToFileWithClass];
        }
    } @catch (NSException *exception) {
        [OCShowAlertView showAlertViewWithArg1:exception];
    } @finally {
        [OCShowAlertView showAlertViewWithArg1:self];
    }
    
    %orig;
}

%end





