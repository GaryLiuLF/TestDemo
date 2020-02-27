//
//  DBTool.m
//  License
//
//  Created by wei on 2019/7/11.
//  Copyright © 2019年 wei. All rights reserved.
//

#import "DBTool.h"
#import "FMDB.h"
#import "AlongModel.h"
#import "WrongModel.h"
static DBTool *manager = nil;

@interface DBTool()
@property (nonatomic,strong)FMDatabase*fmdb;
@property (nonatomic,strong)NSMutableArray*datasss;

@property (nonatomic,strong)NSArray*moni_array;

@end


@implementation DBTool
+ (instancetype)sharedDB
{
    if (manager == nil)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            manager = [[[self class] alloc] init];
        });
    }
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentPath = [paths objectAtIndex:0];
        NSString *desPath = [documentPath stringByAppendingPathComponent:@"license.sqlite"];
        //NSString *filePath=[[NSBundle mainBundle] pathForResource:@"license" ofType:@"sqlite"];
        _fmdb = [FMDatabase databaseWithPath:desPath];
        [_fmdb open];
        
        //模拟练习需要的2张表
        _moni_array = @[@"questionID",
                          @"question",
                          @"questionType",
                          @"optionA",
                          @"optionB",
                          @"optionC",
                          @"optionD",
                          @"key",
                          @"imageURL",
                          @"explains",
                          @"licenseType",
                          @"subjectType",
                          @"value",
                          @"moni_id"
                          ];
        NSString*excute_start = [NSString stringWithFormat:@"create table if not exists %@ (ID integer primary key autoincrement",kMoniList];
        NSString*excute_mid = @"";
        for(int i=0;i<_moni_array.count;i++){
            if(i==_moni_array.count-1){
                excute_mid = [NSString stringWithFormat:@" %@,%@ integer ",excute_mid,_moni_array[i]];
            }else{
                excute_mid = [NSString stringWithFormat:@" %@,%@ text ",excute_mid,_moni_array[i]];
            }
        }
        NSString*excute_reslut = [NSString stringWithFormat:@"%@%@)",excute_start,excute_mid];
        [self.fmdb executeUpdate:excute_reslut];
        
        //创建结果表
        NSArray*reslut = @[@"licenseType",
                           @"subjectType",
                           @"moni_id",
                           @"right",
                           @"wrong",
                           @"havePlay",
                           @"useTime",
                           @"startTime"
                        ];
        excute_start = [NSString stringWithFormat:@"create table if not exists %@ (ID integer primary key autoincrement",kMoniReslut];
        excute_mid = @"";
        for(int i=0;i<reslut.count;i++){
            NSString*key = reslut[i];
            if([key isEqualToString:@"licenseType"] || [key isEqualToString:@"subjectType"] || [key isEqualToString:@"startTime"]){
                excute_mid = [NSString stringWithFormat:@"%@,%@ text",excute_mid,key];
            }else{
                excute_mid = [NSString stringWithFormat:@"%@,%@ integer",excute_mid,key];
            }
        }
        excute_reslut = [NSString stringWithFormat:@"%@%@)",excute_start,excute_mid];
        [self.fmdb executeUpdate:excute_reslut];
        
    }
    return self;
}


