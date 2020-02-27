//
//  HotTitle2TableViewCell.h
//  License
//
//  Created by wei on 2019/7/17.
//  Copyright © 2019年 wei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HotDataMaker.h"
@interface HotTitle2TableViewCell : UITableViewCell
@property (nonatomic,strong)HotItem*item;
+ (CGFloat)cellHightWithItem:(HotItem*)item;
@end
