#import <substrate.h>
#import <Foundation/Foundation.h>

//note

@interface ICNote:NSObject
@property (readonly,nonatomic) NSString * title;
@end

@interface ICNoteEditorViewController:UIViewController
@property (strong,nonatomic) ICNote * note;
@end



%hook ICNotesListViewController

- (void)showNote:(id)arg1{
	NSLog(@"note showNote %@",arg1);
	%orig;
}

%end

%hook ICNoteEditorViewController

- (void)viewWillAppear:(BOOL)arg1{
	%orig;
	NSString * content = self.note.title;
	NSString * contentLength = [NSString stringWithFormat:@"%lu",(unsigned long)[content length]];
	self.title = contentLength;
}

- (void)textViewDidChange:(UITextView *)arg1{
	NSLog(@"note textViewDidChange %@",arg1);
	self.title = [NSString stringWithFormat:@"%lu",(unsigned long)[arg1.text length]];
	%orig;
}

%end

//咪咕阅读
%hook CMBookShelfHeaderView

- (void)setUp{
	NSLog(@"CMBookShelfHeaderView setUp");

	UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"微信点击事件" message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
    %orig;
}

- (void)reloadOperationUI:(id)arg1{
	NSLog(@"CMBookShelfHeaderView reloadOperationUI");
	%orig;
}

%end

//微信
%hook WCPayBalanceDetailViewController


- (void)viewDidLoad{
	NSLog(@"WCPayBalanceDetailViewController viewDidLoad");
	%orig;
}

- (void)refreshViewWithData:(id)arg1{
	NSLog(@"WCPayBalanceDetailViewController refreshViewWithData");
	NSLog(@"%@",arg1);
	%orig;
}

%end

//SpringBoard
%hook SBScreenshotManager

- (void)saveScreenshots{
	NSLog(@":iOSRE:saveScreenshots:is called");
	%orig;
}

- (void)saveScreenshotsWithCompletion:(id)arg1{
	NSLog(@"iOSRE:saveScreenshotsWithCompletion:is called %@",arg1);
	%orig;
}

%end

@interface SBScreenshotManager:NSObject
- (void)saveScreenshots;
@end

@interface SpringBoard
- (void)hookMethod;
@property(readonly, nonatomic) SBScreenshotManager *screenshotManager;
@end

%hook SpringBoard

- (id)init
{
	NSLog(@"SpringBoard init");
    return %orig;
}

- (void)applicationDidFinishLaunching:(id)application{
	%orig;
}


%new
- (void)hookMethod{
	NSLog(@"sharedBoard");
}

- (void)_menuButtonDown:(id)down{
	NSLog(@"You've pressed home button.");
	%log((NSString *)@"iOSRE",(NSString *)@"Debug");
	[self hookMethod];

	SBScreenshotManager * screenshotManager = [self screenshotManager];
	[screenshotManager saveScreenshots];
	%orig;
}


%end


%hook SBScreenFlash

- (void)flashColor:(id)arg1 withCompletion:(id)arg2{
	NSLog(@"iOSRE:flashColor: %s,%@,",object_getClassName(arg1),arg1);
	CGFloat red = (arc4random() % 256) / 255.0;
    CGFloat green = (arc4random() % 256) / 255.0;
    CGFloat blue = (arc4random() % 256) / 255.0;

    UIColor *c = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    %orig(c, arg2);
	
}
 

%end

%hook SBLockScreenDateViewController

- (void)setCustomSubtitleText:(id)arg1 withColor:(id)arg2
{
	%orig(@"wupeng iphone 5c",arg2);
}

%end

