//
//  HomeCustomItemView.m
//  License
//
//  Created by wei on 2019/7/15.
//  Copyright © 2019年 wei. All rights reserved.
//

#import "HomeCustomItemView.h"

@interface HomeCustomItemView()
@property (nonatomic,strong)UIView*shadowView;
@property (nonatomic,strong)UIView*cornerView;
@property (nonatomic,strong)UILabel*subtitleLb;
@end

@implementation HomeCustomItemView

- (instancetype)initWithFrame:(CGRect)frame andInfo:(NSDictionary*)info;{
    self = [super initWithFrame:frame];
    if(self){
        self.itemClickSignal = [RACSubject subject];
        self.shadowView = [[UIView alloc] initWithFrame:self.bounds];
        self.shadowView.backgroundColor = KClearColor;
        self.shadowView.layer.shadowColor = [kblock colorWithAlphaComponent:0.2].CGColor;
        self.shadowView.layer.shadowOffset=CGSizeMake(0, 2);
        self.shadowView.layer.shadowOpacity = 2;
        self.shadowView.layer.shadowRadius = 4.0;
        [self addSubview:self.shadowView];
        
        self.cornerView = [[UIView alloc] initWithFrame:self.shadowView.bounds];
        self.cornerView.layer.cornerRadius = 8.f;
        self.cornerView.layer.masksToBounds = YES;
        self.cornerView.backgroundColor = kwhite;
        [self.shadowView addSubview:self.cornerView];
        
        if([[info objectForKey:@"type"] intValue]==0){
            UIImage*hotImg = BImage(@"ichot");
            UIImageView*hotImageV = [[UIImageView alloc] initWithImage:hotImg];
            hotImageV.frame = CGRectMake(0, 0, 40, 40);
            [self.cornerView addSubview:hotImageV];
            
            float imgWidth = [HomeCustomItemView needHeight]/3.0+6;
            UIImageView*imageV = [[UIImageView alloc] init];
            imageV.frame = CGRectMake(self.width/3-imgWidth, self.height/2-imgWidth/2, imgWidth, imgWidth);
            imageV.image = BImage([info objectForKey:@"image"]);
            [self.cornerView addSubview:imageV];
            
            UILabel*lb = [UILabel crateLabelWithTitle:[info objectForKey:@"title"] font:PFontZ(17) color:kblue location:0];
            lb.frame = CGRectMake(self.width/3+12, imageV.top, 200, 17);
            [self.cornerView addSubview:lb];
            _subtitleLb = [UILabel crateLabelWithTitle:[info objectForKey:@"content"] font:PFontX(15) color:[kblue colorWithAlphaComponent:0.7] location:0];
            _subtitleLb.frame = CGRectMake(self.width/3+12, imageV.bottom-15, 200, 15);
            [self.cornerView addSubview:_subtitleLb];
            
            if([[info objectForKey:@"title"] isEqualToString:@"全真模拟"]){
                UIImage*promt = BImage(@"ic_promt");
                UIImageView*promtImageV = [[UIImageView alloc] initWithImage:promt];
                promtImageV.userInteractionEnabled=YES;
                promtImageV.frame = CGRectMake(self.cornerView.width-4-20, 4, 20, 20);
                [self.cornerView addSubview:promtImageV];
                [promtImageV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemTap)]];
            }
            
            
            
        }else{
            float imgWidth = [HomeCustomItemView needHeight]/3.0+6;
            UIImageView*imageV = [[UIImageView alloc] init];
            imageV.frame = CGRectMake(self.width/3-imgWidth, self.height/2-imgWidth/2, imgWidth, imgWidth);
            imageV.image = BImage([info objectForKey:@"image"]);
            [self.cornerView addSubview:imageV];
            
            UILabel*lb = [UILabel crateLabelWithTitle:[info objectForKey:@"title"] font:PFontZ(17) color:kblue location:0];
            lb.frame = CGRectMake(self.width/3+12, imageV.centerY-9, 200, 18);
            [self.cornerView addSubview:lb];
        }
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction)]];
    }
    return self;
}
- (void)tapGestureAction{
    [self.itemClickSignal sendNext:@1];
}
- (void)itemTap{
    [self.itemClickSignal sendNext:@10];
}
- (void)setSubtitle:(NSString*)subTitle;{
    _subtitleLb.text = subTitle;
}

+(float)needHeight;{
    if(_iPhone5){
        return 28*3;
    }
    return 33*3;
}

@end
