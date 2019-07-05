#import <substrate.h>
#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface WCMallControlData:NSObject
@end

@interface WCPayControlData:NSObject
@end

%hook WCPayControlData

- (NSString *)description{
	NSLog(@"WeChat WCMallControlData description");
    //声明一个字典
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    //得到当前class的所有属性
    uint count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    //循环并用KVC得到每个属性的值
    for(int i = 0; i<count; i++) {
        objc_property_t property = properties[i];
        NSString *name = @(property_getName(property));
        id value = [self valueForKey:name]?:@"nil";//默认值为nil字符串
        [dictionary setObject:value forKey:name];//装载到字典里
    }
    
    //释放
    free(properties);

    NSString * allClassMessage = [NSString stringWithFormat:@"%@",dictionary];
    
    [allClassMessage writeToFile:@"/var/mobile/allClassMessage2.txt" atomically:NO encoding:4 error:NULL];
    //return
    return %orig;
}

%end


@interface WCBizMainViewController:UIViewController

@end



%hook WCBizMainViewController

- (void)viewWillAppear:(BOOL)arg1{
    %orig;
    self.title = @"My Wallet";
}

- (void)refreshViewWithPayControlData:(WCPayControlData *)arg1
{
    // WCPayControlData
    // NSLog(@"WeChat:refreshViewWithPayControlData: %s,%@,",object_getClassName(arg1),[arg1 description]);
    %orig;
}

%end

//微信
%hook WCPayBalanceDetailViewController


- (void)viewDidLoad{
	NSLog(@"WCPayBalanceDetailViewController viewDidLoad");
	%orig;
}

- (void)refreshViewWithData:(WCPayControlData *)arg1{
	NSLog(@"WCPayBalanceDetailViewController refreshViewWithData");
	NSLog(@"WeChat:refreshViewWithData: %s,%@,",object_getClassName(arg1),[arg1 description]);
	%orig;
}

%end