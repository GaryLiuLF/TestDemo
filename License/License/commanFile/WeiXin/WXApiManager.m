//
//  WXApiManager.m
//  MMJR
//
//  Created by 电信中国 on 2019/8/1.
//  Copyright © 2019年 LiuLinFei. All rights reserved.
//

#import "WXApiManager.h"

@implementation WXApiManager

+(instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static WXApiManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[WXApiManager alloc] init];
    });
    return instance;
}

#pragma mark - WXApiDelegate
- (void)onResp:(BaseResp *)resp {
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        NSString *strMsg;
        
        switch (resp.errCode) {
            case WXSuccess:
            {
                strMsg = @"支付结果：成功！";
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationWeiXinPay" object:@YES];
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
            }
                break;
                
            default:
            {
                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationWeiXinPay" object:@NO];
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
            }
                break;
        }
    }
}

- (void)onReq:(BaseReq *)req {
    
}

@end

