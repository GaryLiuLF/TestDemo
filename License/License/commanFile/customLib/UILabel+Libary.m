//
//  UILabel+Libary.m
//  SDLibary
//
//  Created by wei on 17/3/24.
//  Copyright © 2017年 wei. All rights reserved.
//

#import "UILabel+Libary.h"

@implementation UILabel (Libary)

+ (UILabel*)crateLabelWithTitle:(NSString*)title font:(UIFont*)font color:(UIColor*)color location:(int)location;{
    UILabel*lable = [UILabel new];
    lable.font = font;
    lable.textColor = color;
    lable.text = title;
    if(location==0){
        lable.textAlignment = NSTextAlignmentLeft;
    }else if (location==1){
        lable.textAlignment = NSTextAlignmentCenter;
    }else{
        lable.textAlignment = NSTextAlignmentRight;
    }
    return lable;
}
+ (NSAttributedString*)text:(NSString*)text conditions:(NSArray <NSArray*> *)condition;
{
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:text];
    int startPoint = 0;
    for(int i=0;i<condition.count;i++){
        NSArray*item = condition[i];//长短 颜色 字体
        NSDictionary *nameSubAttributeDict =
        @{ NSForegroundColorAttributeName : item[1],
           NSFontAttributeName : item[2] };
        [attrStr setAttributes:nameSubAttributeDict range:NSMakeRange(startPoint,[item[0] intValue])];
        startPoint = startPoint + [item[0] intValue];
    }
    return attrStr;
}
+ (NSAttributedString*)text:(NSString*)text underLineConditions:(NSArray <NSArray*> *)condition;//最后一项属性是下划线
{
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:text];
    int startPoint = 0;
    for(int i=0;i<condition.count;i++){
        NSArray*item = condition[i];//长短 颜色 字体
        NSDictionary *nameSubAttributeDict;
        if([item[3] boolValue]){
            nameSubAttributeDict =
            @{ NSForegroundColorAttributeName : item[1],
               NSFontAttributeName : item[2],
               NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]
               };
        }else{
            nameSubAttributeDict =
            @{ NSForegroundColorAttributeName : item[1],
               NSFontAttributeName : item[2] };
        }
        [attrStr setAttributes:nameSubAttributeDict range:NSMakeRange(startPoint,[item[0] intValue])];
        //是否加下划线
        startPoint = startPoint + [item[0] intValue];
    }
    return attrStr;
}

//添加行间距和字间距
+ (NSAttributedString*)text:(NSString*)text textSpace:(float)textSpace lineSpace:(float)lineSpace font:(UIFont*)font color:(UIColor*)color;{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpace;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    
    [attributedString addAttributes:@{NSFontAttributeName:font,
                                      NSForegroundColorAttributeName:color,
                                      NSKernAttributeName:@(textSpace),
                                      NSParagraphStyleAttributeName:paragraphStyle,
                                      } range:NSMakeRange(0, attributedString.length)];
    return attributedString;
}

+ (CGFloat)height:(NSString*)text font:(UIFont*)font w:(CGFloat)w{
    CGRect tmpRect = [text boundingRectWithSize:CGSizeMake(w, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil] context:nil];
    return tmpRect.size.height+0.5;
}
+ (CGFloat)width:(NSString*)text font:(UIFont*)font h:(CGFloat)h;{
    CGRect tmpRect = [text boundingRectWithSize:CGSizeMake(1000, h) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil] context:nil];
    return tmpRect.size.width+0.5;
}




+ (CGFloat)changeLineSpaceForLabel:(UILabel *)label WithSpace:(float)space {
    NSString *labelText = label.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText]; NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init]; [paragraphStyle setLineSpacing:space]; [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])]; label.attributedText = attributedString;
    [label sizeToFit];
    
    NSDictionary *dic = @{NSFontAttributeName:label.font, NSParagraphStyleAttributeName:paragraphStyle, NSKernAttributeName:@1.5f
                          };
    CGSize size = [labelText boundingRectWithSize:CGSizeMake(label.frame.size.width, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.height;
}
+ (CGFloat)changeLineSpaceForLabelRight:(UILabel *)label WithSpace:(float)space {
    NSString *labelText = label.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText]; NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:space];
    paragraphStyle.alignment = NSTextAlignmentRight;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    label.attributedText = attributedString;
    [label sizeToFit];
    
    NSDictionary *dic = @{NSFontAttributeName:label.font, NSParagraphStyleAttributeName:paragraphStyle, NSKernAttributeName:@1.5f
                          };
    CGSize size = [labelText boundingRectWithSize:CGSizeMake(label.frame.size.width, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.height;
}

+ (CGFloat)changeWordSpaceForLabel:(UILabel *)label WithSpace:(float)space {
    NSString *labelText = label.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText attributes:@{NSKernAttributeName:@(space)}];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    label.attributedText = attributedString;
    [label sizeToFit];
    NSDictionary *dic = @{NSFontAttributeName:label.font, NSParagraphStyleAttributeName:paragraphStyle, NSKernAttributeName:@1.5f
                          };
    CGSize size = [labelText boundingRectWithSize:CGSizeMake(label.frame.size.width, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.height;
}

+ (CGSize)textRectWithString:(NSString*)text maxWidth:(CGFloat)width andFont:(UIFont*)font andTextSpace:(CGFloat)textSpace andLineSpace:(CGFloat)lineSpace;{
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = lineSpace;
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@(textSpace)
                          };
    CGSize size = [text boundingRectWithSize:CGSizeMake(width, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size;
}

+ (CGFloat)changeSpaceForLabel:(UILabel *)label withLineSpace:(float)lineSpace WordSpace:(float)wordSpace textALi:(int)ali WithLine:(BOOL)line; {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    if(ali==0) paraStyle.alignment = NSTextAlignmentLeft;
    else if (ali==1) paraStyle.alignment = NSTextAlignmentCenter;
    else paraStyle.alignment = NSTextAlignmentRight;
    paraStyle.lineSpacing = lineSpace; //设置行间距
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    //设置字间距 NSKernAttributeName:@1.5f
    NSDictionary *dic = @{NSFontAttributeName:label.font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@(wordSpace)
                          };
    if(line){
        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:label.text attributes:dic];
        [attributeStr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, label.text.length)];
        label.attributedText = attributeStr;
    }else{
        NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:label.text attributes:dic];
        label.attributedText = attributeStr;
    }
    
    
    return 0.0;
}
+ (CGFloat)changeSpaceForLabelForMidlle:(UILabel *)label withLineSpace:(float)lineSpace WordSpace:(float)wordSpace;//居中
{
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentCenter;
    paraStyle.lineSpacing = lineSpace; //设置行间距
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    //设置字间距 NSKernAttributeName:@1.5f
    NSDictionary *dic = @{NSFontAttributeName:label.font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@(wordSpace)
                          };
    
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:label.text attributes:dic];
    label.attributedText = attributeStr;
    
   //CGSize size = [label.text boundingRectWithSize:CGSizeMake(label.frame.size.width, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return 0.0;
}

@end
