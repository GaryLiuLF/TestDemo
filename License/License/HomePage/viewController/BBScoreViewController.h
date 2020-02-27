//
//  BBScoreViewController.h
//  License
//
//  Created by wei on 2019/7/22.
//  Copyright © 2019年 wei. All rights reserved.
//

#import "BasicViewController.h"

@interface BBScoreViewController : BasicViewController

@end


@interface BBScoreCell : UITableViewCell
@property (nonatomic,strong)UILabel*titelLb;
@property (nonatomic,strong)UILabel*useTimeLb;
@property (nonatomic,strong)UILabel*timeLb;
@property (nonatomic,strong)UIImageView*arrowView;
@property (nonatomic,strong)NSDictionary*dictionary;
@end

