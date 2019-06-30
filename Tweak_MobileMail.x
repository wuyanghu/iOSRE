#import <substrate.h>
#import <Foundation/Foundation.h>

@interface MailboxPickerController : UITableViewController
@end

@interface NSConcreteNotification : NSNotification
@end

@interface MessageMiniMall:NSObject
- (id)copyAllMessages;
- (void)markMessagesAsViewed:(id)arg1;
@end

@interface MFMessageInfo:NSObject
@property (nonatomic) BOOL read;
@end

@interface MFLibraryMessage:NSObject
- (NSArray *)senders;
- (MFMessageInfo *)copyMessageInfo;
@end

%hook MailboxPickerController

%new
- (void)iOSREShowWhitelist{
	UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"Whitelist" message:@"Please input an email address" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField * whitelistField = alertController.textFields.firstObject;
        if ([whitelistField.text length]!=0) {
            [[NSUserDefaults standardUserDefaults] setObject:whitelistField.text forKey:@"whitelist"];
        }
    }];
    
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"823105162@qq.com";
        textField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"whitelist"];
    }];
    [self presentViewController:alertController animated:YES completion:nil];

}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Whitelist" style:UIBarButtonItemStylePlain target:self action:@selector(iOSREShowWhitelist)];
    %orig;
}

%end

%hook MailboxContentViewController

- (void)viewWillAppear:(BOOL)arg1{
    NSString * whitelist = [[NSUserDefaults standardUserDefaults] objectForKey:@"whitelist"];
	NSLog(@"MobileMail:viewWillAppear %@",whitelist);
	%orig;
}

- (void)miniMallDidLoadMessages:(id)arg1{
	NSLog(@"MobileMail:miniMallDidLoadMessages");
	%orig;
}

- (void)miniMallFinishedFetch:(id)arg1{
	NSLog(@"MobileMail:miniMallFinishedFetch");
	%orig;
}

- (void)miniMallMessageCountDidChange:(id)arg1{
	%orig;
	NSLog(@"MobileMail:miniMallMessageCountDidChange");
	NSMutableSet * targetMessages = [NSMutableSet new];
    NSString * whitelist = [[NSUserDefaults standardUserDefaults] objectForKey:@"whitelist"];
    MessageMiniMall * mall = [arg1 object];
    NSSet * messages = [mall copyAllMessages];
    for (MFLibraryMessage * message in messages) {
        MFMessageInfo * messageInfo = [message copyMessageInfo];
        for (NSString * sender in [message senders]) {
            if (!messageInfo.read && [sender rangeOfString:[NSString stringWithFormat:@"<%@>",whitelist]].location == NSNotFound) {
                [targetMessages addObject:message];
            }
        }
    }
    [mall markMessagesAsViewed:targetMessages];
}

%end

%hook MessageMiniMall

- (id)copyAllMessages{
	id allMessages = %orig;
	NSLog(@"MobileMail:copyAllMessages %s,%@,",object_getClassName(allMessages),allMessages);
	return %orig;
}

- (void)markMessagesAsViewed:(id)arg1{
	NSLog(@"MobileMail:markMessagesAsViewed: %s,%@,",object_getClassName(arg1),arg1);
	%orig;
}

%end