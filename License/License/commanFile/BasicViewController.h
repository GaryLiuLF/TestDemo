//
//  PushViewController.h
//  WoAiJieTu
//
//  Created by wei on 17/1/18.
//  Copyright © 2017年 WoAiJieTu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BasicViewController : UIViewController
@property (nonatomic,assign) BOOL cannotPopGestureRecognizer;

- (void)setBg:(UIColor*)bgColor titleColor:(UIColor*)titleColor;
- (void)setBackButton:(BOOL)isPublic;
- (void)setTopLineColor:(UIColor*)lineColor;
- (void)leftItemClick;

@end

