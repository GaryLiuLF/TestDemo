//
//  BBScoreViewController.m
//  License
//
//  Created by wei on 2019/7/22.
//  Copyright © 2019年 wei. All rights reserved.
//

#import "BBScoreViewController.h"
#import "TotolViewController.h"
@interface BBScoreViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView*tableView;
@property (nonatomic,strong)NSMutableArray*dataSource;

@end

@implementation BBScoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setBackButton:YES];
    UILabel*_txtLabel = [UILabel crateLabelWithTitle:@"考试记录" font:PFontZ(18) color:kblock location:1];
    _txtLabel.frame = CGRectMake(0, 0, 220, 30);
    self.navigationItem.titleView = _txtLabel;
    [self setTopLineColor:nil];
    [self makeData];
    [self.view addSubview:self.tableView];
}
- (void)makeData{
    [self.dataSource addObjectsFromArray:[[DBTool sharedDB] getScoreInfo]];
}
- (void)showNoScore{
    UIImageView*imagev = [[UIImageView alloc] initWithImage:BImage(@"noscore")];
    imagev.frame = BBRect(BBWidth/2-40/2, BBHeight/2-40/2-35, 40, 40);
    [self.view addSubview:imagev];
    UILabel*_txtLabel = [UILabel crateLabelWithTitle:@"无记录" font:PFontX(13) color:kColor(@"ff575757") location:1];
    _txtLabel.frame = CGRectMake(0, imagev.bottom+10, BBWidth, 20);
    [self.view addSubview:_txtLabel];
    
}

#pragma mark --- tableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(self.dataSource.count==0){
        [self showNoScore];
    }
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString*ID = @"BBScoreCell";
    BBScoreCell*cell=(BBScoreCell*)[tableView dequeueReusableCellWithIdentifier:ID];
    if(!cell) cell = [[BBScoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    cell.dictionary = self.dataSource[indexPath.row];
    return cell;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 0.01;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary*info = [self.dataSource objectAtIndex:indexPath.row];
    TotolViewController*totolController = [[TotolViewController alloc] init];
    totolController.type = value_moni;
    totolController.moniId = [[info objectForKey:@"moni_id"] intValue];
    [self.navigationController pushViewController:totolController animated:YES];
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
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, BBNavHeight+0.5, BBWidth, BBHeight-BBNavHeight) style:UITableViewStylePlain];
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
- (BOOL)hidesBottomBarWhenPushed{
    return YES;
}

@end


@implementation BBScoreCell
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
        
        _titelLb = [UILabel crateLabelWithTitle:@"" font:PFontX(15) color:kwhite location:1];
        _titelLb.frame = BBRect(12, 17/2, 28, 28);
        _titelLb.numberOfLines = 0;
        _titelLb.layer.cornerRadius = 14.f;
        _titelLb.layer.masksToBounds = YES;
        _titelLb.backgroundColor = kblue;
        [self.contentView addSubview:_titelLb];
        
        _useTimeLb = [UILabel crateLabelWithTitle:@"" font:PFontX(15) color:kblock location:1];
        _useTimeLb.frame = BBRect(_titelLb.right+23, 0, 80, 45);
        [self.contentView addSubview:_useTimeLb];
        
        _timeLb = [UILabel crateLabelWithTitle:@"" font:PFontX(15) color:kblock location:1];
        _timeLb.frame = BBRect(_useTimeLb.right+23, 0, 100, 45);
        [self.contentView addSubview:_timeLb];
        
        _arrowView = [[UIImageView alloc] init];
        _arrowView.frame = BBRect(BBWidth-12-20, 25/2, 20, 20);
        _arrowView.image = BImage(@"icon_rightArrow");
        [self.contentView addSubview:_arrowView];
       
    }
    return self;
}
- (void)setDictionary:(NSDictionary *)dictionary{
    _dictionary = dictionary;
    if([[dictionary objectForKey:@"subjectType"] intValue]==1){
        _titelLb.text = [NSString stringWithFormat:@"%d",[[dictionary objectForKey:@"right"] intValue]];
    }else{
        _titelLb.text = [NSString stringWithFormat:@"%d",[[dictionary objectForKey:@"right"] intValue]*2];
    }
    int useTime = [[dictionary objectForKey:@"useTime"] intValue];
    _useTimeLb.text = [NSString stringWithFormat:@"%02d:%02d",useTime/60,useTime%60];
    NSDateFormatter*formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd HH:mm"];
    _timeLb.text = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[[dictionary objectForKey:@"startTime"] intValue]]];
}
@end
