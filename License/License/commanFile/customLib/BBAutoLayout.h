
#ifndef BBAutoLayout_h
#define BBAutoLayout_h

//frame 和 屏幕长高
#define BBWidth [UIScreen mainScreen].bounds.size.width
#define BBHeight [UIScreen mainScreen].bounds.size.height
#define BBRect(x,y,w,h) CGRectMake(x, y, w, h)
// 状态栏
#define BBStatusBar [[UIApplication sharedApplication] statusBarFrame].size.height
#define BBNavHeight_Y  (_iPhoneX?24.0:0.0)
#define BBNavHeight  (_iPhoneX?88.0:64.0)
#define BBToolBot  (_iPhoneX?34.0:0.0)

// 底部bar高度
#define BBTabBar ([[UIApplication sharedApplication] statusBarFrame].size.height>20?83:49)
// 顶部导航条高度
#define BBTopBar (PMKStatusBar + 44.0)
//比例倍数
//颜色
#define kColorRGB(a,b,c) [UIColor colorWithRed:a/255.0 green:b/255.0 blue:c/255.0 alpha:1]
#define kRGB(A, B, C, D) [UIColor colorWithRed:A/255.0f green:B/255.0f blue:C/255.0f alpha:D]
#define kColor(name) [UIColor colorWithHexString:name]
//字体
#define PFontS(x) [UIFont fontWithName:@"PingFangSC-Regular" size:x]
#define PFontA(x) [UIFont fontWithName:@"Arial" size:x]
#define PFontH(x) [UIFont fontWithName:@"PingFangSC-Semibold" size:x]
#define PFontM(x) [UIFont fontWithName:@"PingFangSC-Medium" size:x]

#define PFontX(x) [UIFont fontWithName:@"FZLTXHJW--GB1-0" size:x]
#define PFontZ(x) [UIFont fontWithName:@"FZLTZHJW--GB1-0" size:x]


//系统
#define  _system [[[UIDevice currentDevice] systemVersion] floatValue]
#define  _iPhone4     ((BBWidth == 320.f && BBHeight == 480.f)? YES : NO)
#define  _iPhone5     ((BBWidth == 320.f && BBHeight == 568.f) ? YES : NO)
#define  _iPhone6     ((BBWidth == 375.f && BBHeight == 667.f)? YES : NO)
#define  _iPhone6P    ((BBWidth == 414.f && BBHeight == 736.f )? YES : NO)
#define  _iPhoneX      [CommandManager sharedManager].isIphoneX

//NSUserDefaults 实例化
#define BBDefault [NSUserDefaults standardUserDefaults]
//image
#define BImage(A) [UIImage imageNamed:A]
#define BXImage(A) _iPhoneX?[UIImage imageNamed:[NSString stringWithFormat:@"X%@",A]]:[UIImage imageNamed:A]

//本项目颜色  背景白
#define KClearColor   [UIColor clearColor]
#define klineColor    kColor(@"ffC8D4DB")
#define kblue         kColor(@"ff0581D1")
#define kwhite        kColor(@"ffffffff")
#define kblock        kColor(@"ff000000")
#define kred        kColor(@"ffEB5252")

#define BType [CommandManager sharedManager].carType

//本应用专用
#define bmob_id @"58f761ec74dcc7992605e787bd52a6d5"
#define bmob_key @"0cda2c87d8aa93f7cde8e418f04d431c"
#define bmob_secret @"0c2de5e2ba79ceac"
#define bmob_master @"f2e3b93228b75a3fe9a140d7cfe4629e"


#import "UILabel+Libary.h"
#import "NSObject+Libary.h"
#import "UIButton+Libary.h"
#import "UIColor+Libary.h"
#import "NSArray+Library.h"
#import "NSDictionary+Library.h"
#import "CommandManager.h"
#import "MBProgressHUD+TVAssistant.h"
#import "KDefine.h"
#import "DBTool.h"
#import "WRNavigationBar.h"
#endif
