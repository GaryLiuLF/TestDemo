//
//  BBMineViewController.m
//  BeibeiMusic
//
//  Created by wei on 2019/7/7.
//  Copyright © 2019年 wei. All rights reserved.
//  所选类型  是否开启通知  考试答题后直接下一题  ／ 分享给好友  意见反馈   给个好评   版本号
//差友盟统计，推送

#import "BBMineViewController.h"
#import "BBSetCell.h"
#import "LearnTypeView.h"
#import "OpenController.h"
#import <MessageUI/MFMailComposeViewController.h>
#import <Social/Social.h>
#import "AppDelegate.h"
#import "MyApplyViewController.h"

@class AppDelegate;

@interface BBMineViewController ()<UITableViewDelegate,UITableViewDataSource,MFMailComposeViewControllerDelegate>
@property (nonatomic,strong)UITableView*tableView;
@property (nonatomic,strong)NSMutableArray*dataSource;
@property (nonatomic,strong)UIView*headerView;
@property (nonatomic,strong)UIView*footerView;
@property (nonatomic,strong)LearnTypeView*learnView1;
@end

@implementation BBMineViewController

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    _learnView1.type = [CommandManager sharedManager].carType;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setBg:kblue titleColor:kwhite];
    UILabel*titelabel = [UILabel crateLabelWithTitle:@"设置" font:PFontZ(18) color:kwhite location:1];
    titelabel.frame = CGRectMake(0, 0, 100, 20);
    self.navigationItem.titleView = titelabel;
    [self makeData];
    [self.view addSubview:self.tableView];
}
- (void)makeData{
    BBSetModel*model1=[[BBSetModel alloc] init];
    model1.title = @"考试答题后直接下一题";
    model1.imageName=@"ics_xy";
    model1.needSwith=YES;
    model1.isOn=[CommandManager sharedManager].canStep;
    
    BBSetModel*model2=[[BBSetModel alloc] init];
    model2.title = @"是否接收消息";
    model2.imageName=@"ics_tz";
    model2.needSwith=YES;
    model2.isOn=[CommandManager sharedManager].canPush;
    
    BBSetModel*model3=[[BBSetModel alloc] init];
    model3.title = @"给个好评";
    model3.imageName=@"ics_pl";
    model3.needSwith=NO;
    
    BBSetModel*model4=[[BBSetModel alloc] init];
    model4.title = @"意见反馈";
    model4.imageName=@"ics_fk";
    model4.needSwith=NO;
    
    BBSetModel*model5=[[BBSetModel alloc] init];
    model5.title = @"分享应用";
    model5.imageName=@"ics_fx";
    model5.needSwith=NO;
    
    BBSetModel*model6=[[BBSetModel alloc] init];
    model6.title = @"我的考试预约";
    model6.imageName=@"ics_yy";
    model6.needSwith=NO;
    
    [self.dataSource addObject:model1];
    [self.dataSource addObject:model2];
    [self.dataSource addObject:model3];
    [self.dataSource addObject:model4];
    [self.dataSource addObject:model5];
    [self.dataSource addObject:model6];
}


