//
//  BBWrongCell.m
//  License
//
//  Created by wei on 2019/7/23.
//  Copyright © 2019年 wei. All rights reserved.
//

#import "BBWrongCell.h"

@implementation BBWrongCell

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
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
        
        _titelLb = [UILabel crateLabelWithTitle:@"" font:PFontH(15) color:kblue location:0];
        //_titelLb.frame = BBRect(12, 17/2, 28, 28);
        _titelLb.numberOfLines = 0;
        [self.contentView addSubview:_titelLb];
        
        _subLb = [UILabel crateLabelWithTitle:@"" font:PFontX(14) color:kblue location:0];
        //_titelLb.frame = BBRect(12, 17/2, 28, 28);
        _subLb.numberOfLines = 0;
        [self.contentView addSubview:_subLb];
        
        _wrongLb = [UILabel crateLabelWithTitle:@"" font:PFontX(15) color:kred location:2];
        _wrongLb.frame = BBRect(BBWidth-32-4-100, 0, 100, 50);
        _wrongLb.numberOfLines = 0;
        [self.contentView addSubview:_wrongLb];
        
        _arrowView = [[UIImageView alloc] init];
        _arrowView.frame = BBRect(BBWidth-12-20, 15, 20, 20);
        _arrowView.image = BImage(@"icon_rightArrow");
        [self.contentView addSubview:_arrowView];
        
    }
    return self;
}
- (void)setModel:(WrongModel *)model{
    _model = model;
    _titelLb.text = model.title;
    _subLb.text = model.subTitle;
    _wrongLb.text = [NSString stringWithFormat:@"%d道",model.wrongNumber];
    if(model.subTitle.length>0){
        _titelLb.frame = BBRect(15, 7, 100, 20);
        _subLb.frame = BBRect(15, 27+2, 100, 13);
    }else{
        _titelLb.frame = BBRect(15, 0, 100, 50);
    }
    
}

@end
