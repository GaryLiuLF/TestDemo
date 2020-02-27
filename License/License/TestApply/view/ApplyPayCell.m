//
//  ApplyPayCell.m
//  License
//
//  Created by 电信中国 on 2019/9/10.
//  Copyright © 2019 wei. All rights reserved.
//

#import "ApplyPayCell.h"

@interface ApplyPayCell ()

@property (nonatomic, strong) UIImageView *payImgView;
@property (nonatomic, strong) UILabel *titleLb;
@property (nonatomic, strong) UILabel *subTitleLb;
@property (nonatomic, strong) UIImageView *selectImgView;

@property (nonatomic, copy) NSArray *titleArr;

@end

@implementation ApplyPayCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        [self setup];
    }
    return self;
}

- (void)setup {
    
    UIImageView *payImgView = [[UIImageView alloc]init];
    payImgView.userInteractionEnabled = YES;
    [self.contentView addSubview:payImgView];
    self.payImgView = payImgView;
    
    UILabel *titleLb = [[UILabel alloc]init];
    titleLb.textColor = [UIColor colorWithHexString:@"#2F2F2F"];
    titleLb.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    titleLb.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:titleLb];
    self.titleLb = titleLb;
    
    UILabel *subTitleLb = [[UILabel alloc]init];
    subTitleLb.textColor = [UIColor colorWithHexString:@"#9B9B9B"];
    subTitleLb.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    subTitleLb.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:subTitleLb];
    self.subTitleLb = subTitleLb;
    
    UIImageView *selectImgView = [[UIImageView alloc]init];
    selectImgView.image = [UIImage imageNamed:@"noSelected"];
    [self.contentView addSubview:selectImgView];
    self.selectImgView = selectImgView;
}

#pragma mark - Setter
- (void)setType:(ApplyPayType)type {
    self.payImgView.image = [UIImage imageNamed:self.titleArr[0][type]];
    self.titleLb.text = self.titleArr[1][type];
    self.subTitleLb.text = self.titleArr[2][type];
}

- (void)setIsSelected:(BOOL)isSelected {
    if (isSelected) {
        self.selectImgView.image = [UIImage imageNamed:@"selected"];
    }
    else {
        self.selectImgView.image = [UIImage imageNamed:@"noSelected"];
    }
}

#pragma mark - 布局
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.payImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(14);
        make.left.equalTo(self.contentView).offset(12);
        make.width.height.mas_equalTo(32);
    }];
    
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.payImgView.mas_right).offset(13);
        make.top.equalTo(self.contentView).offset(9);
        make.right.equalTo(self.contentView).offset(-40);
        make.height.mas_equalTo(22);
    }];
    
    [self.subTitleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLb);
        make.top.mas_equalTo(self.titleLb.mas_bottom).offset(2);
        make.right.equalTo(self.contentView).offset(-40);
        make.height.mas_equalTo(17);
    }];
    
    [self.selectImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-12);
        make.width.height.mas_equalTo(18);
    }];
}

- (NSArray *)titleArr {
    if (!_titleArr) {
        _titleArr = @[@[@"pay_weixin", @"pay_zhifu"], @[@"微信支付", @"支付宝"], @[@"推荐已安装微信的用户使用", @"推荐支付宝用户使用"]];
    }
    return _titleArr;
}


@end
