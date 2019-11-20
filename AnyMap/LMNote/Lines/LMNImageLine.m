//
//  LMNImageLine.m
//  LMNote
//
//  Created by littleMeaning on 2018/7/9.
//  Copyright © 2018年 littleMeaning. All rights reserved.
//

#import "LMNImageLine.h"
#import "LMNImageView.h"
#import "LMNStore.h"
#import "UIImage+LMNStore.h"

@interface LMNImageLine ()

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) NSString *imageFile;
@property (nonatomic, copy) NSString *imgURL;   //图片上传的URL

@end

@implementation LMNImageLine

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        self.imageFile = [aDecoder decodeObjectForKey:@"imageFile"][@"filename"];
        self.imgURL = [aDecoder decodeObjectForKey:@"imageFile"][@"imgURL"];
        NSLog(@"%@",self.imageFile);
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    
    UIImage *image = self.bindingImageView.image;
    if (image) {
        if (!image.lmn_fileName) {
            //将图片写入到本地
            NSData *imageData = UIImagePNGRepresentation(image);
            NSString *fileName = [NSUUID UUID].UUIDString;
            NSURL *fileURL = [[LMNStore shared].imageDirectory URLByAppendingPathComponent:fileName];
            [imageData writeToURL:fileURL atomically:YES];
            image.lmn_fileName = fileName;
        }
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setValue:image.lmn_fileName forKey:@"filename"];
        [dic setValue:self.imgURL forKey:@"imgURL"];
//        [aCoder encodeObject:image.lmn_fileName forKey:@"imageFile"];
        [aCoder encodeObject:dic forKey:@"imageFile"];
        
    }
}

- (void)bindImageView:(LMNImageView *)bindingImageView
{
    _bindingImageView = bindingImageView;
    bindingImageView.owner = self;
}

- (void)unbindImageView
{
    _bindingImageView.owner = nil;
    _bindingImageView = nil;
}

- (UIImage *)image
{
    if (!_image) {
        _image = self.bindingImageView.image;
    }
    if (!_image && self.imageFile != nil) {
        NSLog(@"%@",self.imageFile);
        NSURL *fileURL = [[LMNStore shared].imageDirectory URLByAppendingPathComponent:self.imageFile];
        _image = [UIImage imageWithContentsOfFile:fileURL.path];
        _image.lmn_fileName = self.imageFile;
    }
    return _image;
}

- (NSString*)getimgURL{
    return _imgURL;
}

- (CGFloat)getimgWidth{
    return self.bindingImageView.frame.size.width;
}

- (CGFloat)getimgHeight{
    return self.bindingImageView.frame.size.height;
}

-(void)bindimgURL:(NSString *)imgURL{
    _imgURL = imgURL;
}
@end
