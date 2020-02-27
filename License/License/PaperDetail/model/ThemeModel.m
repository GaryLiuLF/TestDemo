//
//  ThemeModel.m
//  License
//
//  Created by wei on 2019/7/11.
//  Copyright © 2019年 wei. All rights reserved.
//

#import "ThemeModel.h"

@implementation ThemeModel

- (void)setQuestion:(NSString *)question{
    _question=question;
    if([question isKindOfClass:[NSNull class]]){
        _question=@"";
    }
}
- (void)setOptionA:(NSString *)optionA{
    _optionA=optionA;
    if([optionA isKindOfClass:[NSNull class]]){
        _optionA=@"";
    }
}
- (void)setOptionB:(NSString *)optionB{
    _optionB=optionB;
    if([optionB isKindOfClass:[NSNull class]]){
        _optionB=@"";
    }
}
- (void)setOptionC:(NSString *)optionC{
    _optionC=optionC;
    if([optionC isKindOfClass:[NSNull class]]){
        _optionC=@"";
    }
}
- (void)setOptionD:(NSString *)optionD{
    _optionD=optionD;
    if([optionD isKindOfClass:[NSNull class]]){
        _optionD=@"";
    }
}
- (void)setImageURL:(NSString *)imageURL{
    _imageURL=imageURL;
    if([imageURL isKindOfClass:[NSNull class]]){
        _imageURL=@"";
    }
}
- (void)setKey:(NSString *)key{
    _key=key;
    if([key isKindOfClass:[NSNull class]]){
        _key=@"";
    }
}
- (void)setExplains:(NSString *)explains{
    _explains=explains;
    if([explains isKindOfClass:[NSNull class]]){
        _explains=@"";
    }
}

@end
