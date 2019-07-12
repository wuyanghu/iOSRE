#import <substrate.h>
#import <Foundation/Foundation.h>
#import "src/BalloonFlyView.h"
#import "OCShowAlertView.h"

static NSTimer * flyTimer;
static CGFloat animatedTime = 2.0;

@interface YYTableView:UITableView
@end

@interface BaseMsgContentViewController:UIViewController
- (id)getTableView;
- (void)showBallonFly;
- (void)tryCatchShowBallonFly;
@end

%hook BaseMsgContentViewController

- (void)viewWillAppear:(BOOL)animated{
    
    YYTableView * tableView = (YYTableView *)[self getTableView];
    UIImage * image = [UIImage imageWithContentsOfFile:CHFile(@"IMG_0263.JPG")];
    tableView.layer.contents = (__bridge id)image.CGImage;

    [self tryCatchShowBallonFly];
    flyTimer = [NSTimer scheduledTimerWithTimeInterval:animatedTime target:self selector:@selector(tryCatchShowBallonFly) userInfo:nil repeats:YES];

    %orig;
    
}

- (void)viewWillDisappear:(BOOL)animated{
    %orig;
    [flyTimer invalidate];
    flyTimer = nil;

}

%new 
- (void)tryCatchShowBallonFly{
    @try {
        [self showBallonFly];
    } @catch (NSException *exception) {

    } @finally {

    }
}

%new
- (void)showBallonFly{
    BalloonFlyView *vi = [[BalloonFlyView alloc] initWithFrame:CGRectZero];
    [vi showAnimationInView:self.view];


    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(animatedTime/4*1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        BalloonFlyView *vi = [[BalloonFlyView alloc] initWithFrame:CGRectZero];
        [vi showAnimationInView:self.view];

    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(animatedTime/4*2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        BalloonFlyView *vi = [[BalloonFlyView alloc] initWithFrame:CGRectZero];
        [vi showAnimationInView:self.view];

    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(animatedTime/4*3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        BalloonFlyView *vi = [[BalloonFlyView alloc] initWithFrame:CGRectZero];
        [vi showAnimationInView:self.view];

    });
    
}


%end
