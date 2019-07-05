#import <substrate.h>
#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface NSObject(LogWriteToFile)
- (void)writeToFileWithClass;
@end
 
@implementation NSObject(LogWriteToFile)

- (void)writeToFileWithClass{
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
    NSString * writePath = [NSString stringWithFormat:@"/var/mobile/%@.txt",NSStringFromClass([self class])];
    [allClassMessage writeToFile:writePath atomically:NO encoding:4 error:NULL];
}

@end


@interface WCPayLqtCellInfo:NSObject
@property(retain, nonatomic) NSString *lqt_wording;
@end


@interface WCPayTransferMoneyData:NSObject
@end

@interface WCPayUserInfo:NSObject
@property(retain, nonatomic) WCPayLqtCellInfo *lqtCellInfo;
@end

@interface WCPaySwitchInfo:NSObject
@end
//零钱通
@interface WCPayLQTInfo:NSObject
@end
//余额支付
@interface WCPayBalanceInfo:NSObject
@property(nonatomic) unsigned long long m_uiAvailableBalance;
@property(nonatomic) unsigned long long m_uiFetchBalance; // @synthesize m_uiFetchBalance;
@property(nonatomic) unsigned long long m_uiTotalBalance;
@end

@interface WCPayBindCardListApplyNewCardInfo:NSObject
@end

@interface WCPayPayMenuArrayInfo:NSObject
@end

@interface WCPayLoanEntryInfo:NSObject
@end

@interface WCPayF2FControlData:NSObject
@end

@interface WCPayHoneyPayControlData:NSObject
@end

@interface WCPayControlData:NSObject
@property(retain, nonatomic) WCPayTransferMoneyData *transferMoneyData; 
@property(retain, nonatomic) WCPayUserInfo *m_structUserInfo;
@property(retain, nonatomic) WCPaySwitchInfo *m_structSwitchInfo;
@property(retain, nonatomic) WCPayLQTInfo *m_structLqtInfo;
@property(retain, nonatomic) WCPayBalanceInfo *m_structBalanceInfo;
@property(retain, nonatomic) WCPayBindCardListApplyNewCardInfo *m_payApplyNewCardInfo;
@property(retain, nonatomic) WCPayPayMenuArrayInfo *m_payMenuArrayInfo;
@property(retain, nonatomic) WCPayLoanEntryInfo *m_loanEntryInfo;
@property(retain, nonatomic) WCPayF2FControlData *m_f2fControlData;
@property(retain, nonatomic) WCPayHoneyPayControlData *honeyPayData;
@end


@interface WCBizMainViewController:UIViewController

@end



%hook WCBizMainViewController

- (void)viewWillAppear:(BOOL)arg1{
    %orig;
    self.title = @"My Wallet";
}

- (void)refreshViewWithPayControlData:(WCPayControlData *)arg1
{
    arg1.m_structUserInfo.lqtCellInfo.lqt_wording = @"￥100";

    arg1.m_structBalanceInfo.m_uiAvailableBalance = 2000000;
    arg1.m_structBalanceInfo.m_uiTotalBalance = 2000000;
    arg1.m_structBalanceInfo.m_uiFetchBalance = 2000000;
    %orig;
}

%end

//微信
%hook WCPayBalanceDetailViewController

- (void)refreshViewWithData:(WCPayControlData *)arg1{
	NSLog(@"WCPayBalanceDetailViewController refreshViewWithData");
    arg1.m_structBalanceInfo.m_uiAvailableBalance = 2000000;
    arg1.m_structBalanceInfo.m_uiTotalBalance = 2000000;
    arg1.m_structBalanceInfo.m_uiFetchBalance = 2000000;
    
    // [arg1.transferMoneyData writeToFileWithClass];
    // [arg1.m_structUserInfo writeToFileWithClass];
    // [arg1.m_structSwitchInfo writeToFileWithClass];
    // [arg1.m_structLqtInfo writeToFileWithClass];
    // [arg1.m_structBalanceInfo writeToFileWithClass];
    // [arg1.m_payApplyNewCardInfo writeToFileWithClass];
    // [arg1.m_payMenuArrayInfo writeToFileWithClass];
    // [arg1.m_loanEntryInfo writeToFileWithClass];
    // [arg1.m_f2fControlData writeToFileWithClass];
    // [arg1.honeyPayData writeToFileWithClass];
	NSLog(@"WeChat:refreshViewWithData: %s,%@,",object_getClassName(arg1),arg1);
	%orig;
}

%end