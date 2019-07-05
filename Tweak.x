#import <substrate.h>
#import <Foundation/Foundation.h>

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


