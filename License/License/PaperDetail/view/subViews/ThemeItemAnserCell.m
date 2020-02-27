//
//  ThemeItemAnserCell.m
//  License
//
//  Created by wei on 2019/7/11.
//  Copyright © 2019年 wei. All rights reserved.
//

#import "ThemeItemAnserCell.h"
@interface ThemeItemAnserCell ()
@property (nonatomic,strong)UILabel*anserLab;
@end
@implementation ThemeItemAnserCell
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
        self.anserLab = [UILabel crateLabelWithTitle:@"" font:PFontZ(18) color:kblock location:0];
        self.anserLab.backgroundColor = kColor(@"ffF6F6F6");
        self.anserLab.layer.cornerRadius = 5.f;
        self.anserLab.layer.masksToBounds = YES;
        self.anserLab.frame = CGRectMake(23, 10, BBWidth-23*2, 40);
        [self.contentView addSubview:self.anserLab];
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
    _anserLab.text = [NSString stringWithFormat:@"  本题答案: %@",model.value];
}

+ (CGFloat)cellHightWithModel:(ThemeItem*)model;{
    if(model.showed){
        return 60;
    }else return 0;
}
@end
