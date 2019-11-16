//
//  CoreDataManager.h
//  AnyMap
//
//  Created by hwl on 2019/10/27.
//  Copyright © 2019 hwl. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NSManagedObjectID;

NS_ASSUME_NONNULL_BEGIN

@interface CoreDataManager : NSObject

//单例
+ (instancetype)sharedInstance;

//创建一个点
- (NSManagedObjectID*)createStoryPoint:(NSDictionary*)dic;
//根据ID查询一个点，返回这个object的必要信息
- (NSDictionary*)checkPointByObjectID:(NSManagedObjectID*)ID;

@end

NS_ASSUME_NONNULL_END
