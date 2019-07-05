#import <substrate.h>
#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface LogWriteToFile : NSObject
+ (void)writeToFileWithClass:(id)class;
@end

@implementation LogWriteToFile

+ (void)writeToFileWithClass:(id)selfclass{
    //声明一个字典
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    //得到当前class的所有属性
    uint count;
    objc_property_t *properties = class_copyPropertyList([selfclass class], &count);
    
    //循环并用KVC得到每个属性的值
    for(int i = 0; i<count; i++) {
        objc_property_t property = properties[i];
        NSString *name = @(property_getName(property));
        id value = [selfclass valueForKey:name]?:@"nil";//默认值为nil字符串
        [dictionary setObject:value forKey:name];//装载到字典里
    }
    
    //释放
    free(properties);

    NSString * allClassMessage = [NSString stringWithFormat:@"%@",dictionary];
    NSString * writePath = [NSString stringWithFormat:@"/var/mobile/%@.txt",NSStringFromClass([selfclass class])];
    [allClassMessage writeToFile:writePath atomically:NO encoding:4 error:NULL];
}

@end

@interface WCPaySecurityControlData:NSObject
@end

@interface WCPayControlData:NSObject
@property(retain, nonatomic) WCPaySecurityControlData *securityData;
@end

%hook WCPaySecurityControlData
- (NSString *)description{
    [LogWriteToFile writeToFileWithClass:self];
    return %orig;
}
%end


%hook WCPayControlData
- (NSString *)description{
    [LogWriteToFile writeToFileWithClass:self];
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
    [LogWriteToFile writeToFileWithClass:self];
    %orig;
}

%end

//微信
%hook WCPayBalanceDetailViewController

- (void)refreshViewWithData:(WCPayControlData *)arg1{
	NSLog(@"WCPayBalanceDetailViewController refreshViewWithData");
	NSLog(@"WeChat:refreshViewWithData: %s,%@,",object_getClassName(arg1),[arg1 description]);
    [arg1.securityData description];
	%orig;
}

%end