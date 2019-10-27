//
//  SCEditHomeworkDetailTableViewCell.m
//  stuclass
//
//  Created by hwl on 2019/10/14.
//  Copyright © 2019 JunhaoWang. All rights reserved.
//

#import "SCEditHomeworkTextTableViewCell.h"
#import <Masonry.h>

@interface SCEditHomeworkTextTableViewCell()<UITextViewDelegate>


@end
@implementation SCEditHomeworkTextTableViewCell


#pragma mark -初始化Cell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.textview = [[PlaceholderTextView alloc] init];
        [self.contentView addSubview:self.textview];
        [self setUpSubviews];
    }
    return self;
}

#pragma mark -布局子视图
-(void)setUpSubviews{
        
    
    //TextField
    self.textview.font = [UIFont systemFontOfSize:16];
    self.textview.delegate = self;
    self.textview.scrollEnabled = NO;
    self.textview.showsVerticalScrollIndicator = NO;
    self.textview.showsHorizontalScrollIndicator = NO;
    //设置textview的约束,实现自定义高度,布局
    [self.textview mas_makeConstraints:^(MASConstraintMaker *make) {
               make.top.equalTo(self.contentView.mas_top).offset(5).priority(999);
               make.height.mas_greaterThanOrEqualTo(@(14)).priority(888);
               make.bottom.equalTo(self.contentView.mas_bottom).offset(-5).priority(777);
               make.left.equalTo(self.contentView.mas_left).offset(5);
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
