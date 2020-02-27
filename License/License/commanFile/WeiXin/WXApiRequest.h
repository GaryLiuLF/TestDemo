//
//  WXApiRequest.h
//  MMJR
//
//  Created by 电信中国 on 2019/8/1.
//  Copyright © 2019年 LiuLinFei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WXApiRequest : NSObject

+ (void)jumpToWeiXinPayWithParam:(NSDictionary *)param  fromVC:(UIViewController *)superVC;

@end

NS_ASSUME_NONNULL_END
