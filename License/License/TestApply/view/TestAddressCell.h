//
//  TestAddressCell.h
//  License
//
//  Created by 电信中国 on 2019/9/3.
//  Copyright © 2019 wei. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^TestApplyBlock)(void);
@interface TestAddressCell : UITableViewCell

@property (nonatomic, copy) TestApplyBlock testApplyBlock;
@property (nonatomic, strong) NSDictionary *infoDic;
@property (nonatomic, assign) BOOL isApplied;

- (void)testApplyBlock:(TestApplyBlock)block;

@end

NS_ASSUME_NONNULL_END
