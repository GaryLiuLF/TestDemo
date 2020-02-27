//
//  ThemeItemAnserOptionCell.m
//  License
//
//  Created by wei on 2019/7/11.
//  Copyright © 2019年 wei. All rights reserved.
//

#import "ThemeItemAnserOptionCell.h"
@interface ThemeItemAnserOptionCell ()
@property (nonatomic,strong)UIView*corView;
@property (nonatomic,strong)UILabel*textLb;
@property (nonatomic,strong)UIImageView*selectView;
@property (nonatomic,strong)UILabel*contentLb;
@end

@implementation ThemeItemAnserOptionCell
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
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.corView = [[UIView alloc] initWithFrame:CGRectMake(23, 10, 20, 20)];
        self.corView.layer.shadowColor = [kblock colorWithAlphaComponent:0.3].CGColor;
        self.corView.layer.shadowOffset=CGSizeMake(0, 2);
        self.corView.layer.shadowOpacity = 2;
        self.corView.layer.shadowRadius = 2.0;
        [self.contentView addSubview:self.corView];
        
        self.textLb = [UILabel crateLabelWithTitle:@"" font:PFontS(13) color:kblock location:1];
        self.textLb.frame = self.corView.bounds;
        self.textLb.backgroundColor = kwhite;
        self.textLb.layer.cornerRadius = 10.f;
        self.textLb.layer.masksToBounds=YES;
        self.textLb.layer.borderColor = [kblock colorWithAlphaComponent:0.3].CGColor;
        [self.corView addSubview:self.textLb];
        
        self.selectView = [[UIImageView alloc] init];
        self.selectView.frame = self.corView.frame;
        [self.contentView addSubview:self.selectView];
        
        self.contentLb = [UILabel new];
        self.contentLb.frame = CGRectMake(self.corView.right+12, 10, BBWidth-(self.textLb.right+12), 20);
        [self.contentView addSubview:self.contentLb];
    }
    return self;
}
- (void)setModel:(ThemeItem *)model{
    _model = model;
    switch (model.anserType) {
        case ThemeItemAnserA:
        {
            self.textLb.text = @"A";
        }
            break;
        case ThemeItemAnserB:
        {
            self.textLb.text = @"B";
        }
            break;
        case ThemeItemAnserC:
        {
            self.textLb.text = @"C";
        }
            break;
        case ThemeItemAnserD:
        {
            self.textLb.text = @"D";
        }
            break;
        case ThemeItemAnserNone:
        {
            self.textLb.text = @"!";
        }
            break;
        default:
            break;
    }
//    ThemeItemStateNone = 1,//正常可选状态
//    ThemeItemStateError = 2,//直接选错，标记红色
//    ThemeItemStateCorrect = 3,//直接选对，标记蓝色
    //    ThemeItemStatelouxuan = 4,//系统正确状态
    //    ThemeItemStateNoAnser = 5 //不是答案，并未选择 系统普通状态

    switch (model.stateType) {
        case ThemeItemStateNone:
        {
            if(self.corView.hidden==YES){
                self.corView.hidden=NO;
            }
            self.corView.layer.shadowColor = [kblock colorWithAlphaComponent:0.3].CGColor;
            //self.corView.layer.shadowColor=KClearColor.CGColor;
            self.textLb.backgroundColor = kwhite;
            self.textLb.textColor = kblock;
            self.textLb.layer.borderWidth=0.0;
            self.contentLb.attributedText = [UILabel text:model.value textSpace:3 lineSpace:0 font:PFontX(16) color:kblock];
            if(self.selectView.hidden==NO){
                self.selectView.hidden=YES;
            }
        }
            break;
        case ThemeItemStateError:
        {
            if(self.selectView.hidden==YES){
                self.selectView.hidden=NO;
            }
            self.selectView.image=BImage(@"theme_error");
            if(self.corView.hidden==NO){
                self.corView.hidden=YES;
            }
            self.contentLb.attributedText = [UILabel text:model.value textSpace:3 lineSpace:0 font:PFontX(16) color:kColor(@"ffEB5252")];
            
        }
            break;
        case ThemeItemStateCorrect:
        {
            if(self.selectView.hidden==YES){
                self.selectView.hidden=NO;
            }
            self.selectView.image=BImage(@"theme_rigjt");
            if(self.corView.hidden==NO){
                self.corView.hidden=YES;
            }
            self.contentLb.attributedText = [UILabel text:model.value textSpace:3 lineSpace:0 font:PFontX(16) color:kblue];
        }
            break;
        case ThemeItemStatelouxuan:
        {
            if(self.selectView.hidden==NO){
                self.selectView.hidden=YES;
            }
            if(self.corView.hidden==YES){
                self.corView.hidden=NO;
            }
            self.corView.layer.shadowColor=KClearColor.CGColor;
            self.textLb.layer.borderWidth=0.0;
            self.textLb.backgroundColor = kblue;
            self.textLb.textColor = kwhite;
            self.contentLb.attributedText = [UILabel text:model.value textSpace:3 lineSpace:0 font:PFontX(16) color:kblue];
        }
            break;
        case ThemeItemStateNoAnser:
        {
            if(self.selectView.hidden==NO){
                self.selectView.hidden=YES;
            }
            if(self.corView.hidden==YES){
                self.corView.hidden=NO;
            }
            self.corView.layer.shadowColor=KClearColor.CGColor;
            self.textLb.layer.borderWidth=0.5;
            self.textLb.backgroundColor = kwhite;
            self.textLb.textColor = kblock;
            self.contentLb.attributedText = [UILabel text:model.value textSpace:3 lineSpace:0 font:PFontX(16) color:kblock];
        }
            break;
            
        default:
            break;
    }
    
}

+ (CGFloat)cellHightWithModel:(ThemeItem*)model;{
    return 20+20;
}
@end
