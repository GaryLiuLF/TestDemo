//
//  HotDetailViewController.m
//  License
//
/*
 if (data) {
 
 NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
 
 NSLog(@"%@",dict);
 
 }
 
 2.Foundation对象转换为json数据(+(NSData *)dataWithJSONObject: options:error:）;(其中对象不能为空)
 
 NSDictionary *dict = @{@"1" : @"a",@"2" : @"b"};
 //    NSArray *arr = @[@"1",@"2"];
 if ([NSJSONSerialization isValidJSONObject:dict]) {
 NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
 NSString *json = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
 NSLog(@"%@",json);
 }
 */
//  Created by wei on 2019/7/17.
//  Copyright © 2019年 wei. All rights reserved.
//

/*
 寻找数据
 导入txt中整理
【
 分割<>
 标题[t0]
 子标题[t1]
 三级子标题[t2]
 一级item [i]
 内容  [c]
 图  [p]
 结束语[j]
 】
 传入test.plist中
 由HotDetailViewController读取显示调整后
 导入服务器存储
 读取数据并展示用户
 */

#import "HotDetailViewController.h"

#import "HotTitle1TableViewCell.h"
#import "HotTitle2TableViewCell.h"
#import "HotItemTableViewCell.h"
#import "HotContentTableViewCell.h"
#import "HotPicTableViewCell.h"
#import "HotEndTableViewCell.h"

#import "HotDataMaker.h"
#import "SBJson5.h"
@interface HotDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView*tableView;
@property (nonatomic,strong)NSMutableArray*dataSource;
@property (nonatomic,strong)UILabel*txtLabel;
@end

@implementation HotDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setBackButton:YES];
    _txtLabel = [UILabel crateLabelWithTitle:@"" font:PFontX(16) color:kblock location:1];
    _txtLabel.frame = CGRectMake(0, 0, 220, 30);
    HotItem*item = self.list[0];
    _txtLabel.text = item.value;
    self.navigationItem.titleView = _txtLabel;
    [self setTopLineColor:KClearColor];
    [self makeData];
    [self.view addSubview:self.tableView];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"test" style:UIBarButtonItemStylePlain target:self action:@selector(testAction)];
}

- (void)makeData{
    for(int i=1;i<_list.count;i++){
        [self.dataSource addObject:_list[i]];
    }
}
- (void)testAction{
//    //生成需要的json数据
    NSMutableArray*array = [NSMutableArray array];
    for(int i=0;i<self.dataSource.count;i++){
        HotItem*item = self.dataSource[i];
        if(item.type==kHotTitle1){
            [array addObject:@{@"type":@"[t1]",@"value":item.value}];
        }else if (item.type==kHotTitle2){
            [array addObject:@{@"type":@"[t2]",@"value":item.value}];
        }else if (item.type==kHotItem){
            [array addObject:@{@"type":@"[i]",@"value":item.value}];
        }else if (item.type==kHotContent){
            [array addObject:@{@"type":@"[c]",@"value":item.value}];
        }else if (item.type==kHotImage){
            [array addObject:@{@"type":@"[p]",@"value":item.value}];
        }else if (item.type==kHotEnd){
            [array addObject:@{@"type":@"[j]",@"value":item.value}];
        }
    }
    NSString*json = [CommandManager json_stringWithValue:array];
    NSLog(@"title=%@",_txtLabel.text);
    NSLog(@"json=%@",json);
//    id obj = [CommandManager json_objetWith:json];
//    NSLog(@"obj = %@",obj);
}

#pragma mark --- tableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HotItem*item = [self.dataSource objectAtIndex:indexPath.row];
    switch (item.type) {
        case kHotTitle1:
        {
            static NSString*ID = @"HotTitle1TableViewCell";
            HotTitle1TableViewCell*cell=(HotTitle1TableViewCell*)[tableView dequeueReusableCellWithIdentifier:ID];
            if(!cell) cell = [[HotTitle1TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
            cell.item = item;
            return cell;
        }
            break;
        case kHotTitle2:
        {
            static NSString*ID = @"HotTitle2TableViewCell";
            HotTitle2TableViewCell*cell=(HotTitle2TableViewCell*)[tableView dequeueReusableCellWithIdentifier:ID];
            if(!cell) cell = [[HotTitle2TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
            cell.item = item;
            return cell;
        }
            break;
        case kHotItem:
        {
            static NSString*ID = @"HotItemTableViewCell";
            HotItemTableViewCell*cell=(HotItemTableViewCell*)[tableView dequeueReusableCellWithIdentifier:ID];
            if(!cell) cell = [[HotItemTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
            cell.item = item;
            return cell;
        }
            break;
        case kHotContent:
        {
            static NSString*ID = @"HotContentTableViewCell";
            HotContentTableViewCell*cell=(HotContentTableViewCell*)[tableView dequeueReusableCellWithIdentifier:ID];
            if(!cell) cell = [[HotContentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
            cell.item = item;
            return cell;
        }
            break;
        case kHotImage:
        {
            static NSString*ID = @"HotPicTableViewCell";
            HotPicTableViewCell*cell=(HotPicTableViewCell*)[tableView dequeueReusableCellWithIdentifier:ID];
            if(!cell) cell = [[HotPicTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
            cell.item = item;
            return cell;
        }
            break;
        case kHotEnd:
        {
            static NSString*ID = @"HotEndTableViewCell";
            HotEndTableViewCell*cell=(HotEndTableViewCell*)[tableView dequeueReusableCellWithIdentifier:ID];
            if(!cell) cell = [[HotEndTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
            cell.item = item;
            return cell;
        }
            break;
        default:
            break;
    }
    static NSString*ID = @"UITableViewCell";
    UITableViewCell*cell=(UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:ID];
    if(!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    HotItem*item = [self.dataSource objectAtIndex:indexPath.row];
    switch (item.type) {
        case kHotTitle1:
        {
            return [HotTitle1TableViewCell cellHightWithItem:item];
        }
            break;
        case kHotTitle2:
        {
            return [HotTitle2TableViewCell cellHightWithItem:item];
        }
            break;
        case kHotItem:
        {
            return [HotItemTableViewCell cellHightWithItem:item];
        }
            break;
        case kHotContent:
        {
            return [HotContentTableViewCell cellHightWithItem:item];
        }
            break;
        case kHotImage:
        {
            return [HotPicTableViewCell cellHightWithItem:item];
        }
            break;
        case kHotEnd:
        {
            return [HotEndTableViewCell cellHightWithItem:item];
        }
            break;
        default:
            break;
    }
    return 0.0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (NSMutableArray*)dataSource{
    if(!_dataSource){
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}
- (UITableView*)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, BBNavHeight, BBWidth, BBHeight-BBNavHeight) style:UITableViewStylePlain];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _tableView.sectionHeaderHeight = 0;
        _tableView.sectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate=self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = kwhite;
        [_tableView setTableFooterView:[[UIView alloc] init]];
    }
    return _tableView;
}
- (BOOL)hidesBottomBarWhenPushed{
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
