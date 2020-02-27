//
//  LearnTypeView.h
//  License
//
//  Created by wei on 2019/7/10.
//  Copyright © 2019年 wei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,kLearnCarType) {
    kLearncar=1,
    kLearnvan=2,
    kLearnbus=3,
    kLearnmotorcycle=4
};

@interface LearnTypeView : UIView
@property (nonatomic,strong)RACSubject*valueSiganl;
@property (nonatomic,assign)kLearnCarType type;
@property (nonatomic,assign)BOOL isSelect;
@end
