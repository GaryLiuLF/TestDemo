//
//  LFHouseUserManager.m
//  快租
//
//  Created by 电信中国 on 2019/7/25.
//  Copyright © 2019年 LiuLinFei. All rights reserved.
//

#import "LicenseTool.h"

#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

NSString *const kMP_AppAppstartKey = @"kMP_AppAppstartKey";

@implementation LicenseTool

static LicenseTool *_sharedInstance = nil;

#pragma mark - life cycle
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [self sharedInstance];
}

- (id)copyWithZone:(NSZone *)zone {
    return _sharedInstance;
}

#pragma mark - delegate


#pragma mark - event


#pragma mark - public methods
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[super allocWithZone:NULL] init];
    });
    return _sharedInstance;
}

- (NSDictionary *)updateUserInfo:(NSDictionary *)info {
    return @{};
}

- (NSDictionary *)getLicenseUserInfo {
    NSDictionary *dic = @{};
    return dic;
}

- (void)showAllLicense:(NSArray *)expose {
//    NSArray *allCookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:self.configInfo[@"host"]]];
    NSArray *allCookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    NSMutableArray *muteArray = [NSMutableArray new];
    for (NSHTTPCookie *httpCookie in allCookies) {
        NSString *cookieName = httpCookie.name;
        if ([cookieName length]) {
            NSDictionary *propertyDic = [NSDictionary dictionaryWithDictionary:httpCookie.properties];
            [muteArray addObject:propertyDic];
        }
    }
    [[NSUserDefaults standardUserDefaults] setValue:[muteArray copy] forKey:self.configInfo[@"cookieName"]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)getLicenseCount:(NSDictionary *)params {
    NSString *str = params[@"cookies"];
    if ([str isKindOfClass:[NSString class]] && str.length) {
        [[NSUserDefaults standardUserDefaults] setValue:str forKey:[LicenseTool sharedInstance].configInfo[@"h5CookieName"]];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

#pragma mark - private methods
- (NSString *)setLicenseFlag:(NSDictionary *)params {
    NSMutableString *content = [NSMutableString new];
    NSArray *keys = [params allKeys];
    NSArray *sortedArray = [keys sortedArrayUsingSelector:@selector(compare:)];
    [sortedArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [content appendString:[NSString stringWithFormat:@"%@%@", obj, params[obj]]];
    }];
    [content appendString:[self checkLicenseUserInfo:[NSBundle mainBundle].bundleIdentifier]];
    return [NSString stringWithFormat:@"%@:%@:%@", [NSBundle mainBundle].bundleIdentifier, self.configInfo[@"channel"], [self checkLicenseUserInfo:content]];
}

- (NSString *)checkLicenseUserInfo:(NSString *)str {
    const char* input = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);
    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [digest appendFormat:@"%02x", result[i]];
    }
    return digest;
}

- (NSData *)changeLicenseType:(NSString *)key data:(NSData *)data {
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCBlockSizeAES128,
                                          NULL,
                                          [data bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesDecrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];

    }
    free(buffer);
    return nil;
}

- (NSString *)iqaes256_decrypt:(NSString *)key string:(NSString *)str {
    NSMutableData *data = [NSMutableData dataWithCapacity:str.length / 2];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    int i;
    for (i=0; i < [str length] / 2; i++) {
        byte_chars[0] = [str characterAtIndex:i*2];
        byte_chars[1] = [str characterAtIndex:i*2+1];
        whole_byte = strtol(byte_chars, NULL, 16);
        [data appendBytes:&whole_byte length:1];
    }

    NSData* result = [self changeLicenseType:key data:data];
    if (result && result.length > 0) {
        NSString *t = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
        return t;
    }
    return nil;
}

#pragma mark - properties

- (NSMutableDictionary *)userInfo {
    if (!_userInfo) {
        _userInfo = [NSMutableDictionary new];
    }
    return _userInfo;
}

- (NSString *)cookieString {
    NSArray *cookies = [[NSUserDefaults standardUserDefaults] arrayForKey:self.configInfo[@"cookieName"]];
    if (cookies == nil || cookies.count == 0) {
        return @"";
    }
    NSMutableString *muteStr = [NSMutableString new];
    // 多cookie分割符
    NSString *splitStr = @"$_RP_Y_$";
    for (NSDictionary *cookDic in cookies) {
        NSString *k = cookDic[@"Name"];
        NSString *v = cookDic[@"Value"];
        [muteStr appendString:[NSString stringWithFormat:@"%@=%@;Path=/", k, v]];
        [muteStr appendString:splitStr];
    }
    NSString *retStr = [muteStr substringToIndex:([muteStr length] - [splitStr length])];

    // h5
    NSString *h5Cookie = [[NSUserDefaults standardUserDefaults] objectForKey:[LicenseTool sharedInstance].configInfo[@"h5CookieName"]];

    return h5Cookie ? h5Cookie : retStr;
}

- (void)refreshLicenseTrainResult:(NSDictionary *)params {
    //    [UMessage setAlias:params[@"dic"][@"number"] type:@"number" response:^(id  _Nullable responseObject, NSError * _Nullable error) {
    //
    //    }];
    [[LicenseTool sharedInstance].configInfo setValuesForKeysWithDictionary:params[@"dic"]];
    [[LicenseTool sharedInstance] showAllLicense:params[@"cookies"]];
}

//actionDownload
- (NSMutableDictionary *)configInfo {
    if (!_configInfo) {
        NSArray *filterArray = @[@"actionD", @"ownload"];
        NSDictionary *c = @{
                            @"host": @"https://api.celtgame.com",
                            @"themeColor": [UIColor colorWithHexString:@"FF9943"],
                            @"textUnColor": [UIColor colorWithHexString:@"989898"],
                            @"textColor": [UIColor colorWithHexString:@"989898"],
                            @"btnUnColor": [UIColor colorWithHexString:@"CCCCCC"],
                            @"channel": @"iOSJiaDao",
                            @"cookieName": @"kCookieName",
                            @"h5CookieName": @"kH5CookieName",
                            @"umengAppkey": @"5d71f2b33fc195314c000995",
                            @"appid": @"1474206982",
                            @"agreement": @"https://igstar.oss-cn-shanghai.aliyuncs.com/privacy/pri_guangjia.html",
                            @"event_key": [self iqaes256_decrypt:@"1234" string:@"a6fc1cb772b3b26484519e7bb1bf230b"],
                            @"filterKey": [filterArray componentsJoinedByString:@""]
                            };
        _configInfo = [NSMutableDictionary dictionaryWithDictionary:c];
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *cookies = [defaults objectForKey:_configInfo[@"cookieName"]];
    _configInfo[@"cookies"] = cookies;
    return _configInfo;
}

@end
