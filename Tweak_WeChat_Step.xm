#import <substrate.h>
#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "OCLogWriteToFile.h"
#import "OCShowAlertView.h"

//修改微信步数

@interface  WCDeviceStepObject:NSObject
- (unsigned long)getStepCount;
- (NSString *)getNowDateString;
- (NSInteger)getweekDayStringWithDate:(NSString *)dateStr;
- (NSString *)stepKeyWithDateString:(NSString *)dateString;
- (unsigned long)getEverydayRandomStep;
@end

%hook WCDeviceStepObject

- (unsigned long)hkStepCount{
    unsigned long count = %orig*1.5;
    return count;
}

- (unsigned long)m7StepCount{

    unsigned long count = %orig*1.5;
    return count;
}

%new;
- (unsigned long)getEverydayRandomStep{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * stepKey = [self stepKeyWithDateString:[self getNowDateString]];
    
    double step = [userDefaults doubleForKey:stepKey];
    if (step <= 10) {
        step = [self getStepCount];
        [userDefaults setDouble:step forKey:stepKey];
    }
    return (unsigned long)step;
}

%new;
- (unsigned long)getStepCount{
    NSString * dateString = [self getNowDateString];
    NSInteger weekData = [self getweekDayStringWithDate:dateString];
    if (weekData == 6) {
        return 5000+arc4random()%5000;
    }else if(weekData == 7){
        return 10000+arc4random()%15000;
    }
    return 2000+arc4random()%5000;
}

%new;
- (NSString *)stepKeyWithDateString:(NSString *)dateString{
    return [NSString stringWithFormat:@"wechatstep_%@",[self getNowDateString]];
}

%new;
- (NSString *)getNowDateString{
    //获取当前时间日期
    NSDate *date=[NSDate date];
    NSDateFormatter *format1=[[NSDateFormatter alloc] init];
    [format1 setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr;
    dateStr=[format1 stringFromDate:date];
    NSLog(@"wechatstep %@",dateStr);
    return dateStr;
}

%new;
- (NSInteger)getweekDayStringWithDate:(NSString *)dateStr{
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
    NSDate *newDate=[format dateFromString:dateStr];
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar]; // 指定日历的算法
    NSDateComponents *comps = [calendar components:NSWeekdayCalendarUnit fromDate:newDate];// 1 是周日，2是周一 3.以此类推
    NSInteger weekDay = comps.weekday-1 == 0?7:comps.weekday-1;
    return weekDay;
}

%end
