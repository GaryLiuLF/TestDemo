//
//  NSDictionary+Library.m
//  NextStepPP
//
//  Created by wei on 2018/7/6.
//  Copyright © 2018年 wei. All rights reserved.
//

#import "NSDictionary+Library.h"

@implementation NSDictionary (Library)

- (NSDictionary *)deleteNull{
    NSMutableDictionary *mutableDic = [[NSMutableDictionary alloc] init];
    for (NSString *keyStr in self.allKeys) {
        if ([[self objectForKey:keyStr] isEqual:[NSNull null]]) {
            [mutableDic setObject:@"" forKey:keyStr];
        }
        else{
            [mutableDic setObject:[self objectForKey:keyStr] forKey:keyStr];
        }
    }
    return mutableDic;
}

@end
