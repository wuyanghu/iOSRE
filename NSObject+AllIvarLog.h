//
//  NSObject+ModelToDictionary.h
//  iOSREHeaders
//
//  Created by ruantong on 2019/7/5.
//  Copyright © 2019 wupeng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (AllIvarLog)
- (void)writeToFileWithClass;
- (id)idFromObject:(nonnull id)object;
- (NSDictionary *)dictionaryFromModel;
@end

NS_ASSUME_NONNULL_END
