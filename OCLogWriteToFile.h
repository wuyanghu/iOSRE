//
//  NSObject+ModelToDictionary.h
//  iOSREHeaders
//
//  Created by ruantong on 2019/7/5.
//  Copyright © 2019 wupeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OCLogWriteToFile:NSObject
+ (void)writeToFileWithFileName:(NSString *)fileName obj:(id)obj;
@end
