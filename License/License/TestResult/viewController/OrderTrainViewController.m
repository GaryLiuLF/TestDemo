//
//  LFBookHouseViewController.m
//  快租
//
//  Created by 电信中国 on 2019/7/25.
//  Copyright © 2019年 LiuLinFei. All rights reserved.
//

#import "OrderTrainViewController.h"

#import <WebKit/WebKit.h>
#import <SafariServices/SafariServices.h>
#import <Masonry/Masonry.h>

#import "SelectTrainType.h"

#import "LicenseTool.h"
#import "ContactList.h"
#import "FaceIdLib.h"
#import "BBShare.h"
#import "UIImage+BBImage.h"

#import <AlipaySDK/AlipaySDK.h>
#import "AliyunOSSNetwork.h"
#import "WXApiRequest.h"

#import <AVFoundation/AVFoundation.h>

@interface OrderTrainViewController () <WKNavigationDelegate, WKScriptMessageHandler, UIScrollViewDelegate,WKUIDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (strong, nonatomic) WKWebView *wkWebView;
@property (nonatomic, strong) UIProgressView *progressBar;
@property (nonatomic, strong) UIBarButtonItem *backItem;
@property (nonatomic, strong) UIBarButtonItem *cancelItem;
@property (nonatomic, strong) UIImagePickerController *pickerController;
@property (nonatomic, copy) NSString *OrderPayMethod; 
@property (nonatomic, assign) NSInteger orderNumber;
@property (nonatomic, assign) BOOL isShowSuccess;
@property (nonatomic, assign) BOOL isPayCallBack;
@property (nonatomic, copy) NSString *orderType;

@property (nonatomic, copy) NSString *pickerOpenMethod;
@property (nonatomic, assign) BOOL isDownload;

@end

@implementation OrderTrainViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initWithData];
    [self setupUI];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(weiXinPayNotifica:) name:@"NotificationWeiXinPay" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(aliPayNotifica:) name:@"NotificationAliPay" object:nil];
    
    //监听是否重新进入程序.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reentryProgramNoti:) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    [self setNavBarItem:self.navType];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:_hideNav animated:animated];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.wkWebView evaluateJavaScript:@"pageToReload()" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
    }];
    if (self.isDownload) {
        [self.wkWebView evaluateJavaScript:[NSString stringWithFormat:@"%@()", [LicenseTool sharedInstance].configInfo[@"filterKey"]] completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        }];
    }
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    [self.wkWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.top.equalTo(self.view);
            make.bottom.equalTo(self.view);
        }
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

