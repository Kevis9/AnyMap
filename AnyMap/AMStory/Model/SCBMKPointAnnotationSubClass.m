//
//  SCBMKPointAnnotationSubClass.m
//  AnyMap
//
//  Created by hwl on 2019/10/27.
//  Copyright © 2019 hwl. All rights reserved.
//

#import "SCBMKPointAnnotationSubClass.h"

@implementation SCBMKPointAnnotationSubClass


#pragma mark -Lazy loading
- (NSMutableArray<UIImage *> *)imgs{
    if(!_imgs)
    {
        _imgs = [[NSMutableArray alloc] init];
    }
    return _imgs;    
}
@end
