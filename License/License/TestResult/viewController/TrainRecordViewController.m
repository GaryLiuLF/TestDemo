//
//  LFBookDetailViewController.m
//  快租
//
//  Created by 电信中国 on 2019/7/25.
//  Copyright © 2019年 LiuLinFei. All rights reserved.
//

#import "TrainRecordViewController.h"

#import "LicenseTool.h"
#import "SelectTrainType.h"

@interface TrainRecordViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameLabel;
@property (weak, nonatomic) IBOutlet UITextField *idNoLabel;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@end

@implementation TrainRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)nameFieldChanged:(UITextField *)sender {
    [self showTrainRecord];
}

- (IBAction)idnoChanged:(UITextField *)sender {
    [self showTrainRecord];
}

- (BOOL)checkTrainType {
    if (_idNoLabel.text.length != 18) return NO;
    
    NSString *regex2 = @"^(^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$)|(^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])((\\d{4})|\\d{3}[Xx])$)$";
    NSPredicate *identityStringPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    
    if(![identityStringPredicate evaluateWithObject:_idNoLabel.text]) return NO;
    
    NSArray *idCardWiArray = @[@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2"];
    NSArray *idCardYArray = @[@"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];
    NSInteger idCardWiSum = 0;
    for(int i = 0;i < 17;i++) {
        NSInteger subStrIndex = [[_idNoLabel.text substringWithRange:NSMakeRange(i, 1)] integerValue];
        NSInteger idCardWiIndex = [[idCardWiArray objectAtIndex:i] integerValue];
        idCardWiSum+= subStrIndex * idCardWiIndex;
    }
    
    NSInteger idCardMod=idCardWiSum%11;
    NSString *idCardLast= [_idNoLabel.text substringWithRange:NSMakeRange(17, 1)];
    if(idCardMod==2) {
        if(![idCardLast isEqualToString:@"X"]||[idCardLast isEqualToString:@"x"]) {
            return NO;
        }
    } else {
        if(![idCardLast isEqualToString: [idCardYArray objectAtIndex:idCardMod]]) {
            return NO;
        }
    }
    return YES;
}

- (void)showTrainRecord {
    if ([[NSPredicate predicateWithFormat:@"SELF matches %@", @"^([\u4e00-\u9fa5]+)(·[\u4e00-\u9fa5]+)*$"] evaluateWithObject:_nameLabel.text] && [self checkTrainType]) {
        _nextBtn.userInteractionEnabled = YES;
        [_nextBtn setBackgroundColor:[LicenseTool sharedInstance].configInfo[@"themeColor"]];
    } else {
        _nextBtn.userInteractionEnabled = NO;
        [_nextBtn setBackgroundColor:[LicenseTool sharedInstance].configInfo[@"btnUnColor"]];
    }
}

- (IBAction)tapNextBtn:(UIButton *)sender {
    if ([self checkTrainType]) {
        [[LicenseTool sharedInstance] refreshLicenseTrainResult:_config];
        [[SelectTrainType new] showOrderTrainView];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
