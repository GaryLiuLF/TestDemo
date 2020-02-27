//
//  HSDownloadManager.m
//  HSDownloadManagerExample
//
//  Created by hans on 15/8/4.
//  Copyright © 2015年 hans. All rights reserved.
//

// 缓存主目录
#define HSCachesDirectory [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"HSCache"]

// 保存文件名
#define HSFileName(url) [NSString stringWithFormat:@"%@.mp4",url.md5String]

// 文件的存放路径（caches）
#define HSFileFullpath(url) [HSCachesDirectory stringByAppendingPathComponent:HSFileName(url)]

// 文件的已下载长度
#define HSDownloadLength(url) [[[NSFileManager defaultManager] attributesOfItemAtPath:HSFileFullpath(url) error:nil][NSFileSize] integerValue]

// 存储文件总长度的文件路径（caches）
#define HSTotalLengthFullpath [HSCachesDirectory stringByAppendingPathComponent:@"totalLength.plist"]

#import "HSDownloadManager.h"
#import "NSString+Hash.h"

@interface HSDownloadManager()<NSCopying, NSURLSessionDelegate>

/** 保存所有任务(注：用下载地址md5后作为key) */
@property (nonatomic, strong) NSMutableDictionary *tasks;
/** 保存所有下载相关信息 */
@property (nonatomic, strong) NSMutableDictionary *sessionModels;
@end

@implementation HSDownloadManager

- (NSMutableDictionary *)tasks
{
    if (!_tasks) {
        _tasks = [NSMutableDictionary dictionary];
    }
    return _tasks;
}

- (NSMutableArray*)downloadsTasks{
    if(!_downloadsTasks){
        _downloadsTasks = [[NSMutableArray alloc] init];
    }
    return _downloadsTasks;
}

- (NSMutableDictionary *)sessionModels
{
    if (!_sessionModels) {
        _sessionModels = [NSMutableDictionary dictionary];
    }
    return _sessionModels;
}


static HSDownloadManager *_downloadManager;

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _downloadManager = [super allocWithZone:zone];
    });
    
    return _downloadManager;
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone
{
    return _downloadManager;
}

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _downloadManager = [[self alloc] init];
    });
    
    return _downloadManager;
}

/**
 *  创建缓存目录文件
 */
- (void)createCacheDirectory
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:HSCachesDirectory]) {
        [fileManager createDirectoryAtPath:HSCachesDirectory withIntermediateDirectories:YES attributes:nil error:NULL];
    }
}

/**
 *  开启任务下载资源
 */
- (void)downloadUrl:(NSString*)url;{
    //[self download:url progress:nil state:nil];
    if(self.pause) return;
    [self download:url progress:^(NSInteger receivedSize, NSInteger expectedSize, CGFloat progress) {
        
    } state:^(DownloadState state) {
        
    }];
}
- (void)download:(NSString *)url progress:(void (^)(NSInteger, NSInteger, CGFloat))progressBlock state:(void (^)(DownloadState))stateBlock
{
    if (!url) return;
    if ([self isCompletion:url]) {
        stateBlock(DownloadStateCompleted);
        return;
    }
    // 暂停
    if ([self.tasks valueForKey:HSFileName(url)]) {
        //存在下载任务则重新定义回调参数
        HSSessionModel *sessionModel = [self getSessionModel:[self getTask:url].taskIdentifier];
        sessionModel.url = url;
        sessionModel.progressBlock = progressBlock;
        sessionModel.stateBlock = stateBlock;
        [self.sessionModels setValue:sessionModel forKey:@([self getTask:url].taskIdentifier).stringValue];
        //[self checkTask];
        [self start:url];
        return;
    }
    // 创建缓存目录文件
    [self createCacheDirectory];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[[NSOperationQueue alloc] init]];
    // 创建流
    NSOutputStream *stream = [NSOutputStream outputStreamToFileAtPath:HSFileFullpath(url) append:YES];
    // 创建请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    // 设置请求头
    NSString *range = [NSString stringWithFormat:@"bytes=%zd-", HSDownloadLength(url)];
    [request setValue:range forHTTPHeaderField:@"Range"];
    // 创建一个Data任务
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request];
    NSUInteger taskIdentifier = arc4random() % ((arc4random() % 10000 + arc4random() % 10000));
    [task setValue:@(taskIdentifier) forKeyPath:@"taskIdentifier"];
    // 保存任务
    [self.tasks setValue:task forKey:HSFileName(url)];
    [self.downloadsTasks addObject:task];
    HSSessionModel *sessionModel = [[HSSessionModel alloc] init];
    sessionModel.url = url;
    sessionModel.progressBlock = progressBlock;
    sessionModel.stateBlock = stateBlock;
    sessionModel.stream = stream;
    [self.sessionModels setValue:sessionModel forKey:@(task.taskIdentifier).stringValue];
    [self start:url];
    //[self checkTask];
}
- (void)checkTask{
    if(self.pause==YES) return;
    BOOL can = YES;
    for(NSURLSessionDataTask *task in self.downloadsTasks){
        if(task.state == NSURLSessionTaskStateRunning){
            can = NO;
            return;
        }
    }
    if(can==YES){
        for(int i = 0;i<self.downloadsTasks.count;i++){
            NSURLSessionDataTask *task = self.downloadsTasks[i];
            if(task.state != NSURLSessionTaskStateCompleted ){
                [task resume];
                [self getSessionModel:task.taskIdentifier].stateBlock(DownloadStateStart);
                break;
            }
        }
    }
}

