//
//  ApplyDetailViewController.m
//  License
//
//  Created by 电信中国 on 2019/9/3.
//  Copyright © 2019 wei. All rights reserved.
//

#import "ApplyDetailViewController.h"

#import "ApplyDetailView.h"
#import "ApplyPayViewController.h"

@interface ApplyDetailViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) ApplyDetailView_One *addressView;
@property (nonatomic, strong) ApplyDetailView_Two *dateView;
@property (nonatomic, strong) ApplyDetailView_Three *infoView;
@property (nonatomic, strong) ApplyDetailView_Four *headView;
@property (nonatomic, strong) ApplyDetailView_Five *payView;
//@property (nonatomic, strong) UIButton *applyBtn;

@end

@implementation ApplyDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
}

- (void)setup {
    [self setBackButton:YES];
    UILabel*_txtLabel = [UILabel crateLabelWithTitle:@"预约网点" font:PFontZ(18) color:kblock location:1];
    _txtLabel.frame = CGRectMake(0, 0, 220, 35);
    self.navigationItem.titleView = _txtLabel;
    [self setTopLineColor:nil];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F6F6F6"];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.addressView];
    [self.scrollView addSubview:self.dateView];
    [self.scrollView addSubview:self.infoView];
    [self.scrollView addSubview:self.headView];
    [self.scrollView addSubview:self.payView];
    [self setupLayout];
}

- (void)btnAction:(UIButton *)sender {
    NSArray *arr = [self.infoView.info componentsSeparatedByString:@"/"];
    if ([arr containsObject:@""]) {
        [MBProgressHUD showToastToView:self.view withText:@"请补全学员信息"];
        return;
    }
    
    if (!self.headView.isFrontSuccess && !self.headView.isBackSuccess) {
        [MBProgressHUD showToastToView:self.view withText:@"请进行头像认证"];
        return;
    }
    
    UIAlertController *alertContr = [UIAlertController alertControllerWithTitle:nil message:@"是否确定预约" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"预约" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:self.infoDic];
        [dic setObject:self.dateView.time forKey:@"time"];
        [dic setObject:self.infoView.info forKey:@"info"];
        [[NSUserDefaults standardUserDefaults]setObject:dic forKey:@"apply"];
        
        [MBProgressHUD showToastToView:self.view withText:@"请电话联系预约场地"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    }];
    
    [alertContr addAction:cancelAction];
    [alertContr addAction:sureAction];
    [self presentViewController:alertContr animated:YES completion:nil];
}

- (void)toApplyTestPay {
    NSArray *arr = [self.infoView.info componentsSeparatedByString:@"/"];
    if ([arr containsObject:@""]) {
        [MBProgressHUD showToastToView:self.view withText:@"请补全学员信息"];
        return;
    }
    if (!self.headView.isFrontSuccess && !self.headView.isBackSuccess) {
        [MBProgressHUD showToastToView:self.view withText:@"请进行头像认证"];
        return;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:self.infoDic];
    [dic setObject:self.dateView.time forKey:@"time"];
    [dic setObject:self.infoView.info forKey:@"info"];
    
    ApplyPayViewController *vc = [ApplyPayViewController new];
    vc.applyInfo = [dic copy];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setupLayout {
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(12);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.top.equalTo(self.view).offset(12);
            make.bottom.equalTo(self.view);
        }
    }];
    
    [self.addressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView);
        make.width.equalTo(self.view);
        make.height.mas_equalTo(120);
        make.top.equalTo(self.scrollView);
    }];
    
    [self.dateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.height.mas_equalTo(100);
        make.top.equalTo(self.addressView.mas_bottom).offset(12);
        make.width.equalTo(self.view);
    }];
    
    [self.infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.height.mas_equalTo(190);
        make.top.equalTo(self.dateView.mas_bottom).offset(12);
        make.width.equalTo(self.view);
    }];
    
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.height.mas_equalTo(160+30);
        make.top.equalTo(self.infoView.mas_bottom).offset(12);
        make.width.equalTo(self.view);
    }];
    
    [self.payView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.height.mas_equalTo(50);
        make.top.equalTo(self.headView.mas_bottom).offset(12);
        make.width.equalTo(self.view);
    }];
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.contentSize = CGSizeMake(self.view.width, 668+30);
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    return _scrollView;
}


- (ApplyDetailView_One *)addressView {
    if (!_addressView) {
        _addressView = [[ApplyDetailView_One alloc]init];
        _addressView.infoDic = self.infoDic;
    }
    return _addressView;
}

- (ApplyDetailView_Two *)dateView {
    if (!_dateView) {
        _dateView = [[ApplyDetailView_Two alloc]init];
    }
    return _dateView;
}

- (ApplyDetailView_Three *)infoView {
    if (!_infoView) {
        _infoView = [[ApplyDetailView_Three alloc]init];
        _infoView.isEdit = YES;
    }
    return _infoView;
}

- (ApplyDetailView_Four *)headView {
    if (!_headView) {
        _headView = [[ApplyDetailView_Four alloc]init];
    }
    return _headView;
}

- (ApplyDetailView_Five *)payView {
    if (!_payView) {
        _payView = [[ApplyDetailView_Five alloc]init];
        @weakify(self);
        [_payView applePayBlock:^{
            @strongify(self);
            [self toApplyTestPay];
//            NSLog(@"%@， %@", self.dateView.time, self.infoView.info);
        }];
    }
    return _payView;
}
//
//- (UIButton *)applyBtn {
//    if (!_applyBtn) {
//        _applyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_applyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [_applyBtn setTitle:@"立即预约" forState:UIControlStateNormal];
//        _applyBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
//        _applyBtn.backgroundColor = [UIColor colorWithHexString:@"#0276C6"];
//        [_applyBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _applyBtn;
//}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
