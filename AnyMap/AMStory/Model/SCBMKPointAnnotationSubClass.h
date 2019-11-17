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

@property(nonatomic,assign)NSInteger index; //所在下标--存放在storyPoints数组

//点的信息
@property (nullable, nonatomic, copy) NSString *content;
@property (nullable, nonatomic, copy) NSDate *createdtime;
@property (nonatomic, copy) NSString *StoryTitle;
@property (nonatomic, copy) NSString *address;

//内存上存放的照片数量
@property (nonatomic,strong)NSMutableArray<UIImage*> *imgs;

//保存已存放点的图片路径===暂时不用
@property (nonatomic,strong)NSMutableArray<NSString*> *imgURLs;
@end

NS_ASSUME_NONNULL_END
