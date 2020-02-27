//
//  ProtocolRemindView.m
//  License
//
//  Created by 电信中国 on 2019/10/18.
//  Copyright © 2019 wei. All rights reserved.
//

#import "ProtocolRemindView.h"

#import <YYKit.h>
#import <Masonry.h>
#import "LicenseTool.h"
#import "RegisterProtocolViewController.h"

@interface ProtocolRemindView ()

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *hintLabel;
@property (nonatomic, strong) UITextField *nameTextFiled;
@property (nonatomic, strong) YYTextView *hintTextView;
@property (nonatomic, strong) UIButton *agreeButton;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIButton *showButton;
@property (nonatomic, strong) UIButton *delegateButton;

@property (nonatomic, strong) UIViewController *superViewContr;

@end

@implementation ProtocolRemindView

- (instancetype)initWithFrame:(CGRect)frame fromVC:(nonnull UIViewController *)vc
{
    self = [super initWithFrame:frame];
    if (self) {
        self.superViewContr = vc;
        [self initWithData];
    }
    return self;
}

- (void)initWithData {
    
    UIView *maskView = [[UIView alloc] init];
    maskView.layer.backgroundColor = [UIColor colorWithRed:34/255.0 green:34/255.0 blue:34/255.0 alpha:0.8].CGColor;
    [self addSubview:maskView];
    self.maskView = maskView;
    
    UITextField *nameTextFiled = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 100, 20)];
    nameTextFiled.textAlignment = NSTextAlignmentLeft;
    nameTextFiled.textColor = [UIColor whiteColor];
    nameTextFiled.backgroundColor = [UIColor clearColor];
    nameTextFiled.font = [UIFont systemFontOfSize:10];
    
    UIView *contentView = [[UIView alloc]init];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.layer.cornerRadius = 10;
    [maskView addSubview:contentView];
    self.contentView = contentView;
    
    UILabel *hintLabel = [[UILabel alloc]init];
    hintLabel.text = @"温馨提示";
    hintLabel.font = [UIFont boldSystemFontOfSize:23];
    hintLabel.textColor = [UIColor colorWithHexString:@"#222222"];
    hintLabel.textAlignment = NSTextAlignmentLeft;
    [contentView addSubview:hintLabel];
    self.hintLabel = hintLabel;
    
    YYTextView *hintTextView = [[YYTextView alloc]init];
    hintTextView.textVerticalAlignment = YYTextVerticalAlignmentTop;
    hintTextView.textAlignment = NSTextAlignmentLeft;
    hintTextView.editable = NO;
    [contentView addSubview:hintTextView];
    self.hintTextView = hintTextView;
    
    UIButton *showButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [showButton setTitle:@"是否显示" forState:UIControlStateNormal];
    [showButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    showButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    showButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    showButton.backgroundColor = [UIColor clearColor];
    
    UIButton *agreeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [agreeButton setTitle:[NSString stringWithFormat:@"同意，进入%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"]] forState:UIControlStateNormal];
    [agreeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    agreeButton.backgroundColor = [LicenseTool sharedInstance].configInfo[@"themeColor"];
    agreeButton.titleLabel.font = [UIFont systemFontOfSize:16];
    agreeButton.layer.cornerRadius = 22;
    [contentView addSubview:agreeButton];
    self.agreeButton = agreeButton;
    [self.agreeButton addTarget:self action:@selector(showMoreAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setImage:[UIImage imageNamed:@"btn_close"] forState:UIControlStateNormal];
    [maskView addSubview:closeButton];
    self.closeButton = closeButton;
    [self.closeButton addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *contentStr = @"我们非常重视您的隐私保护和个人信息保护。请您认真阅读以下全部条款，同意并接受全部条款后再开始使用我们的服务。\n";
    for (NSDictionary *dic in [LicenseTool sharedInstance].configInfo[@"privacy_protocol"][@"privacy"]) {
        contentStr = [contentStr stringByAppendingString:[NSString stringWithFormat:@"%@\n", dic[@"title"]]];
    }
    
    [self.hintTextView setAttributedText:[self setAttriStrWithContentStr:contentStr]];
}


- (NSMutableAttributedString*)setAttriStrWithContentStr:(NSString*)contentStr {
    NSMutableAttributedString * resultAttr = [[NSMutableAttributedString alloc] initWithString:contentStr];
    resultAttr.lineSpacing = 7;
    resultAttr.kern = [NSNumber numberWithFloat:1.0];
    resultAttr.font = [UIFont systemFontOfSize:15];
    resultAttr.color = [UIColor colorWithHexString:@"#444444"];
    
    NSArray *arr = [LicenseTool sharedInstance].configInfo[@"privacy_protocol"][@"privacy"];
    for (NSInteger i = 0; i < arr.count; i++) {
        NSRange range = [contentStr rangeOfString:arr[i][@"title"]];
        [resultAttr setTextHighlightRange:range color:[UIColor colorWithHexString:@"#FC9900"] backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            RegisterProtocolViewController *vc = [RegisterProtocolViewController new];
            vc.urlStr = [LicenseTool sharedInstance].configInfo[@"privacy_protocol"][@"privacy"][i][@"link"];
            vc.titleStr = [LicenseTool sharedInstance].configInfo[@"privacy_protocol"][@"privacy"][i][@"title"];
            [self.superViewContr.navigationController pushViewController:vc animated:YES];
        }];
    }
    
    return resultAttr;
}

- (void)closeAction {
    [self removeFromSuperview];
}

- (void)showMoreAction {
    if (self.showMoreBlock) {
        self.showMoreBlock();
    }
}

- (void)showMoreBlock:(ShowMoreBlock)block {
    self.showMoreBlock = block;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.top.equalTo(self);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.maskView);
        make.centerY.equalTo(self.maskView).offset(-20);
        make.width.mas_equalTo(310);
        make.height.mas_equalTo(350);
    }];
    
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.maskView);
        make.top.equalTo(self.contentView.mas_bottom).offset(32);
        make.width.height.mas_equalTo(27);
    }];
    
    [self.hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(23);
        make.top.equalTo(self.contentView).offset(38);
        make.height.mas_equalTo(33);
        make.right.equalTo(self.contentView).offset(-23);
    }];
    
    [self.hintTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(23);
        make.top.equalTo(self.hintLabel.mas_bottom).offset(20);
        make.right.equalTo(self.contentView).offset(-23);
        make.height.mas_equalTo(150);
    }];
    
    [self.agreeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(-40);
        make.left.equalTo(self.contentView).offset(23);
        make.right.equalTo(self.contentView).offset(-23);
        make.height.mas_equalTo(45);
    }];
}

@end
