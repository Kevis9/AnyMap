//
//  SlideScrollView.m
//  SlideScrollViewDemo
//
//  Created by 刘继新 on 2018/10/22.
//  Copyright © 2018 Topstech. All rights reserved.
//
//

#import "AMStoryBottomSlideView.h"
#import "UIView+Size.h"
#import "EditStoryTableViewCell.h"
#import <SDAutoLayout.h>
#import <Masonry.h>


@interface AMStoryBottomSlideView ()<UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIButton *addPointbtn;    //保存故事点

@property (nonatomic, strong) UIButton *deletePointbtn; //删除故事点

@property (nonatomic, strong) UIButton *uploadPointbtn; //发布故事点

@property (nonatomic, strong) UIButton *editPointbtn;   //编辑故事点,防止重复添加

@property (nonatomic, strong) UITableViewCell *tmpCell;     //暂时代表放置图片的cell

@property (nonatomic, strong) UIButton *tmpBtn;             //暂时代表图片添加按钮
@end

@implementation AMStoryBottomSlideView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
    }
    return self;
}

- (void)initViews {
    
    //调用父类方法
    [super initViews];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //初始图片数量为0
    self.numOfImgs = 0;
    
    [self.tableView registerClass:[EditStoryTableViewCell class] forCellReuseIdentifier:@"cellWithStory"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellWithBtn"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellWithImg"];
    
    
//    //监听Textview是否发生变化，若变化则应变为Full模式
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AdjustHeightFull) name:@"TextViewChange" object:nil];
    
    
}


//#pragma mark - TextView 调整self高度
//-(void)AdjustHeightFull{
//    [self setSizeState:SlideScrollViewStateFull];
//}

#pragma mark - TableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
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
        [cell.contentView addSubview:self.uploadPointbtn];
        
        //布局--"地址"
        grayLabel.sd_layout
        .leftSpaceToView(cell.contentView,15)
        .topSpaceToView(cell.contentView,10)
        .widthIs(30)
        .heightIs(10);
        
        //布局--详细地址Label
        //[self.addressLabel setText:@"暂无位置信息"];
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
        
        //布局--保存btn
        self.addPointbtn.sd_layout
        .leftSpaceToView(self.editPointbtn,10)
        .topSpaceToView(self.addressLabel,10)
        .widthIs((self.frame.size.width-50)/3)
        .heightIs(50);
        
        //布局--发布btn
        self.uploadPointbtn.sd_layout
        .leftSpaceToView(self.addPointbtn,10)
        .topSpaceToView(self.addressLabel,10)
        .widthIs((self.frame.size.width-50)/3)
        .heightIs(50);
                        
        //布局--设置当前cell的约束
        cell.autoresizesSubviews = YES;
        [grayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.contentView.mas_top).offset(10).priority(999);
            make.bottom.equalTo(cell.contentView.mas_bottom).offset(-130);
         }];

        return cell;
        
    }
    else if(indexPath.row==1)
    {
        
       EditStoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellWithStory"];
        
       cell.selectionStyle = UITableViewCellSelectionStyleNone;
       
        
       [cell.label setText:@"标题"];
       
       self.TitleTextView = cell.textview;
       self.TitleTextView.font = [UIFont boldSystemFontOfSize:18];
        
       //去掉水平分割线
       cell.separatorInset = UIEdgeInsetsMake(0,0,0,cell.bounds.size.width+100);
       return cell;
       
    }
    else if(indexPath.row==2)
    {
        
        EditStoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellWithStory"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        [cell.textview.placeholder setText:@"写下你的故事~"];
        [cell.label setText:@"故事"];
        self.StoryTextView = cell.textview;
        return cell;
    }
    else if(indexPath.row==3)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellWithImg"];
        
        //设置不可点击
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 112, 120)];
        btn.backgroundColor = [UIColor whiteColor];
        [btn setImage:[UIImage imageNamed:@"添加"] forState:UIControlStateNormal];
        btn.layer.cornerRadius = 8.0f;
        [btn addTarget:self action:@selector(addImgs:) forControlEvents:UIControlEventTouchUpInside];
      
        [cell.contentView addSubview:btn];
        
        //btn布局
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.contentView.mas_top).offset(15).priority(999);
            make.height.mas_greaterThanOrEqualTo(120).priority(888);
            make.bottom.equalTo(cell.contentView.mas_bottom).offset(-15).priority(777);
            make.left.equalTo(cell.contentView.mas_left).offset(22);
            make.right.equalTo(cell.contentView.mas_right).offset(-280);
        }];
        
        //给btn添加虚线
        CAShapeLayer *layer = [[CAShapeLayer alloc] init];
        layer.frame = CGRectMake(0,0,btn.frame.size.width,btn.frame.size.height);
        layer.backgroundColor = [UIColor clearColor].CGColor;

        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:layer.frame cornerRadius:8];
        layer.path = path.CGPath;
        layer.lineWidth = 2.0f;
        layer.lineDashPattern = @[@5, @5];
        layer.fillColor = [UIColor clearColor].CGColor;
        //虚线的颜色
        layer.strokeColor = [UIColor colorWithRed:171/255.0 green:170/255.0 blue:170/255.0 alpha:1].CGColor;
        [btn.layer addSublayer:layer];
        self.tmpCell = cell;
        
        return cell;
    }
    return nil;
}

