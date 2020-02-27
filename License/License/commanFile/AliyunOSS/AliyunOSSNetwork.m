//
//  AliyunOSSNetwork.m
//  CashPocket
//
//  Created by ChenQiushi on 17/3/2.
//  Copyright © 2017年 Ge. All rights reserved.
//

#import "AliyunOSSNetwork.h"
#import <AliyunOSSiOS/OSSService.h>
#import "LicenseTool.h"

//https://platplat.oss-cn-shanghai.aliyuncs.com/user/1000150/1539330321/id_image_back.jpeg
static NSString * const kBucketName = @"platplat";
static NSString * const kEndPoint = @"https://oss-cn-shanghai.aliyuncs.com";
static NSString * const kURLPre = @"https://platplat.oss-cn-shanghai.aliyuncs.com";


@interface AliyunOSSNetwork()

@property(strong, nonatomic) OSSClient *client;

@end

@implementation AliyunOSSNetwork

- (void)uploadFiles:(NSDictionary *)files foler:(NSString *)folder contentType:(AliyunContentType)type success:(AliyunResponseSuccess)success fail:(AliyunResponseFail)fail {
    if (!files.count) {
        return;
    }
    // 签名
    id<OSSCredentialProvider> credential = [[OSSCustomSignerCredentialProvider alloc] initWithImplementedSigner:^NSString *(NSString *contentToSign, NSError *__autoreleasing *error) {
        NSString * kSignURL = [NSString stringWithFormat:@"%@/config/osssign", [LicenseTool sharedInstance].configInfo[@"host"]]
        ;
        NSURL *url = [NSURL URLWithString:kSignURL];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
        [request setHTTPMethod:@"POST"];
        
        request.HTTPBody = [contentToSign dataUsingEncoding:NSUTF8StringEncoding];
        [request setValue:@"text/plain" forHTTPHeaderField:@"Content-Type"];
        
        __block NSString *str1;
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        NSURLSession *session = [NSURLSession sharedSession];
        [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            // handle response
            dispatch_semaphore_signal(semaphore);
            str1 = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"s:%@", str1);
        }] resume];
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        
//        NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//        NSString *str1 = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
        NSLog(@"sign:%@",str1);

        return str1;
    }];
    
    _client = [[OSSClient alloc] initWithEndpoint:kEndPoint credentialProvider:credential];
    NSMutableDictionary *fileLinks = [NSMutableDictionary dictionaryWithCapacity:files.count];
    NSError *aliError = nil;
    for (NSString *key in files) {
        OSSPutObjectRequest * put = [OSSPutObjectRequest new];
        // 必填字段
        put.bucketName = kBucketName;
        NSString *folderPath = [NSString stringWithFormat:@"%@/%@.jpeg", folder, key];
        put.objectKey = folderPath;
        id file = files[key];
        
        if (type == AliyunContentTypeImage) {
            put.uploadingFileURL = [NSURL fileURLWithPath:file];
        } else if (type == AliyunContentTypeData) {
            put.uploadingData = file;
        }
        
        // 统一为 jpeg 格式
        put.contentType = @"image/jpeg";
        OSSTask * putTask = [_client putObject:put];
        
        [putTask waitUntilFinished]; // 阻塞直到上传完成
        
        if (!putTask.error) {
            NSString *link = [NSString stringWithFormat:@"%@/%@", kURLPre, put.objectKey];
            [fileLinks setValue:link forKey:key];
//            IQLog(@"link:%@", link);
        } else {
            aliError = putTask.error;
            NSLog(@"upload object failed, error: %@" , putTask.error);
        }
    }
    
    if (fileLinks.count) {
        success(fileLinks);
    } else {
        fail(aliError);
    }
    
}

@end