- (NSMutableArray<ThemeModel*>*)getDataWithCarType:(NSString*)carType andValueType:(KValueListType)valueType onlyWrong:(BOOL)isWrong;{
    NSMutableArray* array=[NSMutableArray array];
    NSString*selectSql=@"";
    if(valueType==KValue_id){
        if(isWrong){
            selectSql = [NSString stringWithFormat:@"select * FROM %@ where value_id like '2-%%' order by id asc",carType];
        }else{
            selectSql = [NSString stringWithFormat:@"select * FROM %@ order by id asc",carType];
        }
    }else if (valueType == value_id2){
        if(isWrong){
            selectSql = [NSString stringWithFormat:@"select * FROM %@ where value_id2 like '2-%%' order by ID_random asc",carType];
        }else{
            selectSql = [NSString stringWithFormat:@"select * FROM %@ order by ID_random asc",carType];
        }
        
    }else if (valueType == value_check){
        if(isWrong){
            selectSql = [NSString stringWithFormat:@"select * FROM %@ where questionType = '1' and value_check like '2-%%' order by id asc",carType];
        }else{
            selectSql = [NSString stringWithFormat:@"select * FROM %@ where questionType = '1' order by id asc",carType];
        }
        
    }else if (valueType == value_sigle){
        if(isWrong){
            selectSql = [NSString stringWithFormat:@"select * FROM %@ where questionType = '2' and value_sigle like '2-%%' order by id asc",carType];
        }else{
            selectSql = [NSString stringWithFormat:@"select * FROM %@ where questionType = '2' order by id asc",carType];
        }
        
    }else if (valueType == value_mul){
        if(isWrong){
            selectSql = [NSString stringWithFormat:@"select * FROM %@ where questionType = '3' and value_mul like '2-%%' order by id asc",carType];
        }else{
            selectSql = [NSString stringWithFormat:@"select * FROM %@ where questionType = '3' order by id asc",carType];
        }
        
    }else if (valueType == value_text){
        if(isWrong){
            selectSql = [NSString stringWithFormat:@"select * FROM %@ where imageURL is null and value_text like '2-%%' order by id asc",carType];
        }else{
            selectSql = [NSString stringWithFormat:@"select * FROM %@ where imageURL is null order by id asc",carType];
        }
        
    }else if (valueType == value_image){
        if(isWrong){
            selectSql = [NSString stringWithFormat:@"select * FROM %@ WHERE imageURL like '%%%@%%' and value_image like '2-%%' order by id asc",carType,@".jpg"];
        }else{
            selectSql = [NSString stringWithFormat:@"select * FROM %@ WHERE imageURL like '%%%@%%' order by id asc",carType,@".jpg"];
        }
        
    }else if (valueType == value_vedio){
        if(isWrong){
            selectSql = [NSString stringWithFormat:@"select * FROM %@ WHERE imageURL like '%%%@%%' and value_vedio like '2-%%' order by id asc",carType,@".swf"];
        }else{
            selectSql = [NSString stringWithFormat:@"select * FROM %@ WHERE imageURL like '%%%@%%' order by id asc",carType,@".swf"];
        }
        
    }
    FMResultSet *set = [_fmdb executeQuery:selectSql];
    while ([set next]) {
        [array addObject:[self getModelWithSet:set]];
    }
    return array;
}
- (NSRange)getRightAndWrongNumberWithCarType:(NSString*)carType andValueType:(KValueListType)valueType;{
    NSInteger rightNumber = 0;
    NSInteger wrongNumber=0;
    NSString*key = @"";
    NSString*selectSql=@"";
    if(valueType==KValue_id){
        key = @"value_id";
        selectSql = [NSString stringWithFormat:@"select * FROM %@ where %@ != '%@' order by id asc",carType,key,@"0-0-0"];
    }else if (valueType == value_id2){
        key = @"value_id2";
        selectSql = [NSString stringWithFormat:@"select * FROM %@ where %@ != '%@' order by ID_random asc",carType,key,@"0-0-0"];
    }else if (valueType == value_check){
        key = @"value_check";
        selectSql = [NSString stringWithFormat:@"select * FROM %@ where %@ != '%@' and questionType = '1' order by id asc",carType,key,@"0-0-0"];
    }else if (valueType == value_sigle){
        key = @"value_sigle";
        selectSql = [NSString stringWithFormat:@"select * FROM %@ where %@ != '%@' and questionType = '2' order by id asc",carType,key,@"0-0-0"];
    }else if (valueType == value_mul){
        key = @"value_mul";
        selectSql = [NSString stringWithFormat:@"select * FROM %@ where %@ != '%@' and questionType = '3' order by id asc",carType,key,@"0-0-0"];
    }else if (valueType == value_text){
        key = @"value_text";
        selectSql = [NSString stringWithFormat:@"select * FROM %@ where %@ != '%@' and imageURL is null order by id asc",carType,key,@"0-0-0"];
    }else if (valueType == value_image){
        key = @"value_image";
        selectSql = [NSString stringWithFormat:@"select * FROM %@ WHERE imageURL like '%%%@%%' and %@ != '%@' order by id asc",carType,@".jpg",key,@"0-0-0"];
    }else if (valueType == value_vedio){
        key = @"value_vedio";
        selectSql = [NSString stringWithFormat:@"select * FROM %@ WHERE imageURL like '%%%@%%' and %@ != '%@' order by id asc",carType,@".swf",key,@"0-0-0"];
    }
    FMResultSet *set = [_fmdb executeQuery:selectSql];
    while ([set next]) {
        NSString*value = [set stringForColumn:key];
        if([value hasPrefix:@"2-"]){
            wrongNumber++;
        }else if ([value hasPrefix:@"1-"]){
            rightNumber++;
        }
        //NSString*value = [set co]
        //[array addObject:[self getModelWithSet:set]];
    }
    return NSMakeRange(rightNumber, wrongNumber);
}
- (NSArray*)getSunxuDatasWithSubType:(int)subtype;{
    NSString*tableName=@"";
    if([CommandManager sharedManager].carType==1){
        if(subtype==1) tableName= ktype0ke1;
        else tableName= ktype0ke2;
    }else if ([CommandManager sharedManager].carType==2){
        if(subtype==1) tableName= ktype1ke1;
        else tableName= ktype1ke2;
    }else if ([CommandManager sharedManager].carType==3){
        if(subtype==1) tableName= ktype2ke1;
        else tableName= ktype2ke2;
    }else{
        if(subtype==1) tableName= ktype3ke1;
        else tableName= ktype3ke2;
    }
    FMResultSet *set = [_fmdb executeQuery:[NSString stringWithFormat:@"select * FROM %@ ",tableName]];
    NSInteger totol=0;
    NSInteger doit = 0;
    while ([set next]) {
        NSString*value = [set stringForColumn:@"value_id"];
        if(![value isEqualToString:@"0-0-0"]){
            doit++;
        }
        totol++;
    }
    return @[@(totol),@(doit)];
}


