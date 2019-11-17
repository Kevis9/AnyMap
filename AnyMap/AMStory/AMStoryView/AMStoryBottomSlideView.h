//
//  SlideScrollView.h
//  SlideScrollViewDemo
//
//  Created by 刘继新 on 2018/10/22.
//  Copyright © 2018 Topstech. All rights reserved.
// 

#import <UIKit/UIKit.h>
#import "BottomSlideView.h"

@class AMStoryBottomSlideView;

typedef void(^CellPickImgCopleteblock)(NSArray* imgs);

@protocol AMStoryBottomViewDelegate <NSObject>

- (void)addStoryPoint:(AMStoryBottomSlideView*)slideview;

- (void)pickImgFinishedHandle:(CellPickImgCopleteblock)block;

@end

@interface AMStoryBottomSlideView : BottomSlideView


@property(nonatomic,strong) UITextView *TitleTextView;
@property(nonatomic,strong) UITextView *StoryTextView;
@property(nonatomic,strong) id<AMStoryBottomViewDelegate> delegate;
@property(nonatomic,assign) NSInteger numOfImgs;
@property(nonatomic,strong) UIImage *firstImg;
@property (nonatomic, strong) UILabel *addressLabel;         //显示具体地点的Label


@end


