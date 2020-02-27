//
//  LFBookDetailViewController.h
//  快租
//
//  Created by 电信中国 on 2019/7/25.
//  Copyright © 2019年 LiuLinFei. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TrainRecordViewController : UIViewController

@property (nonatomic, strong) NSDictionary *testUserInfo;
@property (nonatomic, strong) NSString *trainID;
@property (strong, nonatomic) NSDictionary *config;

@end

NS_ASSUME_NONNULL_END
