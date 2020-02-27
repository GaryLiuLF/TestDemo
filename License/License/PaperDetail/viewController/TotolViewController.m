//
//  TotolViewController.m
//  License
//
//  Created by wei on 2019/7/11.
//  Copyright © 2019年 wei. All rights reserved.
//

#import "TotolViewController.h"
#import "PaperCollectionViewCell.h"
#import "ThemeNumberView.h"
#import "LEEAlert.h"

@interface TotolViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>{
    float bottomNeedHeight;
}
@property (nonatomic,strong)UICollectionView*collectionView;
@property (nonatomic,strong)NSMutableArray*dataSource;
@property (nonatomic,strong)ThemeNumberView*pickView;
@property (nonatomic,assign)NSInteger wrongNumbers;
@property (nonatomic,assign)NSInteger totolNumber;

@property (nonatomic,assign)NSInteger perWrongNumbers;
@property (nonatomic,assign)NSInteger perRightNumbers;

@property (nonatomic,strong)UILabel*numberLabel1;
@property (nonatomic,strong)UILabel*numberLabel2;
@property (nonatomic,strong)UILabel*numberLabel3;
@property (nonatomic,strong)UILabel*numberLabel4;

@property (nonatomic,strong)UISegmentedControl*segmentedControl;
@property (nonatomic,strong)UILabel*timeLabel;
@property (nonatomic,assign)NSInteger useTime;
@property (nonatomic,strong)NSTimer*currentTimer;
@property (nonatomic,assign)BOOL havePlayed;

@end



@implementation TotolViewController
- (instancetype)init{
    self = [super init];
    if(self){
        self.valueBackSignal = [RACSubject subject];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if(self.wrongModel){
        [self setBackButton:YES];
    }else{
        [self setBackButton:NO];
    }
    [self setTopLineColor:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themePlay:) name:@"themeWasWrited" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stepToNext:) name:@"themeWasWritedAndStep" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appGoBack) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appGoActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    bottomNeedHeight = [ThemeNumberView viewNeedHeight]+16+BBToolBot;
    [self.view addSubview:self.collectionView];
    [self makeDatas];
    self.perRightNumbers=0;
    self.perWrongNumbers=0;
    /*根据type布局其余页面
     比如：顺序 有背题模式  随机则没有  none则是错题模式  其他几项是专项练习
     还有一个特殊的真题模拟
     */
    if(_type!=value_moni && !_wrongModel){
        // 初始化，添加分段名，会自动布局
        self.segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"答题模式", @"背题模式"]];
        self.segmentedControl.frame = CGRectMake(BBWidth/2-90, 20+BBNavHeight_Y+7, 180, 30);
        // 设置整体的色调
        self.segmentedControl.tintColor = kblue;
        // 设置分段名的字体
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:kblue,NSForegroundColorAttributeName,[UIFont systemFontOfSize:18],NSFontAttributeName ,nil];
        [self.segmentedControl setTitleTextAttributes:dic forState:UIControlStateNormal];
        // 设置初始选中项
        self.segmentedControl.selectedSegmentIndex = 0;
        [self.segmentedControl addTarget:self action:@selector(selectItem:) forControlEvents:UIControlEventValueChanged];// 添加响应方法
        // 设置样式的segmentedControlStyle属性在iOS 7.0之后将不再起作用
        // 设置点击后恢复原样，默认为NO，点击后一直保持选中状态
        self.navigationItem.titleView = self.segmentedControl;
        //[self.view addSubview:self.segmentedControl];
    }
}
- (void)goBackCustom{
    if(self.type==value_moni){
        if(self.havePlayed){
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }else{
            [LEEAlert alert].config
            .LeeAddTitle(^(UILabel *label) {
                label.text =@"温馨提示";
                label.font = PFontH(16);
                label.textColor = kblock;
                label.textAlignment = NSTextAlignmentCenter;
            })
            .LeeAddContent(^(UILabel *label) {
                label.text =@"您当前正在考试中，是否立即交卷退出考试？";
                label.font = PFontS(14);
                label.textColor = kblock;
                label.textAlignment = NSTextAlignmentCenter;
            })
            .LeeAction(@"继续答题",^{
                
            })
            .LeeAction(@"立即交卷",^{
                [self submitPaper];
            })
            .LeeShow();
        }
        return;
    }
    if(self.perRightNumbers+self.perWrongNumbers<1){
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        float percentage = (float)(self.perRightNumbers*100.0) /(float)(self.perRightNumbers+self.perWrongNumbers);
        [LEEAlert alert].config
        .LeeAddTitle(^(UILabel *label) {
            label.text =(percentage>90.0)?@"恭喜您":@"好遗憾";
            label.font = PFontH(16);
            label.textColor = kblock;
            label.textAlignment = NSTextAlignmentCenter;
        })
        .LeeAddContent(^(UILabel *label) {
            NSString*r_str =[NSString stringWithFormat:@"答对%ld道",self.perRightNumbers];
            NSString*w_str =[NSString stringWithFormat:@"答错%ld道",self.perWrongNumbers];
            NSString*text = [NSString stringWithFormat:@"本次答题%ld道，答对%ld道，答错%ld道。成功率为%.1f%%。",self.perRightNumbers+self.perWrongNumbers,self.perRightNumbers,self.perWrongNumbers,percentage];
            NSRange r_range = [text rangeOfString:r_str];
            NSRange w_range = [text rangeOfString:w_str];
            label.attributedText = [UILabel text:text conditions:@[@[@(r_range.location),kblock,PFontS(14)],
                                                                  @[@(r_range.length),kblue,PFontS(14)],
                                                                  @[@(1),kblock,PFontS(14)],
                                                                  @[@(w_range.length),kred,PFontS(14)],
                                                                  @[@(text.length-w_range.location-w_range.length),kblock,PFontS(14)]]];
            label.textAlignment = NSTextAlignmentLeft;
        })
        .LeeAction(@"继续答题",^{
            
        })
        .LeeAction(@"退出",^{
            [self.navigationController popViewControllerAnimated:YES];
        })
        .LeeShow();
        
    }
    
}

