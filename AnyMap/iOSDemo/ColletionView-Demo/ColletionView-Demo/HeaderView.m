//
//  HeaderView.m
//  ColletionView-Demo
//
//  Created by hwl on 2019/9/24.
//  Copyright © 2019 stumap. All rights reserved.
//

#import "HeaderView.h"
#import "SDAutoLayout.h"
#import "define.h"

#define cellwidth (([[UIScreen mainScreen] bounds].size.width-w3-gap1-6*gap2)/7)
@implementation HeaderView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self SetupSubviews];
    }
    return self;
}

- (void)SetupSubviews{
    UIView *view = [[UIView alloc] init];
    UILabel *label = [[UILabel alloc] init];
    [label setText:@"9月"];
    label.font = [UIFont systemFontOfSize:14];
    view.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.1];
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
    [self addSubview:view];
    
    view.sd_layout
    .leftSpaceToView(self, 0)
    .topSpaceToView(self,0)
    .heightRatioToView(self, 1)
    .widthIs(w3);
    
    label.sd_layout
    .leftSpaceToView(view, 0)
    .topSpaceToView(view, 0)
    .heightRatioToView(view,1)
    .widthRatioToView(view,1);
    
    
    NSArray *week = @[@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日"];
    for(int i=0;i<7;i++)
    {
        view = [[UIView alloc] init];
        view.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.1];
        label = [[UILabel alloc] init];
        [view addSubview:label];
        [self addSubview:view];
        [label setText:[week objectAtIndex:i]];
        label.font = [UIFont systemFontOfSize:14];
        label.textAlignment = NSTextAlignmentCenter;
        if(i==0)
        {
            view.sd_layout
            .leftSpaceToView(self,gap1+w3)
            .topSpaceToView(self,0)
            .heightRatioToView(self,1)
            .widthIs(cellwidth);
            
            
            label.sd_layout
            .leftSpaceToView(view,0)
            .topSpaceToView(view,10)
            .widthIs(cellwidth)
            .heightRatioToView(view,0.5);
            
        }
        else
        {
            view.sd_layout
            .leftSpaceToView(self,gap1+w3+(gap2+cellwidth)*i)
            .topSpaceToView(self,0)
            .heightRatioToView(self,1)
            .widthIs(cellwidth);
            
            label.sd_layout
            .leftSpaceToView(view,0)
            .topSpaceToView(view,10)
            .widthIs(cellwidth)
            .heightRatioToView(view,0.5);
        }
    }
    
}
@end

