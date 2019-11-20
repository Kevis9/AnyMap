//
//  AMStoryHTMLTableViewCell.m
//  AnyMap
//
//  Created by hwl on 2019/11/20.
//  Copyright © 2019 hwl. All rights reserved.
//

#import "AMStoryHTMLTableViewCell.h"
#import <WebKit/WebKit.h>
#import <Masonry.h>
@interface AMStoryHTMLTableViewCell()

@property (nonatomic,strong)UILabel *showStoryisEmptyLabel;     //用于显示有无故事
@property (nonatomic,strong)UILabel *showLabel;                 //显示"故事"字段
@property (nonatomic,strong)WKWebView *webView;                 //展示故事主体
@property (nonatomic,copy)NSString *htmlStr;                    //htmlstring
@end

@implementation AMStoryHTMLTableViewCell



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    //使用注册的方式，cell的加载就必须实现这个方法
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpSubViews];
    }
    return self;
}

- (void)setUpSubViews{
    
    [self.contentView addSubview:self.showLabel];
    [self.contentView addSubview:self.showStoryisEmptyLabel];
    [self.contentView addSubview:self.webView];
    
    [self.showStoryisEmptyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //居中
        make.top.equalTo(self.contentView.mas_top).offset(45);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
        make.centerX.equalTo(self.contentView.mas_centerX);
    }];
    
    //设置webview的布局约束 实现cell高度自适应
//    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.contentView.mas_top).offset(5);
//        make.left.equalTo(self.contentView.mas_left).offset(0);
//        make.right.equalTo(self.contentView.mas_right).offset(0);
//        make.bottom.equalTo(self.contentView.mas_bottom).offset(0);
//        make.width.greaterThanOrEqualTo(@([UIScreen mainScreen].bounds.size.width));
//    }];
    
}

#pragma mark - Lazy loading
- (UILabel *)showLabel{
    if(!_showLabel)
    {
        _showLabel = [[UILabel alloc] init];
        [_showLabel setText:@"故事"];
        [_showLabel setFont:[UIFont systemFontOfSize:13]];
        [_showLabel setTextColor:[UIColor grayColor]];
        _showLabel.frame = CGRectMake(15,5,50,30);
    }
    return _showLabel;
}

- (UILabel *)showStoryisEmptyLabel{
    if(!_showStoryisEmptyLabel)
    {
        _showStoryisEmptyLabel = [[UILabel alloc] init];
        [_showStoryisEmptyLabel setText:@"赶快写下故事吧~~"];
        [_showStoryisEmptyLabel setFont:[UIFont systemFontOfSize:13]];
        [_showStoryisEmptyLabel setTextColor:[UIColor grayColor]];
        _showStoryisEmptyLabel.textAlignment = NSTextAlignmentCenter;
        [_showStoryisEmptyLabel sizeToFit];
        if(_htmlStr)
            _showStoryisEmptyLabel.hidden = YES;
        
    }
    return _showStoryisEmptyLabel;
}

- (WKWebView *)webView{
    if(!_webView)
    {
        _webView = [[WKWebView alloc] init];
    
    }
    return _webView;
}

@end
