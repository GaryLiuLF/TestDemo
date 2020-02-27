//
//  LearnTypeView.m
//  License
//
//  Created by wei on 2019/7/10.
//  Copyright © 2019年 wei. All rights reserved.
//

#import "LearnTypeView.h"
@interface LearnTypeView()
@property (nonatomic,strong)UIImageView*imageV;
@property (nonatomic,strong)UIImageView*selectView;
@property (nonatomic,strong)UILabel*titleLabel;
@property (nonatomic,strong)UILabel*subtitleLabel;


@end
@implementation LearnTypeView

- (instancetype)initWithFrame:(CGRect)frame;{
    self = [super initWithFrame:frame];
    if(self){
        self.valueSiganl = [RACSubject subject];
        self.imageV = [[UIImageView alloc] initWithFrame:BBRect(self.width/2-40, 10, 80, 80)];
        self.imageV.userInteractionEnabled = YES;
        [self addSubview:self.imageV];
        
        self.selectView=[[UIImageView alloc] initWithFrame:BBRect(self.width-30, 10,20 , 20)];
        self.selectView.image=BImage(@"icoSelect");
        self.selectView.hidden = YES;
        [self addSubview:self.selectView];
        
        
        self.titleLabel = [UILabel crateLabelWithTitle:@"" font:PFontX(18) color:kColor(@"ff575757") location:1];
        _titleLabel.frame = BBRect(-15,self.imageV.bottom-7,self.width+30,18);
        [self addSubview:_titleLabel];
        
        self.subtitleLabel = [UILabel crateLabelWithTitle:@"" font:PFontX(16) color:kColor(@"ff575757") location:1];
        _subtitleLabel.frame = BBRect(-15,_titleLabel.bottom+2,self.width+30 ,16);
        [self addSubview:_subtitleLabel];
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)]];
    }
    return self;
}
- (void)setType:(kLearnCarType)type{
    _type = type;
    switch (type) {
        case kLearncar:
        {
            self.imageV.image=BImage(@"car1");
            self.titleLabel.text=@"小车";
            self.subtitleLabel.text=@"（C1，C2，C3）";
            
        }
            break;
        case kLearnvan:
        {
            self.imageV.image=BImage(@"car2");
            self.titleLabel.text=@"货车";
            self.subtitleLabel.text=@"（A2，B2）";
        }
            break;
        case kLearnbus:
        {
            self.imageV.image=BImage(@"car3");
            self.titleLabel.text=@"客车";
            self.subtitleLabel.text=@"（A1，A3，B1）";
        }
            break;
        case kLearnmotorcycle:
        {
            self.imageV.image=BImage(@"car4");
            self.titleLabel.text=@"摩托车";
            self.subtitleLabel.text=@"（D，E，F）";
        }
            break;
        default:
            break;
    }
}
- (void)setIsSelect:(BOOL)isSelect{
    _isSelect = isSelect;
    if(_isSelect){
        if(self.selectView.hidden==YES){
            self.selectView.hidden=NO;
        }
    }else{
        if(self.selectView.hidden==NO){
            self.selectView.hidden=YES;
        }
    }
}
- (void)tapAction{
    [self.valueSiganl sendNext:@1];
}

@end
