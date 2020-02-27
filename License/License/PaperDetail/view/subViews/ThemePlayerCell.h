//
//  ThemePlayerCell.h
//  License
//
//  Created by wei on 2019/7/11.
//  Copyright © 2019年 wei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThemeItem.h"
@interface ThemePlayerCell : UITableViewCell
@property (nonatomic,strong)ThemeItem*model;
- (void)clear;
+ (CGFloat)cellHightWithModel:(ThemeItem*)model;
@end
