//
//  EditStoryTableViewCell.m
//  AnyMap
//
//  Created by hwl on 2019/10/26.
//  Copyright © 2019 hwl. All rights reserved.
//

#import "EditStoryTableViewCell.h"
#import <Masonry.h>


@interface EditStoryTableViewCell()<UITextViewDelegate>

@end
@implementation EditStoryTableViewCell


#pragma mark -初始化Cell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.label = [[UILabel alloc] init];
        self.textview = [[PlaceholderTextView alloc] init];
        [self.contentView addSubview:self.label];
        [self.contentView addSubview:self.textview];
        [self setUpSubviews];
    }
    return self;
}

#pragma mark -布局子视图
-(void)setUpSubviews{
        
    //Label
    [self.label setFont:[UIFont systemFontOfSize:13]];
    [self.label setTextColor:[UIColor grayColor]];
    self.label.frame = CGRectMake(15,5,50,30);
    //Textview
    self.textview.font = [UIFont systemFontOfSize:16];
    self.textview.delegate = self;
    self.textview.scrollEnabled = NO;
    self.textview.showsVerticalScrollIndicator = NO;
    self.textview.showsHorizontalScrollIndicator = NO;
    
    //TextView--布局
    [self.textview mas_makeConstraints:^(MASConstraintMaker *make) {
               make.top.equalTo(self.contentView.mas_top).offset(35).priority(999);
               make.height.mas_greaterThanOrEqualTo(@(14)).priority(888);
               make.bottom.equalTo(self.contentView.mas_bottom).offset(-5).priority(777);
               make.left.equalTo(self.contentView.mas_left).offset(10);
               make.right.equalTo(self.contentView.mas_right).offset(-15);
           }];
        
}

#pragma mark -TextView Delegate
- (void)textViewDidChange:(UITextField *)textView {
    
    //高度自适应
    CGRect bounds = self.textview.bounds;
    // 计算 text view 的高度
    CGSize maxSize = CGSizeMake(bounds.size.width, CGFLOAT_MAX);
    CGSize newSize = [self.textview sizeThatFits:maxSize];
    bounds.size = newSize;
    textView.bounds = bounds;
    
    UITableView *tableView = [self tableView];
    
    //禁用刷新动画
    [UIView performWithoutAnimation:^{
            [tableView beginUpdates];
            [tableView endUpdates];
    }];
    
    //判断是否要hide placeholder
    if(textView.text.length==0)
    {
        self.textview.placeholder.hidden = NO;
    }
    else
    {
        self.textview.placeholder.hidden = YES;
    }
    
}

#pragma mark -获取父视图Tableview
- (UITableView *)tableView{

    UIView *tableView = self.superview;
    while (![tableView isKindOfClass:[UITableView class]] && tableView) {
        tableView = tableView.superview;
    }
    return (UITableView *)tableView;
}

@end
