//
//  BBInstructionsViewController.h
//  License
//
//  Created by wei on 2019/7/22.
//  Copyright © 2019年 wei. All rights reserved.
//

#import "BasicViewController.h"
#import "HotDataMaker.h"
@interface BBInstructionsViewController : BasicViewController

@end


@interface BBInstructionsCell : UITableViewCell
@property (nonatomic,strong)UILabel*titellb;
@property (nonatomic,strong)UIView*pointV;
@property (nonatomic,strong)NSString*content;
+ (CGFloat)cellHightWithString:(NSString*)item;
@end

