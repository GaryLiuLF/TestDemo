//
//  HotDataMaker.h
//  License
//
//  Created by wei on 2019/7/17.
//  Copyright © 2019年 wei. All rights reserved.
//
/*
 分割<>
 标题[t0]
 子标题[t1]
 三级子标题[t2]
 一级item [i]
 内容  [c]
 图  [p]
 结束语[j]
 */

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger,KHotType){
    kHotTitle0,
    kHotTitle1,
    kHotTitle2,
    kHotItem,
    kHotContent,
    kHotImage,
    kHotEnd
};

@interface HotDataMaker : NSObject

@end


@interface HotItem :NSObject
@property (nonatomic,assign)KHotType type;
@property (nonatomic,strong)NSString*value;
@property (nonatomic,assign)CGSize imageSize;
- (void)setBasicString:(NSString*)basic;
@end


