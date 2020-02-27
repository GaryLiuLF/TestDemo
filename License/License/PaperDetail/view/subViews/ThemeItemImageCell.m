//
//  ThemeItemImageCell.m
//  License
//
//  Created by wei on 2019/7/11.
//  Copyright © 2019年 wei. All rights reserved.
//

#import "ThemeItemImageCell.h"
@interface ThemeItemImageCell ()
@property (nonatomic,strong)UIImageView*imgView;

@end
@implementation ThemeItemImageCell
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
        _imgView = [[UIImageView alloc] init];
        [self.contentView addSubview:_imgView];
    }
    return self;
}
- (void)setModel:(ThemeItem *)model{
    _model = model;
    float x = [[CommandManager sharedManager] getImageHeightWithUrl:model.value];
    if(x==0.f){
        if(_imgView.hidden==NO) _imgView.hidden=YES;
        @weakify(self);
        [_imgView sd_setImageWithURL:[NSURL URLWithString:model.value] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            @strongify(self);
            if(image && [self.model.value isEqualToString:imageURL.absoluteString]){
                CGSize size = image.size;
                float needHeight = 0.0;
                if(size.width>BBWidth-23*2){
                    needHeight = (BBWidth-23*2)*size.height/size.width;
                }else{
                    needHeight = size.height;
                }
                [[CommandManager sharedManager] setImageUrl:model.value andValue:@(needHeight)];
                [self.valueSignal sendNext:@1];
            }
        }];
    }else{
        if(_imgView.hidden==YES) _imgView.hidden=NO;
        [_imgView sd_setImageWithURL:[NSURL URLWithString:model.value] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if(image && [self.model.value isEqualToString:imageURL.absoluteString]){
                CGSize size = image.size;
                if(size.width>BBWidth-23*2){
                    self.imgView.frame = CGRectMake(23, 10, BBWidth-23*2, (BBWidth-23*2)*size.height/size.width);
                }else{
                    self.imgView.frame = CGRectMake(BBWidth/2-size.width/2, 10, size.width, size.height);
                }
            }
        }];
    }
}


+ (CGFloat)cellHightWithModel:(ThemeItem*)model;{
    float x = [[CommandManager sharedManager] getImageHeightWithUrl:model.value];
    if(x>0){
        return x+20.f;
    }
    return 0;
}
@end
