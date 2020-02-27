//
//  UIButton+Libary.h
//  SDLibary
//
//  Created by wei on 17/3/27.
//  Copyright © 2017年 wei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Libary)
/**
 *  初始化纯文本按钮
 *
 *  @param text 按钮文字
 *
 *  @return UIButton
 */
+ (UIButton*)textButton:(NSString*)text font:(UIFont*)font color:(UIColor*)color location:(int)location;
/**
 *  设置按钮文字
 *  @param title 按钮文字
 */
- (void)pmSetTitle:(NSString*)title;
/**
 *  设置按钮layer
 *  @param cor 圆角
 */
- (void)pmSetLayer:(float)cor borderWidth:(float)width borderColor:(UIColor*)color;

/**
 *  初始化纯图片按钮
 *
 *  @param img 按钮图片
 *  @param layout 是否自适配
 *
 *  @return UIButton
 */
+ (UIButton*)imageButton:(id)img layout:(BOOL)layout;
/**
 *  初始化背景色按钮+文本按钮
 *
 *  @param text 文字
 *  @param bgColor 背景颜色
 *
 *  @return UIButton
 */
+ (UIButton*)totalButton:(NSString*)text font:(UIFont*)font color:(UIColor*)color bg:(UIColor*)bgColor;


/**
 *  初始化可点击背景色按钮+文本按钮
 *
 *  @param text 文字
 *  @param bgColor 背景颜色
 *
 *  @return UIButton
 */
+ (UIButton*)clickButton:(NSString*)text font:(UIFont*)font color:(UIColor*)color bg:(UIColor*)bgColor;


//按钮的扩大范围
- (void)clickEnlargeEdgeWithTop:(CGFloat) top right:(CGFloat) right bottom:(CGFloat) bottom left:(CGFloat) left;

@end
