//
//  LFQuickBookViewController.m
//  快租
//
//  Created by 电信中国 on 2019/7/25.
//  Copyright © 2019年 LiuLinFei. All rights reserved.
//

#import "TestSkillViewController.h"

#import <AFNetworking/AFNetworking.h>
#import <UMPush/UMessage.h>
#import <Masonry/Masonry.h>
#import <MBProgressHUD.h>

#import "OrderTrainViewController.h"
#import "TrainRecordViewController.h"
#import "BoxInputView_Underline.h"

#import "LicenseTool.h"
#import "ContactList.h"
#import "SelectTrainType.h"

#import <YYKit.h>
#import "RegisterProtocolViewController.h"
#import "ProtocolRemindView.h"

NSInteger const kSMSSeconds = 60;
NSInteger const kVoiceSMSSeconds = 30;

@interface TestSkillViewController ()

@property (weak, nonatomic) IBOutlet UILabel *sendNumberLabel;
@property (weak, nonatomic) IBOutlet UIButton *sendCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *voiceBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (nonatomic, strong) UIButton *selectBtn;
@property (nonatomic, strong) YYLabel *protocolLb;
@property (nonatomic, strong) ProtocolRemindView *moreRecordView;

@property (strong, nonatomic) NSString *code;
@property (strong, nonatomic) CRBoxInputView *boxInputView;

@property (assign, nonatomic) BOOL hasLogin;
@property (nonatomic, copy) NSArray *selectImgArr;
@property (nonatomic, assign) BOOL isRead;
@property (nonatomic, assign) BOOL isShow;
@property (nonatomic, strong) NSMutableArray *privacyArr;
@property (nonatomic, strong) NSDictionary *infoDic;
@property (nonatomic, strong) NSDictionary *fields;

@end

@implementation TestSkillViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initWithData];
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.sendCodeBtn.userInteractionEnabled = YES;
}

- (void)initWithData {
    self.testUserInfo = @{};
    self.trainID = @"";
    
    self.sendNumberLabel.text = [NSString stringWithFormat:@"验证码会发送至%@", self.number];
}