- (BOOL)handle:(NSString *)url
{
    NSURLSessionDataTask *task = [self getTask:url];
    if(!task){
        [self downloadUrl:url];
    }
    if (task.state == NSURLSessionTaskStateRunning) {
        [self pause:url];
        return NO;
    } else {
        [self start:url];
        return YES;
    }
}

/**
 *  开始下载
 */
- (void)start:(NSString *)url
{
    NSURLSessionDataTask *task = [self getTask:url];
    [task resume];
    [self getSessionModel:task.taskIdentifier].stateBlock(DownloadStateStart);
}

/**
 *  暂停下载
 */
- (void)pause:(NSString *)url
{
    NSURLSessionDataTask *task = [self getTask:url];
    if(!task) return;
    [task suspend];
    [self getSessionModel:task.taskIdentifier].stateBlock(DownloadStateSuspended);
}

/**
 *  根据url获得对应的下载任务
 */
- (NSURLSessionDataTask *)getTask:(NSString *)url
{
    return (NSURLSessionDataTask *)[self.tasks valueForKey:HSFileName(url)];
}
//是否在下载中
- (BOOL)isDownLoading;{
    if(self.tasks.allKeys.count>0){
        return YES;
    }else{
        return NO;
    }
}
- (void)allPause;{
    self.pause = YES;
    for(int i=0;i<self.downloadsTasks.count;i++){
        NSURLSessionDataTask *task = self.downloadsTasks[i];
        if(task.state == NSURLSessionTaskStateRunning){
            [task suspend];
            //[self getSessionModel:task.taskIdentifier].stateBlock(DownloadStateStart);
        }
    }
}

/**
 *  根据url获取对应的下载信息模型
 */
- (HSSessionModel *)getSessionModel:(NSUInteger)taskIdentifier
{
    return (HSSessionModel *)[self.sessionModels valueForKey:@(taskIdentifier).stringValue];
}

/**
 *  判断该文件是否下载完成
 */
- (BOOL)isCompletion:(NSString *)url
{
    if (url.length>0 && [self fileTotalLength:url] && HSDownloadLength(url) == [self fileTotalLength:url]) {
        return YES;
    }
    return NO;
}

/**
 *  查询该资源的下载进度值
 */
- (CGFloat)progress:(NSString *)url
{
    return [self fileTotalLength:url] == 0 ? 0.0 : 1.0 * HSDownloadLength(url) /  [self fileTotalLength:url];
}

/**
 *  获取该资源总大小
 */
- (NSInteger)fileTotalLength:(NSString *)url
{
    return [[NSDictionary dictionaryWithContentsOfFile:HSTotalLengthFullpath][HSFileName(url)] integerValue];
}

#pragma mark - 删除
/**
 *  删除该资源
 */
- (void)deleteFile:(NSString *)url
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:HSFileFullpath(url)]) {

        // 删除沙盒中的资源
        [fileManager removeItemAtPath:HSFileFullpath(url) error:nil];
        // 删除任务
        [self.tasks removeObjectForKey:HSFileName(url)];
        [self.sessionModels removeObjectForKey:@([self getTask:url].taskIdentifier).stringValue];
        // 删除资源总长度
        if ([fileManager fileExistsAtPath:HSTotalLengthFullpath]) {
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:HSTotalLengthFullpath];
            [dict removeObjectForKey:HSFileName(url)];
            [dict writeToFile:HSTotalLengthFullpath atomically:YES];
        
        }
    }
}

/**
 *  清空所有下载资源
 */
- (void)deleteAllFile
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:HSCachesDirectory]) {
        // 删除沙盒中所有资源
        [fileManager removeItemAtPath:HSCachesDirectory error:nil];
        // 删除任务
        [[self.tasks allValues] makeObjectsPerformSelector:@selector(cancel)];
        [self.tasks removeAllObjects];
        
        for (HSSessionModel *sessionModel in [self.sessionModels allValues]) {
            [sessionModel.stream close];
        }
        [self.sessionModels removeAllObjects];
        
        // 删除资源总长度
        if([fileManager fileExistsAtPath:HSTotalLengthFullpath]) {
            [fileManager removeItemAtPath:HSTotalLengthFullpath error:nil];
        }
    }
}

