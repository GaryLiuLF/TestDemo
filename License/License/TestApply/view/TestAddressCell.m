//
//  TestAddressCell.m
//  License
//
//  Created by 电信中国 on 2019/9/3.
//  Copyright © 2019 wei. All rights reserved.
//

#import "TestAddressCell.h"

@interface TestAddressCell ()

@property (strong, nonatomic) UILabel *nameLb;
@property (strong, nonatomic) UILabel *contentLb;
@property (strong, nonatomic) UIButton *applyBtn;

@end

@implementation TestAddressCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setup];
    }
    return self;
}

- (void)setup {
    UILabel *nameLb = [[UILabel alloc]init];
    nameLb.textAlignment = NSTextAlignmentLeft;
    nameLb.font = [UIFont boldSystemFontOfSize:16];
    nameLb.textColor = [UIColor colorWithHexString:@"#0F2C39"];
    [self.contentView addSubview:nameLb];
    self.nameLb = nameLb;
    
    UILabel *contentLb = [[UILabel alloc]init];
    contentLb.textAlignment = NSTextAlignmentLeft;
    contentLb.font = [UIFont boldSystemFontOfSize:12];
    contentLb.textColor = [UIColor colorWithHexString:@"#B1AEB0"];
    [self.contentView addSubview:contentLb];
    self.contentLb = contentLb;
    
    UIButton *applyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [applyBtn setTitle:@"立即报名" forState:UIControlStateNormal];
    [applyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    applyBtn.backgroundColor = [UIColor colorWithHexString:@"#0276C6"];
    applyBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    applyBtn.layer.cornerRadius = 15;
    [applyBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:applyBtn];
    self.applyBtn = applyBtn;
    
    self.nameLb.text = @"驾驶理论徐汇支队大木桥路考场";
    self.contentLb.text = @"地址：徐汇区大木桥路434号1号楼206室";
}

- (void)btnAction:(UIButton *)sender {
    if (self.testApplyBlock) {
        self.testApplyBlock();
    }
}

- (void)testApplyBlock:(TestApplyBlock)block {
    self.testApplyBlock = block;
}

- (void)setInfoDic:(NSDictionary *)infoDic  {
    self.nameLb.text = infoDic[@"name"];
    self.contentLb.text = infoDic[@"address"];
}

- (void)setIsApplied:(BOOL)isApplied {
    if (isApplied) {
        [self.applyBtn setTitle:@"已报名" forState:UIControlStateNormal];
        self.applyBtn.backgroundColor = [UIColor colorWithHexString:@"#B4B4B4"];
        self.applyBtn.enabled = NO;
    }
    else {
        [self.applyBtn setTitle:@"立即报名" forState:UIControlStateNormal];
        self.applyBtn.backgroundColor = [UIColor colorWithHexString:@"#0276C6"];
        self.applyBtn.enabled = YES;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(12);
        make.right.equalTo(self.contentView).offset(-100);
        make.height.mas_equalTo(20);
        make.bottom.equalTo(self.contentView.mas_centerY).offset(-4);
    }];
    
    [self.contentLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLb);
        make.top.equalTo(self.contentView.mas_centerY).offset(4);
        make.height.mas_equalTo(self.nameLb.mas_height);
        make.width.equalTo(self.nameLb);
    }];
    
    [self.applyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-15);
        make.centerY.equalTo(self.contentView);
        make.width.mas_equalTo(75);
        make.height.mas_equalTo(30);
    }];
    
}

@end
