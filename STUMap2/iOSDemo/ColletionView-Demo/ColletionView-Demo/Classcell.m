//
//  Classcell.m
//  ColletionView-Demo
//
//  Created by hwl on 2019/9/25.
//  Copyright © 2019 stumap. All rights reserved.
//

#import "Classcell.h"
#import "SDAutoLayout.h"
@implementation Classcell


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
          [self SetUpSubviews];
    }
    return self;
}

- (void)SetUpSubviews{
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:12];
    [label setText:@"哈哈哈"];
    self.backgroundColor = [UIColor yellowColor];
    self.layer.cornerRadius = 7;
    label.backgroundColor = [UIColor clearColor];
    [self addSubview:label];
    label.sd_layout
    .leftSpaceToView(self,0)
    .topSpaceToView(self, 0)
    .heightRatioToView(self, 1)
    .widthRatioToView(self, 1);
    
}
@end
