//
//  ApplyDetailView.m
//  License
//
//  Created by 电信中国 on 2019/9/3.
//  Copyright © 2019 wei. All rights reserved.
//

#import "ApplyDetailView.h"
#import <MGIDCard/MGIDCard.h>

#import <AVFoundation/AVFoundation.h>

@implementation ApplyDetailView

@end

@interface ApplyDetailView_One ()

@property (nonatomic, strong) UILabel *nameLb;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *titleLb;
@property (nonatomic, strong) UILabel *subTitleLb;

@end

@implementation ApplyDetailView_One

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setup];
    }
    return self;
}

- (void)setup {
    UILabel *nameLb = [[UILabel alloc]init];
    nameLb.font = [UIFont systemFontOfSize:16];
    nameLb.textAlignment = NSTextAlignmentLeft;
    nameLb.text = @"考试地点:";
    [self addSubview:nameLb];
    self.nameLb = nameLb;
    
    UIView *contentView = [[UIView alloc]init];
    contentView.backgroundColor = [UIColor colorWithHexString:@"#DCEBF7"];
    contentView.layer.cornerRadius = 3;
    [self addSubview:contentView];
    self.contentView = contentView;
    
    UILabel *titleLb = [[UILabel alloc]init];
    titleLb.textAlignment = NSTextAlignmentLeft;
    titleLb.font = [UIFont boldSystemFontOfSize:15];
    titleLb.textColor = [UIColor colorWithHexString:@"#0F2C39"];
    [self.contentView addSubview:titleLb];
    self.titleLb = titleLb;
    
    UILabel *subTitleLb = [[UILabel alloc]init];
    subTitleLb.textAlignment = NSTextAlignmentLeft;
    subTitleLb.font = [UIFont boldSystemFontOfSize:11];
    subTitleLb.textColor = [UIColor colorWithHexString:@"#B1AEB0"];
    [self.contentView addSubview:subTitleLb];
    self.subTitleLb = subTitleLb;
}

- (void)setInfoDic:(NSDictionary *)infoDic {
    self.titleLb.text = infoDic[@"name"];
    self.subTitleLb.text = [NSString stringWithFormat:@"地址：%@", infoDic[@"address"]];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(16);
        make.top.equalTo(self).offset(10);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(25);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(12);
        make.right.equalTo(self).offset(-90);
        make.height.mas_equalTo(65);
        make.top.equalTo(self.nameLb.mas_bottom).offset(5);
    }];
    
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-5);
        make.height.mas_equalTo(20);
        make.bottom.equalTo(self.contentView.mas_centerY);
    }];
    
    [self.subTitleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLb);
        make.top.equalTo(self.contentView.mas_centerY).offset(2);
        make.height.mas_equalTo(self.nameLb.mas_height);
        make.width.equalTo(self.titleLb);
    }];
}

@end

@interface ApplyDetailView_Two ()

@property (nonatomic, strong) UILabel *titleLb;
@property (nonatomic, strong) UIView *dateView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIButton *timeBtn_one;
@property (nonatomic, strong) UIButton *timeBtn_two;

@property (nonatomic, strong) NSMutableArray *dateBtns;

@property (nonatomic, copy) NSArray *dateArr;
@property (nonatomic, assign) NSInteger selectedTag;
@property (nonatomic, strong) UIButton *selectedTimeBtn;

@end

@implementation ApplyDetailView_Two

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setup];
    }
    return self;
}

