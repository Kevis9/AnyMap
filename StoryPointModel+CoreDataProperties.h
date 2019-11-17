//
//  StoryPointModel+CoreDataProperties.h
//  
//
//  Created by hwl on 2019/11/17.
//
//

#import "StoryPointModel+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface StoryPointModel (CoreDataProperties)

+ (NSFetchRequest<StoryPointModel *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *content;
@property (nullable, nonatomic, copy) NSDate *createdtime;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) NSString *address;

@end

NS_ASSUME_NONNULL_END
