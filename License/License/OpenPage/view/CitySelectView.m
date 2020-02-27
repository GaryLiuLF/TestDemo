//
//  CitySelectView.m
//  License
//
//  Created by wei on 2019/7/10.
//  Copyright © 2019年 wei. All rights reserved.
//

#import "CitySelectView.h"
@interface CitySelectView()<UITextFieldDelegate>
@property (nonatomic,strong)UIImageView*downArrow;
@property (nonatomic,strong)UIView*lineView;

@end


@implementation CitySelectView

- (instancetype)initWithFrame:(CGRect)frame andPrompt:(NSString*)prompt;{
    self = [super initWithFrame:frame];
    if(self){
        self.clickSignal = [RACSubject subject];
        _tf = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, frame.size.width-30, frame.size.height)];
        _tf.delegate=self;
        _tf.borderStyle = UITextBorderStyleNone;
        _tf.placeholder = prompt;
        _tf.textColor = kblue;
        _tf.font = PFontX(20);
        _tf.userInteractionEnabled = NO;
        [self addSubview:_tf];
        
        UIImage*image = BImage(@"downArrow");
        _downArrow = [[UIImageView alloc] init];
        _downArrow.image = image;
        _downArrow.frame = CGRectMake(frame.size.width-20-5, self.height/2-10, 20, 20);
        [self addSubview:_downArrow];
        
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height-0.5, self.width, 0.5)];
        _lineView.backgroundColor = klineColor;
        [self addSubview:_lineView];
        
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)]];
        
    }
    return self;
}
- (void)tapAction{
    if(self.clickSignal){
        [self.clickSignal sendNext:@1];
    }
}

@end
