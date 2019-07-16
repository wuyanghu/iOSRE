#import <substrate.h>
#import <Foundation/Foundation.h>
#import "OCShowAlertView.h"
#import "OCLogWriteToFile.h"

@interface XAdEnginePreAdModule:UIView
@end

%hook XAdEnginePreAdModule

- (void)getADInfo:(NSMutableArray *)arg1{
	[arg1 removeAllObjects];
    %orig;
}

%end

%hook YTEngineController

- (_Bool)isVipUser{
	%orig;
	return YES;
}

- (_Bool)addPreAdURLItems:(id)arg1 fromObject:(id)arg2{
	return %orig;
}

- (_Bool)seekToTime:(double)arg1 fromObject:(id)arg2{
	[OCShowAlertView tryCatchShowAlert:@"seekToTime" arg1:arg2];
	return %orig;
}

- (void)setAdInfoForPlayer:(id)arg1{
	[OCShowAlertView tryCatchShowAlert:@"setAdInfoForPlayer" arg1:arg1];
	%orig;
}

- (void)watchAdWithVid:(id)arg1 cu:(id)arg2 userInfo:(id)arg3{
	[OCShowAlertView tryCatchShowAlert:@"watchAdWithVid" arg1:arg2];
	%orig;
}

%end

%hook OPPaymentVideoPlayerEndContainerView

- (void)updateWeexViewData:(id)arg1{
	// [OCLogWriteToFile writeToFileWithFileName:@"op_updateWeexViewData" obj:arg1];
	%orig;
}

- (void)refreshWithModel:(id)arg1 screenModel:(long long)arg2{
	%orig;
}

- (id)initWithFrame:(struct CGRect)arg1 videoModel:(id)arg2 screenModel:(long long)arg3{
	return %orig;
}

%end

@interface OPPaymentVideoModel:NSObject
@property(retain, nonatomic) NSDictionary *playEndInfo; // @synthesize playEndInfo=_playEndInfo;
// @property(retain, nonatomic) NSDictionary *sourceData;
@end

%hook OPProgressView
- (void)progressView:(OPProgressView *)arg1 seekDidEnd:(long long)arg2{
	%orig;
	[OCShowAlertView showAlertViewWithArg1:arg1];
}
%end

%hook OPPaymentVideoModel

+ (id)createFromDictionary:(NSDictionary *)arg1{
	NSLog(@"createFromDictionary");
	NSMutableDictionary * newDict = [NSMutableDictionary dictionaryWithDictionary:arg1];
    [newDict setObject:@"10" forKey:@"try_time"];
    arg1 = newDict;

	id reuslt = %orig;

	return reuslt;
}

%end


%hook OPProgressPlugin
- (void)progressView:(OPProgressView *)arg1 seekDidEnd:(long long)arg2{
	// NSString * timestr = [self formattingTime:arg2];
	// NSString * msg = [NSString stringWithFormat:@"OPProgressPlugin"];
	// [OCShowAlertView showAlertViewWithMessage:msg];
	%orig;
}

%end

