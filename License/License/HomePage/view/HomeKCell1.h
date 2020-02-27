//
//  HomeKCell1.h
//  License
//
//  Created by wei on 2019/7/14.
//  Copyright © 2019年 wei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeKCell1 : UICollectionViewCell
@property (nonatomic,strong)RACSubject*itemClickSignal;
- (void)refrsh;
@end

