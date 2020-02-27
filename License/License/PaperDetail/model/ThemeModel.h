//
//  ThemeModel.h
//  License
//
//  Created by wei on 2019/7/11.
//  Copyright © 2019年 wei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AlongModel.h"
@interface ThemeModel : NSObject
//所在数据库中ID，只是序号
@property (nonatomic,assign)NSInteger ID;
//问题ID，全库唯一
@property (nonatomic,assign)NSInteger questionID;
//问题
@property (nonatomic,strong)NSString*question;
//类型，1，判断题 2 单选  3 多选
@property (nonatomic,assign)NSInteger questionType;
//答案A
@property (nonatomic,strong)NSString*optionA;
//答案B
@property (nonatomic,strong)NSString*optionB;
//答案C
@property (nonatomic,strong)NSString*optionC;
//答案D
@property (nonatomic,strong)NSString*optionD;
//正确答案
@property (nonatomic,strong)NSString*key;
//资源图片
@property (nonatomic,strong)NSString*imageURL;
//解释
@property (nonatomic,strong)NSString*explains;
//小车、货车、客车、摩托车
@property (nonatomic,strong)NSString*licenseType;
//科一、科四
@property (nonatomic,strong)NSString*subjectType;

//随机ID
@property (nonatomic,assign)NSInteger ID_random;
@property (nonatomic,strong)AlongModel*value_id;
@property (nonatomic,strong)AlongModel*value_id2;
@property (nonatomic,strong)AlongModel*value_check;
@property (nonatomic,strong)AlongModel*value_image;
@property (nonatomic,strong)AlongModel*value_text;
@property (nonatomic,strong)AlongModel*value_vedio;
@property (nonatomic,strong)AlongModel*value_sigle;
@property (nonatomic,strong)AlongModel*value_mul;
@property (nonatomic,assign)NSInteger isAnser;
@end
