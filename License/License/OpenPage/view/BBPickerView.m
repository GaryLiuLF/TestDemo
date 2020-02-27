//
//  FCEditPikerView.m
//  FocusUser
//
//  Created by wei on 2018/1/17.
//  Copyright © 2018年 wei. All rights reserved.
//

#import "BBPickerView.h"

@implementation BBPickerView

- (id)initWithFrame:(CGRect)frame;{
    self = [super initWithFrame:frame];
    if(self){
        self.valuesignal=[RACSubject subject];
        self.backgroundColor = [UIColor clearColor];
        self.mainView = [[UIView alloc] initWithFrame:frame];
        self.mainView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.mainView];
        
        UITapGestureRecognizer*tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [self.mainView addGestureRecognizer:tap];
        
        _animationView = [[UIView alloc] initWithFrame:BBRect(0, BBHeight, BBWidth, 256+BBToolBot)];
        _animationView.backgroundColor = [UIColor whiteColor];
        _animationView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        _animationView.layer.shadowOffset = CGSizeMake(-1, -1);
        _animationView.layer.shadowOpacity = .3;
        _animationView.layer.shadowRadius = 2.0;
        [self addSubview:_animationView];
        
//        UIView*lineView = [[UIView alloc] initWithFrame:BBRect(0, 0, BBWidth, 1.0)];
//        lineView.backgroundColor = kblock;
//        [_animationView addSubview:lineView];
        UIButton*button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button setFrame:BBRect(BBWidth-15-60, 0, 60, 40)];
        button.titleLabel.font = PFontZ(17);
        [button setTitle:@"完成" forState:UIControlStateNormal];
        [button setTitleColor:kblue forState:UIControlStateNormal];
        [button addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [button clickEnlargeEdgeWithTop:0 right:15 bottom:0 left:15];
        [_animationView addSubview:button];
        
        _pickerView=[[UIPickerView alloc] initWithFrame:BBRect(0, 40, BBWidth, 216)];
        _pickerView.dataSource=self;
        _pickerView.delegate=self;
        [_animationView addSubview:_pickerView];
    }
    return self;
}
- (void)tapAction{
    [self closePicker];
}
- (void)showPicker;{
    [UIView animateWithDuration:0.3 animations:^{
        _animationView.frame = BBRect(0, BBHeight, BBWidth, 256+BBToolBot);
        _animationView.frame = BBRect(0, BBHeight-256-BBToolBot, BBWidth, 256+BBToolBot);
    }];
    if(self.dataSource.count>0){
        self.selectItem = _dataSource[0];
    }
}
- (void)closePicker{
    [UIView animateWithDuration:0.3 animations:^{
        _animationView.frame = BBRect(0, BBHeight-256-BBToolBot, BBWidth, 256+BBToolBot);
        _animationView.frame = BBRect(0, BBHeight, BBWidth, 256+BBToolBot);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
- (void)pickeSelectItem:(NSString*)string;{
    
}

#pragma Mark -UIPickerViewDelegate-UIPickerViewDataSource-
//返回显示的列数
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
//返回当前列显示的行数
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.dataSource.count;
}
//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSDictionary*info = [self.dataSource objectAtIndex:row];
    return [info objectForKey:@"name"];
}
- (UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:PFontX(20)];
    }
    pickerLabel.textColor=kblue;
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}
-(void) pickerView: (UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent: (NSInteger)component;{
    //选择
    self.selectItem = [self.dataSource objectAtIndex:row];
}
- (void)confirmAction{
    [self.valuesignal sendNext:self.selectItem];
    [self closePicker];
}


@end
