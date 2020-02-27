//
//  LFQuickBookViewController.h
//  快租
//
//  Created by 电信中国 on 2019/7/25.
//  Copyright © 2019年 LiuLinFei. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, TestSkillType) {
    TestSkillTypeCode,
    TestSkillTypeVoice
};

typedef void(^TestSkillSelectBlock)(void);

@interface TestSkillViewController : UIViewController

@property (nonatomic, strong) NSDictionary *testUserInfo;
@property (nonatomic, strong) NSString *trainID;
@property (strong, nonatomic) NSString *number;
@property (assign, nonatomic) TestSkillType smsType;
@property (nonatomic, copy) TestSkillSelectBlock testSkillSelectBlock;

- (void)testSkillSelectBlock:(TestSkillSelectBlock)block;

@end

NS_ASSUME_NONNULL_END
