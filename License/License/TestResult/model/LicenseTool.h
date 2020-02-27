//
//  LFHouseUserManager.h
//  快租
//
//  Created by 电信中国 on 2019/7/25.
//  Copyright © 2019年 LiuLinFei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LicenseTool : NSObject

+ (instancetype)sharedInstance;


@property (strong, nonatomic) NSDictionary *licenseUserInfo;
@property (nonatomic, strong) NSString *userID;
@property (strong, nonatomic) NSMutableDictionary *userInfo;
@property (strong, nonatomic) NSString *cookieString;
@property (strong, nonatomic) NSMutableDictionary *configInfo;

- (NSDictionary *)getLicenseUserInfo;
- (void)showAllLicense:(NSArray *)expose;
- (void)getLicenseCount:(NSDictionary *)params;
- (void)refreshLicenseTrainResult:(NSDictionary *)params;
- (NSString *)setLicenseFlag:(NSDictionary *)params;


@end

NS_ASSUME_NONNULL_END