- (void)selectItem:(UISegmentedControl *)sender {
    NSArray*array = self.collectionView.visibleCells;
    NSMutableArray*indexs = [NSMutableArray array];
    for(int i=0;i<array.count;i++){
        PaperCollectionViewCell*cell =array[i];
        [indexs addObject:[NSIndexPath indexPathForRow:cell.row inSection:0]];
    }
    [self.collectionView reloadItemsAtIndexPaths:indexs];
}

- (void)makeDatas{
    //@[ktype0ke1,ktype1ke1,ktype2ke1,ktype3ke1,ktype0ke2,ktype1ke2,ktype2ke2,ktype3ke2];
    if(_wrongModel){
        NSString*title= @"";
        if(_wrongModel.moni_id>0){
            title= @"考试错题";
            self.dataSource = [[DBTool sharedDB] getMoniTWrongWithmoniId:_wrongModel.moni_id];
            [CommandManager sharedManager].proid=_wrongModel.moni_id;
            self.moniId = _wrongModel.moni_id;
            [self.collectionView reloadData];
        }else{
            NSString*tableName = [[CommandManager sharedManager] tableName];
            self.dataSource = [[DBTool sharedDB] getDataWithCarType:tableName andValueType:_type onlyWrong:YES];
            [self.collectionView reloadData];
            
            if(_wrongModel.subTitle>0){
                title=[NSString stringWithFormat:@"%@-%@",_wrongModel.title,_wrongModel.subTitle];
            }else{
                title=_wrongModel.title;
            }
            
        }
        self.totolNumber  = self.dataSource.count;
        self.wrongNumbers = self.dataSource.count;
        _timeLabel = [UILabel crateLabelWithTitle:title font:PFontS(20) color:kblock location:1];
        _timeLabel.frame = CGRectMake(0, 0, 180, 34);
        self.navigationItem.titleView = _timeLabel;
        
    }else{
        if(_type != value_moni){
            NSString*tableName = [[CommandManager sharedManager] tableName];
            self.dataSource = [[DBTool sharedDB] getDataWithCarType:tableName andValueType:_type onlyWrong:NO];
            [self.collectionView reloadData];
            
            NSRange range = [[DBTool sharedDB] getRightAndWrongNumberWithCarType:tableName andValueType:_type];
            //self.wrongNumbers = [[DBTool sharedDB] getWrongNumberWithCarType:tableName andValueType:_type];
            self.totolNumber = range.location+range.length;
            self.wrongNumbers = range.length;
        }else{
            //如果是模拟题
            self.dataSource = [[DBTool sharedDB] getMoniThemesWithCarType:[CommandManager sharedManager].carType subType:[CommandManager sharedManager].subType moniId:self.moniId];
            if(self.moniId==0){
                self.moniId = [CommandManager sharedManager].proid;
            }
            [self.collectionView reloadData];
            NSArray*range = [[DBTool sharedDB] getMoniRightAndWrongNumberWithMoniId:self.moniId];
            self.totolNumber = [range[0] intValue]+[range[1] intValue];
            self.wrongNumbers = [range[1] intValue];
            self.useTime = [range[2] intValue];
            self.havePlayed = [range[3] boolValue];
            if(self.havePlayed==YES){
                //跟句id获取时间／／
                _timeLabel = [UILabel crateLabelWithTitle:@"考试结束" font:PFontS(20) color:kblock location:1];
                _timeLabel.frame = CGRectMake(0, 0, 100, 34);
                self.navigationItem.titleView = _timeLabel;
            }else{
                //跟句id获取时间／／
                _timeLabel = [UILabel crateLabelWithTitle:@"" font:PFontS(20) color:kwhite location:1];
                int overTime = 45*60 - (int)self.useTime;
                self.timeLabel.text = [NSString stringWithFormat:@"%02d:%02d",overTime/60,overTime%60];
                _timeLabel.backgroundColor = kblue;
                _timeLabel.layer.cornerRadius = 4.f;
                _timeLabel.layer.masksToBounds = YES;
                _timeLabel.frame = CGRectMake(0, 0, 100, 34);
                self.navigationItem.titleView = _timeLabel;
                //准备记时
                [self startRunTime];
                self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"交卷" style:UIBarButtonItemStylePlain target:self action:@selector(submitPaper)];
            }
            
            
        }
    }
    
    
    
    int tag = 0;
    if(!_wrongModel){
        if(self.dataSource.count>0){
            NSString*key= [NSString stringWithFormat:@"now-%d-%d-%ld-%d",[CommandManager sharedManager].carType,[CommandManager sharedManager].subType,self.type,self.moniId];
            tag = [[CommandManager getValue:key] intValue];
            NSIndexPath*indexPath = [NSIndexPath indexPathForRow:[[CommandManager getValue:key] intValue] inSection:0];
            [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        }
    }
    
    
    UIView*toolView = [[UIView alloc] initWithFrame:CGRectMake(0,BBHeight-bottomNeedHeight, BBWidth,bottomNeedHeight)];
    [self.view addSubview:toolView];
    UIView*linev = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BBWidth, 0.5)];
    linev.backgroundColor = klineColor;
    [toolView addSubview:linev];
    _pickView = [[ThemeNumberView alloc] initWithFrame:CGRectMake(0,8,BBWidth/2,[ThemeNumberView viewNeedHeight]) andTotolNumber:self.dataSource.count];
    [toolView addSubview:_pickView];
    @weakify(self);
    [_pickView.valuesignal subscribeNext:^(NSNumber*x) {
        @strongify(self);
        NSIndexPath*indexPath = [NSIndexPath indexPathForRow:[x intValue] inSection:0];
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }];
    
    UIImageView*gouView = [[UIImageView alloc] initWithImage:BImage(@"ic_dui")];
    gouView.frame = CGRectMake(BBWidth/2+5, (toolView.height-BBToolBot)/2-10, 20, 20);
    [toolView addSubview:gouView];
    
    _numberLabel1 = [UILabel crateLabelWithTitle:@"" font:PFontH(14) color:kblock location:0];
    _numberLabel1.frame = CGRectMake(gouView.right, gouView.top, 30, gouView.height);
    [toolView addSubview:_numberLabel1];
    
    UIImageView*cuoView = [[UIImageView alloc] initWithImage:BImage(@"ic_cuo")];
    cuoView.frame = CGRectMake(_numberLabel1.right+5, (toolView.height-BBToolBot)/2-10, 20, 20);
    [toolView addSubview:cuoView];
    
    _numberLabel2 = [UILabel crateLabelWithTitle:@"" font:PFontH(14) color:kblock location:0];
    _numberLabel2.frame = CGRectMake(cuoView.right, gouView.top, 30, gouView.height);
    [toolView addSubview:_numberLabel2];
    
    UIImageView*shuView = [[UIImageView alloc] initWithImage:BImage(@"ic_shu")];
    shuView.frame = CGRectMake(_numberLabel2.right+20, (toolView.height-BBToolBot)/2-10, 20, 20);
    [toolView addSubview:shuView];
    
    _numberLabel3 = [UILabel crateLabelWithTitle:@"" font:PFontH(14) color:kblock location:2];
    _numberLabel3.frame = CGRectMake(shuView.left-36, gouView.top, 40, gouView.height);
    [toolView addSubview:_numberLabel3];
    
    _numberLabel4 = [UILabel crateLabelWithTitle:@"" font:PFontH(14) color:kblock location:0];
    _numberLabel4.frame = CGRectMake(shuView.right-4, gouView.top, 40, gouView.height);
    [toolView addSubview:_numberLabel4];
    
    [self setToolViewSelect:tag];
    [self setToolViewText];
    
    if(_wrongModel){
        gouView.hidden=YES;
        _numberLabel1.hidden=YES;
        cuoView.hidden=YES;
        _numberLabel2.hidden=YES;
    }
}
- (void)setToolViewSelect:(NSInteger)tag{
    self.pickView.selectItem = tag;
}
- (void)setToolViewText{
    _numberLabel4.text = [NSString stringWithFormat:@"%ld",self.dataSource.count];
    _numberLabel3.text = [NSString stringWithFormat:@"%ld",self.totolNumber];
    _numberLabel2.text = [NSString stringWithFormat:@"%ld",self.wrongNumbers];
    _numberLabel1.text = [NSString stringWithFormat:@"%ld",self.totolNumber-self.wrongNumbers];
}
- (void)stepToNext:(NSNotification*)notification{
    if(_type==value_moni && self.havePlayed==NO && !_wrongModel && [CommandManager sharedManager].canStep){
        int x = [notification.object intValue];
        if(x<self.dataSource.count-1){
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:x+1 inSection:0];
            [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
        }
    }
}
- (void)themePlay:(NSNotification*)notification{
    self.totolNumber++;
    int x = [notification.object intValue];
    if(x!=1){
        self.wrongNumbers++;
        self.perWrongNumbers++;
    }else{
        self.perRightNumbers++;
    }
    [self setToolViewText];
    if(_type==value_moni){
        [[DBTool sharedDB] updateWithID:self.moniId right:(int)(self.totolNumber-self.wrongNumbers)  wrong:(int)self.wrongNumbers];
        if([CommandManager sharedManager].canStep){
        }
    }
    if(self.type==value_moni){
        if(self.totolNumber==self.dataSource.count){
            [self submitPaper];
        }
    }else{
        if(self.totolNumber==self.dataSource.count){
            [LEEAlert alert].config
            .LeeAddTitle(^(UILabel *label) {
                label.text =@"恭喜您";
                label.font = PFontH(16);
                label.textColor = kblock;
                label.textAlignment = NSTextAlignmentCenter;
            })
            .LeeAddContent(^(UILabel *label) {
                label.text =@"您已完成所有试题，去看看别的试题吧。";
                label.font = PFontS(14);
                label.textColor = kblock;
                label.textAlignment = NSTextAlignmentCenter;
            })
            .LeeAction(@"继续",^{
                
            })
            .LeeAction(@"确定",^{
                [self.navigationController popViewControllerAnimated:YES];
            })
            .LeeShow();
        }
    }
    
}
- (void)startRunTime{
    self.currentTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(refreshTimeLabelValue) userInfo:nil repeats:YES];
    //[[NSRunLoop currentRunLoop] addTimer:self.currentTimer forMode:NSRunLoopCommonModes];
}
- (void)refreshTimeLabelValue{
    self.useTime++;
    if(self.useTime==45*60){
        [[DBTool sharedDB] updateWithID:self.moniId useTime:(int)self.useTime];
        [_currentTimer invalidate];
        _currentTimer = nil;
        [self submitPaper];
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        int overTime = 45*60 - (int)self.useTime;
        self.timeLabel.text = [NSString stringWithFormat:@"%02d:%02d",overTime/60,overTime%60];
        if(self.useTime%5==0){
            [[DBTool sharedDB] updateWithID:self.moniId useTime:(int)self.useTime];
        }
    });
}
- (void)appGoBack{
    if(_currentTimer){
        [_currentTimer invalidate];
    }
}
- (void)appGoActive{
    if(_currentTimer){
        _currentTimer = nil;
        [self startRunTime];
    }
}
- (void)submitPaper{
    //立即更新数据
    [[DBTool sharedDB] updateMoniReslutCompleteWithID:self.moniId];
    self.navigationItem.rightBarButtonItem=nil;
    _timeLabel = [UILabel crateLabelWithTitle:@"考试结束" font:PFontS(20) color:kblock location:1];
    _timeLabel.frame = CGRectMake(0, 0, 100, 34);
    self.navigationItem.titleView = _timeLabel;
    self.havePlayed = YES;
    
    if(_currentTimer){
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(refreshTimeLabelValue) object:nil];
        [_currentTimer invalidate];
        _currentTimer=nil;
    }
    
    NSInteger percentage = self.totolNumber-self.wrongNumbers;
    if(self.dataSource.count==50){
        percentage = percentage*2;
    }
    [LEEAlert alert].config
    .LeeAddTitle(^(UILabel *label) {
        label.text =(percentage>=90)?@"恭喜您":@"好遗憾";
        label.font = PFontH(16);
        label.textColor = kblock;
        label.textAlignment = NSTextAlignmentCenter;
    })
    .LeeAddContent(^(UILabel *label) {
        
        NSString*r_str =[NSString stringWithFormat:@"答对%ld道",self.totolNumber-self.wrongNumbers];
        NSString*w_str =[NSString stringWithFormat:@"答错%ld道",self.wrongNumbers];
        NSString*text = [NSString stringWithFormat:@"本次答题%ld道，用时%02ld:%02ld，答对%ld道，答错%ld道。得分：%ld分。",self.totolNumber,self.useTime/60,self.useTime%60,self.totolNumber-self.wrongNumbers,self.wrongNumbers,percentage];
        NSRange r_range = [text rangeOfString:r_str];
        NSRange w_range = [text rangeOfString:w_str];
        label.attributedText = [UILabel text:text conditions:@[@[@(r_range.location),kblock,PFontS(14)],
                                                               @[@(r_range.length),kblue,PFontS(14)],
                                                               @[@(1),kblock,PFontS(14)],
                                                               @[@(w_range.length),kred,PFontS(14)],
                                                               @[@(text.length-w_range.location-w_range.length),kblock,PFontS(14)]]];
        label.textAlignment = NSTextAlignmentLeft;
    })
    .LeeAction(@"再看看",^{
        
    })
    .LeeAction(@"退出",^{
        [self.navigationController popViewControllerAnimated:YES];
    })
    .LeeShow();
}



