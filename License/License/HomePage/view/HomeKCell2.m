//
//  HomeKCell2.m
//  License
//
//  Created by wei on 2019/7/14.
//  Copyright © 2019年 wei. All rights reserved.
//

#import "HomeKCell2.h"
#import "HomeCustomItemView.h"
@interface HomeKCell2()

@property (nonatomic,strong) UIScrollView *scrollView;

@end
@implementation HomeKCell2
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.itemClickSignal = [RACSubject subject];
        self.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:self.scrollView];
        
        NSArray*array = @[@{@"image":@"ic_shunxu",@"title":@"顺序训练",@"content":@"(共1300题：已做：5题)",@"type":@"0"},
                          @{@"image":@"ic_suiji",@"title":@"随机训练",@"content":@"(共1300题：已做：5题)",@"type":@"1"},
                          @{@"image":@"ic_zhuanxiang",@"title":@"专项练习",@"content":@"(共1300题：已做：5题)",@"type":@"1"},
                          @{@"image":@"ic_moni",@"title":@"全真模拟",@"content":@"完全模拟真实考试环境",@"type":@"0"},
                          @{@"image":@"ic_xuzhi",@"title":@"考试技巧",@"content":@"(共1300题：已做：5题)",@"type":@"1"},
                          @{@"image":@"ic_jilu",@"title":@"考试记录",@"content":@"(共1300题：已做：5题)",@"type":@"1"},
                          @{@"image":@"ic_kaoshi",@"title":@"科四考试预约报名",@"content":@"取消预约报名费可退",@"type":@"0"}];
        float height = [HomeCustomItemView needHeight];
        float sapce = 0.0;
        if(_iPhone5){
            sapce = 15;
        }else{
            sapce = 20.0;
        }
        
        self.scrollView.contentSize = CGSizeMake(self.width, self.height+height+20);
        
        for(int i=0;i<array.count;i++){
            CGRect rect;
            if(i==0){
                rect = CGRectMake(23, 10, BBWidth-23*2, height);
            }else if (i==1){
                rect = CGRectMake(23, 10+(sapce+height), (BBWidth-23*2-sapce)/2, height);
            }else if (i==2){
                rect = CGRectMake(BBWidth-23-(BBWidth-23*2-sapce)/2, 10+(sapce+height), (BBWidth-23*2-sapce)/2, height);
            }else if (i==3){
                rect = CGRectMake(23, 10+(sapce+height)*2, BBWidth-23*2, height);
            }else if (i==4){
                rect = CGRectMake(23, 10+(sapce+height)*3, (BBWidth-23*2-sapce)/2, height);
            }else if (i==5){
                rect = CGRectMake(BBWidth-23-(BBWidth-23*2-sapce)/2, 10+(sapce+height)*3, (BBWidth-23*2-sapce)/2, height);
            }else {
                rect = CGRectMake(23, 10+(sapce+height)*4, BBWidth-23*2, height);
            }
            HomeCustomItemView*itemView = [[HomeCustomItemView alloc] initWithFrame:rect andInfo:array[i]];
            itemView.tag = 100+i;
            [self.scrollView addSubview:itemView];
            @weakify(self);
            [itemView.itemClickSignal subscribeNext:^(id x) {
                @strongify(self);
                if([x integerValue]==10){
                    [self.itemClickSignal sendNext:@(10)];
                }else{
                    [self.itemClickSignal sendNext:@(i)];
                }
            }];
        }
    }
    [self refrsh];
    return self;
}
- (void)refrsh;{
    HomeCustomItemView*itemView = [self viewWithTag:100];
    if(itemView){
        NSArray*array = [[DBTool sharedDB] getSunxuDatasWithSubType:2];
        [itemView setSubtitle:[NSString stringWithFormat:@"共:%ld题 已答:%ld题",[array[0] integerValue],[array[1] integerValue]]];
    }
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

@end

