//
//  BBWrongCell.h
//  License
//
//  Created by wei on 2019/7/23.
//  Copyright © 2019年 wei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WrongModel.h"
@interface BBWrongCell : UITableViewCell
@property (nonatomic,strong)UILabel*titelLb;
@property (nonatomic,strong)UILabel*subLb;
@property (nonatomic,strong)UILabel*wrongLb;
@property (nonatomic,strong)UIImageView*arrowView;
@property (nonatomic,strong)WrongModel*model;
@end
