//
//  BBQuestionView.m
//  License
//
//  Created by wei on 2019/7/19.
//  Copyright © 2019年 wei. All rights reserved.
//

#import "BBQuestionView.h"

@implementation BBQuestionView

- (instancetype)initWithFrame:(CGRect)frame subject:(int)subject;{
    self = [super initWithFrame:frame];
    if(self){
        NSArray*titles=@[@"考试科目",@"考试题库",@"考试标准",@"合格标准",@"出题规则"];
        NSString*tiku=@"";
        if([CommandManager sharedManager].subType==0){
            tiku=@"小车C1/C2/C3";
        }else if ([CommandManager sharedManager].subType==1){
            tiku=@"货车A2/B2";
        }else if ([CommandManager sharedManager].subType==2){
            tiku=@"客车A1/A3/B1";
        }else{
            tiku=@"摩托车D/E/F";
        }
        NSArray*ansers;
        if(subject==0){
            ansers=@[@"科目一理论考试",tiku,@"100题，45分钟",@"90分及格",@"交管局出题规则"];
        }else{
            ansers=@[@"科目四理论考试",tiku,@"50题，45分钟",@"90分及格",@"交管局出题规则"];
        }
        NSString*promtString=@"温馨提示：答案不可修改，累计错题分数达到不及格标准时将提示交卷，考试不通过";
        //构建视图
        self.backgroundColor = KClearColor;
        UIView*alpv = [[UIView alloc] initWithFrame:self.bounds];
        alpv.backgroundColor = kblock;
        alpv.alpha = 0.6;
        [self addSubview:alpv];
        [alpv addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)]];
        
        float space = 23;
        float textHeight = 16.f;
        float itemSapce = 16.f;
        float width = BBWidth-40*2;
        float proHeight = [UILabel height:promtString font:PFontS(14) w:width-2*space];
        float height = space*3+proHeight+4*itemSapce+textHeight*5;
        UIView*cornorView = [[UIView alloc] initWithFrame:CGRectMake(self.width/2-width/2, self.height/2-height/2, width, height)];
        [self addSubview:cornorView];
        cornorView.backgroundColor = kwhite;
        cornorView.layer.cornerRadius=5.f;
        cornorView.layer.masksToBounds = YES;
        
        for(int i=0;i<ansers.count;i++){
            UILabel*lb1=[UILabel crateLabelWithTitle:titles[i] font:PFontS(14) color:[UIColor lightGrayColor] location:0];
            lb1.frame = CGRectMake(space, space+i*(itemSapce+textHeight), width-2*space, textHeight);
            [cornorView addSubview:lb1];
            
            UILabel*lb2=[UILabel crateLabelWithTitle:ansers[i] font:PFontS(14) color:kblock location:2];
            lb2.frame = CGRectMake(space, space+i*(itemSapce+textHeight), width-2*space, textHeight);
            [cornorView addSubview:lb2];
        }
        UILabel*lb3=[UILabel crateLabelWithTitle:promtString font:PFontS(14) color:kblock location:0];
        lb3.numberOfLines = 0;
        lb3.frame = CGRectMake(space, height-space-proHeight, width-2*space, proHeight);
        [cornorView addSubview:lb3];
        
    }
    return self;
}
- (void)tapAction{
    [self removeFromSuperview];
}
@end
