//
//  PaperCollectionViewCell.h
//  License
//
//  Created by wei on 2019/7/11.
//  Copyright © 2019年 wei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThemeModel.h"

@interface PaperCollectionViewCell : UICollectionViewCell
@property (nonatomic,assign)int moniId;//必须先传
@property (nonatomic,assign)KValueListType type;//必须先传
@property (nonatomic,assign)BOOL isBeiti;//必须先传
@property (nonatomic,strong)ThemeModel*currentModel;
@property (nonatomic,assign)NSInteger row;
- (AlongModel*)getAlongModel;

@end
