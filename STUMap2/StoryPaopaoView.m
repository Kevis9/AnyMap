//
//  StoryPaopaoView.m
//  STUMap2
//
//  Created by hwl on 2019/10/27.
//  Copyright © 2019 hwl. All rights reserved.
//

#import "StoryPaopaoView.h"

#define kPortraitMargin     5
#define kPortraitWidth      50
#define kPortraitHeight     50
#define kTitleWidth         120
#define kTitleHeight        20
#define kArrorHeight 0
@implementation StoryPaopaoView

#pragma mark - draw rect

- (void)drawRect:(CGRect)rect
{
[self drawInContext:UIGraphicsGetCurrentContext()];

self.layer.shadowColor = [[UIColor blackColor] CGColor];
self.layer.shadowOpacity = 1.0;
self.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
}

- (void)drawInContext:(CGContextRef)context
{
CGContextSetLineWidth(context, 2.0);
CGContextSetFillColorWithColor(context, [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.8].CGColor);

    [self getDrawPath:context];
    CGContextFillPath(context);
}
- (void)getDrawPath:(CGContextRef)context
{
    CGRect rrect = self.bounds;
    CGFloat radius = 6.0;
    CGFloat minx = CGRectGetMinX(rrect),
    midx = CGRectGetMidX(rrect),
    maxx = CGRectGetMaxX(rrect);
    CGFloat miny = CGRectGetMinY(rrect),
    maxy = CGRectGetMaxY(rrect)-kArrorHeight;

    CGContextMoveToPoint(context, midx+kArrorHeight, maxy);
    CGContextAddLineToPoint(context,midx, maxy+kArrorHeight);
    CGContextAddLineToPoint(context,midx-kArrorHeight, maxy);

    CGContextAddArcToPoint(context, minx, maxy, minx, miny, radius);
    CGContextAddArcToPoint(context, minx, minx, maxx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, maxx, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextClosePath(context);
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews
{
    

    self.titleTextView = [[UITextView alloc] initWithFrame:CGRectMake(kPortraitMargin * 2 + kPortraitWidth, kPortraitMargin, kTitleWidth, kTitleHeight)];
    self.titleTextView.font = [UIFont boldSystemFontOfSize:14];
    self.titleTextView.textColor = [UIColor whiteColor];
    self.titleTextView.backgroundColor = [UIColor blackColor];
    
    [self addSubview:self.titleTextView];

    
    self.storyTextView = [[UITextView alloc] initWithFrame:CGRectMake(kPortraitMargin * 2 + kPortraitWidth, kPortraitMargin * 2 + kTitleHeight, kTitleWidth, kTitleHeight)];
    self.storyTextView.font = [UIFont systemFontOfSize:12];
    self.storyTextView.textColor = [UIColor whiteColor];
    self.storyTextView.backgroundColor = [UIColor blackColor];
    [self addSubview:self.storyTextView];
}

@end
