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

    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(65,5,50,20)];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:10];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.numberOfLines = 1;
    self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    [self addSubview:self.titleLabel];

    self.storyLabel = [[UILabel alloc] initWithFrame:CGRectMake(65,25,50,40)];
    self.storyLabel.font = [UIFont systemFontOfSize:8];
    self.storyLabel.textColor = [UIColor whiteColor];
    self.storyLabel.backgroundColor = [UIColor clearColor];
    self.storyLabel.numberOfLines=0;
    self.storyLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self addSubview:self.storyLabel];

    self.storyImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"标注"]];
    self.storyImgView.frame = CGRectMake(5,5,60,60);
    [self addSubview:self.storyImgView];
    
}

@end
