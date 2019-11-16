//
//  StoryPointModel+CoreDataProperties.h
//  STUMap2
//
//  Created by hwl on 2019/10/27.
//  Copyright © 2019 hwl. All rights reserved.
//
//

#import "StoryPointModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface StoryPointModel (CoreDataProperties)

+ (NSFetchRequest<StoryPointModel *> *)fetchRequest;

@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@property (nullable, nonatomic, copy) NSString *content;
@property (nullable, nonatomic, copy) NSDate *createdtime;
@property (nullable, nonatomic, copy) NSString *title;

@end

NS_ASSUME_NONNULL_END
