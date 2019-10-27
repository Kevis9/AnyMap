//
//  ClassViewLayout.m
//  ColletionView-Demo
//
//  Created by hwl on 2019/9/24.
//  Copyright © 2019 stumap. All rights reserved.
//

#import "ClassViewLayout.h"
#import "SupplementaryView.h"
#import "define.h"
#define cell_w  (([[UIScreen mainScreen] bounds].size.width-w3-gap1-6*gap2)/7)
@implementation ClassViewLayout

- (void)prepareLayout{
    
    [super prepareLayout];
    [self registerClass:[SupplementaryView class] forDecorationViewOfKind:@"ClassNum"];
    
}


- (CGSize)collectionViewContentSize{
    
    return CGSizeMake([[UIScreen mainScreen] bounds].size.width,w4*13+gap2*12+gap1);
    
}


- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    
    //supplmentary view
    for(int i=0;i<13;i++)
    {
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:i inSection:0];
        [arr addObject:[self layoutAttributesForSupplementaryViewOfKind:@"ClassNum" atIndexPath:indexpath]];
    }
    
    //cell
    for(int i=0;i<1;i++)
    {
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:i inSection:0];
        
        [arr addObject:[self layoutAttributesForItemAtIndexPath:indexpath]];
    }
    return arr;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewLayoutAttributes *att = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:elementKind withIndexPath:indexPath];
 
    CGRect f = CGRectMake(0, 0, w3,w4);
    f.origin.y = gap1+ indexPath.row*(gap2+w4);
    att.frame = f;
    return att;
}


- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewLayoutAttributes *att = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    CGRect f = CGRectMake(w3+gap1,gap1,cell_w,w4*2+gap2);
    att.frame = f;
    return att;
}
@end
