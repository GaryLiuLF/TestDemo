//
//  LFShareFriend.h
//  快租
//
//  Created by 电信中国 on 2019/7/25.
//  Copyright © 2019年 LiuLinFei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ContactList : NSObject

- (void)showContactListWithCompletion:(void(^)(BOOL success, NSDictionary *contacts))completion;

- (void)showContactAlertView;

@end

NS_ASSUME_NONNULL_END
