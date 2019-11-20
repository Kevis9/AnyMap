//
//  LMNFolder.m
//  LMNote
//
//  Created by littleMeaning on 2018/7/2.
//  Copyright © 2018年 littleMeaning. All rights reserved.
//

#import "LMNFolder.h"
#import "LMNStore.h"

@implementation LMNFolder

- (instancetype)initWithUUID:(NSUUID *)uuid name:(NSString *)name date:(NSDate *)date
{
    self = [super initWithUUID:uuid name:name date:date];
    if (self) {
        self.contents = [NSMutableArray array];
    }
    return self;
}

- (void)setStore:(LMNStore *)store
{
    [super setStore:store];
    for (LMNItem *item in self.contents) {
        item.store = store;
    }
}

- (void)add:(LMNItem *)item
{
    item.parent = self;
    if ([self.contents containsObject:item]) {
        return;
    }
    //将item（即一个note）添加到目录
    [self.contents addObject:item];
    //进行目录的归档
    [self.store save:item userInfo:nil];
}

- (void)remove:(LMNItem *)item
{
    if (![self.contents containsObject:item]) {
        return;
    }
    item.parent = nil;
    [self.contents removeObject:item];
    [self.store save:item userInfo:nil];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self.contents forKey:@"contents"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.contents = [aDecoder decodeObjectForKey:@"contents"];
        for (LMNItem *item in self.contents) {
            [self add:item];
        }
        
        if (!self.contents) {
            self.contents = [NSMutableArray array];
        }
    }
    return self;
}

@end
