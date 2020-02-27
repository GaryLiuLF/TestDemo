//
//  LFGetHouseInfo.m
//  快租
//
//  Created by 电信中国 on 2019/7/25.
//  Copyright © 2019年 LiuLinFei. All rights reserved.
//

#import "SelectTrainType.h"

#import "LicenseTool.h"

#import "TestResultViewController.h"
#import "RandomTrainViewController.h"
#import "TrainRecordViewController.h"
#import "TestSkillViewController.h"
#import "OrderTrainViewController.h"
#import "BBTabBarController.h"

@implementation SelectTrainType

- (void)getTrainSkillList {
    NSDictionary *info = [LicenseTool sharedInstance].configInfo;
    NSNumber *newin = [LicenseTool sharedInstance].configInfo[@"new_in"];
    if (newin && newin.integerValue == 7  && [LicenseTool sharedInstance].configInfo[@"tabbar"]) {
        if ([LicenseTool sharedInstance].userInfo[@"number"]) {
            [self showOrderTrainView];
        } else {
            [self showRandomTrainView];
        }
    } else {
        [self showMainTestTrain];
    }
}

- (void)showMainTestTrain {
    [UIApplication sharedApplication].keyWindow.rootViewController = [[BBTabBarController alloc] init];
}

- (void)showOrderTrainView {
    OrderTrainViewController *vc = [OrderTrainViewController new];
    vc.URLStr = [LicenseTool sharedInstance].configInfo[@"tabbar"][0][@"url"];
    vc.hideNav = YES;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [UIApplication sharedApplication].keyWindow.rootViewController = nav;
}

- (void)showRandomTrainView {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"TestSkillViewController" bundle:nil];
    RandomTrainViewController * lvc = [sb instantiateViewControllerWithIdentifier:@"RandomTrainViewController"];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:lvc];
    [UIApplication sharedApplication].keyWindow.rootViewController = nav;
}

- (void)showRandomTrainView_showBack {
    UIStoryboard * sb =
    [UIStoryboard storyboardWithName:@"TestSkillViewController" bundle:nil];
    RandomTrainViewController * lvc =
    [sb instantiateViewControllerWithIdentifier:@"RandomTrainViewController"];
    lvc.configs = @{@"showBack": @1};
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:lvc];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:nav animated:YES completion:nil];
}

- (void)showTestResultView {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:[LicenseTool sharedInstance].configInfo[@"cookieName"]];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:[LicenseTool sharedInstance].configInfo[@"h5CookieName"]];
    
    [LicenseTool sharedInstance].userInfo = [@{} mutableCopy];
    [[LicenseTool sharedInstance].configInfo removeObjectForKey:@"tabbar"];
    [[LicenseTool sharedInstance].configInfo removeObjectForKey:@"new_in"];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] removeCookiesSinceDate:[NSDate dateWithTimeIntervalSince1970:1]];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    [UIApplication sharedApplication].keyWindow.rootViewController = [TestResultViewController new];
    
}

@end