- (NSArray*)getSpecialDatas;//获取专项部分的数据
{
    NSString*tableName = [[CommandManager sharedManager] tableName];
    NSString*selectSql=@"";
    //判断
    //ThemeModel;
    int checkNumbers = 0,checkNumbers_play = 0;
    int sigleNumbers = 0,sigleNumbers_play = 0;
    int mulNumbers   = 0,mulNumbers_play = 0;
    int textNumbers  = 0,textNumbers_play = 0;
    int imageNumbers = 0,imageNumbers_play = 0;
    int vedioNumbers = 0,vedioNumbers_play = 0;
    
    selectSql = [NSString stringWithFormat:@"select * FROM %@ order by id asc",tableName];
    FMResultSet *set = [_fmdb executeQuery:selectSql];
    while ([set next]) {
        int type = [set intForColumn:@"questionType"];
        if(type==1){
            checkNumbers++;
            NSString*value = [set stringForColumn:@"value_check"];
            if(![value hasPrefix:@"0"]){
                checkNumbers_play++;
            }
        }else if (type==2){
            sigleNumbers++;
            NSString*value = [set stringForColumn:@"value_sigle"];
            if(![value hasPrefix:@"0"]){
                sigleNumbers_play++;
            }
        }else{
            mulNumbers++;
            NSString*value = [set stringForColumn:@"value_mul"];
            if(![value hasPrefix:@"0"]){
                mulNumbers_play++;
            }
        }
        
        NSString*image = [set stringForColumn:@"imageURL"];
        if(image.length>0){
            if([image rangeOfString:@".swf"].length>0){
                vedioNumbers++;
                NSString*value = [set stringForColumn:@"value_vedio"];
                if(![value hasPrefix:@"0"]){
                    vedioNumbers_play++;
                }
            }else{
                imageNumbers++;
                NSString*value = [set stringForColumn:@"value_image"];
                if(![value hasPrefix:@"0"]){
                    imageNumbers_play++;
                }
            }
        }else{
            textNumbers++;
            NSString*value = [set stringForColumn:@"value_text"];
            if(![value hasPrefix:@"0"]){
                textNumbers_play++;
            }
        }
        
    }
    return @[@(checkNumbers),@(checkNumbers_play),@(sigleNumbers),@(sigleNumbers_play),@(mulNumbers),@(mulNumbers_play),@(textNumbers),@(textNumbers_play),@(imageNumbers),@(imageNumbers_play),@(vedioNumbers),@(vedioNumbers_play)];
}



