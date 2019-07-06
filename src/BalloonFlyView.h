//
//  BalloonFlyView.h
//  HWTou
//
//  Created by Reyna on 2017/11/29.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#define CHFile(path) [NSString stringWithFormat:@"/Library/PreferenceLoader/Preferences/%@",path]
@interface BalloonFlyView : UIView

- (void)showAnimationInView:(UIView *)view;

@end