#pragma mark - 添加图片btn
//添加图片
- (void)addImgs:(UIButton*)btn{
    
    self.tmpBtn = btn;
    [self.delegate pickImgFinishedHandle:^(NSArray * _Nonnull imgs) {

        if(self.numOfImgs == 0)
        {
            self.firstImg = imgs[0]; //存储九宫格的第一张图
        }
        //添加完图片,获得新的图片,对Cell进行布局
        for(int i=0;i<[imgs count];i++)
        {
            //创建UIimageview
            UIImageView *imgView = [[UIImageView alloc] initWithImage:imgs[i]];
            imgView.layer.cornerRadius = 8;
            [self.tmpCell addSubview:imgView];
            //当前图片所在的位置
            NSInteger index = self.numOfImgs+i;
            [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                //根据当前的index来计算其布局约束
                make.top.equalTo(self.tmpCell.contentView.mas_top).offset((index/3)*129+15);
            make.bottom.equalTo(self.tmpCell.contentView.mas_bottom).offset(-(2-(index/3)*129+15));
                make.left.equalTo(self.tmpCell.contentView.mas_left).offset((index%3)*129+22);
              make.right.equalTo(self.tmpCell.contentView.mas_right).offset(-(2-(index%3)*129+22));

                //布置图片的大小
                make.height.lessThanOrEqualTo(@120);
                make.width.lessThanOrEqualTo(@112);
            }];
        }//for
        // 更新图片数量
        self.numOfImgs += [imgs count];
        if(self.numOfImgs>=9)
        {
            self.tmpBtn.hidden = YES;
        }
        else{
            self.tmpBtn = btn;
            [self updateConstraints];
        }

        [self.tableView beginUpdates];
        [self.tableView endUpdates];
    }];
    
}

//更新btn约束
//图片添加完成之后，需要更新虚线btn的约束，从而实现cell高度自适应
- (void)updateConstraints{
    NSInteger index = self.numOfImgs;
    //更新btn布局
    [self.tmpBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tmpCell.contentView.mas_top).offset((index/3)*129+15);
    make.bottom.equalTo(self.tmpCell.contentView.mas_bottom).offset(-15);

        make.left.equalTo(self.tmpCell.contentView.mas_left).offset((index%3)*129+22);
      make.right.equalTo(self.tmpCell.contentView.mas_right).offset(-((2-index%3)*129+22));
        make.height.greaterThanOrEqualTo(@120);
        make.width.lessThanOrEqualTo(@112);
    }];

    [super updateConstraints];
}


#pragma mark - TableView Delegate

//还有一些delegate的方法在父类中实现

#pragma mark -添加故事点

- (void) addPoint:(UIButton*)btn{
    
    if([self.delegate respondsToSelector:@selector(addStoryPoint:)])
        [self.delegate addStoryPoint:self];
    
}


#pragma mark - Lazy loading

- (UIButton *)addPointbtn {
    if(_addPointbtn == nil){
        //布局放在cell中布局
        _addPointbtn = [[UIButton alloc] init];
        _addPointbtn.backgroundColor =[UIColor colorWithRed:233/255.0 green:230/255.0 blue:223/255.0 alpha:0.5];
        [_addPointbtn setTitle:@"保存" forState:UIControlStateNormal];
        
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

- (UIButton *)uploadPointbtn{
    if(_uploadPointbtn == nil)
    {
        
        //布局放在cell中
        _uploadPointbtn = [[UIButton alloc] init];
        _uploadPointbtn.backgroundColor = [UIColor colorWithRed:233/255.0 green:230/255.0 blue:223/255.0 alpha:0.5];
        [_uploadPointbtn setTitle:@"发布" forState:UIControlStateNormal];
        //设置字体颜色
        [_uploadPointbtn setTitleColor:[UIColor colorWithRed:233/255.0 green:230/255.0 blue:223/255.0 alpha:1] forState:UIControlStateNormal];
        [_uploadPointbtn setTitleColor:[UIColor colorWithRed:12/255.0 green:95/255.0 blue:250/255.0 alpha:1] forState:UIControlStateNormal];
        
        _uploadPointbtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _uploadPointbtn.layer.cornerRadius = 8;
        
    }
    return _uploadPointbtn;
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