- (ThemeModel*)getModelWithSet:(FMResultSet*)set{
    ThemeModel*model = [ThemeModel new];
    model.ID=[set intForColumn:@"ID"];
    model.questionID=[set intForColumn:@"questionID"];
    model.question=[set stringForColumn:@"question"];
    model.questionType=[set intForColumn:@"questionType"];
    model.optionA=[set stringForColumn:@"optionA"];
    model.optionB=[set stringForColumn:@"optionB"];
    model.optionC=[set stringForColumn:@"optionC"];
    model.optionD=[set stringForColumn:@"optionD"];
    model.key=[set stringForColumn:@"key"];
    model.imageURL=[set stringForColumn:@"imageURL"];
    model.explains=[set stringForColumn:@"explains"];
    model.licenseType=[set stringForColumn:@"licenseType"];
    model.subjectType=[set stringForColumn:@"subjectType"];
    
    model.ID_random=[set intForColumn:@"ID_random"];
    model.isAnser=[set intForColumn:@"isAnser"];
    model.value_id=[[AlongModel alloc] initWithValue:[set stringForColumn:@"value_id"]];
    model.value_id2=[[AlongModel alloc] initWithValue:[set stringForColumn:@"value_id2"]];
    model.value_check=[[AlongModel alloc] initWithValue:[set stringForColumn:@"value_check"]];
    model.value_image=[[AlongModel alloc] initWithValue:[set stringForColumn:@"value_image"]];
    model.value_text=[[AlongModel alloc] initWithValue:[set stringForColumn:@"value_text"]];
    model.value_vedio=[[AlongModel alloc] initWithValue:[set stringForColumn:@"value_vedio"]];
    model.value_sigle=[[AlongModel alloc] initWithValue:[set stringForColumn:@"value_sigle"]];
    model.value_mul=[[AlongModel alloc] initWithValue:[set stringForColumn:@"value_mul"]];
    return model;
}

- (ThemeModel*)getMoniModelWithSet:(FMResultSet*)set{
    ThemeModel*model = [ThemeModel new];
    model.ID=[set intForColumn:@"ID"];
    model.questionID=[set intForColumn:@"questionID"];
    model.question=[set stringForColumn:@"question"];
    model.questionType=[set intForColumn:@"questionType"];
    model.optionA=[set stringForColumn:@"optionA"];
    model.optionB=[set stringForColumn:@"optionB"];
    model.optionC=[set stringForColumn:@"optionC"];
    model.optionD=[set stringForColumn:@"optionD"];
    model.key=[set stringForColumn:@"key"];
    model.imageURL=[set stringForColumn:@"imageURL"];
    model.explains=[set stringForColumn:@"explains"];
    model.licenseType=[set stringForColumn:@"licenseType"];
    model.subjectType=[set stringForColumn:@"subjectType"];
    if([set stringForColumn:@"value"]){
        model.value_id=[[AlongModel alloc] initWithValue:[set stringForColumn:@"value"]];
    }
    return model;
}

- (void)updateWithCarType:(NSString*)carType andValueType:(KValueListType)type andModel:(ThemeModel*)model;{
    AlongModel*alongModel;
    NSString*typeString = @"";
    if(type==KValue_id){
        alongModel=model.value_id;
        typeString = @"value_id";
    }
    else if (type==value_id2) {
        alongModel=model.value_id2;
        typeString = @"value_id2";
    }
    else if (type==value_check) {
        alongModel=model.value_check;
        typeString = @"value_check";
    }
    else if (type==value_image) {
        alongModel=model.value_image;
        typeString = @"value_image";
    }
    else if (type==value_text) {
        alongModel=model.value_text;
        typeString = @"value_text";
    }
    else if (type==value_vedio) {
        alongModel=model.value_vedio;
        typeString = @"value_vedio";
    }
    else if (type==value_sigle) {
        alongModel=model.value_sigle;
        typeString = @"value_sigle";
    }
    else  {
        alongModel=model.value_mul;
        typeString = @"value_mul";
    }
    NSString*updateSql = [NSString stringWithFormat:@"update %@ set %@ = '%@' where questionID = '%ld'",carType,typeString,[alongModel currentValue],model.questionID];
    BOOL flag = [self.fmdb executeUpdate:updateSql];
    if(flag){
        NSLog(@"suc15");
    }else{
        NSLog(@"fai4");
    }
    
}



