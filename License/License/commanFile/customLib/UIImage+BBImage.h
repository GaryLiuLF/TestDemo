//
//  UIImage+BBImage.h
//  License
//
//  Created by 电信中国 on 2019/10/21.
//  Copyright © 2019 wei. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (BBImage)

+ (NSData *)getCompressedImage:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
