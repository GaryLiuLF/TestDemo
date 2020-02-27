//
//  HotPicTableViewCell.m
//  License
//
//  Created by wei on 2019/7/17.
//  Copyright © 2019年 wei. All rights reserved.
//

#import "HotPicTableViewCell.h"
@interface HotPicTableViewCell()
@property (nonatomic,strong)UIImageView*imagev;
@property (nonatomic,strong)MASConstraint *masHeight;
@end
@implementation HotPicTableViewCell

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
        _imagev = [[UIImageView alloc] init];
        [self.contentView addSubview:_imagev];
    }
    return self;
}
- (void)setItem:(HotItem *)item{
    _item = item;
    [_imagev sd_setImageWithURL:[NSURL URLWithString:@"http://ww1.sinaimg.cn/mw600/5eb4d75agw1e28yojmwsjj.jpg"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if(image.size.width<=BBWidth-80){
            [_imagev mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.imagev.mas_left).with.offset(BBWidth/2-image.size.width/2);
                make.top.equalTo(self.imagev.mas_top).with.offset(8);
                make.right.equalTo(self.imagev.mas_right).with.offset(-(BBWidth/2-image.size.width/2));
                make.height.mas_equalTo(image.size.height);
                self.masHeight = make.height.mas_greaterThanOrEqualTo(@16);
            }];
        }else{
            [_imagev mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.imagev.mas_left).with.offset(40);
                make.top.equalTo(self.imagev.mas_top).with.offset(8);
                make.right.equalTo(self.imagev.mas_right).with.offset(-40);
                make.height.mas_equalTo((BBWidth-80)*image.size.height/image.size.width);
                self.masHeight = make.height.mas_greaterThanOrEqualTo(@16);
            }];
        }
    }];
}

+ (CGFloat)cellHightWithItem:(HotItem*)item;{
    return 80.f;
}
@end