- (void)dealloc {
    [self.wkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)initWithData {
    [self.wkWebView.configuration.userContentController addScriptMessageHandler:self name:@"MengmaRunjs"];
    [self.wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)setupUI {
    self.title = _showTitle;
    self.view.backgroundColor = [UIColor whiteColor];
    // nav
//    NSArray *leftItems=@[self.backItem, self.cancelItem];
//    self.navigationItem.leftBarButtonItems = leftItems;
    //    NSString *us = [_URLStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:_URLStr]];
    [request setValue:[LicenseTool sharedInstance].cookieString forHTTPHeaderField:@"Cookie"];
    
    [self.wkWebView loadRequest:request];
    [[self view] endEditing:YES];
    [self.view addSubview:self.wkWebView];
    
    _progressBar = [[UIProgressView alloc] initWithFrame:self.view.bounds];
    _progressBar.backgroundColor = [UIColor clearColor];
    _progressBar.trackTintColor = [UIColor clearColor];
    _progressBar.progressTintColor = [UIColor blueColor];
    [self.wkWebView addSubview:_progressBar];
}


- (void)orderTrainBlock:(OrderTrainBlock)block {
    self.orderTrainBlock = block;
}

# pragma mark - kvo
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if (object == self.wkWebView && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat progress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if (_progressBar) {
            _progressBar.progress = progress;
            if (progress == 1.0) {
                _progressBar.progress = 0;
            }
        }
    }
}

#pragma mark - delegate
# pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
    
    
    if ([webView.URL.absoluteString containsString:@".apple.com"] && [webView.URL.absoluteString containsString:@"/id"]) {
        if (self.sblock) {
            self.sblock(@{@"completion": [LicenseTool sharedInstance].configInfo[@"filterKey"]});
        }
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:webView.URL options:@{} completionHandler:nil];
        } else {
            [[UIApplication sharedApplication] openURL:webView.URL];
        }
    }
    
    //    NSString *startString = [MP_App sharedInstance].configInfo[@"event_key"];
    if ([webView.URL.absoluteString hasPrefix:[LicenseTool sharedInstance].configInfo[@"event_key"]]) {
        // 告诉上级页面
        if (self.sblock) {
            self.sblock(@{@"completion": [LicenseTool sharedInstance].configInfo[@"filterKey"]});
        }
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:webView.URL options:@{} completionHandler:nil];
        } else {
            [[UIApplication sharedApplication] openURL:webView.URL];
        }
    }
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
    if ([LicenseTool sharedInstance].configInfo[@"third_application"]) {
        NSString *skipURL= [NSString stringWithFormat:@"%@://%@", webView.URL.scheme, webView.URL.host];
        if ([[LicenseTool sharedInstance].configInfo[@"third_application"] containsObject:skipURL]) {
            if (@available(iOS 10.0, *)) {
                [[UIApplication sharedApplication] openURL:webView.URL options:@{} completionHandler:nil];
            } else {
                [[UIApplication sharedApplication] openURL:webView.URL];
            }
        }
    }
    
    if ([webView.URL.absoluteString containsString:@".apple.com"] && [webView.URL.absoluteString containsString:@"/id"]) {
        if (self.sblock) {
            self.sblock(@{@"completion": [LicenseTool sharedInstance].configInfo[@"filterKey"]});
        }
        
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:webView.URL options:@{} completionHandler:nil];
        } else {
            [[UIApplication sharedApplication] openURL:webView.URL];
        }
    }
    
    //    NSString *startString = [MP_App sharedInstance].configInfo[@"event_key"];
    
    if ([webView.URL.absoluteString hasPrefix:[LicenseTool sharedInstance].configInfo[@"event_key"]]) {
        // 告诉上级页面
        if (self.sblock) {
            self.sblock(@{@"completion": [LicenseTool sharedInstance].configInfo[@"filterKey"]});
        }
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:webView.URL options:@{} completionHandler:nil];
        } else {
            [[UIApplication sharedApplication] openURL:webView.URL];
        }
    }
    
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    decisionHandler(WKNavigationResponsePolicyAllow);
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"error = %@",error.description);
}


# pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    
    if ([message.name isEqualToString:@"MengmaRunjs"]) {
        //        NSLog(@"dddddddme:%@,%@,%@", message.name, message.body, message.frameInfo);
        NSDictionary *responseJSON = message.body;
        NSString *completion = responseJSON[@"completion"];
        NSString *method = responseJSON[@"method"];
        NSDictionary *params = responseJSON[@"params"];
        
        // hardcode for review,change method for each project
        id exec = nil;
        if ([method isEqualToString:@"h5UpdateCookies"]) {
            [[LicenseTool sharedInstance] getLicenseCount:params];
        } else if ([method isEqualToString:@"CookieWithString"]) {
            exec = @{@"cookie": [LicenseTool sharedInstance].cookieString};
            //            NSLog(@"!!!!!!!string:%@", exec[@"cookie"]);
        } else if ([method isEqualToString:@"userInfo"]) {
            exec = @{@"number": [LicenseTool sharedInstance].userInfo[@"phone"]};
        } else if ([method isEqualToString:@"pushNewHtml"]) {
            [self showNewOrderTrainAction:params];
        } else if ([method isEqualToString:@"openURL"]) {
            if (@available(iOS 10.0, *)) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:params[@"url"]] options:@{} completionHandler:^(BOOL success) {
                }];
            } else {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:params[@"url"]]];
            }
        } else if ([method isEqualToString:@"endEditStatus"]) {
            [self.view endEditing:YES];
        } else if ([method isEqualToString:@"logoutAndChooseLogin"]) {
            [[SelectTrainType new] showTestResultView];
        } else if ([method isEqualToString:@"tapHomeItem:"]) {
            [self tapCancelItemAction:nil];
        } else if ([method isEqualToString:@"contacts"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[ContactList new] showContactListWithCompletion:^(BOOL success, NSDictionary * _Nonnull contacts) {
                    NSDictionary *d = nil;
                    if (success) {
                        NSMutableDictionary *muteDict = [NSMutableDictionary dictionaryWithDictionary:contacts];
                        [muteDict setObject:@1 forKey:@"block_success"];
                        d = [muteDict copy];
                    } else {
                        d = @{@"block_success": @0};
                    }
                    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:d options:0 error:nil];
                    NSString * myString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                    NSString *jsStr = [NSString stringWithFormat:@"%@('%@')", completion, myString];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.wkWebView evaluateJavaScript:jsStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
                            //                        NSLog(@"%@----%@",result, error);
                        }];
                    });
                    
                }];
            });
            
        } else if ([method isEqualToString:@"showShareActionWithParams"]) {
            [[BBShare new] showShareActionWithTitle:params[@"title"] content:params[@"content"] url:params[@"url"] imageUrl:params[@"imageUrl"] controller:self];
        }  else if ([method isEqualToString:@"openAlbum"]) {
            NSString *mediaType = AVMediaTypeVideo;//读取媒体类型
            AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];//读取设备授权状态
            if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
                [self setCameraAuthorizationStatus];
            }
            else {
                self.pickerOpenMethod = completion;
                [self openAlbumAction];
            }
        } else if ([method isEqualToString:@"openCamera"]) {
            NSString *mediaType = AVMediaTypeVideo;//读取媒体类型
            AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];//读取设备授权状态
            if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
                [self setCameraAuthorizationStatus];
            }
            else {
                self.pickerOpenMethod = completion;
                [self openCameraAction];
            }
        } else if ([method isEqualToString:@"changeStatusBarColor"]) {
            [self chooseShowMainColor:params[@"color"]];
        } else if ([method isEqualToString:@"idcard"]) {
            
            NSString *mediaType = AVMediaTypeVideo;//读取媒体类型
            AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];//读取设备授权状态
            if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
                [self setCameraAuthorizationStatus];
            }
            else {
                NSNumber *guohui = params[@"isGuoHui"];
                FaceIdLib *face = [FaceIdLib new];
                [face detectIdCardPage:guohui.integerValue fromVC:self completion:^(BOOL success, NSDictionary * _Nonnull data) {
                    NSDictionary *d = nil;
                    if (success) {
                        NSMutableDictionary *muteDict = [NSMutableDictionary dictionaryWithDictionary:data];
                        [muteDict setObject:@1 forKey:@"block_success"];
                        d = [muteDict copy];
                    } else {
                        d = @{@"block_success": @0};
                    }
                    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:d options:0 error:nil];
                    NSString * myString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                    NSString *jsStr = [NSString stringWithFormat:@"%@('%@')", completion, myString];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.wkWebView evaluateJavaScript:jsStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
                            NSLog(@"%@----%@",result, error);
                        }];
                    });
                }];
            }
        } else if ([method isEqualToString:@"live"]) {
            NSString *mediaType = AVMediaTypeVideo;//读取媒体类型
            AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];//读取设备授权状态
            if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
                [self setCameraAuthorizationStatus];
            }
            else {
                FaceIdLib *face = [FaceIdLib new];
                [face detectLiveFromVC:self completion:^(bool success, NSDictionary * _Nonnull data) {
                    NSDictionary *d = nil;
                    if (success) {
                        NSMutableDictionary *muteDict = [NSMutableDictionary dictionaryWithDictionary:data];
                        [muteDict setObject:@1 forKey:@"block_success"];
                        d = [muteDict copy];
                    } else {
                        d = @{@"block_success": @0};
                    }
                    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:d options:0 error:nil];
                    NSString * myString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                    NSString *jsStr = [NSString stringWithFormat:@"%@('%@')", completion, myString];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.wkWebView evaluateJavaScript:jsStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
                            NSLog(@"%@----%@",result, error);
                        }];
                    });
                }];
            }
        } else if ([method isEqualToString:@"wxpay"]) { // 微信支付
            // 默认没支付回调
            self.isPayCallBack = NO;
            self.OrderPayMethod = @"wxpayCompleteFunc";
            
            NSData *jsonData = [params[@"order"] dataUsingEncoding:NSUTF8StringEncoding];
            NSError *err;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
            [WXApiRequest jumpToWeiXinPayWithParam:dic fromVC:self];
        } else if ([method isEqualToString:@"alipay"]) { // 支付宝支付
            // 默认没支付回调
            self.isPayCallBack = NO;
            self.OrderPayMethod = @"alipayCompleteFunc";
            
            NSData *jsonData = [params[@"order"] dataUsingEncoding:NSUTF8StringEncoding];
            NSError *err;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
            [[AlipaySDK defaultService]payOrder:dic[@"sign_ali"] fromScheme:@"fuxingjiakao.com" callback:^(NSDictionary *resultDic) {
                NSLog(@"reslut = %@",resultDic);
            }];
        } else if ([method isEqualToString:@"changeNavBarType"]) {
            [self setNavBarItem:[params[@"type"] integerValue]];
        }
        
        if (completion && exec) {
            NSData * jsonData = [NSJSONSerialization dataWithJSONObject:exec options:0 error:nil];
            NSString * myString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSString *jsStr = [NSString stringWithFormat:@"%@('%@')", completion, myString];
            [self.wkWebView evaluateJavaScript:jsStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
                //                NSLog(@"jslog:%@\nerror:%@", result, error);
            }];
        }
    }
}

