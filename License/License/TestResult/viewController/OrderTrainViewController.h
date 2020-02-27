//
//  LFBookHouseViewController.h
//  快租
//
//  Created by 电信中国 on 2019/7/25.
//  Copyright © 2019年 LiuLinFei. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^OrderTrainBlock)(void);

@interface OrderTrainViewController : UIViewController

@property (nonatomic, strong) NSDictionary *testUserInfo;
@property (strong, nonatomic) NSString *showTitle;
@property (strong, nonatomic) NSString *URLStr;

@property (nonatomic, assign) BOOL trainID;
@property (assign, nonatomic) BOOL hideNav;
@property (nonatomic, assign) NSInteger navType;

@property (nonatomic, copy) OrderTrainBlock orderTrainBlock;
@property (copy, nonatomic) void(^sblock)(NSDictionary *data);

- (void)orderTrainBlock:(OrderTrainBlock)block;
- (void)showOrderTrainList:(NSDictionary *)pushDict;

@end

NS_ASSUME_NONNULL_END