- (void)setup {
    UILabel *titleLb = [[UILabel alloc]init];
    titleLb.font = [UIFont systemFontOfSize:16];
    titleLb.textAlignment = NSTextAlignmentLeft;
    titleLb.text = @"考试时间:";
    [self addSubview:titleLb];
    self.titleLb = titleLb;
    
    UIView *dateView = [[UIView alloc]init];
    [self addSubview:dateView];
    self.dateView = dateView;
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#F6F6F6"];
    [self addSubview:lineView];
    self.lineView = lineView;
    
    UIButton *timeBtn_one = [UIButton buttonWithType:UIButtonTypeCustom];
    [timeBtn_one setTitle:@"上午10:00" forState:UIControlStateNormal];
    [timeBtn_one setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    timeBtn_one.titleLabel.font = [UIFont boldSystemFontOfSize:10];
    timeBtn_one.layer.cornerRadius = 12;
    timeBtn_one.backgroundColor = [UIColor colorWithHexString:@"#0276C6"];
    timeBtn_one.layer.borderColor = [UIColor colorWithHexString:@"#0276C6"].CGColor;
    timeBtn_one.layer.borderWidth = 1;
    [self addSubview:timeBtn_one];
    self.timeBtn_one = timeBtn_one;
    
    UIButton *timeBtn_two = [UIButton buttonWithType:UIButtonTypeCustom];
    [timeBtn_two setTitle:@"下午03:00" forState:UIControlStateNormal];
    [timeBtn_two setTitleColor:[UIColor colorWithHexString:@"#0276C6"] forState:UIControlStateNormal];
    timeBtn_two.titleLabel.font = [UIFont boldSystemFontOfSize:10];
    timeBtn_two.backgroundColor = [UIColor whiteColor];
    timeBtn_two.layer.cornerRadius = 12;
    timeBtn_two.layer.borderColor = [UIColor colorWithHexString:@"#0276C6"].CGColor;
    timeBtn_two.layer.borderWidth = 1;
    [self addSubview:timeBtn_two];
    self.timeBtn_two = timeBtn_two;
    
    [self setupDateButton];
    
    [self.timeBtn_one  addTarget:self action:@selector(timeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.timeBtn_two  addTarget:self action:@selector(timeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.selectedTimeBtn = self.timeBtn_one;
}

- (void)setupDateButton {
    _dateBtns = [NSMutableArray array];
    _dateArr = [self getByDate];
    for (NSInteger i = 0; i < 6; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = 10+i;
        btn.layer.cornerRadius = 18;
        btn.titleLabel.font = [UIFont systemFontOfSize:10];
        [self.dateView addSubview:btn];
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i == 0) {
            [btn setTitle:@"今日" forState:UIControlStateNormal];
        } else {
            [btn setTitle:_dateArr[i] forState:UIControlStateNormal];
        }
        
        switch (i) {
            case 0:
            case 1:
            case 2:
            {
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                btn.backgroundColor = [UIColor colorWithHexString:@"#B4B4B4"];
                btn.enabled = NO;
            }
                break;
            case 3:
            {
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                btn.backgroundColor = [UIColor colorWithHexString:@"#0276C6"];
                btn.layer.borderColor = [UIColor colorWithHexString:@"#0276C6"].CGColor;
                btn.layer.borderWidth = 1;
                
                self.selectedTag = 13;
            }
                break;
            case 4:
            case 5:
            {
                [btn setTitleColor:[UIColor colorWithHexString:@"#0276C6"] forState:UIControlStateNormal];
                btn.backgroundColor = [UIColor whiteColor];
                btn.layer.borderColor = [UIColor colorWithHexString:@"#0276C6"].CGColor;
                btn.layer.borderWidth = 1;
            }
                break;
                
            default:
                break;
        }
        [_dateBtns addObject:btn];
    }
}

- (void)timeBtnAction:(UIButton *)sender {
    if (sender != self.selectedTimeBtn) {
        [self.selectedTimeBtn setTitleColor:[UIColor colorWithHexString:@"#0276C6"] forState:UIControlStateNormal];
        self.selectedTimeBtn.backgroundColor = [UIColor whiteColor];
        
        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        sender.backgroundColor = [UIColor colorWithHexString:@"#0276C6"];
        
        self.selectedTimeBtn = sender;
        
    }else{
        return;
    }
}

- (void)btnAction:(UIButton *)sender {
    
    if (sender.tag != self.selectedTag) {
        
        UIButton *oldBtn = [self viewWithTag:self.selectedTag];
        [oldBtn setTitleColor:[UIColor colorWithHexString:@"#0276C6"] forState:UIControlStateNormal];
        oldBtn.backgroundColor = [UIColor whiteColor];
        
        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        sender.backgroundColor = [UIColor colorWithHexString:@"#0276C6"];
        
        self.selectedTag = sender.tag;
        
    } else {
        return;
    }
}

- (NSArray *)getByDate{
    NSInteger dis = 5; //前后的天数
    NSDate*nowDate = [NSDate date];
    //NSDate* theDate;
    NSTimeInterval  oneDay = 24*60*60*1;  //1天的长度
    NSDate* theDate;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSMutableArray* dateArr = [NSMutableArray array];
    for (int i = 0; i<=dis; i++) {
        
        //几月几日
        theDate = [nowDate initWithTimeIntervalSinceNow: +oneDay*i ];
        formatter.dateFormat = @"M/d";
        [dateArr addObject:[formatter stringFromDate:theDate]];
    }
    return [dateArr copy];
}

- (NSString *)time {
    NSString *dateStr = [[_dateArr[self.selectedTag-10] stringByReplacingOccurrencesOfString:@"/" withString:@"月"]stringByAppendingString:@"日 "];
    
    return [dateStr stringByAppendingString:self.selectedTimeBtn.currentTitle];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(16);
        make.top.equalTo(self).offset(10);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(25);
    }];
    
    
    [self.dateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.top.equalTo(self.titleLb.mas_bottom).offset(8);
        make.width.mas_equalTo(250);
        make.height.mas_equalTo(40);
    }];
    
    [_dateBtns mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:36 leadSpacing:0 tailSpacing:0];
    [_dateBtns mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.dateView);
        make.height.mas_equalTo(36);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-100);
        make.top.equalTo(self).offset(20);
        make.bottom.equalTo(self).offset(-20);
        make.width.mas_equalTo(1);
    }];
    
    [self.timeBtn_one mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-20);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(24);
        make.bottom.equalTo(self.mas_centerY).offset(-4);
    }];
    
    [self.timeBtn_two mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeBtn_one.mas_left);
        make.width.mas_equalTo(self.timeBtn_one.mas_width);
        make.height.mas_equalTo(self.timeBtn_one.mas_height);
        make.top.equalTo(self.mas_centerY).offset(4);
    }];
}

