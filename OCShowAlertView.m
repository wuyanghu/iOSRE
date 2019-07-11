//
//  CustomTestView.m
//  iOSREHeaders
//
//  Created by ruantong on 2019/7/7.
//  Copyright © 2019 wupeng. All rights reserved.
//

#import "OCShowAlertView.h"

@implementation OCShowAlertView

+ (void)showAlertViewWithMessage:(NSString *)message{
    dispatch_async(dispatch_get_main_queue(), ^{
		UIAlertView * alert = [[UIAlertView alloc] initWithTitle:message message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
	    [alert show];
	});
}

+ (void)showAlertViewWithArg1:(id)arg1{
	NSString * message = [NSString stringWithFormat:@"%s,%@,",object_getClassName(arg1),arg1];
    [self showAlertViewWithMessage:message];
}

@end
