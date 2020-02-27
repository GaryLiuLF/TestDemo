//
//  MyApplyViewController.m
//  License
//
//  Created by 电信中国 on 2019/9/4.
//  Copyright © 2019 wei. All rights reserved.
//

#import "MyApplyViewController.h"

#import "ApplyDetailView.h"

@interface MyApplyViewController ()

@property (nonatomic, strong) UILabel *noDateLb;
@property (nonatomic, strong) ApplyDetailView_One *addressView;
@property (nonatomic, strong) ApplyDetailView_Six *dateView;
@property (nonatomic, strong) ApplyDetailView_Three *infoView;
@property (nonatomic, strong) UIButton *applyBtn;

@property (nonatomic, strong) NSDictionary *applyDic;
@property (nonatomic, assign) BOOL isNoData;

@end

@implementation MyApplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self setup];
}

- (void)initData {
    self.applyDic = [[[NSUserDefaults standardUserDefaults] objectForKey:@"apply"]copy];
    if (self.applyDic == nil) {
        self.isNoData = YES;
    }
    else {
        self.isNoData = NO;
    }
}

- (void)setup {
    [self setBackButton:YES];
    UILabel*_txtLabel = [UILabel crateLabelWithTitle:@"考试预约" font:PFontZ(18) color:kblock location:1];
    _txtLabel.frame = CGRectMake(0, 0, 220, 35);
    self.navigationItem.titleView = _txtLabel;
    [self setTopLineColor:nil];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F6F6F6"];
    
    if (self.isNoData) {
        [self.view addSubview:self.noDateLb];
    }else{
        [self.view addSubview:self.addressView];
        [self.view addSubview:self.dateView];
        [self.view addSubview:self.infoView];
        [self.view addSubview:self.applyBtn];
    }
    [self setupLayout];
}

- (void)btnAction:(UIButton *)sender {

    UIAlertController *alertContr = [UIAlertController alertControllerWithTitle:nil message:@"是否确定取消预约" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"apply"];
        
        [MBProgressHUD showToastToView:self.view withText:@"取消成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    }];
    
    [alertContr addAction:cancelAction];
    [alertContr addAction:sureAction];
    [self presentViewController:alertContr animated:YES completion:nil];
}

- (void)setupLayout {
    
    if (self.isNoData) {
        [self.noDateLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.centerY.equalTo(self.view).offset(-20);
            make.height.mas_equalTo(80);
            make.width.mas_equalTo(200);
        }];
        return;
    }
    
    [self.addressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(120);
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(12);
        } else {
            make.top.equalTo(self.view).offset(12);
        }
    }];
    
    [self.dateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.height.mas_equalTo(80);
        make.top.equalTo(self.addressView.mas_bottom).offset(12);
        make.width.equalTo(self.view);
    }];
    
    [self.infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.height.mas_equalTo(190);
        make.top.equalTo(self.dateView.mas_bottom).offset(12);
        make.width.equalTo(self.view);
    }];
    
    [self.applyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.height.mas_equalTo(50);
        make.bottom.equalTo(self.view);
        make.width.equalTo(self.view);
    }];
}

- (UILabel *)noDateLb {
    if (!_noDateLb) {
        _noDateLb = [[UILabel alloc]init];
        _noDateLb.text = @"暂无预约";
        _noDateLb.textColor = [UIColor grayColor];
        _noDateLb.font = [UIFont systemFontOfSize:18];
        _noDateLb.textAlignment = NSTextAlignmentCenter;
    }
    return _noDateLb;
}

- (ApplyDetailView_One *)addressView {
    if (!_addressView) {
        _addressView = [[ApplyDetailView_One alloc]init];
        _addressView.infoDic = self.applyDic;
    }
    return _addressView;
}

- (ApplyDetailView_Six *)dateView {
    if (!_dateView) {
        _dateView = [[ApplyDetailView_Six alloc]init];
        _dateView.time = self.applyDic[@"time"];
    }
    return _dateView;
}

- (ApplyDetailView_Three *)infoView {
    if (!_infoView) {
        _infoView = [[ApplyDetailView_Three alloc]init];
        _infoView.isEdit = NO;
        _infoView.info = self.applyDic[@"info"];
    }
    return _infoView;
}

- (UIButton *)applyBtn {
    if (!_applyBtn) {
        _applyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_applyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_applyBtn setTitle:@"取消预约" forState:UIControlStateNormal];
        _applyBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        _applyBtn.backgroundColor = [UIColor colorWithHexString:@"#0276C6"];
        [_applyBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _applyBtn;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