#pragma mark--模拟题部分数据操作--
- (NSMutableArray<ThemeModel*>*)getMoniThemesWithCarType:(int)carType subType:(int)subType moniId:(int)moniId;{
    if(moniId==0){
        NSMutableArray*array = [NSMutableArray arrayWithCapacity:1];
        //需要创建数据 carType;// 1 2 3 4   subType;// 1 2
        //SELECT * FROM 表名 ORDER BY RANDOM() limit 1
        if(subType==1){
            NSString*sqlName=[[CommandManager sharedManager] tableName];
            NSString*selectSql = [NSString stringWithFormat:@"SELECT * FROM %@ ORDER BY RANDOM() limit 100",sqlName];
            FMResultSet *set = [_fmdb executeQuery:selectSql];
            while ([set next]) {
                [array addObject:[self getMoniModelWithSet:set]];
            }
        }else{
            NSString*sqlName=[[CommandManager sharedManager] tableName];
            NSString*selectSql = [NSString stringWithFormat:@"SELECT * FROM %@ where questionType != '3'  ORDER BY RANDOM() limit 45",sqlName];
            FMResultSet *set = [_fmdb executeQuery:selectSql];
            while ([set next]) {
                [array addObject:[self getMoniModelWithSet:set]];
            }
            
            selectSql = [NSString stringWithFormat:@"SELECT * FROM %@ where questionType = '3'  ORDER BY RANDOM() limit 5",sqlName];
            FMResultSet *set2 = [_fmdb executeQuery:selectSql];
            while ([set2 next]) {
                [array addObject:[self getMoniModelWithSet:set2]];
            }
        }
        
        //执行插入
        moniId = [CommandManager getMoniId];
        NSString*ll=[_moni_array componentsJoinedByString:@","];
        for(int i=0;i<array.count;i++){
            ThemeModel*model=array[i];
            NSString*qq=[NSString stringWithFormat:@"'%ld','%@','%ld','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%d'",model.questionID,model.question,model.questionType,model.optionA,model.optionB,model.optionC?model.optionC:@"",model.optionD?model.optionD:@"",model.key,model.imageURL?model.imageURL:@"",model.explains,model.licenseType,model.subjectType,@"0-0-0",moniId];
            NSString*str = [NSString stringWithFormat:@"insert into %@ (%@) values (%@)",kMoniList,ll,qq];
            [_fmdb executeUpdate:str];
        }
        //执行插入1条结果数据
        NSInteger startTime = [[NSDate date] timeIntervalSince1970];
        NSString*str = [NSString stringWithFormat:@"insert into %@ (%@) values ('%d','%d','%d','%d','%d','%d','%d','%@')",kMoniReslut,@"licenseType,subjectType,moni_id,right,wrong,havePlay,useTime,startTime",carType,subType,moniId,0,0,0,0,[NSString stringWithFormat:@"%ld",startTime]];
        [_fmdb executeUpdate:str];
        return [self getMoniThemesWithCarType:carType subType:subType moniId:moniId];
    }
    else{
        //读取已存在数据
        NSMutableArray*array = [NSMutableArray arrayWithCapacity:1];
        //需要创建数据 carType;// 1 2 3 4   subType;// 1 2
        //SELECT * FROM 表名 ORDER BY RANDOM() limit 1
        NSString*selectSql = [NSString stringWithFormat:@"SELECT * FROM %@ where moni_id = '%d'",kMoniList,moniId];
        FMResultSet *set = [_fmdb executeQuery:selectSql];
        while ([set next]) {
            [array addObject:[self getMoniModelWithSet:set]];
        }
        return array;
    }
}
- (NSArray*)getMoniRightAndWrongNumberWithMoniId:(int)moniId;{//order by id desc
    NSInteger rightNumber = 0;
    NSInteger wrongNumber=0;
    NSInteger useTime = 0;
    BOOL havePlay = NO;
    NSString*selectSql = [NSString stringWithFormat:@"SELECT * FROM %@ where moni_id = '%d'",kMoniReslut,moniId];
    FMResultSet *set = [_fmdb executeQuery:selectSql];
    while ([set next]) {
        rightNumber = [set intForColumn:@"right"];
        wrongNumber = [set intForColumn:@"wrong"];
        useTime =     [set intForColumn:@"useTime"];
        havePlay =  [set intForColumn:@"havePlay"]==1?YES:NO;
    }
    return @[@(rightNumber),@(wrongNumber),@(useTime),@(havePlay)];
}
- (void)updateWithModelInfo:(ThemeModel*)currentModel;{
    NSString*updateSql = [NSString stringWithFormat:@"update %@ set value = '%@' where ID = '%ld'",kMoniList,[currentModel.value_id currentValue],currentModel.ID];
    BOOL flag = [self.fmdb executeUpdate:updateSql];
    if(flag){
        NSLog(@"suc13");
    }else{
        NSLog(@"fai2");
    }
}
- (void)updateWithID:(int)ID right:(int)right wrong:(int)wrong;{//"licenseType,subjectType,moni_id,right,wrong,havePlay,useTime,startTime
    NSString*updateSql = [NSString stringWithFormat:@"update %@ set right = '%d',wrong = '%d'  where moni_id = '%d'",kMoniReslut,right,wrong,ID];
    BOOL flag = [self.fmdb executeUpdate:updateSql];
    if(flag){
        NSLog(@"suc12");
    }else{
        NSLog(@"fai1");
    }
}
- (void)updateMoniReslutCompleteWithID:(int)ID;{//"licenseType,subjectType,moni_id,right,wrong,havePlay,useTime,startTime
    NSString*updateSql = [NSString stringWithFormat:@"update %@ set havePlay = '%d' where moni_id = '%d'",kMoniReslut,1,ID];
    [self.fmdb executeUpdate:updateSql];
}

