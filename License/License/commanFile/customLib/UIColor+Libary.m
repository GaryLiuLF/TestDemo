
#import "UIColor+Libary.h"

@implementation UIColor (Libary)

+ (UIColor *)colorWithHexString:(NSString *)hexString{
    
    unsigned int alpha, red, green, blue;
    
    // 获取到的颜色
    if ([[hexString uppercaseString] hasPrefix:@"0X"]) {
        hexString = [hexString substringFromIndex:2];
    } else if ([hexString hasPrefix:@"#"]) {
        hexString = [hexString substringFromIndex:1];
    }
    
    // 当颜色值少于6个字符时返回黑色
    if (hexString.length < 6) return [UIColor blackColor];
    
    NSRange range = NSMakeRange(0, 2);
    
    // Alpha值 默认为255(1.0f)
    if (6 == hexString.length) {
        alpha = 255;
    } else {
        [[NSScanner scannerWithString:[hexString substringWithRange:range]] scanHexInt:&alpha];
        range.location += 2;
    }
    
    // 红色
    [[NSScanner scannerWithString:[hexString substringWithRange:range]] scanHexInt:&red];
    range.location += 2;
    
    // 绿色
    [[NSScanner scannerWithString:[hexString substringWithRange:range]] scanHexInt:&green];
    range.location += 2;
    
    // 蓝色
    [[NSScanner scannerWithString:[hexString substringWithRange:range]] scanHexInt:&blue];
    
    return [UIColor colorWithRed:red / 255.0f green:green / 255.0f blue:blue / 255.0f alpha:alpha / 255.0f];
}

@end