@end

@interface ApplyDetailView_Three () <UITextFieldDelegate>

@property (nonatomic, strong) UILabel *titleLb;
@property (nonatomic, strong) UILabel *nameLb;
@property (nonatomic, strong) UITextField *nameTf;
@property (nonatomic, strong) UILabel *phoneLb;
@property (nonatomic, strong) UITextField *phoneTf;
@property (nonatomic, strong) UILabel *idcardLb;
@property (nonatomic, strong) UITextField *idcardTf;
@property (nonatomic, strong) UIView *line_one;
@property (nonatomic, strong) UIView *line_two;
@property (nonatomic, strong) UIView *line_three;

@end

@implementation ApplyDetailView_Three

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setup];
    }
    return self;
}

- (void)setup {
    UILabel *titleLb = [[UILabel alloc]init];
    titleLb.font = [UIFont systemFontOfSize:16];
    titleLb.textAlignment = NSTextAlignmentLeft;
    titleLb.text = @"学员信息:";
    [self addSubview:titleLb];
    self.titleLb = titleLb;
    
    self.nameLb     = [self setTitleLabel:@"姓名"];
    self.phoneLb    = [self setTitleLabel:@"手机号"];
    self.idcardLb   = [self setTitleLabel:@"身份证号"];
    
    self.nameTf     = [self setContentTextField:@"请输入申请人姓名"];
    self.phoneTf    = [self setContentTextField:@"请输入手机号码"];
    self.idcardTf   = [self setContentTextField:@"请输入身份证号"];
    
    self.line_one = [self setLineView];
    self.line_two = [self setLineView];
    self.line_three = [self setLineView];
}

/// 统一设置标题Label
- (UILabel *)setTitleLabel:(NSString *)title {
    UILabel *lb = [[UILabel alloc]init];
    lb.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
    lb.font = [UIFont systemFontOfSize:14];
    lb.textAlignment = NSTextAlignmentLeft;
    lb.text = title;
    [self addSubview:lb];
    return lb;
}

/// 统一设置内容TextField
- (UITextField *)setContentTextField:(NSString *)placeholder {
    UITextField *tf = [[UITextField alloc]init];
    tf.textColor = [UIColor colorWithHexString:@"#6E6E6E"];
    tf.font = [UIFont systemFontOfSize:14];
    tf.textAlignment = NSTextAlignmentRight;
    tf.placeholder = placeholder;
    tf.returnKeyType = UIReturnKeyDone;
    tf.delegate = self;
    [self addSubview:tf];
    return tf;
}

