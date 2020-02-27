//
//  LFBookListViewController.m
//  快租
//
//  Created by 电信中国 on 2019/7/25.
//  Copyright © 2019年 LiuLinFei. All rights reserved.
//

#import "RandomTrainViewController.h"

#import <AFNetworking/AFNetworking.h>
#import <UMPush/UMessage.h>

#import "LicenseTool.h"

#import "OrderTrainViewController.h"
#import "TestSkillViewController.h"

@interface RandomTrainViewController ()

@property (weak, nonatomic) IBOutlet UILabel *appNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *numberField;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@property (nonatomic, strong) UIBarButtonItem *backItem;

@end

@implementation RandomTrainViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //    [self initData];
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (!_configs[@"showBack"]) {
//        self.navigationItem.leftBarButtonItem = YES;
    }
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_numberField becomeFirstResponder];
}

- (void)setupUI {
    _appNameLabel.text = [NSString stringWithFormat:@"欢迎您使用%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"]];
    
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    
    _backItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"arr_btn"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]  style:UIBarButtonItemStylePlain target:self action:@selector(backAction:)];
    _backItem.imageInsets = UIEdgeInsetsMake(4, 0, -4, 0);
    if (_configs[@"showBack"]) {
        self.navigationItem.leftBarButtonItem = _backItem;
    }
}

- (IBAction)textEditChanged:(UITextField *)sender {
    if ([[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^1\\d{10}$"] evaluateWithObject:sender.text]) {
        [self selectNextTrainAction];
    } else {
        [self selectFirstTrainAction];
    }
}

#pragma mark - event
- (void)backAction:(UIBarButtonItem *)btn{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"MP_ToLogin"]) {
        TestSkillViewController *vc = segue.destinationViewController;
        vc.number = _numberField.text;
        vc.smsType = TestSkillTypeCode;
    }
}

- (void)selectFirstTrainAction {
    _nextBtn.userInteractionEnabled = NO;
    [_nextBtn setBackgroundColor:[LicenseTool sharedInstance].configInfo[@"btnUnColor"]];
}

- (void)selectNextTrainAction {
    _nextBtn.userInteractionEnabled = YES;
    [_nextBtn setBackgroundColor:[LicenseTool sharedInstance].configInfo[@"themeColor"]];
}


- (void)showFirstTrainAction {
    _nextBtn.userInteractionEnabled = YES;
    [_nextBtn setBackgroundColor:[LicenseTool sharedInstance].configInfo[@"themeColor"]];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


@end