#pragma mark - 代理
#pragma mark NSURLSessionDataDelegate
/**
 * 接收到响应
 */
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSHTTPURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    
    HSSessionModel *sessionModel = [self getSessionModel:dataTask.taskIdentifier];
    
    // 打开流
    [sessionModel.stream open];
    
    // 获得服务器这次请求 返回数据的总长度
    NSInteger totalLength = [response.allHeaderFields[@"Content-Length"] integerValue] + HSDownloadLength(sessionModel.url);
    sessionModel.totalLength = totalLength;
    
    // 存储总长度
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:HSTotalLengthFullpath];
    if (dict == nil) dict = [NSMutableDictionary dictionary];
    dict[HSFileName(sessionModel.url)] = @(totalLength);
    [dict writeToFile:HSTotalLengthFullpath atomically:YES];
    
    // 接收这个请求，允许接收服务器的数据
    completionHandler(NSURLSessionResponseAllow);
}

/**
 * 接收到服务器返回的数据
 */
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    HSSessionModel *sessionModel = [self getSessionModel:dataTask.taskIdentifier];
    
    // 写入数据
    [sessionModel.stream write:data.bytes maxLength:data.length];
    
    // 下载进度
    NSUInteger receivedSize = HSDownloadLength(sessionModel.url);
    NSUInteger expectedSize = sessionModel.totalLength;
    CGFloat progress = 1.0 * receivedSize / expectedSize;
    if(expectedSize>0 && progress<=1.0){
        if(self.backDelegate && [self.backDelegate respondsToSelector:@selector(downloadBack:andProgress:)]){
            [self.backDelegate downloadBack:sessionModel.url andProgress:progress];
        }
        sessionModel.progressBlock(receivedSize, expectedSize, progress);
    }
}

/**
 * 请求完毕（成功|失败）
 */
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    HSSessionModel *sessionModel = [self getSessionModel:task.taskIdentifier];
    if (!sessionModel) return;
    if(error.code==-1001){
        //请求超时
        return;
    }
    if ([self isCompletion:sessionModel.url]) {
        // 下载完成
        sessionModel.stateBlock(DownloadStateCompleted);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DownloadStateCompletedUrl" object:sessionModel.url];
        if(self.backDelegate && [self.backDelegate respondsToSelector:@selector(downloadBack:andProgress:)]){
            [self.backDelegate downloadBack:sessionModel.url andProgress:1.0];
        }
        // 关闭流
        [sessionModel.stream close];
        sessionModel.stream = nil;
        
        // 清除任务
        [self.tasks removeObjectForKey:HSFileName(sessionModel.url)];
        [self.sessionModels removeObjectForKey:@(task.taskIdentifier).stringValue];
        [self.downloadsTasks removeObject:task];
        //[self checkTask];
        if(self.backDelegate && [self.backDelegate respondsToSelector:@selector(downloadCheck)]){
            [self.backDelegate downloadCheck];
        }
    } else{
        // 下载失败
        if(self.backDelegate && [self.backDelegate respondsToSelector:@selector(downloadFailed:)]){
            [self.backDelegate downloadFailed:sessionModel.url];
        }
        sessionModel.stateBlock(DownloadStateFailed);
        // 关闭流
        [sessionModel.stream close];
        sessionModel.stream = nil;
        // 清除任务
        [self.tasks removeObjectForKey:HSFileName(sessionModel.url)];
        [self.sessionModels removeObjectForKey:@(task.taskIdentifier).stringValue];
        [self.downloadsTasks removeObject:task];
    }
    
    
}
- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(nullable NSError *)error;{
    NSLog(@" --- -- - -- - -cuowu ");
}

//获取文件路径
- (NSString *)getFilePath:(NSString *)url{
    return HSFileFullpath(url);
}

//获取当前url是否在下载中
- (BOOL)isDownLoading:(NSString *)url{
    NSURLSessionDataTask *task = [self getTask:url];
    if (task) {
        if (task.state == NSURLSessionTaskStateRunning) {
            return YES;
        }
    }
    return NO;
}
- (void)stopDownUrl:(NSString*)url;{
    NSURLSessionDataTask *task = [self getTask:url];
    for(int i=0;i<self.downloadsTasks.count;i++){
        NSURLSessionDataTask *newtask = self.downloadsTasks[i];
        if(newtask.taskIdentifier==task.taskIdentifier){
            [self.downloadsTasks removeObject:newtask];
            break;
        }
    }
    if(task){
        [task cancel];
    }
}

//暂停当前url的下载进程
- (BOOL)pauseMediaUrl:(NSString *)url{
    NSURLSessionDataTask *task = [self getTask:url];
    if (task) {
        [task suspend];
        return YES;
    }
    return NO;
}
@end
