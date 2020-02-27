//
//  HotDataMaker.m
//  License
//
//  Created by wei on 2019/7/17.
//  Copyright © 2019年 wei. All rights reserved.
//

#import "HotDataMaker.h"

@implementation HotDataMaker

@end


@implementation HotItem
- (void)setBasicString:(NSString*)basic;{
    basic = [basic stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSRange range = [basic rangeOfString:@"[t0]"];
    if(range.length>0){
        self.type = kHotTitle0;
        self.value = [self.value stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        self.value=[basic substringWithRange:NSMakeRange(range.length, basic.length-range.length)];
        return;
    }
    range = [basic rangeOfString:@"[t1]"];
    if(range.length>0){
        self.type = kHotTitle1;
        self.value=[basic substringWithRange:NSMakeRange(range.length, basic.length-range.length)];
        return;
    }
    range = [basic rangeOfString:@"[t2]"];
    if(range.length>0){
        self.type = kHotTitle2;
        self.value=[basic substringWithRange:NSMakeRange(range.length, basic.length-range.length)];
        return;
    }
    range = [basic rangeOfString:@"[i]"];
    if(range.length>0){
        self.type = kHotItem;
        self.value=[basic substringWithRange:NSMakeRange(range.length, basic.length-range.length)];
        return;
    }
    range = [basic rangeOfString:@"[c]"];
    if(range.length>0){
        self.type = kHotContent;
        self.value=[basic substringWithRange:NSMakeRange(range.length, basic.length-range.length)];
        return;
    }
    range = [basic rangeOfString:@"[p]"];
    if(range.length>0){
        self.type = kHotImage;
        self.value=[basic substringWithRange:NSMakeRange(range.length, basic.length-range.length)];
        return;
    }
    range = [basic rangeOfString:@"[j]"];
    if(range.length>0){
        self.type = kHotEnd;
        self.value=[basic substringWithRange:NSMakeRange(range.length, basic.length-range.length)];
        return;
    }
}
@end