- (void)setupUI {
    [self getNewTestSkillTypeAction];
    
    CRBoxInputCellProperty *cellProperty = [CRBoxInputCellProperty new];
    cellProperty.cellCursorColor = [LicenseTool sharedInstance].configInfo[@"themeColor"];
    cellProperty.cellCursorWidth = 2;
    cellProperty.cellCursorHeight = 27;
    cellProperty.cornerRadius = 0;
    cellProperty.borderWidth = 0;
    cellProperty.cellFont = [UIFont boldSystemFontOfSize:24];
    cellProperty.cellTextColor = [UIColor colorWithHexString:@"#222222"];
    
    BoxInputView_Underline *boxInputView = [BoxInputView_Underline new];
    _boxInputView = boxInputView;
    _boxInputView.boxFlowLayout.itemSize = CGSizeMake(52, 52);
    _boxInputView.customCellProperty = cellProperty;
    [_boxInputView loadAndPrepareViewWithBeginEdit:NO];
    _boxInputView.keyBoardType = UIKeyboardTypeNumberPad;
    
    [_boxInputView clearAllWithBeginEdit:YES];
    __weak typeof(self) weakSelf = self;
    _boxInputView.textDidChangeblock = ^(NSString *text, BOOL isFinished) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.code = text;
        [strongSelf updateAfterLogBtn];
        if (isFinished) {
            if (strongSelf.isShow && !strongSelf.isRead) {
                [strongSelf.view addSubview:strongSelf.moreRecordView];
            } else {
                [strongSelf logCodelL];
            }
        }
    };
    [self.view addSubview:_boxInputView];
    
    [_boxInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(29);
        make.right.equalTo(self.view).offset(-29);
        make.height.equalTo(@50);
        make.top.equalTo(self->_sendNumberLabel.mas_bottom).offset(37);
    }];
    
    if (![LicenseTool sharedInstance].configInfo[@"privacy_protocol"]) {
        return;
    }
    
    if ([[LicenseTool sharedInstance].configInfo[@"privacy_protocol"][@"privacy_show"] integerValue] == 1) {
        self.isShow = YES;
    }
    else {
        self.isShow = NO;
    }
    
    
    if ([[LicenseTool sharedInstance].configInfo[@"privacy_protocol"][@"privacy_choose"] integerValue] == 1) {
        self.isRead = YES;
    }
    else {
        self.isRead = NO;
    }
    
    if (!self.isShow) {
        return;
    }
    
    self.privacyArr = [NSMutableArray array];
    for (NSDictionary *privacyDic in [LicenseTool sharedInstance].configInfo[@"privacy_protocol"][@"privacy"]) {
        [self.privacyArr addObject:privacyDic[@"title"]];
    }
    NSString *contentStr=[@"同意并接受" stringByAppendingString:[self.privacyArr componentsJoinedByString:@"、"]];
    if (self.privacyArr.count>1) {
        NSRange lastPrivacyRange = [contentStr rangeOfString:self.privacyArr.lastObject];
        contentStr = [contentStr stringByReplacingCharactersInRange:NSMakeRange(lastPrivacyRange.location-1, 1) withString:@"和"];
    }
    
    UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectBtn setImage:[UIImage imageNamed:self.selectImgArr[self.isRead]] forState:UIControlStateNormal];
    [self.view addSubview:selectBtn];
    self.selectBtn = selectBtn;
    [self.selectBtn addTarget:self action:@selector(selectFindStatusAction) forControlEvents:UIControlEventTouchUpInside];
    
    YYLabel *protocolLb = [[YYLabel alloc]init];
    protocolLb.textVerticalAlignment = YYTextVerticalAlignmentTop;
    protocolLb.textAlignment = NSTextAlignmentLeft;
    protocolLb.numberOfLines = 0;
    protocolLb.displaysAsynchronously = YES;
    [protocolLb setAttributedText:[self setAttributedStringWithContentStr:contentStr]];
    [self.view addSubview:protocolLb];
    self.protocolLb = protocolLb;
    
    @weakify(self);
    [self.moreRecordView showMoreBlock:^{
        @strongify(self);
        [self.moreRecordView removeFromSuperview];
        
        self.isRead = YES;
        [self.selectBtn setImage:[UIImage imageNamed:self.selectImgArr[self.isRead]] forState:UIControlStateNormal];
        
        [self logCodelL];
    }];
    
    
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.top.equalTo(self.loginBtn.mas_bottom).offset(13);
        make.height.width.mas_equalTo(17);
    }];
    
    [self.protocolLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.selectBtn.mas_right).offset(8);
        make.right.equalTo(self.view).offset(-15);
        make.height.mas_equalTo(100);
        make.top.equalTo(self.loginBtn.mas_bottom).offset(15);
    }];
}

- (NSMutableAttributedString*)setAttributedStringWithContentStr:(NSString*)attributedString {
    NSMutableAttributedString * resultAttr = [[NSMutableAttributedString alloc] initWithString:attributedString];
    resultAttr.lineSpacing = 7;
    resultAttr.kern = [NSNumber numberWithFloat:1.0];
    resultAttr.font = [UIFont systemFontOfSize:13];
    resultAttr.color = [UIColor colorWithHexString:@"#B1B1B1"];
    
    for (NSInteger i = 0; i < self.privacyArr.count; i++) {
        NSRange range = [attributedString rangeOfString:self.privacyArr[i]];
        [resultAttr setTextHighlightRange:range color:[UIColor colorWithHexString:@"#FC9900"] backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            RegisterProtocolViewController *vc = [RegisterProtocolViewController new];
            vc.urlStr = [LicenseTool sharedInstance].configInfo[@"privacy_protocol"][@"privacy"][i][@"link"];
            vc.titleStr = [LicenseTool sharedInstance].configInfo[@"privacy_protocol"][@"privacy"][i][@"title"];
            [self.navigationController pushViewController:vc animated:YES];
        }];
    }
    
    return resultAttr;
}

- (void)selectFindStatusAction {
    self.isRead = !self.isRead;
    [self.selectBtn setImage:[UIImage imageNamed:self.selectImgArr[self.isRead]] forState:UIControlStateNormal];
}


