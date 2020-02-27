//
//  ApplyDetailView.h
//  License
//
//  Created by 电信中国 on 2019/9/3.
//  Copyright © 2019 wei. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ApplyDetailView : UIView

@end

@interface ApplyDetailView_One : UIView

@property (nonatomic, strong) NSDictionary *infoDic;

@end

@interface ApplyDetailView_Two : UIView

@property (nonatomic, strong) NSString *time;

@end

@interface ApplyDetailView_Three : UIView

/// 信息是否可编辑，YES可编辑，NO不可编辑
@property (nonatomic, assign) BOOL isEdit;

/// 姓名/手机号/身份证
@property (nonatomic, strong) NSString *info;

@end

@interface ApplyDetailView_Four : UIView

/// 是否正面认证成功
@property (nonatomic, assign) BOOL isFrontSuccess;
/// 是否反面认证成功
@property (nonatomic, assign) BOOL isBackSuccess;

@end

typedef void(^ApplePayBlock)(void);
@interface ApplyDetailView_Five : UIView

@property (nonatomic, copy) ApplePayBlock applePayBlock;
- (void)applePayBlock:(ApplePayBlock)block;

@end

@interface ApplyDetailView_Six : UIView

@property (nonatomic, strong) NSString *time;

@end

NS_ASSUME_NONNULL_END
