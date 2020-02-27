//
//  FCEditPikerView.h
//  FocusUser
//
//  Created by wei on 2018/1/17.
//  Copyright © 2018年 wei. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface BBPickerView : UIView<UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic,strong)RACSubject*valuesignal;
@property (nonatomic,strong)id selectItem;
@property (nonatomic,strong)NSArray*dataSource;
@property (nonatomic,strong)UIView*mainView;

@property (nonatomic,strong)UIView*animationView;
@property (nonatomic,strong)UIPickerView*pickerView;
- (id)initWithFrame:(CGRect)frame;
- (void)pickeSelectItem:(NSString*)string;
- (void)showPicker;
- (void)closePicker;

@end
