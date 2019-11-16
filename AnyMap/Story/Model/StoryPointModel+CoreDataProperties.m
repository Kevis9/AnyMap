//
//  StoryPointModel+CoreDataProperties.m
//  AnyMap
//
//  Created by hwl on 2019/10/27.
//  Copyright © 2019 hwl. All rights reserved.
//
//

#import "StoryPointModel+CoreDataProperties.h"

@implementation StoryPointModel (CoreDataProperties)

+ (NSFetchRequest<StoryPointModel *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"StoryPointModel"];
}

@dynamic latitude;
@dynamic longitude;
@dynamic content;
@dynamic createdtime;
@dynamic title;

@end
