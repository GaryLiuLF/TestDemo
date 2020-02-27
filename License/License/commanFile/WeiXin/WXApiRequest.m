//
//  WXApiRequest.m
//  MMJR
//
//  Created by 电信中国 on 2019/8/1.
//  Copyright © 2019年 LiuLinFei. All rights reserved.
//

#import "WXApiRequest.h"
#import <WXApi.h>

@implementation WXApiRequest

+ (void)jumpToWeiXinPayWithParam:(NSDictionary *)param fromVC:(nonnull UIViewController *)superVC{
    
    
    NSDictionary *dic = param[@"sign_we"];
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]]) {
        // 微信授权
        [WXApi registerApp:dic[@"appid"]];
        
        //调起微信支付
        PayReq* req             = [[PayReq alloc] init];
        req.partnerId           = [dic objectForKey:@"partnerid"];
        req.prepayId            = [dic objectForKey:@"prepayid"];
        req.nonceStr            = [dic objectForKey:@"noncestr"];
        req.timeStamp           = [[dic objectForKey:@"timestamp"]intValue];
        req.package             = [dic objectForKey:@"pack"];
        req.sign                = [dic objectForKey:@"sign"];
        
        [WXApi sendReq:req];
    }
    else {
        UIAlertController *alertContr = [UIAlertController alertControllerWithTitle:@"提示" message:@"您尚未安装微信或者微信版本过低，建议升级至最新版本后重试" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"去下载" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (@available(iOS 10.0, *)) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id414478124"] options:@{} completionHandler:nil];
            } else {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id414478124"]];
            }
        }];
        [alertContr addAction:cancelAction];
        [alertContr addAction:sureAction];
        
        [superVC presentViewController:alertContr animated:YES completion:nil];
    }
}


@end
