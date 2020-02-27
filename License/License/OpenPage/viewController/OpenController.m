//
//  BBHomeViewController.m
//  BeibeiMusic
//
//  Created by wei on 2019/7/7.
//  Copyright © 2019年 wei. All rights reserved.
//

#import "OpenController.h"
#import "CitySelectView.h"
#import "BBPickerView.h"
#import "LearnTypeView.h"
#import "FMDB.h"
#import <CoreLocation/CoreLocation.h>
@interface OpenController ()<CLLocationManagerDelegate>
@property (nonatomic,strong)CitySelectView*provinceView;
@property (nonatomic,strong)CitySelectView*cityView;

@property (nonatomic,strong)NSString*provinceId;

@property (nonatomic,strong)LearnTypeView*learnView1;
@property (nonatomic,strong)LearnTypeView*learnView2;
@property (nonatomic,strong)LearnTypeView*learnView3;
@property (nonatomic,strong)LearnTypeView*learnView4;

@property (nonatomic,strong)UIButton*startBtn;


//数据库
@property (nonatomic,strong)FMDatabase*fmdb;
@property(nonatomic,strong) CLLocationManager *locationManager;
@property (nonatomic,assign)BOOL isOld;
@end

@implementation OpenController
- (instancetype)initWithOld:(BOOL)old;{
    self = [super init];
    if(self){
        self.isOld = old;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createDB];
    BOOL isIphone5= _iPhone5;
    float titleLeftSpace = 50.f;
    float viewLineSpace = 15.f;
    float textLineSpace = 30.f;
    float ii = self.view.width>375 ? 0.25:0.20;
    UIView*topView = [[UIView alloc] initWithFrame:BBRect(0, 0, self.view.width, self.view.height*ii)];
    topView.backgroundColor = kblue;
    [self.view addSubview:topView];
    int fontSize = self.view.width>375 ? 30:25;
    
    UILabel*textlb = [UILabel crateLabelWithTitle:self.isOld?@"一起来重新选择驾考类型吧":@"一起来开启您的学车之旅吧" font:PFontH(fontSize) color:kwhite location:0];
    textlb.numberOfLines=0;
    textlb.frame = CGRectMake(titleLeftSpace,0,topView.width-titleLeftSpace*2,topView.height);
    [topView addSubview:textlb];
    //选择您的学车地点
    //选择您的学车类型
    textlb = [UILabel crateLabelWithTitle:@"您考试的城市？" font:PFontX(22) color:kblock location:0];
    textlb.frame = BBRect(textLineSpace,topView.bottom+viewLineSpace,self.view.width-textLineSpace*2,23);
    [self.view addSubview:textlb];
    
    @weakify(self);
    
    [CommandManager save:self.provinceId key:pprovenceid];
    [CommandManager save:self.cityView.tf.text key:pcity];
    
    self.provinceId = [CommandManager getValue:pprovenceid];
    NSString*province = [CommandManager getValue:pprovence];
    NSString*citt = [CommandManager getValue:pcity];

    _provinceView = [[CitySelectView alloc] initWithFrame:BBRect(textLineSpace,textlb.bottom+(isIphone5?8:12), self.view.width-2*textLineSpace, isIphone5?40:50) andPrompt:@"选择您所在的省/市"];
    if(province.length>0){
        _provinceView.tf.text = province;
    }
    [self.view addSubview:_provinceView];
    [_provinceView.clickSignal subscribeNext:^(id x) {
        @strongify(self);
        BBPickerView*pickerView = [[BBPickerView alloc] initWithFrame:BBRect(0, 0, BBWidth, BBHeight)];
        pickerView.dataSource = [self getProvence];
        [self.view addSubview:pickerView];
        [pickerView showPicker];
        @weakify(self);
        [pickerView.valuesignal subscribeNext:^(NSDictionary* x) {
            @strongify(self);
            if(![self.provinceView.tf.text isEqualToString:x[@"name"]]){
                self.provinceId = x[@"id"];
                self.provinceView.tf.text=x[@"name"];
                self.cityView.tf.text=@"";
            }
        }];
    }];
    
    _cityView = [[CitySelectView alloc] initWithFrame:BBRect(textLineSpace,_provinceView.bottom+(isIphone5?8:12), self.view.width-2*textLineSpace, isIphone5?40:50) andPrompt:@"选择您所在的市/区"];
    if(citt.length>0){
        _cityView.tf.text = citt;
    }
    [self.view addSubview:_cityView];
    [_cityView.clickSignal subscribeNext:^(id x) {
        @strongify(self);
        if(self.provinceId.length>0){
            BBPickerView*pickerView = [[BBPickerView alloc] initWithFrame:BBRect(0, 0, BBWidth, BBHeight)];
            pickerView.dataSource = [self getCitys:self.provinceId];
            [self.view addSubview:pickerView];
            [pickerView showPicker];
            @weakify(self);
            [pickerView.valuesignal subscribeNext:^(NSDictionary* x) {
                @strongify(self);
                if(![self.cityView.tf.text isEqualToString:x[@"name"]]){
                    self.cityView.tf.text=x[@"name"];
                }
            }];
        }else{
            [MBProgressHUD showToastToView:self.view withText:@"请先选择您所在的省/市"];
        }
    }];
    
    
    textlb = [UILabel crateLabelWithTitle:@"您考取的驾照类型？" font:PFontX(22) color:kblock location:0];
    textlb.frame = BBRect(textLineSpace,_cityView.bottom+viewLineSpace,self.view.width-textLineSpace*2,23);
    [self.view addSubview:textlb];
    
    float itemWidth = 120;
    float itemHeight = 120;
    float space = (self.view.width-itemWidth*2)/3;
    _learnView1=[[LearnTypeView alloc] initWithFrame:BBRect(space, textlb.bottom+(isIphone5?0:5), itemWidth, itemHeight)];
    _learnView1.type = kLearncar;
    if(_isOld){
        _learnView1.isSelect = [CommandManager sharedManager].carType==1?YES:NO;
    }
    [self.view addSubview:_learnView1];
    _learnView2=[[LearnTypeView alloc] initWithFrame:BBRect(space*2+itemWidth, textlb.bottom+(isIphone5?0:5), itemWidth, itemHeight)];
    _learnView2.type = kLearnvan;
    if(_isOld){
        _learnView2.isSelect = [CommandManager sharedManager].carType==2?YES:NO;
    }
    [self.view addSubview:_learnView2];
    _learnView3=[[LearnTypeView alloc] initWithFrame:BBRect(space, _learnView2.bottom+(isIphone5?-8:0), itemWidth, itemHeight)];
    _learnView3.type = kLearnbus;
    if(_isOld){
        _learnView3.isSelect = [CommandManager sharedManager].carType==3?YES:NO;
    }
    [self.view addSubview:_learnView3];
    _learnView4=[[LearnTypeView alloc] initWithFrame:BBRect(space*2+itemWidth, _learnView2.bottom+(isIphone5?-8:0), itemWidth, itemHeight)];
    _learnView4.type = kLearnmotorcycle;
    if(_isOld){
        _learnView4.isSelect = [CommandManager sharedManager].carType==4?YES:NO;
    }
    [self.view addSubview:_learnView4];
    [_learnView1.valueSiganl subscribeNext:^(id x) {
        @strongify(self);
        self.learnView1.isSelect=YES;
        self.learnView2.isSelect=NO;
        self.learnView3.isSelect=NO;
        self.learnView4.isSelect=NO;
        self.startBtn.backgroundColor = kblue;
        self.startBtn.userInteractionEnabled=YES;
    }];
    [_learnView2.valueSiganl subscribeNext:^(id x) {
        @strongify(self);
        self.learnView1.isSelect=NO;
        self.learnView2.isSelect=YES;
        self.learnView3.isSelect=NO;
        self.learnView4.isSelect=NO;
        self.startBtn.backgroundColor = kblue;
        self.startBtn.userInteractionEnabled=YES;
    }];
    [_learnView3.valueSiganl subscribeNext:^(id x) {
        @strongify(self);
        self.learnView1.isSelect=NO;
        self.learnView2.isSelect=NO;
        self.learnView3.isSelect=YES;
        self.learnView4.isSelect=NO;
        self.startBtn.backgroundColor = kblue;
        self.startBtn.userInteractionEnabled=YES;
    }];
    [_learnView4.valueSiganl subscribeNext:^(id x) {
        @strongify(self);
        self.learnView1.isSelect=NO;
        self.learnView2.isSelect=NO;
        self.learnView3.isSelect=NO;
        self.learnView4.isSelect=YES;
        self.startBtn.backgroundColor = kblue;
        self.startBtn.userInteractionEnabled=YES;
    }];
    
    CGSize size;
    if(isIphone5) size=CGSizeMake(120, 40.f);
    else size=CGSizeMake(140, 44.f);
    _startBtn = [[UIButton alloc] initWithFrame:BBRect(self.view.width/2-size.width/2,_learnView4.bottom+(isIphone5?5:22) , size.width, size.height)];
    _startBtn.layer.cornerRadius = 5.f;
    _startBtn.layer.masksToBounds = YES;
    _startBtn.backgroundColor = [UIColor lightGrayColor];
    _startBtn.userInteractionEnabled = NO;
    [_startBtn setTitle:_isOld?@"确定":@"开始" forState:UIControlStateNormal];
    _startBtn.titleLabel.font = PFontX(22);
    [_startBtn setTitleColor:kwhite forState:UIControlStateNormal];
    [self.view addSubview:_startBtn];
    if(_isOld){
        self.startBtn.backgroundColor = kblue;
        self.startBtn.userInteractionEnabled=YES;
    }
    
    [[self.startBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        //存储类型和位置
        [CommandManager save:self.provinceView.tf.text key:pprovence];
        [CommandManager save:self.provinceId key:pprovenceid];
        [CommandManager save:self.cityView.tf.text key:pcity];
        NSString*cartype=@"1";
        if(self.learnView1.isSelect) cartype=@"1";
        else if(self.learnView2.isSelect) cartype=@"2";
        else if(self.learnView3.isSelect) cartype=@"3";
        else if(self.learnView4.isSelect) cartype=@"4";
        [CommandManager save:cartype key:ptype];
        [CommandManager save:@"1" key:psubtype];
        [CommandManager sharedManager].carType=[cartype intValue];
        [CommandManager sharedManager].subType=1;
        [self dismissViewControllerAnimated:_isOld completion:nil];
    }];
    [self startLoaction];
}


