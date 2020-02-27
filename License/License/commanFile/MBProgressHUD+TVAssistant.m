//
//  MBProgressHUD+TVAssistant.m
//  TextField抖动效果、toast提示语
//
//  Created by WOSHIPM on 16/7/8.
//  Copyright © 2016年 WOSHIPM. All rights reserved.
//

#import "MBProgressHUD+TVAssistant.h"

@implementation MBProgressHUD (TVAssistant)
-(void)showToastWithText:(NSString *)text
{
    [self showAnimated:NO];
    [self setMode:MBProgressHUDModeText];
    //customView
//    float textHight = 20.f;
//    float textWidth = [UILabel width:text font:PMFontX(16) h:textHight];
//    if(textWidth>Pwidth/7*4){
//        textWidth = Pwidth/7*4;
//        textHight = [UILabel hight:text font:PMFontX(16) w:textWidth];
//    }
//    UIView*customView = [[UIView alloc] initWithFrame:PRect(0, 0, textWidth+40, textHight+20)];
//    customView.backgroundColor = [UIColor blackColor];
//    UILabel*lb = [UILabel crateLabelWithTitle:text font:PMFontX(16) color:[UIColor whiteColor] location:1];
//    lb.frame = PRect(20, 10, textWidth, textHight);
//    lb.numberOfLines = 0;
//    [customView addSubview:lb];
//    self.customView = customView;
    self.userInteractionEnabled = NO;
    self.detailsLabel.text = text;
    
    self.detailsLabel.font = PFontS(16);
    self.detailsLabel.textColor = kwhite;
    self.bezelView.backgroundColor = [UIColor blackColor];
   //    设置视图停留的时间
    [self hideAnimated:YES afterDelay:1.5];
}
-(void)showToastWithText:(NSString *)text isAutoHide:(BOOL)isAutoHide
{
    [self setMode:MBProgressHUDModeText];
    self.userInteractionEnabled = NO;
    self.detailsLabel.text = text;
    self.detailsLabel.font = PFontH(14);
    if (isAutoHide) {
        //    设置视图停留的时间
        [self hideAnimated:YES afterDelay:2];
    }
}

-(void)showToastWithText:(NSString *)text whileExecutingBlock:(dispatch_block_t)block
{
    [self setMode:MBProgressHUDModeText];
    self.userInteractionEnabled = NO;
    self.label.text = text;
//    设置视图停留的时间
    dispatch_time_t time3s = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC));
    dispatch_after(time3s, dispatch_get_global_queue(0, 0), ^{
        [self hideAnimated:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            block();
        });
    });
}


+(MBProgressHUD *)showToastToView:(UIView *)view withText:(NSString *)text
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.bezelView.color = [UIColor clearColor];
    [hud showToastWithText:text];
    return hud;
}
+(MBProgressHUD *)showToastNoHideClearColorToView:(UIView *)view withText:(NSString *)text textColor:(UIColor*)textColor
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    //hud.yOffset = 70;
    hud.detailsLabel.textColor = textColor;
    [hud showToastWithText:text isAutoHide:NO];
    return hud;
}

@end
