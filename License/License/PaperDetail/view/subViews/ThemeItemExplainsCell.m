//
//  ThemeItemExplainsCell.m
//  License
//
//  Created by wei on 2019/7/11.
//  Copyright © 2019年 wei. All rights reserved.
//

#import "ThemeItemExplainsCell.h"
@interface ThemeItemExplainsCell ()
@property (nonatomic,strong)UILabel*explainlb;
@end
@implementation ThemeItemExplainsCell
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
        
        UIView*blueView = [[UIView alloc] initWithFrame:CGRectMake(23, 10, 3, 14)];
        blueView.layer.cornerRadius = 0.5;
        blueView.layer.masksToBounds = YES;
        blueView.backgroundColor = kblue;
        [self.contentView addSubview:blueView];
        
        UILabel*lb = [UILabel crateLabelWithTitle:@"题目解析" font:PFontH(14) color:kblock location:0];
        lb.frame = CGRectMake(blueView.right+4, 10, 100, 14);
        [self.contentView addSubview:lb];
        
        self.explainlb = [UILabel crateLabelWithTitle:@"" font:PFontZ(14) color:kblock location:0];
        self.explainlb.numberOfLines = 0;
        [self.contentView addSubview:self.explainlb];
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
    self.explainlb.attributedText = [UILabel text:[NSString stringWithFormat:@"%@",model.value] textSpace:3 lineSpace:3 font:PFontZ(14) color:kblock];
    float height = [self.explainlb.attributedText boundingRectWithSize:CGSizeMake(BBWidth-23*2, 10000) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height;
    if(self.explainlb.height != height){
        self.explainlb.frame = BBRect(23, 10+14+10,BBWidth-23*2,height);;
    }
}

+ (CGFloat)cellHightWithModel:(ThemeItem*)model;{
    if(model.showed){
        CGSize size = [UILabel textRectWithString:[NSString stringWithFormat:@"      %@",model.value] maxWidth:BBWidth-23*2 andFont:PFontZ(14) andTextSpace:3 andLineSpace:3];
        return 10+14+10+size.height+10;
    }else return 0;
}
@end
