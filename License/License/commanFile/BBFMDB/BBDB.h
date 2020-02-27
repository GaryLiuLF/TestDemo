//
//  PPDB.h
//  SecondMemory
//
//  Created by wei on 2018/9/29.
//  Copyright © 2018年 wei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

@interface BBDB : NSObject{
    FMDatabase*db;
}
+ (instancetype)sharedManager;
@end

