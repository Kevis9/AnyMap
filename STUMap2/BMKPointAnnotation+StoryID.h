//
//  BMKPointAnnotation+StoryID.h
//  STUMap2
//
//  Created by hwl on 2019/10/27.
//  Copyright © 2019 hwl. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件

NS_ASSUME_NONNULL_BEGIN

@interface BMKPointAnnotation (StoryID)

@property(nonatomic,strong)NSManagedObjectID *pointID;

@end

NS_ASSUME_NONNULL_END
