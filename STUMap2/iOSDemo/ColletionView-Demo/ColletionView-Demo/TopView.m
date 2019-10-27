//
//  TopView.m
//  ColletionView-Demo
//
//  Created by hwl on 2019/9/24.
//  Copyright © 2019 stumap. All rights reserved.
//

#import "TopView.h"
#import "SDAutoLayout.h"

@interface TopView ()

@property(nonatomic,strong)UIButton *btn;

@end


@implementation TopView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self SetUpSubviews];
    }
    return self;
}

- (void)SetUpSubviews{
    self.btn = [[UIButton alloc] init];
     _btn.backgroundColor = [UIColor yellowColor];
     [self addSubview:self.btn];
    _btn.sd_layout
    .leftSpaceToView(self,[[UIScreen mainScreen] bounds].size.width/2-60)
    .topSpaceToView(self, 0)
    .heightRatioToView(self,1)
    .widthIs(120);
   
   
}
@end
