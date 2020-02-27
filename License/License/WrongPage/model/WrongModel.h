//
//  WrongModel.h
//  License
//
//  Created by wei on 2019/7/23.
//  Copyright © 2019年 wei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WrongModel : NSObject

@property(nonatomic,strong)NSString*title;//类型
@property(nonatomic,strong)NSString*subTitle;//选择／时间
@property(nonatomic,assign)int wrongNumber;
@property(nonatomic,assign)KValueListType type;
@property(nonatomic,assign)int moni_id;
@end