- (IBAction)tapSendCodeBtn:(UIButton *)sender {
    _smsType = TestSkillTypeCode;
    [self getNewTestSkillTypeAction];
}

- (IBAction)tapVoiceBtn:(UIButton *)sender {
    _smsType = TestSkillTypeVoice;
    [self startLogV];
}

- (IBAction)tapLoginBtn:(UIButton *)sender {
    if (self.isShow && !self.isRead) {
        [self.view addSubview:self.moreRecordView];
    } else {
        [self logCodelL];
    }
}

- (void)dealloc {
    NSLog(@"dealloc");
}

- (void)testSkillSelectBlock:(TestSkillSelectBlock)block {
    self.testSkillSelectBlock = block;
}

- (void)getNewTestSkillTypeAction {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFCompoundResponseSerializer serializer];
    NSDictionary *params = @{
                             @"number": _number,
                             @"case": @"login"
                             };
    __weak typeof(self) weakSelf = self;
    [manager POST:[NSString stringWithFormat:@"%@/land/code", [LicenseTool sharedInstance].configInfo[@"host"]] parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:NULL];
        if ([dic[@"status"] isEqual:@1]) {
            [strongSelf afreshSetSkillTypeAction];
        } else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"获取验证码太频繁，请稍后再试" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:cancelAction];
            [strongSelf presentViewController:alert animated:YES completion:nil];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"获取验证码失败，请稍后再试" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancelAction];
        [strongSelf presentViewController:alert animated:YES completion:nil];
    }];
}

- (void)afreshSetSkillTypeAction {
    self.sendCodeBtn.userInteractionEnabled = NO;
    __block NSInteger timeout = kSMSSeconds; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0);
    __weak typeof(self) weakSelf = self;
    dispatch_source_set_event_handler(_timer, ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (timeout <= 0) {
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.sendCodeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
                self.sendCodeBtn.userInteractionEnabled = YES;
            });
        } else {
            NSInteger seconds = timeout % (kSMSSeconds + 1);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.sendCodeBtn setTitle:[NSString stringWithFormat:@"%zd秒后重试", seconds] forState:UIControlStateNormal];
            });
        }
        if (timeout <= kSMSSeconds - kVoiceSMSSeconds) {
            dispatch_async(dispatch_get_main_queue(), ^{
                strongSelf.voiceBtn.hidden = NO;
            });
        }
        timeout--;
    });
    dispatch_resume(_timer);
    [_boxInputView becomeFirstResponder];
}

- (void)startLogV {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFCompoundResponseSerializer serializer];
    NSDictionary *params = @{
                             @"number": _number,
                             @"case": @"login",
                             @"voice": @1
                             };
    __weak typeof(self) weakSelf = self;
    [manager POST:[NSString stringWithFormat:@"%@/land/code", [LicenseTool sharedInstance].configInfo[@"host"]] parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [strongSelf updateLogBtn];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"获取验证码失败，请稍后再试" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancelAction];
        [strongSelf presentViewController:alert animated:YES completion:nil];
    }];
}

