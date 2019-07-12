#import <substrate.h>
#import <Foundation/Foundation.h>
#import "OCShowAlertView.h"
#import "OCLogWriteToFile.h"

@interface XAdEnginePreAdModule:UIView
// - (void)writeToFile:(NSString *)fileName arr:(NSArray *)arr;
@end

%hook XAdEnginePreAdModule

- (void)getADInfo:(NSMutableArray *)arg1{
	// [OCLogWriteToFile writeToFileWithFileName:@"XAdEnginePreAdModule" obj:arg1];
	[arg1 removeAllObjects];
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

- (NSDictionary *)playEndInfo{
	id playEndInfo = %orig;
	[OCLogWriteToFile writeToFileWithFileName:@"playEndInfo" obj:playEndInfo];
	return %orig;
}

- (NSDictionary *)sourceData{
	id sourceData = %orig;
	[OCLogWriteToFile writeToFileWithFileName:@"sourceData" obj:sourceData];
	return %orig;
}

+ (id)createFromDictionary:(NSDictionary *)arg1{
	NSLog(@"createFromDictionary");
	NSMutableDictionary * newDict = [NSMutableDictionary dictionaryWithDictionary:arg1];
    [newDict setObject:@"10" forKey:@"try_time"];
    arg1 = newDict;

	id reuslt = %orig;

	return reuslt;
}


%end