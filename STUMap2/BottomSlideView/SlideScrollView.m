//
//  SlideScrollView.m
//  SlideScrollViewDemo
//
//  Created by 刘继新 on 2018/10/22.
//  Copyright © 2018 Topstech. All rights reserved.
//

#import "SlideScrollView.h"
#import "UIView+Size.h"
#import "EditStoryTableViewCell.h"
#import <SDAutoLayout.h>
#import <Masonry.h>

#define FULL_TOP (STATUS_BAR_HEIGHT + 30.0) // 全尺寸模式下view的y坐标
#define SMALL_TOP (SCREEN_HEIGHT - 200.0)   // 缩小模式下view的y坐标
#define CHANGE_MINI 50.0f                   // 切换状态需要手势移动的距离

@interface SlideScrollView ()<UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>
{
    BOOL _scrollDecelerat; // 定义scroll是否需要减速缓冲运动，如果为false则手指离开后滚动会立即停止
}
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView *shadeView;

@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic, strong) UIButton *addPointbtn;    //添加故事点

@property (nonatomic, strong) UIButton *deletePointbtn; //删除故事点

@property (nonatomic, strong) UIButton *editPointbtn;   //编辑故事点,防止重复添加

@property (nonatomic, strong) UILabel *addressLabel;         //显示具体地点的Label

@end

@implementation SlideScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
    }
    return self;
}

- (void)initViews {
    self.top = SMALL_TOP;
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.shadeView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AdjustHeightFull) name:@"TextViewChange" object:nil];
    // shadow
    CALayer *shadowLayer0 = [[CALayer alloc] init];
    shadowLayer0.frame = self.bounds;
    shadowLayer0.shadowColor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.3f].CGColor;
//    shadowLayer0.shadowColor = [UIColor whiteColor].CGColor;
    
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
    
    
    [self.tableView registerClass:[EditStoryTableViewCell class] forCellReuseIdentifier:@"cellWithStory"];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellWithBtn"];
    
    //[self addSubview:self.searchBar];
    [self addSubview:self.tableView];
    [self addSubview:self.addPointbtn];
    
}

#pragma mark - TextView 调整self高度
-(void)AdjustHeightFull{
    [self setSizeState:SlideScrollViewStateFull];
}

#pragma mark - TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row==0){
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellWithBtn"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *grayLabel = [[UILabel alloc] init];
        grayLabel.textColor = [UIColor grayColor];
        grayLabel.font = [UIFont systemFontOfSize:13];
        [grayLabel setText:@"地址"];
        
        //添加子控件
        [cell.contentView addSubview:grayLabel];
        [cell.contentView addSubview:self.addressLabel];
        [cell.contentView addSubview:self.editPointbtn];
        [cell.contentView addSubview:self.addPointbtn];
        [cell.contentView addSubview:self.deletePointbtn];
        
        //布局--"地址"
        grayLabel.sd_layout
        .leftSpaceToView(cell.contentView,15)
        .topSpaceToView(cell.contentView,10)
        .widthIs(30)
        .heightIs(10);
        
        //布局--详细地址Label,height都是试出来的
        [self.addressLabel setText:@"杭州市........hwlwlwlwlwllwlw"];
        self.addressLabel.sd_layout
        .leftSpaceToView(cell.contentView,15)
        .topSpaceToView(grayLabel,5)
        .widthIs(cell.frame.size.width)
        .heightIs(50);
        
        //布局--编辑btn
        self.editPointbtn.sd_layout
        .leftSpaceToView(cell.contentView,15)
        .topSpaceToView(self.addressLabel,10)
        .widthIs((self.frame.size.width-50)/3)
        .heightIs(50);
        
        //布局--添加btn
        self.addPointbtn.sd_layout
        .leftSpaceToView(self.editPointbtn,10)
        .topSpaceToView(self.addressLabel,10)
        .widthIs((self.frame.size.width-50)/3)
        .heightIs(50);
        
        //布局--删除btn
        self.deletePointbtn.sd_layout
        .leftSpaceToView(self.addPointbtn,10)
        .topSpaceToView(self.addressLabel,10)
        .widthIs((self.frame.size.width-50)/3)
        .heightIs(50);
        
        //布局--设置当前cell的约束
        cell.autoresizesSubviews = YES;
        [grayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.contentView.mas_top).offset(10).priority(999);
            make.bottom.equalTo(cell.contentView.mas_bottom).offset(-125);
         }];
