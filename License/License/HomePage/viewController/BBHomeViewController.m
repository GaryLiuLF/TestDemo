//
//  BBHomeViewController.m
//  BeibeiMusic
//
//  Created by wei on 2019/7/7.
//  Copyright © 2019年 wei. All rights reserved.
//

#import "BBHomeViewController.h"
#import "OpenController.h"
#import "TotolViewController.h"
#import "BBProViewController.h"

#import "HomeKCell1.h"
#import "HomeKCell2.h"
#import "HomeKCell3.h"
#import "HomeKCell4.h"
#import "BBQuestionView.h"
#import "LEEAlert.h"

#import "BBInstructionsViewController.h"
#import "BBScoreViewController.h"
#import "TestApplyViewController.h"

@interface BBHomeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>{
    UIImageView*fan_v;
}
@property (nonatomic,strong)UICollectionView*collectionView;
@property (nonatomic,assign)NSInteger selectTag;
@property (nonatomic,assign)BOOL scrolledNeedChangeBtnState;
@end

@implementation BBHomeViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSArray*cellArray=[self.collectionView visibleCells];
    for(HomeKCell1*cell in cellArray){
        [cell refrsh];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if(BType==0){
        //为了不让首页出现，先用启动图遮挡一下
        [self showLaunchImage];
        OpenController*openViewContoller=[[OpenController alloc] init];
        @weakify(self);
        [self presentViewController:openViewContoller animated:NO completion:^{
            @strongify(self);
            [self closeLaunchImage];
        }];
    }
    [self setBg:kblue titleColor:kwhite];
    UILabel*txt = [UILabel crateLabelWithTitle:@"驾考通" font:PFontZ(18) color:kwhite location:1];
    txt.frame = CGRectMake(0, 0, 100, 20);
    self.navigationItem.titleView = txt;
    
    
    UIImage*fanImg = BImage(@"bg_ fan");
    fan_v = [[UIImageView alloc] initWithImage:fanImg];
    fan_v.frame = CGRectMake(0, BBNavHeight, self.view.width, self.view.width*fanImg.size.height/fanImg.size.width);
    fan_v.userInteractionEnabled = YES;
    [self.view addSubview:fan_v];
    
    NSArray*titles=@[@"科目一",@"科目四"];
    for(int i=0;i<titles.count;i++){
        UIButton*btn= [[UIButton alloc] init];
        btn.tag = 100+i;
        btn.frame = CGRectMake(0+BBWidth/2 * (i%4), 0, BBWidth/2, fan_v.height/3*2);
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        btn.titleLabel.font = PFontH(16);
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [fan_v addSubview:btn];
    }
    float selectWidth=[UILabel width:@"科目四" font:PFontH(16) h:20];
    UIView*selectView = [[UIView alloc] initWithFrame:BBRect(BBWidth/4-selectWidth/2, fan_v.height/3*2-8, selectWidth, 2.5)];
    selectView.tag = 111;
    selectView.backgroundColor = kwhite;
    [fan_v addSubview:selectView];
    self.scrolledNeedChangeBtnState = YES;
    [self.view addSubview:self.collectionView];
    self.selectTag = [CommandManager sharedManager].subType-1;
    if(_selectTag==1){
        self.scrolledNeedChangeBtnState = NO;
        NSIndexPath*path = [NSIndexPath indexPathForRow:_selectTag inSection:0];
        [self.collectionView scrollToItemAtIndexPath:path atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        self.scrolledNeedChangeBtnState = YES;
    }
    
}
- (void)btnAction:(UIButton*)sender{
    self.selectTag = sender.tag - 100;
    NSIndexPath*path = [NSIndexPath indexPathForRow:_selectTag inSection:0];
    self.scrolledNeedChangeBtnState = NO;
    [self.collectionView scrollToItemAtIndexPath:path atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    self.scrolledNeedChangeBtnState = YES;
}
- (void)setSelectTag:(NSInteger)selectTag{
    _selectTag = selectTag;
    if(self.selectTag==0){
        [CommandManager sharedManager].subType = 1;
        [CommandManager save:@"1" key:psubtype];
        //showed
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSMutableDictionary*info = [[DBTool sharedDB] getMoniInfoWithSubType];
            if(info){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [LEEAlert alert].config
                    .LeeAddTitle(^(UILabel *label) {
                        label.text =@"温馨提示";
                        label.font = PFontH(16);
                        label.textColor = kblock;
                        label.textAlignment = NSTextAlignmentCenter;
                    })
                    .LeeAddContent(^(UILabel *label) {
                        float percent = (float)([[info objectForKey:@"right"] intValue] +  [[info objectForKey:@"wrong"] intValue]);
                        int time = [[info objectForKey:@"useTime"] intValue];
                        label.text =[NSString stringWithFormat:@"您还有模拟考试未完成，已进行%.1f%%，用时%02d分%02d秒，是否继续考试？",percent,time/60,time%60];
                        label.font = PFontS(14);
                        label.textColor = kblock;
                        label.textAlignment = NSTextAlignmentCenter;
                    })
                    .LeeAction(@"继续考试",^{
                        TotolViewController*totolController = [[TotolViewController alloc] init];
                        totolController.type = value_moni;
                        totolController.moniId = [[info objectForKey:@"moni_id"] intValue];
                        [self.navigationController pushViewController:totolController animated:YES];
                    })
                    .LeeAction(@"不再提醒",^{
                        [[DBTool sharedDB] updateMoniReslutCompleteWithID:[[info objectForKey:@"moni_id"] intValue]];
                    })
                    .LeeShow();
                });
            }
        });
        
    }else{
        [CommandManager sharedManager].subType = 2;
        [CommandManager save:@"2" key:psubtype];
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSMutableDictionary*info = [[DBTool sharedDB] getMoniInfoWithSubType];
            if(info){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [LEEAlert alert].config
                    .LeeAddTitle(^(UILabel *label) {
                        label.text =@"温馨提示";
                        label.font = PFontH(16);
                        label.textColor = kblock;
                        label.textAlignment = NSTextAlignmentCenter;
                    })
                    .LeeAddContent(^(UILabel *label) {
                        float percent = ([[info objectForKey:@"right"] intValue] +  [[info objectForKey:@"wrong"] intValue])*2.f;
                        int time = [[info objectForKey:@"useTime"] intValue];
                        label.text =[NSString stringWithFormat:@"您还有模拟考试未完成，已进行%.1f%%，用时%02d分%02d秒，是否继续考试？",percent,time/60,time%60];
                        label.font = PFontS(14);
                        label.textColor = kblock;
                        label.textAlignment = NSTextAlignmentCenter;
                    })
                    .LeeAction(@"继续考试",^{
                        TotolViewController*totolController = [[TotolViewController alloc] init];
                        totolController.type = value_moni;
                        totolController.moniId = [[info objectForKey:@"moni_id"] intValue];
                        [self.navigationController pushViewController:totolController animated:YES];
                    })
                    .LeeAction(@"不再提醒",^{
                        [[DBTool sharedDB] updateMoniReslutCompleteWithID:[[info objectForKey:@"moni_id"] intValue]];
                    })
                    .LeeShow();
                });
            }
        });
    }
    for(int i=0;i<4;i++){
        UIButton*btn = [fan_v viewWithTag:100+i];
        if(selectTag==i){
            [btn setTitleColor:kwhite forState:UIControlStateNormal];
        }else{
            [btn setTitleColor:[kwhite colorWithAlphaComponent:0.5] forState:UIControlStateNormal];
        }
    }
    [UIView animateWithDuration:0.1 animations:^{
        UIView*selectView = [fan_v viewWithTag:111];
        CGRect rect = selectView.frame;
        rect.origin.x = BBWidth/4-rect.size.width/2+selectTag*BBWidth/2;
        selectView.frame = rect;
    }];
    
    //判断是否有未完成的模拟题训练
    
    
}
#pragma mark 设置CollectionView的组数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
#pragma mark 设置CollectionView每组所包含的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 2;
}
#pragma mark 设置CollectionCell的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row==0){
        HomeKCell1*cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeKCell1" forIndexPath:indexPath];
        @weakify(self);
        [[cell.itemClickSignal takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x){
            @strongify(self);
            if([x intValue]==0){
                TotolViewController*totolController = [[TotolViewController alloc] init];
                totolController.type = KValue_id;
                [self.navigationController pushViewController:totolController animated:YES];
            }else if ([x intValue]==1){
                TotolViewController*totolController = [[TotolViewController alloc] init];
                totolController.type = value_id2;
                [self.navigationController pushViewController:totolController animated:YES];
            }else if ([x intValue]==2){
                //专项
                BBProViewController*pro = [[BBProViewController alloc] init];
                [self.navigationController pushViewController:pro animated:YES];
                [pro.valueSiganl subscribeNext:^(id x) {
                    
                }];
            }else if ([x intValue]==3){
                //模拟考试
                TotolViewController*totolController = [[TotolViewController alloc] init];
                totolController.type = value_moni;
                totolController.moniId = 0;
                [self.navigationController pushViewController:totolController animated:YES];
            }else if ([x intValue]==4){
                //须知
                BBInstructionsViewController*instruct = [[BBInstructionsViewController alloc] init];
                [self.navigationController pushViewController:instruct animated:YES];
            }else if ([x intValue]==5){
                //查询
                BBScoreViewController*score = [[BBScoreViewController alloc] init];
                [self.navigationController pushViewController:score animated:YES];
            }else if ([x intValue]==6){
                //查询
                TestApplyViewController*score = [[TestApplyViewController alloc] init];
                [self.navigationController pushViewController:score animated:YES];
            }else if ([x intValue]==10){
                //全真模拟？
                BBQuestionView*view = [[BBQuestionView alloc] initWithFrame:CGRectMake(0, 0, BBWidth, BBHeight) subject:0];
                [self.tabBarController.view addSubview:view];
            }
        }];
        return cell;
    }else{
        HomeKCell2*cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeKCell2" forIndexPath:indexPath];
        @weakify(self);
        [[cell.itemClickSignal takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x){
            
            @strongify(self);
            if([x intValue]==0){
                TotolViewController*totolController = [[TotolViewController alloc] init];
                totolController.type = KValue_id;
                [self.navigationController pushViewController:totolController animated:YES];
            }else if ([x intValue]==1){
                TotolViewController*totolController = [[TotolViewController alloc] init];
                totolController.type = value_id2;
                [self.navigationController pushViewController:totolController animated:YES];
            }else if ([x intValue]==2){
                //专项
                BBProViewController*pro = [[BBProViewController alloc] init];
                [self.navigationController pushViewController:pro animated:YES];
                [pro.valueSiganl subscribeNext:^(id x) {
                    
                }];
            }else if ([x intValue]==3){
                //模拟考试
                TotolViewController*totolController = [[TotolViewController alloc] init];
                totolController.type = value_moni;
                totolController.moniId = 0;
                [self.navigationController pushViewController:totolController animated:YES];
            }else if ([x intValue]==4){
                //须知
                BBInstructionsViewController*instruct = [[BBInstructionsViewController alloc] init];
                [self.navigationController pushViewController:instruct animated:YES];
            }else if ([x intValue]==5){
                //查询
                BBScoreViewController*score = [[BBScoreViewController alloc] init];
                [self.navigationController pushViewController:score animated:YES];
            }else if ([x intValue]==6){
                //考试预约
                TestApplyViewController*score = [[TestApplyViewController alloc] init];
                [self.navigationController pushViewController:score animated:YES];
            }else if ([x intValue]==10){
                //全真模拟？
                BBQuestionView*view = [[BBQuestionView alloc] initWithFrame:CGRectMake(0, 0, BBWidth, BBHeight) subject:1];
                [self.tabBarController.view addSubview:view];
            }
        }];
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath;{
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
        NSLog(@"se %f %f",self.navigationController.toolbar.height,self.view.height);
        layout.itemSize = CGSizeMake(self.view.width,BBHeight-44.f-BBToolBot-fan_v.bottom);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.sectionInset = UIEdgeInsetsMake(0,0,0,0);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,fan_v.bottom, BBWidth,BBHeight-44.f-BBToolBot-fan_v.bottom) collectionViewLayout:layout];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = kwhite;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled=YES;
        _collectionView.bounces=YES;
        _collectionView.scrollEnabled = YES;
        //注册Cell
        [_collectionView registerClass:[HomeKCell1 class] forCellWithReuseIdentifier:@"HomeKCell1"];
        [_collectionView registerClass:[HomeKCell2 class] forCellWithReuseIdentifier:@"HomeKCell2"];
        [_collectionView registerClass:[HomeKCell3 class] forCellWithReuseIdentifier:@"HomeKCell3"];
        [_collectionView registerClass:[HomeKCell4 class] forCellWithReuseIdentifier:@"HomeKCell4"];
    }
    return _collectionView;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(self.scrolledNeedChangeBtnState==YES){
        if((int)scrollView.contentOffset.x % (int)BBWidth == 0){
            self.selectTag = (int)scrollView.contentOffset.x / (int)BBWidth;
        }
    }
}


- (void)showLaunchImage{
    UIImage*launchImage = [UIImage imageNamed:[self getLaunchImageName]];
    UIImageView*launchView = [[UIImageView alloc] initWithImage:launchImage];
    launchView.tag = 10;
    [launchView setFrame:CGRectMake(0, 0, BBWidth, BBHeight)];
    UIWindow*window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:launchView];
}
- (void)closeLaunchImage{
    UIWindow*window = [UIApplication sharedApplication].keyWindow;
    UIImageView*launchView = [window viewWithTag:10];
    if(launchView){
        [launchView removeFromSuperview];
    }
}
- (NSString *)getLaunchImageName
{
    CGSize viewSize = CGSizeMake(BBWidth,BBHeight);
    // 竖屏
    NSString *viewOrientation = @"Portrait";
    NSString *launchImageName = nil;
    NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for (NSDictionary* dict in imagesDict)
    {
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        if (CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]])
        {
            launchImageName = dict[@"UILaunchImageName"];
        }
    }
    return launchImageName;
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
