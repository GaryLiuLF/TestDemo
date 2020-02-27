//
//  UIButton+Libary.m
//  SDLibary
//
//  Created by wei on 17/3/27.
//  Copyright © 2017年 wei. All rights reserved.
//

#import "UIButton+Libary.h"
#import <objc/runtime.h>
@implementation UIButton (Libary)

static char topNameKey;
static char rightNameKey;
static char bottomNameKey;
static char leftNameKey;
+ (UIButton*)textButton:(NSString*)text font:(UIFont*)font color:(UIColor*)color location:(int)location;
{
    UIButton*button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.titleLabel.font = font;
    [button setTitleColor:color forState:UIControlStateNormal];
    if(location==0){
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }else if(location==1){
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    }else{
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    }
    [button setTitle:text forState:UIControlStateNormal];
    return button;
}
- (void)pmSetTitle:(NSString*)title;{
    self.titleLabel.text = title;
    [self setTitle:title forState:UIControlStateNormal];
}
- (void)pmSetLayer:(float)cor borderWidth:(float)width borderColor:(UIColor*)color;{
    self.layer.borderWidth = width;
    self.layer.backgroundColor = color.CGColor;
    self.layer.cornerRadius = cor;
    self.layer.masksToBounds = YES;
}

+ (UIButton*)imageButton:(id)img layout:(BOOL)layout;{
    UIButton*button = [UIButton buttonWithType:UIButtonTypeSystem];
    UIImage*image;
    if([img isKindOfClass:[NSString class]]){
        image = BImage(img);
    }else if([img isKindOfClass:[UIImage class]]){
        image = img;
    }
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    if(layout){
        [button setImage:image forState:UIControlStateNormal];
    }else{
        [button setBackgroundImage:image forState:UIControlStateNormal];
    }
    return button;
}

+ (UIButton*)totalButton:(NSString*)text font:(UIFont*)font color:(UIColor*)color bg:(UIColor*)bgColor;{
    UIButton*button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.backgroundColor = bgColor;
    button.titleLabel.font = font;
    [button setTitleColor:color forState:UIControlStateNormal];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [button setTitle:text forState:UIControlStateNormal];
    return button;
}

+ (UIButton*)clickButton:(NSString*)text font:(UIFont*)font color:(UIColor*)color bg:(UIColor*)bgColor;{
    UIButton*button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.backgroundColor = bgColor;
    button.titleLabel.font = font;
    [button setTitleColor:color forState:UIControlStateNormal];
    [button setTitleColor:[color colorWithAlphaComponent:0.8] forState:UIControlStateHighlighted];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [button setTitle:text forState:UIControlStateNormal];
    return button;
}


- (void)clickEnlargeEdgeWithTop:(CGFloat) top right:(CGFloat) right bottom:(CGFloat) bottom left:(CGFloat) left;
{
    objc_setAssociatedObject(self, &topNameKey, [NSNumber numberWithFloat:top], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &rightNameKey, [NSNumber numberWithFloat:right], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &bottomNameKey, [NSNumber numberWithFloat:bottom], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &leftNameKey, [NSNumber numberWithFloat:left], OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CGRect) enlargedRect
{
    NSNumber* topEdge = objc_getAssociatedObject(self, &topNameKey);
    NSNumber* rightEdge = objc_getAssociatedObject(self, &rightNameKey);
    NSNumber* bottomEdge = objc_getAssociatedObject(self, &bottomNameKey);
    NSNumber* leftEdge = objc_getAssociatedObject(self, &leftNameKey);
    if (topEdge && rightEdge && bottomEdge && leftEdge)
    {
        return CGRectMake(self.bounds.origin.x - leftEdge.floatValue,
                          self.bounds.origin.y - topEdge.floatValue,
                          self.bounds.size.width + leftEdge.floatValue + rightEdge.floatValue,
                          self.bounds.size.height + topEdge.floatValue + bottomEdge.floatValue);
    }
    else
    {
        return self.bounds;
    }
}

- (UIView*) hitTest:(CGPoint) point withEvent:(UIEvent*) event
{
    CGRect rect = [self enlargedRect];
    if (CGRectEqualToRect(rect, self.bounds))
    {
        return [super hitTest:point withEvent:event];
    }
    return CGRectContainsPoint(rect, point) ? self : nil;
}



@end
