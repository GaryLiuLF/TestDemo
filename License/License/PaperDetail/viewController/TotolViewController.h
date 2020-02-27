//
//  TotolViewController.h
//  License
//
//  Created by wei on 2019/7/11.
//  Copyright © 2019年 wei. All rights reserved.
//

#import "BasicViewController.h"
#import "WrongModel.h"
@interface TotolViewController : BasicViewController
@property (nonatomic,assign)KValueListType type;
@property (nonatomic,assign)int moniId;
@property (nonatomic,strong)WrongModel*wrongModel;
@property (nonatomic,strong)RACSubject*valueBackSignal;
@end
