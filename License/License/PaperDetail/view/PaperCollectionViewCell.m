//
//  PaperCollectionViewCell.m
//  License
//
//  Created by wei on 2019/7/11.
//  Copyright © 2019年 wei. All rights reserved.
//

#import "PaperCollectionViewCell.h"

#import "ThemeItemTitleCell.h"
#import "ThemeItemAnserCell.h"
#import "ThemeItemImageCell.h"
#import "ThemeItemSubmitCell.h"
#import "ThemeItemExplainsCell.h"
#import "ThemeItemAnserOptionCell.h"
#import "ThemePlayerCell.h"

@interface PaperCollectionViewCell()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView*tableView;
@property (nonatomic,strong)NSMutableArray*dataSource;
@property (nonatomic,assign)BOOL canSubmitAnser;
@end

@implementation PaperCollectionViewCell
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.tableView];
    }
    return self;
}

- (void)setCurrentModel:(ThemeModel *)currentModel{
    if([_currentModel isEqual:currentModel]) return;
    dispatch_queue_t queue_t = dispatch_queue_create("loadModel", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue_t, ^{
        _currentModel = currentModel;
        if(_dataSource) [_dataSource removeAllObjects];
        //构建itemMoedls
        //类型 标题
        ThemeItem*titleItem=[ThemeItem new];
        titleItem.showed = YES;
        titleItem.type = ThemeItemTitle;
        titleItem.optionType=currentModel.questionType;
        titleItem.value=currentModel.question;
        [self.dataSource addObject:titleItem];
        //图片
        if(currentModel.imageURL.length>0){
            if([currentModel.imageURL rangeOfString:@".swf"].length>0){
                ThemeItem*imageItem=[ThemeItem new];
                imageItem.showed = YES;
                imageItem.type = ThemeItemplayer;
                imageItem.value=currentModel.imageURL;
                [self.dataSource addObject:imageItem];
            }else{
                //清除
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self clearPlayerCell];
                });
                ThemeItem*imageItem=[ThemeItem new];
                imageItem.showed = YES;
                imageItem.type = ThemeItemImage;
                imageItem.value=currentModel.imageURL;
                [self.dataSource addObject:imageItem];
            }
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self clearPlayerCell];
            });
        }
        //答案A
        if(currentModel.optionA.length>0){
            ThemeItem*optionItemA=[ThemeItem new];
            optionItemA.showed = YES;
            optionItemA.type = ThemeItemAnserOption;
            optionItemA.value=currentModel.optionA;
            optionItemA.stateType = ThemeItemStateNone;
            optionItemA.anserType = ThemeItemAnserA;
            [self.dataSource addObject:optionItemA];
        }
        
        //答案B
        if(currentModel.optionB.length>0){
            ThemeItem*optionItemB=[ThemeItem new];
            optionItemB.showed = YES;
            optionItemB.type = ThemeItemAnserOption;
            optionItemB.value=currentModel.optionB;
            optionItemB.stateType = ThemeItemStateNone;
            optionItemB.anserType = ThemeItemAnserB;
            [self.dataSource addObject:optionItemB];
        }
        
        //答案C
        if(currentModel.optionC.length>0){
            ThemeItem*optionItemC=[ThemeItem new];
            optionItemC.showed = YES;
            optionItemC.type = ThemeItemAnserOption;
            optionItemC.value=currentModel.optionC;
            optionItemC.stateType = ThemeItemStateNone;
            optionItemC.anserType = ThemeItemAnserC;
            [self.dataSource addObject:optionItemC];
        }
        
        //答案D
        if(currentModel.optionD.length>0){
            ThemeItem*optionItemD=[ThemeItem new];
            optionItemD.showed = YES;
            optionItemD.type = ThemeItemAnserOption;
            optionItemD.value=currentModel.optionD;
            optionItemD.stateType = ThemeItemStateNone;
            optionItemD.anserType = ThemeItemAnserD;
            [self.dataSource addObject:optionItemD];
        }
        //是否要提交按钮
        if(currentModel.questionType==3){
            ThemeItem*submitItem=[ThemeItem new];
            submitItem.showed = YES;
            submitItem.type = ThemeItemSubmit;
            [self.dataSource addObject:submitItem];
        }
        //是否有答案
        if(currentModel.key.length>0){
            ThemeItem*anserItem=[ThemeItem new];
            anserItem.showed=YES;
            anserItem.value = currentModel.key;
            anserItem.type = ThemeItemAnser;
            [self.dataSource addObject:anserItem];
        }
        //是否有解析
        if(currentModel.explains.length>0){
            ThemeItem*explainsItem=[ThemeItem new];
            explainsItem.showed=YES;
            explainsItem.value = currentModel.explains;
            explainsItem.type = ThemeItemExplains;
            [self.dataSource addObject:explainsItem];
        }
        [self codeState];
        
    });
}
- (void)codeState{
    self.canSubmitAnser = NO;
    //判断是否背题
    if(_isBeiti){
        ThemeItemStateTypeS anser = [self getItemStateSWithAlongModel:nil andThemeModel:_currentModel];
        [self.dataSource enumerateObjectsUsingBlock:^(ThemeItem*item, NSUInteger idx, BOOL * _Nonnull stop) {
            if(item.type==ThemeItemSubmit){
                item.showed=NO;
            }else{
                item.showed=YES;
            }
            if(item.type==ThemeItemAnserOption){
                if(item.anserType == ThemeItemAnserA){
                    item.stateType = anser.A;
                }else if(item.anserType == ThemeItemAnserB){
                    item.stateType = anser.B;
                }else if(item.anserType == ThemeItemAnserC){
                    item.stateType = anser.C;
                }else if(item.anserType == ThemeItemAnserD){
                    item.stateType = anser.D;
                }
            }
        }];
    }else{
        AlongModel*model = [self getAlongModel];
        if(model.isAnser==0){
            [self.dataSource enumerateObjectsUsingBlock:^(ThemeItem*item, NSUInteger idx, BOOL * _Nonnull stop) {
                if(item.type==ThemeItemAnserOption){
                    item.stateType = ThemeItemStateNone;
                }else if (item.type==ThemeItemExplains || item.type==ThemeItemAnser){
                    item.showed=NO;
                }else{
                    item.showed=YES;
                }
            }];
        }else{
            //答了
            ThemeItemStateTypeS anser = [self getItemStateSWithAlongModel:model andThemeModel:_currentModel];
            [self.dataSource enumerateObjectsUsingBlock:^(ThemeItem*item, NSUInteger idx, BOOL * _Nonnull stop) {
                item.showed=YES;
                if(item.type==ThemeItemAnserOption){
                    if(item.anserType == ThemeItemAnserA){
                        item.stateType = anser.A;
                    }else if(item.anserType == ThemeItemAnserB){
                        item.stateType = anser.B;
                    }else if(item.anserType == ThemeItemAnserC){
                        item.stateType = anser.C;
                    }else if(item.anserType == ThemeItemAnserD){
                        item.stateType = anser.D;
                    }
                }
            }];
        }
    }
    //处理各种展现形式
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
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
    ThemeItem*model = [self.dataSource objectAtIndex:indexPath.row];
    switch (model.type) {
        case ThemeItemTitle:
        {
            static NSString*ID = @"ThemeItemTitleCell";
            ThemeItemTitleCell*cell=(ThemeItemTitleCell*)[tableView dequeueReusableCellWithIdentifier:ID];
            if(!cell) cell = [[ThemeItemTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
            cell.model = model;
            return cell;
        }
            break;
        case ThemeItemImage:
        {
            static NSString*ID = @"ThemeItemImageCell";
            ThemeItemImageCell*cell=(ThemeItemImageCell*)[tableView dequeueReusableCellWithIdentifier:ID];
            if(!cell) cell = [[ThemeItemImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
            cell.model = model;
            @weakify(self,indexPath);
            [cell.valueSignal subscribeNext:^(id x) {
                @strongify(self,indexPath);
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                [self.tableView beginUpdates];
                [self.tableView endUpdates];
            }];
            return cell;
        }
            break;
        case ThemeItemplayer:
        {
            static NSString*ID = @"ThemePlayerCell";
            ThemePlayerCell*cell=(ThemePlayerCell*)[self.tableView dequeueReusableCellWithIdentifier:ID];
            if(!cell) cell = [[ThemePlayerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
            cell.model = model;
            return cell;
        }
            break;
        case ThemeItemAnserOption:
        {
            static NSString*ID = @"ThemeItemAnserOptionCell";
            ThemeItemAnserOptionCell*cell=(ThemeItemAnserOptionCell*)[tableView dequeueReusableCellWithIdentifier:ID];
            if(!cell) cell = [[ThemeItemAnserOptionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
            cell.model = model;
            return cell;
        }
            break;
        case ThemeItemSubmit:
        {
            static NSString*ID = @"ThemeItemSubmitCell";
            ThemeItemSubmitCell*cell=(ThemeItemSubmitCell*)[tableView dequeueReusableCellWithIdentifier:ID];
            if(!cell) cell = [[ThemeItemSubmitCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
            cell.model = model;
            cell.canSubmitAnser = self.canSubmitAnser;
            @weakify(self);
            [[cell.valueSignal takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
                @strongify(self);
                BOOL A=NO,B=NO,C=NO,D=NO;
                for(int i=0;i<self.dataSource.count;i++){
                    ThemeItem*TheItem = self.dataSource[i];
                    if(TheItem.type==ThemeItemAnserOption){
                        if(TheItem.anserType==ThemeItemAnserA){
                            if(TheItem.stateType!=ThemeItemStateNone) A=YES;
                        }
                        if(TheItem.anserType==ThemeItemAnserB){
                            if(TheItem.stateType!=ThemeItemStateNone) B=YES;
                        }
                        if(TheItem.anserType==ThemeItemAnserC){
                            if(TheItem.stateType!=ThemeItemStateNone) C=YES;
                        }
                        if(TheItem.anserType==ThemeItemAnserD){
                            if(TheItem.stateType!=ThemeItemStateNone) D=YES;
                        }
                    }
                }
                [self codeResultWithA:A B:B C:C D:D];
            }];
            return cell;
        }
            break;
        case ThemeItemAnser:
        {
            static NSString*ID = @"ThemeItemAnserCell";
            ThemeItemAnserCell*cell=(ThemeItemAnserCell*)[tableView dequeueReusableCellWithIdentifier:ID];
            if(!cell) cell = [[ThemeItemAnserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
            cell.model = model;
            return cell;
        }
            break;
        case ThemeItemExplains:
        {
            static NSString*ID = @"ThemeItemExplainsCell";
            ThemeItemExplainsCell*cell=(ThemeItemExplainsCell*)[tableView dequeueReusableCellWithIdentifier:ID];
            if(!cell) cell = [[ThemeItemExplainsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
            cell.model = model;
            return cell;
        }
            break;
            
        default:
            break;
    }
    static NSString*ID = @"UITableViewCell_id";
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if(!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ThemeItem*model = [self.dataSource objectAtIndex:indexPath.row];
    switch (model.type) {
        case ThemeItemTitle:
        {
            return [ThemeItemTitleCell cellHightWithModel:model];
        }
            break;
        case ThemeItemImage:
        {
            return [ThemeItemImageCell cellHightWithModel:model];
        }
            break;
        case ThemeItemplayer:
        {
            return [ThemePlayerCell cellHightWithModel:model];
        }
            break;
        case ThemeItemAnserOption:
        {
            return [ThemeItemAnserOptionCell cellHightWithModel:model];
        }
            break;
        case ThemeItemSubmit:
        {
            return [ThemeItemSubmitCell cellHightWithModel:model];
        }
            break;
        case ThemeItemAnser:
        {
            return [ThemeItemAnserCell cellHightWithModel:model];
        }
            break;
        case ThemeItemExplains:
        {
            return [ThemeItemExplainsCell cellHightWithModel:model];
        }
            break;
            
        default:
            break;
    }
    return 0.01;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //选择答案
    ThemeItem*model = [self.dataSource objectAtIndex:indexPath.row];
    if(model.type==ThemeItemAnserOption){
        AlongModel*alongmodel = [self getAlongModel];
        if(alongmodel.isAnser==0){
            //判断是多选还是单选
            if(self.currentModel.questionType!=3){
                //立即执行结果并刷新
                if(model.anserType==ThemeItemAnserA){
                    [self codeResultWithA:YES B:NO C:NO D:NO];
                }else if (model.anserType==ThemeItemAnserB){
                    [self codeResultWithA:NO B:YES C:NO D:NO];
                }else if (model.anserType==ThemeItemAnserC){
                    [self codeResultWithA:NO B:NO C:YES D:NO];
                }else if (model.anserType==ThemeItemAnserD){
                    [self codeResultWithA:NO B:NO C:NO D:YES];
                }
            }else{
                //多选
                if(model.stateType==ThemeItemStateNone){
                    model.stateType = ThemeItemStatelouxuan;
                }else{
                    model.stateType = ThemeItemStateNone;
                }
                NSInteger haveAnserd = 0;
                NSInteger submit = 0;
                for(int i=0;i<self.dataSource.count;i++){
                    ThemeItem*TheItem = self.dataSource[i];
                    if(TheItem.type==ThemeItemAnserOption){
                        if(TheItem.stateType!=ThemeItemStateNone){
                            haveAnserd++;
                        }
                    }else if (TheItem.type==ThemeItemSubmit){
                        submit = i;
                    }
                }
                if(haveAnserd>1){
                    self.canSubmitAnser = YES;
                }else{
                    self.canSubmitAnser = NO;
                }
                NSIndexPath*path = [NSIndexPath indexPathForRow:submit inSection:0];
                [self.tableView reloadRowsAtIndexPaths:@[indexPath,path] withRowAnimation:UITableViewRowAnimationNone];
                
            }
        }
    }
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
- (void)clearPlayerCell{
    ThemePlayerCell*cell=(ThemePlayerCell*)[self.tableView dequeueReusableCellWithIdentifier:@"ThemePlayerCell"];
    if(cell){
        [cell clear];
    }
}
- (NSMutableArray*)dataSource{
    if(!_dataSource){
        _dataSource=[[NSMutableArray alloc] init];
    }
    return _dataSource;
}
- (UITableView*)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
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

#pragma mark -处理结果-
- (void)codeResultWithA:(BOOL)a B:(BOOL)b C:(BOOL)c D:(BOOL)d{
    AlongModel*alongModel = [self getAlongModel];
    if(_currentModel.questionType==1){
        //判断题
        if(a && [_currentModel.key isEqualToString:@"正确"]){
            alongModel.isAnser = 1;
        }else if (b && [_currentModel.key isEqualToString:@"错误"]){
            alongModel.isAnser = 1;
        }else{
            alongModel.isAnser = 2;
        }
    }else if (_currentModel.questionType==2){
        //判断题
        if(a){
            if([_currentModel.key isEqualToString:@"A"]){
                alongModel.isAnser = 1;
                alongModel.isRight = 3555;
            }else if ([_currentModel.key isEqualToString:@"B"]){
                alongModel.isAnser = 2;
                alongModel.isRight = 2455;
            }else if ([_currentModel.key isEqualToString:@"C"]){
                alongModel.isAnser = 2;
                alongModel.isRight = 2545;
            }else if ([_currentModel.key isEqualToString:@"D"]){
                alongModel.isAnser = 2;
                alongModel.isRight = 2554;
            }
        }else if (b){
            if([_currentModel.key isEqualToString:@"A"]){
                alongModel.isAnser = 2;
                alongModel.isRight = 4255;
            }else if ([_currentModel.key isEqualToString:@"B"]){
                alongModel.isAnser = 1;
                alongModel.isRight = 5355;
            }else if ([_currentModel.key isEqualToString:@"C"]){
                alongModel.isAnser = 2;
                alongModel.isRight = 5245;
            }else if ([_currentModel.key isEqualToString:@"D"]){
                alongModel.isAnser = 2;
                alongModel.isRight = 5254;
            }
        }else if (c){
            if([_currentModel.key isEqualToString:@"A"]){
                alongModel.isAnser = 2;
                alongModel.isRight = 4525;
            }else if ([_currentModel.key isEqualToString:@"B"]){
                alongModel.isAnser = 2;
                alongModel.isRight = 5425;
            }else if ([_currentModel.key isEqualToString:@"C"]){
                alongModel.isAnser = 1;
                alongModel.isRight = 5535;
            }else if ([_currentModel.key isEqualToString:@"D"]){
                alongModel.isAnser = 2;
                alongModel.isRight = 5524;
            }
        }else if (d){
            if([_currentModel.key isEqualToString:@"A"]){
                alongModel.isAnser = 2;
                alongModel.isRight = 4552;
            }else if ([_currentModel.key isEqualToString:@"B"]){
                alongModel.isAnser = 2;
                alongModel.isRight = 5452;
            }else if ([_currentModel.key isEqualToString:@"C"]){
                alongModel.isAnser = 1;
                alongModel.isRight = 5542;
            }else if ([_currentModel.key isEqualToString:@"D"]){
                alongModel.isAnser = 2;
                alongModel.isRight = 5553;
            }
        }
    }
    else if(_currentModel.questionType==3){
        //多选、
        int anserA=0;
        int anserB=0;
        int anserC=0;
        int anserD=0;
        if(a){
            if([_currentModel.key rangeOfString:@"A"].length>0) anserA = 3;
            else anserA = 2;
        }else{
            if([_currentModel.key rangeOfString:@"A"].length>0) anserA = 4;
            else anserA = 5;
        }
        if(b){
            if([_currentModel.key rangeOfString:@"B"].length>0) anserB = 3;
            else anserB = 2;
        }else{
            if([_currentModel.key rangeOfString:@"B"].length>0) anserB = 4;
            else anserB = 5;
        }
        if(c){
            if([_currentModel.key rangeOfString:@"C"].length>0) anserC = 3;
            else anserC = 2;
        }else{
            if([_currentModel.key rangeOfString:@"C"].length>0) anserC = 4;
            else anserC = 5;
        }
        if(d){
            if([_currentModel.key rangeOfString:@"D"].length>0) anserD = 3;
            else anserD = 2;
        }else{
            if([_currentModel.key rangeOfString:@"D"].length>0) anserD = 4;
            else anserD = 5;
        }
        if( anserA==2 || anserA==4 || anserB==2 || anserB==4 || anserC==2 || anserC==4 || anserD==2 || anserD==4){
            alongModel.isAnser = 2;
            alongModel.isRight = anserA*1000+anserB*100+anserC*10+anserD;
        }else{
            alongModel.isAnser = 1;
            alongModel.isRight = anserA*1000+anserB*100+anserC*10+anserD;
        }
    }
    //执行本地更新
    @weakify(self);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        @strongify(self);
        if(self.type == value_moni){
            //存储本题并存储结果
            [[DBTool sharedDB] updateWithModelInfo:self.currentModel];
        }else{
            NSString*tableName = [[CommandManager sharedManager] tableName];
            [[DBTool sharedDB] updateWithCarType:tableName andValueType:self.type andModel:self.currentModel];
        }
        //存储做题做到这里
        NSString*key= [NSString stringWithFormat:@"now-%d-%d-%ld-%d",[CommandManager sharedManager].carType,[CommandManager sharedManager].subType,self.type,self.moniId];
        [CommandManager save:@(self.row) key:key];
        [self codeState];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter]postNotificationName:@"themeWasWrited" object:@(alongModel.isAnser)];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"themeWasWritedAndStep" object:@(self.row)];
            
        });
    });
}
- (AlongModel*)getAlongModel;{
    //KValue_id,
    //        value_id2,
    //        value_check,
    //        value_image,
    //        value_text,
    //        value_vedio,
    //        value_sigle,
    //        value_mul,
    //        value_none
    AlongModel*model;
    if(_type==KValue_id) model=_currentModel.value_id;
    else if (_type==value_id2) model=_currentModel.value_id2;
    else if (_type==value_check) model=_currentModel.value_check;
    else if (_type==value_image) model=_currentModel.value_image;
    else if (_type==value_text) model=_currentModel.value_text;
    else if (_type==value_vedio) model=_currentModel.value_vedio;
    else if (_type==value_sigle) model=_currentModel.value_sigle;
    else if (_type==value_moni) model=_currentModel.value_id;
    else  model=_currentModel.value_mul;
    return model;
}
- (ThemeItemStateTypeS)getItemStateSWithAlongModel:(AlongModel*)AlongModel andThemeModel:(ThemeModel*)themeModel{
    ThemeItemStateTypeS anser;
    if(_isBeiti){
        //背题模式
        if(themeModel.questionType==1){
            if([themeModel.key isEqualToString:@"正确"]){
                anser.A=ThemeItemStatelouxuan;
                anser.B=ThemeItemStateNoAnser;
            }else{
                anser.A=ThemeItemStateNoAnser;
                anser.B=ThemeItemStatelouxuan;
            }
        }else if(themeModel.questionType==2){
            if([themeModel.key isEqualToString:@"A"]){
                anser.A=ThemeItemStatelouxuan;
                anser.B=ThemeItemStateNoAnser;
                anser.C=ThemeItemStateNoAnser;
                anser.D=ThemeItemStateNoAnser;
            }else if([themeModel.key isEqualToString:@"B"]){
                anser.A=ThemeItemStateNoAnser;
                anser.B=ThemeItemStatelouxuan;
                anser.C=ThemeItemStateNoAnser;
                anser.D=ThemeItemStateNoAnser;
            }else if([themeModel.key isEqualToString:@"C"]){
                anser.A=ThemeItemStateNoAnser;
                anser.B=ThemeItemStateNoAnser;
                anser.C=ThemeItemStatelouxuan;
                anser.D=ThemeItemStateNoAnser;
            }else{
                anser.A=ThemeItemStateNoAnser;
                anser.B=ThemeItemStateNoAnser;
                anser.C=ThemeItemStateNoAnser;
                anser.D=ThemeItemStatelouxuan;
            }
        }else{
            //多选
            if([themeModel.key rangeOfString:@"A"].length>0){
                anser.A=ThemeItemStateCorrect;
            }else{
                anser.A=ThemeItemStateNoAnser;
            }
            if([themeModel.key rangeOfString:@"B"].length>0){
                anser.B=ThemeItemStateCorrect;
            }else{
                anser.B=ThemeItemStateNoAnser;
            }
            if([themeModel.key rangeOfString:@"C"].length>0){
                anser.C=ThemeItemStateCorrect;
            }else{
                anser.C=ThemeItemStateNoAnser;
            }
            if([themeModel.key rangeOfString:@"D"].length>0){
                anser.D=ThemeItemStateCorrect;
            }else{
                anser.D=ThemeItemStateNoAnser;
            }
        }
    }
    else{
        //非背题模式
        //nomoal下
        if(AlongModel.isAnser==0){
            anser.A=ThemeItemStateNone;
            anser.B=ThemeItemStateNone;
            anser.C=ThemeItemStateNone;
            anser.D=ThemeItemStateNone;
        }else{
            //答错的情况
            if(themeModel.questionType==1){
                if(AlongModel.isAnser==1){
                    //答对
                    if([themeModel.key isEqualToString:@"正确"]){
                        anser.A=ThemeItemStateCorrect;
                        anser.B=ThemeItemStateNoAnser;
                    }else{
                        anser.A=ThemeItemStateNoAnser;
                        anser.B=ThemeItemStateCorrect;
                    }
                }else{
                    //答错
                    if([themeModel.key isEqualToString:@"正确"]){
                        anser.A=ThemeItemStatelouxuan;
                        anser.B=ThemeItemStateError;
                    }else{
                        anser.A=ThemeItemStateError;
                        anser.B=ThemeItemStatelouxuan;
                    }
                }
            }else{
                int isRight = AlongModel.isRight;
                anser.A = isRight/1000;
                anser.B = (isRight%1000)/100;
                anser.C = (isRight%100)/10;
                anser.D = isRight%10;
                
            }
        }
    }
    return anser;
}
- (void)dealloc{
    //必须释放
}
@end
