#import <substrate.h>
#import <Foundation/Foundation.h>
#import "OCShowAlertView.h"
#import "OCLogWriteToFile.h"

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




