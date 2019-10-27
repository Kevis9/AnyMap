//
//  ViewController.m
//  ColletionView-Demo
//
//  Created by hwl on 2019/9/23.
//  Copyright © 2019 stumap. All rights reserved.
//

#import "ViewController.h"
#import "ClassViewLayout.h"
#import "SDAutoLayout.h"
#import "TopView.h"
#import "HeaderView.h"
#import "define.h"
#import "Classcell.h"
#import "SupplementaryView.h"
#define WIDTH [[UIScreen mainScreen] bounds].size.width
#define cell_w  (([[UIScreen mainScreen] bounds].size.width-w3-gap1-6*gap2)/7)

@interface ViewController ()<UICollectionViewDataSource,
                            UICollectionViewDelegate,
                            UIGestureRecognizerDelegate>

@property(nonatomic,strong) TopView* topview;
@property(nonatomic,strong) HeaderView *header;
@property(nonatomic,strong) UICollectionView *colletionview;
@property(nonatomic,strong) ClassViewLayout *layout;
@property(nonatomic,strong) UIView *tmpview;
@property(nonatomic,assign) CGPoint origin;
@end


@implementation ViewController

//懒加载tmpview
- (UIView *)tmpview{
    if(_tmpview)
    {
        return _tmpview;
    }
    else
    {
        
        _tmpview = [[UIView alloc] init];
        _tmpview.backgroundColor = [UIColor grayColor];
        _tmpview.layer.cornerRadius = 7;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handletap2:)];
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlepan:)];
        
        [_tmpview addGestureRecognizer:tap];
        [_tmpview addGestureRecognizer:pan];
        return _tmpview;
    };
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self SetUpSubviews];
    [self SetUpGestures];//做好手势处理
    
    
    
}

- (void)SetUpGestures{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handletap:)];
    [self.colletionview addGestureRecognizer:tap];
    
}

- (void)handlepan:(UIPanGestureRecognizer *)pan{
    
    //获取偏移量
    // 返回的是相对于最原始的手指的偏移量
    // CGPoint transP = [pan translationInView:self.tmpview];
//    // 移动图片控件
//    self.tmpview.transform = CGAffineTransformTranslate(self.tmpview.transform, transP.x, transP.y);
//    // 复位,表示相对上一次
//    [pan setTranslation:CGPointZero inView:self.tmpview];
    //如果是往下移动,坐标不变,高度增加
    CGPoint position = [pan locationInView:self.colletionview];
    if([pan velocityInView:self.tmpview].y>0)
    {
        CGRect tmp = self.tmpview.frame;
        if(position.y-tmp.origin.y<=tmp.size.height)
        {
            if(position.y-tmp.origin.y > w4 && position.y < self.origin.y + w4)
            {
                tmp.origin.y +=w4+gap2;
                tmp.size.height -= w4+gap2;
                self.tmpview.frame = tmp;
            }
            return;
        }
        NSLog(@"3");
        //偏移量要大于当前高度
        tmp.size.height += w4+gap2;
        self.tmpview.frame = tmp;
    }
    else
    {
        //y坐标增加,高度增加
        CGRect tmp = self.tmpview.frame;
        if(position.y>=tmp.origin.y)
        {
            if(tmp.size.height+tmp.origin.y-position.y > w4 && position.y > self.origin.y)
            {
                tmp.size.height -= (w4+gap2);
                self.tmpview.frame = tmp;
            }
            return;
        }
        NSLog(@"4");
        //偏移量要大于当前高度
        tmp.size.height += w4 + gap2;
        tmp.origin.y -= (w4+gap2);
        self.tmpview.frame = tmp;
    }
}

- (void)handletap2:(UITapGestureRecognizer *)tap{
    NSLog(@"2");
}

- (void)handletap:(UITapGestureRecognizer *) tap{
    
    NSLog(@"sss");
//    [self.colletionview reloadData];
    //添加一个新的格子
    //首先判断视图是否已经存在
    if(![self.tmpview isDescendantOfView:self.colletionview])
        [self.colletionview addSubview:self.tmpview];
    //判断点击的坐标位置
    CGPoint point = [tap locationInView:self.colletionview];
    if(point.x<w3) return;//考虑到旁边的时间栏
    NSInteger col = ((NSInteger)point.x-w3)/(NSInteger)(cell_w+gap2)+1;
    NSInteger row = (NSInteger)point.y/(NSInteger)(w4+gap2)+1;
    NSLog(@"周%ld",col);
    NSLog(@"时间%ld",row);
    self.tmpview.frame = CGRectMake(w3+gap1+(col-1)*(gap2+cell_w), gap1+(row-1)*(gap2+w4), cell_w,w4);
    self.origin = self.tmpview.frame.origin;
    NSLog(@"1");

}

- (void)SetUpSubviews{
    
    self.topview = [[TopView alloc] init];
    _topview.frame = CGRectMake(0, 0, WIDTH, w1);
    _topview.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.topview];

    self.header = [[HeaderView alloc] init];
    [self.view addSubview:self.header];
    _header.sd_layout
    .widthIs(WIDTH)
    .heightIs(w2)
    .leftSpaceToView(self.view,0)
    .topSpaceToView(self.view,w1);
    
    
    self.layout = [[ClassViewLayout alloc] init];
    
    self.colletionview = [[UICollectionView alloc] initWithFrame:CGRectMake(0,w1+w2,WIDTH,self.view.frame.size.height-(w1+w2)) collectionViewLayout:self.layout];
    self.colletionview.backgroundColor = [UIColor whiteColor];
    self.colletionview.dataSource = self;
    self.colletionview.bounces = NO;
    [self.colletionview registerClass:[Classcell class] forCellWithReuseIdentifier:@"classcell"];
    [self.colletionview registerClass:[SupplementaryView class] forSupplementaryViewOfKind:@"ClassNum" withReuseIdentifier:@"classnum"];
    
    [self.view addSubview:self.colletionview];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    Classcell *classcell = [collectionView dequeueReusableCellWithReuseIdentifier:@"classcell" forIndexPath:indexPath];
    
    
    return classcell;
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    SupplementaryView *sv = [collectionView dequeueReusableSupplementaryViewOfKind:@"ClassNum" withReuseIdentifier:@"classnum" forIndexPath:indexPath];
    
    [sv Setupwithnum:indexPath.row+1];
    return sv;
    
}

@end
