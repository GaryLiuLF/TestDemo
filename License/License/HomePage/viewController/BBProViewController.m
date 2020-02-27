//
//  BBProViewController.m
//  License
//
//  Created by wei on 2019/7/15.
//  Copyright © 2019年 wei. All rights reserved.
//

#import "BBProViewController.h"
#import "TotolViewController.h"

@interface BBProViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView*tableView;
@property (nonatomic,strong)NSMutableArray*dataSource;
@end

@implementation BBProViewController

- (instancetype)init{
    self = [super init];
    self.valueSiganl = [RACSubject subject];
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self refreshData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setBackButton:YES];
    UILabel*txt = [UILabel crateLabelWithTitle:@"专项训练" font:PFontZ(18) color:kblock location:1];
    txt.frame = CGRectMake(0, 0, 100, 20);
    self.navigationItem.titleView = txt;
    [self setTopLineColor:nil];
    
    BBProModel*model1=[BBProModel new];
    model1.number=1;
    model1.name = @"判断题";
    
    BBProModel*model2=[BBProModel new];
    model2.number=2;
    model2.name = @"单选题";
    
    BBProModel*model3=[BBProModel new];
    model3.number=3;
    model3.name = @"多选题";
    
    BBProModel*model4=[BBProModel new];
    model4.number=4;
    model4.name = @"文字题";
    
    BBProModel*model5=[BBProModel new];
    model5.number=5;
    model5.name = @"图片题";
    
    BBProModel*model6=[BBProModel new];
    model6.number=6;
    model6.name = @"动画题";
    
    [self.dataSource addObject:model1];
    [self.dataSource addObject:model2];
    [self.dataSource addObject:model3];
    [self.dataSource addObject:model4];
    [self.dataSource addObject:model5];
    [self.dataSource addObject:model6];
    [self.view addSubview:self.tableView];
}
- (void)refreshData;{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray*array = [[DBTool sharedDB] getSpecialDatas];
        for(int i=0;i<self.dataSource.count;i++){
            BBProModel*model = self.dataSource[i];
            model.content = [NSString stringWithFormat:@"%ld/%ld",[array[i*2+1] integerValue],[array[i*2] integerValue]];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
}

#pragma mark --- tableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BBProModel*model = [self.dataSource objectAtIndex:indexPath.row];
    static NSString*ID = @"BBProCell";
    BBProCell*cell=(BBProCell*)[tableView dequeueReusableCellWithIdentifier:ID];
    if(!cell) cell = [[BBProCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    cell.model = model;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [BBProCell cellHightWithModel:self.dataSource[indexPath.row]];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BBProModel*model = [self.dataSource objectAtIndex:indexPath.row];
    NSString*content = model.content;
    if(content.length>0){
        NSArray*array = [content componentsSeparatedByString:@"/"];
        if([array[1] intValue]==0){
            //无题
            [MBProgressHUD showToastToView:self.view withText:@"该选项还未收录题目\n请选择其他项训练吧"];
            return;
        }
    }
    KValueListType type = value_text;
    if(model.number==1) type=value_check;
    else if (model.number==2) type=value_sigle;
    else if (model.number==3) type=value_mul;
    else if (model.number==4) type=value_text;
    else if (model.number==5) type=value_image;
    else if (model.number==6) type=value_vedio;
    TotolViewController*totolController = [[TotolViewController alloc] init];
    totolController.type = type;
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


@interface BBProCell()
@property (nonatomic,strong)UIView*shadowView;
@property (nonatomic,strong)UIView*cornerView;
@property (nonatomic,strong)UIImageView*numberView;
@property (nonatomic,strong)UILabel*numberLb;
@property (nonatomic,strong)UILabel*textLb;
@property (nonatomic,strong)UILabel*tiLab;
@property (nonatomic,strong)UIImageView*arrowView;
@end
@implementation BBProCell
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
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.shadowView = [[UIView alloc] initWithFrame:CGRectMake(23, 12, BBWidth-23*2, 56)];
        self.shadowView.backgroundColor = KClearColor;
        self.shadowView.layer.shadowColor = [kblock colorWithAlphaComponent:0.2].CGColor;
        self.shadowView.layer.shadowOffset=CGSizeMake(0, 2);
        self.shadowView.layer.shadowOpacity = 2;
        self.shadowView.layer.shadowRadius = 4.0;
        [self.contentView addSubview:self.shadowView];
        
        self.cornerView = [[UIView alloc] initWithFrame:self.shadowView.bounds];
        self.cornerView.layer.cornerRadius = 8.f;
        self.cornerView.layer.masksToBounds = YES;
        self.cornerView.backgroundColor = kwhite;
        [self.shadowView addSubview:self.cornerView];
        
        self.numberView = [[UIImageView alloc] initWithFrame:CGRectMake(18, 28-12, 24, 24)];
        self.numberView.image = BImage(@"ic_number");
        [self.cornerView addSubview:self.numberView];
        
        _numberLb = [UILabel crateLabelWithTitle:@"" font:PFontH(16) color:kwhite location:1];
        _numberLb.frame = self.numberView.bounds;
        [self.numberView addSubview:_numberLb];
        
        _textLb = [UILabel crateLabelWithTitle:@"" font:PFontH(16) color:kblue location:0];
        _textLb.frame = CGRectMake(self.numberView.right+12, 0, 100, 56);
        [self.cornerView addSubview:_textLb];
        
        self.arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(self.cornerView.width-18-20, 28-10, 20, 20)];
        self.arrowView.image = BImage(@"icon_rightArrow");
        [self.cornerView addSubview:self.arrowView];
        
        _tiLab = [UILabel crateLabelWithTitle:@"" font:PFontS(16) color:klineColor location:2];
        _tiLab.frame = CGRectMake(self.arrowView.left-100, 0, 100, 56);
        [self.cornerView addSubview:_tiLab];
        
        
    }
    return self;
}
- (void)setModel:(BBProModel *)model{
    _model = model;
    _numberLb.text = [NSString stringWithFormat:@"%ld",model.number];
    _textLb.text = model.name;
    _tiLab.text = model.content;
}



+ (CGFloat)cellHightWithModel:(BBProModel*)model;{
    return 80.f;
}
@end

@implementation BBProModel
@end
