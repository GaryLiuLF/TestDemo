//
//  LoginProtocolViewController.h
//  License
//
//  Created by 电信中国 on 2019/10/18.
//  Copyright © 2019 wei. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface RegisterProtocolViewController : UIViewController

@property (nonatomic, strong) NSString *urlStr;
@property (nonatomic, strong) NSString *titleStr;
@property (nonatomic, strong) NSString *protocolType;
@property (nonatomic,strong)id selectItem;
@property (nonatomic,strong)NSArray*dataSource;


@end

NS_ASSUME_NONNULL_END
