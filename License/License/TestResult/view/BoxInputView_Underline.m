//
//  CRBoxInputView_Line.m
//  CRBoxInputView_Example
//
//  Created by Chobits on 2019/1/7.
//  Copyright © 2019 BearRan. All rights reserved.
//

#import "BoxInputView_Underline.h"
#import "BoxInputCell_Underline.h"

@implementation BoxInputView_Underline

- (void)initDefaultValue {
    [super initDefaultValue];
    [[self mainCollectionView] registerClass:[BoxInputCell_Underline class] forCellWithReuseIdentifier:CRBoxInputView_LineID];
}

- (BoxInputCell_Underline *)customCollectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BoxInputCell_Underline *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CRBoxInputView_LineID forIndexPath:indexPath];
    return cell;
}

@end
