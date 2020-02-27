//
//  CommandManager.m
//  BeibeiMusic
//
//  Created by wei on 2019/7/7.
//  Copyright © 2019年 wei. All rights reserved.
//

#import "CommandManager.h"
#import "BDeviceTool.h"
static CommandManager *manager = nil;

@implementation CommandManager
+ (instancetype)sharedManager
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
        self.isIphoneX = [BDeviceTool isIphonX];
        //[self fmdb];
        self.carType = [[BBDefault objectForKey:ptype] intValue];
        NSLog(@"");
        self.subType = [[BBDefault objectForKey:psubtype] intValue];
        
        if([BBDefault objectForKey:BBCanStepWhenAnsered]){
            int x = [[BBDefault objectForKey:BBCanStepWhenAnsered] intValue];
            if(x) self.canStep=YES;else self.canStep=NO;
        }else{
            self.canStep=YES;
        }
        
        if([BBDefault objectForKey:BBCanPush]){
            int x = [[BBDefault objectForKey:BBCanPush] intValue];
            if(x) self.canPush=YES;else self.canPush=NO;
        }else{
            self.canPush=YES;
        }
        
        self.totolImageSizeDictionary = [NSMutableDictionary dictionaryWithDictionary:[BBDefault objectForKey:TotolImageHeights]];
        if(!self.totolImageSizeDictionary){
            self.totolImageSizeDictionary=[[NSMutableDictionary alloc] init];
        }
    }
    return self;
}

//存储和获取图片高度
- (void)setImageUrl:(NSString*)imageUrl andValue:(NSNumber*)value;{
    if(!imageUrl || !value) return;
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        [self.totolImageSizeDictionary setObject:value forKey:imageUrl];
        [BBDefault setObject:self.totolImageSizeDictionary forKey:TotolImageHeights];
        [BBDefault synchronize];
    });
}
- (float)getImageHeightWithUrl:(NSString*)imageUrl;{
    return [[self.totolImageSizeDictionary objectForKey:imageUrl] floatValue];
}

//获取表名
- (NSString*)tableName;{
    if(_carType==1){
        if(_subType==1) return ktype0ke1;
        else return ktype0ke2;
    }else if (_carType==2){
        if(_subType==1) return ktype1ke1;
        else return ktype1ke2;
    }else if (_carType==3){
        if(_subType==1) return ktype2ke1;
        else return ktype2ke2;
    }else{
        if(_subType==1) return ktype3ke1;
        else return ktype3ke2;
    }
}

+ (void)save:(id)obj key:(NSString*)key;{
    if(obj && key){
        [BBDefault setObject:obj forKey:key];
        [BBDefault synchronize];
    }
}
+ (id)getValue:(NSString*)key;{
    if(key){
        return [BBDefault objectForKey:key];
    }
    return nil;
}
+ (int)getMoniId;{
    int x = [[BBDefault objectForKey:@"BBMoniID"] intValue];
    x++;
    [BBDefault setObject:@(x) forKey:@"BBMoniID"];
    [BBDefault synchronize];
    [CommandManager sharedManager].proid = x;
    return x;
}

+ (id)json_objetWith:(id)value;{
    if(!value) return nil;
    if([value isKindOfClass:[NSString class]]){
        NSData*data=[value dataUsingEncoding:NSUTF8StringEncoding];
        return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    }else if([value isKindOfClass:[NSData class]]){
        return [NSJSONSerialization JSONObjectWithData:value options:NSJSONReadingMutableContainers error:nil];
    }
    return nil;
}
+ (NSString*)json_stringWithValue:(id)value;{
    if(!value) return nil;
    //NSJSONWritingSortedKeys 以字符串形式  NSJSONWritingPrettyPrinted 以字典形式
    if (@available(iOS 11.0, *)) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:value options:NSJSONWritingSortedKeys error:nil];
        return [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    } else {
        // Fallback on earlier versions
        NSData *data = [NSJSONSerialization dataWithJSONObject:value options:NSJSONWritingPrettyPrinted error:nil];
        return [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    }
}

@end
