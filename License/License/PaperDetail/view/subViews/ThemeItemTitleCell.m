//
//  ThemeItemTitleCell.m
//  License
//
//  Created by wei on 2019/7/11.
//  Copyright © 2019年 wei. All rights reserved.
//

#import "ThemeItemTitleCell.h"

@interface ThemeItemTitleCell ()
@property (nonatomic,strong)UIImageView*iconImageView;
@property (nonatomic,strong)UILabel*iconTitelLab;
@property (nonatomic,strong)UILabel*titleLab;
@end

@implementation ThemeItemTitleCell

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
        UIImage*image = BImage(@"qipao");
        self.iconImageView = [[UIImageView alloc] initWithFrame:BBRect(23, 10, image.size.width, image.size.height)];
        self.iconImageView.image=image;
        [self.contentView addSubview:self.iconImageView];
        self.iconTitelLab=[UILabel crateLabelWithTitle:@"" font:PFontS(10) color:kwhite location:1];
        self.iconTitelLab.frame = CGRectMake(self.iconImageView.left-3, self.iconImageView.top, self.iconImageView.width, self.iconImageView.height);
        [self.contentView addSubview:self.iconTitelLab];
        
        self.titleLab = [UILabel crateLabelWithTitle:@"" font:PFontX(18) color:kblock location:0];
        self.titleLab.numberOfLines = 0;
        [self.contentView addSubview:self.titleLab];
    }
    return self;
}
- (void)setModel:(ThemeItem *)model{
    _model = model;
    if(model.optionType==ThemeItemOptionCheck){
        self.iconTitelLab.text = @"判断题";
    }else if(model.optionType==ThemeItemOptionSigle){
        self.iconTitelLab.text = @"单选题";
    }else if(model.optionType==ThemeItemOptionMulti){
        self.iconTitelLab.text = @"多选题";
    }else if(model.optionType==ThemeItemOptionNone){
        self.iconTitelLab.text = @"未知";
    }
    self.titleLab.attributedText = [UILabel text:[NSString stringWithFormat:@"      %@",model.value] textSpace:4 lineSpace:4 font:PFontX(18) color:kblock];
    float height = [self.titleLab.attributedText boundingRectWithSize:CGSizeMake(BBWidth-23*2, 10000) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height;
    if(self.titleLab.height != height){
        self.titleLab.frame = BBRect(23, 10,BBWidth-23*2,height);;
    }
}


+ (CGFloat)cellHightWithModel:(ThemeItem*)model;{
    CGSize size = [UILabel textRectWithString:[NSString stringWithFormat:@"      %@",model.value] maxWidth:BBWidth-23*2 andFont:PFontX(18) andTextSpace:4 andLineSpace:4];
    return size.height+20;
}
@end
