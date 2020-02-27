//
//  ThemeNumberView.h
//  License
//
//  Created by wei on 2019/7/15.
//  Copyright © 2019年 wei. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface ThemeNumberView : UIView
@property (nonatomic,strong)RACSubject*valuesignal;
@property (nonatomic,assign)NSInteger selectItem;
- (instancetype)initWithFrame:(CGRect)frame andTotolNumber:(NSInteger)number;
+(float)viewNeedHeight;
@end
