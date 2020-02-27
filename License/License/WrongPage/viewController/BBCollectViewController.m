//
//  BBCollectViewController.m
//  BeibeiMusic
//
//  Created by wei on 2019/7/7.
//  Copyright © 2019年 wei. All rights reserved.
//

#import "BBCollectViewController.h"
#import "TotolViewController.h"
#import "BBWrongCell.h"
@interface BBCollectViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView*tableView;
@property (nonatomic,strong)NSMutableArray*dataSource;
@property (nonatomic,strong)UILabel*paperLabel;
@end

@implementation BBCollectViewController

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self makeData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setBg:kblue titleColor:kwhite];
    _paperLabel = [UILabel crateLabelWithTitle:@"错题集" font:PFontZ(18) color:kwhite location:1];
    _paperLabel.frame = CGRectMake(0, 0, 100, 20);
    self.navigationItem.titleView = _paperLabel;
    [self.view addSubview:self.tableView];
    
}
- (void)makeData{
    //[self.dataSource addObjectsFromArray:[[DBTool sharedDB] getScoreInfo]];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self.dataSource removeAllObjects];
        [self.dataSource addObjectsFromArray:[[DBTool sharedDB] nomalWrong]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
}
- (void)showNoScore{
    UIImageView*imagev = [self.view viewWithTag:100];
    UILabel*_txtLabel  = [self.view viewWithTag:101];
    if(imagev){
        imagev.hidden = NO;
        [self.view bringSubviewToFront:imagev];
    }else{
        imagev = [[UIImageView alloc] initWithImage:BImage(@"noscore")];
        imagev.tag = 100;
        imagev.frame = BBRect(BBWidth/2-40/2, BBHeight/2-40/2-35, 40, 40);
        [self.view addSubview:imagev];
    }
    
    if(_txtLabel){
        _txtLabel.hidden = NO;
        [self.view bringSubviewToFront:_txtLabel];
    }else{
        _txtLabel = [UILabel crateLabelWithTitle:@"还没有错题" font:PFontX(13) color:kColor(@"ff575757") location:1];
        _txtLabel.frame = CGRectMake(0, imagev.bottom+10, BBWidth, 20);
        _txtLabel.tag = 101;
        [self.view addSubview:_txtLabel];
    }
}
- (void)hideNoScore{
    UIImageView*imagev = [self.view viewWithTag:100];
    UILabel*_txtLabel = [self.view viewWithTag:101];
    if(imagev){
        imagev.hidden = YES;
    }
    if(_txtLabel){
        _txtLabel.hidden = YES;
    }
}

#pragma mark --- tableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(self.dataSource.count==0){
        [self showNoScore];
    }else{
        [self hideNoScore];
    }
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString*ID = @"BBWrongCell";
    BBWrongCell*cell=(BBWrongCell*)[tableView dequeueReusableCellWithIdentifier:ID];
    if(!cell) cell = [[BBWrongCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    cell.model = self.dataSource[indexPath.row];
    return cell;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 0.01;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WrongModel*model = [self.dataSource objectAtIndex:indexPath.row];
    TotolViewController*totolController = [[TotolViewController alloc] init];
    totolController.type =model.type;
    totolController.wrongModel = model;
    [self.navigationController pushViewController:totolController animated:YES];
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
//        [cell setSeparatorInset:UIEdgeInsetsZero];
//    }
//    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
//        [cell setLayoutMargins:UIEdgeInsetsZero];
//    }
}

- (NSMutableArray*)dataSource{
    if(!_dataSource){
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}
- (UITableView*)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, BBNavHeight+0.5, BBWidth, BBHeight-BBNavHeight-BBTabBar) style:UITableViewStylePlain];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _tableView.sectionHeaderHeight = 0;
        _tableView.sectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.delegate=self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = kwhite;
        [_tableView setTableFooterView:[[UIView alloc] init]];
    }
    return _tableView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
