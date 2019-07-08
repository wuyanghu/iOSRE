//
//  NSObject+ModelToDictionary.m
//  iOSREHeaders
//
//  Created by ruantong on 2019/7/5.
//  Copyright © 2019 wupeng. All rights reserved.
//

#import "NSObject+LogWriteToFile.h"
#import <objc/runtime.h>
#import "OCShowAlertView.h"

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
                if (![value isMemberOfClass:[NSObject class]]) {
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


@end
