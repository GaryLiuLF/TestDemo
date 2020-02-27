//
//  LFLaunchImageViewController.h
//  快租
//
//  Created by 电信中国 on 2019/7/25.
//  Copyright © 2019年 LiuLinFei. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TestResultViewController : UIViewController

@property (nonatomic, strong) NSDictionary *testInfo;
- (void)initWithFrame:(CGRect)frame type:(NSInteger)type;

@end

NS_ASSUME_NONNULL_END
