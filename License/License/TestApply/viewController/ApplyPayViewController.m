//
//  ApplyPayViewController.m
//  License
//
//  Created by 电信中国 on 2019/9/10.
//  Copyright © 2019 wei. All rights reserved.
//

#import "ApplyPayViewController.h"

#import "ApplyPaySectionView.h"
#import "ApplyPayCell.h"

#import "WXApiRequest.h"
#import <AlipaySDK/AlipaySDK.h>

#import "ApplyDetailViewController.h"

static NSString *cellID = @"ApplyPayCellID";

@interface ApplyPayViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *priceLb;
@property (nonatomic, strong) UIButton *payBtn;

@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

@end

@implementation ApplyPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (void)setup {
    [self setBackButton:YES];
    UILabel*_txtLabel = [UILabel crateLabelWithTitle:@"预约支付" font:PFontZ(18) color:kblock location:1];
    _txtLabel.frame = CGRectMake(0, 0, 220, 35);
    self.navigationItem.titleView = _txtLabel;
    [self setTopLineColor:nil];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F6F6F6"];
    
    [self.view addSubview:self.priceLb];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.payBtn];
    
    [self setupLayout];
    
    self.selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    // 通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(weiXinPayNotifica:) name:@"NotificationWeiXinPay" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(aliPayNotifica:) name:@"NotificationAliPay" object:nil];
}

/// 微信支付
- (void)weiXinPayNotifica:(NSNotification *)notification {

}

/// 支付宝支付
- (void)aliPayNotifica:(NSNotification *)notification {

}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ApplyPayCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.type = indexPath.row;
    if (indexPath == self.selectedIndexPath) {
        cell.isSelected = YES;
    }
    else {
        cell.isSelected = NO;
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ApplyPaySectionView *view = [[ApplyPaySectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 30)];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedIndexPath = indexPath;
    [self.tableView reloadData];
}

- (NSAttributedString *)setAttributedString:(NSString *)content {
    NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc]initWithString:content];
    [attriStr setAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#D04332"], NSFontAttributeName : [UIFont fontWithName:@"PingFangSC-Regular" size:19]} range:NSMakeRange(5, content.length - 5)];
    return attriStr;
}

#pragma mark - 支付事件
- (void)btnAction {
    if (self.selectedIndexPath.row == 0) {
        [self WxPayAction];
    }
    else if (self.selectedIndexPath.row == 1) {
        [self AlipayAction];
    }
}

#pragma mark - 通知回调
- (void)WxPayNoti:(NSNotification *)notification {
    
    if ([notification.object boolValue]) {
        [MBProgressHUD showToastToView:self.view withText:@"支付成功"];
        [[NSUserDefaults standardUserDefaults]setObject:self.applyInfo forKey:@"apply"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
        });
    }
    else {
        [MBProgressHUD showToastToView:self.view withText:@"支付失败"];
    }
    
    
}

- (void)AlipayNoti:(NSNotification *)notification {
    if ([notification.object boolValue]) {
        [MBProgressHUD showToastToView:self.view withText:@"支付成功"];
        [[NSUserDefaults standardUserDefaults]setObject:self.applyInfo forKey:@"apply"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
        });
        
    }
    else {
        [MBProgressHUD showToastToView:self.view withText:@"支付失败"];
    }
}

#pragma mark - 请求
/// 微信支付
- (void)WxPayAction {
    
    NSDictionary *dic = @{
                          @"trade" : @"5d80a142bdff1446f702b52d",
                          @"sign_we" : @{
                                  @"appid" : @"wxa3a4b2435855efe0",
                                  @"noncestr" : @"5d9j1bni",
                                  @"pack" : @"Sign=WXPay",
                                  @"partnerid" : @"1516286301",
                                  @"prepayid" : @"wx171702590148624afb6b079c1160192100",
                                  @"sign" : @"406D0AF6183D494180E8AA015BDA5CC7",
                                  @"timestamp" : @"1568710979"
                                  }
                          };
    [WXApiRequest jumpToWeiXinPayWithParam:dic fromVC:self];
}

/// 支付宝支付
- (void)AlipayAction {
    NSDictionary *dic = @{
                          @"trade" : @"5d80a18fbdff144754da68b4",
                          @"sign_ali" : @"app_id=2019081566182801&biz_content=%7B%22subject%22%3A%22%5Cu4e1a%5Cu52a1%5Cu652f%5Cu4ed8%22%2C%22out_trade_no%22%3A%225d80a18fbdff144754da68b4%22%2C%22total_amount%22%3A199.0%2C%22product_code%22%3A%22QUICK_MSECURITY_PAY%22%7D&charset=utf-8&method=alipay.trade.app.pay&notify_url=https%3A%2F%2F116.247.105.194%3A18101%2Fmisc%2Fprofiles%2Falinotify%2Freport&sign_type=RSA2&timestamp=2019-09-17+17%3A04%3A16&version=1.0&sign=l%2BJQ0KdSKMCBJxppGZ8RgIf9m0G9LBIq0ETH2mi3vOOxqwfAZIIsavpWZWKXYfpe%2FdFgGcrbjxKZfAMj9X0fZZcsQXDIlXXcQTGrbsyteGGy%2BwCQKAOhSSMlroplWM7e4%2BmNu8jkG%2FX2yFbahXDz2f4Z3Rq%2BWiCqMwgczDZBk2%2B6lJA3j5YcvpUqlQB2z6ut9kND2ttn%2FFbeBYN0bqrA84oycxH64njU08hMkSm%2FYKy4jrVkrlmadtdMBv7MBV4W7QZ2p8MprVTitJURvWOC3HlAL6FP4%2FLPHWnt0oseH7dna1M0ciwDw4X%2FGyvh4altjpHFKCn0Q7uu6IIBnDBAtg%3D%3D"
                          };
    [[AlipaySDK defaultService]payOrder:dic[@"sign_ali"] fromScheme:@"fuxingjiakao.com" callback:^(NSDictionary *resultDic) {
        NSLog(@"reslut = %@",resultDic);
    }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



- (void)setupLayout {
    [self.priceLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(12);
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        } else {
            make.top.equalTo(self.view);
        }
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(50);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.priceLb.mas_bottom).offset(2);
        make.height.mas_equalTo(150);
    }];
    
    [self.payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(50);
        make.bottom.equalTo(self.view);
    }];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 60;
        _tableView.separatorColor = [UIColor colorWithHexString:@"#F6F6F6"];
        _tableView.separatorInset = UIEdgeInsetsMake(0, 12, 0, 0);
        _tableView.tableFooterView = [UIView new];
        _tableView.bounces = NO;
        _tableView.backgroundColor = [UIColor whiteColor];
        
        [_tableView registerClass:[ApplyPayCell class] forCellReuseIdentifier:cellID];
    }
    return _tableView;
}

- (UILabel *)priceLb {
    if (!_priceLb) {
        _priceLb = [[UILabel alloc]init];
        _priceLb.textColor = [UIColor colorWithHexString:@"#2F2F2F"];
        _priceLb.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
         _priceLb.backgroundColor = [UIColor clearColor];
        [_priceLb setAttributedText:[self setAttributedString:@"应付金额：￥199.00"]];
    }
    return _priceLb;
}


- (UIButton *)payBtn {
    if (!_payBtn) {
        _payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_payBtn setTitle:@"立即支付" forState:UIControlStateNormal];
        _payBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        _payBtn.backgroundColor = [UIColor colorWithHexString:@"#0276C6"];
        [_payBtn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _payBtn;
}

@end
