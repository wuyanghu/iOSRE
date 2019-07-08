#import <substrate.h>
#import <Foundation/Foundation.h>
#import "src/CustomTestView.h"

@interface NSObject (LogWriteToFile)
- (void)writeToFileWithClass;
- (id)idFromObject:(nonnull id)object;
- (NSDictionary *)dictionaryFromModel;
- (void)showAlertView:(NSString *)message;
@end

@implementation NSObject (LogWriteToFile)

- (void)writeToFileWithClass{
    
    NSDictionary *dictionary = [self dictionaryFromModel];
    
    NSString * allClassMessage = [NSString stringWithFormat:@"%@",dictionary];
    NSString * writePath = [NSString stringWithFormat:@"/var/mobile/%@.txt",NSStringFromClass([self class])];
    [allClassMessage writeToFile:writePath atomically:NO encoding:4 error:NULL];
}

- (NSDictionary *)dictionaryFromModel
{
    unsigned int count = 0;
    
    Ivar * ivars = class_copyIvarList([self class], &count);
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:count];
    
    for (int i = 0; i < count; i++) {
        NSString *key = [NSString stringWithUTF8String:ivar_getName(ivars[i])];
        id value = [self valueForKey:key];
        
        //only add it to dictionary if it is not nil
        if (key && value) {
            if ([value isKindOfClass:[NSString class]]
                || [value isKindOfClass:[NSNumber class]]) {
                [dict setObject:value forKey:key];
            }else if ([value isKindOfClass:[NSArray class]]
                     || [value isKindOfClass:[NSDictionary class]]) {
                // 数组类型或字典类型
                [dict setObject:[self idFromObject:value] forKey:key];
            }else{
                if (![@"NSObject" isEqualToString:NSStringFromClass(value)]) {
                    [dict setObject:[value dictionaryFromModel] forKey:key];
                }
            }
        } else if (key && value == nil) {
            // 如果当前对象该值为空，设为nil。在字典中直接加nil会抛异常，需要加NSNull对象
            [dict setObject:[NSNull null] forKey:key];
        }
    }
    
    free(ivars);
    return dict;
}

- (id)idFromObject:(nonnull id)object
{
    if ([object isKindOfClass:[NSArray class]]) {
        if (object != nil && [object count] > 0) {
            NSMutableArray *array = [NSMutableArray array];
            for (id obj in object) {
                // 基本类型直接添加
                if ([obj isKindOfClass:[NSString class]]
                    || [obj isKindOfClass:[NSNumber class]]) {
                    [array addObject:obj];
                }
                // 字典或数组需递归处理
                else if ([obj isKindOfClass:[NSDictionary class]]
                         || [obj isKindOfClass:[NSArray class]]) {
                    [array addObject:[self idFromObject:obj]];
                }
                // model转化为字典
                else {
                    [array addObject:[obj dictionaryFromModel]];
                }
            }
            return array;
        }
        else {
            return object ? : [NSNull null];
        }
    }
    else if ([object isKindOfClass:[NSDictionary class]]) {
        if (object && [[object allKeys] count] > 0) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            for (NSString *key in [object allKeys]) {
                // 基本类型直接添加
                if ([object[key] isKindOfClass:[NSNumber class]]
                    || [object[key] isKindOfClass:[NSString class]]) {
                    [dic setObject:object[key] forKey:key];
                }
                // 字典或数组需递归处理
                else if ([object[key] isKindOfClass:[NSArray class]]
                         || [object[key] isKindOfClass:[NSDictionary class]]) {
                    [dic setObject:[self idFromObject:object[key]] forKey:key];
                }
                // model转化为字典
                else {
                    [dic setObject:[object[key] dictionaryFromModel] forKey:key];
                }
            }
            return dic;
        }
        else {
            return object ? : [NSNull null];
        }
    }
    
    return [NSNull null];
}


- (void)showAlertView:(NSString *)message{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:message message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
}

@end

@interface YKFSquareCViewController:NSObject
@end

@interface YTEngineController:NSObject
@end

%hook YKFSquareCViewController

- (void)viewDidLoad{
    %orig;
}
%end

%hook YTEngineController

- (void)skipAd:(int)arg1{
    %orig;
}

- (_Bool)skipCurrentAd:(id)arg1{
    return %orig;
}
%end

@interface OPDataSourceHelper:NSObject
@end
@interface OPDataSourceManager:NSObject
@end

@interface OPManagerFactory:NSObject
@property(readonly, nonatomic) OPDataSourceHelper *dataSourceHelper; // @synthesize dataSourceHelper=_dataSourceHelper;
@property(readonly, nonatomic) OPDataSourceManager *dataSourceManager; // @synthesize dataSourceManager=_dataSourceManager;
@end

@interface OPPlayerAPI:NSObject
@property(retain, nonatomic) OPManagerFactory *managerFactory;
@end

%hook OPPlayerAPI

- (void)playWithVideo:(id)arg1{
    // [arg1 writeToFileWithClass];
    // [self.managerFactory writeToFileWithClass];
    // [self.managerFactory.dataSourceManager writeToFileWithClass];
    // [self.managerFactory.dataSourceHelper writeToFileWithClass];
    %orig;
}

%end

@interface XAdEngineVideoAdView:UIView
@property(nonatomic) _Bool isCountDownInvisible;
@property(nonatomic) long long unableSkipTime;
@property(nonatomic) long long ableSkipTime;
@property(nonatomic) double countdownTime;
@property(nonatomic) long long totalSkipTime;
- (void)updateMethod;
@end



%hook XAdEngineVideoAdView

- (void)updateSkipViewFinishStatus:(id)arg1{
    [self updateMethod];
    %orig;
}

- (void)updateSkipViewPromptContent:(id)arg1{
    [self updateMethod];
    %orig;
}

- (void)updateCountDownLabelStyle:(id)arg1{
    [self updateMethod];
    %orig;
}

- (void)updateVipSkipContent{
    [self updateMethod];
    %orig;
}

- (void)updateEventSkipViewInfo:(id)arg1{
    [self updateMethod];
    %orig;
}

- (void)layoutSubviews{
    %orig;
}

%new
- (void)updateMethod{
    // self.ableSkipTime = self.countdownTime;
}
%end

@interface XAdEnginePlayerAdItem:NSObject
@end

@interface XAdEnginePreAdModule:UIView
@property(retain, nonatomic) XAdEnginePlayerAdItem *adItem;
@end

%hook XAdEnginePreAdModule
- (_Bool)needAd{
    %orig;
    return NO;
}

- (void)getADInfo:(id)arg1{
    [self showAlertView:@"getADInfo"];
    [self writeToFileWithClass];
    // [self.adItem writeToFileWithClass];
    %orig;
}

%end





