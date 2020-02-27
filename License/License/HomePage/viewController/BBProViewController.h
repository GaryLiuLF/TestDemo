//
//  BBProViewController.h
//  License
//
//  Created by wei on 2019/7/15.
//  Copyright © 2019年 wei. All rights reserved.
//

#import "BasicViewController.h"
@class BBProModel;
@interface BBProViewController : BasicViewController

@property (nonatomic,strong)RACSubject*valueSiganl;

@end

@interface BBProCell :UITableViewCell
@property (nonatomic,strong)BBProModel*model;
+ (CGFloat)cellHightWithModel:(BBProModel*)model;
@end

@interface BBProModel :NSObject

@property (nonatomic,assign)NSInteger number;
@property (nonatomic,strong)NSString* name;
@property (nonatomic,strong)NSString* content;
@end