- (void)updateWithID:(int)ID useTime:(int)time;{
    NSString*updateSql = [NSString stringWithFormat:@"update %@ set useTime = '%d' where moni_id = '%d'",kMoniReslut,time,ID];
    BOOL flag = [self.fmdb executeUpdate:updateSql];
    if(flag){
        NSLog(@"suc14");
    }else{
        NSLog(@"fai0");
    }
}
//获取模拟题信息
- (NSMutableDictionary*)getMoniInfoWithSubType{
    NSString*selectSql = [NSString stringWithFormat:@"select * from %@  where licenseType = '%d' and subjectType = '%d'  order by moni_id desc",kMoniReslut,[CommandManager sharedManager].carType,[CommandManager sharedManager].subType];
    FMResultSet *set =[self.fmdb executeQuery:selectSql];
    while ([set next]) {
        if([set intForColumn:@"havePlay"]==0){
            NSMutableDictionary*dict = [NSMutableDictionary dictionary];
            [dict setObject:@([set intForColumn:@"licenseType"]) forKey:@"licenseType"];
            [dict setObject:@([set intForColumn:@"subjectType"]) forKey:@"subjectType"];
            [dict setObject:@([set intForColumn:@"moni_id"]) forKey:@"moni_id"];
            [dict setObject:@([set intForColumn:@"right"]) forKey:@"right"];
            [dict setObject:@([set intForColumn:@"wrong"]) forKey:@"wrong"];
            [dict setObject:@([set intForColumn:@"havePlay"]) forKey:@"havePlay"];
            [dict setObject:@([set intForColumn:@"useTime"]) forKey:@"useTime"];
            return dict;
        }else{
            return nil;
        }
        //[dict setObject:@([set intForColumn:@"subjectType"]) forKey:@"startTime"];
    }
    return nil;
}
- (NSArray*)getScoreInfo;{
    NSString*selectSql = [NSString stringWithFormat:@"select * from %@  where licenseType = '%d' and subjectType = '%d'  order by moni_id desc",kMoniReslut,[CommandManager sharedManager].carType,[CommandManager sharedManager].subType];
    NSMutableArray*array = [NSMutableArray array];
    FMResultSet *set =[self.fmdb executeQuery:selectSql];
    while ([set next]) {
        NSMutableDictionary*dict = [NSMutableDictionary dictionary];
        [dict setObject:@([set intForColumn:@"licenseType"]) forKey:@"licenseType"];
        [dict setObject:@([set intForColumn:@"subjectType"]) forKey:@"subjectType"];
        [dict setObject:@([set intForColumn:@"moni_id"]) forKey:@"moni_id"];
        [dict setObject:@([set intForColumn:@"right"]) forKey:@"right"];
        [dict setObject:@([set intForColumn:@"wrong"]) forKey:@"wrong"];
        [dict setObject:@([set intForColumn:@"havePlay"]) forKey:@"havePlay"];
        [dict setObject:@([set intForColumn:@"useTime"]) forKey:@"useTime"];
        if([set stringForColumn:@"startTime"]){
            [dict setObject:[set stringForColumn:@"startTime"] forKey:@"startTime"];
        }
        [array addObject:dict];
    }
    return array;
}

