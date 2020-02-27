//
//  UIImage+BBImage.m
//  License
//
//  Created by 电信中国 on 2019/10/21.
//  Copyright © 2019 wei. All rights reserved.
//

#import "UIImage+BBImage.h"

@implementation UIImage (BBImage)

+ (NSData *)getCompressedImage:(UIImage *)image {
    CGSize originalSize = image.size;
    CGFloat imageW = MIN(500.0, originalSize.width);
    CGFloat imageH = imageW * originalSize.height / originalSize.width;
    CGSize size = CGSizeMake(imageW, imageH);
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return UIImageJPEGRepresentation(image, 1);
}

@end
