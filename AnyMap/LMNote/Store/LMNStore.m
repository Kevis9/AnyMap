//
//  LMNStore.m
//  LMNote
//
//  Created by littleMeaning on 2018/7/2.
//  Copyright © 2018年 littleMeaning. All rights reserved.
//

#import "LMNStore.h"

NSString * const LMNStoreVersion = @"1.0";
NSString * const LMNStoreVersionArchiveKey = @"1.0";
NSString * const LMNStoreDidChangedNotification = @"LMNStoreDidChanged";

@interface LMNStore ()

@property (nonatomic, strong) NSURL *baseURL;

@end

@implementation LMNStore

static NSString * const kStoreLocation = @"archives.dat";
static NSString * const kStoreImageDirectoryName = @"archives_images";

+ (instancetype)shared
{
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        NSURL *documentDirectory = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:NULL];
        instance = [[self alloc] initWithURL:documentDirectory];
    });
    return instance;
}

- (instancetype)initWithURL:(NSURL *)url
{
    self = [super init];
    if (self) {
        self.baseURL = url;
        [self loadData];
    }
    return self;
}

- (void)loadData
{
    NSURL *fileURL = [self.baseURL URLByAppendingPathComponent:kStoreLocation];
    NSData *data = [NSData dataWithContentsOfURL:fileURL];
    self.rootFolder = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if (!self.rootFolder) {
        self.rootFolder = [[LMNFolder alloc] initWithUUID:[NSUUID UUID] name:@"" date:[NSDate date]];
    }
    self.rootFolder.store = self;
}

- (void)save:(LMNItem *)item userInfo:(NSDictionary *)userInfo
{
    //保存草稿
    NSURL *file = [self.baseURL URLByAppendingPathComponent:kStoreLocation];
    //文件归档
    //这里的思路是，将整个目录重新归档。即一旦新增了note，这个note所在的目录进行重新的归档
    //所以item这个参数无用
    
    if (![NSKeyedArchiver archiveRootObject:self.rootFolder toFile:file.path]) {
        // 保存失败
        return;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:LMNStoreDidChangedNotification
                                                        object:self
                                                      userInfo:userInfo];
}

- (void)reload
{
    [self loadData];
}

- (NSURL *)imageDirectory
{
    NSURL *url = [self.baseURL URLByAppendingPathComponent:kStoreImageDirectoryName];
    NSError *error;
    [[NSFileManager defaultManager] createDirectoryAtURL:url withIntermediateDirectories:YES attributes:nil error:&error];
    NSAssert(!error, @"%@", error);
    return url;
}

@end
