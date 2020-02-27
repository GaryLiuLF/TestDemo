//
//  BBShare.h
//  License
//
//  Created by 电信中国 on 2019/10/21.
//  Copyright © 2019 wei. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BBShare : UIView

+ (void)initWithUMShare;
- (void)showShareActionWithTitle:(NSString *)title content:(NSString *)content url:(NSString *)url imageUrl:(id)imageUrl  controller: (UIViewController *)controller;
- (void)showShareActionWithParams:(NSDictionary *)params;

@end

NS_ASSUME_NONNULL_END
