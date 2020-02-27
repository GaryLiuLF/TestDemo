//
//  HomeKCell2.h
//  License
//
//  Created by wei on 2019/7/14.
//  Copyright © 2019年 wei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeKCell2 : UICollectionViewCell
@property (nonatomic,strong)RACSubject*itemClickSignal;
- (void)refrsh;
@end