//        [self.editPointbtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.equalTo(cell.contentView.mas_bottom).offset(-10).priority(999);
//        }];
        return cell;
    }
    else if(indexPath.row==1)
    {
        
       EditStoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellWithStory"];
        
       cell.selectionStyle = UITableViewCellSelectionStyleNone;
       [cell.textview.placeholder setText:@"标题"];
       self.TitleTextView = cell.textview;
        return cell;
       
    }
    else if(indexPath.row==2)
    {
        
        EditStoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellWithStory"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.textview.placeholder setText:@"写下你的故事~"];
        self.StoryTextView = cell.textview;
        return cell;
    }
    
    return nil;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if(indexPath.row==0)
//        return 150;
//    else
//    {
//        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//        return cell.frame.size.height;
//    }
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

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

#pragma mark -添加故事点

- (void) addPoint:(UIButton*)btn{
    
    if([self.delegate respondsToSelector:@selector(addStoryPoint:)])
        [self.delegate addStoryPoint:self];
    
}
#pragma mark - Lazy

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]init];
        _tableView.frame = CGRectMake(0, 0, self.width, self.height-60);
        _tableView.top = 60;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        [_tableView setTableFooterView:view];
        //_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView.panGestureRecognizer addTarget:self action:@selector(panGestureHandle:)];
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

- (UIButton *)addPointbtn {
    if(_addPointbtn == nil){
        //布局放在cell中布局
        _addPointbtn = [[UIButton alloc] init];
        _addPointbtn.backgroundColor =[UIColor colorWithRed:233/255.0 green:230/255.0 blue:223/255.0 alpha:0.5];
        [_addPointbtn setTitle:@"添加" forState:UIControlStateNormal];
        
        [_addPointbtn setTitleColor:[UIColor colorWithRed:12/255.0 green:95/255.0 blue:250/255.0 alpha:1] forState:UIControlStateNormal];
        
        [_addPointbtn addTarget:self action:@selector(addPoint:) forControlEvents:UIControlEventTouchDown];
        
        
        _addPointbtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _addPointbtn.layer.cornerRadius = 8;
    }
    return _addPointbtn;
}

- (UIButton *)deletePointbtn{
    if(_deletePointbtn == nil)
    {

        //布局放在cell中
        _deletePointbtn = [[UIButton alloc] init];
        _deletePointbtn.backgroundColor = [UIColor colorWithRed:233/255.0 green:230/255.0 blue:223/255.0 alpha:0.5];
        [_deletePointbtn setTitle:@"移除" forState:UIControlStateNormal];
        //设置字体颜色
        [_deletePointbtn setTitleColor:[UIColor colorWithRed:233/255.0 green:230/255.0 blue:223/255.0 alpha:1] forState:UIControlStateNormal];
        [_deletePointbtn setTitleColor:[UIColor colorWithRed:12/255.0 green:95/255.0 blue:250/255.0 alpha:1] forState:UIControlStateNormal];
        
        _deletePointbtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _deletePointbtn.layer.cornerRadius = 8;
    }
    return _deletePointbtn;
}

- (UIButton *)editPointbtn{
    //布局放在cell中
    if(_editPointbtn == nil){
        
        _editPointbtn = [[UIButton alloc] init];
        
        _editPointbtn.backgroundColor = [UIColor colorWithRed:233/255.0 green:230/255.0 blue:223/255.0 alpha:0.5];
        [_editPointbtn setTitleColor:[UIColor colorWithRed:12/255.0 green:95/255.0 blue:250/255.0 alpha:1] forState:UIControlStateNormal];
        [_editPointbtn setTitle:@"编辑" forState:UIControlStateNormal];
        _editPointbtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _editPointbtn.layer.cornerRadius = 8;
    }
    return _editPointbtn;
}

- (UILabel *)addressLabel{
    
    if(_addressLabel == nil){
        _addressLabel = [[UILabel alloc] init];
        _addressLabel.numberOfLines = 2;
        _addressLabel.lineBreakMode = NSLineBreakByCharWrapping;
        //设置粗体
        _addressLabel.font = [UIFont boldSystemFontOfSize:18];
    }
    return _addressLabel;
    
}
@end

