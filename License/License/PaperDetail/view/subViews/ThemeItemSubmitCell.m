//
//  ThemeItemSubmitCell.m
//  License
//
//  Created by wei on 2019/7/11.
//  Copyright © 2019年 wei. All rights reserved.
//

#import "ThemeItemSubmitCell.h"
@interface ThemeItemSubmitCell ()
@property (nonatomic,strong)UIButton*submitBtn;
@end
@implementation ThemeItemSubmitCell
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.valueSignal = [RACSubject subject];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.submitBtn = [[UIButton alloc] initWithFrame:CGRectMake(BBWidth/2-70, 10, 140, 40)];
        self.submitBtn.backgroundColor = kblue;
        self.submitBtn.layer.cornerRadius = 4.f;
        self.submitBtn.layer.masksToBounds = YES;
        [self.submitBtn setTitle:@"提交答案" forState:UIControlStateNormal];
        [self.submitBtn setTitleColor:kwhite forState:UIControlStateNormal];
        [self.submitBtn addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
        self.submitBtn.titleLabel.font = PFontH(16);
        [self.contentView addSubview:self.submitBtn];
    }
    return self;
}
- (void)setModel:(ThemeItem *)model{
    _model = model;
    if(model.showed){
        if(self.contentView.hidden==YES){
            self.contentView.hidden=NO;
        }
    }else{
        if(self.contentView.hidden==NO){
            self.contentView.hidden=YES;
        }
    }
}
- (void)setCanSubmitAnser:(BOOL)canSubmitAnser{
    _canSubmitAnser = canSubmitAnser;
    if(canSubmitAnser==YES){
        self.submitBtn.backgroundColor = kblue;
        self.submitBtn.userInteractionEnabled=YES;
    }else{
        self.submitBtn.backgroundColor = [UIColor lightGrayColor];
        self.submitBtn.userInteractionEnabled = NO;
    }
}
- (void)submitAction{
    [self.valueSignal sendNext:@1];
}

+ (CGFloat)cellHightWithModel:(ThemeItem*)model;{
    if(model.showed){
        return 60;
    }else return 0;
}
@end