#pragma mark --- tableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString*ID = @"BBSetCell";
    BBSetModel*model = self.dataSource[indexPath.row];
    BBSetCell*cell=(BBSetCell*)[tableView dequeueReusableCellWithIdentifier:ID];
    if(!cell) cell = [[BBSetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    cell.model =model;
    @weakify(self,model);
    [[cell.valueSignal takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(NSNumber*x) {
        //BBCanPush
        @strongify(self,model);
        if([model.imageName isEqualToString:@"ics_xy"]){
            [CommandManager save:x key:BBCanStepWhenAnsered];
            [CommandManager sharedManager].canStep=x.boolValue;
            model.isOn = x.boolValue;
           // [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }else if ([model.imageName isEqualToString:@"ics_tz"]){
            [CommandManager save:x key:BBCanPush];
            [CommandManager sharedManager].canPush=x.boolValue;
            model.isOn = x.boolValue;
            AppDelegate*app = (AppDelegate*)[UIApplication sharedApplication].delegate;
            [app registerNotificate:x.boolValue];
            //[self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
    }];
    return cell;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 0.01;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 54.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.row==2){
        NSString  * nsStringToOpen = [NSString  stringWithFormat: @"itms-apps://itunes.apple.com/app/id%@?action=write-review",@"1474206982"];//替换为对应的APPID
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:nsStringToOpen]];
    }
    else if(indexPath.row==3){
        MFMailComposeViewController*mail = [[MFMailComposeViewController alloc] init];
        if (!mail) {
            // 在设备还没有添加邮件账户的时候mailViewController为空，
            // 下面的present view controller会导致程序崩溃，这里要作出判断 设备还没有添加邮件账户
            return;
        }
        mail.mailComposeDelegate=self;
        [mail setSubject:@"意见反馈"];
        [mail setToRecipients:[NSArray arrayWithObjects:@"1173138998@qq.com", nil]];
        [mail setCcRecipients:[NSArray arrayWithObjects:@"lilei@jingxuwu.com", nil]];
        [mail setMessageBody:@"<p><span style=\"color:#111111;\"><span style=\"font-size:14px;\">正文</span><span style=\"color:#000000;font-size:14px;\"><strong><br /></strong></span></span></p><p><span style=\"color:#111111;\"><span style=\"color:#000000;font-size:14px;\"><strong></strong></span></span></p><p><br /></p><p><br /></p><p><br /></p><p><span style=\"color:#111111;\"><span style=\"color:#111111;\"><span style=\"color:#111111;\">（在上面输入想法）</span></span></span></p>" isHTML:YES];
        [self presentViewController:mail animated:YES completion:^{
            
        }];
    }else if (indexPath.row==4){
        //分享的标题
        NSString *text =@"驾考通，让拿驾照更轻松";
        //分享的图片  //
        UIImage *image= [UIImage imageNamed:@"shareImage"];
        //分享的url
        NSString  * nsStringToOpen = [NSString  stringWithFormat: @"https://itunes.apple.com/cn/app/id%@?mt=8",@"1474206982"];//替换为对应的APPID
        NSURL*url = [NSURL URLWithString:nsStringToOpen];
        //把分项的文字, 图片, 链接放入数组
        NSArray*activityItems =@[text,image,url];
        UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
        //不出现在活动项目
        activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard,UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll];//弹出分享的页面
        [self presentViewController:activityVC animated:YES completion:nil];
        // 分享后回调
        activityVC.completionWithItemsHandler= ^(UIActivityType  _NullableactivityType,BOOL completed,NSArray*_NullablereturnedItems,NSError*_NullableactivityError) {
            if(completed) {
                NSLog(@"completed");
                //分享成功
            }else{
                NSLog(@"cancled");
            }
        };
        
    }else if (indexPath.row == 5) {
        MyApplyViewController *vc = [MyApplyViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
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
        _tableView.separatorColor = klineColor;
        _tableView.delegate=self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = kwhite;
        [_tableView setTableFooterView:self.footerView];
        [_tableView setTableHeaderView:self.headerView];
    }
    return _tableView;
}
- (UIView*)headerView{
    if(!_headerView){
        _headerView = [[UIView alloc] initWithFrame:BBRect(0, 0, BBWidth, 120+16.f)];
        _headerView.backgroundColor = kwhite;
        UIView*linev = [[UIView alloc] initWithFrame:BBRect(0, _headerView.height-0.5, BBWidth, 0.5)];
        linev.backgroundColor = klineColor;
        [_headerView addSubview:linev];
        
        _learnView1=[[LearnTypeView alloc] initWithFrame:BBRect(BBWidth/2-60, 0.f, 120, 120)];
        _learnView1.type = kLearncar;
        [_headerView addSubview:_learnView1];
        UIView*blankv = [[UIView alloc] initWithFrame:_headerView.bounds];
        [_headerView addSubview:blankv];
        
        UIImageView*arrowView =[[UIImageView alloc] initWithFrame:BBRect(BBWidth-12-20, _headerView.height/2-10, 20, 20)];
        arrowView.image = BImage(@"icon_rightArrow");
        [_headerView addSubview:arrowView];
        
        [_headerView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerCleck)]];
    }
    return _headerView;
}
- (UIView*)footerView{
    if(!_footerView){
        _footerView = [[UIView alloc] initWithFrame:BBRect(0, 0, BBWidth, 115.f)];
        _footerView.backgroundColor = kwhite;
        
        UIView*linev = [[UIView alloc] initWithFrame:BBRect(0, 0, BBWidth, 0.5)];
        linev.backgroundColor = klineColor;
        [_footerView addSubview:linev];
        
        UIImageView*icon = [[UIImageView alloc] init];
        icon.frame = BBRect(BBWidth/2-30, 20, 60, 60);
        icon.image = BImage(@"icon40");
        [_footerView addSubview:icon];
        
        UILabel*_textLb = [UILabel crateLabelWithTitle:[NSString stringWithFormat:@"版本 %@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]] font:PFontX(13) color:kblock location:1];
        _textLb.frame = BBRect(0, icon.bottom+15, BBWidth, 20);
        _textLb.numberOfLines = 0;
        [_footerView addSubview:_textLb];
        
    }
    return _footerView;
}

- (void)headerCleck{
    OpenController*openVC = [[OpenController alloc] initWithOld:YES];
    [self presentViewController:openVC animated:YES completion:^{
        
    }];
}
#pragma mark - MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error{
    [controller dismissViewControllerAnimated:YES completion:nil];
    switch (result) {
        case MFMailComposeResultCancelled:
        {
            //NSLog(@"发送取消");
        }
            break;
        case MFMailComposeResultSaved:
        {
            //NSLog(@"发送保存");
        }
            break;
        case MFMailComposeResultSent:
        {
            //NSLog(@"发送成功");
        }
            break;
        case MFMailComposeResultFailed:
        {
            //NSLog(@"发送失败");
        }
            break;
            
        default:
            break;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
