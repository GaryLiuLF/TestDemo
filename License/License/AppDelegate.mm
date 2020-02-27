//
//  AppDelegate.m
//  License
//
//  Created by wei on 2019/7/8.
//  Copyright © 2019年 wei. All rights reserved.
//

#import "AppDelegate.h"
#import "TestResultViewController.h"

#import <UMCommon/UMCommon.h>
#import <UMPush/UMessage.h>
#import <UMAnalytics/MobClick.h>
#import <MGBaseKit/MGBaseKit.h>
#import <UMShare/UMShare.h>
#import <AlipaySDK/AlipaySDK.h>
#import "WXApiManager.h"
#import "BBShare.h"

@interface AppDelegate ()<UNUserNotificationCenterDelegate>
@property (nonatomic,strong)NSDictionary*launchOptions;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [DBTool moveDBToCache];
    [UMConfigure initWithAppkey:@"5d71f2b33fc195314c000995" channel:@"iOSJiaDao"];
    [MobClick setScenarioType:E_UM_NORMAL];
    if([CommandManager sharedManager].canPush){
        self.launchOptions = launchOptions;
        UMessageRegisterEntity * entity = [[UMessageRegisterEntity alloc] init];
        //type是对推送的几个参数的选择，可以选择一个或者多个。默认是三个全部打开，即：声音，弹窗，角标
        entity.types = UMessageAuthorizationOptionBadge|UMessageAuthorizationOptionAlert|UMessageAuthorizationOptionSound;
        if (@available(iOS 10.0, *)) {
            [UNUserNotificationCenter currentNotificationCenter].delegate=self;
        } else {
            // Fallback on earlier versions
        }
        [UMessage registerForRemoteNotificationsWithLaunchOptions:launchOptions Entity:entity completionHandler:^(BOOL granted, NSError * _Nullable error) {
        }];
    }
    
    if (![MGLicenseManager getLicense]) {
        [MGLicenseManager licenseForNetWokrFinish:^(bool License) {
            NSLog(@"%@", [NSString stringWithFormat:@"授权%@", License ? @"成功" : @"失败"]);
        }];
    }
    
    [BBShare initWithUMShare];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [TestResultViewController new];
    [self.window makeKeyAndVisible];
    
    return YES;
}
- (void)registerNotificate:(BOOL)isNeed;{
    if(isNeed){
        UMessageRegisterEntity * entity = [[UMessageRegisterEntity alloc] init];
        //type是对推送的几个参数的选择，可以选择一个或者多个。默认是三个全部打开，即：声音，弹窗，角标
        entity.types = UMessageAuthorizationOptionBadge|UMessageAuthorizationOptionAlert|UMessageAuthorizationOptionSound;
        if (@available(iOS 10.0, *)) {
            [UNUserNotificationCenter currentNotificationCenter].delegate=self;
        } else {
            // Fallback on earlier versions
        }
        [UMessage registerForRemoteNotificationsWithLaunchOptions:self.launchOptions Entity:entity completionHandler:^(BOOL granted, NSError * _Nullable error) {
        }];
    }else{
        [UMessage unregisterForRemoteNotifications];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//iOS10以下使用这两个方法接收通知
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [UMessage setAutoAlert:NO];
    if([[[UIDevice currentDevice] systemVersion]intValue] < 10){
        [UMessage didReceiveRemoteNotification:userInfo];
    }
    completionHandler(UIBackgroundFetchResultNewData);
}
//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    NSDictionary * userInfo = notification.request.content.userInfo;
    if (@available(iOS 10.0, *)) {
        if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            [UMessage setAutoAlert:NO];
            //应用处于前台时的远程推送接受
            //必须加这句代码
            [UMessage didReceiveRemoteNotification:userInfo];
        }else{
            //应用处于前台时的本地推送接受
        }
    } else {
        // Fallback on earlier versions
    }
    if (@available(iOS 10.0, *)) {
        completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
    } else {
        // Fallback on earlier versions
    }
}

//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if (@available(iOS 10.0, *)) {
        if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            //应用处于后台时的远程推送接受
            //必须加这句代码
            [UMessage didReceiveRemoteNotification:userInfo];
        }else{
            //应用处于后台时的本地推送接受
        }
    } else {
        // Fallback on earlier versions
    }
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    //[self stringDevicetoken:deviceToken];
    //[PPBmob sharedBmob].deviceToken = [self stringDevicetoken:deviceToken];
    NSLog(@"test:%@",[self stringDevicetoken:deviceToken]);
}
-(NSString *)stringDevicetoken:(NSData *)deviceToken
{
    return @"";
//    NSString *token = [deviceToken description];
//    NSString *pushToken = [[[token stringByReplacingOccurrencesOfString:@"<"withString:@""]                   stringByReplacingOccurrencesOfString:@">"withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
//    return pushToken;
}
// 当 DeviceToken 获取失败时，系统会回调此方法
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"DeviceToken 获取失败，原因：%@",error);
}


// 支持所有iOS系统
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
        // 微信的支付支付回调
        if ([url.host isEqualToString:@"pay"]) {
            return  [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
        }
        if ([url.host isEqualToString:@"safepay"]) {
            //跳转支付宝钱包进行支付，处理支付结果
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                NSLog(@"result = %@",resultDic);
                // 支付成功
                if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationAliPay" object:@YES];
                }
                else {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationAliPay" object:@NO];
                }
            }];
        }
    }
    return result;
}

@end
