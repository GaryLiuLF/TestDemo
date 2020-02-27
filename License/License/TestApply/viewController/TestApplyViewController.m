//
//  TestApplyViewController.m
//  License
//
//  Created by 电信中国 on 2019/9/3.
//  Copyright © 2019 wei. All rights reserved.
//

#import "TestApplyViewController.h"

#import "TestAddressView.h"
#import "TestAddressCell.h"

#import "ApplyDetailViewController.h"

static NSString *cellID = @"TestAddressCellID";
@interface TestApplyViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) TestAddressView *testAddressView;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, copy) NSArray *addrArr;
@property (nonatomic, strong) NSMutableArray *showAddrArr;
@property (nonatomic, strong) NSDictionary *appliedInfo;

@end

@implementation TestApplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setup];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self initData];
    [self.tableView reloadData];
}

- (BOOL)hidesBottomBarWhenPushed{
    return YES;
}

- (void)initData {
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"testAddress" ofType:@"plist"];
    self.addrArr = [[NSArray arrayWithContentsOfFile:filePath]copy];
    
    self.showAddrArr = [NSMutableArray arrayWithArray:self.addrArr[0][@"address"]];
    
    self.appliedInfo = [[[NSUserDefaults standardUserDefaults] objectForKey:@"apply"]copy];
}

- (void)setup {
    [self setBackButton:YES];
    UILabel*_txtLabel = [UILabel crateLabelWithTitle:@"预考考场" font:PFontZ(18) color:kblock location:1];
    _txtLabel.frame = CGRectMake(0, 0, 220, 30);
    self.navigationItem.titleView = _txtLabel;
    [self setTopLineColor:nil];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F6F6F6"];
    [self.view addSubview:self.testAddressView];
    [self.view addSubview:self.tableView];
    [self setupLayout];
}

- (void)setupLayout {
    [self.testAddressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(12);
        } else {
            make.top.equalTo(self.view).offset(12);
        }
        make.height.mas_equalTo(100);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.testAddressView.mas_bottom).offset(12);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.equalTo(self.view);
        }
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.showAddrArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TestAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    NSDictionary *dic = self.showAddrArr[indexPath.section];
    cell.infoDic = dic;
    if ([dic[@"testID"] isEqualToString:self.appliedInfo[@"testID"]]) {
        cell.isApplied = YES;
    }
    else {
        cell.isApplied = NO;
    }
    @weakify(self);
    [cell testApplyBlock:^{
        @strongify(self);
        if (self.appliedInfo) {
            UIAlertController *alertContr = [UIAlertController alertControllerWithTitle:nil message:@"您已预约考试，是否更改预约" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"立即更改" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                ApplyDetailViewController *vc = [ApplyDetailViewController new];
                vc.infoDic = self.showAddrArr[indexPath.section];
                [self.navigationController pushViewController:vc animated:YES];
            }];
            
            [alertContr addAction:cancelAction];
            [alertContr addAction:sureAction];
            [self presentViewController:alertContr animated:YES completion:nil];
        }
        else {
            ApplyDetailViewController *vc = [ApplyDetailViewController new];
            vc.infoDic = self.showAddrArr[indexPath.section];
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 12;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (TestAddressView *)testAddressView {
    if (!_testAddressView) {
        _testAddressView = [[TestAddressView alloc]init];
        @weakify(self);
        [_testAddressView testAddrSelectBlock:^(NSInteger flag) {
            @strongify(self);
            if (self.tableView.mj_header.refreshing) {
                [self.tableView.mj_header endRefreshing];
            }
            
            self.showAddrArr = [NSMutableArray arrayWithArray:self.addrArr[flag][@"address"]];
            [self.tableView reloadData];
        }];
    }
    return _testAddressView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 80;
        _tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0.01)];
        _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0.01)];;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [_tableView registerClass:[TestAddressCell class] forCellReuseIdentifier:cellID];
        
        MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            [self refreshList];
        }];
        header.lastUpdatedTimeLabel.hidden = YES;
        _tableView.mj_header = header;
    
    }
    return _tableView;
}

- (void)refreshList {
    float delayInSeconds = arc4random()%3+0.5;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.tableView.mj_header.refreshing) {
            [self.tableView.mj_header endRefreshing];
        }
    });
    
}


@end
