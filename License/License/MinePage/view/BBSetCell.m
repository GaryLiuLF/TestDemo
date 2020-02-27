//
//  BBSetCell.m
//  License
//
//  Created by wei on 2019/7/23.
//  Copyright © 2019年 wei. All rights reserved.
//

#import "BBSetCell.h"

@implementation BBSetCell

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
        self.valueSignal = [RACSubject subject];
        
        _iconView = [[UIImageView alloc] init];
        _iconView.frame = BBRect(12, 15, 24, 24);
        [self.contentView addSubview:_iconView];
        
        _textLb = [UILabel crateLabelWithTitle:@"" font:PFontX(16) color:kblock location:0];
        _textLb.frame = BBRect(_iconView.right+8, 13, 200, 28);
        _textLb.numberOfLines = 0;
        [self.contentView addSubview:_textLb];
        
        _switchView = [[UISwitch alloc] init];
        [_switchView addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        _switchView.frame = BBRect(BBWidth-12-50, 12, 50, 30);
        _switchView.tintColor = kblue;
        _switchView.onTintColor =kblue;
        [self.contentView addSubview:_switchView];
        
        _arrowView = [[UIImageView alloc] init];
        _arrowView.frame = BBRect(BBWidth-12-20, 17, 20, 20);
        _arrowView.image = BImage(@"icon_rightArrow");
        [self.contentView addSubview:_arrowView];
        
    }
    return self;
}
- (void)setModel:(BBSetModel *)model{
    _model = model;
    _iconView.image = BImage(model.imageName);
    _textLb.text = model.title;
    if(model.needSwith){
        if(_switchView.hidden==YES){
            _switchView.hidden=NO;
        }
        if(_arrowView.hidden==NO){
            _arrowView.hidden=YES;
        }
        _switchView.on = model.isOn;
    }else{
        if(_switchView.hidden==NO){
            _switchView.hidden=YES;
        }
        if(_arrowView.hidden==YES){
            _arrowView.hidden=NO;
        }
    }
}
- (void)switchAction:(UISwitch*)sender{
    [self.valueSignal sendNext:@(sender.on)];
}

@end
