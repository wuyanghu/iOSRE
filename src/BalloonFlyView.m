//
//  BalloonFlyView.m
//  HWTou
//
//  Created by Reyna on 2017/11/29.
//  Copyright © 2017年 LieMi. All rights reserved.
//
#import <substrate.h>
#import "BalloonFlyView.h"

@interface BalloonFlyView () <CAAnimationDelegate>

@end

@implementation BalloonFlyView

#define Balloon_W 27.5
#define Balloon_H 81.5

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:CGRectMake(0, 0, Balloon_W, Balloon_H)];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)showAnimationInView:(UIView *)view {
    
    CGFloat view_W = view.bounds.size.width;
    CGFloat view_H = view.bounds.size.height;
    
    CGFloat val = arc4random()%(int)(view_W/Balloon_W);
    
    self.frame = CGRectMake(view_W - Balloon_W * val - Balloon_W/2.0, view_H, Balloon_W, Balloon_H);
    [view addSubview:self];
    [view bringSubviewToFront:self];
    
    CABasicAnimation *anima1 = [CABasicAnimation animationWithKeyPath:@"position"];
    anima1.fromValue = [NSValue valueWithCGPoint:CGPointMake(view_W - Balloon_W * val - Balloon_W/2.0, view_H + Balloon_H/2.0)];
    anima1.toValue = [NSValue valueWithCGPoint:CGPointMake(view_W - Balloon_W * val - Balloon_W/2.0, - Balloon_H/2.0)];

    CABasicAnimation *anima2 =
    [CABasicAnimation animationWithKeyPath:@"opacity"];
    anima2.fromValue = [NSNumber numberWithFloat:1];
    anima2.toValue = [NSNumber numberWithFloat:0];

    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.animations = [NSArray arrayWithObjects:anima1,anima2, nil];
    groupAnimation.duration = 3.0f;
    groupAnimation.removedOnCompletion = YES;
    groupAnimation.fillMode = kCAFillModeRemoved;
    groupAnimation.delegate = self;
    [self.layer addAnimation:groupAnimation forKey:@"groupAnimation"];
}

- (void)createUI {
    
    int x = arc4random()%4;
    NSArray * imgArr = @[@"img_qqb.png",@"img_qqg.png",@"img_qqr.png",@"img_qqy.png"];
    NSString * imageNamed = imgArr[x];

    UIImageView * iv = [[UIImageView alloc] initWithFrame:self.bounds];
    UIImage * image = [UIImage imageWithContentsOfFile:CHFile(imageNamed)];
    iv.image = image;
    [self addSubview:iv];
}

#pragma mark - CAAnimationDelegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
    [self removeFromSuperview];
}

@end
