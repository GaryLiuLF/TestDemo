//
//  CRBoxInputCell_Line.m
//  CRBoxInputView_Example
//
//  Created by Chobits on 2019/1/7.
//  Copyright © 2019 BearRan. All rights reserved.
//

#import "BoxInputCell_Underline.h"
#import <Masonry/Masonry.h>
#import "LicenseTool.h"

@interface BoxInputCell_Underline ()
{
    NSString *_type;
}
@property (nonatomic, strong) NSArray *list;

@end

@implementation BoxInputCell_Underline

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setSepLineView];
    }
    return self;
}

- (void)setBoxInputCell:(UIView *)view {
    UIView *subView = [[UIView alloc]init];
    subView.backgroundColor = [UIColor clearColor];
}

- (void)setSepLineView {
    static CGFloat sepLineViewHeight = 1;
    
    UIView *_sepLineView = [UIView new];
    _sepLineView.backgroundColor = [UIColor colorWithHexString:@"#DDDDDD"];
    _sepLineView.layer.cornerRadius = sepLineViewHeight / 2.0;
    [self.contentView addSubview:_sepLineView];
    [_sepLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.height.mas_equalTo(sepLineViewHeight);
    }];
    
    _sepLineView.layer.shadowColor = [[UIColor colorWithHexString:@"#DDDDDD"] colorWithAlphaComponent:0.2].CGColor;
    _sepLineView.layer.shadowOpacity = 1;
    _sepLineView.layer.shadowOffset = CGSizeMake(0, 2);
    _sepLineView.layer.shadowRadius = 4;
}


@end
