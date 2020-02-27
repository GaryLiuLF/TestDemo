//
//  WXApiManager.h
//  MMJR
//
//  Created by 电信中国 on 2019/8/1.
//  Copyright © 2019年 LiuLinFei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WXApi.h>

NS_ASSUME_NONNULL_BEGIN

@protocol WXApiManagerDelegate <NSObject>

@end

@interface WXApiManager : NSObject <WXApiDelegate>

@property (nonatomic, assign) id<WXApiManagerDelegate> delegate;
+ (instancetype)sharedManager;

@end

NS_ASSUME_NONNULL_END
