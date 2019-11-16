//
//  EditStoryTableViewCell.h
//  STUMap2
//
//  Created by hwl on 2019/10/26.
//  Copyright © 2019 hwl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaceholderTextView.h"
NS_ASSUME_NONNULL_BEGIN

@interface EditStoryTableViewCell : UITableViewCell

@property(nonatomic,strong) PlaceholderTextView *textview;
@property(nonatomic,strong) UILabel* label;
@end

NS_ASSUME_NONNULL_END
