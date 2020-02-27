//
//  CitySelectView.h
//  License
//
//  Created by wei on 2019/7/10.
//  Copyright © 2019年 wei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CitySelectView : UIView

- (instancetype)initWithFrame:(CGRect)frame andPrompt:(NSString*)prompt;
@property (nonatomic,strong)UITextField*tf;
@property (nonatomic,strong)RACSubject*clickSignal;

@end
