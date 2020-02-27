//
//  UILabel+Libary.h
//  SDLibary
//
//  Created by wei on 17/3/24.
//  Copyright © 2017年 wei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Libary)
//正常lable
+ (UILabel*)crateLabelWithTitle:(NSString*)title font:(UIFont*)font color:(UIColor*)color location:(int)location;
//mutablestring
+ (NSAttributedString*)text:(NSString*)text conditions:(NSArray <NSArray*> *)condition;
+ (NSAttributedString*)text:(NSString*)text underLineConditions:(NSArray <NSArray*> *)condition;

//添加行间距和字间距
+ (NSAttributedString*)text:(NSString*)text textSpace:(float)textSpace lineSpace:(float)lineSpace font:(UIFont*)font color:(UIColor*)color;

+ (CGFloat)height:(NSString*)text font:(UIFont*)font w:(CGFloat)w;
+ (CGFloat)width:(NSString*)text font:(UIFont*)font h:(CGFloat)h;
/**
 *  改变行间距
 */
+ (CGFloat)changeLineSpaceForLabel:(UILabel *)label WithSpace:(float)space;
+ (CGSize)textRectWithString:(NSString*)text maxWidth:(CGFloat)width andFont:(UIFont*)font andTextSpace:(CGFloat)textSpace andLineSpace:(CGFloat)lineSpace;
+ (CGFloat)changeLineSpaceForLabelRight:(UILabel *)label WithSpace:(float)space;//右对齐
/**
 *  改变字间距
 */
+ (CGFloat)changeWordSpaceForLabel:(UILabel *)label WithSpace:(float)space;
/**
 *  改变行间距和字间距
 */
+ (CGFloat)changeSpaceForLabel:(UILabel *)label withLineSpace:(float)lineSpace WordSpace:(float)wordSpace textALi:(int)ali WithLine:(BOOL)line;
+ (CGFloat)changeSpaceForLabelForMidlle:(UILabel *)label withLineSpace:(float)lineSpace WordSpace:(float)wordSpace;//居中
@end
