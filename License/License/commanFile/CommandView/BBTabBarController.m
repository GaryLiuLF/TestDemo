//
//  FCMainVC.m
//  FocusUser
//
//  Created by wei on 2018/4/8.
//  Copyright © 2018年 wei. All rights reserved.
//

#import "BBTabBarController.h"
#import "BasicNavigationController.h"
#import "BBHomeViewController.h"
#import "BBCollectViewController.h"
#import "BBHotViewController.h"
#import "BBMineViewController.h"


@interface BBTabBarController ()

@end

@implementation BBTabBarController

- (instancetype)init{
    self = [super init];
    if(self){
        self.view.backgroundColor = [UIColor whiteColor];
        [self setup];
    }
    return self;
}
- (void)setup{
    self.tabBar.backgroundImage = [UIImage imageNamed:@"whiteimage"];
    BBHomeViewController *homepage = [[BBHomeViewController alloc] init];
    UINavigationController *homepagenav = [[UINavigationController alloc] initWithRootViewController:homepage];
    
    BBCollectViewController *colletc = [[BBCollectViewController alloc] init];
    UINavigationController *colletnav = [[UINavigationController alloc] initWithRootViewController:colletc];
    
//    BBHotViewController *hotvc= [[BBHotViewController alloc]init];
//    UINavigationController *hotNav = [[UINavigationController alloc] initWithRootViewController:hotvc];
    
    BBMineViewController *minevc = [[BBMineViewController alloc] init];
    BasicNavigationController *minenav = [[BasicNavigationController alloc] initWithRootViewController:minevc];
    
    self.viewControllers = @[homepagenav, colletnav, minenav];
    
    // 批量设置nav的背景色、风格
    [self.viewControllers enumerateObjectsUsingBlock:^(__kindof UINavigationController * _Nonnull nav, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"idx = %ld",idx);
        //[nav.navigationBar setBackgroundImage:[[UIImage imageNamed:@"sblack"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forBarMetrics:UIBarMetricsDefault];
        //[nav.navigationBar setBarStyle:UIBarStyleBlack];
        //[nav.navigationBar setTintColor:kColor_content];
    }];
    [self setTabbarItemStyle:homepagenav title:@"考试" imageName:@"bhome_no" selectedImage:@"bhome_se" imageInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self setTabbarItemStyle:colletnav title:@"错题" imageName:@"bcollect_no" selectedImage:@"bcollect_se" imageInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    //[self setTabbarItemStyle:hotNav title:@"要闻" imageName:@"bdownload_no" selectedImage:@"bdownload_se" imageInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self setTabbarItemStyle:minenav title:@"设置" imageName:@"bme_no" selectedImage:@"bme_se" imageInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    // 文字的偏移调整（水平，垂直）
    //textnav.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -4);
    //imagenav.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -4);
    //gifnav.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -4);
    //menav.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -4);
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName:PFontX(10), NSForegroundColorAttributeName: klineColor} forState:(UIControlStateNormal)];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName:PFontX(10), NSForegroundColorAttributeName: kblue} forState:UIControlStateSelected];
    //CGSize size = CGSizeMake(self.tabBar.bounds.size.width/self.tabBar.items.count, self.tabBar.bounds.size.height+2);
    //self.tabBar.selectionIndicatorImage = [self drawTabbarItemBackgroundImageWithSize:size];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, -0.5, BBWidth, 0.5)];
    view.backgroundColor = klineColor;
    [[UITabBar appearance] insertSubview:view atIndex:0];
}
- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize andOffSet:(CGPoint)offSet{
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(offSet.x, offSet.y, newSize.width-offSet.x, newSize.height-offSet.y)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
- (UIImage*)drawTabbarItemBackgroundImageWithSize:(CGSize)size{
    UIGraphicsBeginImageContext(size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(ctx, 17.0/255, 17.0/255, 17.0/255, 1.0);
    CGContextFillRect(ctx, CGRectMake(0, 0, size.width, size.height));
    UIImage*img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndPDFContext();
    return img;
}
- (void)setTabbarItemStyle:(UIViewController *)viewController title:(NSString *)title imageName:(NSString *)image selectedImage:(NSString *)selectedImage imageInsets:(UIEdgeInsets)insets
{
    //1, 2, 3, 2     4, 3, 2, 3
    UIImage *unselectImage =[UIImage imageNamed:image];
    UIImage *selectImage = [UIImage imageNamed:selectedImage];
    
    unselectImage = [self imageWithImage:unselectImage scaledToSize:CGSizeMake(25, 25) andOffSet:CGPointMake(0, 0)];
    selectImage = [self imageWithImage:selectImage scaledToSize:CGSizeMake(25, 25) andOffSet:CGPointMake(0, 0)];
    
    unselectImage = [unselectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    selectImage = [selectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    viewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:unselectImage selectedImage:selectImage];
    viewController.tabBarItem.imageInsets = insets;
    [viewController.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -2)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

@end
