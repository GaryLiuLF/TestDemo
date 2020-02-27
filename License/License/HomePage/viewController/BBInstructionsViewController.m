//
//  BBInstructionsViewController.m
//  License
//
//  Created by wei on 2019/7/22.
//  Copyright © 2019年 wei. All rights reserved.
//

#import "BBInstructionsViewController.h"
#import "HotDetailViewController.h"
@interface BBInstructionsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView*tableView;
@property (nonatomic,strong)NSMutableArray*dataSource;

@end

@implementation BBInstructionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setBackButton:YES];
    UILabel*_txtLabel = [UILabel crateLabelWithTitle:@"考试技巧" font:PFontZ(18) color:kblock location:1];
    _txtLabel.frame = CGRectMake(0, 0, 220, 30);
    self.navigationItem.titleView = _txtLabel;
    [self setTopLineColor:nil];
    [self makeData];
    [self.view addSubview:self.tableView];
}
- (void)makeData{
    NSString*xuzhi = @"";
    if([CommandManager sharedManager].subType==1){
        xuzhi = @"xuzhi";
    }else{
        xuzhi = @"xuzhi2";
    }
    NSString*path = [[NSBundle mainBundle] pathForResource:xuzhi ofType:@"plist"];
    NSMutableArray *array=[NSMutableArray arrayWithContentsOfFile:path];
    for(int i=0;i<array.count;i++){
        NSString*content =array[i];
        NSMutableArray*valueArray=[NSMutableArray array];
        NSArray*arrayItem = [content componentsSeparatedByString:@"<>"];
        for(int j=0;j<arrayItem.count;j++){
            HotItem*item = [[HotItem alloc] init];
            [item setBasicString:arrayItem[j]];
            [valueArray addObject:item];
        }
        [self.dataSource addObject:valueArray];
    }
}

#pragma mark --- tableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString*ID = @"BBInstructionsCell";
    BBInstructionsCell*cell=(BBInstructionsCell*)[tableView dequeueReusableCellWithIdentifier:ID];
    if(!cell) cell = [[BBInstructionsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    HotItem*item = self.dataSource[indexPath.row][0];
    if(cell){
        cell.content = item.value;
    }
    return cell;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 0.01;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    HotItem*item = self.dataSource[indexPath.row][0];
    return [BBInstructionsCell cellHightWithString:item.value];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HotDetailViewController*deatil = [[HotDetailViewController alloc] init];
    deatil.list = self.dataSource[indexPath.row];
    [self.navigationController pushViewController:deatil animated:YES];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end




@implementation BBInstructionsCell
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
        
        _pointV = [[UIView alloc] initWithFrame:CGRectMake(23, 12+15/2-10.f/2, 10.f, 10.f)];
        _pointV.backgroundColor = kblue;
        _pointV.layer.cornerRadius = 5.f;
        _pointV.layer.masksToBounds = YES;
        [self.contentView addSubview:_pointV];
        
        _titellb = [UILabel crateLabelWithTitle:@"" font:PFontX(15) color:kblock location:0];
        _titellb.numberOfLines = 0;
        [self.contentView addSubview:_titellb];
        @weakify(self);
        [_titellb mas_updateConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.left.equalTo(self.titellb.superview).with.offset((23+10.f+8.f));
            make.right.equalTo(self.titellb.superview).with.offset(-23);
            make.top.equalTo(self.titellb.superview).with.offset(10);
            make.bottom.equalTo(self.titellb.superview).with.offset(-10);
        }];
    }
    return self;
}
- (void)setContent:(NSString *)content{
    _content = content;
    _titellb.text = content;
}
+ (CGFloat)cellHightWithString:(NSString*)item;{
    float x = [UILabel height:item font:PFontX(15) w:BBWidth-23-(23+10.f+8.f)];
    return x+22.f;
}
@end
