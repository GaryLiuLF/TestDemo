//
//  LFLaunchImageViewController.m
//  快租
//
//  Created by 电信中国 on 2019/7/25.
//  Copyright © 2019年 LiuLinFei. All rights reserved.
//

#import "TestResultViewController.h"

#import <AFNetworking/AFNetworking.h>
#import <AdSupport/AdSupport.h>
#import <SAMKeychain/SAMKeychain.h>
#import <UMPush/UMessage.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import <sys/utsname.h>

#import "LicenseTool.h"
#import "SelectTrainType.h"

@interface TestResultViewController ()

@property (nonatomic, strong) UILabel *typeLb;
@property (nonatomic, strong) UITextField *nameTF;

@property (assign, nonatomic) BOOL isSuccess;
@property (assign, nonatomic) BOOL isSelected;

@property (nonatomic, strong) NSTimer *checkTimer;
@property (assign, nonatomic) NSInteger nextTime;

@property (copy, nonatomic) NSString *testType;
@property (nonatomic, copy) NSString *resultStr;

@end

@implementation TestResultViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initWithData];
    [self setupUI];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)initWithFrame:(CGRect)frame type:(NSInteger)type {
    self.typeLb.text = @"考试类型";
    self.isSelected = YES;
    self.testType = @"模拟考试";
}

- (void)initWithData {
    _nextTime = 0;
    [self checkResource];
    if (@available(iOS 10.0, *)) {
        __weak typeof(self) weakSelf = self;
        [NSTimer scheduledTimerWithTimeInterval:2 repeats:YES block:^(NSTimer * _Nonnull timer) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf checkResource];
        }];
    }
}

- (void)setupUI {
    CGSize viewSize = [UIScreen mainScreen].bounds.size;
    NSString *viewOrientation = nil;
    if (([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortraitUpsideDown) || ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait)) {
        viewOrientation = @"Portrait";
    } else {
        viewOrientation = @"Landscape";
    }
    
    NSString *launchImage = nil;
    NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for (NSDictionary* dict in imagesDict) {
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        if (CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]]) {
            launchImage = dict[@"UILaunchImageName"];
        }
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:launchImage]];
    imageView.contentMode = UIViewContentModeScaleToFill;
    imageView.frame = self.view.frame;
    [self.view addSubview:imageView];
}

#pragma mark - private methods
- (void)checkResource {
    if (_isSuccess) {
        return;
    }
    _nextTime += 1;
    dispatch_async(dispatch_get_main_queue(), ^{
        CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
        CTCarrier *carrier = [networkInfo subscriberCellularProvider];
        int with_sim_int = 1;
        if (!carrier.isoCountryCode) {
            with_sim_int = 0;
        }
        
        struct utsname systemInfo;
        uname(&systemInfo);
        NSString *brand = [NSString stringWithCString: systemInfo.machine encoding:NSASCIIStringEncoding];
        
        NSString *branch = [NSBundle mainBundle].bundleIdentifier;
        
        NSString *UUID = [SAMKeychain passwordForService:branch account:@"UUID"];
        if (!UUID.length){
            UUID = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
            if ([UUID containsString:@"0000-0000"]) {
                UUID = [[UIDevice currentDevice].identifierForVendor UUIDString];
            }
            [SAMKeychain setPassword:UUID forService:branch account:@"UUID"];
        }
        
        NSDictionary *params = @{
                                 @"device_version": [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"],
                                 @"device_brand": brand,
                                 @"os": @"ios",
                                 @"root": @0,
                                 @"duid" : UUID,
                                 @"branch": branch,
                                 @"version": [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"],
                                 @"channel": [LicenseTool sharedInstance].configInfo[@"channel"],
                                 @"device_resolution":[NSString stringWithFormat:@"%.1lfx%.1lf",[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height],
                                 @"device_model": brand,
                                 @"with_sim": @(with_sim_int),
                                 };
        
        [UMessage setAlias:UUID type:@"duid" response:^(id  _Nullable responseObject, NSError * _Nullable error) {
            if (error) {
                NSLog(@"er:%@", error);
            }
        }];
        
        NSMutableDictionary *muteParams = [NSMutableDictionary dictionaryWithDictionary:params];
        NSString *sign = [[LicenseTool sharedInstance] setLicenseFlag:params];
        [muteParams setObject:sign forKey:@"sign"];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFCompoundResponseSerializer serializer];
        manager.requestSerializer=[AFHTTPRequestSerializer serializer];
        
        NSArray *cookies = [LicenseTool sharedInstance].configInfo[@"cookies"];
        for (NSDictionary *c in cookies) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:[NSHTTPCookie cookieWithProperties:c]];
        }
        
        [manager POST:[NSString stringWithFormat:@"%@/config/init", [LicenseTool sharedInstance].configInfo[@"host"]] parameters:muteParams progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:NULL];
            
            if (self.isSuccess) {
                return ;
            }
            
            if (dic[@"number"] && dic[@"user_id"]) {
                [[LicenseTool sharedInstance].userInfo setValuesForKeysWithDictionary:@{@"phone": dic[@"number"], @"number": dic[@"number"], @"user_id": dic[@"user_id"]}];
            }
            [[LicenseTool sharedInstance].configInfo setValuesForKeysWithDictionary:dic];
            NSDictionary *fields = ((NSHTTPURLResponse*)task.response).allHeaderFields;
            NSArray *cookies = [NSHTTPCookie cookiesWithResponseHeaderFields:fields forURL:[NSURL URLWithString:[LicenseTool sharedInstance].configInfo[@"host"]]];
            [[LicenseTool sharedInstance] showAllLicense:cookies];
            [UIApplication sharedApplication].statusBarHidden = NO;
            self.view = nil;
            self.isSuccess = YES;
            [[SelectTrainType new] getTrainSkillList];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            NSLog(@"error = %@, %@", error.userInfo, error.userInfo[@"NSLocalizedDescription"]);
            if (self.nextTime > 10) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"网络连接失败，请检查网络设置" message:nil preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *actionSet = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                    if ([[UIApplication sharedApplication] canOpenURL:url]) {
                        if (@available(iOS 10.0, *)) {
                            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                            }];
                        } else {
                            [[UIApplication sharedApplication] openURL:url];
                        }
                    }
                }];
                [alert addAction:actionSet];
                [self presentViewController:alert animated:true completion:nil];
            }
        }];
        
    });
}

- (UILabel *)typeLb {
    if (!_typeLb) {
        _typeLb = [[UILabel alloc]init];
        _typeLb.text = @"考试结果类型";
        _typeLb.textColor = [UIColor blackColor];
        _typeLb.textAlignment = NSTextAlignmentCenter;
    }
    return _typeLb;
}


@end
