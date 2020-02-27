//
//  TestAddressView.h
//  License
//
//  Created by 电信中国 on 2019/9/3.
//  Copyright © 2019 wei. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^TestAddrSelectBlock)(NSInteger flag);
@interface TestAddressView : UIView

@property (nonatomic, copy) TestAddrSelectBlock testAddrSelectBlock;
- (void)testAddrSelectBlock:(TestAddrSelectBlock)block;

@end

NS_ASSUME_NONNULL_END