- (NSMutableArray*)nomalWrong;{
//    KValue_id,//顺序
//    value_id2,//随机
//    value_check,//判断
//    value_image,//图片
//    value_text,//文字
//    value_vedio,//动画
//    value_sigle,//单选
//    value_mul,//多选
//    value_moni,//真题模拟
//    value_none//未知
    NSMutableArray*array = [NSMutableArray array];
    int sunxu=0,suiji=0,check=0,image=0,text=0,vedio=0,sigle=0,mul=0;
    NSString*selectSql = [NSString stringWithFormat:@"select * FROM %@",[[CommandManager sharedManager] tableName]];
    FMResultSet *set = [_fmdb executeQuery:selectSql];
    while ([set next]) {
        if([[set stringForColumn:@"value_id"] hasPrefix:@"2-"]){
            sunxu++;
        }
        if([[set stringForColumn:@"value_id2"] hasPrefix:@"2-"]){
            suiji++;
        }
        if([[set stringForColumn:@"value_check"] hasPrefix:@"2-"]){
            check++;
        }
        if([[set stringForColumn:@"value_sigle"] hasPrefix:@"2-"]){
            sigle++;
        }
        if([[set stringForColumn:@"value_mul"] hasPrefix:@"2-"]){
            mul++;
        }
        if([[set stringForColumn:@"value_text"] hasPrefix:@"2-"]){
            text++;
        }
        if([[set stringForColumn:@"value_image"] hasPrefix:@"2-"]){
            image++;
        }
        if([[set stringForColumn:@"value_vedio"] hasPrefix:@"2-"]){
            vedio++;
        }
        //NSString*value = [set co]
        //[array addObject:[self getModelWithSet:set]];
    }
    if(sunxu>0){
        WrongModel*model = [[WrongModel alloc]init];
        model.title=@"顺序训练";
        model.wrongNumber=sunxu;
        model.type =KValue_id;
        [array addObject:model];
    }
    if(suiji>0){
        WrongModel*model = [[WrongModel alloc]init];
        model.title=@"随机训练";
        model.wrongNumber=suiji;
        model.type =value_id2;
        [array addObject:model];
    }
    if(check>0){
        WrongModel*model = [[WrongModel alloc]init];
        model.title=@"专项练习";
        model.subTitle=@"判断题";
        model.type =value_check;
        model.wrongNumber=check;
        [array addObject:model];
    }
    if(sigle>0){
        WrongModel*model = [[WrongModel alloc]init];
        model.title=@"专项练习";
        model.subTitle=@"单选题";
        model.type =value_sigle;
        model.wrongNumber=sigle;
        [array addObject:model];
    }
    if(mul>0){
        WrongModel*model = [[WrongModel alloc]init];
        model.title=@"专项练习";
        model.subTitle=@"多选题";
        model.type =value_mul;
        model.wrongNumber=mul;
        [array addObject:model];
    }
    if(text>0){
        WrongModel*model = [[WrongModel alloc]init];
        model.title=@"专项练习";
        model.subTitle=@"文字题";
        model.type =value_text;
        model.wrongNumber=text;
        [array addObject:model];
    }
    if(image>0){
        WrongModel*model = [[WrongModel alloc]init];
        model.title=@"专项练习";
        model.subTitle=@"图片题";
        model.type =value_image;
        model.wrongNumber=image;
        [array addObject:model];
    }
    if(vedio>0){
        WrongModel*model = [[WrongModel alloc]init];
        model.title=@"专项练习";
        model.subTitle=@"动画题";
        model.type =value_vedio;
        model.wrongNumber=vedio;
        [array addObject:model];
    }
    
    NSDateFormatter*formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd HH:mm"];
    
    selectSql = [NSString stringWithFormat:@"select * from %@  where licenseType = '%d' and subjectType = '%d' and wrong > 0 order by moni_id desc",kMoniReslut,[CommandManager sharedManager].carType,[CommandManager sharedManager].subType];
    FMResultSet *set2 =[self.fmdb executeQuery:selectSql];
    while ([set2 next]) {
        WrongModel*model = [[WrongModel alloc]init];
        model.title=@"模拟考试";
        model.type =value_moni;
        model.moni_id=[set2 intForColumn:@"moni_id"];
        int time = [[set2 stringForColumn:@"startTime"] intValue];
        model.subTitle=[formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:time]];
        model.wrongNumber=[set2 intForColumn:@"wrong"];
        [array addObject:model];
        //[dict setObject:@([set intForColumn:@"subjectType"]) forKey:@"startTime"];
    }
    return array;
}

