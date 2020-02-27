//
//  HomeCustomItemView.h
//  License
//
//  Created by wei on 2019/7/15.
//  Copyright © 2019年 wei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeCustomItemView : UIView
@property (nonatomic,strong)RACSubject*itemClickSignal;
- (instancetype)initWithFrame:(CGRect)frame andInfo:(NSDictionary*)info;
- (void)setSubtitle:(NSString*)subTitle;
+(float)needHeight;

@end