- (void)logCodelL {
    if (_hasLogin) {
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFCompoundResponseSerializer serializer];
    
    NSDictionary *params = @{
                             @"number": _number,
                             @"code": _code,
                             };
    
    __weak typeof(self) weakSelf = self;
    
    NSString *tempNumber = @"12345678999";
    
    [manager POST:[NSString stringWithFormat:@"%@/users/logincode", [LicenseTool sharedInstance].configInfo[@"host"]] parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
        
        if (self.hasLogin) {
            return ;
        }
        self.hasLogin = YES;
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:NULL];
        [[LicenseTool sharedInstance].userInfo setValuesForKeysWithDictionary:@{@"phone": strongSelf.number, @"number": dic[@"number"], @"user_id": dic[@"id"]}];
        NSDictionary *fields = ((NSHTTPURLResponse*)task.response).allHeaderFields;
        NSArray *cookies = [NSHTTPCookie cookiesWithResponseHeaderFields:fields forURL:[NSURL URLWithString:[LicenseTool sharedInstance].configInfo[@"host"]]];
        
        NSDictionary *info = @{@"cookies": cookies, @"dic": dic};
        if ([dic[@"new_in"] isEqual:@7] && [dic[@"auth_name"] isEqual:@1]) {
            [[LicenseTool sharedInstance] refreshLicenseTrainResult:info];
            strongSelf.view = nil;
            [[SelectTrainType new] getTrainSkillList];
        } else if ([dic[@"new_in"] isEqual:@7]) {
            strongSelf.view = nil;
            [strongSelf showQuickNoteViewController:info];
        } else {
            [[LicenseTool sharedInstance] refreshLicenseTrainResult:info];
            strongSelf.view = nil;
            [[SelectTrainType new] getTrainSkillList];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        self.hasLogin = NO;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([self.number isEqualToString:tempNumber]) {
            strongSelf.view = nil;
            [[SelectTrainType new] getTrainSkillList];
            return ;
        }
        
        [self.boxInputView clearAllWithBeginEdit:YES];
        
        NSHTTPURLResponse *responses = (NSHTTPURLResponse *)task.response;
        if (responses.statusCode == 400) {
            NSError *err;
            NSDictionary *errDic = [NSJSONSerialization JSONObjectWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] options:NSJSONReadingMutableContainers error:&err];
            NSString *msgStr = @"";
            if (errDic[@"link"] && ![errDic[@"link"] isEqualToString:@""]) {
                RegisterProtocolViewController *vc = [RegisterProtocolViewController new];
                vc.urlStr = errDic[@"link"];
                vc.titleStr = @"已注销";
                [self.navigationController pushViewController:vc animated:YES];
                return ;
            }
            else if(!errDic[@"msg"]){
                msgStr = @"验证码错误";
                
            }
            else {
                if ([errDic[@"msg"] isKindOfClass:[NSArray class]]) {
                    msgStr = [errDic[@"msg"] componentsJoinedByString:@","];
                }
                else {
                    msgStr = errDic[@"msg"];
                }
            }
            UIAlertController *errAlert = [UIAlertController alertControllerWithTitle:nil message:msgStr preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
            [errAlert addAction:sureAction];
            [strongSelf presentViewController:errAlert animated:YES completion:nil];
        }
    }];
    
}

- (void)updateLogBtn {
    static dispatch_once_t disOnce;
    __weak typeof(self) weakSelf = self;
    dispatch_once(&disOnce,^ {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        dispatch_async(dispatch_get_main_queue(), ^{
            strongSelf.voiceBtn.userInteractionEnabled = NO;
            NSAttributedString *muteAttrStr = [[NSAttributedString alloc] initWithString:@"已经发送，请注意接听手机来电" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#FC9900"]}];
            [strongSelf.voiceBtn setAttributedTitle:muteAttrStr forState:UIControlStateNormal];
        });
        
    });
}

- (void)updateAfterLogBtn {
    if (self.code && self.code.length > 3) {
        _loginBtn.userInteractionEnabled = YES;
        [_loginBtn setBackgroundColor:[LicenseTool sharedInstance].configInfo[@"themeColor"]];
    } else {
        _loginBtn.userInteractionEnabled = NO;
        [_loginBtn setBackgroundColor:[LicenseTool sharedInstance].configInfo[@"btnUnColor"]];
    }
}

- (void)showQuickNoteViewController:(NSDictionary *)dic {
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"TestSkillViewController" bundle:nil];
    TrainRecordViewController * lvc = [sb instantiateViewControllerWithIdentifier:@"LFBookDetailViewController"];
    lvc.config = dic;
    [UIApplication sharedApplication].keyWindow.rootViewController = lvc;
}

- (ProtocolRemindView *)moreRecordView {
    if (!_moreRecordView) {
        _moreRecordView = [[ProtocolRemindView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) fromVC:self];
    }
    return _moreRecordView;
}

- (NSArray *)selectImgArr {
    if (!_selectImgArr) {
        _selectImgArr = @[@"btn_unselected", @"btn_selected"];
    }
    return _selectImgArr;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


@end
