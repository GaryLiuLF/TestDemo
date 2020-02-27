//
//  BBDownloadViewController.m
//  BeibeiMusic
//
//  Created by wei on 2019/7/7.
//  Copyright © 2019年 wei. All rights reserved.
//

#import "BBHotViewController.h"
#import "HotDetailViewController.h"
@interface BBHotViewController ()

@end

@implementation BBHotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"test" style:UIBarButtonItemStylePlain target:self action:@selector(testAction)];
}
- (void)testAction{
    NSString*path = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"plist"];
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithContentsOfFile:path];
    HotDetailViewController*hotDetail = [[HotDetailViewController alloc] init];
//    hotDetail.hotTitle=@"";
//    hotDetail.content = [dic objectForKey:@"mydata"];
    [self.navigationController pushViewController:hotDetail animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