/// 统一设置横线Line
- (UIView *)setLineView {
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"#F6F6F6"];
    [self addSubview:line];
    return line;
}

#pragma mark - 代理
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return _isEdit;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField endEditing:YES];
    return YES;
}

- (NSString *)info {
    return [NSString stringWithFormat:@"%@/%@/%@", self.nameTf.text, self.phoneTf.text, self.idcardTf.text];
}

- (void)setInfo:(NSString *)info {
    NSArray *arr = [info componentsSeparatedByString:@"/"];
    self.nameTf.text = arr[0];
    self.phoneTf.text = arr[1];
    self.idcardTf.text = arr[2];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(16);
        make.top.equalTo(self).offset(10);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(25);
    }];
    
    [self.line_one mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(self);
        make.top.equalTo(self).offset(45);
        make.height.mas_equalTo(1);
    }];
    
    [self.nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(16);
        make.top.mas_equalTo(self.line_one.mas_bottom).offset(12);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(20);
    }];
    
    [self.nameTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameLb);
        make.left.mas_equalTo(self.nameLb.mas_right).offset(16);
        make.right.equalTo(self).offset(-24);
        make.height.mas_equalTo(20);
    }];
    
    [self.line_two mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(self);
        make.top.mas_equalTo(self.line_one.mas_bottom).offset(46);
        make.height.mas_equalTo(1);
    }];
    
    [self.phoneLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.line_two.mas_bottom).offset(12);
        make.left.equalTo(self).offset(16);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(20);
    }];
    
    [self.phoneTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.phoneLb);
        make.left.mas_equalTo(self.phoneLb.mas_right).offset(16);
        make.right.equalTo(self).offset(-24);
        make.height.mas_equalTo(20);
    }];
    
    [self.line_three mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.line_two.mas_bottom).offset(46);
        make.right.left.equalTo(self);
        make.height.mas_equalTo(1);
    }];
    
    [self.idcardLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.line_three.mas_bottom).offset(12);
        make.left.equalTo(self).offset(16);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(20);
    }];
    
    [self.idcardTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.idcardLb);
        make.left.mas_equalTo(self.phoneLb.mas_right).offset(16);
        make.right.equalTo(self).offset(-24);
        make.height.mas_equalTo(20);
    }];
}

@end

@interface ApplyDetailView_Four ()

@property (nonatomic, strong) UILabel *titleLb;
@property (nonatomic, strong) UIButton *idCardBtn1;
@property (nonatomic, strong) UIButton *idCardBtn2;
@property (nonatomic, strong) UILabel *idCardLab1;
@property (nonatomic, strong) UILabel *idCardLab2;

@end

@implementation ApplyDetailView_Four

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setup];
    }
    return self;
}

