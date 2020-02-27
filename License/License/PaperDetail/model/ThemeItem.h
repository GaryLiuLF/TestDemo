//
//  ThemeItem.h
//  License
//
//  Created by wei on 2019/7/11.
//  Copyright © 2019年 wei. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger,ThemeItemType){
    ThemeItemTitle,
    ThemeItemplayer,
    ThemeItemImage,
    ThemeItemAnserOption,
    ThemeItemSubmit,
    ThemeItemAnser,
    ThemeItemExplains
};
typedef NS_ENUM(NSInteger,ThemeItemStateType){
    ThemeItemStateNone = 1,//正常可选状态
    ThemeItemStateError = 2,//直接选错，标记红色
    ThemeItemStateCorrect = 3,//直接选对，标记蓝色
    ThemeItemStatelouxuan = 4,//是答案未选 普通绿色 系统
    ThemeItemStateNoAnser = 5 //不是答案，并未选择  系统
};

struct ThemeItemStateTypeS {
    ThemeItemStateType A;
    ThemeItemStateType B;
    ThemeItemStateType C;
    ThemeItemStateType D;
};
typedef struct ThemeItemStateTypeS ThemeItemStateTypeS;

typedef NS_ENUM(NSInteger,ThemeItemAnserType){
    ThemeItemAnserA,
    ThemeItemAnserB,
    ThemeItemAnserC,
    ThemeItemAnserD,
    ThemeItemAnserNone
};
typedef NS_ENUM(NSInteger,ThemeItemOptionType){
    ThemeItemOptionNone = 0,
    ThemeItemOptionCheck = 1,
    ThemeItemOptionSigle = 2,
    ThemeItemOptionMulti = 3
    
};
@interface ThemeItem : NSObject
@property (nonatomic,assign)ThemeItemType type;
//@property (nonatomic,assign)BOOL isShow;
//具体值
@property (nonatomic,strong)NSString*value;

//标题部分使用
@property (nonatomic,assign)ThemeItemOptionType optionType;
//选项部分使用
@property (nonatomic,assign)ThemeItemStateType stateType;

@property (nonatomic,assign)ThemeItemAnserType anserType;

@property (nonatomic,assign)BOOL showed;
@end
