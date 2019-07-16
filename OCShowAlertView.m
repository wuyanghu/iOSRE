//
//  CustomTestView.m
//  iOSREHeaders
//
//  Created by ruantong on 2019/7/7.
//  Copyright © 2019 wupeng. All rights reserved.
//

#import "OCShowAlertView.h"
#import "OCLogWriteToFile.h"

@implementation OCShowAlertView

+ (void)showAlertViewWithMessage:(NSString *)message{
    dispatch_async(dispatch_get_main_queue(), ^{
		UIAlertView * alert = [[UIAlertView alloc] initWithTitle:message message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
	    [alert show];
	});
}

+ (void)showAlertViewWithArg1:(id)arg1{
	NSString * message = [self arg1ToString:arg1];
    [self showAlertViewWithMessage:message];
}

+ (NSString *)arg1ToString:(id)arg1{
	NSString * message = [NSString stringWithFormat:@"%s,%@,",object_getClassName(arg1),arg1];
	return message;
}

+ (void)printCurrentThread:(NSString *)name{
	NSLog(@"name %@",[NSThread currentThread]);
}

+ (void)printArg1WithPrefix:(NSString *)prefix arg1:(id)arg1{
	NSString * message = [self arg1ToString:arg1];
	NSLog(@"%@_%@",prefix,message);
}

+ (void)tryCatchShowAlert:(NSString *)fileName arg1:(id)arg1{
	@try {
		[OCLogWriteToFile writeToFileWithFileName:fileName obj:arg1];
    } @catch (NSException *exception) {
    	[OCShowAlertView showAlertViewWithArg1:exception];
    } @finally {
    	[OCShowAlertView showAlertViewWithArg1:arg1];
    }
}

@end
