//
//  LFGetHouseInfo.h
//  快租
//
//  Created by 电信中国 on 2019/7/25.
//  Copyright © 2019年 LiuLinFei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, SelectType) {
    SelectTypeMain,
    SelectTypeOrder,
    SelectTypeRandom,
};

@interface SelectTrainType : NSObject

@property (nonatomic, assign) SelectType selectType;

- (void)getTrainSkillList;
- (void)showOrderTrainView;
- (void)showRandomTrainView;
- (void)showTestResultView;
- (void)showRandomTrainView_showBack;

@end

NS_ASSUME_NONNULL_END
