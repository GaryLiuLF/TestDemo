//
//  CommandManager.h
//  BeibeiMusic
//
//  Created by wei on 2019/7/7.
//  Copyright © 2019年 wei. All rights reserved.
//

#import <Foundation/Foundation.h>

#define BBCanPush @"BBCanPush"
#define BBCanStepWhenAnsered @"BBCanStepWhenAnsered"

@interface CommandManager : NSObject
@property (nonatomic,strong)NSMutableDictionary*totolImageSizeDictionary;
@property (nonatomic,assign)BOOL isIphoneX;
@property (nonatomic,assign)int carType;// 1 2 3 4
@property (nonatomic,assign)int subType;// 1 2
@property (nonatomic,assign)int proid;// 1 2

@property (nonatomic,assign)BOOL canPush;
@property (nonatomic,assign)BOOL canStep;
+ (instancetype)sharedManager;
+ (void)save:(id)obj key:(NSString*)key;
+ (id)getValue:(NSString*)key;
+ (int)getMoniId;

//存储和获取图片高度
- (void)setImageUrl:(NSString*)imageUrl andValue:(NSNumber*)value;
- (float)getImageHeightWithUrl:(NSString*)imageUrl;
- (NSString*)tableName;
+ (id)json_objetWith:(id)value;
+ (NSString*)json_stringWithValue:(id)value;


@end


