//
//  AlongModel.m
//  License
//
//  Created by wei on 2019/7/12.
//  Copyright © 2019年 wei. All rights reserved.
//

#import "AlongModel.h"

@implementation AlongModel

- (instancetype)initWithValue:(NSString*)value;{
    self = [super init];
    if(self){
        if(!value || [value isEqualToString:@""]){
            self.isAnser=0;
            self.isRight=0;
            self.isHere=0;
        }else{
            NSArray*a=[value componentsSeparatedByString:@"-"];
            self.isAnser=[a[0] intValue];
            self.isRight=[a[1] intValue];
            self.isHere=[a[2] intValue];
        }
    }
    return self;
}
- (void)setValue:(NSString*)value;{
//    if(!value || [value isEqualToString:@""]){
//        self.isHere=0;
//        self.isAnser=0;
//        self.isRight=0;
//        return;
//    }
    NSArray*a=[value componentsSeparatedByString:@"-"];
    self.isAnser=[a[0] intValue];
    self.isRight=[a[1] intValue];
    self.isRight=[a[2] intValue];
}
- (NSString*)currentValue;{
    return [NSString stringWithFormat:@"%d-%d-%d",self.isAnser,self.isRight,self.isHere];
}


@end
