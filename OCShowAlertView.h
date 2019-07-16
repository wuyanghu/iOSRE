//
//  CustomTestView.h
//  iOSREHeaders
//
//  Created by ruantong on 2019/7/7.
//  Copyright © 2019 wupeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OCShowAlertView : UIView
+ (void)showAlertViewWithMessage:(NSString *)message;
+ (void)showAlertViewWithArg1:(id)arg1;
+ (NSString *)arg1ToString:(id)arg1;
+ (void)printArg1WithPrefix:(NSString *)prefix arg1:(id)arg1;
+ (void)tryCatchShowAlert:(NSString *)fileName arg1:(id)arg1;
@end
