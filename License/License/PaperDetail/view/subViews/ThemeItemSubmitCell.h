//
//  ThemeItemSubmitCell.h
//  License
//
//  Created by wei on 2019/7/11.
//  Copyright © 2019年 wei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThemeItem.h"
@interface ThemeItemSubmitCell : UITableViewCell
@property (nonatomic,strong)ThemeItem*model;
@property (nonatomic,assign)BOOL canSubmitAnser;
@property (nonatomic,strong)RACSubject*valueSignal;
+ (CGFloat)cellHightWithModel:(ThemeItem*)model;
@end
