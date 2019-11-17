//
//  CoreDataManager.m
//  AnyMap
//
//  Created by hwl on 2019/10/27.
//  Copyright © 2019 hwl. All rights reserved.
//

#import "CoreDataManager.h"
#import "StoryPointModel+CoreDataProperties.h"
#import <CoreData/CoreData.h>

static CoreDataManager* sharedInstance = nil;

@interface CoreDataManager()

@property(readonly,strong) NSManagedObjectModel *manageObjectModel;
@property(readonly,strong) NSPersistentStoreCoordinator *persistentContainer;
@property(nonatomic,readonly,strong) NSManagedObjectContext *ManageObjectContext;

@end
@implementation CoreDataManager

+ (instancetype)sharedInstance {
 
    static dispatch_once_t onceToken;
 
    dispatch_once(&onceToken, ^{
 
        sharedInstance = [[CoreDataManager alloc] init];
 
    });
 
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initCoreData];
    }
    return self;
}

#pragma mark -初始化CoreData
- (void)initCoreData{
    
    //初始ObjectModel
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"StoryDB" withExtension:@"momd"];
    _manageObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
        
    //初始化container
    //绑定ObjectModel
    _persistentContainer = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_manageObjectModel];
    //创建SQLite数据库
    //获取Document路径
    NSString *docStr = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *sqlStr = [docStr stringByAppendingPathComponent:@"StroyDB.sqlite"];
    NSURL *sqlURL = [NSURL fileURLWithPath:sqlStr];
    
    NSError *error = nil;
    
    [_persistentContainer addPersistentStoreWithType:NSSQLiteStoreType
                                       configuration:nil
                                                 URL:sqlURL
                                             options:nil
                                               error:&error];
    if(error)
    {
        NSLog(@"数据库创建失败");
    }
    else NSLog(@"数据库创建成功");
    
    //初始化Context,在主队列进行
    _ManageObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    
    //绑定数据库
    _ManageObjectContext.persistentStoreCoordinator = _persistentContainer;
    
}
#pragma mark -StoryPoint 增删改查

//插入成功之后返回ID
- (NSManagedObjectID*)createStoryPoint:(NSDictionary*)dic{
    
    
    StoryPointModel *newpoint = [NSEntityDescription insertNewObjectForEntityForName:@"StoryPointModel" inManagedObjectContext:_ManageObjectContext];
    
    
    newpoint.createdtime = dic[@"createdtime"];
    newpoint.latitude = [dic[@"latitude"] doubleValue];
    newpoint.longitude = [dic[@"longitude"] doubleValue];
    newpoint.title = dic[@"title"];
    newpoint.content = dic[@"content"];
    newpoint.address = dic[@"address"];
    __autoreleasing NSError *error = nil;
    [_ManageObjectContext save:&error];
    if(error)
    {
        NSLog(@"点数据添加失败");
        return nil;
    }
    else
    {
        NSLog(@"点数据添加成功");
        return [newpoint objectID];
    }
}

- (NSDictionary*)checkPointByObjectID:(NSManagedObjectID*)ID
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    StoryPointModel *obj = (StoryPointModel*)[_ManageObjectContext objectWithID:ID];
    if(obj){
        NSLog(@"查找成功");
        NSLog(@"%@",obj.content);
        [dic setValue:obj.content forKey:@"content"];
        [dic setValue:obj.title forKey:@"title"];
        [dic setValue:obj.createdtime forKey:@"createdtime"];
        [dic setValue:obj.address forKey:@"address"];
        return (NSDictionary*)dic;
    }
    else{
        NSLog(@"查找失败");
        return nil;
    }
}
@end
