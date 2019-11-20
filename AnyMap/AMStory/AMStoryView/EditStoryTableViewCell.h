//
//  EditStoryTableViewCell.h
//  AnyMap
//
//  Created by hwl on 2019/10/26.
//  Copyright © 2019 hwl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaceholderTextView.h"
NS_ASSUME_NONNULL_BEGIN

@interface EditStoryTableViewCell : UITableViewCell

@property(nonatomic,strong) PlaceholderTextView *textview;
@property(nonatomic,strong) UILabel* label;     //显示"标题","故事"字段

@end

NS_ASSUME_NONNULL_END