- (void)setup {
    UILabel *titleLb = [[UILabel alloc]init];
    titleLb.font = [UIFont systemFontOfSize:16];
    titleLb.textAlignment = NSTextAlignmentLeft;
    titleLb.text = @"报考身份证上传:";
    [self addSubview:titleLb];
    self.titleLb = titleLb;
    
    UIButton *idCardBtn1 = [[UIButton alloc]init];
    [idCardBtn1 setImage:[UIImage imageNamed:@"idCard0"] forState:UIControlStateNormal];
    [self addSubview:idCardBtn1];
    self.idCardBtn1 = idCardBtn1;
    [self.idCardBtn1 addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *idCardBtn2 = [[UIButton alloc]init];
    [idCardBtn2 setImage:[UIImage imageNamed:@"idCard1"] forState:UIControlStateNormal];
    [self addSubview:idCardBtn2];
    self.idCardBtn2 = idCardBtn2;
    [self.idCardBtn2 addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *idCardLab1 = [[UILabel alloc]init];
    idCardLab1.text = @"正面上传";
    idCardLab1.textColor = [UIColor grayColor];
    idCardLab1.font = [UIFont systemFontOfSize:12];
    idCardLab1.textAlignment = NSTextAlignmentCenter;
    [self addSubview:idCardLab1];
    self.idCardLab1 = idCardLab1;
    
    UILabel *idCardLab2 = [[UILabel alloc]init];
    idCardLab2.text = @"反面上传";
    idCardLab2.textColor = [UIColor grayColor];
    idCardLab2.font = [UIFont systemFontOfSize:12];
    idCardLab2.textAlignment = NSTextAlignmentCenter;
    [self addSubview:idCardLab2];
    self.idCardLab2 = idCardLab2;
    
}

- (void)btnAction:(UIButton *)sender {
    
    MGIDCardSide flag = IDCARD_SIDE_FRONT;
    NSString *typeStr;
    UILabel *showLb;
    if (sender == self.idCardBtn1) {
        flag = IDCARD_SIDE_FRONT;
        typeStr = @"正面";
        showLb = self.idCardLab1;
    }
    else if (sender == self.idCardBtn2) {
        flag = IDCARD_SIDE_BACK;
        typeStr = @"反面";
        showLb = self.idCardLab2;
    }
    
    if (![MGLicenseManager getLicense]) {
        [MGLicenseManager licenseForNetWokrFinish:^(bool License) {
            NSLog(@"%@", [NSString stringWithFormat:@"授权%@", License ? @"成功" : @"失败"]);
            if (!License) {
                [[[UIAlertView alloc] initWithTitle:@"提示" message:@"SDK授权失败，请检查" delegate:self cancelButtonTitle:@"完成" otherButtonTitles:nil, nil] show];
                return;
            }
        }];
    }
    
    NSString *mediaType = AVMediaTypeVideo;//读取媒体类型
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];//读取设备授权状态
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        [self setCameraAuthorizationStatus];
    }
    else {
        MGIDCardManager *cardManager = [[MGIDCardManager alloc] init];
        [cardManager setScreenOrientation:MGIDCardScreenOrientationLandscapeLeft];
        [cardManager IDCardStartDetection:[self getSuperVC:self]
                               IdCardSide:flag
                                   finish:^(MGIDCardModel *model) {
                                       [sender setImage:[model croppedImageOfIDCard] forState:UIControlStateNormal];
                                       showLb.text = [NSString stringWithFormat:@"%@认证成功", typeStr];
                                       showLb.textColor = [UIColor colorWithHexString:@"#0276C6"];
                                       flag == IDCARD_SIDE_FRONT ? _isFrontSuccess = YES : _isBackSuccess = YES;
                                   }
                                     errr:^(MGIDCardError errorType) {
                                         NSLog(@"errorType = %lu", (unsigned long)errorType);
                                         //                                         showLb.text = [NSString stringWithFormat:@"%@认证失败", typeStr];
                                         //                                         showLb.textColor = [UIColor redColor];
                                         flag == IDCARD_SIDE_FRONT ? _isFrontSuccess = NO : _isBackSuccess = NO;
                                     }];
    }
}

#pragma mark - 相机权限设置
- (void)setCameraAuthorizationStatus {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"应用相机权限受限,请在设置中启用" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionSet = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            if (@available(iOS 10.0, *)) {
                [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                }];
            } else {
                [[UIApplication sharedApplication] openURL:url];
            }
        }
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:cancelAction];
    [alert addAction:actionSet];
    [[self getSuperVC:self] presentViewController:alert animated:true completion:nil];
}

- (UIViewController *)getSuperVC:(UIView *)view {
    for (UIView* next = [view superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

- (BOOL)isFrontSuccess {
    return _isFrontSuccess;
}

- (BOOL)isBackSuccess {
    return _isBackSuccess;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(16);
        make.top.equalTo(self).offset(10);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(25);
    }];
    
    CGFloat w = (self.width-3*15)/2;
    CGFloat h = (w+15)/2;
    
    [self.idCardBtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(14);
        make.width.mas_equalTo(w);
        make.height.mas_equalTo(h);
        make.top.equalTo(self.titleLb.mas_bottom).offset(10);
    }];
    
    [self.idCardBtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.idCardBtn1.mas_right).offset(14);
        make.width.equalTo(self.idCardBtn1.mas_width);
        make.height.equalTo(self.idCardBtn1.mas_height);
        make.top.equalTo(self.idCardBtn1);
    }];
    
    [self.idCardLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.idCardBtn1);
        make.top.equalTo(self.idCardBtn1.mas_bottom).offset(4);
        make.height.mas_equalTo(20);
        make.right.equalTo(self.idCardBtn1);
    }];
    
    [self.idCardLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.idCardBtn2);
        make.top.equalTo(self.idCardBtn2.mas_bottom).offset(4);
        make.height.mas_equalTo(20);
        make.right.equalTo(self.idCardBtn2);
    }];
}

