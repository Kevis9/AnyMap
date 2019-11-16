//
//  SlideScrollView.m
//  SlideScrollViewDemo
//
//  Created by 刘继新 on 2018/10/22.
//  Copyright © 2018 Topstech. All rights reserved.
//

#import "BottomSlideView.h"
#import "UIView+Size.h"

@interface BottomSlideView ()<UISearchBarDelegate>
{
    BOOL _scrollDecelerat; // 定义scroll是否需要减速缓冲运动，如果为false则手指离开后滚动会立即停止
}

@end

@implementation BottomSlideView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
    }
    return self;
}

- (void)initViews {
    
    self.top = SMALL_TOP;
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.shadeView];

    // shadow
    CALayer *shadowLayer0 = [[CALayer alloc] init];
    shadowLayer0.frame = self.bounds;
    shadowLayer0.shadowColor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.3f].CGColor;
    shadowLayer0.shadowOpacity = 1;
    shadowLayer0.shadowOffset = CGSizeMake(0, 0);
    shadowLayer0.shadowRadius = 5;
    CGFloat shadowSize0 = -1;
    CGRect shadowSpreadRect0 = CGRectMake(-shadowSize0, -shadowSize0, self.bounds.size.width+shadowSize0*2, self.bounds.size.height+shadowSize0*2);
    CGFloat shadowSpreadRadius0 =  self.layer.cornerRadius == 0 ? 0 : self.layer.cornerRadius+shadowSize0;
    UIBezierPath *shadowPath0 = [UIBezierPath bezierPathWithRoundedRect:shadowSpreadRect0 cornerRadius:shadowSpreadRadius0];
    shadowLayer0.shadowPath = shadowPath0.CGPath;
    [self.layer addSublayer:shadowLayer0];
    
    // background
    UIToolbar *backgroundView = [[UIToolbar alloc] initWithFrame:self.bounds];
    [self addSubview:backgroundView];
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                               byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight
                                                     cornerRadii:CGSizeMake(12, 12)];
    CAShapeLayer *maskLayer = [CAShapeLayer new];
    maskLayer.frame = backgroundView.bounds;
    maskLayer.path = path.CGPath;
    backgroundView.layer.mask = maskLayer;
     
    UIView *iconView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 5)];
    iconView.top = 6;
    iconView.centerX = self.width/2;
    iconView.backgroundColor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.1f];
    iconView.layer.cornerRadius = 2.5;
    [self addSubview:iconView];
    
    //[self addSubview:self.searchBar];
    [self addSubview:self.tableView];
    
    //监听键盘事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}

