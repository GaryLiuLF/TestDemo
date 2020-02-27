//
//  AlongModel.h
//  License
//
//  Created by wei on 2019/7/12.
//  Copyright © 2019年 wei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlongModel : NSObject
@property (nonatomic,assign)int isAnser;
@property (nonatomic,assign)int isHere;
@property (nonatomic,assign)int isRight;//判断题不用，单多选定下规则
- (instancetype)initWithValue:(NSString*)value;
- (NSString*)currentValue;
@end
