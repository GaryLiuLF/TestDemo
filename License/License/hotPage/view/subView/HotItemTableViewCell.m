//
//  HotItemTableViewCell.m
//  License
//
//  Created by wei on 2019/7/17.
//  Copyright © 2019年 wei. All rights reserved.
//

#import "HotItemTableViewCell.h"
@interface HotItemTableViewCell()
@property (nonatomic,strong)UILabel*titellb;
@property (nonatomic,strong)UIView*pointV;
@end
@implementation HotItemTableViewCell

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
        
        _pointV = [[UIView alloc] initWithFrame:CGRectMake(23, 10+15/2-10.f/2, 10.f, 10.f)];
        _pointV.backgroundColor = kblue;
        _pointV.layer.cornerRadius = 5.f;
        _pointV.layer.masksToBounds = YES;
        [self.contentView addSubview:_pointV];
        
        _titellb = [UILabel crateLabelWithTitle:@"" font:PFontX(15) color:kblue location:0];
        _titellb.numberOfLines = 0;
        [self.contentView addSubview:_titellb];
        @weakify(self);
        [_titellb mas_updateConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.left.equalTo(self.titellb.superview).with.offset((23+10.f+8.f));
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
    float x = [UILabel height:item.value font:PFontX(15) w:BBWidth-23-(23+10.f+8.f)];
    return x+17.f;
}
@end