- (void)setNavBarItem:(NSInteger)type {
    
    switch (type) {
        case 0:
        {
            self.navigationItem.leftBarButtonItems = @[self.backItem, self.cancelItem];
        }
            break;
        case 1:
        {
            self.navigationItem.leftBarButtonItems = @[self.backItem];
        }
            break;
        case 2:
        {
            self.navigationItem.leftBarButtonItems = @[self.cancelItem];
        }
            break;
        default:
            break;
    }
}

/// 微信支付
- (void)weiXinPayNotifica:(NSNotification *)notification {
    self.isPayCallBack = YES;
    
    NSString *status;
    if ([notification.object boolValue]) {
        status = @"2";
    }
    else {
        status = @"1";
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@1 forKey:@"block_success"];
    [dic setObject:@{@"status" : status} forKey:@"data"];
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:nil];
    NSString * myString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *jsStr = [NSString stringWithFormat:@"%@('%@')", @"wxpayCompleteFunc", myString];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.wkWebView evaluateJavaScript:jsStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            NSLog(@"%@----%@",result, error);
            self.OrderPayMethod = nil;
        }];
    });
}

/// 支付宝支付
- (void)aliPayNotifica:(NSNotification *)notification {
    self.isPayCallBack = YES;
    
    NSString *status;
    if ([notification.object boolValue]) {
        status = @"2";
    }
    else {
        status = @"1";
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@1 forKey:@"block_success"];
    [dic setObject:@{@"status" : status} forKey:@"data"];
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:nil];
    NSString * myString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *jsStr = [NSString stringWithFormat:@"%@('%@')", @"alipayCompleteFunc", myString];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.wkWebView evaluateJavaScript:jsStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            self.OrderPayMethod = nil;
            NSLog(@"%@----%@",result, error);
        }];
    });
}

