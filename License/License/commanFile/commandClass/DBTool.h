//
//  DBTool.h
//  License
//
//  Created by wei on 2019/7/11.
//  Copyright © 2019年 wei. All rights reserved.
//

// 转移数据库到沙盒
// 在数据库中添加基础字段
// 导出数据库
// 再转移


#import <Foundation/Foundation.h>
#import "ThemeModel.h"
#define ktype0ke1 @"ktype0ke1" //科一 小车
#define ktype1ke1 @"ktype1ke1" //科一 货车
#define ktype2ke1 @"ktype2ke1" //科一 客车
#define ktype3ke1 @"ktype3ke1" //科一 摩托
#define ktype0ke2 @"ktype0ke2" //科二 小车
#define ktype1ke2 @"ktype1ke2" //科二 货车
#define ktype2ke2 @"ktype2ke2" //科二 客车
#define ktype3ke2 @"ktype3ke2" //科二 摩托

#define kMoniList @"kMoniList" //模拟数据库
#define kMoniReslut @"kMoniReslut" //模拟结果表

typedef NS_ENUM(NSInteger,KValueListType) {
    KValue_id,//顺序
    value_id2,//随机
    value_check,//判断
    value_image,//图片
    value_text,//文字
    value_vedio,//动画
    value_sigle,//单选
    value_mul,//多选
    value_moni,//真题模拟
    value_none//未知
};

@interface DBTool : NSObject

+ (instancetype)sharedDB;

- (void)refreshUserDB;//每次都只负责2个，科一科四
- (NSMutableArray<ThemeModel*>*)getDataWithCarType:(NSString*)carType andValueType:(KValueListType)valueType onlyWrong:(BOOL)isWrong;
- (NSRange)getRightAndWrongNumberWithCarType:(NSString*)carType andValueType:(KValueListType)valueType;
- (NSArray*)getSunxuDatasWithSubType:(int)subtype;
- (void)updateWithCarType:(NSString*)carType andValueType:(KValueListType)valueType andModel:(ThemeModel*)model;
- (NSArray*)getSpecialDatas;//获取专项部分的数据


//模拟题部分数据操作
- (NSMutableArray<ThemeModel*>*)getMoniThemesWithCarType:(int)carType subType:(int)subType moniId:(int)moniId;
- (NSArray*)getMoniRightAndWrongNumberWithMoniId:(int)moniId;
//保存结果
- (void)updateWithModelInfo:(ThemeModel*)currentModel;
- (void)updateWithID:(int)ID right:(int)right wrong:(int)wrong;
- (void)updateMoniReslutCompleteWithID:(int)ID;
- (void)updateWithID:(int)ID useTime:(int)time;
- (NSMutableDictionary*)getMoniInfoWithSubType;
- (NSArray*)getScoreInfo;


- (NSMutableArray*)nomalWrong;
- (NSMutableArray<ThemeModel*>*)getMoniTWrongWithmoniId:(int)moniId;

+ (BOOL)moveDBToCache;
@end














