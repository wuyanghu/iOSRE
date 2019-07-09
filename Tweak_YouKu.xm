#import <substrate.h>
#import <Foundation/Foundation.h>
#import "OCShowAlertView.h"
#import "NSObject+AllIvarLog.h"

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

@interface XAdEnginePlayerAdItem:NSObject
@property(copy, nonatomic) NSString *adUrl;
@property(nonatomic) double adCountdown;
@property(nonatomic) long long adDuration;
@property(nonatomic) long long duration;
@end


@interface XAdEnginePreAdModule:UIView
@end

%hook XAdEnginePreAdModule

- (void)getADInfo:(NSArray *)arg1{
	for (int i = 0; i < arg1.count; ++i)
	{
		XAdEnginePlayerAdItem * adItem = arg1[i];
		adItem.adCountdown = 0;
		adItem.adCountdown = 0;
		adItem.duration = 0;
		adItem.adUrl = @"http://vali.cp31.ott.cibntv.net/youku/6572e41874d4171a7e7764268/03000801005CEE263B7456A003E880835B7D49-1110-4DF5-B527-4631DD228FEF.mp4?sid=056268027000010007252_00_A2c517ada725fca0cf45f9d1ca7dabbca&sign=c297d3b9b8dabead471d24b9da83d77d&ctype=20";
	}
	    [arg1[0] writeToFileWithClass];
    %orig;
}

%end




