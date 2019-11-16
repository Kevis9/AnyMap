//
//  SCBMKPointAnnotationSubClass.h
//  AnyMap
//
//  Created by hwl on 2019/10/27.
//  Copyright © 2019 hwl. All rights reserved.
//

#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface SCBMKPointAnnotationSubClass : BMKPointAnnotation

@property(nonatomic,strong)NSManagedObjectID *pointID;

@end

NS_ASSUME_NONNULL_END
