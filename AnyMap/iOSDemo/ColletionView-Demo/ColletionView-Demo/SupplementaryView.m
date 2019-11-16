//
//  SupplementaryView.m
//  ColletionView-Demo
//
//  Created by hwl on 2019/9/25.
//  Copyright © 2019 stumap. All rights reserved.
//

#import "SupplementaryView.h"
#import "SDAutoLayout.h"

@interface SupplementaryView ()
@property(nonatomic,strong) UILabel *label;
@end
@implementation SupplementaryView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self SetUpSubviews];
    }
    return self;
}

- (void)SetUpSubviews{
    self.label = [[UILabel alloc] init];
    self.label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.label];
    _label.sd_layout
    .leftSpaceToView(self, 0)
    .topSpaceToView(self, 0)
    .heightRatioToView(self, 1)
    .widthRatioToView(self, 1);
}

- (void)Setupwithnum:(NSInteger) num{
    [self.label setText:[NSString stringWithFormat:@"%ld",num]];
    
}
@end
