//
//  PPDB.m
//  SecondMemory
//
//  Created by wei on 2018/9/29.
//  Copyright © 2018年 wei. All rights reserved.
//

#import "BBDB.h"
#import "SBJson5.h"
#import "HSDownloadManager.h"
@interface BBDB ()
@end

static BBDB *manager = nil;
@implementation BBDB
+ (instancetype)sharedManager
{
    if (manager == nil)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            manager = [[[self class] alloc] init];
        });
    }
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        //[self fmdb];
    }
    return self;
}
@end