#pragma mark 设置CollectionView的组数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
#pragma mark 设置CollectionView每组所包含的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}
#pragma mark 设置CollectionCell的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ThemeModel*model = self.dataSource[indexPath.row];
    //NSLog(@"刷新 %ld",indexPath.row);
    PaperCollectionViewCell*cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PaperCollectionViewCell" forIndexPath:indexPath];
    cell.moniId = self.moniId;
    cell.isBeiti = (self.segmentedControl.selectedSegmentIndex>0)?YES:NO;
    cell.type= self.type;
    cell.currentModel=model;
    cell.row = indexPath.row;
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath;{
    //ThemeModel*model = self.dataSource[indexPath.row];
}
#pragma mark 点击CollectionView触发事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //ThemeModel*model = self.dataSource[indexPath.row];
}
#pragma mark 设置CollectionViewCell是否可以被点击
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (UICollectionView*)collectionView{
    if(!_collectionView){
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(self.view.width,BBHeight-bottomNeedHeight-BBNavHeight);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.sectionInset = UIEdgeInsetsMake(0,0,0,0);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,BBNavHeight, BBWidth,BBHeight-bottomNeedHeight-BBNavHeight) collectionViewLayout:layout];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = kwhite;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled=YES;
        _collectionView.scrollEnabled = YES;
        //注册Cell
        [_collectionView registerClass:[PaperCollectionViewCell class] forCellWithReuseIdentifier:@"PaperCollectionViewCell"];
    }
    return _collectionView;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if( (int)scrollView.contentOffset.x % (int)BBWidth == 0){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ThemePlayerCell_stop" object:nil];
        [self setToolViewSelect:(int)scrollView.contentOffset.x/(int)BBWidth];
    }
}
- (BOOL)hidesBottomBarWhenPushed{
    return YES;
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
