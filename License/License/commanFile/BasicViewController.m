//
//  PushViewController.m
//  WoAiJieTu
//
//  Created by wei on 17/1/18.
//  Copyright © 2017年 WoAiJieTu. All rights reserved.
//

#import "BasicViewController.h"

@interface BasicViewController ()<UIGestureRecognizerDelegate>
{
    id<UIGestureRecognizerDelegate> _delegate;
}
@property (nonatomic,assign)BOOL is_public;
@end

@implementation BasicViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // 导航条设置
    //[self setback_black];
    self.view.backgroundColor = kwhite;
    [self wr_setNavBarShadowImageHidden:YES];
}
- (void)setBg:(UIColor*)bgColor titleColor:(UIColor*)titleColor;{
    [self wr_setNavBarBarTintColor:bgColor];
    [self wr_setNavBarTitleColor:titleColor];
}
- (void)setBackButton:(BOOL)isPublic;{
    self.is_public = isPublic;
    if(isPublic){
        UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"ic_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(goBack)];
        self.navigationItem.leftBarButtonItem = left;
    }else{
        UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"ic_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(goBackCustom)];
        self.navigationItem.leftBarButtonItem = left;
    }
    
    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
//    button.frame = CGRectMake(0, 0, 44, 44);
//    button.backgroundColor = kblue;
//    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
//    [button setImage:[[UIImage imageNamed:@"ic_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
//    if(isPublic){
//        [button addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
//    }else{
//        [button addTarget:self action:@selector(leftItemClick) forControlEvents:UIControlEventTouchUpInside];
//    }
//    UIBarButtonItem *leftItem0 = [[UIBarButtonItem alloc]initWithCustomView:button];
//    self.navigationItem.leftBarButtonItem = leftItem0;
//    //self.navigationItem.leftBarButtonItem = leftItem0;
//    UIBarButtonItem *nagetiveSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
//                                                                                   target:nil action:nil];
//    nagetiveSpacer.width = -20;//这个值可以根据自己需要自己调整
//    self.navigationItem.leftBarButtonItems = @[nagetiveSpacer,left];
    
}
- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setTopLineColor:(UIColor*)lineColor;{
    UIView*line = [[UIView alloc] initWithFrame:CGRectMake(0, BBNavHeight, BBWidth, 0.5)];
    if(lineColor){
        line.backgroundColor = lineColor;
    }else{
        line.backgroundColor = klineColor;
    }
    [self.view addSubview:line];
}

- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //self.classname = NSStringFromClass([self class]);
    if (self.navigationController.viewControllers.count > 1 && !_cannotPopGestureRecognizer) {
        // 记录系统返回手势的代理
        _delegate = self.navigationController.interactivePopGestureRecognizer.delegate;
        // 设置系统返回手势的代理为当前控制器
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    if(self.navigationController.viewControllers.count > 1){
        [UIApplication sharedApplication].statusBarStyle =  UIStatusBarStyleDefault;
    }else{
        [UIApplication sharedApplication].statusBarStyle =  UIStatusBarStyleLightContent;
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    for(UIView*v in self.view.subviews){
        if([v isKindOfClass:[UIScrollView class]]){
            UIScrollView*scroll = (UIScrollView*)v;
            scroll.scrollEnabled = NO;
        }
    }
    //self.view.userInteractionEnabled = NO;
    // 设置系统返回手势的代理为我们刚进入控制器的时候记录的系统的返回手势代理
    if (self.navigationController.viewControllers.count > 1 && !_cannotPopGestureRecognizer){
        self.navigationController.interactivePopGestureRecognizer.delegate = _delegate;
    }
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //self.classname = NSStringFromClass([self class]);
    for(UIView*v in self.view.subviews){
        if([v isKindOfClass:[UIScrollView class]]){
            UIScrollView*scroll = (UIScrollView*)v;
            scroll.scrollEnabled = YES;
        }
    }
    //self.kcontroller_self = YES;
    //self.view.userInteractionEnabled = YES;
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}
#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if(self.is_public==NO) return NO;
    return self.navigationController.childViewControllers.count > 1;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if(self.is_public==NO) return NO;
    return self.navigationController.viewControllers.count > 1;
}

- (UIImage*)drawTabbarItemBackgroundImageWithSize:(CGSize)size r:(float)r g:(float)g b:(float)b{
    UIGraphicsBeginImageContext(size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(ctx, r/255, g/255, b/255, 1.0);
    CGContextFillRect(ctx, CGRectMake(0, 0, size.width, size.height));
    UIImage*img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndPDFContext();
    return img;
}

- (BOOL)prefersHomeIndicatorAutoHidden{
    return YES;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"leftButtonBack" object:nil];
    NSLog(@"dealloc：%@",NSStringFromClass([self class]));
}


@end



