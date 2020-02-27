//
//  ProtocolRemindView.h
//  License
//
//  Created by 电信中国 on 2019/10/18.
//  Copyright © 2019 wei. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ShowMoreBlock)(void);

@interface ProtocolRemindView : UIView

@property (nonatomic, strong) NSDictionary *infoDic;
@property (nonatomic, assign) BOOL isApplied;
@property (nonatomic, copy) ShowMoreBlock showMoreBlock;
- (instancetype)initWithFrame:(CGRect)frame fromVC:(UIViewController *)vc;
- (void)showMoreBlock:(ShowMoreBlock)block;

@end

NS_ASSUME_NONNULL_END
