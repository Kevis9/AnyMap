//
//  StoryPointModel.h
//  AnyMap
//
//  Created by hwl on 2019/11/17.
//  Copyright © 2019 hwl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AMStoryPointModel : NSObject

@property (nullable, nonatomic, copy) NSString *content;
@property (nullable, nonatomic, copy) NSDate *createdtime;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) NSString *address;

@end

NS_ASSUME_NONNULL_END
