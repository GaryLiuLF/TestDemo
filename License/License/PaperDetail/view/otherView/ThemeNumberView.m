//
//  ThemeNumberView.m
//  License
//
//  Created by wei on 2019/7/15.
//  Copyright © 2019年 wei. All rights reserved.
//

#import "ThemeNumberView.h"

@interface ThemeNumberView()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic,assign)NSInteger totolItem;
@property (nonatomic,assign)float numberWidth;
@property (nonatomic,strong)UIView*mainView;
@property (nonatomic,strong)UIPickerView*pickerView;
@end

@implementation ThemeNumberView

- (instancetype)initWithFrame:(CGRect)frame andTotolNumber:(NSInteger)number;{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor clearColor];
        self.numberWidth = [ThemeNumberView viewNeedHeight];
        self.valuesignal=[RACSubject subject];
        self.totolItem = number;
        self.backgroundColor = [UIColor clearColor];
        self.mainView = [[UIView alloc] initWithFrame:CGRectMake(frame.size.width/2-frame.size.height/2, frame.size.height/2-frame.size.width/2, frame.size.height, frame.size.width)];
        //self.mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.mainView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.mainView];
        self.mainView.transform = CGAffineTransformMakeRotation((90.0f * -M_PI) / 180.0f);
        
        UITapGestureRecognizer*tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [self.mainView addGestureRecognizer:tap];
        
        _pickerView=[[UIPickerView alloc] initWithFrame:self.mainView.bounds];
        _pickerView.dataSource=self;
        _pickerView.delegate=self;
        [self.mainView addSubview:_pickerView];
        
    }
    return self;
}
- (void)tapAction{
    
}

- (void)setSelectItem:(NSInteger)selectItem{
    _selectItem = selectItem;
    [self.pickerView selectRow:selectItem inComponent:0 animated:NO];
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
    return self.totolItem;
}
//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [NSString stringWithFormat:@"%ld",row+1];
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 48;
}
- (UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        UILabel*contentLabel = [UILabel crateLabelWithTitle:@"" font:PFontH(12) color:kblock location:1];
        contentLabel.tag = 99;
        contentLabel.frame = CGRectMake(_pickerView.width/2-self.numberWidth/2, 24-self.numberWidth/2, self.numberWidth, self.numberWidth);
        contentLabel.layer.borderWidth = 1.0;
        contentLabel.layer.borderColor = kblock.CGColor;
        contentLabel.layer.cornerRadius = self.numberWidth/2;
        contentLabel.layer.masksToBounds = YES;
        [pickerLabel addSubview:contentLabel];
        contentLabel.transform = CGAffineTransformMakeRotation((90.0f * M_PI) / 180.0f);
        
        ((UILabel *)[pickerView.subviews objectAtIndex:1]).backgroundColor = KClearColor;
        ((UILabel *)[pickerView.subviews objectAtIndex:2]).backgroundColor = KClearColor;
    }
    UILabel*contentLabel = [pickerLabel viewWithTag:99];
    contentLabel.text = [NSString stringWithFormat:@"%ld",row+1];
    return pickerLabel;
}
-(void)pickerView: (UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent: (NSInteger)component;{
    //选择
    self.selectItem = row;
    [self.valuesignal sendNext:@(row)];
}

+(float)viewNeedHeight;{
    return [UILabel width:@"1000" font:PFontH(12) h:20]+5;
}

@end
