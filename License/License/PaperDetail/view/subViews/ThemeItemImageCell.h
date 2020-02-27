//
//  ThemeItemImageCell.h
//  License
//
//  Created by wei on 2019/7/11.
//  Copyright © 2019年 wei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThemeItem.h"
@interface ThemeItemImageCell : UITableViewCell
@property (nonatomic,strong)RACSubject*valueSignal;
@property (nonatomic,strong)ThemeItem*model;
+ (CGFloat)cellHightWithModel:(ThemeItem*)model;
@end
