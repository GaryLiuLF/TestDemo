//
//  AliyunOSSNetwork.h
//  CashPocket
//
//  Created by ChenQiushi on 17/3/2.
//  Copyright © 2017年 Ge. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^AliyunResponseSuccess)(NSDictionary *response);
typedef void(^AliyunResponseFail)(NSError *error);

typedef NS_ENUM(NSUInteger, AliyunContentType) {
    AliyunContentTypeImage = 0,
    AliyunContentTypeData
};

@interface AliyunOSSNetwork : NSObject

/**
 上传到阿里云

 @param files Dic key 文件名，value 图片或者图片数据
 @param folder 文件目录
 以上传人脸照片为参考：
 NSString *rootFolder = @"kuaidai/user";
 NSString *phone = @"userid";
 NSString *ts = @"时间戳";
 NSString *photeType = [NSString stringWithFormat:@"face/%@", ts];
 NSString *folder = [NSString stringWithFormat:@"%@/%@/%@", rootFolder, phone, photeType];
 
 @param type AliyunContentType 图片或者图片数据
 @param success
 @param fail
 */
- (void)uploadFiles:(NSDictionary *)files foler:(NSString *)folder contentType:(AliyunContentType)type success:(AliyunResponseSuccess)success fail:(AliyunResponseFail)fail;

@end
