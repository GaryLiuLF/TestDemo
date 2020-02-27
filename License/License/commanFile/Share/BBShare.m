//
//  BBShare.m
//  License
//
//  Created by 电信中国 on 2019/10/21.
//  Copyright © 2019 wei. All rights reserved.
//

#import "BBShare.h"

#import <UMShare/UMShare.h>
#import <UShareUI/UShareUI.h>
#import <YYKit.h>

@implementation BBShare

+ (void)initWithUMShare {
    [self setupUSharePlatforms];
}

+ (void)setupUSharePlatforms {
    //设置友盟appkey
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wxa3a4b2435855efe0" appSecret:nil redirectURL:nil];
    
    NSString *qqAppID = @"1106259697";
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:qqAppID appSecret:nil redirectURL:nil];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_Qzone),@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine), @(UMSocialPlatformType_Sms)]];
    });
}

- (void)showShareActionWithParams:(NSDictionary *)params {
    NSString *title = params[@"title"];
    NSString *content = params[@"content"];
    NSString *url = params[@"url"];
    NSString *imageUrl = params[@"imageUrl"];
    [self showShareActionWithTitle:title content:content url:url imageUrl:imageUrl controller:[self iqCurrentViewController]];
}

- (UIViewController *)iqCurrentViewController {
    for (UIView *view = self; view; view = view.superview) {
        UIResponder *nextResponder = [view nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

//网页分享
- (void)showShareActionWithTitle: (NSString *)title content:(NSString *)content url:(NSString *) url imageUrl:(id)imageUrl  controller: (UIViewController *)controller {
    [UMSocialShareUIConfig shareInstance].sharePageGroupViewConfig.sharePageGroupViewPostionType = UMSocialSharePageGroupViewPositionType_Bottom;
    [UMSocialShareUIConfig shareInstance].sharePageScrollViewConfig.shareScrollViewPageItemStyleType = UMSocialPlatformItemViewBackgroudType_None;
    
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        //创建分享消息对象
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        // TODO(ChenQiuShi): 1.0上线后，分享QQ微下载的下载链接
        //创建网页内容对象
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:content thumImage:imageUrl];
        shareObject.webpageUrl = url;
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject;
        
        //调用分享接口
        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:controller completion:^(id result, NSError *error) {
            NSLog(@"%@, %@", result, error);
            if (error) {
                NSLog(@"************Share fail with error %@*********",error.userInfo[@"share error"]);
                [[[UIAlertView alloc] initWithTitle:@"分享失败"
                                            message:@"请稍后重试"
                                           delegate:nil
                                  cancelButtonTitle:@"确定"
                                  otherButtonTitles:nil] show];
            }else{
                MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:controller.view animated:YES];
                hub.mode = MBProgressHUDModeText;
                hub.label.text = @"分享成功";
                hub.label.textColor = [UIColor whiteColor];
                hub.backgroundColor = [UIColor clearColor];
                hub.label.font = [UIFont systemFontOfSize:16];
                hub.bezelView.backgroundColor = [UIColor colorWithHexString:@"#444444"];
                [hub hideAnimated:YES afterDelay:2];
            }
            
        }];
    }];
}

@end