- (NSMutableArray<ThemeModel*>*)getMoniTWrongWithmoniId:(int)moniId;{
    //读取已存在数据
    NSMutableArray*array = [NSMutableArray arrayWithCapacity:1];
    //需要创建数据 carType;// 1 2 3 4   subType;// 1 2
    //SELECT * FROM 表名 ORDER BY RANDOM() limit 1
    NSString*selectSql = [NSString stringWithFormat:@"SELECT * FROM %@ where moni_id = '%d' and value like '2-%%'",kMoniList,moniId];
    FMResultSet *set = [_fmdb executeQuery:selectSql];
    while ([set next]) {
        [array addObject:[self getMoniModelWithSet:set]];
    }
    return array;
}

+ (BOOL)moveDBToCache;{
    NSString *sourcesPath = [[NSBundle mainBundle] pathForResource:@"license"ofType:@"sqlite"];
    //2、获得沙盒中Document文件夹的路径——目的路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];
    NSString *desPath = [documentPath stringByAppendingPathComponent:@"license.sqlite"];
    //3、通过NSFileManager类，将工程中的数据库文件复制到沙盒中。
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:desPath])
    {
        NSError *error ;
        if ([fileManager copyItemAtPath:sourcesPath toPath:desPath error:&error]) {
            return YES;
        }
        else {
            return NO;
        }
    }
    return YES;
}



/*
- (BOOL)insertModel:(ThemeModel*)model With:(NSString*)strs andrnddd:(NSInteger)randd;{
    NSString*updateSql = [NSString stringWithFormat:@"update %@ set value_id = '%@' , value_id2 = '%@' ,value_check = '%@',value_image = '%@',value_text = '%@',value_vedio = '%@',value_sigle = '%@',value_mul = '%@',ID_random = '%ld' , isAnser = '%d'    where ID = '%ld'",strs,@"0-0-0",@"0-0-0",@"0-0-0",@"0-0-0",@"0-0-0",@"0-0-0",@"0-0-0",@"0-0-0",randd,0,model.ID];
    return [self.fmdb executeUpdate:updateSql];
}
- (void)makeDatas{
    NSLog(@"______start");
    NSArray*all=@[ktype0ke1,ktype1ke1,ktype2ke1,ktype3ke1,ktype0ke2,ktype1ke2,ktype2ke2,ktype3ke2];
    for(int i =0 ;i<all.count;i++){
        self.dataSource = [[DBTool sharedDB] getDataWith:all[i]];
        //更具数量生成一个随机数组
        NSArray*numverarray = [self noRepeatRandomArrayWithMinNum:1 maxNum:self.dataSource.count count:self.dataSource.count];
        for(int j=0;j<self.dataSource.count;j++){
            ThemeModel*model = self.dataSource[j];
            BOOL suc = [[DBTool sharedDB] insertModel:model With:all[i] andrnddd:[numverarray[j] integerValue]];
            if(suc){
                NSLog(@"成功-%@,%ld",all[i],model.ID);
            }else{
                NSLog(@"失败-%@,%ld",all[i],model.ID);
            }
        }
        NSLog(@"成功-%@",all[i]);
    }
    NSLog(@"______end");
    //[self.collectionView reloadData];
}
- (NSArray *)noRepeatRandomArrayWithMinNum:(NSInteger)min maxNum:(NSInteger )max count:(NSInteger)count{
    
    NSMutableSet *set = [NSMutableSet setWithCapacity:count];
    while (set.count < count) {
        NSInteger value = arc4random() % (max-min+1) + min;
        [set addObject:[NSNumber numberWithInteger:value]];
    }
    return set.allObjects;
}
 */

@end
