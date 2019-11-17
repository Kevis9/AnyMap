//
//  StoryPointModel+CoreDataProperties.m
//  
//
//  Created by hwl on 2019/11/17.
//
//

#import "StoryPointModel+CoreDataProperties.h"

@implementation StoryPointModel (CoreDataProperties)

+ (NSFetchRequest<StoryPointModel *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"StoryPointModel"];
}

@dynamic content;
@dynamic createdtime;
@dynamic latitude;
@dynamic longitude;
@dynamic title;
@dynamic address;

@end
