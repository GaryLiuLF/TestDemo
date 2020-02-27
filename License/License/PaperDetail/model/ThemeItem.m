//
//  ThemeItem.m
//  License
//
//  Created by wei on 2019/7/11.
//  Copyright © 2019年 wei. All rights reserved.
//

#import "ThemeItem.h"
@implementation ThemeItem
/*
 类型+标题cell
 图片
 选项
 提交按钮
 本题答案
 本体解析
 */

CG_INLINE ThemeItemStateTypeS
StateTypeSMake(ThemeItemStateType A, ThemeItemStateType B, ThemeItemStateType C, ThemeItemStateType D)
{
    ThemeItemStateTypeS stateTypeS;
    stateTypeS.A = A;
    stateTypeS.B = B;
    stateTypeS.C = C;
    stateTypeS.D = D;
    return stateTypeS;
};


@end
