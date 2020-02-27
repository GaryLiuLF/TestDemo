//
//  NZFaceIdLib.h
//  SANNIN
//
//  Created by ChenQiushi on 2019/6/11.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FaceIdLib : NSObject

- (void)detectIdCardPage:(NSInteger)isFront fromVC:(UIViewController *)vc completion:(void(^)(BOOL success, NSDictionary *data))completion;
- (void)detectLiveFromVC:(UIViewController *)vc completion:(void(^)(bool success, NSDictionary *data))completion;

@end

NS_ASSUME_NONNULL_END
