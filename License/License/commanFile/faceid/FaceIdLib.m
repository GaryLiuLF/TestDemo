//
//  NZFaceIdLib.m
//  SANNIN
//
//  Created by ChenQiushi on 2019/6/11.
//

#import "FaceIdLib.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <MGIDCard/MGIDCard.h>
#import <MGLivenessDetection/MGLivenessDetection.h>
#import "AliyunOSSNetwork.h"
#import "LicenseTool.h"


@implementation FaceIdLib

- (void)detectIdCardPage:(NSInteger)isGuoHui fromVC:(UIViewController *)vc completion:(void(^)(BOOL success, NSDictionary *data))completion {
    if (![MGLicenseManager getLicense]) {
        [MGLicenseManager licenseForNetWokrFinish:^(bool License) {
            NSLog(@"%@", [NSString stringWithFormat:@"授权%@", License ? @"成功" : @"失败"]);
        }];
    }
    [MBProgressHUD showHUDAddedTo:vc.view animated:YES];
    MGIDCardManager *cardManager = [[MGIDCardManager alloc] init];
    [cardManager setScreenOrientation:MGIDCardScreenOrientationPortrait];
    [cardManager IDCardStartDetection:vc
                           IdCardSide:isGuoHui
                               finish:^(MGIDCardModel *model) {
                                   UIImage *modalImage = [model croppedImageOfIDCard];
                                   NSData *cardData = UIImageJPEGRepresentation(modalImage, 1.0);
                                   NSString *imageName = isGuoHui ? @"idCard_back" : @"idCard";
                                   AliyunOSSNetwork *yun = [AliyunOSSNetwork new];
                                   NSDictionary *files = @{imageName: cardData};

                                   // 组织当前登录用户信息
                                   NSString *rootFolder = @"user";
                                   NSString *phone = [[LicenseTool sharedInstance].userInfo[@"user_id"] stringValue];
                                   NSString *ts = [NSString stringWithFormat:@"%lld", (long long)[[NSDate date] timeIntervalSince1970]];
                                   NSString *photeType = [NSString stringWithFormat:@"idCard/%@", ts];
                                   NSString *folder = [NSString stringWithFormat:@"%@/%@/%@", rootFolder, phone, photeType];

                                   [yun uploadFiles:files foler:folder contentType:AliyunContentTypeData success:^(NSDictionary *response) {
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           [MBProgressHUD hideHUDForView:vc.view animated:YES];
                                       });

                                       if (completion) {
                                           completion(YES, response);
                                       }

                                   } fail:^(NSError *error) {
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           [MBProgressHUD hideHUDForView:vc.view animated:YES];
                                       });
                                       if (completion) {
                                           completion(NO, @{});
                                       }
                                   }];

                               }
//    {
//                                   UIImage *image = [model croppedImageOfIDCard];
//                                   NSData *imgData = UIImageJPEGRepresentation(image, 1.0f);
//                                   NSString *encodedImageStr = [imgData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
//                                   if (completion) {
//                                       completion(YES, @{@"image": [NSString stringWithFormat:@"data:image/png;base64,%@", encodedImageStr]});
//                                   }
////                                   weakSelf.cardView.image = [model croppedImageOfIDCard];
//                               }
                                 errr:^(MGIDCardError errorType) {
                                     dispatch_async(dispatch_get_main_queue(), ^{
                                         [MBProgressHUD hideHUDForView:vc.view animated:YES];
                                     });
                                     
                                     if (completion) {
                                         completion(NO, @{});
                                     }
                                 }];
}

- (void)detectLiveFromVC:(UIViewController *)vc completion:(void(^)(bool success, NSDictionary *data))completion {
    if (![MGLicenseManager getLicense]) {
        [MGLicenseManager licenseForNetWokrFinish:^(bool License) {
            NSLog(@"%@", [NSString stringWithFormat:@"授权%@", License ? @"成功" : @"失败"]);
        }];
    }
    MGLiveManager *liveManager = [[MGLiveManager alloc] init];
    [liveManager startFaceDecetionViewController:vc
                                          finish:^(FaceIDData *finishDic, UIViewController *viewController) {
                                              
                                              [viewController dismissViewControllerAnimated:YES completion:nil];
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  [MBProgressHUD showHUDAddedTo:vc.view animated:YES];
                                              });
                                              
                                              NSString *delta = finishDic.delta;
                                              NSDictionary *images = finishDic.images;
                                              AliyunOSSNetwork *yun = [AliyunOSSNetwork new];
                                              // 组织当前登录用户信息
                                              NSString *rootFolder = @"user";
                                              NSString *phone = [[LicenseTool sharedInstance].userInfo[@"user_id"] stringValue];
                                              NSString *ts = [NSString stringWithFormat:@"%lld", (long long)[[NSDate date] timeIntervalSince1970]];
                                              NSString *photeType = [NSString stringWithFormat:@"face/%@", ts];
                                              NSString *folder = [NSString stringWithFormat:@"%@/%@/%@", rootFolder, phone, photeType];
                                              NSMutableDictionary *muteD = [NSMutableDictionary new];
                                              [muteD setObject:delta forKey:@"delta"];
                                              [yun uploadFiles:images foler:folder contentType:AliyunContentTypeData success:^(NSDictionary *response) {
                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                      [MBProgressHUD hideHUDForView:vc.view animated:YES];
                                                  });
                                                  NSLog(@"face link:%@", response);
                                                  [muteD setValuesForKeysWithDictionary:response];
                                                  // 把所有的 key : value 和 delta 上传到服务器
                                                  // 上传成功
                                                  if (completion) {
                                                      completion(YES, muteD);
                                                  }
                                                  // 上传失败
                                              } fail:^(NSError *error) {
                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                      [MBProgressHUD hideHUDForView:vc.view animated:YES];
                                                  });
                                                  if (completion) {
                                                      completion(NO, @{});
                                                  }
                                              }];
                                              
                                              
     
//                                              [self.resultImageV setImage:resultImage];
//                                              [self.messageLabel setText:[NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"key_action_live_detect", nil), NSLocalizedString(@"title_success", nil)]];
//                                              [self.messageLabel setTextColor:[UIColor blueColor]];
                                          }
                                           error:^(MGLivenessDetectionFailedType errorType, UIViewController *viewController) {
                                               [viewController dismissViewControllerAnimated:YES completion:nil];
                                               if (completion) {
                                                   completion(NO, @{});
                                               }
                                           }];
}

@end