@end


@interface ApplyDetailView_Five ()

@property (nonatomic, strong) UILabel *priceLb;
@property (nonatomic, strong) UILabel *titleLb;
@property (nonatomic, strong) UILabel *subTitleLb;
@property (nonatomic, strong) UIButton *payBtn;

@end

@implementation ApplyDetailView_Five

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#0276C6"];
        [self setup];
    }
    return self;
}

- (void)setup {
    UILabel *priceLb = [[UILabel alloc]init];
    priceLb.textColor = [UIColor colorWithHexString:@"#0276C6"];
    priceLb.textAlignment = NSTextAlignmentCenter;
    priceLb.font = [UIFont boldSystemFontOfSize:18];
    priceLb.text = @"￥199";
    priceLb.backgroundColor = [UIColor whiteColor];
    [self addSubview:priceLb];
    self.priceLb = priceLb;
    
    UILabel *titleLb = [[UILabel alloc]init];
    titleLb.textAlignment = NSTextAlignmentCenter;
    titleLb.font = [UIFont boldSystemFontOfSize:14];
    titleLb.textColor = [UIColor whiteColor];
    titleLb.text = @"支付并预约";
    [self addSubview:titleLb];
    self.titleLb = titleLb;
    
    UILabel *subTitleLb = [[UILabel alloc]init];
    subTitleLb.textAlignment = NSTextAlignmentCenter;
    subTitleLb.font = [UIFont systemFontOfSize:10];
    subTitleLb.textColor = [UIColor whiteColor];
    subTitleLb.text = @"考试开始前取消预约报名费可退";
    [self addSubview:subTitleLb];
    self.subTitleLb = subTitleLb;
    
    UIButton *payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    payBtn.backgroundColor = [UIColor clearColor];
    [self addSubview:payBtn];
    self.payBtn = payBtn;
    
    [payBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)btnAction:(UIButton *)sender {
    if (self.applePayBlock) {
        self.applePayBlock();
    }
}

- (void)applePayBlock:(ApplePayBlock)block {
    self.applePayBlock = block;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.priceLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.width/3);
        make.left.equalTo(self);
        make.height.equalTo(self);
    }];
    
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.priceLb.mas_right).offset(5);
        make.right.equalTo(self).offset(-5);
        make.height.mas_equalTo(20);
        make.top.equalTo(self).offset(7);
    }];
    
    [self.subTitleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.priceLb.mas_right).offset(5);
        make.right.equalTo(self).offset(-5);
        make.height.mas_equalTo(15);
        make.top.equalTo(self.titleLb.mas_bottom).offset(2);
    }];
    
    [self.payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.width.mas_equalTo(self.width*2/3);
        make.height.equalTo(self);
    }];
}

@end


@interface ApplyDetailView_Six ()

@property (nonatomic, strong) UILabel *titleLb;
@property (nonatomic, strong) UILabel *contentLb;

@end

@implementation ApplyDetailView_Six

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setup];
    }
    return self;
}

- (void)setup {
    UILabel *titleLb = [[UILabel alloc]init];
    titleLb.font = [UIFont systemFontOfSize:16];
    titleLb.textAlignment = NSTextAlignmentLeft;
    titleLb.text = @"考试时间:";
    [self addSubview:titleLb];
    self.titleLb = titleLb;
    
    UILabel *contentLb = [[UILabel alloc]init];
    contentLb.font = [UIFont systemFontOfSize:12];
    contentLb.textAlignment = NSTextAlignmentLeft;
    contentLb.textColor = [UIColor colorWithHexString:@"#6E6E6E"];
    [self addSubview:contentLb];
    self.contentLb = contentLb;
}

- (void)setTime:(NSString *)time {
    self.contentLb.text = time;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(16);
        make.top.equalTo(self).offset(10);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(25);
    }];
    
    [self.contentLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(16);
        make.top.equalTo(self.titleLb.mas_bottom).offset(5);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(25);
    }];
}

@end
