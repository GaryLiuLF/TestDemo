//
//  BBSetCell.h
//  License
//
//  Created by wei on 2019/7/23.
//  Copyright © 2019年 wei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBSetModel.h"
@interface BBSetCell : UITableViewCell
@property (nonatomic,strong)UIImageView*iconView;
@property (nonatomic,strong)UILabel*textLb;
@property (nonatomic,strong)UISwitch*switchView;
@property (nonatomic,strong)UIImageView*arrowView;

@property (nonatomic,strong)RACSubject*valueSignal;
@property (nonatomic,strong)BBSetModel*model;
@end