- (void)reentryProgramNoti:(NSNotification *)notification {
    
    if (self.OrderPayMethod == nil || [self.OrderPayMethod isEqualToString:@""]) {
        return;
    }
    if (!self.isPayCallBack) {  // 如果正在支付状态，又切换回到APP，切换未支付
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:@1 forKey:@"block_success"];
        [dic setObject:@{@"status" : @"0"} forKey:@"data"];
        NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:nil];
        NSString * myString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSString *jsStr = [NSString stringWithFormat:@"%@('%@')", self.OrderPayMethod, myString];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.wkWebView evaluateJavaScript:jsStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
                NSLog(@"%@----%@",result, error);
                self.OrderPayMethod = nil;
            }];
        });
    }
    else {
        // 如果支付已回调结果，支付操作状态恢复初始状态
        self.isPayCallBack = NO;
        self.OrderPayMethod = nil;
    }
}

#pragma mark - 打开相册
-(void)openAlbumAction {
    self.pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.pickerController.delegate = self;
    [self presentViewController:self.pickerController animated:YES completion:nil];
}

#pragma mark - 打开相机
-(void)openCameraAction {
    self.pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.pickerController.delegate = self;
    [self presentViewController:self.pickerController animated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    [self pickerCompleteActionWithImgUrl:@"" success:NO];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    UIImage *finishImage = info[UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    NSData *cardData = [UIImage getCompressedImage:finishImage];
    NSString *imageName = @"id_image_in_hand";
    NSDictionary *files = @{imageName: cardData};
    
    AliyunOSSNetwork *yun = [AliyunOSSNetwork new];
    // 组织当前登录用户信息
    NSString *rootFolder = @"user";
    NSString *phone = [[LicenseTool sharedInstance].userInfo[@"user_id"] stringValue];
    NSString *ts = [NSString stringWithFormat:@"%lld", (long long)[[NSDate date] timeIntervalSince1970]];
    NSString *photeType = [NSString stringWithFormat:@"idCard/%@", ts];
    NSString *folder = [NSString stringWithFormat:@"%@/%@/%@", rootFolder, phone, photeType];
    
    [yun uploadFiles:files foler:folder contentType:AliyunContentTypeData success:^(NSDictionary *response) {
        NSString *link = [[response allValues] objectAtIndex:0];
        [self pickerCompleteActionWithImgUrl:link success:YES];
        
    } fail:^(NSError *error) {
        [self pickerCompleteActionWithImgUrl:@"" success:NO];
    }];
}

- (void)pickerCompleteActionWithImgUrl:(NSString *)imageUrl success:(BOOL)isSuccess {
    
    NSInteger status = isSuccess ? 1 : 0;
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@(status) forKey:@"block_success"];
    [dic setObject:imageUrl forKey:@"image"];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:nil];
    NSString *mjString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *jsStr = [NSString stringWithFormat:@"%@('%@')", self.pickerOpenMethod, mjString];
    
    NSLog(@"dada = %@", jsStr);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.wkWebView evaluateJavaScript:jsStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            NSLog(@"%@----%@",result, error);
        }];
    });
}

//设置状态栏颜色
- (void)chooseShowMainColor:(NSString *)colorStr {
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = [UIColor colorWithHexString:colorStr];
    }
}

- (void)showMoreOrderTrainInfoWithUser:(NSDictionary *)userInfo fromVC:(UIViewController *)superVC {
    
    NSInteger type = [userInfo[@"copy"]integerValue];
    NSString *phone = @"";
    if (type == 1) {
        phone = [LicenseTool sharedInstance].userInfo[@"phone"];
    } else if (type == 2) {
        phone = userInfo[@"copy_text"];
    } else {
        return;
    }
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = phone;
    
    MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:superVC.view animated:YES];
    hub.mode = MBProgressHUDModeText;
    hub.label.text = @"手机号已复制，可快速粘贴";
    hub.label.textColor = [UIColor whiteColor];
    hub.backgroundColor = [UIColor clearColor];
    hub.label.font = [UIFont systemFontOfSize:16];
    hub.bezelView.backgroundColor = [UIColor colorWithHexString:@"#444444"];
    [hub hideAnimated:YES afterDelay:2];
}


