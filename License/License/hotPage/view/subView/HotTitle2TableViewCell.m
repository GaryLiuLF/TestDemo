//
//  HotTitle2TableViewCell.m
//  License
//
//  Created by wei on 2019/7/17.
//  Copyright © 2019年 wei. All rights reserved.
//

#import "HotTitle2TableViewCell.h"
@interface HotTitle2TableViewCell()
@property (nonatomic,strong)UILabel*titellb;
@end
@implementation HotTitle2TableViewCell

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
        _titellb = [UILabel crateLabelWithTitle:@"" font:PFontH(15) color:[kblock colorWithAlphaComponent:0.8] location:0];
        _titellb.numberOfLines = 0;
        [self.contentView addSubview:_titellb];
        @weakify(self);
        [_titellb mas_updateConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.left.equalTo(self.titellb.superview).with.offset(23);
            make.right.equalTo(self.titellb.superview).with.offset(-23);
            make.top.equalTo(self.titellb.superview).with.offset(8);
            make.bottom.equalTo(self.titellb.superview).with.offset(-8);
        }];
    }
    return self;
}
- (void)setItem:(HotItem *)item{
    _item = item;
    _titellb.text = item.value;
}

+ (CGFloat)cellHightWithItem:(HotItem*)item;{
    float x = [UILabel height:item.value font:PFontH(15) w:BBWidth-23*2];
    return x+17.f;
}

@end
