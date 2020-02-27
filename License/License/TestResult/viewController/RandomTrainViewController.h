//
//  LFBookListViewController.h
//  快租
//
//  Created by 电信中国 on 2019/7/25.
//  Copyright © 2019年 LiuLinFei. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    TrainType_Single = 0,
    TrainType_More,
} TrainType;

@interface RandomTrainViewController : UIViewController

@property (nonatomic, strong) NSDictionary *testUserInfo;
@property (nonatomic, strong) NSString *trainID;
@property (strong, nonatomic) NSDictionary *configs;
@property (nonatomic, assign) TrainType type;


@end

NS_ASSUME_NONNULL_END
