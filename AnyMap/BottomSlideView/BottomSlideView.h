//
//  SlideScrollView.h
//  SlideScrollViewDemo
//
//  Created by 刘继新 on 2018/10/22.
//  Copyright © 2018 Topstech. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SCREEN_WIDTH ([[UIScreen mainScreen]bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen]bounds].size.height)
#define STATUS_BAR_HEIGHT [[UIApplication sharedApplication] statusBarFrame].size.height

#define FULL_TOP (STATUS_BAR_HEIGHT + 30.0) // 全尺寸模式下view的y坐标
#define SMALL_TOP (SCREEN_HEIGHT - 200.0)   // 缩小模式下view的y坐标
#define CHANGE_MINI 50.0f                   // 切换状态需要手势移动的距离

typedef NS_ENUM(NSInteger, SlideScrollViewState) {
    SlideScrollViewStateSmall,  ///< 缩小模式
    SlideScrollViewStateFull    ///< 全尺寸模式
};

NS_ASSUME_NONNULL_BEGIN

@interface BottomSlideView : UIView

@property (nonatomic, assign) SlideScrollViewState sizeState;

@property (nonatomic, assign, readonly) BOOL isSizeFull;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView *shadeView;

@property (nonatomic, strong) UISearchBar *searchBar;

- (void)initViews;

@end

NS_ASSUME_NONNULL_END
