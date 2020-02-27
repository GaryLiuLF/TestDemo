//
//  TestAddressView.m
//  License
//
//  Created by 电信中国 on 2019/9/3.
//  Copyright © 2019 wei. All rights reserved.
//

#import "TestAddressView.h"

@interface TestAddressView ()

@property (nonatomic, strong) UILabel *titleLb;
@property (nonatomic, strong) UIButton *addressBtn1;
@property (nonatomic, strong) UIButton *addressBtn2;
@property (nonatomic, strong) UILabel *otherLb;

@property (nonatomic, assign) NSInteger selectedTag;

@end

@implementation TestAddressView

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        [self setup];
    }
    return self;
}

- (void)setup {
    UILabel *titleLb = [[UILabel alloc]init];
    titleLb.font = [UIFont systemFontOfSize:16];
    titleLb.textAlignment = NSTextAlignmentLeft;
    titleLb.text = @"网点查询";
    [self addSubview:titleLb];
    self.titleLb = titleLb;
    
    UIButton *addressBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [addressBtn1 setTitle:@"上海" forState:UIControlStateNormal];
    [addressBtn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    addressBtn1.titleLabel.font = [UIFont systemFontOfSize:13];
    addressBtn1.backgroundColor = [UIColor colorWithHexString:@"#0276C6"];
    addressBtn1.layer.cornerRadius = 5;
    addressBtn1.layer.borderColor = [UIColor colorWithHexString:@"#0276C6"].CGColor;
    addressBtn1.layer.borderWidth = 1;
    addressBtn1.tag = 10;
    [self addSubview:addressBtn1];
    self.addressBtn1 = addressBtn1;
    
    UIButton *addressBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [addressBtn2 setTitle:@"北京" forState:UIControlStateNormal];
    [addressBtn2 setTitleColor:[UIColor colorWithHexString:@"#0276C6"] forState:UIControlStateNormal];
    addressBtn2.titleLabel.font = [UIFont systemFontOfSize:13];
    addressBtn2.backgroundColor = [UIColor whiteColor];
    addressBtn2.layer.cornerRadius = 5;
    addressBtn2.layer.borderColor = [UIColor colorWithHexString:@"#0276C6"].CGColor;
    addressBtn2.layer.borderWidth = 1;
    addressBtn2.tag = 11;
    [self addSubview:addressBtn2];
    self.addressBtn2 = addressBtn2;
    
    UILabel *otherLb = [[UILabel alloc]init];
    otherLb.text = @"待开发";
    otherLb.font = [UIFont systemFontOfSize:13];
    otherLb.textColor = [UIColor whiteColor];
    otherLb.backgroundColor = [UIColor colorWithHexString:@"#D1D1D1"];
    otherLb.textAlignment = NSTextAlignmentCenter;
    otherLb.layer.cornerRadius = 5;
    otherLb.layer.masksToBounds = YES;
    [self addSubview:otherLb];
    self.otherLb = otherLb;
    
    self.selectedTag = 10;
    [addressBtn1 addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [addressBtn2 addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)btnAction:(UIButton *)sender {
    if (sender.tag != self.selectedTag) {
        UIButton *oldBtn = [self viewWithTag:self.selectedTag];
        [oldBtn setTitleColor:[UIColor colorWithHexString:@"#0276C6"] forState:UIControlStateNormal];
        oldBtn.backgroundColor = [UIColor whiteColor];
        
        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        sender.backgroundColor = [UIColor colorWithHexString:@"#0276C6"];
        
        self.selectedTag = sender.tag;
        
        if (self.testAddrSelectBlock) {
            self.testAddrSelectBlock(sender.tag-10);
        }
        
    } else {
        return;
    }
}

- (void)testAddrSelectBlock:(TestAddrSelectBlock)block {
    self.testAddrSelectBlock = block;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(16);
        make.top.equalTo(self).offset(10);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(25);
    }];
    
    [self.addressBtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(12);
        make.top.equalTo(self.titleLb.mas_bottom).offset(10);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(35);
    }];
    
    [self.addressBtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.addressBtn1.mas_right).offset(15);
        make.centerY.equalTo(self.addressBtn1);
        make.width.mas_equalTo(self.addressBtn1.mas_width);
        make.height.mas_equalTo(self.addressBtn1.mas_height);
    }];
    
    [self.otherLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.addressBtn2.mas_right).offset(15);
        make.centerY.equalTo(self.addressBtn1);
        make.width.mas_equalTo(self.addressBtn1.mas_width);
        make.height.mas_equalTo(self.addressBtn1.mas_height);
    }];
}


@end
