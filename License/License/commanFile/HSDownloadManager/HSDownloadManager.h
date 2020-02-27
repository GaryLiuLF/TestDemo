//
//  HSDownloadManager.h
//  HSDownloadManagerExample
//
//  Created by hans on 15/8/4.
//  Copyright © 2015年 hans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSSessionModel.h"

@protocol HSDownloadManagerDelegate <NSObject>
- (void)downloadBack:(NSString*)url andProgress:(CGFloat)progress;
- (void)downloadFailed:(NSString*)url;
- (void)downloadCheck;
@end

@interface HSDownloadManager : NSObject
@property (nonatomic,assign)id<HSDownloadManagerDelegate>backDelegate;
@property (nonatomic,strong)NSMutableArray*downloadsTasks;
@property (nonatomic,assign)BOOL pause;
@property (nonatomic,assign)BOOL lastDownIsOffline;

/**
 *  单例
 *
 *  @return 返回单例对象
 */
+ (instancetype)sharedInstance;
- (void)downloadUrl:(NSString*)url;
- (BOOL)handle:(NSString *)url;

/**
 *  开启任务下载资源
 *
 *  @param url           下载地址
 *  @param progressBlock 回调下载进度
 *  @param stateBlock    下载状态
 */
- (void)download:(NSString *)url progress:(void(^)(NSInteger receivedSize, NSInteger expectedSize, CGFloat progress))progressBlock state:(void(^)(DownloadState state))stateBlock;
/**
 *  查询该资源的下载进度值
 *
 *  @param url 下载地址
 *
 *  @return 返回下载进度值
 */
- (CGFloat)progress:(NSString *)url;
/**
 *  获取该资源总大小
 *
 *  @param url 下载地址
 *
 *  @return 资源总大小
 */
- (NSInteger)fileTotalLength:(NSString *)url;
/**
 *  判断该资源是否下载完成
 *
 *  @param url 下载地址
 *
 *  @return YES: 完成
 */
- (BOOL)isCompletion:(NSString *)url;
/**
 *  删除该资源
 *
 *  @param url 下载地址
 */
- (void)deleteFile:(NSString *)url;
/**
 *  清空所有下载资源
 */

//是否在下载中
- (BOOL)isDownLoading;
//全部暂停
- (void)allPause;

- (void)deleteAllFile;
//获取文件路径
- (NSString *)getFilePath:(NSString *)url;
- (BOOL)pauseMediaUrl:(NSString *)url;
//获取当前url是否在下载中
- (BOOL)isDownLoading:(NSString *)url;
- (void)stopDownUrl:(NSString*)url;
@end
