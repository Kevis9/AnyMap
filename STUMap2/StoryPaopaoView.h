//
//  StoryPaopaoView.h
//  STUMap2
//
//  Created by hwl on 2019/10/27.
//  Copyright © 2019 hwl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface StoryPaopaoView : UIView

@property (nonatomic, strong) UIImage *image; //故事图
@property (nonatomic, strong) UITextView *titleTextView; //故事主题
@property (nonatomic, strong) UITextView *storyTextView; //故事

@end

NS_ASSUME_NONNULL_END