#pragma mark - 键盘事件
//当keyboard显示的时候出现
- (void)keyboardWillShow:(NSNotification *)info{
    //改变tableview的inset
    CGRect keyboardBounds = [[[info userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.tableView.contentInset = UIEdgeInsetsMake(self.tableView.contentInset.top,0, keyboardBounds.size.height+150, 0);
}

- (void)keyboardWillHide:(NSNotification *)info{
    
    self.tableView.contentInset = UIEdgeInsetsMake(self.tableView.contentInset.top, 0,150,0);
}

#pragma mark - TableView

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offSetY = scrollView.contentOffset.y;
    if ((offSetY <= 0 || self.isSizeFull == NO) && scrollView.tracking) {
        // 使scrollView滚动偏移无效
        // 注意，如果有contentInset，记得加上contentInset.top
        scrollView.contentOffset = CGPointMake(0, 0);
    } else {
        _scrollDecelerat = YES;
        scrollView.showsVerticalScrollIndicator = YES;
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if (NO == _scrollDecelerat) {
        // 禁止惯性滚动
        targetContentOffset->x = scrollView.contentOffset.x;
        targetContentOffset->y = scrollView.contentOffset.y;
    }
}

#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [self setSizeState:SlideScrollViewStateFull];
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
    [self setSizeState:SlideScrollViewStateSmall];
}

#pragma mark - Event

// 核心函数：手势处理
- (void)panGestureHandle:(UIPanGestureRecognizer *)tap {
    static CGPoint startPoint;
    static CGPoint viewPoint;
    static BOOL isBegan;
    CGPoint endPoint;
    if ((self.tableView.contentOffset.y > 0 && self.sizeState == SlideScrollViewStateFull)
        || self.top < FULL_TOP) {
        isBegan = NO;
        [self panGestureEndWithViewPoint:viewPoint];
        return;
    }
    _scrollDecelerat = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    if (tap.state == UIGestureRecognizerStateBegan || isBegan == NO) {
        isBegan = YES;
        startPoint = [tap locationInView:self.superview];
        viewPoint = self.origin;
    }
    switch (tap.state) {
        case UIGestureRecognizerStateChanged: {
            endPoint = [tap locationInView:self.superview];
            CGFloat toPointY = viewPoint.y + (endPoint.y - startPoint.y);
            self.top = toPointY;
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed: {
            isBegan = NO;
            [self panGestureEndWithViewPoint:viewPoint];
        }
        default:
            break;
    }
}

- (void)panGestureEndWithViewPoint:(CGPoint)point {
    CGFloat change = point.y - self.top;
    BOOL isSmall = self.sizeState == SlideScrollViewStateSmall;
    BOOL isChange = isSmall ? (change > CHANGE_MINI) : (change < -CHANGE_MINI);
    if (isChange) {
        if (self.sizeState == SlideScrollViewStateSmall) {
            self.sizeState = SlideScrollViewStateFull;
        } else {
            //收起键盘
            [self endEditing:YES];
            self.sizeState = SlideScrollViewStateSmall;
        }
    } else {
        [self setSizeState:self.sizeState];
    }
}

- (void)setSizeState:(SlideScrollViewState)sizeState {
    _sizeState = sizeState;
    if (sizeState == SlideScrollViewStateSmall) {
        [self viewAnimatedToPoint:CGPointMake(0, SMALL_TOP) shadeAlpha:0];
        [self.searchBar resignFirstResponder];
        [self.searchBar setShowsCancelButton:NO animated:YES];
    } else {
        [self viewAnimatedToPoint:CGPointMake(0, FULL_TOP) shadeAlpha:0.2];
    }
}

- (void)viewAnimatedToPoint:(CGPoint)point shadeAlpha:(CGFloat)alpha  {
    [UIView animateWithDuration:0.55
                          delay:0
         usingSpringWithDamping:0.85
          initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveEaseOut animations:^{
                            self.origin = point;
                            self.shadeView.alpha = alpha;
                        } completion:nil];
}

- (BOOL)isSizeFull {
    return self.top <= FULL_TOP;
}

#pragma mark - Lazy

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]init];
        _tableView.frame = CGRectMake(0, 0, self.width, self.height-60);
        _tableView.top = 60;
        _tableView.backgroundColor = [UIColor clearColor];
        [_tableView.panGestureRecognizer addTarget:self action:@selector(panGestureHandle:)];
        
        //设置tableview的初始Inset
        _tableView.contentInset = UIEdgeInsetsMake(_tableView.contentInset.top,0, 300, 0);
                
        //去掉底部空余部分
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor redColor];
        [_tableView setTableFooterView:view];
        
        
    }
    return _tableView;
}

- (UISearchBar *)searchBar {
    if (_searchBar == nil) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(5, 10, self.width - 10, 50)];
        _searchBar.searchBarStyle = UISearchBarStyleMinimal;
        _searchBar.delegate = self;
        [_searchBar addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureHandle:)]];
    }
    return _searchBar;
}

- (UIView *)shadeView {
    if (_shadeView == nil) {
        _shadeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*2)];
        _shadeView.top = -SCREEN_HEIGHT;
        _shadeView.backgroundColor = [UIColor blackColor];
        _shadeView.alpha = 0;
    }
    return _shadeView;
}

@end
