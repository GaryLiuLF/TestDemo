//
//  ApplyPaySectionView.m
//  License
//
//  Created by 电信中国 on 2019/9/10.
//  Copyright © 2019 wei. All rights reserved.
//

#import "ApplyPaySectionView.h"

@interface ApplyPaySectionView ()

@property (nonatomic, strong) UILabel *titleLb;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation ApplyPaySectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setup];
    }
    return self;
}

- (void)setup {
    UILabel *titleLb = [[UILabel alloc]init];
    titleLb.text = @"自选支付方式";
    titleLb.textAlignment = NSTextAlignmentLeft;
    titleLb.textColor = [UIColor colorWithHexString:@"#9B9B9B"];
    titleLb.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    [self addSubview:titleLb];
    self.titleLb = titleLb;
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#F6F6F6"];
    [self addSubview:lineView];
    self.lineView = lineView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(12);
        make.centerY.equalTo(self);
        make.width.mas_equalTo(200);
        make.height.equalTo(self);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self);
        make.height.mas_equalTo(1);
    }];
}

@end