#pragma mark -- location --
- (void)startLoaction{
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager requestWhenInUseAuthorization];
    self.locationManager.delegate = self;
    // 开始定位
    [self.locationManager startUpdatingLocation];
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    //此处locations存储了持续更新的位置坐标值，取最后一个值为最新位置，如果不想让其持续更新位置，则在此方法中获取到一个值之后让locationManager stopUpdatingLocation
    CLLocation *currentLocation = [locations lastObject];
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *array, NSError *error){
        if (array.count > 0){
            CLPlacemark *placemark = [array objectAtIndex:0];
            NSString *city = placemark.locality;
            NSString*administrativeArea=placemark.administrativeArea;
            if(city.length>0 && administrativeArea.length>0){
                @weakify(self);
                dispatch_async(dispatch_get_main_queue(), ^{
                    @strongify(self);
                    self.provinceView.tf.text = administrativeArea;
                    self.cityView.tf.text = city;
                });
            }
        }
    }];
    [manager stopUpdatingLocation];
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if (error.code == kCLErrorDenied) {
        // 提示用户出错原因，可按住Option键点击 KCLErrorDenied的查看更多出错信息，可打印error.code值查找原因所在
    }
}


//构建数据
- (void)createDB{
    NSString *filePath=[[NSBundle mainBundle] pathForResource:@"totolCity" ofType:@"db"];
    _fmdb = [FMDatabase databaseWithPath:filePath];
    [_fmdb open];
    
}
- (NSMutableArray*)getProvence{
    NSMutableArray* ary=[NSMutableArray array];
    FMResultSet *set = [_fmdb executeQuery:@"select * FROM sys_area  WHERE  reid = '0' order by id asc"];
    while ([set next]) {
        NSDictionary*infoDic =@{@"name":[set stringForColumn:@"name"],@"id":[NSString stringWithFormat:@"%d",[set intForColumn:@"id"]]};
        [ary addObject:infoDic];
    }
    return ary;
}
- (NSMutableArray*)getCitys:(NSString*)provenceId{
    NSMutableArray* ary=[NSMutableArray array];
    NSString*sql=[NSString stringWithFormat:@"select * FROM sys_area  WHERE  reid = '%@' order by id asc",provenceId];
    FMResultSet *set = [_fmdb executeQuery:sql];
    while ([set next]) {
        NSDictionary*infoDic =@{@"name":[set stringForColumn:@"name"],@"id":[NSString stringWithFormat:@"%d",[set intForColumn:@"id"]]};
        [ary addObject:infoDic];
    }
    return ary;
}
- (NSMutableArray*)getCountys:(NSString*)cityId{
    NSMutableArray* ary=[NSMutableArray array];
    NSString*sql=[NSString stringWithFormat:@"select * FROM sys_area  WHERE  reid = '%@' order by id asc",cityId];
    FMResultSet *set = [_fmdb executeQuery:sql];
    while ([set next]) {
        NSDictionary*infoDic =@{@"name":[set stringForColumn:@"name"],@"id":[NSString stringWithFormat:@"%d",[set intForColumn:@"id"]]};
        [ary addObject:infoDic];
    }
    return ary;
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