#pragma mark - 相机权限设置
- (void)setCameraAuthorizationStatus {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"应用相机权限受限,请在设置中启用" message:nil preferredStyle:UIAlertControllerStyleAlert];
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
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:cancelAction];
    [alert addAction:actionSet];
    [self presentViewController:alert animated:true completion:nil];
}

#pragma mark - js
- (void)showNewOrderTrainAction:(NSDictionary *)pushDict {

    OrderTrainViewController *showVC = [OrderTrainViewController new];
    showVC.URLStr = pushDict[@"link"];
    showVC.showTitle = pushDict[@"showTitle"];
    showVC.navType = [pushDict objectForKey:@"nav_type"] ? [pushDict[@"nav_type"]integerValue] : 0;
    __weak typeof(self) weakSelf = self;
    showVC.sblock = ^(NSDictionary *data) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.wkWebView evaluateJavaScript:[NSString stringWithFormat:@"%@()", [LicenseTool sharedInstance].configInfo[@"filterKey"]] completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            //                NSLog(@"push:%@\nerror:%@", result, error);
        }];
    };
    [self.navigationController pushViewController:showVC animated:YES];
    
    if ([pushDict[@"copy"] integerValue] != 0) {
        [self showMoreOrderTrainInfoWithUser:pushDict fromVC:showVC];
    }
    
    
}

#pragma mark - public methods
- (void)showOrderTrainList:(NSDictionary *)pushDict {
    OrderTrainViewController *showVC = [OrderTrainViewController new];
    showVC.URLStr = pushDict[@"link"];
    showVC.showTitle = pushDict[@"showTitle"];
    __weak typeof(self) weakSelf = self;
    showVC.sblock = ^(NSDictionary *data) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.wkWebView evaluateJavaScript:[NSString stringWithFormat:@"%@()", [LicenseTool sharedInstance].configInfo[@"filterKey"]] completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            //                NSLog(@"push:%@\nerror:%@", result, error);
        }];
    };
    [self.navigationController pushViewController:showVC animated:YES];
}

- (void)backItemClickedAction:(id)sender {
    if (self.wkWebView.canGoBack) {
        [self.wkWebView goBack];
    }else{
        [self tapCancelItemAction:nil];
    }
}

- (void)tapCancelItemAction:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - properties
- (WKWebView *)wkWebView {
    if (_wkWebView == nil) {
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        WKPreferences *preferences = [WKPreferences new];
        preferences.javaScriptCanOpenWindowsAutomatically = YES;
        configuration.preferences = preferences;
        WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:configuration];
        webView.navigationDelegate = self;
        webView.scrollView.delegate = self;
        webView.UIDelegate = self;
        webView.scrollView.bounces = NO;
        _wkWebView = webView;
    }
    
    return _wkWebView;
}

- (UIImagePickerController *)pickerController {
    if (!_pickerController) {
        _pickerController = [[UIImagePickerController alloc]init];
        _pickerController.delegate = self;
    }
    return _pickerController;
}

- (UIBarButtonItem *)backItem {
    if (!_backItem) {
        _backItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back_btn"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backItemClickedAction:)];
        
        if (@available(iOS 11, *)) {
            [_backItem.customView.heightAnchor constraintEqualToConstant:30].active = YES;
            [_backItem.customView.widthAnchor constraintEqualToConstant:30].active = YES;
        }
    }
    return _backItem;
}

- (UIBarButtonItem *)cancelItem {
    if (!_cancelItem) {
        _cancelItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"close_btn1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(tapCancelItemAction:)];
        
        if (@available(iOS 11, *)) {
            [_cancelItem.customView.heightAnchor constraintEqualToConstant:26].active = YES;
            [_cancelItem.customView.widthAnchor constraintEqualToConstant:26].active = YES;
        }
    }
    return _cancelItem;
}

@end
