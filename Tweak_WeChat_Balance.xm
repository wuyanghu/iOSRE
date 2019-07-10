#import <substrate.h>
#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "OCLogWriteToFile.h"

@interface WCPayTransferMoneyData:NSObject
@end

@interface WCPaySwitchInfo:NSObject
@end
//零钱通
@interface WCPayLQTInfo:NSObject
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

@interface WCPayLqtCellInfo:NSObject
@property(retain, nonatomic) NSString *lqt_wording;
@end

@interface WCPayUserInfo:NSObject
@property(retain, nonatomic) WCPayLqtCellInfo *lqtCellInfo;
@end

//余额支付
@interface WCPayBalanceInfo:NSObject
@property(nonatomic) unsigned long long m_uiAvailableBalance;
@property(nonatomic) unsigned long long m_uiFetchBalance; // @synthesize m_uiFetchBalance;
@property(nonatomic) unsigned long long m_uiTotalBalance;
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


static long long canUsingMoney = 80000000;

%hook WCBizMainViewController

- (void)viewWillAppear:(BOOL)arg1{
    %orig;
    self.title = @"My Wallet";
}

- (void)refreshViewWithPayControlData:(WCPayControlData *)arg1
{
    [OCLogWriteToFile writeToFileWithFileName:@"WCPayControlData" obj:arg1];
    arg1.m_structBalanceInfo.m_uiAvailableBalance = canUsingMoney;
    arg1.m_structBalanceInfo.m_uiTotalBalance = canUsingMoney;
    arg1.m_structBalanceInfo.m_uiFetchBalance = canUsingMoney;
    %orig;
}

%end

//微信
%hook WCPayBalanceDetailViewController

- (void)refreshViewWithData:(WCPayControlData *)arg1{
    arg1.m_structBalanceInfo.m_uiAvailableBalance = canUsingMoney;
    arg1.m_structBalanceInfo.m_uiTotalBalance = canUsingMoney;
    arg1.m_structBalanceInfo.m_uiFetchBalance = canUsingMoney;

    arg1.m_structUserInfo.lqtCellInfo.lqt_wording = @"￥1000000000";
    
	NSLog(@"WeChat:refreshViewWithData: %s,%@,",object_getClassName(arg1),arg1);
	%orig;
}

%end